---@module ModuleMgr.TeamMgr
module("ModuleMgr.TeamMgr", package.seeall)
require "Stage/StageMgr"

EventDispatcher = EventDispatcher.new()

maxGetRoleBreafInfo = 30
---@type ModuleData.TeamData
local l_teamData = DataMgr:GetData("TeamData")
local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")

function OnReconnected(reconnectData)
    --断线重连重新拉一下组队数据
    GetTeamInfo()
    GetTeamMatchStatus()
    --断线重连重新拉一下申请列表数据
    if MPlayerInfo.UID == l_teamData.myTeamInfo.captainId then
        ModuleMgr.TeamMgr:GetApplicationLists()
    end
    IsInSoloDungeon()
end

function OnEnterScene(sceneId)
    if MPlayerInfo.PlayerDungeonsInfo.DungeonID ~= 0 then
        IsAllMemberAssist()
    end

    IsInSoloDungeon()
    if sceneId == MGlobalConfig:GetInt("G_MatchPrepSceneId") then
        l_teamData.SetCanUseTeamFunc(false)
        GetTeamInfo()
    else
        l_teamData.SetCanUseTeamFunc(true)
    end
end

function OnSelectRoleNtf(info)
    GetTeamInfo()
    OnLogin()
end

--请求创建队伍
function RequestCreateTeam(targetId)
    if targetId == nil then
        targetId = 1000
    end
    local l_msgId = Network.Define.Rpc.CreateTeam
    ---@type CreateTeamArg
    local l_sendInfo = GetProtoBufSendTable("CreateTeamArg")
    l_sendInfo.team_setting.target = targetId
    l_sendInfo.team_setting.name = Common.Utils.Lang("TEAM_DEFAULT_NAME", MPlayerInfo.Name)
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--创建队伍回掉
function OnCreateTeam(msg)
    ---@type CreateTeamRes
    local l_info = ParseProtoBufToTable("CreateTeamRes", msg)
    if l_info.error == 0 then
        UIMgr:ActiveUI(UI.CtrlNames.Team)
    else
        GetTeamInfo()
    end
end

--创建队伍，无论以何种方式都走这里
--自己创建
--邀请别人后自动创建
function CreateTeamNtf(msg)
    GetTeamInfo()
    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("CREATE_TEAM_NOTIFY"))
    --创建队伍成功 清楚组队邀请列表
    l_teamData.ClearTeamInvite()
    EventDispatcher:Dispatch(l_teamData.ON_SELF_IN_TEAM)   --自己入队 抛出事件
    --自己进组 清除组队频道的求组信息
    local l_chatDataMgr = DataMgr:GetData("ChatData")
    l_chatDataMgr.ClearChatInfoCacheByChannel(l_chatDataMgr.EChannel.TeamChat)
end

--邀请别的玩家入队
function InviteJoinTeam(UserID, UserLevel)
    --战场中邀请其他玩家入队，目标玩家需要等级需要与主角区间一致
    if StageMgr:GetCurStageEnum() == MStageEnum.BattlePre and UserLevel ~= nil then
        if not MgrMgr:GetMgr("BattleMgr").CanMatchingLevelSection(UserLevel) then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("BattleHintInvite")) --活动等级区间不匹配，邀请失败
            return
        end
    end

    if l_teamData.CheckIsInvateCd(UserID) then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("DONT_INVATE_SAMEONE"))
        return
    end

    local data = {}
    data.UserID = UserID
    data.LeftInvatCdTime = MGlobalConfig:GetFloat("TeamInviteCD", 5)
    l_teamData.AddTeamInvationCdList(data)
    --table.insert(teamInvationCdList, data)

    local l_msgId = Network.Define.Rpc.InviteJoinTeam
    ---@type InviteJoinTeamArg
    local l_sendInfo = GetProtoBufSendTable("InviteJoinTeamArg")
    l_sendInfo.user_id = tostring(UserID)
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnInviteJoinTeam(msg)
    ---@type InviteJoinTeamRes
    local l_info = ParseProtoBufToTable("InviteJoinTeamRes", msg)
    if l_info.error == 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("INVITE_JOIN_TEAM_OK"))
    elseif l_info.error == ErrorCode.ERR_TEAM_ALREADY_INOTHERTEAM then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("ERR_TEAM_ALREADY_INOTHERTEAM"))
    elseif l_info.error == ErrorCode.ERR_TEAM_ALREADY_INTEAM then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("ERR_TEAM_ALREADY_INTEAM"))
    elseif l_info.error == ErrorCode.ERR_TARGET_ROLE_OFFLINE then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("ERR_TARGET_ROLE_OFFLINE"))
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error))
    end
end

--队员推荐队员入队
function RecommandMember(UserID)
    local l_msgId = Network.Define.Rpc.RecommandMember
    ---@type RecommandMemberArg
    local l_sendInfo = GetProtoBufSendTable("RecommandMemberArg")
    l_sendInfo.role_id = tostring(UserID)
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnRecommandMember(msg)
    ---@type RecommandMemberRes
    local l_info = ParseProtoBufToTable("RecommandMemberRes", msg)
    if l_info.error ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error))
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("TIPS_INVITE_SUCCESS"))
    end
end

function RecommondJoinTeamNtf(msg)
    ---@type TeamInvatationData
    local l_info = ParseProtoBufToTable("TeamInvatationData", msg)
    local teamInfo = l_teamData.Pb2teamInfo(l_info.team_info)
    teamInfo.inviterId = l_info.inviter_id
    teamInfo.remainTime = l_teamData.TotalTime
    teamInfo.isStart = false       --是否开始计时
    teamInfo.isWaitCaptain = false  --是否是队长同意状态
    teamInfo.isInvate = false       --是否是邀请
    teamInfo.isRecommend = true     --是否是推荐
    teamInfo.inviterName = l_teamData.GetNameById(l_info.inviter_id, teamInfo)
    teamInfo.inviterLv = l_teamData.GetLvById(l_info.inviter_id, teamInfo)
    AddNewInvitation(teamInfo)
end

function OnSyncTeamMemberInfo(msg)
    ---@type MemberBaseInfo
    local l_info = ParseProtoBufToTable("MemberBaseInfo", msg)
    l_teamData.UpdateMemberBaseInfo(l_info)
end

--同意入队
function AcceptTeamInvatation()
    local teamInfo = l_teamData.GetInvitationTeamInfo()
    if teamInfo and teamInfo.inviterId then
        local l_msgId = Network.Define.Rpc.AcceptTeamInvatation
        ---@type AcceptTeamInvatationArg
        local l_sendInfo = GetProtoBufSendTable("AcceptTeamInvatationArg")
        l_sendInfo.team_id = teamInfo.teamId
        l_sendInfo.inviter_id = teamInfo.inviterId
        Network.Handler.SendRpc(l_msgId, l_sendInfo)
    end
end

function AcceptTeamInvatationByTeamInfo(teamInfo)
    if teamInfo and teamInfo.inviterId then
        local l_msgId = Network.Define.Rpc.AcceptTeamInvatation
        ---@type AcceptTeamInvatationArg
        local l_sendInfo = GetProtoBufSendTable("AcceptTeamInvatationArg")
        l_sendInfo.team_id = teamInfo.teamId
        l_sendInfo.inviter_id = teamInfo.inviterId
        Network.Handler.SendRpc(l_msgId, l_sendInfo)
    end
end

function OnAcceptTeamInvatation(msg)
    ---@type AcceptTeamInvatationRes
    local l_info = ParseProtoBufToTable("AcceptTeamInvatationRes", msg)
    if l_info.error ~= 0 then
        l_teamData.HidTeamInvite()
    else
        l_teamData.ClearTeamInvite()
    end
end

function NewTeamInvatationNtf(msg)
    ---@type TeamInvatationData
    local l_info = ParseProtoBufToTable("TeamInvatationData", msg)
    local teamInfo = l_teamData.Pb2teamInfo(l_info.team_info)
    teamInfo.inviterId = l_info.inviter_id
    teamInfo.remainTime = l_teamData.TotalTime
    teamInfo.isStart = false       --是否开始计时
    teamInfo.isWaitCaptain = false  --是否是队长同意状态
    teamInfo.isInvate = true        --是否是邀请
    teamInfo.isRecommend = false    --是否是推荐
    teamInfo.inviterName = l_teamData.GetNameById(l_info.inviter_id, teamInfo)
    teamInfo.inviterLv = l_teamData.GetLvById(l_info.inviter_id, teamInfo)
    AddNewInvitation(teamInfo)
end

function AddNewInvitation(teamInfo)
    --没有组队方可被推荐和邀请
    if not l_teamData.myTeamInfo.isInTeam then
        l_teamData.AddTeamInviteList(teamInfo)
        if table.maxn(TeamInviteList) > 1 then
            EventDispatcher:Dispatch(l_teamData.ON_ADD_NEW_INVATION)
        end
    end

    if l_teamData.CheckTeamInvite() and not UIMgr:IsActiveUI(UI.CtrlNames.TeamOfferList) then
        ShowNewInvite()
    end

end

--todo re_timer
function OnUpdate()
    local l_teamInvationCdList = l_teamData.TeamInvationCdList
    if table.maxn(l_teamInvationCdList) > 0 then
        for i = table.maxn(l_teamInvationCdList), 1, -1 do
            local data = l_teamInvationCdList[i]
            if data.LeftInvatCdTime > 0 then
                data.LeftInvatCdTime = data.LeftInvatCdTime - UnityEngine.Time.deltaTime
            else
                table.remove(l_teamInvationCdList, i)
            end
        end
    end
    local l_teamInviteList = l_teamData.TeamInviteList
    if table.maxn(l_teamInviteList) > 0 then
        if NeedShowTeamOffer() then
            for z = 1, table.maxn(l_teamInviteList) do
                l_teamInviteList[z].remainTime = l_teamInviteList[z].remainTime - UnityEngine.Time.deltaTime
                if l_teamInviteList[z].remainTime < 0 then
                    table.remove(l_teamInviteList, z)
                else
                    ShowNewInvite()
                end
            end
        end
    end
end

function ShowNewInvite()
    UIMgr:ActiveUI("TeamOffer")
end

function NeedShowTeamOffer()
    local l_teamOffer = UIMgr:GetUI("TeamOffer")
    local l_teamOfferList = UIMgr:GetUI("TeamOfferList")
    if l_teamOffer ~= nil and l_teamOffer.isActive then
        return false
    end
    if l_teamOfferList~=nil then
        if l_teamOfferList.isActive then
            return false
        end
    end
    if UIMgr:IsPanelAtActiveStatus(UI.CtrlNames.TeamOfferList) then
        return false
    end
    return true
end

--新成员入队广播
function NewTeamMemberNtf(msg)
    ---@type NewMemberNtfData
    local l_info = ParseProtoBufToTable("NewMemberNtfData", msg)
    local addName = Common.Utils.PlayerName(l_info.name)
    local addUserId = l_info.uid
    if l_teamData.GetIsInTeam() or l_teamData.myTeamInfo.isInTeam then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("TEAM_NEW_MEMBER_NOTIFY", addName))
        ShowTeamInfoMsg(Lang("MSG_JOIN_IN_TEAM", GetColorText(addName, RoColorTag.Blue)))
    else
        l_teamData.SetIsInTeam(true)
        if l_info.notice then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.notice.errorno))
        end
    end
    if addUserId == MPlayerInfo.UID then
        l_teamData.SetIsInTeam(true)
        --自己进组 清除组队频道的求组信息
        local l_chatDataMgr = DataMgr:GetData("ChatData")
        l_chatDataMgr.ClearChatInfoCacheByChannel(l_chatDataMgr.EChannel.TeamChat)
        l_teamData.ClearTeamInvite()
        EventDispatcher:Dispatch(l_teamData.ON_SELF_IN_TEAM)    --自己入队 抛出事件
        ShowTeamInfoMsg(Lang("MSG_JOIN_IN_TEAM", Lang("YOU")))
        MEventMgr:LuaFireGlobalEvent(MEventType.MEvent_MercenaryChange) --自己进队,发送佣兵变化处理
        MEventMgr:LuaFireGlobalEvent(MEventType.MEvent_CameraShowTypeChange)
    end
    --新人进组 重新GetTeamInfo
    GetTeamInfo()
    --新人进组 检测下申请列表 如果在申请列表有该人 移除该对象
    l_teamData.RemoveTeamApplicationInfoById(addUserId)

    onTeamApplicationInfoChange()                           --红点判定
    EventDispatcher:Dispatch(l_teamData.ON_TEAM_INFO_UPDATE)           --新成员入队 抛出队员更新事件
    EventDispatcher:Dispatch(l_teamData.ON_TEAM_APPLY_INFO_UPDATE)     --新成员入队 抛出申请界面更新事件
    EventDispatcher:Dispatch(l_teamData.ON_NEW_TEAM_MEMBER)            --新成员入队 抛出刷新事件
end

--离开队伍
function LeaveTeam()
    local l_msgId = Network.Define.Rpc.LeaveTeam
    Network.Handler.SendRpc(l_msgId)
end

function OnLeaveTeam(msg)
    ---@type LeaveTeamRes
    local l_info = ParseProtoBufToTable("LeaveTeamRes", msg)
    if l_info.error ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error))
    else
        FollowEndMsg(Common.Utils.Lang("STOP_FOLLOW_LEAVETEAM"))
        l_teamData.SetIsInTeam(false)
        MEventMgr:LuaFireGlobalEvent(MEventType.MEvent_CameraShowTypeChange)
    end
end

function CloseTeamQuickFuncPanel()
    UIMgr:DeActiveUI(UI.CtrlNames.TeamQuickFunc)
end

--其他队员收到xxx离开队伍的推送
function LeaveTeamNtf(msg)
    ---@type OutTeamNtfData
    local l_info = ParseProtoBufToTable("OutTeamNtfData", msg)
    local l_self = l_info.id == MPlayerInfo.UID
    local l_targetInfo = nil
    if l_self then
        --MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("TEAM_LEAVE_OK"))
        --后续增加默认初始数据
        if l_info.notice then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.notice.errorno))
        end
        l_teamData.ResetTeamInfo()
        ResetTeamApplication()
        UIMgr:DeActiveUI(UI.CtrlNames.Team)
        EventDispatcher:Dispatch(l_teamData.ON_TEAM_AUTOPAIR_STATUS) --发出刷新组队自动匹配状态的事件
        ShowTeamInfoMsg(Lang("MSG_LEVAVE_TEAM", Lang("YOU")))
    elseif l_teamData.myTeamInfo.isInTeam then
        local leaveTeamName = ""
        local isCaptain = false
        isCaptain, l_targetInfo = l_teamData.RemoveMember(l_info.id)
        if not l_targetInfo then
            return
        end
        if isCaptain then
            FollowEndMsg(Lang("TEAM_CAPTAIN_LEAVE_TIP"))
        end
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("TEAM_KICK_MEMBER_NOTIFY", l_targetInfo.roleName))
        ShowTeamInfoMsg(Lang("MSG_LEVAVE_TEAM", GetColorText(l_targetInfo.roleName, RoColorTag.Blue)))
    end

    CloseTeamQuickFuncPanel()
    EventDispatcher:Dispatch(l_teamData.ON_QUIT_TEAM_MEMBER, l_targetInfo)   --自己或队员离队
    EventDispatcher:Dispatch(l_teamData.ON_TEAM_INFO_UPDATE, l_self)   --自己或队员离队 人数变更 抛出队伍更新事件
    if l_self then
        MEventMgr:LuaFireGlobalEvent(MEventType.MEvent_MercenaryChange)
    end --自己离队 发送更新佣兵事件  小地图用
end

function TeamMercenaryChangeNtf(msg)
    ---@type TeamMercenaryChangeData
    local l_info = ParseProtoBufToTable("TeamMercenaryChangeData", msg)
    l_teamData.RefreshMercenaryInfo(l_info.mercenarys)
    EventDispatcher:Dispatch(l_teamData.ON_TEAM_INFO_UPDATE)
    --佣兵变化 向C#跑个事件，处理下小地图显示 为啥延迟0.1s 因为需要等待一帧 C#Team数据处理
    local timer = Timer.New(function()
        MEventMgr:LuaFireGlobalEvent(MEventType.MEvent_MercenaryChange)
        timer = nil
    end, 0.1)
    timer:Start()
end

--依据UserId获取一个用户是否有组队 该用户是否是队长
function GetUserInTeamOrNot(cUserId)
    local l_msgId = Network.Define.Rpc.QueryIsInTeam
    ---@type QueryIsInTeamArg
    local l_sendInfo = GetProtoBufSendTable("QueryIsInTeamArg")
    l_sendInfo.uid = tostring(cUserId)--cUserId:tostring()
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--服务器返回用户是否有组队
function OnGetUserInTeamOrNot(msg, arg)
    ---@type QueryIsInTeamRes
    local l_info = ParseProtoBufToTable("QueryIsInTeamRes", msg)
    EventDispatcher:Dispatch(l_teamData.ON_GET_PLAYER_TEAM_FRIEND_INFO, l_info, arg.uid)
end

--路人申请入队
function BegInTeam(cUserId)
    local l_msgId = Network.Define.Rpc.BegJoinTeam
    ---@type BegJoinTeamArg
    local l_sendInfo = GetProtoBufSendTable("BegJoinTeamArg")
    l_sendInfo.uid = tostring(cUserId)
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function BegInTeamByTeamId(cTeamId)
    local l_msgId = Network.Define.Rpc.BegJoinTeam
    ---@type BegJoinTeamArg
    local l_sendInfo = GetProtoBufSendTable("BegJoinTeamArg")
    l_sendInfo.team_id = MLuaCommonHelper.Int(cTeamId)
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function onBegInTeam(msg)
    ---@type BegJoinTeamRes
    local l_info = ParseProtoBufToTable("BegJoinTeamRes", msg)
    if l_info.error ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error))
        if l_info.team_id then
            l_teamData.RemoveFromTeamListByTeamId(l_info.team_id)
            EventDispatcher:Dispatch(l_teamData.ON_TEAMSEARCH_INFO_UPDATE)   --加入组队失败 发出刷新组队查询列表的请求
        end
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("HAS_SEND_TEAMOFFER"))
    end
end

--队长收到有人申请入队
function OnTeamApplicationNtf(msg)
    ---@type TeamApplicationData
    local l_info = ParseProtoBufToTable("TeamApplicationData", msg)
    if l_teamData.AddTeamApplication(l_info) then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("NEW_TEAM_APPLICATION"))
    end

    EventDispatcher:Dispatch(l_teamData.ON_TEAM_APPLY_INFO_UPDATE)     --新成员入队 抛出申请界面更新事件
    onTeamApplicationInfoChange()                           --红点判定
end

function onTeamApplicationInfoChange()
    MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(eRedSignKey.TeamApply)
end

function CheckRedSignMethod()
    return table.maxn(l_teamData.TeamApplicationInfo)
end

--设置队长
function SetCaptain(cUserId)
    local l_msgId = Network.Define.Ptc.HandOverCaptainReq
    ---@type UserID
    local l_sendInfo = GetProtoBufSendTable("UserID")
    l_sendInfo.uid = cUserId
    Network.Handler.SendPtc(l_msgId, l_sendInfo)
end

--队长变更广播
function OnCaptainChangeNtf(msg)
    ---@type CaptainChangeNtfData
    local l_info = ParseProtoBufToTable("CaptainChangeNtfData", msg)
    local beforCaptainId = l_teamData.myTeamInfo.captainId
    local changeType = l_info.type
    l_teamData.SetCaptainData(l_info.captain_id)
    if l_info.captain_id == MPlayerInfo.UID then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("HASBEAN_TEAM_CAPTAIN"))
    else
        if changeType == CaptainChangeType.CHANGE_CAPTAIN_TYPE_APPLY then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("MSG_ONCELEAVE_SET_CAPTAIN", l_teamData.GetNameById(l_info.captain_id)))
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("PLAYER_BEAN_TEAM_CAPTAIN", l_teamData.GetNameById(l_info.captain_id)))
        end
    end
    --队长变更停止跟随
    FollowEndMsg(Common.Utils.Lang("STOP_FOLLOW_CAPTAINCHANGE"))
    EventDispatcher:Dispatch(l_teamData.ON_TEAM_INFO_UPDATE)     --队长变更 抛出队伍更新事件
    EventDispatcher:Dispatch(l_teamData.ON_TEAM_AUTOPAIR_STATUS) --发出刷新组队自动匹配状态的事件

    --以下处理文本信息
    if changeType == CaptainChangeType.CHANGE_CAPTAIN_TYPE_HANDOVER then
        ShowTeamInfoMsg(Common.Utils.Lang("MSG_SET_CAPTAIN", GetColorText(l_teamData.GetNameById(beforCaptainId), RoColorTag.Blue), GetColorText(l_teamData.GetNameById(l_info.captain_id), RoColorTag.Blue)))
    elseif changeType == CaptainChangeType.CHANGE_CAPTAIN_TYPE_OFFLINE then
        ShowTeamInfoMsg(Common.Utils.Lang("MSG_OFFLINE_SET_CAPTAIN", GetColorText(l_teamData.GetNameById(beforCaptainId), RoColorTag.Blue), GetColorText(l_teamData.GetNameById(l_info.captain_id), RoColorTag.Blue)))
    elseif changeType == CaptainChangeType.CHANGE_CAPTAIN_TYPE_APPLY then
        ShowTeamInfoMsg(Common.Utils.Lang("MSG_APPLY_SET_CAPTAIN", GetColorText(l_teamData.GetNameById(l_info.captain_id), RoColorTag.Blue)))
    elseif changeType == CaptainChangeType.CHANGE_CAPTAIN_TYPE_LEAVE then
        ShowTeamInfoMsg(Common.Utils.Lang("MSG_CAPTAINELEAVE_SET_CAPTAIN", GetColorText(l_teamData.GetNameById(l_info.captain_id), RoColorTag.Blue)))
    end
    MEventMgr:LuaFireGlobalEvent(MEventType.MEvent_CameraShowTypeChange)
end

function SetCaptainFunc(targetUid)
    local l_txt = Common.Utils.Lang("SET_TEAM_CAPTAIN", l_teamData.GetNameById(targetUid))
    local confirmFunc = function()
        MgrMgr:GetMgr("TeamMgr").SetCaptain(targetUid)
    end
    local cancleFunc = function()

    end
    CommonUI.Dialog.ShowYesNoDlg(true, nil, l_txt, confirmFunc, cancleFunc, 10)
end

function SetLeaveTeamByCaptainFunc(targetUid)
    local l_txt = Common.Utils.Lang("LEAVE_TEAM_BY_CAPTAIN", l_teamData.GetNameById(targetUid))
    local confirmFunc = function()
        MgrMgr:GetMgr("TeamMgr").LeaveByCaptainKick(targetUid)
    end
    local cancleFunc = function()

    end
    CommonUI.Dialog.ShowYesNoDlg(true, nil, l_txt, confirmFunc, cancleFunc, 10)
end

--申请成为队长
function ApplyForCaptain()
    local l_msgId = Network.Define.Rpc.ApplyForCaptain
    ---@type ApplyForCaptainArg
    local l_sendInfo = GetProtoBufSendTable("ApplyForCaptainArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--申请成为队长响应
function OnApplyForCaptain(msg)
    ---@type ApplyForCaptainRes
    local l_info = ParseProtoBufToTable("ApplyForCaptainRes", msg)
    if l_info.error.errorno ~= 0 then
        if l_info.error.param and l_info.error.param[1] and l_info.error.param[1].value then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("TEAM_HAS_ALREADY_APPLY", l_info.error.param[1].value))
            return
        end
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error.errorno))
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("APPLY_CAPTAIN_SUCCESS"))
    end
end

function IsAllMemberAssist()
    local l_msgId = Network.Define.Rpc.IsAllMemberAssist
    ---@type IsAllMemberAssist
    local l_sendInfo = GetProtoBufSendTable("IsAllMemberAssist")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnIsAllMemberAssist(msg)
    ---@type IsAllMemberAssistRes
    local l_info = ParseProtoBufToTable("IsAllMemberAssistRes", msg)
    if l_info.is_all_member_assist then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("ASSIST_ALL_NOT"))
    end
end

--队长处理队长申请
function RespondForApplyCaptain(sendType)
    local l_msgId = Network.Define.Rpc.RespondForApplyCaptain
    ---@type RespondForApplyCaptainArg
    local l_sendInfo = GetProtoBufSendTable("RespondForApplyCaptainArg")
    l_sendInfo.type = sendType
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnRespondForApplyCaptain(msg)
    ---@type RespondForApplyCaptainRes
    local l_info = ParseProtoBufToTable("RespondForApplyCaptainRes", msg)
    if l_info.error ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowErrorCodeTips(l_info.error)
    end
end

--申请成为队长推送
function OnApplyCaptainNtf(msg)
    ---@type UserID
    local l_info = ParseProtoBufToTable("UserID", msg)
    if l_info.uid == MPlayerInfo.UID then
        --自己不显示
    else
        myIsCaptain = MPlayerInfo.UID == l_teamData.myTeamInfo.captainId
        if myIsCaptain then
            local l_openData = {
                openType = MgrMgr:GetMgr("VehicleMgr").EOpenType.AddOfferInfo,
                closeFuc = function()
                    MgrMgr:GetMgr("TeamMgr").RespondForApplyCaptain(replyType.no)
                end,
                okFuc = function()
                    MgrMgr:GetMgr("TeamMgr").RespondForApplyCaptain(replyType.yes)
                end,
                nameTxt = Common.Utils.Lang("TEAM_APPLY_CAPTAIN_WORD"),
                labTxt = Common.Utils.Lang("TEAM_APPLY_CAPTAIN", l_teamData.GetNameById(l_info.uid)),
                totalTime = 10,
                cTime = 0,
                timeOverIsCancle = false,
                strBtnYesKey = ""
            }
            UIMgr:ActiveUI(UI.CtrlNames.VehicleOffer, l_openData)
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("TEAM_APPLY_CAPTAIN", l_teamData.GetNameById(l_info.uid)))
        end
    end
end

--队长拒绝申请队长推送
function OnRefuseCaptainApplyNtf(msg)
    ---@type UserID
    local l_info = ParseProtoBufToTable("UserID", msg)
    myIsCaptain = MPlayerInfo.UID == l_teamData.myTeamInfo.captainId
    if not myIsCaptain then
        Common.Utils.Lang("CONFUSE_TEAM_CAPTAIN")
    end
end

--队长踢人
function LeaveByCaptainKick(cUserId)
    local l_msgId = Network.Define.Rpc.KickTeamMember
    ---@type KickTeamMemberArg
    local l_sendInfo = GetProtoBufSendTable("KickTeamMemberArg")
    l_sendInfo.user_id = cUserId
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnLeaveByCaptainKick(msg)
    ---@type KickTeamMemberRes
    local l_info = ParseProtoBufToTable("KickTeamMemberRes", msg)
    if l_info.error ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error))
    end
end

--队长踢人广播队员
function OnKickTeamMemberNtf(msg)
    ---@type OutTeamNtfData
    local l_info = ParseProtoBufToTable("OutTeamNtfData", msg)
    if l_info.id == MPlayerInfo.UID then
        --自己被移除 重置组队数据
        l_teamData.ResetTeamInfo()
        UIMgr:DeActiveUI(UI.CtrlNames.Team)
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("TEAM_KICK_BY_SELF"))
        if l_info.notice and l_info.notice.errorno ~= ErrorCode.ERR_LEAVE_TEAM_NORMAL then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.notice.errorno))
        end
        l_teamData.SetIsInTeam(false)
        --自己被移除 停止跟随
        FollowEndMsg(Common.Utils.Lang("STOP_FOLLOW_BEKICKED"))
        MEventMgr:LuaFireGlobalEvent(MEventType.MEvent_CameraShowTypeChange)
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("TEAM_KICK_BY_OTHERS", l_teamData.GetNameById(l_info.id)))
        --不是自己 组队信息移除对应队员
        l_teamData.RemoveMember(l_info.id)
    end

    EventDispatcher:Dispatch(l_teamData.ON_TEAM_INFO_UPDATE)   --队长踢人 队伍人数变更 抛出队伍更新事件
end

-------------------消息弃用------------------
--队伍成员位置同步
function OnMemberPosNtf(msg)
    ---@type AllMemberPosInfo
    local l_info = ParseProtoBufToTable("AllMemberPosInfo", msg)
    local l_teamMemberPosList = l_teamData.TeamMemberPosList
    for i = 1, table.maxn(l_info.members) do
        local l_roleid = l_info.members[i].role_id
        local pos = l_info.members[i].pos
        if l_teamMemberPosList[l_roleid] then
            l_teamMemberPosList[l_roleid].pos = pos
        else
            l_teamMemberPosList[l_roleid] = {}
            l_teamMemberPosList[l_roleid].pos = pos
        end
    end
end
-------------------消息弃用------------------


--用于标志是邀请个人还是所有人
isToBeFollowAllOrOne = 0
--队长邀请跟随 有参数邀请个人 无参邀请所有

function ToBeFollowed(cUserId)
    local l_msgId = Network.Define.Rpc.ToBeFollowed
    ---@type ToBeFollowedArg
    local l_sendInfo = GetProtoBufSendTable("ToBeFollowedArg")
    l_sendInfo.uid = cUserId
    isToBeFollowAllOrOne = 1
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--一键召集
function ToBeFollowedAll()
    local memberList = l_teamData.myTeamInfo.memberList
    if memberList then
        if table.maxn(memberList) == 1 then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("TEAM_CAN_NOT_TPBEFOLLOW"))
            return
        end
    end

    local l_msgId = Network.Define.Rpc.ToBeFollowed
    ---@type ToBeFollowedArg
    local l_sendInfo = GetProtoBufSendTable("ToBeFollowedArg")
    isToBeFollowAllOrOne = 2
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnToBeFollowed(msg)
    ---@type ToBeFollowedRes
    local l_info = ParseProtoBufToTable("ToBeFollowedRes", msg)
    if l_info.error ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error))
    else
        if isToBeFollowAllOrOne == 1 then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("TEAM_TOBEFOLLOW_SUCCESS"))
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("TEAM_SEND_TOBEFOLLOW"))
        end
    end
end

replyType = {
    yes = 1,
    no = 0,
}

--队员收到了跟随消息 选择是否跟随
function ReplyToBeFollowed(cType)
    local l_msgId = Network.Define.Rpc.ReplyToBeFollowed
    ---@type ReplyToBeFollowedArg
    local l_sendInfo = GetProtoBufSendTable("ReplyToBeFollowedArg")
    l_sendInfo.type = cType
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnReplyToBeFollowed(msg)
    ---@type ReplyToBeFollowedRes
    local l_info = ParseProtoBufToTable("ReplyToBeFollowedRes", msg)
    if l_info.error ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error))
    end
end

--本地存储跟随Id
followerId = nil
--收到服务器推送的跟随Id  开始跟随
function OnBeginFollowNtf(msg)
    ---@type BeginFollowNtfData
    local l_info = ParseProtoBufToTable("BeginFollowNtfData", msg)
    followerId = l_info.uid
    if followerId then
        MPlayerInfo.FollowerUid = l_info.uid
        FollowSet(true)
    end
end

function FollowSet(state)

    --特殊情况下跟随处理
    if state then
        if MEntityMgr.PlayerEntity ~= nil then
            if MEntityMgr.PlayerEntity.IsClimb --攀爬
                    or MEntityMgr.PlayerEntity.IsFishing --钓鱼
                    or MEntityMgr.PlayerEntity.IsOnSky --在天上
                    or MEntityMgr.PlayerEntity.IsOnSeat then
                --在交互中
                SendEndFollowRpc()
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("CAN_NOT_FOLLOW_IN_THIS_STATE"))
                return
            end
        end
    end

    --存储这次函数是否改变了Follow状态
    local isStateChange = l_teamData.Isfollowing ~= state
    l_teamData.SetIsFollowing(state)
    MPlayerInfo.IsAutoFollow = state
    MPlayerInfo.IsAutoBattle = state
    MPlayerInfo.IsFollowing = state

    if state then
        if isStateChange then
            --开始跟随 监听事件
            MPlayerInfo:RegistFollowEvent()
            --进入跟随 结束暂离
            SetTeamAfkByState(nil, false)
        end
    else
        --结束跟随 移除全局事件的监听
        MPlayerInfo:RemoveFollowEvent()
        --结束跟随 关掉定时器
        MPlayerInfo:StopFollowTimer()
        --结束跟随 打断当前寻路
        MTransferMgr:Interrupt()
        --结束跟随重置 跟随者ID
        followerId = nil
        MPlayerInfo.FollowerUid = 0
    end
    EventDispatcher:Dispatch(l_teamData.ON_TEAM_FOLLOW_STATE_CHANGE)   --跟随状态发生变化 抛出事件
end

function FollowEndMsg(msgStr)
    if l_teamData.Isfollowing then
        SendEndFollowRpc()
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(msgStr)
        FollowSet(false)
    end
end

function OnAskFollowNtf(msg)
    ---@type AskFollowNtfData
    local l_info = ParseProtoBufToTable("AskFollowNtfData", msg)

    --if not isfollowing then
    local l_openData = {
        openType = MgrMgr:GetMgr("VehicleMgr").EOpenType.AddOfferInfo,
        closeFuc = function()
            MgrMgr:GetMgr("TeamMgr").ReplyToBeFollowed(replyType.no)
        end,
        okFuc = function()
            if MgrMgr:GetMgr("ChatRoomMgr").Room:Has() then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ChatRoom_TeamHint")) --当前状态不能进行组队跟随
                MgrMgr:GetMgr("TeamMgr").ReplyToBeFollowed(replyType.no)
                return
            end
            MgrMgr:GetMgr("TeamMgr").ReplyToBeFollowed(replyType.yes)
        end,
        nameTxt = Common.Utils.Lang("TEAM_ASKFOLLOW"),
        labTxt = Common.Utils.Lang("TEAM_FOLLOW_CAPTAIN_OR_NOT") .. l_teamData.GetNameById(l_info.uid),
        totalTime = 10,
        cTime = 0,
        timeOverIsCancle = false,
        strBtnYesKey = ""
    }
    UIMgr:ActiveUI(UI.CtrlNames.VehicleOffer, l_openData)
    --end
end

--请求跟随
function FollowOtherPeople(cUserId)
    local l_msgId = Network.Define.Rpc.FollowOthers
    ---@type FollowOthersArg
    local l_sendInfo = GetProtoBufSendTable("FollowOthersArg")
    l_sendInfo.uid = cUserId
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnFollowOtherPeople(msg)
    ---@type FollowOthersRes
    local l_info = ParseProtoBufToTable("FollowOthersRes", msg)
    if l_info.error ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error))
    end
end

function SetEndAutoFollow()
    FollowEndMsg(Common.Utils.Lang("STOP_FOLLOW_BYSELF"))
end

--发送结束跟随的请求
function SendEndFollowRpc()
    local l_msgId = Network.Define.Ptc.StopFollow
    ---@type EmptyMsg
    local l_sendInfo = GetProtoBufSendTable("EmptyMsg")
    Network.Handler.SendPtc(l_msgId, l_sendInfo)
end

function OnStopFollowMS(msg)
    FollowSet(false)
end

--清除列表
function ClearApplicationListReq()
    local l_msgId = Network.Define.Ptc.ClearApplicationListReq
    ---@type EmptyMsg
    local l_sendInfo = GetProtoBufSendTable("EmptyMsg")
    Network.Handler.SendPtc(l_msgId, l_sendInfo)
end

--同意进组
function Acceptjointeam(cUserId)
    local l_msgId = Network.Define.Rpc.Acceptbegjointeam
    ---@type AcceptBegJoinTeamArg
    local l_sendInfo = GetProtoBufSendTable("AcceptBegJoinTeamArg")
    l_sendInfo.uid = cUserId
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnAcceptbegjointeam(msg)
    local l_info = ParseProtoBufToTable("AcceptBegJoinTeamRes", msg)
    if l_info.error ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error))
    end
end

--获取申请入队列表
function GetApplicationLists()
    local l_msgId = Network.Define.Rpc.GetApplicationList
    ---@type GetApplicationListArg
    local l_sendInfo = GetProtoBufSendTable("GetApplicationListArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnGetApplicationList(msg)
    ---@type GetApplicationListRes
    local l_info = ParseProtoBufToTable("GetApplicationListRes", msg)
    if l_info.error ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error))
    else
        l_teamData.SetTeamApplicationInfo(l_info.members)--重置申请列表数据
    end
    EventDispatcher:Dispatch(l_teamData.ON_TEAM_APPLY_INFO_UPDATE)     --新成员入队 抛出申请界面更新事件
end

--获取邀请列表
--请求推荐队友ID list列表 注释：1好友 2工会 3最近组队 4佣兵
function GetInvitationIdListByType(searchtype)
    local l_msgId = Network.Define.Rpc.GetInvitationList
    ---@type GetInvitationListArg
    local l_sendInfo = GetProtoBufSendTable("GetInvitationListArg")
    l_sendInfo.type = searchtype ~= nil and searchtype or 3
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnGetInvitationIdListByType(msg)
    ---@type GetInvitationListRes
    local l_info = ParseProtoBufToTable("GetInvitationListRes", msg)
    if l_info.error ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error))
    else
        GetRoleInfoListByIds(l_info.role_ids, l_teamData.ERoleInfoType.TeamRecommend)
        GetRoleInfoListByIds(l_info.spcial_recommand, l_teamData.ERoleInfoType.TeamSpecialRecommend)
    end
end

--根据请求的Id列表 请求信息
function GetRoleInfoListByIds(IdTb, Type)
    local l_msgId = Network.Define.Rpc.QueryRoleBriefInfo
    ---@type QueryRoleBriefInfoArg
    local l_sendInfo = GetProtoBufSendTable("QueryRoleBriefInfoArg")
    for i = 1, #IdTb do
        if i > maxGetRoleBreafInfo then
            break
        end
        local oneItem = l_sendInfo.role_ids:add()
        oneItem.value = IdTb[i].value
    end
    l_sendInfo.query_type = Type
    Network.Handler.SendRpc(l_msgId, l_sendInfo)

end

function OnGetRoleInfoListByIds(msg, arg, customData)
    ---@type QueryRoleBriefInfoRes
    local l_info = ParseProtoBufToTable("QueryRoleBriefInfoRes", msg)
    if l_info.error ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error))
    else
        if l_info.query_type == l_teamData.ERoleInfoType.PvPResult then
            MgrMgr:GetMgr("HeadMgr").OnHeadInfoRsp(l_info, arg, customData)
            return
        end

        if l_info.query_type == l_teamData.ERoleInfoType.TeamRecommend or l_info.query_type == l_teamData.ERoleInfoType.TeamSpecialRecommend then
            --如果是组队推荐
            if l_info.query_type == l_teamData.ERoleInfoType.TeamRecommend then
                l_teamData.SetTeamInvationList(l_info.base_infos)
            end
            --如果是组队特殊推荐 那么插入到列表的最前面
            if l_info.query_type == l_teamData.ERoleInfoType.TeamSpecialRecommend then
                for i = 1, table.maxn(l_info.base_infos) do
                    l_teamData.AddNewInvitation(l_info.base_infos[i], 1)
                end
            end
        end

        if l_info.query_type == l_teamData.ERoleInfoType.FashionCollection then
            --如果是时尚杂志
            MgrMgr:GetMgr("FashionRatingMgr").CreatePlayerModel(l_info.base_infos[1])
            return
        end

        if l_info.query_type == l_teamData.ERoleInfoType.Rank then
            MgrMgr:GetMgr("RankMgr").SetSelectTeamInfo(l_info.base_infos)
            return
        end

        local l_ui = UIMgr:GetUI(UI.CtrlNames.TeamInvite)
        if l_ui then
            l_ui:SetPanelByInfo(l_teamData.TeamInvationList)
        else
            GetRecentTeamMate()
            local l_openData = {
                openType = l_teamData.ETeamOpenType.SetPanelByInfo,
                openData = l_teamData.TeamInvationList
            }
            UIMgr:ActiveUI(UI.CtrlNames.TeamInvite, l_openData)
        end
    end
end

--请求队伍设置
function TeamSetting(teamSettingInfo)
    local l_msgId = Network.Define.Rpc.TeamSetting
    ---@type TeamSettingArg
    local l_sendInfo = GetProtoBufSendTable("TeamSettingArg")
    l_sendInfo.team_setting.min_lv = teamSettingInfo.min_lv ~= nil and teamSettingInfo.min_lv or 0
    l_sendInfo.team_setting.max_lv = teamSettingInfo.max_lv ~= nil and teamSettingInfo.max_lv or 0
    l_sendInfo.team_setting.target = teamSettingInfo.target ~= nil and teamSettingInfo.target or 0
    l_sendInfo.team_setting.sub_target = teamSettingInfo.sub_target ~= nil and teamSettingInfo.sub_target or 0
    l_sendInfo.team_setting.name = teamSettingInfo.name ~= nil and teamSettingInfo.name or Common.Utils.Lang("TEAM_DEFAULT_NAME", l_teamData.myTeamInfo.captainName)
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnTeamSetting(msg)
    ---@type TeamSettingRes
    local l_info = ParseProtoBufToTable("TeamSettingRes", msg)
    if l_info.error ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowErrorCodeTips(l_info.error)
    end
end

function OnTeamSettingNtf(msg)
    ---@type TeamSettingNtfData
    local l_info = ParseProtoBufToTable("TeamSettingNtfData", msg)

    if l_info.ts == nil then
        return
    end

    if l_info.ts.name ~= l_teamData.myTeamInfo.teamSetting.name then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("TEAM_CHANGE_TEAM_NAME", l_info.ts.name))
    end

    if l_info.ts.target ~= l_teamData.myTeamInfo.teamSetting.target then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("TEAM_CHANGE_TEAM_TARGET", DataMgr:GetData("TeamData").GetTargetNameById(l_info.ts.target)))
    end
    l_teamData.SetTeamSetting(l_info.ts)
    --todo callback
    local l_ui = UIMgr:GetUI(UI.CtrlNames.Team)
    if l_ui then
        local cHandlerTeamMember = l_ui:GetHandlerByName(UI.HandlerNames.TeamMember)
        if cHandlerTeamMember and cHandlerTeamMember.uObj and cHandlerTeamMember.isActive then
            UIMgr:DeActiveUI(UI.CtrlNames.TeamSet)
            cHandlerTeamMember:SetTeamInfo()
        end
    end
end



--本地存储 匹配类型
curAutoPairType = l_teamData.EAutoPairType.autoTypeNone
function AutoPairOperate(targetType, target, profession, wantLeader)
    local l_msgId = Network.Define.Rpc.AutoPairOperate
    ---@type AutoPairOperateArg
    local l_sendInfo = GetProtoBufSendTable("AutoPairOperateArg")
    l_sendInfo.type = targetType
    l_sendInfo.target = target
    l_sendInfo.want_team_captain = wantLeader
    if profession then
        for i = 1, #profession do
            l_sendInfo.professions[i] = profession[i]
        end
    end
    curAutoPairType = targetType
    l_teamData.SetAutoPairTarget(target)
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnAutoPairOperate(msg, arg)
    ---@type AutoPairOperateRes
    local l_info = ParseProtoBufToTable("AutoPairOperateRes", msg)
    if l_info.error ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error))
    else
        l_teamData.SetIsAutoPair(curAutoPairType == 1)
        if curAutoPairType == 1 then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("TEAM_START_AUTOPAIR"))
        end
        EventDispatcher:Dispatch(l_teamData.ON_TEAM_AUTOPAIR_STATUS) --发出刷新组队自动匹配状态的事件
        local _type = GameEnum.ETeamMatchProcessState.TeamMatch
        if l_teamData.myTeamInfo.captainId == -1 then
            _type = GameEnum.ETeamMatchProcessState.PlayerMatch
        end
        if arg.type == DataMgr:GetData("TeamData").EAutoPairType.autoTypeStart then
            ActiveCareerPanel(_type)
        else
            UIMgr:DeActiveUI(UI.CtrlNames.TeamCareerChoice2)
        end
    end
end

function ActiveCareerPanel(_type)
    if _type == GameEnum.ETeamMatchProcessState.PlayerMatch then
        target = l_teamData.autoPairTarget or -1
    else
        target = l_teamData.myTeamInfo.teamSetting.target or -1
    end
    if target ~= -1 then
        UIMgr:ActiveUI(UI.CtrlNames.TeamCareerChoice2, { type = _type })
    end
end

function UpdateTeamProfessionsNTF(msg)
    ---@type UpdateTeamProfessionsData
    local l_info = ParseProtoBufToTable("UpdateTeamProfessionsData", msg)
    local l_mgr = MgrMgr:GetMgr("TeamLeaderMatchMgr")
    l_mgr.SetDefaultDutyList()
    for i = 1, #l_info.professions do
        l_mgr.SetSlotDuty(#l_teamData.myTeamInfo.memberList + i, l_info.professions[i])
    end
    l_teamData.MatchTimeStamp = l_info.start_time or -1
    ActiveCareerPanel(GameEnum.ETeamMatchProcessState.TeamMatch)
end

--匹配结果下发
function OnPairOverNtf(msg)
    ---@type PairOverData
    local l_info = ParseProtoBufToTable("PairOverData", msg)
    if l_info.reason == 1 then
        l_teamData.SetIsAutoPair(false)
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("TEAM_START_AUTOPAIR_RUNTIME"))
    elseif l_info.reason == 2 then
        l_teamData.SetIsAutoPair(false)
    elseif l_info.reason == 3 then
        l_teamData.SetIsAutoPair(false)
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("TEAM_START_AUTOPAIR_FINISH"))
    end
    UIMgr:DeActiveUI(UI.CtrlNames.TeamCareerChoice2)
    --重置匹配目标
    l_teamData.SetAutoPairTarget(1000)
    EventDispatcher:Dispatch(l_teamData.ON_TEAM_AUTOPAIR_STATUS) --发出刷新组队自动匹配状态的事件
end

--请求匹配状态
function QueryAutoPairStatus()
    local l_msgId = Network.Define.Rpc.QueryAutoPairStatus
    ---@type QueryAutoPairStatusArg
    local l_sendInfo = GetProtoBufSendTable("QueryAutoPairStatusArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnQueryAutoPairStatus(msg)
    ---@type QueryAutoPairStatusRes
    local l_info = ParseProtoBufToTable("QueryAutoPairStatusRes", msg)
    if l_info.error ~= 0 then
        if l_info.error ~= ErrorCode.ERR_INVALID_REQUEST then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error))
        end
    else
        l_teamData.SetIsAutoPair(l_info.status == 1)
    end
    --刷新匹配按钮
    EventDispatcher:Dispatch(l_teamData.ON_TEAM_AUTOPAIR_STATUS) --发出刷新组队自动匹配状态的事件
end

--获取组队列表 用于组队查询TeamSearch
function GetTeamList(target)
    local l_msgId = Network.Define.Rpc.GetTeamList
    ---@type GetTeamListArg
    local l_sendInfo = GetProtoBufSendTable("GetTeamListArg")
    l_sendInfo.target = target
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnGetTeamList(msg)
    ---@type GetTeamListRes
    local l_info = ParseProtoBufToTable("GetTeamListRes", msg)
    if l_info.error_info.errorno ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_info.errorno))
    else
        l_teamData.ClearTeamList()
        HandleTeamListData(l_info.infos)
        EventDispatcher:Dispatch(l_teamData.ON_TEAMSEARCH_INFO_UPDATE)--发出刷新组队查询列表的请求
    end
end

--处理组队列表数据
function HandleTeamListData(targetData)
    for i = 1, table.maxn(targetData) do
        if targetData[i].name == nil or targetData[i].name == "" then
            targetData[i].name = Common.Utils.Lang("TEAM_DEFAULT_NAME", targetData[i].captain.name)
        end
        l_teamData.AddTeamList(targetData[i])
    end
    l_teamData.SortTeamList()
end


--组队喊话
function TeamShout()
    local l_msgId = Network.Define.Rpc.TeamShout
    ---@type TeamShoutArg
    local l_sendInfo = GetProtoBufSendTable("TeamShoutArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnTeamShout(msg)
    ---@type TeamShoutRes
    local l_info = ParseProtoBufToTable("TeamShoutRes", msg)

    if l_info.error ~= 0 then
        if l_info.error == 1157 then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("SHOUT_AGAIN", l_info.error_param[1].value))
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error))
        end
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("TEAM_SHOUT_SUCCESS"))
    end
end

TEAMSHOUT_RESET_TIME = MGlobalConfig:GetFloat("TeamShoutResetTime", 30)
TEAMSHOUT_RESET_NUM = MGlobalConfig:GetInt("TeamShoutResetNum", 10)
TEAM_SHOUT_NUM = 0 --记录当前喊话数量
TEAM_SHOUT_TIME = 0 --记录当前计时器的时间
TEAM_START_CALCULATE = false --是否开启定时器 每次重置后 收到第一条推送的时候开启定时器

--收到服务器推送的组队喊话内容
function OnTeamShoutNtf(msg)
    ---@type TeamShoutNtfData
    local l_info = ParseProtoBufToTable("TeamShoutNtfData", msg)
    if l_info then

        if not l_teamData.CheckIsShowTeamShout(l_info.setting) then
            return
        end

        local channel = DataMgr:GetData("ChatData").EChannel.TeamChat
        local memberNum = l_info.member_count
        local teamSetting = l_info.setting
        local professionString = ""
        for i = 1, table.maxn(l_info.profession_ids) do
            local imageName = l_teamData.GetProfessionImageById(l_info.profession_ids[i].value)
            professionString = professionString .. StringEx.Format(Common.Utils.Lang("RICH_IMAGE"), tostring(imageName), tostring("Common"), 16, 1) .. " "
        end
        -- 协同之证显示
        local l_xieTongStr = ""
        if l_info.show_coordination == 1 then
            l_xieTongStr = StringEx.Format(Common.Utils.Lang("RICH_IMAGE"), "UI_icon_item_xietongzhizheng.png", "Icon_ItemConsumables02", 16, 1) .. " "
        end
        local teamContent = Lang(TableUtil.GetGlobalTable().GetRowByName("TeamPromptContent").Value)
        teamContent = StringEx.Format(teamContent, teamSetting.name, memberNum, DataMgr:GetData("TeamData").maxTeamNumber, professionString, l_xieTongStr, teamSetting.min_lv, teamSetting.max_lv, l_teamData.GetTargetNameById(teamSetting.target), Common.Utils.Lang("TEAM_SHOUT_BTN"))
        local addationalData = {
            isShowDanmu = false,
            isShowInMainChat = false, --TEAM_SHOUT_NUM < TEAMSHOUT_RESET_NUM and true or false
        }

        if l_teamData.myTeamInfo.isInTeam then
            --自己有组队 只显示自己喊话内容
            if l_info.role_id == MPlayerInfo.UID then
                MgrMgr:GetMgr("ChatMgr").DoHandleMsgNtf(l_info.role_id, channel, teamContent, l_info.name, nil, true, addationalData)
            end
        else
            MgrMgr:GetMgr("ChatMgr").DoHandleMsgNtf(l_info.role_id, channel, teamContent, l_info.name, nil, true, addationalData)
        end

        --每次时间重置 重设TEAM_START_CALCULATE为false 开始计算累加
        if not TEAM_START_CALCULATE then
            TEAM_START_CALCULATE = true
            local l_timer
            l_timer = Timer.New(function()
                if TEAM_SHOUT_TIME < TEAMSHOUT_RESET_TIME then
                    TEAM_SHOUT_TIME = TEAM_SHOUT_TIME + 1
                else
                    TEAM_START_CALCULATE = false
                    TEAM_SHOUT_TIME = 0
                    TEAM_SHOUT_NUM = 0
                    l_timer:Stop()
                end
            end, 1, -1, true)
            l_timer:Start()
        end
        TEAM_SHOUT_NUM = TEAM_SHOUT_NUM + 1
    end
end



--function SetSeeting(dataSetting) 无调用暂注
--    local Setting = {}
--    Setting.min_lv = dataSetting.min_lv ~= nil and dataSetting.min_lv or 0
--    Setting.max_lv = dataSetting.max_lv ~= nil and dataSetting.max_lv or 0
--    Setting.target = dataSetting.target ~= nil and dataSetting.target or 0
--    Setting.sub_target = dataSetting.sub_target ~= nil and dataSetting.sub_target or 0
--    Setting.name = dataSetting.name ~= nil and dataSetting.name or ""
--    return Setting
--end



--掉线或者重新开始游戏
function GetTeamInfo()
    local l_msgId = Network.Define.Rpc.GetTeamInfo
    Network.Handler.SendRpc(l_msgId)
end

function OnGetTeamInfo(msg)
    ---@type GetTeamInfoRes
    local l_info = ParseProtoBufToTable("GetTeamInfoRes", msg)
    if l_info.error ~= 0 then
        ReconnectColose()
    else
        l_teamData.ResetTeamInfo()--重置组队数据
        l_teamData.SetTeamInfo(l_info.team_info)
        NeedGetRevive()
    end
    IsInSoloDungeon()
    EventDispatcher:Dispatch(l_teamData.ON_TEAM_INFO_UPDATE) --获取到组队数据 抛出队伍更新事件
end

--断线重连 没拉到数据关闭界面
function ReconnectColose()
    --没拉到数据 清除本地组队数据
    l_teamData.ResetTeamInfo()
    ResetTeamApplication()
    UIMgr:DeActiveUI("Team")
end

function OnAllMemberStatusNtf(msg)
    local l_isRefreshTeamMember = false
    ---@type AllMemberStatusInfo
    local l_info = ParseProtoBufToTable("AllMemberStatusInfo", msg)
    l_isRefreshTeamMember = l_teamData.RefreshMemberStatus(l_info.members)
    if l_info.mercenary_list and not l_teamData.myTeamInfo.mercenaryList then
        GetTeamInfo()
        EventDispatcher:Dispatch(l_teamData.ON_TEAM_BASIC_INFO_UPDATE)
        return
    end
    if l_info.mercenary_list then
        l_teamData.RefreshMercenaryStatus(l_info.mercenary_list)
        NeedGetRevive()
    end
    if l_isRefreshTeamMember then
        EventDispatcher:Dispatch(l_teamData.ON_TEAM_INFO_UPDATE)            --新成员入队 抛出队员更新事件
    end
    EventDispatcher:Dispatch(l_teamData.ON_TEAM_BASIC_INFO_UPDATE)          --组队基础信息变更 抛出更新事件
end

--服务器同步队员的状态 在线 离线 暂离
function OnTeamMemberStatusNtf(msg)
    ---@type TeamMemberStatusNtfData
    local l_info = ParseProtoBufToTable("TeamMemberStatusNtfData", msg)
    l_teamData.SetState(l_info)
    for i = 1, table.maxn(l_teamData.myTeamInfo.memberList) do
        --以下判定 如果队长离线 停止跟随
        if l_info.role_id == l_teamData.myTeamInfo.captainId then
            if l_teamData.myTeamInfo.memberList[i].state == MemberStatus.MEMBER_OFFLINE then
                FollowEndMsg(Common.Utils.Lang("STOP_FOLLOW_CAPTAIN_OFFLINE"))
            end
        end
    end
    if l_info.role_id == MPlayerInfo.UID then
        l_teamData.SetSelfIsInAfk(l_info.status == MemberStatus.MEMBER_AFK)
    end

    EventDispatcher:Dispatch(l_teamData.ON_TEAM_INFO_UPDATE)   --队员状态变化 队伍更新
end

--发送设置暂离状态的消息
function SetTeamAfkByState(self, state)
    --if MPlayerInfo.IsFollowing or MPlayerInfo.IsAutoBattle then
    --return
    --end
    local l_msgId = Network.Define.Ptc.TeamAfkNtf
    ---@type TeamAfkNtfData
    local l_sendInfo = GetProtoBufSendTable("TeamAfkNtfData")
    l_sendInfo.is_afk = state
    Network.Handler.SendPtc(l_msgId, l_sendInfo)
end

--获取复活时间
function GetMercenaryReviveTime(owner_id, mercenary_id)
    local l_msgId = Network.Define.Rpc.GetMercenaryReviveTime
    ---@type GetMercenaryReviveTimeArgs
    local l_sendInfo = GetProtoBufSendTable("GetMercenaryReviveTimeArgs")
    l_sendInfo.owner_id = owner_id;
    l_sendInfo.mercenary_id = mercenary_id
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnGetMercenaryReviveTime(msg)
    ---@type GetMercenaryReviveTimeRes
    local l_info = ParseProtoBufToTable("GetMercenaryReviveTimeRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
    else
        if l_teamData.myTeamInfo.mercenaryList == nil then
            GetTeamInfo()
            EventDispatcher:Dispatch(l_teamData.ON_TEAM_BASIC_INFO_UPDATE)
            return
        end
        l_teamData.SetMercenaryReviveTime(l_info)
    end
    EventDispatcher:Dispatch(l_teamData.ON_MERCENARY_RIVIVE_UPDATE)
end
---@Description:获得最近组过队的玩家信息
function GetRecentTeamMate()
    local l_msgId = Network.Define.Rpc.GetRecentTeamMate
    ---@type NullArg
    local l_sendInfo = GetProtoBufSendTable("NullArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnGetRecentTeamMate(msg)
    ---@type GetRecentTeamMateRes
    local l_info = ParseProtoBufToTable("GetRecentTeamMateRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error))
    else
        l_teamData.SetCurrentMemberIds(l_info.mates)
        EventDispatcher:Dispatch(l_teamData.ON_GET_INVITATION_ID_LIST, l_info.mates)
    end
end

function GetTeamAfkState()
    return l_teamData.selfIsInAfk
end


--已经有队伍了，直接显示
function ShowTeamView()
    if l_teamData.myTeamInfo.isInTeam then
        UIMgr:ActiveUI(UI.CtrlNames.Team)
    end
end

--显示队友功能小界面
function ShowTeamFuncView(targetUid, targetPos, playerMenuLPos, anchorMaxPos, anchorMinPos)
    --查看信息
    local l_CallBack_ShowInformation = function()
        Common.CommonUIFunc.RefreshPlayerMenuLByUid(targetUid)
        if playerMenuLPos then
            local l_ui = UIMgr:GetUI(UI.CtrlNames.PlayerMenuL)
            if l_ui and l_ui.isActive then
                l_ui:SetSelfPos(playerMenuLPos)
            end
        end
    end
    --开始聊天
    local l_CallBack_StartTalk = function()
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips("StartTalk")
    end
    --设置队长
    local l_CallBack_SetCaptain = function()
        MgrMgr:GetMgr("TeamMgr").SetCaptainFunc(targetUid)
    end
    --邀请跟随
    local l_CallBack_FollowInvite = function()
        MgrMgr:GetMgr("TeamMgr").ToBeFollowed(targetUid)
    end
    --队长请离队伍
    local l_CallBack_LeaveTeamByCaptain = function()
        MgrMgr:GetMgr("TeamMgr").SetLeaveTeamByCaptainFunc(targetUid)
    end
    --自己离队
    local l_CallBack_LeaveTeamBySelf = function()
        MgrMgr:GetMgr("TeamMgr").LeaveTeam()
    end
    --主动跟随目标
    local l_CallBack_FollowPeople = function()
        if not l_teamData.Isfollowing then
            MgrMgr:GetMgr("TeamMgr").FollowOtherPeople(targetUid)
        else
            MgrMgr:GetMgr("TeamMgr").SetEndAutoFollow()
        end
    end
    --跟随队长
    local l_CallBack_FollowCaptain = function()
        if not l_teamData.Isfollowing then
            MgrMgr:GetMgr("TeamMgr").FollowOtherPeople(DataMgr:GetData("TeamData").myTeamInfo.captainId)
        else
            MgrMgr:GetMgr("TeamMgr").SetEndAutoFollow()
        end
    end
    --申请队长
    local l_CallBack_ApplyCaptain = function()
        ApplyForCaptain()
    end

    local l_callBackTb = {}
    local l_nameTb = {}
    if MPlayerInfo.UID == l_teamData.myTeamInfo.captainId then
        --l_nameTb   ={"查看信息" "升为队长","邀请跟随","请离队伍","离开队伍"}
        l_nameTb = { Common.Utils.Lang("TEAM_LOOK_INFOMATION"),
                     Common.Utils.Lang(l_teamData.Isfollowing and "STOP_FOLLOW" or "TEAM_FOLLOW_TARGET"),
                     Common.Utils.Lang("TEAM_SET_CAPTAIN"),
                     Common.Utils.Lang("TEAM_ASKFOLLOW"),
                     Common.Utils.Lang("TEAM_LEAVE_BY_TEAM"),
                     Common.Utils.Lang("TEAM_LEAVE_BY_SELF") }
        l_callBackTb = { l_CallBack_ShowInformation,
                         l_CallBack_FollowPeople,
                         l_CallBack_SetCaptain,
                         l_CallBack_FollowInvite,
                         l_CallBack_LeaveTeamByCaptain,
                         l_CallBack_LeaveTeamBySelf }
    elseif targetUid == l_teamData.myTeamInfo.captainId then
        --l_nameTb   ={"查看信息" "跟随目标" "申请队长" "邀请跟随" "离开队伍"}
        l_nameTb = { Common.Utils.Lang("TEAM_LOOK_INFOMATION"),
                     Common.Utils.Lang(l_teamData.Isfollowing and "STOP_FOLLOW" or "TEAM_FOLLOW_TARGET"),
                     Common.Utils.Lang(l_teamData.Isfollowing and "STOP_FOLLOW" or "FOLLOW_CAPTAIN"),
                     Common.Utils.Lang("TEAM_LEAVE_BY_SELF") }
        l_callBackTb = { l_CallBack_ShowInformation,
                         l_CallBack_FollowPeople,
                         l_CallBack_FollowCaptain,
                         l_CallBack_LeaveTeamBySelf }
        table.insert(l_nameTb, 3, Common.Utils.Lang("TEAM_APPLY_CAPTAIN_WORD"))
        table.insert(l_callBackTb, 3, l_CallBack_ApplyCaptain)
        if l_teamData.Isfollowing then
            table.remove(l_nameTb, 2)
            table.remove(l_callBackTb, 2)
        end
    else
        l_nameTb = { Common.Utils.Lang("TEAM_LOOK_INFOMATION"),
                     Common.Utils.Lang(l_teamData.Isfollowing and "STOP_FOLLOW" or "TEAM_FOLLOW_TARGET"),
                     Common.Utils.Lang("TEAM_LEAVE_BY_SELF") }
        l_callBackTb = { l_CallBack_ShowInformation,
                         l_CallBack_FollowPeople,
                         l_CallBack_LeaveTeamBySelf }
        if l_teamData.Isfollowing then
            table.remove(l_nameTb, 2)
            table.remove(l_callBackTb, 2)
        end
    end
    local openData = {
        openType = l_teamData.ETeamOpenType.SetQuickPanelByNameAndFunc,
        nameTb = l_nameTb,
        callbackTb = l_callBackTb,
        dataopenPos = targetPos,
        dataAnchorMaxPos = anchorMaxPos,
        dataAnchorMinPos = anchorMinPos
    }
    UIMgr:ActiveUI(UI.CtrlNames.TeamQuickFunc, openData)
end

--点击了地图上的人
--暂放，后面改为事件 nyq
function OnSelectPlayer(uid, playerInfo, relativeScreenPos, onlyChangePosY)
    --显示详情面板
    l_teamData.SetSelectedUid(uid)
    Common.CommonUIFunc.RefreshPlayerMenuLByUid(l_teamData.GetSelectedUid(), relativeScreenPos, onlyChangePosY)
end

function OnInit()
    l_teamData.ResetAll()
    ResetTeamApplication()
    FollowSet(false)
    gameEventMgr.Register(gameEventMgr.OnBagUpdate, _onItemUpdate)
    --myTeamInfo = l_teamData.myTeamInfo
end

---@param itemUpdateDataList ItemUpdateData[]
function _onItemUpdate(itemUpdateDataList)
    if nil == itemUpdateDataList then
        return
    end

    local C_REASON_MAP = {
        [ItemChangeReason.ITEM_REASON_TEAMLEADER_EXTRA_AWARD] = 1,
    }

    ---@type ItemIdCountPair[]
    local itemPairList = {}
    for i = 1, #itemUpdateDataList do
        local singleUpdateData = itemUpdateDataList[i]
        if nil ~= C_REASON_MAP[singleUpdateData.Reason] and nil ~= singleUpdateData.NewItem then
            local compareData = singleUpdateData:GetItemCompareData()
            local singlePair = {
                id = compareData.id,
                count = compareData.count,
            }
            if ItemChangeReason.ITEM_REASON_TEAMLEADER_EXTRA_AWARD == singleUpdateData.Reason then
                local l_name = Data.BagModel:GetItemNameText(singlePair.id)
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("TEAM_CAPTAIN_GET_ITEM", l_name)
                )
            end
        end
    end
end

function OnLogin(...)
    --"登录游戏重新拉去匹配信息"
    QueryAutoPairStatus()
end

function OnLogout()
    l_teamData.ResetAll()
    ResetTeamApplication()
    FollowSet(false)
    followerId = nil
    MPlayerInfo.FollowerUid = 0
end

function ResetTeamApplication()
    l_teamData.ResetTeamApplication()
    onTeamApplicationInfoChange()
end

function GetRoleAttrByData(cType, cIsMale, cOutloolData, cRoleEquipIds)
    if cType == 0 or cType == nil then
        cType = 1000
    end

    local l_attr = MAttrMgr:InitRoleAttr(MUIModelManagerEx:GetTempUID(), "team", cType, cIsMale, nil)
    if cOutloolData ~= nil then
        l_attr:SetHair(cOutloolData.hair_id)
        l_attr:SetFashion(cOutloolData.wear_fashion)
        l_attr:SetEye(cOutloolData.eye.eye_id)
        l_attr:SetEyeColor(cOutloolData.eye.eye_style_id)
        if cOutloolData.wear_ornament ~= nil then
            for c, v in ipairs(cOutloolData.wear_ornament) do
                if v.value ~= 0 then
                    l_attr:SetOrnament(v.value, false)
                end
            end
        end
    end
    if cRoleEquipIds ~= nil then
        for c, v in ipairs(cRoleEquipIds) do
            if v.value ~= 0 then
                if c - 1 == Data.BagModel.WeapType.MainWeapon then
                    l_attr:SetWeapon(v.value, true)
                elseif c - 1 == Data.BagModel.WeapType.Fashion and cOutloolData.wear_fashion == 0 then
                    ---未应用收纳的时装时读取装备的时装
                    l_attr:SetFashion(v.value)
                else
                    l_attr:SetOrnament(v.value, true)
                end
            end
        end
    end
    return l_attr
end

--设置组队面板上的的选中目标
function SetTeamTargetPlayer(targetUid)
    local l_state = false
    for i = 1, table.maxn(l_teamData.myTeamInfo.memberList) do
        local l_uid = l_teamData.myTeamInfo.memberList[i].roleId
        if tostring(l_uid) == tostring(targetUid) then
            l_state = true
        end
    end
    for i = 1, table.maxn(l_teamData.myTeamInfo.mercenaryList) do
        local l_uid = l_teamData.myTeamInfo.mercenaryList[i].UId
        if tostring(l_uid) == tostring(targetUid) then
            l_state = true
        end
    end
    EventDispatcher:Dispatch(l_teamData.ON_REFRESH_TEAM_TARGET, l_state, targetUid)            --组队目标变更 抛出刷新事件
end

--返回组队中所有的职业 只要职业Id不一样就会返回
function GetTeamTotalProfession()
    local l_professionList = {}
    local l_returnProfessionList = {}
    for i = 1, table.maxn(l_teamData.myTeamInfo.memberList) do
        if l_professionList[l_teamData.myTeamInfo.memberList[i].roleType] == nil then
            l_professionList[l_teamData.myTeamInfo.memberList[i].roleType] = true
            table.insert(l_returnProfessionList, l_teamData.myTeamInfo.memberList[i].roleType)
        end
    end
    return l_returnProfessionList
end

--在组队频道显示信息
function ShowTeamInfoMsg(content)
    if content == nil then
        return
    end
    local l_MsgPkg = {}
    local l_chatDataMgr = DataMgr:GetData("ChatData")
    l_MsgPkg.channel = l_chatDataMgr.EChannel.TeamChat
    l_MsgPkg.lineType = l_chatDataMgr.EChatPrefabType.System
    l_MsgPkg.subType = Lang("CHAT_CHANNEL_TEAM")
    l_MsgPkg.content = content
    l_MsgPkg.showInMainChat = true
    MgrMgr:GetMgr("ChatMgr").BoardCastMsg(l_MsgPkg)
end


--是否在单人副本isInSoloDungeon
function IsInSoloDungeon()
    local dungeonID = MPlayerInfo.PlayerDungeonsInfo.DungeonID
    if dungeonID == 0 then
        l_teamData.SetIsInSoloDungeon(false)
    else
        local l_row = TableUtil.GetDungeonsTable().GetRowByDungeonsID(dungeonID)
        local l_numlimit = Common.Functions.SequenceToTable(l_row.NumbersLimit)
        l_teamData.SetIsInSoloDungeon(l_numlimit[1] == 1 and l_numlimit[2] == 1)
    end
    if l_teamData.myTeamInfo.isInTeam then
        EventDispatcher:Dispatch(l_teamData.ON_SOLODUNGEONS_UPDATE)
    end
end

function GetMyTeamMercenaryUid()
    l_teamData.ClearMercenaryUids()
    if l_teamData.isInSoloDungeon or not l_teamData.myTeamInfo.isInTeam then
        local l_fightMercenarys = MgrMgr:GetMgr("MercenaryMgr"):FindFightMercenary()
        if #l_fightMercenarys == 0 then
            return l_teamData.MercenaryUids2Api
        end
        for _, v in pairs(l_fightMercenarys) do
            l_teamData.AddMercenaryUids2Api(v.UId)
        end
    else
        for _, v in pairs(l_teamData.myTeamInfo.mercenaryList) do
            l_teamData.AddMercenaryUids2Api(v.UId)
        end
    end
    return l_teamData.MercenaryUids2Api
end

function NeedGetRevive()
    if l_teamData.NeedRevieMercenarys and #l_teamData.NeedRevieMercenarys > 0 then
        for i = 1, table.maxn(l_teamData.NeedRevieMercenarys) do
            GetMercenaryReviveTime(l_teamData.NeedRevieMercenarys[i].ownerId, l_teamData.NeedRevieMercenarys[i].mercenaryId)
        end
        l_teamData.ClearNeedRevieMercenarys()
    end
end

function GetTeamMatchStatus()
    local l_msgId = Network.Define.Rpc.GetTeamMatchStatus
    Network.Handler.SendRpc(l_msgId, nil)
end

function OnGetTeamMatchStatus(msg, arg)
    ---@type GetTeamMatchStatusRes
    local l_info = ParseProtoBufToTable("GetTeamMatchStatusRes", msg)
    l_teamData.SetIsAutoPair(l_info.is_in_match)
    if not l_info.is_in_match then
        UIMgr:DeActiveUI(UI.CtrlNames.TeamCareerChoice2)
    end
end

function GetMemberOnLineStatus(data)

    if data == nil then
        return ""
    end

    if data.state == MemberStatus.MEMBER_OFFLINE then
        return Common.Utils.Lang("OFFLINE_STATE_COMMON")
    elseif data.state == MemberStatus.MEMBER_AFK then
        return Common.Utils.Lang("OFFLINE_STATE_AFK")
    end

    --远离状态判断 只要自己和这个人不是同一个场景 那么远离 两个人同场景不同线 也是远离
    if tostring(MPlayerInfo.UID) ~= tostring(data.roleId) then
        if data.state == MemberStatus.MEMBER_NORMAL then
            if MgrMgr:GetMgr("WatchWarMgr").HasMemberWatchRecord(data.roleId) then
                return Common.Utils.Lang("OFFLINE_STATE_AWAYFROM")
            end
            if data.sceneId ~= MScene.SceneID then
                return Common.Utils.Lang("OFFLINE_STATE_AWAYFROM")
            else
                if l_teamData.GetSelfLineNumber() ~= data.roleLineId then
                    return Common.Utils.Lang("OFFLINE_STATE_AWAYFROM")
                end
            end
        end
    else
        local dungeonID = MPlayerInfo.PlayerDungeonsInfo.DungeonID
        if dungeonID == 0 then
            return ""
        end
        local l_row = TableUtil.GetDungeonsTable().GetRowByDungeonsID(dungeonID)
        local l_numlimit = Common.Functions.SequenceToTable(l_row.NumbersLimit)
        if l_numlimit[1] == 1 and l_numlimit[2] == 1 then
            return Common.Utils.Lang("OFFLINE_STATE_AWAYFROM")
        end
    end

    return ""
end

function GetMercenaryStatus()
    ---@type ClientOneMemberInfo
    local data = nil
    for i = 1, table.maxn(l_teamData.myTeamInfo.memberList) do
        if uint64.equals(l_teamData.myTeamInfo.memberList[i].roleId, l_teamData.myTeamInfo.captainId) then
            data = l_teamData.myTeamInfo.memberList[i]
        end
    end

    if not data then
        return ""
    end

    if tostring(MPlayerInfo.UID) ~= tostring(data.roleId) then
        if data.sceneId ~= MScene.SceneID then
            return Common.Utils.Lang("OFFLINE_STATE_AWAYFROM")
        else
            if DataMgr:GetData("TeamData").GetSelfLineNumber() ~= data.roleLineId then
                return Common.Utils.Lang("OFFLINE_STATE_AWAYFROM")
            end
            local dungeonID = MPlayerInfo.PlayerDungeonsInfo.DungeonID
            if dungeonID == 0 then
                return ""
            end
            local l_row = TableUtil.GetDungeonsTable().GetRowByDungeonsID(dungeonID)
            local l_numlimit = Common.Functions.SequenceToTable(l_row.NumbersLimit)
            if l_numlimit[1] == 1 and l_numlimit[2] == 1 then
                return Common.Utils.Lang("OFFLINE_STATE_AWAYFROM")
            end
        end
    end

    return ""

end

function GetLineText(data)
    local PlayerLine = l_teamData.GetSelfLineNumber()
    if tostring(MPlayerInfo.UID) ~= tostring(data.roleId) then
        if data.roleLineId ~= PlayerLine then
            return Common.Utils.Lang("PLAYER_LINE", data.roleLineId)
        end
    end
    return ""
end

return ModuleMgr.TeamMgr