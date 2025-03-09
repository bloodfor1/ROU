--公告/消息/提示分发管理
module("ModuleMgr.MessageRouterMgr", package.seeall)

EMessageRouterType = {
    SubNotice = 1, --底部公告
    MainNotice = 2, --重要公告
    GMNotice = 3, --底部重复公告
    DungeonNotice = 20, --副本提示
    DungeonPrompt = 21, --副本提示，NoticeMgr协议消息
    DungeonHint = 22, --第一次进入副本提示

    DungeonHintOnceWarning = 23, --副本单次警告提示
    DungeonHintLastWarning = 24, --副本持续警告提示
    DungeonHintOnceAuxiliary = 25, --副本单次辅助提示
    DungeonHintLastAuxiliary = 26, --副本持续辅助提示
    DungeonHintAside = 27, --副本旁白

    System = 51, --系统（聊天框）
    SystemPrivate = 52, --个人（聊天框）
    SystemHelp = 53, --帮助（聊天框）
    SystemHint = 54, --提示（聊天框）
    SystemHorseLmp = 55, --特殊的跑马灯

    Team = 61, --组队（聊天框）
    Guide = 62, --公会（聊天框）
    GuildHINT = 621, --公会系统提示（聊天框）

    FriendDialog = 63, --好友对话框提示
    FriendPortrait = 64, --好友头像消息
    WorldSystem = 65, --世界系统消息（聊天框）

    Achievement = 66, --成就相关（聊天框）
    WorldHint = 70,  --世界频道暗示
}

EModelType = {
    NpcID = 1,
    EntityID = 2,
}

chatMgr = MgrMgr:GetMgr("ChatMgr")
chatDataMgr = DataMgr:GetData("ChatData")

function OnEnterScene(sceneId)
    -- 关闭提示信息
    UIMgr:DeActiveUI(UI.CtrlNames.DungeonHintNormal)
end


function OnMessageFromClient(luaType, id)
    OnMessage(id)
end

-- 消息提示
-- @param id MessageTable
-- @param maskType，所需屏蔽的消息类型
-- @param announceData服务器传过来的数据结构,默认为空
-- @param ...表中数据的额外参数
-- @return
function OnMessage(id, maskType, announceData, ...)
    --l_msgData GetMessageTable的表数据
    --l_content 解析后的文本信息
    --l_params 附带参数信息
    --l_localArgs 附加数据
    --l_extraLinkData 额外数据
    local l_msgData,l_content,l_params,l_localArgs,l_extraLinkData = GetMessageContent(id, maskType, announceData, ...)
    if not l_msgData then return false end
    local EChannelSys = chatDataMgr.EChannelSys
    local EChannel = chatDataMgr.EChannel

    --------------置顶消息的特殊处理--------------------------------
    local l_isExist,l_guildNewsData = MgrMgr:GetMgr("GuildMgr").GetGuildNewsMessageData(id)
    local l_zdTime = 0
    --置顶消息
    if l_isExist and l_guildNewsData.ZDorNot == 1 and announceData.type ~= DataMgr:GetData("GuildData").GUILD_NEWS_BASIC_TYPE then
        l_content = MgrMgr:GetMgr("LinkInputMgr").PackToTag(l_content, l_params, true)
        if l_guildNewsData.IsGood == 1 then
            l_content = l_content..Lang("GUILD_LAKE")
        end
        chatMgr.SetChatZDNewsMessage(EChannel.GuildChat,l_content,l_guildNewsData.ZDTime or 10,l_guildNewsData,announceData,l_extraLinkData)
        l_zdTime = l_guildNewsData.ZDTime
    --不置顶消息
    elseif l_isExist and l_guildNewsData.IsGood == 1 then
        --如果是点赞转发到这里的 需要附议的消息
        if announceData.type == DataMgr:GetData("GuildData").GUILD_NEWS_BASIC_TYPE then 
            l_content = l_content.."\n"..announceData.agreeText..Lang("GUILD_AGREE",announceData.replaceText,announceData.senderUid or "")
            MgrMgr:GetMgr("GuildMgr").SendGuildLakeToGuildChat(l_content,announceData,l_extraLinkData)
            return
        else
            chatMgr.SetChatLikesNewsMessage(l_content,l_guildNewsData,announceData,l_extraLinkData)
            l_content = l_content..Lang("GUILD_LAKE")
        end
    end
    ---------------------------------------------------------------

    --多个显示类型
    local l_types = Common.Functions.VectorToTable(l_msgData.Type)
    for i = 1, #l_types do
        local l_type = l_types[i]
        local l_id = id
        local l_tabData = TableUtil.GetMessageTable().GetRowByID(l_id)
        local l_param = unpack(l_localArgs)

        if maskType ~= l_type then
            --logError(StringEx.Format("id={0}, type={1}",id,l_type))
            --主要公告
            if l_type == EMessageRouterType.MainNotice then
                MgrMgr:GetMgr("TipsMgr").ShowImportantNotice(l_content)

            --底部公告
            elseif l_type == EMessageRouterType.SubNotice then
                local l_noticeContent = MgrMgr:GetMgr("LinkInputMgr").PackToTag(l_content, l_params)
                MgrMgr:GetMgr("NoticeMgr").AddSecondaryNotice(ModuleMgr.NoticeMgr.NoticeType.Award, announceData, l_msgData, l_noticeContent)

            --底部GM重复公告
            elseif l_type == EMessageRouterType.GMNotice then
                local l_noticeContent = MgrMgr:GetMgr("LinkInputMgr").PackToTag(l_content, l_params)
                MgrMgr:GetMgr("NoticeMgr").AddSecondaryNotice(ModuleMgr.NoticeMgr.NoticeType.GM, announceData, l_msgData, l_noticeContent)

            --副本提示
            elseif l_type == EMessageRouterType.DungeonNotice then
                MgrMgr:GetMgr("TipsMgr").ClearImportantNotice()
                MgrMgr:GetMgr("TipsMgr").ShowImportantNotice(l_content)

            --副本提示
            elseif l_type == EMessageRouterType.DungeonPrompt then
                if not UIMgr:IsActiveUI(UI.CtrlNames.DungenAlarm) then
                    UIMgr:ActiveUI(UI.CtrlNames.DungenAlarm, function(ctrl)
                        ctrl:ShowTips(l_id, announceData, l_param)
                    end)
                else
                    ModuleMgr.DungeonMgr.EventDispatcher:Dispatch(ModuleMgr.DungeonMgr.SHOW_DUNGEON_ALARM, id, announceData, l_param)
                end
            --副本提示23-27
            elseif l_type == EMessageRouterType.DungeonHintOnceWarning
                    or l_type == EMessageRouterType.DungeonHintLastWarning
                    or l_type == EMessageRouterType.DungeonHintOnceAuxiliary
                    or l_type == EMessageRouterType.DungeonHintLastAuxiliary
                or l_type == EMessageRouterType.DungeonHintAside then
                local l_isClose = false
                if announceData then
                    --是否关闭公告
                    l_isClose = announceData.is_close
                end
                local l_noticeContent = MgrMgr:GetMgr("LinkInputMgr").PackToTag(l_content, l_params)
                MgrMgr:GetMgr("DungeonMgr").ShowDungeonHints(l_id, l_type, l_noticeContent, l_isClose)
            --第一次进入副本的提示
            elseif l_type == EMessageRouterType.DungeonHint then
                local l_info = TableUtil.GetMessageTable().GetRowByID(id)
                if l_info then
                    local l_str = l_param == nil and l_info.Content or Common.Utils.Lang(l_info.Content, unpack(l_localArgs))
                    local l_modelType = CommonUI.ModelAlarm.ModelType.NPC
                    if announceData and announceData.outlook_id and announceData.outlook_id > 0 then
                        l_modelType = CommonUI.ModelAlarm.ModelType.Player
                    end
                    if l_info.NpcID[0] == EModelType.EntityID then
                        l_modelType = CommonUI.ModelAlarm.ModelType.Monster
                    end
                    CommonUI.ModelAlarm.ShowAlarm(l_modelType, l_info.NpcID[1], l_str, l_info.Scale, l_info.Pos, l_info.Duration)
                end
            --聊天窗系统消息
            elseif l_type == EMessageRouterType.System then
                chatMgr.SendSystemInfo(nil, l_content)
            elseif l_type == EMessageRouterType.SystemPrivate then
                chatMgr.SendSystemInfo(EChannelSys.Private, l_content)
            elseif l_type == EMessageRouterType.SystemHelp then
                chatMgr.SendSystemInfo(EChannelSys.Help, l_content)
            elseif l_type == EMessageRouterType.SystemHint then
                chatMgr.SendSystemInfo(EChannelSys.Hint, l_content)
            elseif l_type == EMessageRouterType.SystemHorseLmp then
                local l_info = TableUtil.GetMessageTable().GetRowByID(id)
                if l_info then
                    local l_str = ""
                    if l_param == nil then
                        l_str = l_info.Content
                    else
                        local l_state,l_result = pcall(Common.Utils.Lang,l_content,unpack(l_localArgs))
                        if not l_state then
                            logError("MessageRouterMgr Common.Utils.Lang有报错 MessageId："..id)
                            l_str = l_info.Content
                        else
                            l_str = l_result
                        end
                    end
                    --速度 80 方向向左 行走距离 500
                    MgrMgr:GetMgr("TipsMgr").ShowHorseLampTips(l_str, nil, 80, 1, 1)
                end
            --聊天窗组队消息
            elseif l_type == EMessageRouterType.Team then
                if DataMgr:GetData("TeamData").myTeamInfo.isInTeam then
                    local l_MsgPkg = {}
                    l_MsgPkg.channel = EChannel.TeamChat
                    l_MsgPkg.lineType = chatDataMgr.EChatPrefabType.System
                    l_MsgPkg.subType = Lang("CHAT_CHANNEL_TEAM")
                    l_MsgPkg.content = l_content
                    l_MsgPkg.showInMainChat = true
                    l_MsgPkg.showDanmu = true
                    l_MsgPkg.Param = l_params
                    chatMgr.BoardCastMsg(l_MsgPkg)
                end
            --聊天窗公会消息
            elseif l_type == EMessageRouterType.GuildHINT then
                local l_MsgPkg = {}
                l_MsgPkg.subtitlesSend = l_tabData and l_tabData.SubtitlesSend == 1 or false
                l_MsgPkg.channel = EChannel.GuildChat
                l_MsgPkg.lineType = chatDataMgr.EChatPrefabType.Hint
                l_MsgPkg.subType = Lang("CHAT_CHANNEL_GUILD")
                l_MsgPkg.content = l_content
                l_MsgPkg.showInMainChat = true
                l_MsgPkg.Param = l_params
                --如果是置顶消息 则在置顶结束后发出消息
                if l_zdTime ~= 0 then
                    local l_Timer = Timer.New(function()
                        chatMgr.BoardCastMsg(l_MsgPkg)
                    end, l_zdTime)
                    l_Timer:Start()
                else
                    chatMgr.BoardCastMsg(l_MsgPkg)
                end
            --聊天窗公会系统消息
            elseif l_type == EMessageRouterType.Guide then
                local l_MsgPkg = {}
                l_MsgPkg.subtitlesSend = l_tabData and l_tabData.SubtitlesSend == 1 or false
                l_MsgPkg.channel = EChannel.GuildChat
                l_MsgPkg.lineType = chatDataMgr.EChatPrefabType.System
                l_MsgPkg.subType = Lang("CHAT_CHANNEL_GUILD")
                l_MsgPkg.content = l_content
                l_MsgPkg.showInMainChat = true
                l_MsgPkg.Param = l_params
                if id == 62013 or id == 62014 or id == 62016 then
                    --公会参与建设超链接数据
                    local l_paras = l_localArgs
                    l_MsgPkg.guildBuildActiveId = tonumber(l_paras[#l_paras]) + tonumber(l_paras[#l_paras - 1]) * 100
                end
                l_MsgPkg.aimPlayerId = l_extraLinkData.aimPlayerId
                l_MsgPkg.guildCrystalChargeAnnounceId = l_extraLinkData.guildCrystalChargeAnnounceId
                l_MsgPkg.roomID = l_extraLinkData.roomID
                --如果是置顶消息 则在置顶结束后发出消息
                if l_zdTime ~= 0 then
                    local l_Timer = Timer.New(function()
                        chatMgr.BoardCastMsg(l_MsgPkg)
                    end, l_zdTime)
                    l_Timer:Start()
                else
                    chatMgr.BoardCastMsg(l_MsgPkg)
                end
            --好友对话框提示
            elseif l_type == EMessageRouterType.FriendDialog then
            --好友头像消息
            elseif l_type == EMessageRouterType.FriendPortrait then
            --聊天窗世界系统消息
            elseif l_type == EMessageRouterType.WorldSystem then
                local l_MsgPkg = {}
                l_MsgPkg.channel = EChannel.WorldChat
                l_MsgPkg.lineType = chatDataMgr.EChatPrefabType.System
                l_MsgPkg.subType = Lang("CHAT_CHANNEL_SYSTEM")
                l_MsgPkg.content = l_content
                l_MsgPkg.showInMainChat = true
                l_MsgPkg.showDanmu = true
                l_MsgPkg.Param = l_params
                l_MsgPkg.aimPlayerId = l_extraLinkData.aimPlayerId
                l_MsgPkg.roomID = l_extraLinkData.roomID
                chatMgr.BoardCastMsg(l_MsgPkg)
            --成就相关
            elseif l_type == EMessageRouterType.Achievement then
                --获取成就公告的频道
                local l_channels = {}
                local l_achieveMentParams = nil
                if l_params ~= nil and #l_params >=1 then
                    l_achieveMentParams = l_params[1]
                end
                if l_achieveMentParams == nil or #l_achieveMentParams == 0 or l_achieveMentParams[1].param32 == nil or #l_achieveMentParams[1].param32 == 0 or l_achieveMentParams[1].param32[1].value == nil then
                    logError("成就公告超链接数据包异常")
                    l_channels = {}
                else
                    local l_idNum = tonumber(l_achieveMentParams[1].param32[1].value)
                    l_channels = MgrMgr:GetMgr("AchievementMgr").GetChatChannelWithAchievementId(l_idNum)
                end
                for j = 1, #l_channels do
                    local l_MsgPkg = {}
                    l_MsgPkg.channel = l_channels[j]
                    l_MsgPkg.lineType = chatDataMgr.EChatPrefabType.System
                    l_MsgPkg.subType = EChannelSys.System
                    l_MsgPkg.content = l_content
                    l_MsgPkg.showInMainChat = true
                    l_MsgPkg.Param = l_params
                    l_MsgPkg.aimPlayerId = l_extraLinkData.aimPlayerId
                    --如果是置顶消息 则在置顶结束后发出消息
                    if l_zdTime ~= 0 then
                        local l_Timer = Timer.New(function()
                            chatMgr.BoardCastMsg(l_MsgPkg)
                        end, l_zdTime)
                        l_Timer:Start()
                    else
                        chatMgr.BoardCastMsg(l_MsgPkg)
                    end
                end
            elseif l_type == EMessageRouterType.WorldHint then
                local l_MsgPkg = {}
                l_MsgPkg.subtitlesSend = l_tabData and l_tabData.SubtitlesSend == 1 or false
                l_MsgPkg.channel = EChannel.WorldChat
                l_MsgPkg.lineType = l_chatDataMgr.EChatPrefabType.Hint
                l_MsgPkg.subType = Lang("CHAT_CHANNEL_WORLD")
                l_MsgPkg.content = l_content
                l_MsgPkg.showInMainChat = true
                l_MsgPkg.Param = l_params
                chatMgr.BoardCastMsg(l_MsgPkg)
            end
        end
    end
end

--获取显示文本数据
function GetMessageContent(id, maskType, announceData, ...)
    local chatMgr = MgrMgr:GetMgr("ChatMgr")
    if type(id) ~= "number" or id == -1 then
        return false
    end

    local l_msgData = TableUtil.GetMessageTable().GetRowByID(id)
    if l_msgData == nil then
        return false
    end

    if l_msgData.BaseLevel and MPlayerInfo.Lv < l_msgData.BaseLevel then
        return false
    end
    --消息内容
    local l_content = l_msgData.Title .. RoColor.FormatWord(l_msgData.Content)
    local l_params = nil
    local l_localArgs = {}
    local l_extraLinkData = {}  --额外链接用数据
    --消息中的额外参数处理
    if ... ~= nil then
        local str = { ... }
        l_content = StringEx.Format(l_content, str)
        l_params = ...
    elseif announceData then
        if announceData.announce_msg then
            for i, v in ipairs(announceData.announce_msg) do
                --announce_msg 包含 本地化字符 和 额外参数 二选一
                local l_pTemp = AnalysisAnnounceMsg(v, l_localArgs, l_extraLinkData)
                --如果得到的成就或道具数据包不为空 则赋值
                if l_pTemp then
                    l_params = l_pTemp
                end
            end
        end

        --公会新闻内容处理
        local l_finalArg = LocalArgsSet(announceData,l_localArgs)
        local l_tempContent = l_content
        ------------------
        local l_state,l_result = pcall(StringEx.Format,l_content,l_finalArg)
        if not l_state then
            logError("MessageRouterMgr String.Format有报错 MessageId："..id)
            l_content = l_tempContent
        else
            l_content = l_result
        end
    end
    l_content = MgrMgr:GetMgr("LinkInputMgr").PackToTag(l_content, l_params, true)
    return l_msgData,l_content,l_params,l_localArgs,l_extraLinkData
end

-- 解析公告的数据消息
-- @param announceMsg 服务器发来的数据体
-- @param argList 公告参数列表
-- @param extraLinkData  超链接额外参数列表
-- @return 成就或道具的数据包
function AnalysisAnnounceMsg(announceMsg, argList, extraLinkData)
    --announce_msg 包含 本地化字符 和 额外参数 二选一
    local l_params = nil
    if announceMsg.localization_name and announceMsg.localization_name.type and announceMsg.localization_name.type ~= LocalizationNameType.kLocalizationNameTypeNone then
        table.insert(argList, Lang(announceMsg.localization_name))
    elseif announceMsg.extra_param then
        local l_extraParam = announceMsg.extra_param
        if l_extraParam.type == HrefType.HREF_ACHIEVEMENT_DETAILS then
            --成就
            local l_achieveId = l_extraParam.param32[1] and l_extraParam.param32[1].value or nil
            if not l_achieveId then
                logError("接收到服务器发送的成就消息公告 成就ID为空 @李亚凯")
                return
            end
            local l_linkSt, l_linkParams = MgrMgr:GetMgr("LinkInputMgr").GetAchievementDPack(nil,
                    l_achieveId, l_extraParam.param64[1].value, l_extraParam.param64[2].value) 
            table.insert(argList, l_linkSt)
            --如果存在成就等级
            if l_extraParam.param64[3] then
                table.insert(argList, tostring(l_extraParam.param64[3].value))
            end
            l_params = l_linkParams
        elseif l_extraParam.type == HrefType.HREF_PROP then
            --物品道具
            local l_itemId = l_extraParam.param32[1] and l_extraParam.param32[1].value or nil
            if not l_itemId then
                logError("接收到服务器发送的物品消息公告 物品ID为空 @李亚凯")
                return
            end
            local l_level = l_extraParam.param32[2] and l_extraParam.param32[2].value or 0 --物品强化等级
            local l_uid = l_extraParam.param64[1] and l_extraParam.param64[1].value or 0
            local l_linkSt, l_linkParams = MgrMgr:GetMgr("LinkInputMgr").GetItemPack(nil,
                    l_itemId, l_level, l_uid)
            table.insert(argList, l_linkSt)
            l_params = l_linkParams
        elseif l_extraParam.type == HrefType.HREF_ROLE_INFO then
            -- 玩家信息 链接额外数据增加 玩家ID  注释代码为扩展代码 需等服务器完成一个需求后 替换
            local l_playerName = l_extraParam.name[1] or nil
            local l_linkStr = MgrMgr:GetMgr("LinkInputMgr").GetPlayerInfoLinkStr(l_playerName)
            table.insert(argList, l_linkStr)
            extraLinkData.aimPlayerId = l_extraParam.param64[1].value
        elseif l_extraParam.type == HrefType.HREF_CRYSTAL then
            --华丽水晶
            --多水晶名字拼接
            local l_crystalChargeId = l_extraParam.param64[1] and l_extraParam.param64[1].value or nil
            if not l_crystalChargeId then
                logError("接收到服务器发送的华丽水晶充能消息公告 充能ID为空 @李亚凯")
                return
            end
            local l_allCrystalName = " "
            for i = 1, #l_extraParam.param32 do
                local l_crystalId = l_extraParam.param32[i].value
                local l_crystalRow = TableUtil.GetGuildCrystalTable().GetRowByCrystalId(l_crystalId)
                if l_crystalRow then
                    l_allCrystalName = l_allCrystalName .. Lang("GUILD_CRYSTAL_ANNOUNCE_COLOR_VALUE_SOLT", Lang(l_crystalRow.CrystalName)).. " "
                end
            end
            table.insert(argList, l_allCrystalName)
            --链接额外数据增加
            extraLinkData.guildCrystalChargeAnnounceId = tonumber(tostring(l_crystalChargeId))
        elseif l_extraParam.type == HrefType.HREF_WATCH_SHARE then
            local l_roomId = l_extraParam.param64[1] and l_extraParam.param64[1].value or nil
            if not l_roomId then
                logError("接收到服务器发送的分享观战 房间ID为空 @张宇1")
                return
            end
            extraLinkData.roomID = tonumber(tostring(l_roomId))
        end
    end
    return l_params
end

--该消息是否包含 type类型
function CanType(id, t)
    local l_msgData = TableUtil.GetMessageTable().GetRowByID(id)
    if l_msgData == nil then
        return false
    end
    local l_types = Common.Functions.VectorToTable(l_msgData.Type)
    for i = 1, #l_types do
        local l_type = l_types[i]
        if l_type == t then
            return true
        end
    end
    return false
end

--公会新闻相关处理
function LocalArgsSet(announceData,l_localArgs)
    local data = table.ro_clone(l_localArgs)
    if announceData then
        local l_isExist,l_guildNewsData = MgrMgr:GetMgr("GuildMgr").GetGuildNewsMessageData(announceData.id)
        if l_isExist then
            if announceData.type == 3 then
                local arg = data[2]
                data[2] = DataMgr:GetData("GuildData").GetPositionName(tonumber(arg))
            end
        end
    end
    return data
end


return ModuleMgr.MessageRouterMgr
