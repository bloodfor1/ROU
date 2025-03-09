---@class ChatMsgPack
---@field channel EChannel
---@field lineType EChatPrefabType
---@field subType EChannelSys
---@field content string
---@field Param
---@field isSelf boolean
---@field time string
---@field uid int64
---@field uidStr string @todo待整理 
---@field name string
---@field isFromChat boolean
---@field playerInfo playerInfo
---@field showInMainChat boolean
---@field showDanmu boolean
---@field isNpc boolean
---@field AudioObj
---@field isGuideHistoryMsg boolean
---@field stickers

---@module ModuleMgr.ChatMgr : ChatData
module("ModuleMgr.ChatMgr", package.seeall)

require "Event/EventConst"
require "Common/TimeMgr"
require "Data/Model/BagModel"

AwardExpReason = GameEnum.AwardExpReason
--事件
EventDispatcher = EventDispatcher.new()
local showTip = false
local currentTime = 0.0
local guildHistoryMsg = {}
local taskPhotoNextTime = nil
local waitChatShareRet = false--等待分享消息返回
---@type ChatData
local chatDataMgr = DataMgr:GetData("ChatData")
local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
---@type ModuleMgr.LuaStopWatchMgr
local l_luaStopWatchMgr = MgrMgr:GetMgr("LuaStopWatchMgr")
currentChannel = nil   --用于存储当前的聊天频道
local l_cacheChatMsgHandleTimer = nil
local l_canReceiveChatMsg = true
--- 祈福经验和祝福经验的缓存数据
--- 祈福经验和祝福经验的缓存数据
local cacheBasePrayExp = 0
local cacheJobPrayExp = 0
local cacheBaseBlessExp = 0
local cacheJobBlessExp = 0

--region -----------------------------生命周期-----------------------------
function OnInit()
    l_luaStopWatchMgr.Start(l_luaStopWatchMgr.ELuaStopWatchType.LastHandleChatTime)
    stopHandleCacheChatMsgTimer()
    gameEventMgr.Register(gameEventMgr.OnBagUpdate, _onItemUpdate)
    l_canReceiveChatMsg = true
end

function OnUnInit()
    chatDataMgr.HandleQuickTalkInfosOnLogout()
    stopHandleCacheChatMsgTimer()
    l_canReceiveChatMsg = false
    l_luaStopWatchMgr.End(l_luaStopWatchMgr.ELuaStopWatchType.LastHandleChatTime)
end

function OnLogout()
    StopTips()
    l_canReceiveChatMsg = false
    UIMgr:DeActiveUI(UI.CtrlNames.Chat)
    UIMgr:DeActiveUI(UI.CtrlNames.MainChat)
    guildHistoryMsg = nil
    stopHandleCacheChatMsgTimer()
end

function OnUpdate()
    if showTip then
        currentTime = currentTime + Time.deltaTime
        if currentTime > chatDataMgr.GetNoticeRollingCD() then
            SendTips()
            currentTime = 0
        end
    end
end
--endregion 生命周期

--region ---------------------性能测试----------------------
local l_perfomanceTestMsgTemplate = {}
local l_startStoreMsgTemplate = false
local l_simulateReceiveMsgTimer = nil
function StartStoreMsgPool()
    l_startStoreMsgTemplate = true
end
function EndStoreMsgPool()
    l_startStoreMsgTemplate = false
end
function ClearStoreMsgPool()
    l_perfomanceTestMsgTemplate = {}
end
function StartSimulateReceiveLargeMsg(msgCount, sendIntervalTime)
    local l_temCount = #l_perfomanceTestMsgTemplate
    if l_temCount < 1 then
        return
    end
    stopSimulateMsgTimer()
    l_simulateReceiveMsgTimer = Timer.New(function()
        SimulateReceiveMsg(msgCount, l_temCount)
    end, sendIntervalTime, -1, true)
    SimulateReceiveMsg(msgCount, l_temCount)
    l_simulateReceiveMsgTimer:Start()
end
function SimulateReceiveMsg(msgCount, templateCount)
    for i = 1, msgCount do
        local l_index = math.random(1, templateCount)
        local l_msg = l_perfomanceTestMsgTemplate[l_index]
        if l_msg == nil then
            logError("[StartSimulateReceiveLargeMsg] error find null msg !")
        else
            --尝试缓存聊天消息
            if not tryCacheChatMsg(l_msg) then
                ProcessChattingMsg(l_msg, true, false)
            end
        end
    end
end
function StopSimulateReceiveLargeMsg()
    MgrMgr:GetMgr("LuaStopWatchMgr").End("onNewChatMsg")
    stopSimulateMsgTimer()
end
function stopSimulateMsgTimer()
    if l_simulateReceiveMsgTimer == nil then
        return
    end
    l_simulateReceiveMsgTimer:Stop()
    l_simulateReceiveMsgTimer = nil
end
--endregion

--region-----------------------------网络信息处理--------------------
function OnSelectRoleNtf(msg)
    chatDataMgr.ClearChatCache()
    SendWelcomeInfo()
    StartTips()
    SendReqFrequensWordsMsg()
    l_canReceiveChatMsg = true
    EventDispatcher:Dispatch(chatDataMgr.EEventType.ClearChatPanelSetting)
end
--接收到的新的聊天消息
function OnChattingMsgNtf(msg)
    if not l_canReceiveChatMsg then
        return
    end
    ---@type ChatMsg
    local l_resInfo = ParseProtoBufToTable("ChatMsg", msg)
    if l_startStoreMsgTemplate then
        table.insert(l_perfomanceTestMsgTemplate, l_resInfo)
    end

    --过滤屏蔽玩家消息
    if chatDataMgr.FilterForbidChatMsg(l_resInfo) then
        return
    end

    --尝试缓存聊天消息
    if tryCacheChatMsg(l_resInfo) then
        return
    end
    ProcessChattingMsg(l_resInfo, true, false)
end
function OnChatForbidNtfOnLogin(msg)
    ---@type ChatForbidNtfOnLoginNtf
    local l_resInfo = ParseProtoBufToTable("ChatForbidNtfOnLoginNtf", msg)
    chatDataMgr.SetForbidPlayerInfos(l_resInfo.forbidlist)
end
function OnChatShareC2MMsg(msg, arg)
    ---@type ChatShareC2MRes
    local l_resInfo = ParseProtoBufToTable("ChatShareC2MRes", msg)
    waitChatShareRet = false
    if l_resInfo.error_code ~= 0 then
        if l_resInfo.error_code == ErrorCode.ERR_CHAT_SHARE_CANNOT_FIND then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("SHARE_OUT_DATE"))
        else
            logError("OnChatShareC2MMsg error:" .. tostring(l_resInfo.error_code))
        end
    else
        OnRetQueryShareInfo(arg.share_type, arg.uid, l_resInfo)
    end
end

function ReqChangeChatForbid(roleUID, isAdd, playerName)
    if isAdd and not chatDataMgr.CanAddForbidPlayer(true) then
        return
    end

    --请求所有星标常用语
    local l_msgId = Network.Define.Rpc.ChangeChatForbid
    ---@type ChangeChatForbidReq
    local l_sendInfo = GetProtoBufSendTable("ChangeChatForbidReq")
    l_sendInfo.roleid.value = roleUID
    l_sendInfo.isadd = isAdd
    Network.Handler.SendRpc(l_msgId, l_sendInfo, playerName)
end

---@param arg ChangeChatForbidReq
function OnChangeChatForbid(msg, arg, playerName)
    ---@type ChangeChatForbidRes
    local l_resInfo = ParseProtoBufToTable("ChangeChatForbidRes", msg)

    if l_resInfo.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_resInfo.result))
        return
    end
    if arg.isadd then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("Chat_Forbid_In", playerName))
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("Chat_Forbid_Out", playerName))
    end
    chatDataMgr.ChangeForbidPlayerInfo(MLuaCommonHelper.ULong(arg.roleid.value), arg.isadd)
end

function OnRetQueryShareInfo(shareType, uid, msg)
    if shareType == ChatHrefType.AttributePlan then
        local l_attPlanInfo = chatDataMgr.GetShareAttributePlanInfo(uid)
        if l_attPlanInfo ~= nil then
            l_attPlanInfo.chatShareData = msg
            DisplaySpecialSharePanel(false, l_attPlanInfo.planId, shareType, l_attPlanInfo.memberBaseInfo, l_attPlanInfo.chatShareData)
        end
    elseif shareType == ChatHrefType.SkillPlan then
        local l_skillPlanInfo = chatDataMgr.GetShareSkillPlanInfo(uid)
        if l_skillPlanInfo ~= nil then
            l_skillPlanInfo.chatShareData = msg
            DisplaySpecialSharePanel(false, l_skillPlanInfo.planId, shareType, l_skillPlanInfo.memberBaseInfo, l_skillPlanInfo.chatShareData)
        end
    elseif shareType == ChatHrefType.ClothPlan then
        local l_wardrobeInfo = chatDataMgr.GetShareClothPlanInfo(uid)
        if l_wardrobeInfo ~= nil then
            l_wardrobeInfo.chatShareData = msg
            DisplaySpecialSharePanel(false, l_wardrobeInfo.planId, shareType, l_wardrobeInfo.memberBaseInfo, l_wardrobeInfo.chatShareData)
        end
    elseif shareType == ChatHrefType.FashionRating then
        MgrMgr:GetMgr("FashionRatingMgr").OnChatShareC2MMsg(msg.fashion_photo)
    else
        logError("无法找到uid对应的分享类型,uid:" .. tostring(uid) .. "  shareType:" .. tostring(shareType))
    end
end
function OnFrequentWordsMsg(msg, arg)
    ---@type FrequentWordsRes
    local l_resInfo = ParseProtoBufToTable("FrequentWordsRes", msg)
    if l_resInfo.error_code ~= 0 then
        logError("OnFrequentWordsMsg error:" .. tostring(l_resInfo.error_code))
    else
        chatDataMgr.UpdateServerQuickTalkInfos(l_resInfo)
    end
end
--接收发送的聊天消息返回
function OnSendChatMsg(msg, arg)
    ---@type SendChatMsgRes
    local l_resInfo = ParseProtoBufToTable("SendChatMsgRes", msg)
    local l_residueTime = tonumber(l_resInfo.residue_chat_cd) or -1
    if l_resInfo.result ~= nil and l_resInfo.result ~= 0 then
        if l_resInfo.result == ErrorCode.ERR_VIRTUAL_ITEM_LACK_YUANQI then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("CHAT_HINT_MESSAGE_CONDITION_YUANQI"))--"你的元气不足，无法发言"
            --元气不足
        elseif l_resInfo.result == ErrorCode.ERR_CHAT_SCENE_CD_LIMIT then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("CHAT_HINT_MESSAGE_WAIT_TIME", l_residueTime))
            chatDataMgr.SetSendChatContentCD(arg.msg.msg_head.msg_type, l_residueTime)--覆盖cd
        elseif l_resInfo.result == ErrorCode.ERR_CHAT_WORLD_CD_LIMIT then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("CHAT_HINT_MESSAGE_WAIT_TIME", l_residueTime))
            chatDataMgr.SetSendChatContentCD(arg.msg.msg_head.msg_type, l_residueTime)--覆盖cd
        elseif l_resInfo.result == ErrorCode.ERR_CHAT_GUILD_CD_LIMIT then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("CHAT_HINT_MESSAGE_WAIT_TIME", l_residueTime))
            chatDataMgr.SetSendChatContentCD(arg.msg.msg_head.msg_type, l_residueTime)--覆盖cd
        elseif l_resInfo.result == ErrorCode.ERR_CHAT_TEAM_CD_LIMIT then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("CHAT_HINT_MESSAGE_WAIT_TIME", l_residueTime))
            chatDataMgr.SetSendChatContentCD(arg.msg.msg_head.msg_type, l_residueTime)--覆盖cd
        elseif l_resInfo.result == ErrorCode.ERR_CHAT_TYPE_UNSUPPORT then
            logError("聊天发送异常 => 不支持的聊天类型")
        elseif l_resInfo.result == ErrorCode.ERR_CHAT_WORLD_LEVEL_LIMIT then
            logError("聊天发送异常 => 世界聊天等级限制")
        elseif l_resInfo.result == ErrorCode.ERR_CHAT_FORBID_TALK then
            --显示封禁理由 + 解禁时间
            local l_content = tostring(l_resInfo.reason)
            if l_resInfo.end_time then
                local endTime = tonumber(l_resInfo.end_time)
                local l_time = Common.TimeMgr.GetTimeTableByTimeStr(endTime)
                if l_time then
                    --，%d年%d月%d日 %d:%d解封
                    l_content = l_content .. Lang("Chat_Seal_Hint",
                            l_time.year, l_time.month, l_time.day, l_time.hour, l_time.min, l_time.sec)
                else
                    logError("解禁时间戳异常 => {0}", tostring(l_resInfo.end_time))
                end
            end
            CommonUI.Dialog.ShowOKDlg(true, nil, l_content, nil)
        else
            --logError("聊天发送未知异常 => "..tostring(l_resInfo.result))
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_resInfo.result))
        end
    else
        --发言成功
        if arg.msg.msg_head.msg_type == ChatMsgType.CHAT_TYPE_WORLD then
            local l_worldChatCost = chatDataMgr.GetWorldChatCost()
            if l_worldChatCost > 0 then
                --MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("CHAT_HINT_MESSAGE_TITLE_YUANQI",l_worldChatCost)) --发言成功，消耗20点元气值
                local l_MsgPkg = {}
                l_MsgPkg.channel = chatDataMgr.EChannel.WorldChat
                l_MsgPkg.lineType = chatDataMgr.EChatPrefabType.Hint
                l_MsgPkg.content = Lang("CHAT_HINT_MESSAGE_TITLE_YUANQI", l_worldChatCost)
                BoardCastMsg(l_MsgPkg)
            end
        end
        --覆盖cd
        chatDataMgr.SetSendChatContentCD(arg.msg.msg_head.msg_type, l_residueTime)
    end
end
--接收到聊天消息：
--之前的聊天协议入口，目前剧情中的npc聊天冒泡会走这边，好像是Ai发起的？
function OnChatMsgNtf(msg, isFromChat)
    ---@type ChatInfo
    local l_resInfo = ParseProtoBufToTable("ChatInfo", msg)
    if not isFromChat and not l_resInfo.is_show_in_chat then
        return
    end
    DoHandleMsgNtf(l_resInfo.uid, l_resInfo.channel, l_resInfo.content, l_resInfo.name, l_resInfo.content_key, isFromChat, {
        isNpc = true
    })
end
function ShowSpecialShareInfo(uid, planId, shareServerType, chatData, islocalPlan)
    if islocalPlan then
        DisplaySpecialSharePanel(true, planId, shareServerType, nil, nil)
        return
    end
    if shareServerType == ChatHrefType.SkillPlan then
        local l_skillPlanInfo = chatDataMgr.GetShareSkillPlanInfo(uid)
        if l_skillPlanInfo == nil or l_skillPlanInfo.chatShareData == nil then
            if chatData ~= nil and chatData.playerInfo ~= nil then
                chatDataMgr.SetShareSkillPlanInfo(uid, {
                    memberBaseInfo = chatData.playerInfo,
                    chatShareData = nil,
                    planId = planId,
                })
                SendQueryChatShareInfoMsg(uid, shareServerType)
            end
        else
            DisplaySpecialSharePanel(false, uid, shareServerType, l_skillPlanInfo.memberBaseInfo, l_skillPlanInfo.chatShareData)
        end
    elseif shareServerType == ChatHrefType.AttributePlan then
        local l_attPlanInfo = chatDataMgr.GetShareAttributePlanInfo(uid)
        if l_attPlanInfo == nil or l_attPlanInfo.chatShareData == nil then
            if chatData ~= nil and chatData.playerInfo ~= nil then
                chatDataMgr.SetShareAttributePlanInfo(uid, {
                    memberBaseInfo = chatData.playerInfo,
                    chatShareData = nil,
                    planId = planId,
                })
                SendQueryChatShareInfoMsg(uid, shareServerType)
            end
        else
            DisplaySpecialSharePanel(false, uid, shareServerType, l_attPlanInfo.memberBaseInfo, l_attPlanInfo.chatShareData)
        end
    elseif shareServerType == ChatHrefType.ClothPlan then
        local l_wardrobeInfo = chatDataMgr.SetShareClothPlanInfo(uid)
        if l_wardrobeInfo == nil or l_wardrobeInfo.chatShareData == nil then
            if chatData ~= nil and chatData.playerInfo ~= nil then
                chatDataMgr.SetShareClothPlanInfo(uid, {
                    memberBaseInfo = chatData.playerInfo,
                    chatShareData = nil,
                    planId = planId,
                })
                SendQueryChatShareInfoMsg(uid, shareServerType)
            end
        else
            DisplaySpecialSharePanel(false, uid, shareServerType, l_wardrobeInfo.memberBaseInfo, l_wardrobeInfo.chatShareData)
        end
    end
end
function DisplaySpecialSharePanel(isLocalPlan, planId, shareServerType, memberBaseInfo, chatShareData)
    local l_shareData = nil

    if shareServerType == ChatHrefType.SkillPlan then
        if chatShareData ~= nil then
            l_shareData = chatShareData.skill_plan_share
        end
        local l_openPanelParam = {
            planId = tonumber(planId),
            showSkillPlan = true,
            isLocalPlan = isLocalPlan,
            memberBaseInfo = memberBaseInfo,
            shareData = l_shareData,
        }
        UIMgr:ActiveUI(UI.CtrlNames.BuildPlan, l_openPanelParam)
    elseif shareServerType == ChatHrefType.AttributePlan then
        if chatShareData ~= nil then
            l_shareData = chatShareData.quality_point_page_info
        end
        local l_openPanelParam = {
            planId = tonumber(planId),
            showSkillPlan = false,
            isLocalPlan = isLocalPlan,
            memberBaseInfo = memberBaseInfo,
            shareData = l_shareData,
        }
        UIMgr:ActiveUI(UI.CtrlNames.BuildPlan, l_openPanelParam)
    elseif shareServerType == ChatHrefType.ClothPlan then
        if chatShareData ~= nil then
            l_shareData = chatShareData.wardrobe_share
        end
        local l_openPanelParam = {
            isLocalPlan = isLocalPlan,
            planId = planId,
            memberBaseInfo = memberBaseInfo,
            shareData = l_shareData
        }
        UIMgr:ActiveUI(UI.CtrlNames.Clothshare, l_openPanelParam)
    end
end
function SendQueryChatShareInfoMsg(uid, shareServerType)
    if waitChatShareRet then
        return
    end
    waitChatShareRet = true
    local l_msgId = Network.Define.Rpc.ChatShareMsg
    ---@type ChatShareC2MArg
    local l_sendInfo = GetProtoBufSendTable("ChatShareC2MArg")
    l_sendInfo.uid = uid
    l_sendInfo.share_type = shareServerType
    Network.Handler.SendRpc(l_msgId, l_sendInfo, nil, nil, nil, ResetWaitChatShareState)
end
function ResetWaitChatShareState()
    --超时重置等待状态
    waitChatShareRet = false
end
--请求公会历史消息
--登陆后调用一次
function SendGuideHistoryMsg()
    local l_msgId = Network.Define.Rpc.PullChatMsg
    ---@type PullChatArg
    local l_sendInfo = GetProtoBufSendTable("PullChatArg")
    l_sendInfo.msghead.msg_type = ChatMsgType.CHAT_TYPE_GUILD
    l_sendInfo.msghead.sender_uid = tostring(MPlayerInfo.UID)
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end
--接收公会历史消息
function OnGuideHistoryMsg(msg)
    ---@type PullChatRes
    local l_resInfo = ParseProtoBufToTable("PullChatRes", msg)
    guildHistoryMsg = {}
    if l_resInfo.error ~= 0 then
        return
    end
    local l_msgCount = #l_resInfo.msg
    local l_playerInfoMgr = MgrMgr:GetMgr("PlayerInfoMgr")
    for i = 1, l_msgCount do
        local l_rid = l_resInfo.msg[i].msg_head.sender_uid
        if l_rid ~= nil and l_rid ~= 0 then
            local l_data = {
                rid = l_resInfo.msg[i].msg_head.sender_uid,
                info = l_resInfo.msg[i],
                playerInfo = l_playerInfoMgr.GetPlayerInfoLocal(l_rid, true),
            }
            guildHistoryMsg[#guildHistoryMsg + 1] = l_data
            if l_data.playerInfo == nil then
                l_playerInfoMgr.GetPlayerInfoFromServer(l_rid, function(obj)
                    l_data.playerInfo = obj
                    l_data.playerInfo.isSelf = false
                    HandleGuildHistoryMsg()
                end)
            end
        end
    end
    if #guildHistoryMsg > 0 then
        HandleGuildHistoryMsg()
    end
end
function HandleGuildHistoryMsg()
    if guildHistoryMsg == nil or #guildHistoryMsg < 1 then
        return
    end
    for i = 1, #guildHistoryMsg do
        if guildHistoryMsg[i].playerInfo == nil then
            return
        end
    end
    for i = 1, #guildHistoryMsg do
        local l_info = guildHistoryMsg[i]
        ProcessChattingMsg(l_info.info, true, true, {
            playerInfo = l_info.playerInfo,
            isGuideHistoryMsg = true,
        })
    end
    --公会的时间线：以上为历史消息
    local l_MsgPkg = {}
    l_MsgPkg.channel = chatDataMgr.EChannel.GuildChat
    l_MsgPkg.lineType = chatDataMgr.EChatPrefabType.TimeSpace
    local l_timelong = Common.TimeMgr.GetLocalNowTimestamp()
    l_MsgPkg.time = tostring(os.date("!%H:%M", l_timelong))
    BoardCastMsg(l_MsgPkg)
    guildHistoryMsg = nil
    EventDispatcher:Dispatch(chatDataMgr.EEventType.ResetMainChat)
end

---@Description:当消息接收数量过多时，缓存平滑处理消息
---@param msg ChatMsg
function tryCacheChatMsg(msg)
    local channel = msg.msg_head.msg_type
    --暂时仅世界聊天缓存，其他频道消息量相对较少
    if channel ~= chatDataMgr.EChannel.WorldChat then
        return false
    end
    local l_lastHandleTime = l_luaStopWatchMgr.GetTimeStamp(l_luaStopWatchMgr.ELuaStopWatchType.LastHandleChatTime)
    --与上次处理聊天消息间隔时间过小进入等待队列
    if l_lastHandleTime < chatDataMgr.GetChatHandleInterval() then
        startHandleCacheChatMsgTimer()
        chatDataMgr.EnqueueLargeChatCacheQueue(msg)
        return true
    end

    --之前还有未处理的数据，需要排队
    if chatDataMgr.GetLargeChatCacheQueueSize() > 0 then
        startHandleCacheChatMsgTimer()
        chatDataMgr.EnqueueLargeChatCacheQueue(msg)
        return true
    end
    l_luaStopWatchMgr.Reset(l_luaStopWatchMgr.ELuaStopWatchType.LastHandleChatTime)
    return false
end
function startHandleCacheChatMsgTimer()
    --时钟已初始化，直接返回
    if l_cacheChatMsgHandleTimer ~= nil then
        return
    end
    local l_handleChatMsgIntervalMs = chatDataMgr.GetChatHandleInterval() / 1000.0
    l_cacheChatMsgHandleTimer = Timer.New(handleNextCacheChatMsg,
            l_handleChatMsgIntervalMs, -1)
    l_cacheChatMsgHandleTimer:Start()
end
---@Description:大消息量缓存队列专用，处理缓存中下一条消息
function handleNextCacheChatMsg()
    local l_timeDisToLastHandle = l_luaStopWatchMgr.GetTimeStamp(l_luaStopWatchMgr.ELuaStopWatchType.LastHandleChatTime)
    if l_timeDisToLastHandle < chatDataMgr.GetChatHandleInterval() then
        return
    end
    --无可处理消息
    if chatDataMgr.GetLargeChatCacheQueueSize() < 1 then
        --持续5s缓存队列无数据，停止定时器，节约性能
        if l_timeDisToLastHandle > 5000 then
            stopHandleCacheChatMsgTimer()
        end
        return
    end
    local l_getNextMsg = chatDataMgr.DequeueLargeChatCacheQueue()
    if l_getNextMsg ~= nil then
        l_luaStopWatchMgr.Reset(l_luaStopWatchMgr.ELuaStopWatchType.LastHandleChatTime)
        ProcessChattingMsg(l_getNextMsg, true, false)
    end
end
function stopHandleCacheChatMsgTimer()
    if l_cacheChatMsgHandleTimer == nil then
        return
    end
    l_cacheChatMsgHandleTimer:Stop()
    l_cacheChatMsgHandleTimer = nil
end
--offline = 离线消息
--离线消息的语音不会主动播放,比如说公会历史消息
function ProcessChattingMsg(netMsg, isFromChat, offline, data)
    local l_head = netMsg.msg_head
    if l_head.sender_uid == nil or l_head.sender_uid == 0 then
        logError("收到来自服务器的异常角色uid => " .. tostring(l_head.sender_uid))
        return
    end

    local channel = l_head.msg_type

    if not isFromChat and not netMsg.is_show_in_chat then
        return
    end

    --公会红包
    if netMsg.red_envelope_info then
        local l_playerInfo = data and data.playerInfo or nil
        if netMsg.red_envelope_info.guild_red_envelope_id and netMsg.red_envelope_info.guild_red_envelope_id ~= 0 then
            MgrMgr:GetMgr("RedEnvelopeMgr").OnSendRedEnvelopeNtf(netMsg.red_envelope_info, l_playerInfo)
            return
        end
    end

    local l_data = data or {}
    l_data.MsgParam = netMsg.extra_param
    l_data.lineType = l_head.preview_type

    -- 特殊处理，通过此字段判断是否是贴纸的分享
    if #netMsg.stickers.grid ~= 0 then
        l_data.stickers = netMsg.stickers
    end

    if netMsg.medium == ChatMediumType.ChatMediumTypeAudio then
        l_data.AudioObj = {
            ID = netMsg.audio.audio_id,
            Text = netMsg.audio.text,
            Duration = netMsg.audio.duration,
            PlayOver = offline and true,
        }
    end

    --特殊处理 公会新闻
    if l_data.MsgParam[1] and l_data.MsgParam[1].type == ChatHrefType.GuildNews then
        local l_msgParm = l_data.MsgParam[1]
        netMsg.msg_content = l_msgParm.name[1] or ""
        l_data.aimPlayerId = l_msgParm.param64[1].value
    end

    return DoHandleMsgNtf(l_head.sender_uid, channel, netMsg.msg_content, nil, nil, isFromChat, l_data)
end
--[[
addationalData 附加数据
{
    isShowDanmu 是否显示组队弹幕 默认显示
    isShowInMainChat 是否将聊天消息显示在主界面 默认显示
}
]]--
function DoHandleMsgNtf(uid, channel, content, name, content_key, isFromChat, addationalData)
    local l_MsgPkg = {}
    l_MsgPkg.uid = uid
    l_MsgPkg.uidStr = MoonCommonLib.StringEx.ConverToString(uid)
    l_MsgPkg.channel = channel or 0
    local l_finalContent
    if content_key ~= nil and content_key ~= "" then
        l_finalContent = Lang(content_key)
    elseif content ~= nil and content ~= "" then
        l_finalContent = content
    end
    l_MsgPkg.content = l_finalContent or ""
    l_MsgPkg.name = name
    l_MsgPkg.isFromChat = isFromChat and true
    l_MsgPkg.playerInfo = nil
    l_MsgPkg.lineType = nil --显示在聊天框时使用的模板
    l_MsgPkg.subType = nil  --系统消息子类型
    l_MsgPkg.Param = nil --消息插入的链接参数
    --显示在主界面mini框
    l_MsgPkg.showInMainChat = true
    --以弹幕形式发射
    l_MsgPkg.showDanmu = channel == chatDataMgr.EChannel.TeamChat
    --来自服务器的npc的对话
    l_MsgPkg.isNpc = addationalData and addationalData.isNpc
    --是否需要又需要点击的玩家数据 来自公会新闻点赞
    l_MsgPkg.aimPlayerId = addationalData and addationalData.aimPlayerId
    --附加数据处理
    if addationalData ~= nil then
        --是否显示弹幕
        if addationalData.isShowDanmu ~= nil then
            l_MsgPkg.showDanmu = addationalData.isShowDanmu
        end

        --是否显示在主界面
        if addationalData.isShowInMainChat ~= nil then
            l_MsgPkg.showInMainChat = addationalData.isShowInMainChat
        end

        --音效
        if addationalData.AudioObj ~= nil then
            l_MsgPkg.AudioObj = addationalData.AudioObj
            l_MsgPkg.content = l_MsgPkg.AudioObj.Text
        end

        --内容参数
        l_MsgPkg.Param = addationalData.MsgParam

        --公会聊天记录标签
        l_MsgPkg.isGuideHistoryMsg = addationalData.isGuideHistoryMsg

        -- 贴纸
        l_MsgPkg.stickers = addationalData.stickers

        --自带的角色信息
        l_MsgPkg.playerInfo = addationalData.playerInfo

        --显示类型
        l_MsgPkg.lineType = addationalData.lineType

    end

    if l_MsgPkg.uid ~= nil then
        if l_MsgPkg.playerInfo == nil then
            l_MsgPkg.playerInfo = MgrMgr:GetMgr("PlayerInfoMgr").GetPlayerInfoLocal(l_MsgPkg.uid, isFromChat)
            if l_MsgPkg.playerInfo == nil then
                if not isFromChat then
                    return
                end

                --请求服务角色外观数据
                local l_addationalData = addationalData
                MgrMgr:GetMgr("PlayerInfoMgr").GetPlayerInfoFromServer(l_MsgPkg.uid, function(obj)
                    l_MsgPkg.playerInfo = obj
                    l_MsgPkg.playerInfo.isSelf = false
                    GetDefLineType(l_MsgPkg)
                    BoardCastMsg(l_MsgPkg)
                    if l_addationalData ~= nil and l_addationalData.RoleInfoCallBack ~= nil then
                        l_addationalData.RoleInfoCallBack(l_MsgPkg)
                    end
                end)

                return l_MsgPkg
            end
        end
    end

    GetDefLineType(l_MsgPkg)
    BoardCastMsg(l_MsgPkg)
    return l_MsgPkg
end
---@param l_MsgPkg ChatMsgPack
function GetDefLineType(l_MsgPkg)
    if l_MsgPkg.lineType ~= nil and l_MsgPkg.lineType ~= 0 then
        return l_MsgPkg
    end
    if l_MsgPkg.channel == chatDataMgr.EChannel.SystemChat then
        l_MsgPkg.lineType = chatDataMgr.EChatPrefabType.System
        return l_MsgPkg
    end
    if l_MsgPkg.playerInfo == nil then
        return l_MsgPkg
    end
    if l_MsgPkg.playerInfo.isSelf then
        l_MsgPkg.lineType = chatDataMgr.EChatPrefabType.Self
        return l_MsgPkg
    end
    l_MsgPkg.lineType = chatDataMgr.EChatPrefabType.Other
    return l_MsgPkg
end
---@Description:聊天特殊处理合集
---@param mMsgPkg ChatMsgPack
function ChatSpecialTreatment(mMsgPkg)
    -- 贴纸分享处理
    if mMsgPkg.stickers then
        mMsgPkg.lineType = mMsgPkg.isSelf and chatDataMgr.EChatPrefabType.StickerShareSelf or chatDataMgr.EChatPrefabType.StickerShareOther
        return mMsgPkg
    end
    if mMsgPkg.Param == nil then
        return mMsgPkg
    end
    for i = 1, #mMsgPkg.Param do
        local l_p = mMsgPkg.Param[i]
        --公会照相求助
        if l_p.type == ChatHrefType.TaskPhoto then
            mMsgPkg.lineType = mMsgPkg.isSelf and EChatPrefabType.TaskPhotoSelf or EChatPrefabType.TaskPhotoOther
            if #l_p.param32 > 0 then
                mMsgPkg.ViewportID = l_p.param32[1].value
            end
            break
        end
        --魔法信笺
        if l_p.type == ChatHrefType.MagicLetter then
            mMsgPkg.lineType = mMsgPkg.isSelf and EChatPrefabType.MagicLetterSelf or EChatPrefabType.MagicLetterOther
            break
        end
    end
    return mMsgPkg
end
function BoardCastMsg(mMsgPkg)
    mMsgPkg.isSelf = tostring(mMsgPkg.uid) == tostring(MPlayerInfo.UID)

    --聊天中的特殊处理
    ChatSpecialTreatment(mMsgPkg)

    --解析子类型
    if mMsgPkg.lineType == chatDataMgr.EChatPrefabType.System and mMsgPkg.subType == nil then
        local l_splitPos = string.find(mMsgPkg.content, "@")
        if l_splitPos ~= nil then
            mMsgPkg.subType = string.sub(mMsgPkg.content, 1, l_splitPos - 1)
            mMsgPkg.content = string.sub(mMsgPkg.content, l_splitPos + 1)
        else
            mMsgPkg.subType = chatDataMgr.EChannelSys.System
        end
    end

    --入队,队列限制20条
    if not mMsgPkg.isNpc then
        local l_cache = math.max(5, chatDataMgr.GetLocalCacheNum(mMsgPkg.channel))
        local l_msgChannelCache = chatDataMgr.GetChannelCache(mMsgPkg.channel)
        if l_msgChannelCache:size() >= l_cache then
            l_msgChannelCache:dequeue()
        end
        l_msgChannelCache:enqueue(mMsgPkg)
    end
    --MainChat使用，队列限制20条
    if CanMainChatShow(mMsgPkg) then
        local l_cacheAll = math.max(5, chatDataMgr.GetLocalCacheNum(chatDataMgr.EChannel.AllChat))
        local l_allChannelCache = chatDataMgr.GetChannelCache(chatDataMgr.EChannel.AllChat)
        if l_allChannelCache:size() >= l_cacheAll then
            l_allChannelCache:dequeue()
        end
        l_allChannelCache:enqueue(mMsgPkg)
    end

    GlobalEventBus:Dispatch(EventConst.Names.NewChatMsg, mMsgPkg)
end
--判断消息是否显示在主界面mini消息框
function CanMainChatShow(msg)
    if not msg.showInMainChat then
        return false
    end
    if msg.channel == chatDataMgr.EChannel.CurSceneChat then
        return chatDataMgr.GetSystemSwich(chatDataMgr.ESysSettingSwitch.MainToCurrent)
    elseif msg.channel == chatDataMgr.EChannel.WorldChat then
        return chatDataMgr.GetSystemSwich(chatDataMgr.ESysSettingSwitch.MainToWorld)
    elseif msg.channel == chatDataMgr.EChannel.TeamChat then
        return chatDataMgr.GetSystemSwich(chatDataMgr.ESysSettingSwitch.MainToTeam)
    elseif msg.channel == chatDataMgr.EChannel.GuildChat then
        return chatDataMgr.GetSystemSwich(chatDataMgr.ESysSettingSwitch.MainToGuild)
    elseif msg.channel == chatDataMgr.EChannel.ChatRoomChat then
        return false
    elseif msg.channel == chatDataMgr.EChannel.WatchChat then
        return MgrMgr:GetMgr("WatchWarMgr").IsInSpectator()
    elseif msg.channel == chatDataMgr.EChannel.SystemChat then
        --个人系统消息不显示
        if msg.subType ~= nil and msg.subType == chatDataMgr.EChannelSys.Private then
            return false
        end
        return chatDataMgr.GetSystemSwich(chatDataMgr.ESysSettingSwitch.MainToSystem)
    end
    return false
end
function SendSystemInfo(subType, content, data)
    if subType ~= nil then
        content = subType .. '@' .. content
    end
    DoHandleMsgNtf(nil, chatDataMgr.EChannel.SystemChat, content, nil, nil, false, data)
end
function SendWelcomeInfo()
    local l_tableData = TableUtil.GetNoticeLoadTable().GetTable()
    for i, row in ipairs(l_tableData) do
        local l_limit = row.LoadLevelLimit
        local l_min = l_limit:get_Item(0)
        local l_max = l_limit:get_Item(1)
        if MPlayerInfo.Lv > l_min and MPlayerInfo.Lv < l_max then
            MgrMgr:GetMgr("MessageRouterMgr").OnMessage(row.NoticeLoadContent)
            return
        end
    end
end
function StartTips()
    showTip = true

    --请求公会历史消息
    SendGuideHistoryMsg()
end
function StopTips()
    showTip = false
end
function SendTips()
    local l_currentTips = {}
    local l_tableData = TableUtil.GetNoticeTable().GetTable()
    for i, row in ipairs(l_tableData) do
        local l_limit = row.LevelLimit
        local l_min = l_limit:get_Item(0)
        local l_max = l_limit:get_Item(1)
        if MPlayerInfo.Lv >= l_min and MPlayerInfo.Lv <= l_max then
            table.insert(l_currentTips, row.NoticeContent)
        end
    end
    local l_id = l_currentTips[math.random(1, #l_currentTips)]
    MgrMgr:GetMgr("MessageRouterMgr").OnMessage(l_id)
end

local C_COIN_TYPE_MAP = {
    [GameEnum.l_virProp.Coin104] = 1,
    [GameEnum.l_virProp.Coin103] = 1,
    [GameEnum.l_virProp.Coin101] = 1,
    [GameEnum.l_virProp.Coin102] = 1,
    [GameEnum.l_virProp.Prestige] = 1,
}

local C_EXP_TYPE_MAP = {
    [GameEnum.l_virProp.exp] = 1,
    [GameEnum.l_virProp.jobExp] = 1,
}

---@param itemUpdateDataList ItemUpdateData[]
function _onItemUpdate(itemUpdateDataList)
    if nil == itemUpdateDataList then
        logError("[ChatMgr] invalid param")
        return
    end

    for i = 1, #itemUpdateDataList do
        local singleUpdate = itemUpdateDataList[i]
        local changeData = singleUpdate:GetItemCompareData()
        local itemData = singleUpdate:GetNewOrOldItem()
        --- 如果是拿到了这个reason说明是玩家自己操作，这个时候是不会触发增加或者删除的，所以不进行提示
        if itemData ~= nil and ItemChangeReason.ITEM_REASON_MOVE_ITEM ~= singleUpdate.Reason then
            if GameEnum.EBagContainerType.VirtualItem ~= itemData.ContainerType and 0 < changeData.count then
                SendSystemInfoWithItem(itemData:GetSvrContType(), changeData.count, changeData.id, singleUpdate.Reason, 0, itemData.UID)
            else
                if 0 < changeData.count and nil == C_EXP_TYPE_MAP[changeData.id] then
                    SendSystemInfoWithItem(BagType.BAG, changeData.count, changeData.id, singleUpdate.Reason, 0, 0)
                elseif 0 > changeData.count and nil ~= C_COIN_TYPE_MAP[changeData.id] then
                    local countText = MNumberFormat.GetNumberFormat(tostring(-changeData.count))
                    SendSystemInfo(chatDataMgr.EChannelSys.Private, string.ro_concat(Lang("Chat_ConsumeItem", countText, GetItemText(changeData.id, { rm_color = true }))))
                end
            end
        end

        _showExpText(singleUpdate.Reason, changeData.id, changeData.count)
    end
end

function _showExpText(reason, id, count)
    if nil == reason or nil == id or nil == count then
        logError("[ChatMgr] invalid param")
        return
    end

    local C_EXP_TYPE_MAP = {
        [GameEnum.l_virProp.exp] = 1,
        [GameEnum.l_virProp.jobExp] = 1,
    }

    if nil == C_EXP_TYPE_MAP[id] then
        return
    end

    if GameEnum.l_virProp.exp == id then
        if ItemChangeReason.ITEM_REASON_EXP_BLESS == reason then
            cacheBaseBlessExp = count
        elseif ItemChangeReason.ITEM_REASON_EXP_HEALTH == reason then
            cacheBasePrayExp = count
        else
            _showExpChangeMsg(id, count)
        end
    elseif GameEnum.l_virProp.jobExp == id then
        if ItemChangeReason.ITEM_REASON_EXP_BLESS == reason then
            cacheJobBlessExp = count
        elseif ItemChangeReason.ITEM_REASON_EXP_HEALTH == reason then
            cacheJobPrayExp = count
        else
            _showExpChangeMsg(id, count)
        end
    end
end

--- 收到非祝福经验和祈福经验的时候，会默认在系统频道输出；并且会清空所有的缓存数据
function _showExpChangeMsg(id, count)
    if GameEnum.l_virProp.exp == id then
        suffix = _getSuffix(id)
        _sendSystemMsg(id, count, suffix)
        _clearCacheBaseExp()
    elseif GameEnum.l_virProp.jobExp == id then
        suffix = _getSuffix(id)
        _sendSystemMsg(id, count, suffix)
        _clearCacheJobExp()
    else
        -- do nothing
    end
end

function _getSuffix(id)
    local blessExpStr = Lang("Chat_GetItem_ExtraInfo")
    local prayExpStr = Lang("Chat_GetItem_ExtraInfo_Health")
    local C_STR = "({0})"

    if GameEnum.l_virProp.exp == id then
        if 0 < cacheBaseBlessExp and 0 < cacheBasePrayExp then
            local blessStr = StringEx.Format(blessExpStr, cacheBaseBlessExp)
            local prayStr = StringEx.Format(prayExpStr, tostring(cacheBasePrayExp))
            local fullStr = blessStr .. "、" .. prayStr
            local ret = StringEx.Format(C_STR, fullStr)
            return ret
        elseif 0 < cacheBaseBlessExp and 0 >= cacheBasePrayExp then
            local blessStr = StringEx.Format(blessExpStr, tostring(cacheBaseBlessExp))
            local ret = StringEx.Format(C_STR, blessStr)
            return ret
        elseif 0 >= cacheBaseBlessExp and 0 < cacheBasePrayExp then
            local prayStr = StringEx.Format(prayExpStr, tostring(cacheBasePrayExp))
            local ret = StringEx.Format(C_STR, prayStr)
            return ret
        else
            return ""
        end
    elseif GameEnum.l_virProp.jobExp == id then
        if 0 < cacheJobBlessExp and 0 < cacheJobPrayExp then
            local blessStr = StringEx.Format(blessExpStr, cacheJobBlessExp)
            local prayStr = StringEx.Format(prayExpStr, tostring(cacheJobPrayExp))
            local fullStr = blessStr .. "、" .. prayStr
            local ret = StringEx.Format(C_STR, fullStr)
            return ret
        elseif 0 < cacheJobBlessExp and 0 >= cacheJobPrayExp then
            local blessStr = StringEx.Format(blessExpStr, tostring(cacheJobBlessExp))
            local ret = StringEx.Format(C_STR, blessStr)
            return ret
        elseif 0 >= cacheJobBlessExp and 0 < cacheJobPrayExp then
            local prayStr = StringEx.Format(prayExpStr, tostring(cacheJobPrayExp))
            local ret = StringEx.Format(C_STR, prayStr)
            return ret
        else
            return ""
        end
    else
        -- do nothing
    end

    return ""
end

function _clearCacheJobExp()
    cacheJobBlessExp = 0
    cacheJobPrayExp = 0
end

function _clearCacheBaseExp()
    cacheBaseBlessExp = 0
    cacheBasePrayExp = 0
end

function _sendSystemMsg(id, count, suffix)
    if nil == suffix then
        suffix = ""
    end

    content = GetItemText(id, { prefix = "[", suffix = "]", num = count, color = RoColorTag.Green })
    local sendStr = StringEx.Format("{0} {1}{2}", Common.Utils.Lang("Chat_GetItem"), content, GetColorText(suffix, RoColorTag.Green))
    SendSystemInfo(chatDataMgr.EChannelSys.Private, sendStr)
end

--根据服务器发的物品数据进行显示
function SendSystemInfoWithItem(bagType, count, id, reason, level, uid)
    if bagType == BagType.FASHION_BAG then
        return
    end

    itemTableInfo = TableUtil.GetItemTable().GetRowByItemID(id)
    if itemTableInfo == nil then
        return
    end

    local getItemTitle
    if reason == ItemChangeReason.ITEM_REASON_REFINE then
        getItemTitle = Common.Utils.Lang("Refine_GetItem") .. " "
    else
        getItemTitle = Common.Utils.Lang("Chat_GetItem") .. " "
    end

    if bagType then
        local l_itemText = GetItemText(id, { prefix = "[", suffix = "]", num = tostring(count) })
        SendSystemInfo(chatDataMgr.EChannelSys.Private, getItemTitle .. l_itemText)
    else
        local l_linkSt, l_linkParams = MgrMgr:GetMgr("LinkInputMgr").GetItemPack(nil, id, level, uid, count, true)
        local l_MsgPkg = {}
        l_MsgPkg.channel = chatDataMgr.EChannel.SystemChat
        l_MsgPkg.lineType = chatDataMgr.EChatPrefabType.System
        l_MsgPkg.subType = chatDataMgr.EChannelSys.Private
        l_MsgPkg.content = getItemTitle .. l_linkSt
        l_MsgPkg.Param = l_linkParams
        BoardCastMsg(l_MsgPkg)
    end
end
--endregion

--region-------------------------------发送消息---------------------
--能否发送消息？
function CanSendMsg(channel, showLog, linkParams, ignoreCD)
    if showLog == nil then
        showLog = true
    end
    if channel == chatDataMgr.EChannel.SystemChat then
        return false
    end

    --等级限制
    if channel == chatDataMgr.EChannel.WorldChat then
        --世界发言等级限制
        local l_lv = chatDataMgr.GetWorldSendLv()
        if MPlayerInfo.Lv < l_lv then
            if showLog then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("CHAT_HINT_MESSAGE_CONDITION_LV", l_lv))
            end
            return false
        end

        --世界发言道具消耗
        local l_hasYuanqi = Data.BagModel:GetCoinOrPropNumById(GameEnum.l_virProp.Yuanqi)
        if l_hasYuanqi < chatDataMgr.GetWorldChatCost() then
            if showLog then
                --"你的元气不足，无法发言"
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("CHAT_HINT_MESSAGE_CONDITION_YUANQI"))
            end

            return false
        end
    end

    --超链接频道限制
    if not CanSendHrefContent(channel, linkParams) then
        return false
    end

    --工会限制
    if channel == chatDataMgr.EChannel.GuildChat then
        if not MgrMgr:GetMgr("GuildMgr").IsSelfHasGuild() then
            if showLog then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("CHAT_HINT_MESSAGE_CONDITION_GUILD"))
            end
            return false
        end
    end

    --不在组队中禁止在组队频道发言
    if channel == chatDataMgr.EChannel.TeamChat and not DataMgr:GetData("TeamData").myTeamInfo.isInTeam then
        if showLog then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("CHAT_TIP_NOT_IN_TEAM"))
        end
        return false
    end

    --由于封禁cd会变化，前端不栏cd,返回的error判断
    if not ignoreCD then
        local l_nextSendTime = chatDataMgr.GetSendChatContentCD(channel)
        if l_nextSendTime ~= nil then
            local l_leftTime = math.ceil(l_nextSendTime - Time.realtimeSinceStartup)
            if l_leftTime > 0 then
                if showLog then
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("CHAT_HINT_MESSAGE_WAIT_TIME", l_leftTime))
                end
                return false
            end
        end
    end

    --初心者没改名不允许发言
    if MPlayerInfo.ChangeNameCount <= 0 then
        if showLog then
            --登记姓名后才可以发送消息哦，先去找斯普拉琪吧~
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("PrivateChat_Name_Astrict"))
        end
        return false
    end

    return true
end
function CanSendHrefContent(curChannel, params)
    if params == nil then
        return true
    end
    for i = 1, #params do
        local l_param = params[i]
        local l_canSend, l_funcId = CanSendHrefType(curChannel, l_param.type)
        if not l_canSend then
            local l_openSysData = TableUtil.GetOpenSystemTable().GetRowById(l_funcId)
            if l_openSysData ~= nil then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(string.format(Lang("Chat_Hint_Link"), l_openSysData.Title))  --"该频道无法发送道具信息"
            end
            return false
        end
    end
    return true
end
function CanSendHrefType(channel, hrefType)
    local l_tableData = nil
    if hrefType == ChatHrefType.Prop then
        l_tableData = TableUtil.GetChatSystemTable().GetRowByID(16003)
    elseif hrefType == ChatHrefType.AchievementDetails or hrefType == ChatHrefType.AchievementBadge then
        l_tableData = TableUtil.GetChatSystemTable().GetRowByID(16006)
    elseif hrefType == ChatHrefType.AttributePlan or hrefType == ChatHrefType.SkillPlan then
        l_tableData = TableUtil.GetChatSystemTable().GetRowByID(16005)
    elseif hrefType == ChatHrefType.ClothPlan then
        l_tableData = TableUtil.GetChatSystemTable().GetRowByID(16007)
    end
    if l_tableData == nil then
        return true
    end
    if ContainChannel(channel, l_tableData.ChannelLimit) then
        return true
    end
    return false, l_tableData.ID
end
function ContainChannel(curChannel, channelList)
    if channelList == nil or curChannel == nil then
        return false
    end
    for i = 0, channelList.Length - 1 do
        if channelList[i] == curChannel then
            return true
        end
    end
    return false
end
function SendReqFrequensWordsMsg()
    --请求所有星标常用语
    local l_msgId = Network.Define.Rpc.FrequentWords
    ---@type FrequentWordsArg
    local l_sendInfo = GetProtoBufSendTable("FrequentWordsArg")
    local l_freqWord = l_sendInfo.freq_words:add()
    l_freqWord.frequent_words_op = 3
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end
function SendFrequensWordMsg()
    --发送新的聊天消息
    local l_quickTalkParam = chatDataMgr.GetQuickTalkParamInfo()
    if not l_quickTalkParam.starInfoDirty then
        return
    end
    l_quickTalkParam.starInfoDirty = false
    local l_msgId = Network.Define.Rpc.FrequentWords
    ---@type FrequentWordsArg
    local l_sendInfo = GetProtoBufSendTable("FrequentWordsArg")
    local l_tempIdCount = 1
    local l_quickTalkInfos = chatDataMgr.GetQuickTalkInfo()
    for i = 1, #l_quickTalkInfos do
        local l_talkInfo = l_quickTalkInfos[i]
        if l_talkInfo.isStar then
            if l_talkInfo.uid == "0" and l_talkInfo.tempId == 0 then
                local l_freqWord = l_sendInfo.freq_words:add()
                l_freqWord.uid = "0"
                l_freqWord.frequent_words_op = 1
                l_freqWord.words = l_talkInfo.content
                l_freqWord.client_id = l_tempIdCount
                l_talkInfo.tempId = l_tempIdCount
                l_tempIdCount = l_tempIdCount + 1
                if l_talkInfo.param ~= nil then
                    for i = 1, #l_talkInfo.param do
                        local l_param = l_talkInfo.param[i]
                        local l_data = l_freqWord.extra_param:add()
                        l_data.type = l_param.type
                        if l_param.param32 ~= nil then
                            for j = 1, #l_param.param32 do
                                l_data.param32:add().value = l_param.param32[j].value
                            end
                        end
                        if l_param.param64 ~= nil then
                            for j = 1, #l_param.param64 do
                                l_data.param64:add().value = l_param.param64[j].value
                            end
                        end
                        if l_param.name ~= nil then
                            for j = 1, #l_param.name do
                                table.insert(l_data.name, l_param.name[j])
                            end
                        end
                    end
                end
            end
        else
            if l_talkInfo.uid ~= "0" then
                local l_freqWord = l_sendInfo.freq_words:add()
                l_freqWord.uid = l_talkInfo.uid
                l_freqWord.frequent_words_op = 2
            end
        end
    end
    for i = 1, #l_quickTalkParam.needRemoveTalkUids do
        local l_freqWord = l_sendInfo.freq_words:add()
        l_freqWord.uid = l_quickTalkParam.needRemoveTalkUids[i]
        l_freqWord.frequent_words_op = 2
    end
    l_quickTalkParam.needRemoveTalkUids = {}
    if #l_sendInfo.freq_words > 0 then
        Network.Handler.SendRpc(l_msgId, l_sendInfo)
    end
end
function sendChatMsgInner(uid, chatMsg, channel, params, lineType, fromInputField)
    if not CanSendMsg(channel, true, params) then
        return false
    end
    chatDataMgr.SetSendChatContentCD(channel, chatDataMgr.GetSendChatContentConfigCD(channel))

    --发送新的聊天消息
    local l_msgId = Network.Define.Rpc.SendChatMsg
    ---@type SendChatMsgArg
    local l_sendInfo = GetProtoBufSendTable("SendChatMsgArg")
    l_sendInfo.msg.msg_head.msg_type = channel
    l_sendInfo.msg.msg_head.sender_uid = MoonCommonLib.StringEx.ConverToString(uid)
    l_sendInfo.msg.msg_content = chatMsg
    l_sendInfo.msg.medium = ChatMediumType.ChatMediumTypeText
    if lineType ~= nil then
        l_sendInfo.msg.msg_head.preview_type = lineType
    end
    if params ~= nil then
        for i = 1, #params do
            local l_param = params[i]
            local l_data = l_sendInfo.msg.extra_param:add()
            l_data.type = l_param.type
            if l_param.param32 ~= nil then
                for j = 1, #l_param.param32 do
                    l_data.param32:add().value = l_param.param32[j].value
                end
            end
            if l_param.param64 ~= nil then
                for j = 1, #l_param.param64 do
                    l_data.param64:add().value = l_param.param64[j].value
                end
            end
            if l_param.name ~= nil then
                for j = 1, #l_param.name do
                    table.insert(l_data.name, l_param.name[j])
                end
            end
        end
    end
    if fromInputField ~= nil and fromInputField then
        --将输入框发来的消息记为常用语
        chatDataMgr.UpdateQuickTalkInfo(chatMsg, params)
    end
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
    return true
end
--@Description:聊天使用（超链接Pack信息存储于linkInputMgr情况）
function SendChatMsgSimple(uid, chatMsg, channel, lineType, fromInputField)
    --内容为空
    if chatMsg == "" then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("CHAT_TIP_NO_CONTEXT"))
        return false
    end
    local l_msg, l_args = MgrMgr:GetMgr("LinkInputMgr").ReplaceSendMsg(chatMsg)
    local l_sendSuc = sendChatMsgInner(uid, l_msg, channel, l_args, lineType, fromInputField)
    return l_sendSuc
end
--@Description:发送聊天消息
--@param:超连接参数
function SendChatMsg(uid, chatMsg, channel, params, lineType, fromInputField)
    --内容为空
    if chatMsg == "" then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("CHAT_TIP_NO_CONTEXT"))
        return false
    end
    local l_sendSuc = sendChatMsgInner(uid, chatMsg, channel, params, lineType, fromInputField)
    return l_sendSuc
end
--发送语音消息 -发送者ID
function SendAudioMsg(uid, audioID, translate, length, channel, lineType)
    --发送条件
    if not CanSendMsg(channel) then
        return false
    end
    chatDataMgr.SetSendChatContentCD(channel, chatDataMgr.GetSendChatContentConfigCD(channel))

    --发送新的聊天消息
    local l_msgId = Network.Define.Rpc.SendChatMsg
    ---@type SendChatMsgArg
    local l_sendInfo = GetProtoBufSendTable("SendChatMsgArg")
    l_sendInfo.msg.msg_head.msg_type = channel
    l_sendInfo.msg.msg_head.sender_uid = MoonCommonLib.StringEx.ConverToString(uid)
    l_sendInfo.msg.medium = ChatMediumType.ChatMediumTypeAudio
    l_sendInfo.msg.audio.audio_id = audioID
    l_sendInfo.msg.audio.text = translate
    l_sendInfo.msg.audio.duration = length

    if lineType ~= nil then
        l_sendInfo.msg.msg_head.preview_type = lineType
    end

    Network.Handler.SendRpc(l_msgId, l_sendInfo)
    return true
end
--endregion

--region-----------------------------照相任务-----------------------
--发送任务求助
function SendTaskPhotoChat(pid)
    --发送新的聊天消息
    local l_msgId = Network.Define.Rpc.SendGuildAid
    ---@type SendGuildAidArg
    local l_sendInfo = GetProtoBufSendTable("SendGuildAidArg")
    l_sendInfo.msg.msg_head.msg_type = chatDataMgr.EChannel.GuildChat
    l_sendInfo.msg.msg_head.sender_uid = tostring(MPlayerInfo.UID)
    local l_data = l_sendInfo.msg.extra_param:add()
    l_data.type = ChatHrefType.TaskPhoto
    l_data.param32:add().value = pid
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end
function OnSendGuildAid(msg)
    ---@type SendGuildAidRes
    local l_resInfo = ParseProtoBufToTable("SendGuildAidRes", msg)
    if l_resInfo.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_resInfo.result))
    end

    local l_cd = tonumber(l_resInfo.residue_chat_cd)
    if l_cd == nil or l_cd <= 0 then
        taskPhotoNextTime = nil
    else
        taskPhotoNextTime = Time.realtimeSinceStartup + l_cd
    end
end
--获取照片任务剩余时间
function GetTaskPhotoTime()
    local l_residueTime = (taskPhotoNextTime or 0) - Time.realtimeSinceStartup
    return math.max(l_residueTime, 0)
end
--同步聊天cd、照片任务cd时间
--目前这个cd的数据没有落地，下线上线cd归0，有bug单给小志
function OnChatCDNotify(msg)
    ---@type ChatCDNotifyData
    local l_resInfo = ParseProtoBufToTable("ChatCDNotifyData", msg)
    if l_resInfo.chat_cd and #l_resInfo.chat_cd > 0 then
        for i = 1, #l_resInfo.chat_cd do
            local l_info = l_resInfo.chat_cd[i]
            chatDataMgr.SetSendChatContentCD(l_info.type, tonumber(l_info.residue_chat_cd))
        end
    end
    if l_resInfo.aid_cd and #l_resInfo.aid_cd > 0 then
        if #l_resInfo.aid_cd >= 1 then
            taskPhotoNextTime = tonumber(l_resInfo.aid_cd[1].residue_chat_cd)
        end
    end
end
--endregion

--region -----------------------------通用方法--------------------
---@param msgPack ChatMsgPack
---@param nameCom MoonClient.MLuaUICom @名字组件
---@param permissionCom MoonClient.MLuaUICom @权限组件
---@param tagCom MoonClient.MLuaUICom @标签组件
---@param headParent UnityEngine.Transform @头像组件父Transform
function SetSelfChatMsg(msgPack, nameCom, permissionCom, tagCom)
    if msgPack == nil then
        return
    end

    --玩家名
    if not MLuaCommonHelper.IsNull(nameCom) then
        nameCom.LabText = MPlayerInfo.Name
    end

    --公会职称
    if not MLuaCommonHelper.IsNull(permissionCom) then
        local l_guildData = DataMgr:GetData("GuildData")
        permissionCom:SetActiveEx(false)
        if MgrMgr:GetMgr("GuildMgr").IsSelfHasGuild() and l_guildData.GetSelfGuildPosition() <= l_guildData.EPositionType.Deacon then
            local l_showPermission = msgPack.channel == EChannel.GuildChat
            permissionCom:SetActiveEx(l_showPermission)
            local l_Permission = l_guildData.GetPositionName(l_guildData.GetSelfGuildPosition()) or ""
            l_Permission = StringEx.Format("[{0}]", l_Permission)
            permissionCom.LabText = l_Permission
        end
    end
    -- 标签处理
    if not MLuaCommonHelper.IsNull(tagCom) then
        MgrMgr:GetMgr("RoleTagMgr").SetTag(tagCom, DataMgr:GetData("RoleTagData").GetActiveTagId())
    end
    --已读消息
    MgrMgr:GetMgr("ChatMgr").ReadChat(msgPack)
end
---@param msgPack ChatMsgPack
---@param clickIconCom MoonClient.MLuaUICom @头像点击组件
---@param clickHeadCallBack function @头像点击回调
---@param professionCom MoonClient.MLuaUICom @职业组件
---@param levelCom MoonClient.MLuaUICom @等级组件
---@param nameCom MoonClient.MLuaUICom @名字组件
---@param permissionCom MoonClient.MLuaUICom @权限组件
---@param tagCom MoonClient.MLuaUICom @标签处理
---@param headParent UnityEngine.Transform @头像组件父Transform
function SetOtherChatMsg(msgPack, clickIconCom, clickHeadCallBack, nameCom, permissionCom, tagCom)
    if msgPack == nil then
        return
    end
    --头像点击相关
    if not MLuaCommonHelper.IsNull(clickIconCom) then
        clickIconCom:AddClick(function()
            MgrMgr:GetMgr("TeamMgr").OnSelectPlayer(msgPack.playerInfo.uid, msgPack.playerInfo)
            if clickHeadCallBack then
                clickHeadCallBack(msgPack)
            end
        end, true)
    end

    --玩家名
    if not MLuaCommonHelper.IsNull(nameCom) then
        nameCom.LabText = msgPack.playerInfo.name
    end

    --公会职称
    if not MLuaCommonHelper.IsNull(permissionCom) then
        permissionCom:SetActiveEx(false)
        if msgPack.playerInfo.data.guild_permission ~= nil then
            local l_showPermission = msgPack.channel == EChannel.GuildChat
            l_showPermission = l_showPermission and (msgPack.playerInfo.data.guild_permission <= 4) and (msgPack.playerInfo.data.guild_permission > 0)
            permissionCom:SetActiveEx(l_showPermission)
            local l_Permission = DataMgr:GetData("GuildData").GetPositionName(msgPack.playerInfo.data.guild_permission) or ""
            l_Permission = StringEx.Format("[{0}]", l_Permission)
            permissionCom.LabText = l_Permission
        end
    end
    -- 标签处理
    if not MLuaCommonHelper.IsNull(tagCom) then
        MgrMgr:GetMgr("RoleTagMgr").SetTag(tagCom, msgPack.playerInfo.tag)
    end
    --已读消息
    MgrMgr:GetMgr("ChatMgr").ReadChat(msgPack)
end

---@param tagID number
---@param bgGo MoonClient.MLuaUICom
---@param tagBgGo MoonClient.MLuaUICom
---@param tagLvGo MoonClient.MLuaUICom
function UpdateChatTag(tagID, bgGo, tagBgGo, tagLvGo)
    if nil == bgGo or nil == tagBgGo or nil == tagLvGo then
        return
    end
    if tagID == 0 then
        bgGo:SetActiveEx(false)
        tagBgGo:SetActiveEx(false)
        tagLvGo:SetActiveEx(false)
        return
    end
    local l_chatTagMgr = MgrMgr:GetMgr("ChatTagMgr")
    local l_chatTagData = l_chatTagMgr.GetDataByID(tagID)
    if nil == l_chatTagData then
        logError("[ChatLine] invalid tag id: " .. tostring(tagID))
        return
    end

    local showTag = not string.ro_isEmpty(l_chatTagData.config.Icon)
    bgGo:SetActiveEx(showTag)
    if not showTag then
        return
    end

    bgGo:SetSpriteAsync(l_chatTagData.config.Atlas, l_chatTagData.config.Icon, nil, false)
    local showTagLv = not string.ro_isEmpty(l_chatTagData.config.Grade)
    local showColor = not string.ro_isEmpty(l_chatTagData.config.Color)
    tagBgGo:SetActiveEx(showTagLv)
    tagLvGo:SetActiveEx(showTagLv)
    if not showTagLv then
        return
    end

    tagLvGo.LabText = l_chatTagData.config.Grade
    if not showColor then
        return
    end

    local bgColor = CommonUI.Color.Hex2Color(l_chatTagData.config.Color)
    tagBgGo.Img.color = bgColor
end

---@param headParentTrans UnityEngine.Transform
function DestroyHeadObj(headParentTrans)
    if MLuaCommonHelper.IsNull(headParentTrans) then
        return
    end
    if headParentTrans.childCount > 1 then
        MResLoader:DestroyObj(headParentTrans:GetChild(0).gameObject)
    end
end

--endregion

--region----------------------------系统设置-------------------------
--系统设置变化
function OnSystemIndexChange()
    EventDispatcher:Dispatch(chatDataMgr.EEventType.SystemIndexChange)
end
--聊天设置变化
function OnChatSettingIndexChange()
    EventDispatcher:Dispatch(chatDataMgr.EEventType.ChatSettingIndexChange)
end
--endregion

--region-----------------------------读取信息------------------------
--清除某人所有的聊天记录
function OnChatMsgClearNtf(msg)
    ---@type UserID
    local l_resInfo = ParseProtoBufToTable("UserID", msg)
    local l_rid = l_resInfo.uid
    local l_channels = {
        chatDataMgr.EChannel.TeamChat, --队伍s
        chatDataMgr.EChannel.GuildChat, --工会
        chatDataMgr.EChannel.CurSceneChat, --附近
        chatDataMgr.EChannel.WorldChat, --世界
        chatDataMgr.EChannel.AllChat, --所有-迷你框
    }

    local l_removeAllCount = 0
    for i = 1, #l_channels do
        local l_channel = l_channels[i]
        local l_newQueue = Common.queue.LinkedListQueue.create()
        local l_queue = chatDataMgr.GetChannelCache(l_channel)
        local l_removeCount = 0
        while l_queue:size() > 0 do
            local l_msg = l_queue:dequeue()
            if l_msg.uid == l_rid then
                l_removeCount = l_removeCount + 1
                l_removeAllCount = l_removeAllCount + 1
            else
                l_newQueue:enqueue(l_msg)
            end
        end
        chatDataMgr.SetChannelCache(l_newQueue)
        if l_removeCount > 0 then
            EventDispatcher:Dispatch(chatDataMgr.EEventType.ClearChannelChat, l_channel)
        end
    end

    if l_removeAllCount > 0 then
        EventDispatcher:Dispatch(chatDataMgr.EEventType.ClearChat)
    end
end
--已读消息
function ReadChat(msgPack)
    if msgPack.isRed then
        return
    end
    msgPack.isRed = true
    EventDispatcher:Dispatch(chatDataMgr.EEventType.MsgRead, msgPack)
    --EventDispatcher:Dispatch(EventType.RedChannelNewChat,channel,msgPack)
end
--endregion

--region --------------------其他--------------------------
--置顶消息列表
chatNewsZdTable = {}
function SetChatZDNewsMessage(channel, text, duration, otherInfo, announceData, l_extraLinkData)
    if chatNewsZdTable[channel] == nil then
        chatNewsZdTable[channel] = {}
    end
    local l_newTimer = chatNewsZdTable[channel].zdNewsTimer
    if l_newTimer then
        l_newTimer:Stop()
        l_newTimer = nil
    end
    l_newTimer = Timer.New(function()
        chatNewsZdTable[channel].zdNewsTimer = nil
        EventDispatcher:Dispatch(chatDataMgr.EEventType.ECloseZDNews)
    end, duration, 1)
    l_newTimer:Start()
    chatNewsZdTable[channel].zdNewsTimer = l_newTimer
    chatNewsZdTable[channel].zdNewsText = text or "Msg is Nil"
    chatNewsZdTable[channel].otherInfo = otherInfo
    chatNewsZdTable[channel].announceData = announceData
    chatNewsZdTable[channel].l_extraLinkData = l_extraLinkData
end

--非置顶但是系统点赞消息列表
chatNewsLikesTable = {}
function SetChatLikesNewsMessage(text, otherInfo, announceData, l_extraLinkData)
    if chatNewsLikesTable[text] == nil then
        chatNewsLikesTable[text] = {}
    end
    chatNewsLikesTable[text].zdNewsText = text or "Msg is Nil"
    chatNewsLikesTable[text].otherInfo = otherInfo
    chatNewsLikesTable[text].announceData = announceData
    chatNewsLikesTable[text].l_extraLinkData = l_extraLinkData
end
--endregion
return ModuleMgr.ChatMgr
