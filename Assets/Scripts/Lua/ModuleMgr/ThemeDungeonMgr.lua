---
--- Created by husheng.
--- DateTime: 2018/2/28 15:38
--- 主题副本
---
---@module ModuleMgr.ThemeDungeonMgr
module("ModuleMgr.ThemeDungeonMgr", package.seeall)

require "ModuleMgr/CommonMsgProcessor"

EventDispatcher = EventDispatcher.new()
EventType = {
    ThemeDungeonUIClosed = 1, -- 主题副本界面关闭
    ThemeDungeonInfoChanged = 2, -- 主题副本信息刷新
}

---@type ThemeDungeonData
themeDungeonData = DataMgr:GetData("ThemeDungeonData")

local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")

-- 上一次的点击操作时间
function OnLastStampCommonData(_, value)
    themeDungeonData.lastOpenStamp = value
end

--------------------------------------------生命周期接口--Start----------------------------------
function OnInit()
    gameEventMgr.Register(gameEventMgr.OnBagUpdate, _onItemUpdate)

    ---@type CommonMsgProcessor
    local l_commonData = Common.CommonMsgProcessor.new()
    local l_data1 = {}
    table.insert(l_data1, {
        ModuleEnum = CommondataType.kCDT_NORMAL,
        DetailDataEnum = CommondataId.kCDI_THEME_DUNGEON_STAMP,
        Callback = OnLastStampCommonData,
    })

    l_commonData:Init(l_data1)
    local l_lifeProMgr = MgrMgr:GetMgr("LifeProfessionMgr")
    l_lifeProMgr.EventDispatcher:Add(l_lifeProMgr.EventType.CollectOver, function(_, classID)
        if classID == MgrMgr:GetMgr("OpenSystemMgr").eSystemId.ThemeDungeon then
            OnNpcSelect()
        end
    end, ModuleMgr.ThemeDungeonMgr)
end

function OnUnInit()
    local l_lifeProMgr = MgrMgr:GetMgr("LifeProfessionMgr")
    l_lifeProMgr.EventDispatcher:RemoveObjectAllFunc(l_lifeProMgr.EventType.CollectOver, ModuleMgr.ThemeDungeonMgr)
end

--------------------------------------------生命周期接口--End----------------------------------


-------------------------------------------协议处理--Start----------------------------------
-- 登陆消息处理
function OnSelectRoleNtf(msg)

    themeDungeonData.OnSelectRoleNtf(msg)
end

-- 获取主题副本信息
function RequestGetThemeDungeonInfo()
    ---@type GetThemeDungeonInfoArg
    local l_sendInfo = GetProtoBufSendTable("GetThemeDungeonInfoArg")
    Network.Handler.SendRpc(Network.Define.Rpc.GetThemeDungeonInfo, l_sendInfo)
end

function OnGetThemeDungeonInfo(msg)
    ---@type GetThemeDungeonInfoRes
    local l_info = ParseProtoBufToTable("GetThemeDungeonInfoRes", msg)
    if l_info.result ~= ErrorCode.ERR_SUCCESS then
        if l_info.result ~= ErrorCode.ERR_SYSTEM_NOT_OPEN then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        end
        return
    end

    -- 挑战玩法未开启
    if not TableUtil.GetThemeDungeonTable().GetRowByThemeDungeonID(l_info.theme_id, true) then
        return
    end

    themeDungeonData.curThemeId = l_info.theme_id
    themeDungeonData.lastRefreshTime = l_info.last_refresh_time
    themeDungeonData.nextRefreshTime = l_info.next_refresh_time

    for i = 1, #l_info.dungeons do
        themeDungeonData.dungeonAffix[l_info.dungeons[i].dungeon_id] = {}
        for j = 1, #l_info.dungeons[i].affix_ids do
            table.insert(themeDungeonData.dungeonAffix[l_info.dungeons[i].dungeon_id], l_info.dungeons[i].affix_ids[j].value)
        end
    end

    EventDispatcher:Dispatch(EventType.ThemeDungeonInfoChanged)
end

-- 副本奖励,助战,助战黑盒
function UpdateRewardItem(normalResult,extraResult)
    themeDungeonData.RefreshDungeonRewardItem()
    themeDungeonData.UpdateRewardItem(normalResult,extraResult)
end

-- 副本结算
function OnDungeonsResult(msg)
    ---@type DungeonsResultData
    local l_info = ParseProtoBufToTable("DungeonsResultData", msg)

    local l_DungeonInfo = TableUtil.GetDungeonsTable().GetRowByDungeonsID(l_info.dungeons_id)
    local l_singleDungeon = isSingleThemeDungeon(MPlayerInfo.PlayerDungeonsInfo.DungeonType)

    if l_info.status == DungeonsResultStatus.kResultVictory then
        onVictory(l_info, l_DungeonInfo, l_singleDungeon)
    elseif l_info.status == DungeonsResultStatus.kResultLose then
        onLose(l_DungeonInfo)
    end

    local l_rlt = (l_DungeonInfo.EnterType == 1) or l_singleDungeon or getMemberNumLimit(l_DungeonInfo)
    themeDungeonData.SinglePlayerDungeon = l_rlt
end

-- 发送点赞
function SendDungeonsEncourage(roleId)
    local l_msgId = Network.Define.Ptc.DungeonsEncourage
    ---@type DungeonsEncourageData
    local l_sendInfo = GetProtoBufSendTable("DungeonsEncourageData")
    l_sendInfo.dest_role_id = roleId
    Network.Handler.SendPtc(l_msgId, l_sendInfo)
end

-- 挑战副本战前确认
function ShareChallengeConfirm(dungeonId, hardLevel)
    local selfInTeam, selfIsCaptain = DataMgr:GetData("TeamData").GetPlayerTeamInfo()
    if not selfInTeam or not selfIsCaptain then
        return
    end

    local l_dungeonName = ""
    local l_dungeonRow = TableUtil.GetDungeonsTable().GetRowByDungeonsID(dungeonId)
    if l_dungeonRow then
        l_dungeonName = l_dungeonRow.DungeonsName
    end

    local l_msg, l_msgParam = MgrMgr:GetMgr("LinkInputMgr").GetThemeChallengeConfirmPack("", l_dungeonName, dungeonId, hardLevel)
    local l_isSendSucceed = MgrMgr:GetMgr("ChatMgr").SendChatMsg(MPlayerInfo.UID, l_msg, DataMgr:GetData("ChatData").EChannel.TeamChat, l_msgParam)
    if l_isSendSucceed then

    end
end

function OnShareChallengeConfirmClicked(dungeonId, hardLevel)
    if MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.ThemeChallenge) then
        UIMgr:ActiveUI(UI.CtrlNames.Theme_Challenge, { themeDungeonId = themeDungeonData.curThemeId })
        UIMgr:ActiveUI(UI.CtrlNames.Theme_Confirmation, { dungeonId = dungeonId, hardLevel = hardLevel, isFromHref = true })
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("THEME_CHALLENGE_NOT_OPEN"))
    end
end

-- 请求周奖励
function RequestGetThemeWeekAward(isPreview, callback, notNeedTips)

    local l_msgId = Network.Define.Rpc.GetThemeDungeonWeeklyAward
    ---@type GetThemeDungeonWeeklyAwardArg
    local l_sendInfo = GetProtoBufSendTable("GetThemeDungeonWeeklyAwardArg")
    l_sendInfo.real_get = not isPreview
    Network.Handler.SendRpc(l_msgId, l_sendInfo, { callback = callback, notNeedTips = notNeedTips })
end

-- 周奖励消息处理
function OnRequestGetThemeWeekAward(msg, sendArg, params)
    ---@type GetThemeDungeonWeeklyAwardRes
    local l_info = ParseProtoBufToTable("GetThemeDungeonWeeklyAwardRes", msg)
    if l_info.error ~= 0 then
        if params and params.notNeedTips then
            return
        end
        local l_content
        if l_info.error == ErrorCode.ERR_NO_THEME_DUNGEON_WEEK_AWARD then
            local l_weekAwardCount, l_weekAwardLimit = GetWeekAwardCountAndLimit()
            l_content = Lang("THEMEDUNGEON_ERR_FORMAT1", math.min(l_weekAwardCount, l_weekAwardLimit), l_weekAwardLimit)
        elseif l_info.error == ErrorCode.ERR_THEME_DUNGEON_WEEK_AWARD_WAIT then
            l_content = Lang("THEMEDUNGEON_ERR_FORMAT2")
        end

        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_content or Common.Functions.GetErrorCodeStr(l_info.error))
        return
    end

    if (not sendArg.real_get) and l_info.can_award and params and params.callback then
        params.callback()
        return
    end

    PlayGetRewardAnim()
end

local C_VALID_REASON_MAP = {
    [ItemChangeReason.ITEM_REASON_THEMESTORY_RESULT] = 1,
    [ItemChangeReason.ITEM_REASON_DUNGEONS_RESULT] = 1,
    [ItemChangeReason.ITEM_REASON_HYMN_TRIAL] = 1,
    [ItemChangeReason.ITEM_REASON_TOWER_RESULT] = 1,
    [ItemChangeReason.ITEM_REASON_BATTLE_RESULT] = 1,
    [ItemChangeReason.ITEM_REASON_THEME_RESULT] = 1,
    [ItemChangeReason.ITEM_REASON_PLATFORM_RESULT] = 1,
    [ItemChangeReason.ITEM_REASON_HERO_CHALLENGE_RESULT] = 1,
    [ItemChangeReason.ITEM_REASON_TOWER_DEFENSE_DUNGEON] = 1,
    [ItemChangeReason.ITEM_REASON_GUILD_HUNT_DUNGEONS] = 1,
    [ItemChangeReason.ITEM_REASON_MAZE_DUNGEONS] = 1,
    [ItemChangeReason.ITEM_REASON_HYMN_TRIAL] = 1,
    [ItemChangeReason.ITEM_REASON_ASSIST] = 1,
    [ItemChangeReason.ITEM_REASON_ASSIST_SPECIAL] = 1,
    [ItemChangeReason.ITEM_REASON_ASSIST_HUILIU] = 1,
    [ItemChangeReason.ITEM_REASON_ASSIST_MENGXIN] = 1,
    [ItemChangeReason.ITEM_REASON_ASSIST_XIAOHAO] = 1,
}


---@param itemUpdateDataList ItemUpdateData[]
function _onItemUpdate(itemUpdateDataList)
    if nil == itemUpdateDataList then
        logError("[ThemeDungeonMgr] invalid param")
        return
    end

    --- log不能删除，可能要确定服务器是不是正确的reason
    local l_weekCache = {}
    local l_dungeonRewards = {}
    for i = 1, #itemUpdateDataList do
        local singleUpdateData = itemUpdateDataList[i]
        -- logError(tostring(singleUpdateData.Reason) .. " " .. tostring(singleUpdateData:GetItemCompareData().id))
        if ItemChangeReason.ITEM_REASON_DUNGEON_WEEK == singleUpdateData.Reason then
            table.insert(l_weekCache, singleUpdateData)
        elseif ItemChangeReason.ITEM_REASON_GUILD_HUNT_DUNGEONS == singleUpdateData.Reason then
            table.insert(l_dungeonRewards, singleUpdateData)
        end
    end
    themeDungeonData.UpdateRewardItemFromPropUpdate(l_dungeonRewards)
    themeDungeonData.OnItemChange(l_weekCache)
end

---@param info AwardsInfo[]
function UpdateAwardsInfo(awardsInfo)
    if awardsInfo==nil then
        return
    end

    local dungeonResult = {}
    local dungeonExtraResult = {}
    for i=1 ,#awardsInfo do
        ---@type AwardsInfo
        local l_awardInfo = awardsInfo[i]
        if ItemChangeReason.ITEM_REASON_DUNGEON_WEEK == l_awardInfo.reason then
            table.insert(weekCache, singleUpdateData)
        elseif ItemChangeReason.ITEM_REASON_SPECIAL_ITEM_EXTRA == l_awardInfo.reason then
            table.insert(dungeonExtraResult, l_awardInfo)
        elseif nil ~= C_VALID_REASON_MAP[l_awardInfo.reason] then
            --- log不能删除，可能要确定服务器是不是正确的reason
            --logError(tostring(singleUpdateData.Reason) .. " " .. tostring(singleUpdateData:GetItemCompareData().id))
            table.insert(dungeonResult, l_awardInfo)
        end
    end
    UpdateRewardItem(dungeonResult,dungeonExtraResult)
end
-------------------------------------------协议处理--End----------------------------------

-------------------------------------------其他接口--Start----------------------------------

-- 获取副本前缀
function GetDungeonAffix(dungeonId)
    return themeDungeonData.dungeonAffix[dungeonId] or {}
end

-- 当前副本是否已通关
function IsDungeonPassed(dungeonId)
    return nil ~= themeDungeonData.passedDungeons[dungeonId]
end

-- 设置奖励状态
function SetIsThemeDungeonReward(state)
    themeDungeonData.IsThemeDungeonReward = state
end

-- 缓存邮件奖励(显示用)
function SetRewardItemsMail(rewadItems)
    if themeDungeonData.IsThemeDungeonReward then
        themeDungeonData.CachedRewardItemFromMail = rewadItems
    end
end

-- 清理奖励缓存
function ClearRewardItemsMail()
    themeDungeonData.CachedRewardItemFromMail = {}
end

-- 获取奖励缓存
function GetAllRewardItems()
    return themeDungeonData.GetAllRewardItems()
end

-- 是否是单人副本
function isSingleThemeDungeon(dungeonType)
    local l_dungeonTypeConst = MgrMgr:GetMgr("DungeonMgr").DungeonType
    if dungeonType == l_dungeonTypeConst.DungeonHymn or
            dungeonType == l_dungeonTypeConst.DungeonTask or
            dungeonType == l_dungeonTypeConst.DungeonMaze or
            dungeonType == l_dungeonTypeConst.DungeonGuildHunt then
        return true
    end

    return false
end

-- 副本人数是单人
function getMemberNumLimit(dungeonRow)

    if dungeonRow.NumbersLimit then
        local l_value = Common.Functions.SequenceToTable(dungeonRow.NumbersLimit)
        if l_value and l_value[2] == 1 then
            return true
        end
    end

    return false
end

-- 胜利处理
function onVictory(info, dungeonRow, isSingle)
    local l_dungeonMgr = MgrMgr:GetMgr("DungeonMgr")
    l_dungeonMgr.DungeonResultTime = tonumber(tostring(MServerTimeMgr.UtcSeconds))
    l_dungeonMgr.DungeonRemainTime = dungeonRow.TimeToKick
    themeDungeonData.OnDungeonsResult(info, dungeonRow.DungeonsType)
    UIMgr:ActiveUI(UI.CtrlNames.ThemeDungeonResult)

    -- 助战不算通关
    if not info.is_assist and not MgrMgr:GetMgr("WatchWarMgr").IsInSpectator() then
        
        themeDungeonData.SetDungeonPassed(info.dungeons_id)
    end

    if isSingle then
        themeDungeonData.DumpSceneRoleInfo(tostring(MPlayerInfo.UID))
    end
end

-- 失败处理
function onLose(dungeonRow)

    local l_dungeonMgr = MgrMgr:GetMgr("DungeonMgr")

    l_dungeonMgr.DungeonResultTime = tonumber(tostring(MServerTimeMgr.UtcSeconds))
    l_dungeonMgr.DungeonRemainTime = dungeonRow.TimeToKickDefeat
    UIMgr:ActiveUI(UI.CtrlNames.HeroChallengeResult, function(ctrl)
        ctrl:ShowLoseTween()
    end)
    if l_dungeonMgr.DungeonRemainTime > 0 then
        local l_data =
        {
            startTime = MServerTimeMgr.UtcSeconds,
            remainTime = l_dungeonMgr.DungeonRemainTime
        }
        UIMgr:ActiveUI(UI.CtrlNames.CountDown, l_data)
    end
end

-- 采集物处理
function OnSelectCollectionEvent(id)
    OnNpcSelect()
end

-- npc选择处理
function OnNpcSelect()
    if MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.ThemeDungeon) then
        MgrMgr:GetMgr("SystemFunctionEventMgr").ThemeDungeonEvent()
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("THEME_DUNGEON_NOT_OPEN"))
    end
end

-- 碰撞盒选择
function OnBoxSelect()
    local l_npcEntity = MNpcMgr:FindNpcInViewport(ThemeDungeonBoxId)
    if l_npcEntity then
        l_npcEntity.Model.Layer = MLayer.ID_NPC
    end

    if MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.ThemeDungeon) then
        RequestGetThemeWeekAward()
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("THEME_DUNGEON_NOT_OPEN"))
    end
end

-- 播放周奖励界面
function PlayGetRewardAnim()

    UIMgr:ActiveUI(UI.CtrlNames.ThemeDungeonReward)
end

-- 主题副本是否锁定
function IsThemeDungeonLocked(themeId, notShowTips)
    -- 标题
    local l_themeDungeonRow = TableUtil.TableUtil.GetThemeDungeonTable().GetRowByThemeDungeonID(themeId)

    local l_lock = (MPlayerInfo.Lv < l_themeDungeonRow.ChapterLevel)
    if l_lock and (not notShowTips) then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_themeDungeonRow.ThemeName .. Lang("LifeProfession_LockLevel", l_themeDungeonRow.ChapterLevel))
    end
    -- 前置关卡解锁
    if not l_lock then
        if l_themeDungeonRow.ThemeID ~= 1 then
            local l_preRow
            for _, v in pairs(TableUtil.GetThemeDungeonTable().GetTable()) do
                if v.ThemeID == (l_themeDungeonRow.ThemeID - 1) then
                    l_preRow = v
                    break
                end
            end
            if l_preRow then
                if not IsDungeonPassed(l_preRow.DungeonID) then
                    l_lock = true
                    if not notShowTips then
                        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("THEME_DUNGEON_PRE_PASS_NEED", l_preRow.ThemeName))
                    end
                end
            else
                logError("IsThemeDungeonLocked error, cannot find pre themedungeon", l_themeDungeonRow.ThemeID)
            end
        end
    end

    return l_lock
end

-- 去npc处领奖励
function JudgeThemeAward()
    RequestGetThemeWeekAward(true, function()
        -- UIMgr:DeActiveUI(UI.CtrlNames.ThemeArround)
        UIMgr:DeActiveUI(UI.CtrlNames.ThemeDungeonArround)
        MgrMgr:GetMgr("NpcMgr").GotoNpc(nil, 57, themeDungeonData.ThemeDungeonBoxId)
    end)
end

-- 显示缓存的周奖励
function ShowDungeonWeekAwardNotice()
    local l_cachedDungeonWeekAward = themeDungeonData.CachedDungeonWeekAward
    if nil == l_cachedDungeonWeekAward then
        return
    end

    _showSpecialTips(l_cachedDungeonWeekAward)
    themeDungeonData.CachedDungeonWeekAward = nil
end

--- 对于能够显示特殊道具提示的道具需要显示特殊提示
---@param itemUpdateDataList ItemUpdateData[]
function _showSpecialTips(itemUpdateDataList)
    if nil == itemUpdateDataList then
        logError("[ThemeDungeonMgr] invalid param")
        return
    end

    for i = 1, #itemUpdateDataList do
        local singleUpdateData = itemUpdateDataList[i]
        local compareData = singleUpdateData:GetItemCompareData()
        local targetItem = singleUpdateData:GetNewOrOldItem()
        if 0 < compareData.count then
            _showAcquireItemTips(compareData.id, compareData.count)
            if targetItem:CanShowSpecialTips() then
                MgrMgr:GetMgr("TipsMgr").ShowSpecialItemTips(compareData.id, compareData.count)
            end
        end
    end
end

--- 获得道具之后的提示
function _showAcquireItemTips(itemId, itemCount)
    local l_opt = {
        itemId = itemId,
        itemOpts = { num = itemCount, icon = { size = 18, width = 1.4 } },
    }

    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_opt)
end

-------------------------------------------其他接口--End----------------------------------

return ModuleMgr.ThemeDungeonMgr