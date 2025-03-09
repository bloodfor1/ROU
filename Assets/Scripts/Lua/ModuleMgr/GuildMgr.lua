---
--- Created by cmd(TonyChen).
--- DateTime: 2018/6/6 10:06
---
---@module ModuleMgr.GuildMgr : ModuleData.GuildData
module("ModuleMgr.GuildMgr", package.seeall)

--region-----------  事件相关  -----------------
EventDispatcher = EventDispatcher.new()
--获取公会信息的事件
ON_GET_GUILD_INFO = "ON_GET_GUILD_INFO"
--公会信息变化
ON_GET_GUILD_INFO_CHANGE = "ON_GET_GUILD_INFO_CHANGE"
--公会创建失败事件
ON_GUILD_CREATE_FAILED = "ON_GUILD_CREATE_FAILED"
--被踢出公会的事件
ON_GUILD_KICKOUT = "ON_GUILD_KICKOUT"
--公会列表数据传回后事件
ON_GUILD_LIST_SHOW = "ON_GUILD_LIST_SHOW"
--申请加入后事件
ON_GUILD_APPLY = "ON_GUILD_APPLY"
--申请加入的公会不存在事件
ON_GUILD_APPLY_NO_EXIST_GUILD = "ON_GUILD_APPLY_NO_EXIST_GUILD"
--公会新闻获取后事件
ON_GUILD_NEWS_GET = "ON_GUILD_NEWS_GET"
--公会图标修改后事件
ON_GUILD_ICON_MODIFY = "ON_GUILD_ICON_MODIFY"
--公会公告修改后事件
ON_GUILD_NOTICE_MODIFY = "ON_GUILD_NOTICE_MODIFY"
--招募宣言修改后事件
ON_GUILD_WORDS_MODIFY = "ON_GUILD_WORDS_MODIFY"
--成员列表数据传回后事件
ON_GUILD_MEMBERLIST_SHOW = "ON_GUILD_MEMBERLIST_SHOW"
--筛选符合资格的魅力担当事件
ON_GUILD_BEAUTYOK_SHOW = "ON_GUILD_BEAUTYOK_SHOW"
--成员职位修改后事件
ON_MEMBER_POSITION_MODIFY = "ON_MEMBER_POSITION_MODIFY"
--成员自定义职位编辑后事件
ON_MEMBER_EDIT_POSITION = "ON_MEMBER_EDIT_POSITION"
--成员踢出后事件
ON_MEMBER_KICKOUT = "ON_MEMBER_KICKOUT"
--自身职位被修改后事件(如果在成员列表则刷新列表)
ON_GUILD_POSITION_CHANGED = "ON_GUILD_POSITION_CHANGED"
--申请者列表数据传回后事件
ON_GUILD_APPLYLIST_SHOW = "ON_GUILD_APPLYLIST_SHOW"
--开关自动审核后事件
ON_APPLY_SWITCH_AUTO = "ON_APPLY_SWITCH_AUTO"
--批准申请后事件
ON_CHECK_APPLY = "ON_CHECK_APPLY"
--关闭公会红包列表后事件
ON_CLOSE_GUILD_RED_ENVELOPE_LIST = "ON_CLOSE_GUILD_RED_ENVELOPE_LIST"
--公会断线重连
ON_GUILD_RECONNECT = "ON_GUILD_RECONNECT"
--检查确认无公会
ON_CHECK_NO_GUILD = "ON_CHECK_NO_GUILD"
--组织力进度更新
ON_GUILD_ORGANIZE_PROGRESS_UPDATE = "ON_GUILD_ORGANIZE_PROGRESS_UPDATE"
--获得组织贡献力排行信息
ON_GET_GUILD_ORGANIZATION_RANK = "ON_GET_GUILD_ORGANIZATION_RANK"
--组织贡献力个人奖励数据更新
ON_GET_GUILD_ORGANIZATION_PERSONAL_REWARD = "ON_GET_GUILD_ORGANIZATION_PERSONAL_REWARD"
--endregion----------- END 事件相关  -----------------

--公会数据获取
local l_guildData = DataMgr:GetData("GuildData")
local l_isOpening = false  --是否正在打开公会
local l_openType = nil    --公会打开类型参数（opensystem表传入）
local l_isReconnect = false  --是否是断线重连

--- 后续应该把部分逻辑放进OnInit()内
function OnInit()
    --需要更新today_money字段，在新一天来临时请求公会信息
    local dtMgr = MgrMgr:GetMgr("DailyTaskMgr")
    dtMgr.EventDispatcher:Add(dtMgr.NEW_DAY_COMING, ReqGuildInfo, ModuleMgr.GuildMgr)
end

--打开公会界面
--防止别的系统错误引起 公会数据在登录是没获取到 故在OpenSystem的时候重新拉取
--openType  打开类型
function OpenGuild(openType)
    l_openType = openType
    if IsSelfHasGuild() then
        --如果已经有公会数据了 不再重复请求直接打开
        OnGetGuildInfoForOpenGuild()
    else
        --如果没有公会数据 则防止别的异常导致登录时没有请求 再次确认后再打开
        l_isOpening = true
        ReqGuildInfo()
    end
end

--获取公会数据后 打开公会操作
function OnGetGuildInfoForOpenGuild()
    l_isOpening = false
    if IsSelfHasGuild() then
        if l_openType == nil or #l_openType == 0 then
            UIMgr:ActiveUI(UI.CtrlNames.Guild)
            return
        end
        local l_type = tonumber(l_openType[1])
        if l_type == l_guildData.EGuildHandleType.GuildInfo then
            UIMgr:ActiveUI(UI.CtrlNames.Guild, {
                selectHandlerName = UI.HandlerNames.GuildInfor,
            })
        elseif l_type == l_guildData.EGuildHandleType.GuildMember then
            UIMgr:ActiveUI(UI.CtrlNames.Guild, {
                selectHandlerName = UI.HandlerNames.GuildMember,
            })
        elseif l_type == l_guildData.EGuildHandleType.GuildWelfare then
            UIMgr:ActiveUI(UI.CtrlNames.Guild, {
                selectHandlerName = UI.HandlerNames.GuildWelfare,
            })
        elseif l_type == l_guildData.EGuildHandleType.GuildActivity then
            UIMgr:ActiveUI(UI.CtrlNames.Guild, {
                selectHandlerName = UI.HandlerNames.GuildActivity,
            })
        else
            UIMgr:ActiveUI(UI.CtrlNames.Guild)
        end
        l_openType = nil
    else
        UIMgr:ActiveUI(UI.CtrlNames.GuildList)
    end
end

--重连重新请求公会数据 防止被加入公会的时候 没收到消息
function OnReconnected(reconnectData)
    l_isReconnect = true
    ReqGuildInfo()
end

--初始化公会
function InitGuild()
    l_guildData.Init()      --初始化所有数据
    UpdateGuildHUD()        --公会的HUD信息更新
    UpdateGuildRedSign()    --公会的红点信息更新
    CommonUI.Dialog.CloseDlgByTopic(CommonUI.Dialog.DialogTopic.GUILD)  --关闭所有公会主题的对话框
end

--判断自己是否有公会
function IsSelfHasGuild()
    --防止小概率服务器发来的数据异常 导致公会出现异常
    return l_guildData.selfGuildMsg.id and tonumber(tostring(l_guildData.selfGuildMsg.id)) ~= 0 or false
end

--更新公会HUD数据
function UpdateGuildHUD()
    local l_guildId_HUD = l_guildData.selfGuildMsg.id or 0
    local l_guildName_HUD = l_guildData.selfGuildMsg.name or ""
    local l_guildPositionName_HUD = l_guildData.GetPositionName(l_guildData.GetSelfGuildPosition()) or ""
    local l_guildIconId_HUD = l_guildData.guildBaseInfo.icon_id or 0
    --现在起始获取公会数据的时候 玩家的Entity并没有创建 所以需要判空一下
    if MEntityMgr.PlayerEntity ~= nil and (l_guildName_HUD ~= l_guildData.curGuildName_HUD
            or l_guildPositionName_HUD ~= l_guildData.curGuildPositionName_HUD or l_guildIconId_HUD ~= l_guildData.curGuildIconId_HUD) then

        MEventMgr:LuaFireEvent(MEventType.MEvent_GuildMsg_Change, MEntityMgr.PlayerEntity,
                l_guildId_HUD, l_guildName_HUD, l_guildPositionName_HUD, l_guildIconId_HUD, l_guildData.GetSelfGuildPosition())
        l_guildData.curGuildName_HUD = l_guildName_HUD
        l_guildData.curGuildPositionName_HUD = l_guildPositionName_HUD
        l_guildData.curGuildIconId_HUD = l_guildIconId_HUD

    end
end

--更新公会相关红点
function UpdateGuildRedSign()
    local l_redSignMgr = MgrMgr:GetMgr("RedSignMgr")
    l_redSignMgr.UpdateRedSign(eRedSignKey.GuildWelfare)
    l_redSignMgr.UpdateRedSign(eRedSignKey.GuildCrystalOneLv)
    l_redSignMgr.UpdateRedSign(eRedSignKey.GuildActivity)
    l_redSignMgr.UpdateRedSign(eRedSignKey.GuildSale)
end

--选中成员列表显示详细信息
function ShowMemberDetailInfo(memberData)
    local l_openData = {
        openType = l_guildData.EUIOpenType.GuildRefreshPlayerMenuL,
        MemberData = memberData
    }
    UIMgr:ActiveUI(UI.CtrlNames.PlayerMenuL, l_openData)
end

--控制面板 逐出公会 按钮点击
function KickoutMember(memberData)
    UIMgr:DeActiveUI(UI.CtrlNames.PlayerMenuL)
    local l_offlineTime = Common.TimeMgr.GetUtcTimeByTimeTable() - memberData.lastOfflineTime
    local l_setting = TableUtil.GetGuildSettingTable().GetRowBySetting("KickConsumeVitality").Value
    local l_settingValues = string.ro_split(l_setting, "=")
    local l_checkTime = tonumber(l_settingValues[1]) * 86400
    if l_offlineTime < l_checkTime and tonumber(l_settingValues[2]) > 0 then
        --如果配表扣除元气为0则不提示
        --离线不到3天的提示踢出需要元气消耗 切确认时为强制踢出
        local l_stringTable = { StringEx.Format(Lang("GUILD_KICKOUT"), memberData.baseInfo.name), "(", StringEx.Format(Lang("GUILD_KICKOUT_FORCE"), l_settingValues[1], l_settingValues[2]), ")" }
        CommonUI.Dialog.ShowYesNoDlg(true, nil,
                table.concat(l_stringTable),
                function()
                    ReqKickOut(memberData.baseInfo.roleId, true)
                end)
    else
        --离线超过三天的没有特殊提示 也不需要强制踢出
        CommonUI.Dialog.ShowYesNoDlg(true, nil,
                StringEx.Format(Lang("GUILD_KICKOUT"), memberData.baseInfo.name),
                function()
                    ReqKickOut(memberData.baseInfo.roleId, false)
                end)
    end
end

--上交公会之心时 发送公会系统广播
function OnGiveCrystalGuildNTF(data)
    local messageRouterMgr = MgrMgr:GetMgr("MessageRouterMgr")
    local typeId = 62015
    local roleName = MPlayerInfo.Name
    local crystalName = TableUtil.GetItemTable().GetRowByItemID(data.item_id).ItemName

    messageRouterMgr.OnMessage(typeId, nil, nil, roleName, data.item_count, crystalName, data.add_guild_money)
end

--更新成员列表的红包列表状态（指定成员）
function UpdateGuildMemberListRedListState(memberId, redInfoList)
    EventDispatcher:Dispatch(ON_CLOSE_GUILD_RED_ENVELOPE_LIST, memberId, redInfoList)
end

--region------------------------以下是服务器交互PRC------------------------------------------
--登录时获取公会数据
function OnSelectRoleNtf(roleData)
    local l_guildInfo = roleData.brief.guild_info

    --防止极小概率网络数据传输异常 增加容错分支
    if l_guildInfo.guild_id and tonumber(tostring(l_guildInfo.guild_id)) ~= 0 then
        l_guildData.selfGuildMsg.id = l_guildInfo.guild_id
        l_guildData.selfGuildMsg.name = l_guildInfo.guild_name
        l_guildData.selfGuildMsg.position = l_guildInfo.permission
        l_guildData.guildBaseInfo.icon_id = l_guildInfo.icon_id
    else
        l_guildData.InitSelfGuildMsg()
    end

    ReqGuildInfo()  --防弱网情况下出现的低概率异常 这里需要重新请求一次详细信息
    l_guildData.InitGuildFindPath()
end
--请求公会信息
function ReqGuildInfo()
    local l_msgId = Network.Define.Rpc.GuildGetInfo
    ---@type GuildGetInfoArg
    local l_sendInfo = GetProtoBufSendTable("GuildGetInfoArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo, nil, nil, nil, function()
        ReqGuildInfo()
    end)
end

--接收公会信息
--如果接收到的返回消息没有值 表示该玩家没有公会 则请求公会列表
function OnReqGuildInfo(msg)
    ---@type GuildGetInfoRes
    local l_info = ParseProtoBufToTable("GuildGetInfoRes", msg)

    if l_info.error_code == 0 then
        --如果有数据
        --个人相关数据赋值
        l_guildData.selfGuildMsg.id = l_info.self_guild.id
        l_guildData.selfGuildMsg.name = l_info.self_guild.name
        l_guildData.selfGuildMsg.position = l_info.self_info.permission
        l_guildData.selfGuildMsg.contribution = l_info.self_info.cur_contribute
        l_guildData.selfGuildMsg.joinTime = tonumber(tostring(l_info.self_info.join_time))
        --记录公会信息
        l_guildData.guildBaseInfo = l_info.self_guild
        --logError("[GuildMgr] today's money:{0}", l_info.self_guild.today_money)
        --自定义的公会职位名设置
        local l_permissionList = l_info.self_guild.permission_list
        for i = 1, #l_permissionList do
            l_guildData.SetPositionName(l_permissionList[i].permission, l_permissionList[i].permission_name)
        end
        --C#记录的公会ID更新
        if MEntityMgr.PlayerEntity and MEntityMgr.PlayerEntity.AttrRole then
            MEntityMgr.PlayerEntity.AttrRole.GuildId = l_info.self_guild.id
        end
        --事件调用用于更新
        EventDispatcher:Dispatch(ON_GET_GUILD_INFO)
        EventDispatcher:Dispatch(ON_GET_GUILD_INFO_CHANGE, l_guildData.selfGuildMsg)
        --请求加入公会的时间点
        ReqJoinTime()
        --展示公会的HUD信息
        UpdateGuildHUD()
        --请求建筑信息
        MgrMgr:GetMgr("GuildBuildMgr").ReqGuildBuildMsg()
        --请求公会狩猎的信息
        MgrMgr:GetMgr("GuildHuntMgr").ReqGetGuildHuntInfo()
        --请求公会福利信息
        MgrMgr:GetMgr("GuildWelfareMgr").ReqGetWelfare()
        --请求公会仓库信息
        MgrMgr:GetMgr("GuildDepositoryMgr").ReqGetGuildDepositoryInfoBySystem()
        --如果是移动平台请求绑群信息
        -- if Application.isMobilePlatform and tonumber(l_guildData.zoneId) >= 8001 and tonumber(l_guildData.zoneId) <= 8004 then
        --     MgrMgr:GetMgr("GuildSDKMgr").ReqGuildGroupBindInfo()
        -- end
        if l_isReconnect then
            l_isReconnect = false
            EventDispatcher:Dispatch(ON_GUILD_RECONNECT)
        end
    elseif l_info.error_code == ErrorCode.ERR_GUILD_NOT_IN_GUILD then
        --无公会时 初始化一次数据
        --有公会回收机制 但公会回收时不会清理 离线玩家的数据 所以会出现此类情况
        --客户端清理脏数据 并且防止弱网情况一开始没有清理掉 还需要抛一个无公会的事件
        InitGuild()
        EventDispatcher:Dispatch(ON_CHECK_NO_GUILD)
    end
    --如果正在打开公会 则打开对应公会界面
    if l_isOpening then
        OnGetGuildInfoForOpenGuild()
    end
end

--请求加入公会的时间点
function ReqJoinTime()
    local l_msgId = Network.Define.Rpc.GetJoinGuildTime
    ---@type GetJoinGuildTimeReq
    local l_sendInfo = GetProtoBufSendTable("GetJoinGuildTimeReq")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--接收服务器返回的公会列表信息
function OnReqJoinTime(msg)
    ---@type GetJoinGuildTimeRsp
    local l_info = ParseProtoBufToTable("GetJoinGuildTimeRsp", msg)
    --调用展示事件
    if l_info.errcode == 0 then
        l_guildData.selfGuildMsg.joinTime = tonumber(tostring(l_info.jointime))
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.errcode))
    end
end

--请求公会列表
--lastGuildId 当前列表中最后一个公会的Id
function ReqGetGuildList(lastGuildId)
    local l_msgId = Network.Define.Rpc.GuildGetList
    ---@type GuildGetListArg
    local l_sendInfo = GetProtoBufSendTable("GuildGetListArg")
    l_sendInfo.last_guild_id = lastGuildId
    l_sendInfo.count = l_guildData.GUILD_LIST_PAGE_CAPACITY
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--接收服务器返回的公会列表信息
function OnReqGetGuildList(msg)
    ---@type GuildGetListRes
    local l_info = ParseProtoBufToTable("GuildGetListRes", msg)
    --调用展示事件
    EventDispatcher:Dispatch(ON_GUILD_LIST_SHOW, 0, l_info.guild_list)
end

--请求搜索公会
--keyWord 关键字
function ReqSearchGuild(keyWord)
    local l_msgId = Network.Define.Rpc.GuildSearch
    ---@type GuildSearchArg
    local l_sendInfo = GetProtoBufSendTable("GuildSearchArg")
    l_sendInfo.name = keyWord
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--接收服务器返回的搜索公会信息
function OnReqSearchGuild(msg)
    if UIMgr:IsActiveUI(UI.CtrlNames.GuildList) then
        --如果目前正在公会列表界面则展示列表 防止突然被收入公会切界面导致出问题
        ---@type GuildSearchRes
        local l_info = ParseProtoBufToTable("GuildSearchRes", msg)
        if l_info.result == 0 then
            --调用展示事件
            EventDispatcher:Dispatch(ON_GUILD_LIST_SHOW, 1, l_info.guild_list)
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        end
    end
end

--请求加入目标公会
--aimGuildId  目标公会的编码 为0表示一键申请
--inviterId  邀请者ID
function ReqApply(aimGuildId, inviterId)
    local l_msgId = Network.Define.Rpc.GuildApply
    ---@type GuildApplyArg
    local l_sendInfo = GetProtoBufSendTable("GuildApplyArg")
    l_sendInfo.guild_id = aimGuildId
    l_sendInfo.invite_role = inviterId or 0
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--接收服务器返回的申请结果
function OnReqApply(msg, arg)
    ---@type GuildApplyRes
    local l_info = ParseProtoBufToTable("GuildApplyRes", msg)
    if l_info.error_code == 0 then
        if l_info.guild_list then
            --通用提示
            --存在请求的公会 防止临时被解散
            --这里加判断是为了防止申请加入自动收人的公会时发生被收入PTC先传回 然后会出现先提示进入公会 再提示申请成功的问题
            if #l_info.guild_list > 0 and l_guildData.selfGuildMsg.id == 0 then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GUILD_APPLY_SUCCESS"))
            end
            --事件回调
            EventDispatcher:Dispatch(ON_GUILD_APPLY, l_info.guild_list)
        end
    else
        --弹对应错误tip
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
        --如果申请的公会不存在 需要界面根据当时情况重新请求或重新搜索
        if l_info.error_code == ErrorCode.ERR_GUILD_NOT_EXIST then
            EventDispatcher:Dispatch(ON_GUILD_APPLY_NO_EXIST_GUILD, arg.guild_id)
        end
    end
end

--请求创建公会
--guildIconId  公会图标编号
--guildName  公会名称
--recruitWords  招募宣言
function ReqCreateGuild(guildIconId, guildName, recruitWords)
    local l_msgId = Network.Define.Rpc.GuildCreate
    ---@type GuildCreateArg
    local l_sendInfo = GetProtoBufSendTable("GuildCreateArg")
    l_sendInfo.icon_id = guildIconId
    l_sendInfo.name = guildName
    l_sendInfo.declaration = recruitWords
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--接收服务器返回的创建结果
function OnReqCreateGuild(msg)
    ---@type GuildCreateRes
    local l_info = ParseProtoBufToTable("GuildCreateRes", msg)
    --弹tip显示是否成功
    --错误显示错误信息 成功的话获取的是公会信息
    if l_info.error_code == 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GUILD_CREATE_SUCCESS"))
        --关闭公会列表界面 并 请求公会信息
        UIMgr:DeActiveUI(UI.CtrlNames.GuildCreate)
        UIMgr:DeActiveUI(UI.CtrlNames.GuildList)
        ReqGuildInfo()
        MgrMgr:GetMgr("AdjustTrackerMgr").TrackEvent(GameEnum.AdjustTrackerEvent.GuildCreation)
    else
        --弹对应错误tip
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
        EventDispatcher:Dispatch(ON_GUILD_CREATE_FAILED)
    end
end

--请求公会新闻
function ReqGuildNews()
    local l_msgId = Network.Define.Rpc.GuildGetNewsInfo
    ---@type GuildGetNewsInfoArg
    local l_sendInfo = GetProtoBufSendTable("GuildGetNewsInfoArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--接收服务器返回的公会新闻
function OnReqGuildNews(msg)
    ---@type GuildGetNewsInfoRes
    local l_info = ParseProtoBufToTable("GuildGetNewsInfoRes", msg)
    if l_info.error_code == 0 then
        EventDispatcher:Dispatch(ON_GUILD_NEWS_GET, l_info.news_list)
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
    end
end

--请求修改公会图标
--新图标的编号
function ReqModifyGuildIcon(iconId)
    local l_msgId = Network.Define.Rpc.GuildIconChange
    ---@type GuildIconChangeArg
    local l_sendInfo = GetProtoBufSendTable("GuildIconChangeArg")
    l_sendInfo.icon_id = iconId
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--接收服务器返回的修改公会图标结果
function OnReqModifyGuildIcon(msg, arg)
    ---@type GuildIconChangeRes
    local l_info = ParseProtoBufToTable("GuildIconChangeRes", msg)
    if l_info.error_code == 0 then
        l_guildData.guildBaseInfo.icon_id = arg.icon_id  --缓存的公会信息更新
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("MODIFY_SUCCESS"))
        UIMgr:DeActiveUI(UI.CtrlNames.GuildIconSelect)
        EventDispatcher:Dispatch(ON_GUILD_ICON_MODIFY, arg.icon_id)
        UpdateGuildHUD() --公会的HUD信息 更新
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
    end
end

--请求修改公会公告
--guildNotice  公会公告
function ReqModifyGuildNotice(guildNotice)
    local l_msgId = Network.Define.Rpc.GuildAnnounceChange
    ---@type GuildAnnounceChangeArg
    local l_sendInfo = GetProtoBufSendTable("GuildAnnounceChangeArg")
    l_sendInfo.announce = guildNotice
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--接收服务器返回的公会公告修改结果
function OnReqModifyGuildNotice(msg)
    ---@type GuildAnnounceChangeRes
    local l_info = ParseProtoBufToTable("GuildAnnounceChangeRes", msg)
    if l_info.error_code == 0 then
        l_guildData.guildBaseInfo.announce = l_info.announce  --更新缓存中的数据
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("MODIFY_SUCCESS"))
        UIMgr:DeActiveUI(UI.CtrlNames.GuildModifyInfor)
        EventDispatcher:Dispatch(ON_GUILD_NOTICE_MODIFY, l_info.announce)
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
    end
end

--请求修改招募宣言
--recruitWords  招募宣言
function ReqModifyRecruitWords(recruitWords)
    local l_msgId = Network.Define.Rpc.GuildDeclarationChange
    ---@type GuildDeclarationChangeArg
    local l_sendInfo = GetProtoBufSendTable("GuildDeclarationChangeArg")
    l_sendInfo.declartion = recruitWords
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--接收服务器返回的招募宣言修改结果
function OnReqModifyRecruitWords(msg)
    ---@type GuildDeclarationChangeRes
    local l_info = ParseProtoBufToTable("GuildDeclarationChangeRes", msg)
    if l_info.error_code == 0 then
        l_guildData.guildBaseInfo.declaration = l_info.declartion  --更新缓存中的数据
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("MODIFY_SUCCESS"))
        UIMgr:DeActiveUI(UI.CtrlNames.GuildModifyInfor)
        EventDispatcher:Dispatch(ON_GUILD_WORDS_MODIFY, l_info.declartion)
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
    end
end

--请求公会成员列表(一次性请求接收全部的成员)
function ReqGuildMemberList()
    local l_msgId = Network.Define.Rpc.GuildQueryMemberList
    ---@type GuildQueryMemberListArg
    local l_sendInfo = GetProtoBufSendTable("GuildQueryMemberListArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--接收服务器返回的公会成员列表
function OnReqGuildMemberList(msg)
    ---@type GuildQueryMemberListRes
    local l_info = ParseProtoBufToTable("GuildQueryMemberListRes", msg)
    if l_info.error_code == 0 then
        l_guildData.SetGuildMemberList(l_info.member_list)
        EventDispatcher:Dispatch(ON_GUILD_MEMBERLIST_SHOW)
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
    end
end

--请求发送公会群体消息
function ReqSendGuildEmail(content)
    local l_msgId = Network.Define.Rpc.GuildEmailSend
    ---@type GuildEmailSendArg
    local l_sendInfo = GetProtoBufSendTable("GuildEmailSendArg")
    l_sendInfo.content = content
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--接收发送公会群体消息的结果
function OnReqSendGuildEmail(msg)
    ---@type GuildEmailSendRes
    local l_info = ParseProtoBufToTable("GuildEmailSendRes", msg)
    if l_info.error_code == 0 then
        local l_cost = tonumber(TableUtil.GetGuildSettingTable().GetRowBySetting("GuildNoticeMailCost").Value)
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("SEND_SUCCESS_WITH_COST_VITALITY", l_cost))
        UIMgr:DeActiveUI(UI.CtrlNames.GuildEmail)
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
    end
end

--请求搜索公会成员 协议接口保留目前为本地搜索
--keyWord  关键字
function ReqSearchGuildMember(keyWord)
    --local l_msgId = Network.Define.Rpc.GuildMemberSearch
    --local l_sendInfo = PbcMgr.get_pbc_guild_pb().GuildMemberSearchArg()
    --l_sendInfo.name = keyWord
    --Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--接收服务器返回的搜索公会成员的结果
function OnReqSearchGuildMember(msg)
    ---@type GuildMemberSearchRes
    --local l_info = ParseProtoBufToTable("GuildMemberSearchRes", msg)
    --刷新列表 清除选中
end

--请求任命某人为执事
--memberId  成员的编号
--position  职位 1会长 2副会长 3理事 4执事 5成员 6特殊成员1 7特殊成员2
function ReqAppoint(memberId, position)
    local l_msgId = Network.Define.Rpc.GuildChangePermission
    ---@type GuildChangePermissionArg
    local l_sendInfo = GetProtoBufSendTable("GuildChangePermissionArg")
    l_sendInfo.role_id = memberId
    l_sendInfo.permission = position
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--接收服务器返回的任命结果
function OnReqAppoint(msg, arg)
    ---@type GuildChangePermissionRes
    local l_info = ParseProtoBufToTable("GuildChangePermissionRes", msg)
    if l_info.error_code == 0 then
        EventDispatcher:Dispatch(ON_MEMBER_POSITION_MODIFY, arg.role_id, arg.permission)
    else
        if l_info.error_code == ErrorCode.ERR_GUILD_BEAUTY_TIME_NOT_ENOUGH then
            local limit = tonumber(TableUtil.GetGuildSettingTable().GetRowBySetting("BeautyJoinTimeLimit").Value)
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Common.Functions.GetErrorCodeStr(l_info.error_code), limit))
        elseif l_info.error_code == ErrorCode.ERR_GUILD_BEAUTY_ACTIVITY_NOT_ENOUGH then
            local limit = tonumber(TableUtil.GetGuildSettingTable().GetRowBySetting("BeautyActiveTimeLimit").Value)
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Common.Functions.GetErrorCodeStr(l_info.error_code), limit))
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
        end
    end
end

--请求修改公会自定义职位名称
--newNameList  新的自定义职位名列表
function ReqEditPositionName(newNameList)
    local l_msgId = Network.Define.Rpc.GuildPermissionNameChange
    ---@type GuildPermissionNameChangeArg
    local l_sendInfo = GetProtoBufSendTable("GuildPermissionNameChangeArg")

    for k, v in pairs(newNameList) do
        local oneItem = l_sendInfo.permission_list:add()
        oneItem.permission = k
        oneItem.permission_name = v
    end

    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--接收服务器返回的修改公会自定义职位名称结果
function OnReqEditPositionName(msg, arg)
    ---@type GuildPermissionNameChangeRes
    local l_info = ParseProtoBufToTable("GuildPermissionNameChangeRes", msg)
    if l_info.error_info.errorno == 0 then
        --自定义职位新名字赋值
        for i = 1, #arg.permission_list do
            l_guildData.SetPositionName(arg.permission_list[i].permission, arg.permission_list[i].permission_name)
        end
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GUILD_POSITION_EDIT_SUCCESS"))
        --事件发给成员列表 通知更新
        EventDispatcher:Dispatch(ON_MEMBER_EDIT_POSITION)
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_info.errorno))
    end
end

--请求将某人踢出公会
--memberId  成员的编号
function ReqKickOut(memberId, isForce)
    local l_msgId = Network.Define.Rpc.GuildKickOutMember
    ---@type GuildKickOutMemberArg
    local l_sendInfo = GetProtoBufSendTable("GuildKickOutMemberArg")
    l_sendInfo.role_id = memberId
    l_sendInfo.force = isForce
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--接收服务器返回的踢出结果
function OnReqKickOut(msg, arg)
    ---@type GuildKickOutMemberRes
    local l_info = ParseProtoBufToTable("GuildKickOutMemberRes", msg)
    if l_info.error_code == 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GUILD_KICKOUT_SUCCESS"))
        EventDispatcher:Dispatch(ON_MEMBER_KICKOUT, arg.role_id)
    elseif l_info.error_code == ErrorCode.ERR_GUILD_KICK_MEMBER_NEED_MONEY then
        local l_setting = TableUtil.GetGuildSettingTable().GetRowBySetting("KickConsumeVitality").Value
        local l_settingValues = string.ro_split(l_setting, "=")
        if tonumber(l_settingValues[2]) > 0 then
            --如果配表扣除元气为0则不提示
            CommonUI.Dialog.ShowYesNoDlg(true, nil,
                    StringEx.Format(Lang("GUILD_KICKOUT_FORCE"), l_settingValues[1], l_settingValues[2]),
                    function()
                        ReqKickOut(arg.role_id, true)
                    end)
        else
            --如果配表扣除元气为0则不提示 直接请求强制踢出
            ReqKickOut(arg.role_id, true)
        end
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
    end
end

--请求退出公会
function ReqQuit()
    local l_msgId = Network.Define.Rpc.GuildQuit
    ---@type GuildQuitArg
    local l_sendInfo = GetProtoBufSendTable("GuildQuitArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--接收服务器返回的退出结果
function OnReqQuit(msg)
    ---@type GuildQuitRes
    local l_info = ParseProtoBufToTable("GuildQuitRes", msg)
    if l_info.error_code == 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GUILD_QUIT_SUCCESS"))
        UIMgr:DeActiveUI(UI.CtrlNames.Guild)
        InitGuild()
        EventDispatcher:Dispatch(ON_GET_GUILD_INFO_CHANGE, l_guildData.selfGuildMsg)
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
    end
end

--请求申请者列表
function ReqApplyList()
    local l_msgId = Network.Define.Rpc.GuildGetApplicationList
    ---@type GuildGetApplicationListArg
    local l_sendInfo = GetProtoBufSendTable("GuildGetApplicationListArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--接收服务器返回的申请者列表消息
function OnReqApplyList(msg)
    ---@type GuildGetApplicationListRes
    local l_info = ParseProtoBufToTable("GuildGetApplicationListRes", msg)
    if l_info.error_code == 0 then
        l_guildData.SetGuildApplyList(l_info.member_list)
        EventDispatcher:Dispatch(ON_GUILD_APPLYLIST_SHOW, l_info.is_auto)
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
    end
end

--请求审核申请
--memberId   选中则传选中的人的ID 全部处理则传0
--checkType  审核结果  true通过  false忽略
function ReqCheckApply(memberId, checkType)
    local l_msgId = Network.Define.Rpc.GuildApplyReplay
    ---@type GuildApplyReplayArg
    local l_sendInfo = GetProtoBufSendTable("GuildApplyReplayArg")
    l_sendInfo.role_id = memberId
    l_sendInfo.accept = checkType
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--接收服务器返回的审核情况结果
function OnReqCheckApply(msg, arg)
    ---@type GuildApplyReplayRes
    local l_info = ParseProtoBufToTable("GuildApplyReplayRes", msg)
    if l_info.error_code == 0 then
        --操作成功
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("OPERATE_SUCCESS"))
        EventDispatcher:Dispatch(ON_CHECK_APPLY, arg.role_id)
    elseif l_info.error_code == ErrorCode.ERR_GUILD_ROLE_NOT_IN_APPLY_LIST then
        --申请失效
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
        EventDispatcher:Dispatch(ON_CHECK_APPLY, arg.role_id)
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
    end
end

--请求开关自动审核功能
--isAuto  布尔值 true开启 false关闭
function ReqSetAutoCheck(isAuto)
    local l_msgId = Network.Define.Rpc.GuildAutoApprovalApply
    ---@type GuildAutoApprovalApplyArg
    local l_sendInfo = GetProtoBufSendTable("GuildAutoApprovalApplyArg")
    l_sendInfo.is_auto_approval = isAuto
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--接收服务器返回的请求开关自动审核功能结果
function OnReqSetAutoCheck(msg, arg)
    ---@type GuildAutoApprovalApplyRes
    local l_info = ParseProtoBufToTable("GuildAutoApprovalApplyRes", msg)
    if l_info.error_code == 0 then
        --不弹信息 直接根据arg 改变按钮的显示
        EventDispatcher:Dispatch(ON_APPLY_SWITCH_AUTO, arg.is_auto_approval)
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
    end
end

--请求邀请对方入会
function ReqInviteJoin(aimPlayerId)
    local l_msgId = Network.Define.Rpc.GuildInviteJoin
    ---@type GuildInviteJoinArg
    local l_sendInfo = GetProtoBufSendTable("GuildInviteJoinArg")
    l_sendInfo.aimPlayerId = aimPlayerId
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--接收服务器返回的邀请请求结果
function OnReqInviteJoin(msg)
    ---@type GuildInviteJoinRes
    local l_info = ParseProtoBufToTable("GuildInviteJoinRes", msg)
    if l_info.error_code ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("INVITE_GUILD_SUCCESS"))
    end
end

---判断道具是否是捐赠给公会的道具
---@param itemID number 进行判断的道具ID
---@return boolean true若此道具是捐赠道具
function IsGuildItem(itemID)
    if itemID == nil then
        logError("[GuildMgr.IsTribute] itemID is nil")
        return false
    end
    if table.ro_size(l_guildData.gGuildItemTable) == 0 then
        logError("[GuildMgr.IsTribute] 注册的公会道具为空")
        return false
    end
    return table.ro_containsKey(l_guildData.gGuildItemTable, itemID)
end

--- 检测今日公会新增资金是否接近或者达到上限，根据玩家选择捐赠公会道具
---@param itemUId number 道具拥有者id
---@param itemId number 道具id
---@param itemCount number
---@param isAll boolean
function ContributeGuildItem(itemUId, itemId, itemCount, isAll)
    local ret = isBankrollLimitReachedToday(itemId, itemCount)
    if ret == CheckBankrollLimitType.Reached then
        -- 本日公会资金增量达到上限，弹出确认窗，用户确认才上交
        CommonUI.Dialog.ShowYesNoDlg(true, nil, Lang("G_FUND_LIMIT_REACHED_TODAY"),
        function()
            ReqContributeGuildItem(itemUId, itemId, itemCount, isAll)
        end)
    elseif ret == CheckBankrollLimitType.AboutToReach then
        -- 本日公会资金增量即将达到上限，可能无法获得所有资金，弹出确认窗，用户确认才上交
        CommonUI.Dialog.ShowYesNoDlg(true, nil, Lang("G_FUND_LIMIT_ABOUTTOREACH_TODAY"),
        function()
            ReqContributeGuildItem(itemUId, itemId, itemCount, isAll)
        end)
    else
        -- 本日公会资金增量未达到上限，直接上交
        ReqContributeGuildItem(itemUId, itemId, itemCount, isAll)
    end
end

---@private
---判断公会今日捐献所得资金是否已达到限额
---@param itemId number 道具id
---@param itemCount number 道具个数
---@return number Reached->已经超过，AboutToReach->本次捐赠会超过，NotReached->本次捐赠不会超过
function isBankrollLimitReachedToday(itemId, itemCount)
    local l_level = l_guildData.guildBaseInfo.level
    if l_level == nil then
        logError("[GuildMgr.IsFundLimitReachedToday] 玩家工会等级信息为空，但仍尝试上交工会道具(ID{0})", itemId)
        -- 预料外的玩家操作，不弹出提示框，由服务器来保证资金不溢出
        return CheckBankrollLimitType.NotReached
    elseif not table.ro_containsKey(l_guildData.bankrollLimitTable, l_level) then
        logError("[GuildMgr.IsFundLimitReachedToday] 资金上限字典中不含键level{0}", l_level)
        -- 读表失败无法判断是否超出上限，不弹出提示框，由服务器来保证资金不溢出
        return CheckBankrollLimitType.NotReached
    else
        local l_todayBankroll = l_guildData.guildBaseInfo.today_money
        local l_bankrollLimit = l_guildData.bankrollLimitTable[l_level]
        local l_increment = l_guildData.GetGuildItemExchange(itemId, 1)
        --logWarn("[isBankrollLimitReachedToday]{0} + {1} * {2} > {3}?", l_todayBankroll, l_increment, itemCount, l_bankrollLimit)
        if l_todayBankroll >= l_bankrollLimit then
            return CheckBankrollLimitType.Reached
        elseif l_todayBankroll + l_increment * itemCount >= l_bankrollLimit then
            return CheckBankrollLimitType.AboutToReach
        else
            return CheckBankrollLimitType.NotReached
        end
    end
end

---@private
--- 请求捐赠公会道具
function ReqContributeGuildItem(itemUId, itemId, itemCount, isAll)
    local l_msgId = Network.Define.Rpc.GuildGiveItem
    ---@type GuildGiveItemArg
    local l_sendInfo = GetProtoBufSendTable("GuildGiveItemArg")
    l_sendInfo.item_uid = itemUId
    l_sendInfo.item_id = itemId
    l_sendInfo.item_count = tostring(itemCount)
    l_sendInfo.is_all = isAll or false
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--- 处理捐赠公会道具返回信息
function OnReqContributeGuildItem(msg)
    ---@type GuildGiveItemRes
    local l_info = ParseProtoBufToTable("GuildGiveItemRes", msg)

    if l_info.error_code == 0 then
        local l_itemTableRow = TableUtil.GetItemTable().GetRowByItemID(l_info.item_id)
        if l_itemTableRow then
            local itemStr = StringEx.Format(Common.Utils.Lang("RICH_IMAGE"), tostring(l_itemTableRow.ItemIcon), tostring(l_itemTableRow.ItemAtlas), 20, 1)
            local tipStr = StringEx.Format(Common.Utils.Lang("GUILD_WELFARE_GIVE_CRYSTAL_TIP1"), itemStr, l_itemTableRow.ItemName, l_info.item_count, l_info.add_guild_money)
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(tipStr)
        end
        SetCurrentOrganizeProgressValue(l_info.guild_organization)
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
    end
end

function ReqGetGuildOrganizationInfo()
    local l_msgId = Network.Define.Rpc.GetGuildOrganizationInfo
    ---@type NullArg
    local l_sendInfo = GetProtoBufSendTable("NullArg")

    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end
function OnGetGuildOrganizationInfo(msg)
    ---@type GetGuildOrganizationInfoRes
    local l_info = ParseProtoBufToTable("GetGuildOrganizationInfoRes", msg)
    if l_info.errcode ~= ErrorCode.ERR_SUCCESS then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.errcode))
    else
        SetCurrentOrganizeProgressValue(l_info.guild_organization)
        SetCurrentHasGetPersonalRewardKey(l_info.personal_award_list)
    end
end
function ReqGetGuildOrganizationPersonalAward(manualScore)
    local l_msgId = Network.Define.Rpc.GetGuildOrganizationPersonalAward
    ---@type GetGuildOrganizationPersonalAwardArg
    local l_sendInfo = GetProtoBufSendTable("GetGuildOrganizationPersonalAwardArg")
    l_sendInfo.award_stage = manualScore
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end
function OnGetGuildOrganizationPersonalAward(msg, arg)
    ---@type GetGuildOrganizationPersonalAwardRes
    local l_info = ParseProtoBufToTable("GetGuildOrganizationPersonalAwardRes", msg)
    if l_info.err ~= ErrorCode.ERR_SUCCESS then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.err))
    else
        AddPersonalRewardKey(arg.award_stage)
    end
end
function ReqGetGuildOrganizationRank()
    local l_msgId = Network.Define.Rpc.GetGuildOrganizationRank
    ---@type NullArg
    local l_sendInfo = GetProtoBufSendTable("NullArg")

    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end
function OnGetGuildOrganizationRank(msg)
    ---@type GetGuildOrganizationRankRes
    local l_info = ParseProtoBufToTable("GetGuildOrganizationRankRes", msg)
    if l_info.errcode ~= ErrorCode.ERR_SUCCESS then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.errcode))
    else
        EventDispatcher:Dispatch(ON_GET_GUILD_ORGANIZATION_RANK, l_info.member_list)
    end
end

function FindGuildBeautyCandidate()

    local l_msgId = Network.Define.Rpc.FindGuildBeautyCandidate
    ---@type NullArg
    local l_sendInfo = GetProtoBufSendTable("NullArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)

end

function OnFindGuildBeautyCandidate(msg)

    ---@type GuildQueryMemberListRes
    local l_info = ParseProtoBufToTable("GuildQueryMemberListRes", msg)

    if l_info.error_code == 0 then
        EventDispatcher:Dispatch(ON_GUILD_BEAUTYOK_SHOW, l_info.member_list)
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
    end

end

function OnGuildOrganizePersonAwardNtf(msg)
    ---@type GuildOrganizePersonAwardNtfRes
    local l_info = ParseProtoBufToTable("GuildOrganizePersonAwardNtfRes", msg)
    SetCanGetPersonalReward(l_info.award_list)
end
--endregion---------------------------PRC  END------------------------------------------

--region------------------------以下是单项协议 PTC------------------------------------
---请求进入公会场景
function ReqEnterGuildScene()
    local l_msgId = Network.Define.Ptc.EnterGuildScene
    ---@type EnterGuildSceneData
    local l_sendInfo = GetProtoBufSendTable("EnterGuildSceneData")
    l_sendInfo.dungeon_id = l_guildData.GUILD_SCENE_ID
    Network.Handler.SendPtc(l_msgId, l_sendInfo)
end

--被收入公会的推送
function OnGuildEnterNotify(msg)
    ---@type GuildEnterNotifyInfo
    local l_info = ParseProtoBufToTable("GuildEnterNotifyInfo", msg)
    --信息赋值
    l_guildData.selfGuildMsg.id = l_info.guild_id
    l_guildData.selfGuildMsg.name = l_info.guild_name
    --提示加入
    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GUILD_WELCOME_NEW_MEMBER", l_info.guild_name))
    --如果原本在公会列表界面则关闭列表界面打开公会信息界面
    if UIMgr:IsActiveUI(UI.CtrlNames.GuildList) then
        UIMgr:DeActiveUI(UI.CtrlNames.GuildList)
        ReqGuildInfo()  --返回的公会信息带有HUD更新 这里不重复了
    else
        --公会的HUD信息 更新
        UpdateGuildHUD()
    end
    MgrMgr:GetMgr("AdjustTrackerMgr").TrackEvent(GameEnum.AdjustTrackerEvent.GuildJoin)
end

--被踢出的推送
function OnGuildKickOutNotify(msg)
    ---@type GuildKickOutNotifyInfo
    local l_info = ParseProtoBufToTable("GuildKickOutNotifyInfo", msg)
    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Lang("GUILD_NOTIFY_KICKOUT_MEMBER"), l_info.guild_name))
    InitGuild()
    EventDispatcher:Dispatch(ON_GUILD_KICKOUT)
    EventDispatcher:Dispatch(ON_GET_GUILD_INFO_CHANGE, l_guildData.selfGuildMsg)
end

--接收入会邀请
function OnGetGuildInvite(msg)
    ---@type GuildInviteNotifyInfo
    local l_info = ParseProtoBufToTable("GuildInviteNotifyInfo", msg)

    local l_openData = {
        type = l_guildData.EUIOpenType.GuildInviteOffer,
        playerId = l_info.playerId,
        playerName = l_info.playerName,
        playerLv = l_info.playerLv,
        guildId = l_info.guildId,
        guildName = l_info.guildName,
        isCanEnter = l_info.can_enter_guild
    }
    UIMgr:ActiveUI(UI.CtrlNames.GuildInviteOffer, l_openData)
end

--个人公会信息变动推送
function OnSelfGuildMsgChangeNotify(msg)
    ---@type RoleGuildInfo
    local l_info = ParseProtoBufToTable("RoleGuildInfo", msg)

    --这里有可能是公会管理员修改自定义职务名引起的更新 所以不能走UpdateGuildHUD()
    l_guildData.selfGuildMsg.id = l_info.guild_id or 0
    l_guildData.selfGuildMsg.name = l_info.guild_name or ""
    local l_positionId = l_info.permission or 0
    local l_positionName = string.ro_isEmpty(l_info.permission_name) and (l_guildData.GetPositionName(l_positionId) or "") or l_info.permission_name
    l_guildData.guildBaseInfo.icon_id = l_info.icon_id or 0
    --如果是职位变更弹提示
    if l_guildData.GetSelfGuildPosition() ~= l_positionId then
        if not string.ro_isEmpty(l_positionName) then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Lang("GUILD_SELF_POSITION_CHANGED"), l_positionName))
        end
        l_guildData.selfGuildMsg.position = l_positionId
        --职位被修改事件派发
        EventDispatcher:Dispatch(ON_GUILD_POSITION_CHANGED)
    end
    --HUD修改事件触发
    MEventMgr:LuaFireEvent(MEventType.MEvent_GuildMsg_Change, MEntityMgr.PlayerEntity,
            l_guildData.selfGuildMsg.id, l_guildData.selfGuildMsg.name, l_positionName, l_guildData.guildBaseInfo.icon_id, l_positionId)
    l_guildData.curGuildName_HUD = l_guildData.selfGuildMsg.name
    l_guildData.curGuildPositionName_HUD = l_positionName
    l_guildData.curGuildIconId_HUD = l_guildData.guildBaseInfo.icon_id
end

--屏幕内他人信息变动推送
function OnOtherGuildMsgChangeNotify(msg)
    ---@type RoleGuildInfo
    local l_info = ParseProtoBufToTable("RoleGuildInfo", msg)
    local l_guildId = l_info.guild_id or 0
    local l_guildName = l_info.guild_name or ""
    local l_positionId = l_info.permission or 0
    local l_positionName = string.ro_isEmpty(l_info.permission_name) and (l_guildData.GetPositionName(l_positionId) or "") or l_info.permission_name
    local l_guildIconId = l_info.icon_id or 0
    --获取目标的entity 并触发事件
    local l_aimEntity = MEntityMgr:GetEntity(l_info.role_id)
    if l_aimEntity then
        MEventMgr:LuaFireEvent(MEventType.MEvent_GuildMsg_Change, l_aimEntity,
                l_guildId, l_guildName, l_positionName, l_guildIconId, l_positionId)
    end
end

--- 本日公会获得资金被更新的推送，除此处外，OnReqGuildInfo()的返回信息也会更新today_money字段
function OnGuildTodayMoneyUpdated(msg)
    ---@tyep GuildTodayMoney
    local l_info = ParseProtoBufToTable("GuildTodayMoney", msg)
    --logError("[GuildMgr] today's money updated {0} -> {1}", l_guildData.guildBaseInfo.today_money, l_info.today_money)
    l_guildData.guildBaseInfo.today_money = l_info.today_money
end

--endregion----------------------------PTC  END------------------------------------------

--region-------------------------  公会寻路相关逻辑  ----------------------------------
--进入场景的回调  在MgrMgr中调用
function OnEnterScene(sceneId)
    --Hud显示更新 因为PlayerEntity的创建时机修改 在获取公会数据之后 所以只能在切场景时更新
    UpdateGuildHUD()
    --寻路相关
    if sceneId == l_guildData.GUILD_SCENE_ID then
        OnEnterGuild_FindPathByActivityId()
        OnEnterGuild_FindPathByFuncId()
        OnEnterGuild_FindPathByPos()
        OnEnterGuild_FindPathByNpcId()
    end
end

--公会寻路(依据活动表ID)
--id  DailyActivitiesTable表中活动的ID
function GuildFindPath_ActivitiesId(id)
    if not IsSelfHasGuild() then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("NO_GUILD"))
    else
        game:ShowMainPanel()
        l_guildData.findPath_activityId = id
        if not MPlayerInfo.IsInGuild then
            --状态互斥检查 如果状态为不可进入公会 则重置寻路参数
            if StateExclusionManager:GetIsCanChangeState(MExlusionStates.State_U_BackToGuild) then
                ReqEnterGuildScene()
            else
                l_guildData.findPath_activityId = nil
            end
        else
            OnEnterGuild_FindPathByActivityId()
        end
    end
end

--进入公会场景后寻路的回调(依据活动表ID)
function OnEnterGuild_FindPathByActivityId()
    if l_guildData.findPath_activityId then
        --获取活动的信息
        local l_info = TableUtil.GetDailyActivitiesTable().GetRowById(l_guildData.findPath_activityId)
        l_guildData.findPath_activityId = nil
        if l_info then
            --优先根据设置定位坐标寻路
            local l_sceneInfo = l_info.ScenePosition
            for i = 0, l_sceneInfo.Count - 1 do
                local l_posInfo = l_sceneInfo[i]
                local l_sceneId = MLuaCommonHelper.Int(l_posInfo[0])
                if l_sceneId == l_guildData.GUILD_SCENE_ID then
                    local l_pos = Vector3.New(l_posInfo[1], l_posInfo[2], l_posInfo[3])
                    MTransferMgr:GotoPosition(l_sceneId, l_pos)
                    return
                end
            end

            --其次根据功能ID查找对应NPC进行寻路
            local l_commonUIFuncMgr = Common.CommonUIFunc
            local l_cNpcTb = l_commonUIFuncMgr.GetNpcIdTbByFuncId(l_info.FunctionID)
            if table.maxn(l_cNpcTb) > 0 then
                for x = 1, table.maxn(l_cNpcTb) do
                    local l_sceneIdTb, l_posTb = l_commonUIFuncMgr.GetNpcSceneIdAndPos(l_cNpcTb[x])
                    if l_sceneIdTb[1] ~= nil then
                        MTransferMgr:GotoNpc(l_sceneIdTb[1], l_cNpcTb[x], function()
                            MgrMgr:GetMgr("NpcMgr").TalkWithNpc(l_sceneIdTb[1], l_cNpcTb[x])
                        end)
                        return
                    end
                end
            end

        end
    end
end

--寻路前往公会中的NPC(依据功能ID)
--id  NPC上挂载的功能ID
function GuildFindPath_FuncId(id)
    if not IsSelfHasGuild() then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("NO_GUILD"))
    else
        game:ShowMainPanel()
        l_guildData.findPath_funcId = id
        if not MPlayerInfo.IsInGuild then
            --状态互斥检查 如果状态为不可进入公会 则重置寻路参数
            if StateExclusionManager:GetIsCanChangeState(MExlusionStates.State_U_BackToGuild) then
                ReqEnterGuildScene()
            else
                l_guildData.findPath_funcId = nil
            end
        else
            OnEnterGuild_FindPathByFuncId()
        end
    end
end

--进入公会场景后寻路的回调(依据功能ID)
function OnEnterGuild_FindPathByFuncId()
    if l_guildData.findPath_funcId then
        local l_npcMgr = MgrMgr:GetMgr("NpcMgr")
        local l_commonUIFuncMgr = Common.CommonUIFunc
        local l_cNpcTb = l_commonUIFuncMgr.GetNpcIdTbByFuncId(l_guildData.findPath_funcId)
        l_guildData.findPath_funcId = nil
        if table.maxn(l_cNpcTb) > 0 then
            for x = 1, table.maxn(l_cNpcTb) do
                local l_sceneIdTb, l_posTb = l_commonUIFuncMgr.GetNpcSceneIdAndPos(l_cNpcTb[x])
                if l_sceneIdTb[1] ~= nil then
                    MTransferMgr:GotoNpc(l_sceneIdTb[1], l_cNpcTb[x], function()
                        l_npcMgr.TalkWithNpc(l_sceneIdTb[1], l_cNpcTb[x])
                    end)
                    return
                end
            end
        end
    end
end

--前往公会的指定位置
function GuildFindPath_Pos(pos)
    if not IsSelfHasGuild() then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("NO_GUILD"))
    else
        game:ShowMainPanel()
        l_guildData.findPath_pos = pos
        if not MPlayerInfo.IsInGuild then
            --状态互斥检查 如果状态为不可进入公会 则重置寻路参数
            if StateExclusionManager:GetIsCanChangeState(MExlusionStates.State_U_BackToGuild) then
                ReqEnterGuildScene()
            else
                l_guildData.findPath_pos = nil
            end
        else
            OnEnterGuild_FindPathByPos()
        end
    end
end

--进入公会场景后寻路的回调(依据具体坐标)
function OnEnterGuild_FindPathByPos()
    if l_guildData.findPath_pos then
        local doorId = l_guildData.huntDoorId
        MTransferMgr:GotoPosition(l_guildData.GUILD_SCENE_ID, l_guildData.findPath_pos, function()
            if doorId then
                MgrMgr:GetMgr("NpcMgr").TalkWithNpc(l_guildData.GUILD_SCENE_ID, doorId)
            end
        end)
        l_guildData.findPath_pos = nil  --重置
        l_guildData.huntDoorId = nil
    end
end

--寻路前往公会中的NPC(依据NPC ID)
--id  NPC的ID
--arriveCallBack  到达后的回调
function GuildFindPath_NpcId(npcId, arriveCallBack)
    if not IsSelfHasGuild() then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("NO_GUILD"))
    else
        game:ShowMainPanel()
        l_guildData.findPath_npcId = npcId
        l_guildData.arriveCallBack = arriveCallBack
        if not MPlayerInfo.IsInGuild then
            --状态互斥检查 如果状态为不可进入公会 则重置寻路参数
            if StateExclusionManager:GetIsCanChangeState(MExlusionStates.State_U_BackToGuild) then
                ReqEnterGuildScene()
            else
                l_guildData.findPath_npcId = nil
                l_guildData.arriveCallBack = nil
            end
        else
            OnEnterGuild_FindPathByNpcId()
        end
    end
end

--进入公会场景后寻路的回调(依据NPC ID)
function OnEnterGuild_FindPathByNpcId()
    local l_npcId = l_guildData.findPath_npcId
    local l_callback = l_guildData.arriveCallBack
    if l_npcId then
        if l_callback then
            MTransferMgr:GotoNpc(l_guildData.GUILD_SCENE_ID, l_npcId, function()
                l_callback()
            end)
        else
            MTransferMgr:GotoNpc(l_guildData.GUILD_SCENE_ID, l_npcId, function()
                MgrMgr:GetMgr("NpcMgr").TalkWithNpc(l_guildData.GUILD_SCENE_ID, l_npcId)
            end)
        end
        l_guildData.arriveCallBack = nil
        l_guildData.findPath_npcId = nil
    end

end

--endregion-------------------------  End  公会寻路相关逻辑  ------------------------------

--region -------------------------  Start  对外访问数据接口 ------------------------------
function GetGuildBelongTypeData(belongType)
    if l_guildData.guildNewsBelongType[belongType] == nil then
        logError("不存在这个数据 guildNewsType")
        return
    end
    return l_guildData.guildNewsBelongType[belongType]
end

function GetGuildNewsMessageData(messageId)
    if l_guildData.gGuildNewsMessageIdTable[messageId] == nil then
        return false, nil
    end
    return true, l_guildData.gGuildNewsMessageIdTable[messageId]
end

guildNewsLakeState = {}
function GuildNewsSetLakeState(str)
    table.insert(guildNewsLakeState, str)
end

function GuildNewsGetLakeState(str)
    for key, value in pairs(guildNewsLakeState) do
        if value == str then
            return true
        end
    end
    return false
end

function SendGuildNewsMsg(additionalData)
    local l_info = additionalData.announceData
    l_info.type = l_guildData.GUILD_NEWS_BASIC_TYPE
    MgrMgr:GetMgr("MessageRouterMgr").OnMessage(l_info.id, nil, l_info)
    return true
end

--发送点赞信息到消息频道
function SendGuildLakeToGuildChat(finText, announceData, l_extraLinkData)
    local l_chatMgr = MgrMgr:GetMgr("ChatMgr")
    local l_isSendSucceed = l_chatMgr.SendChatMsg(MPlayerInfo.UID, "GuildNews", l_chatMgr.EChannel.GuildChat,
            { { type = ChatHrefType.GuildNews, name = { finText }, param64 = { [1] = { value = l_extraLinkData.aimPlayerId } } } })
end

--显示已经祝福的按钮
function ShowAlreadyLaked(str)
    return string.gsub(str, Lang("GUILD_LAKE_R"), Lang("GUILD_ALREADY_LAKED"))
end
--公会活动红点判定
function CheckGuildActivityRedSignMethod()
    if CheckGuildBookRedSignMethod() > 0 then
        return 1
    end
    return 0
end

--公会组织手册红点判定
function CheckGuildBookRedSignMethod()
    local l_canGetPersonalReward = GetCanGetPersonalReward()
    if #l_canGetPersonalReward > 0 then
        return 1
    end
    return 0
end
function onGuildOrganizePersonRewardInfoChanged()
    MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(eRedSignKey.Guild)
    MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(eRedSignKey.GuildBook)
    MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(eRedSignKey.GuildActivity)
end
--endregion-------------------------  End  对外访问数据接口  ------------------------------

return GuildMgr