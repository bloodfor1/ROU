--[[
    初始化网络协议
    1.注册各个模块的监听函数，模块自己控制
]]--

module("Network", package.seeall)

require("Network/Network_Define")
require("Network/Network_Handler")

--lua网络初始化
function Init()
    MLuaNetworkHelper.SetLuaOverrideDispatchers(GetLuaMsgIds())
end

--rpc lua协议的注册
local l_rpcHandlers = {
    [Network.Define.Rpc.ResolveItem] = {
        func = function(msg)
            MgrMgr:GetMgr("ItemResolveMgr").OnResolveRsp(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.SyncTime] = {
        func = function(msg)
            MgrMgr:GetMgr("RoleInfoMgr").OnReceiveSyncTime(msg)
        end,
        override = false --是否覆盖c#协议
    },
    --- 确认收到聊天标签数据
    [Network.Define.Rpc.ChangeChatTag] = {
        func = function(msg)
            MgrMgr:GetMgr("ChatTagMgr").OnChangeConfirm(msg)
        end,
        override = true --是否覆盖c#协议
    },

    [Network.Define.Rpc.MaintenanceWheelRpc] = {
        func = function(msg)
            MgrMgr:GetMgr("BeiluzCoreMgr").OnMaintainRes(msg)
        end,
        override = true --是否覆盖c#协议
    },

    [Network.Define.Rpc.ChangeStyle] = {
        func = function(msg, arg)
            MgrMgr:GetMgr("SelectRoleMgr").OnChangeStyle(msg, arg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.CombineWheelRpc] = {
        func = function(msg)
            MgrMgr:GetMgr("BeiluzCoreMgr").onCombineCoreRes(msg)
        end,
        override = true --是否覆盖c#协议
    },

    [Network.Define.Rpc.WheelReset] = {
        func = function(msg)
            MgrMgr:GetMgr("BeiluzCoreMgr").onResetRes(msg)
        end,
        override = true --是否覆盖c#协议
    },

    [Network.Define.Rpc.WheelChooseReset] = {
        func = function(msg)
            MgrMgr:GetMgr("BeiluzCoreMgr").onChooseResetRes(msg)
        end,
        override = true --是否覆盖c#协议
    },

    [Network.Define.Rpc.ReturnTaskFinish] = {
        func = function(msg)
            MgrMgr:GetMgr("ReBackMgr").ResFinishTask(msg)
        end,
        override = true --是否覆盖c#协议
    },

    [Network.Define.Rpc.EquipInherit] = {
        file = "ModuleMgr/ItemContainerMgr",
        func = function(msg)
            ---@type ModuleMgr.ItemContainerMgr
            MgrMgr:GetMgr("ItemContainerMgr").OnEquipInheritConfirm(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.QueryGateIP] = {
        func = function(msg)
            game:GetAuthMgr():OnQueryGateIP(msg)
        end,
        override = true --是否覆盖c#协议
    },

    [Network.Define.Rpc.ClientLoginRequest] = {
        func = function(msg)
            game:GetAuthMgr():OnLoginGateServer(msg)
        end,
        override = true --是否覆盖c#协议
    },

    [Network.Define.Rpc.GetVersion] = {
        file = "ModuleMgr/TestMgr",
        func = function(msg)
            ---@type Test
            MgrMgr:GetMgr("Test").OnGetVersion(msg)
        end,
        override = true --是否覆盖c#协议
    },

    [Network.Define.Rpc.SelectRole] = {
        file = "ModuleMgr/SelectRoleMgr",
        func = function(msg)
            ---@type ModuleMgr.SelectRoleMgr
            MgrMgr:GetMgr("SelectRoleMgr").OnSelectRole(msg)
        end,
        override = true --是否覆盖c#协议
    },

    [Network.Define.Rpc.CreateRoleNew] = {
        file = "ModuleMgr/SelectRoleMgr",
        func = function(msg, sendArg)
            ---@type ModuleMgr.SelectRoleMgr
            MgrMgr:GetMgr("SelectRoleMgr").OnCreateRoleNew(msg, sendArg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.GsChangeRoleName] = {
        file = "ModuleMgr/SelectRoleMgr",
        func = function(msg)
            ---@type ModuleMgr.SelectRoleMgr
            MgrMgr:GetMgr("SelectRoleMgr").OnModifyName(msg)
        end,
        override = true --是否覆盖c#协议
    },

    -- 死亡界面
    [Network.Define.Rpc.RoleRevive] = {
        file = "ModuleMgr/DeadDlgMgr",
        func = function(msg, arg)
            MgrMgr:GetMgr("DeadDlgMgr").OnRoleRevive(msg, arg)
        end,
        override = true --是否覆盖c#协议
    },

    --- 累计充值奖励
    -- 作废了，以防反复，先保存
    --[Network.Define.Rpc.GetPayAwardInfo] = {
    --    func = function(msg, arg)
    --        MgrMgr:GetMgr("TotalRechargeAwardMgr").OnRecvGetAllInfo(msg)
    --    end,
    --    override = true --是否覆盖c#协议
    --},
    [Network.Define.Rpc.GetPayAward] = {
        func = function(msg, arg)
            MgrMgr:GetMgr("TotalRechargeAwardMgr").OnRecvGetAward(msg, arg)
        end,
        override = true --是否覆盖c#协议
    },

    --- 节日签到活动
    [Network.Define.Rpc.GetSpecialSupplyInfo] = {
        func = function(msg, ...)
            MgrMgr:GetMgr("ActivityCheckInMgr").OnRecvGetSpecialSupplyInfo(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.ChooseSpecilSupplyAwards] = {
        func = function(msg, ...)
            MgrMgr:GetMgr("ActivityCheckInMgr").OnRecvChooseSpecialSupplyAwards(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.SetSpecialSupplyDice] = {
        func = function(msg, ...)
            MgrMgr:GetMgr("ActivityCheckInMgr").OnRecvSetSpecialSupplyDice(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.RecvSpecialSupplyAwards] = {
        func = function(msg, ...)
            MgrMgr:GetMgr("ActivityCheckInMgr").OnRecvRecvSpecialSupplyAwards(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.RandomDiceValue] = {
        func = function(msg, ...)
            MgrMgr:GetMgr("ActivityCheckInMgr").OnRecvRandomDiceValue(msg)
        end,
        override = true --是否覆盖c#协议
    },

    -- 兑换码
    [Network.Define.Rpc.CDKeyExchange] = {
        func = function(msg, ...)
            MgrMgr:GetMgr("ExchangecodeDialogMgr").OnCDKeyExchangeRes(msg)
        end,
        override = true --是否覆盖c#协议
    },

    --组队相关
    [Network.Define.Rpc.CreateTeam] = {
        file = "ModuleMgr/TeamMgr",
        func = function(msg)
            ---@type ModuleMgr.TeamMgr
            MgrMgr:GetMgr("TeamMgr").OnCreateTeam(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.InviteJoinTeam] = {
        file = "ModuleMgr/TeamMgr",
        func = function(msg)
            ---@type ModuleMgr.TeamMgr
            MgrMgr:GetMgr("TeamMgr").OnInviteJoinTeam(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.AcceptTeamInvatation] = {
        file = "ModuleMgr/TeamMgr",
        func = function(msg)
            ---@type ModuleMgr.TeamMgr
            MgrMgr:GetMgr("TeamMgr").OnAcceptTeamInvatation(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.LeaveTeam] = {
        file = "ModuleMgr/TeamMgr",
        func = function(msg)
            ---@type ModuleMgr.TeamMgr
            MgrMgr:GetMgr("TeamMgr").OnLeaveTeam(msg)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Rpc.GetTeamInfo] = {
        file = "ModuleMgr/TeamMgr",
        func = function(msg)
            ---@type ModuleMgr.TeamMgr
            MgrMgr:GetMgr("TeamMgr").OnGetTeamInfo(msg)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Rpc.QueryIsInTeam] = {
        file = "ModuleMgr/TeamMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.TeamMgr
            MgrMgr:GetMgr("TeamMgr").OnGetUserInTeamOrNot(msg, arg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.BegJoinTeam] = {
        file = "ModuleMgr/TeamMgr",
        func = function(msg)
            ---@type ModuleMgr.TeamMgr
            MgrMgr:GetMgr("TeamMgr").onBegInTeam(msg)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Rpc.KickTeamMember] = {
        file = "ModuleMgr/TeamMgr",
        func = function(msg)
            ---@type ModuleMgr.TeamMgr
            MgrMgr:GetMgr("TeamMgr").OnLeaveByCaptainKick(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.FollowOthers] = {
        file = "ModuleMgr/TeamMgr",
        func = function(msg)
            ---@type ModuleMgr.TeamMgr
            MgrMgr:GetMgr("TeamMgr").OnFollowOtherPeople(msg)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Rpc.Acceptbegjointeam] = {
        file = "ModuleMgr/TeamMgr",
        func = function(msg)
            ---@type ModuleMgr.TeamMgr
            MgrMgr:GetMgr("TeamMgr").OnAcceptbegjointeam(msg)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Rpc.GetApplicationList] = {
        file = "ModuleMgr/TeamMgr",
        func = function(msg)
            ---@type ModuleMgr.TeamMgr
            MgrMgr:GetMgr("TeamMgr").OnGetApplicationList(msg)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Rpc.GetInvitationList] = {
        file = "ModuleMgr/TeamMgr",
        func = function(msg)
            ---@type ModuleMgr.TeamMgr
            MgrMgr:GetMgr("TeamMgr").OnGetInvitationIdListByType(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.QueryRoleBriefInfo] = {
        file = "ModuleMgr/TeamMgr",
        func = function(msg, arg, customData)
            ---@type ModuleMgr.TeamMgr
            MgrMgr:GetMgr("TeamMgr").OnGetRoleInfoListByIds(msg, arg, customData)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.TeamSetting] = {
        file = "ModuleMgr/TeamMgr",
        func = function(msg)
            ---@type ModuleMgr.TeamMgr
            MgrMgr:GetMgr("TeamMgr").OnTeamSetting(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.AutoPairOperate] = {
        file = "ModuleMgr/TeamMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.TeamMgr
            MgrMgr:GetMgr("TeamMgr").OnAutoPairOperate(msg, arg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.GetTeamList] = {
        file = "ModuleMgr/TeamMgr",
        func = function(msg)
            ---@type ModuleMgr.TeamMgr
            MgrMgr:GetMgr("TeamMgr").OnGetTeamList(msg)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Rpc.TeamShout] = {
        file = "ModuleMgr/TeamMgr",
        func = function(msg)
            ---@type ModuleMgr.TeamMgr
            MgrMgr:GetMgr("TeamMgr").OnTeamShout(msg)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Rpc.ToBeFollowed] = {
        file = "ModuleMgr/TeamMgr",
        func = function(msg)
            ---@type ModuleMgr.TeamMgr
            MgrMgr:GetMgr("TeamMgr").OnToBeFollowed(msg)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Rpc.ReplyToBeFollowed] = {
        file = "ModuleMgr/TeamMgr",
        func = function(msg)
            ---@type ModuleMgr.TeamMgr
            MgrMgr:GetMgr("TeamMgr").OnReplyToBeFollowed(msg)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Rpc.QueryAutoPairStatus] = {
        file = "ModuleMgr/TeamMgr",
        func = function(msg)
            ---@type ModuleMgr.TeamMgr
            MgrMgr:GetMgr("TeamMgr").OnQueryAutoPairStatus(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.RecommandMember] = {
        file = "ModuleMgr/TeamMgr",
        func = function(msg)
            ---@type ModuleMgr.TeamMgr
            MgrMgr:GetMgr("TeamMgr").OnRecommandMember(msg)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Rpc.ApplyForCaptain] = {
        file = "ModuleMgr/TeamMgr",
        func = function(msg)
            ---@type ModuleMgr.TeamMgr
            MgrMgr:GetMgr("TeamMgr").OnApplyForCaptain(msg)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Rpc.RespondForApplyCaptain] = {
        file = "ModuleMgr/TeamMgr",
        func = function(msg)
            ---@type ModuleMgr.TeamMgr
            MgrMgr:GetMgr("TeamMgr").OnRespondForApplyCaptain(msg)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Rpc.GetMercenaryReviveTime] = {
        file = "ModuleMgr/TeamMgr",
        func = function(msg)
            ---@type ModuleMgr.TeamMgr
            MgrMgr:GetMgr("TeamMgr").OnGetMercenaryReviveTime(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.GetTeamAllMercenary] = {
        file = "ModuleMgr/TeamMgr",
        func = function(msg)
            MgrMgr:GetMgr("TeamMgr").OnGetTeamAllMercenary(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.GetRecentTeamMate] = {
        file = "ModuleMgr/TeamMgr",
        func = function(msg)
            MgrMgr:GetMgr("TeamMgr").OnGetRecentTeamMate(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.SelectTeamMercenarys] = {
        file = "ModuleMgr/TeamMgr",
        func = function(msg)
            MgrMgr:GetMgr("TeamMgr").OnSelectTeamMercenarys(msg)
        end,
        override = true --是否覆盖c#协议
    },
    --转职
    [Network.Define.Rpc.TransferProfession] = {
        file = "ModuleMgr/ProfessionMgr",
        func = function(msg)
            ---@type ModuleMgr.ProfessionMgr
            MgrMgr:GetMgr("ProfessionMgr").OnRequestTransferProfession(msg)
        end,
        override = true --是否覆盖c#协议
    },
    --人物属性相关
    [Network.Define.Rpc.AttrAdd] = {
        file = "ModuleMgr/RoleInfoMgr",
        func = function(msg)
            ---@type ModuleMgr.RoleInfoMgr
            MgrMgr:GetMgr("RoleInfoMgr").OnAttrAdd(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.AttrClear] = {
        file = "ModuleMgr/RoleInfoMgr",
        func = function(msg)
            ---@type ModuleMgr.RoleInfoMgr
            MgrMgr:GetMgr("RoleInfoMgr").OnAttrClear(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.ExchangeMoney] = {
        file = "ModuleMgr/CurrencyMgr",
        func = function(msg, arg, additionalData)
            ---@type ModuleMgr.CurrencyMgr
            MgrMgr:GetMgr("CurrencyMgr").OnExchangeMoneyRsp(msg, arg, additionalData)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.AttrModule] = {
        file = "ModuleMgr/RoleInfoMgr",
        func = function(msg)
            ---@type ModuleMgr.RoleInfoMgr
            MgrMgr:GetMgr("RoleInfoMgr").OnAttrModule(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.SkillPoint] = {
        file = "ModuleMgr/SkillLearningMgr",
        func = function(msg)
            ---@type ModuleMgr.SkillLearningMgr
            MgrMgr:GetMgr("SkillLearningMgr").OnSkillPoint(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.SkillSlot] = {
        file = "ModuleMgr/SkillLearningMgr",
        func = function(msg)
            ---@type ModuleMgr.SkillLearningMgr
            MgrMgr:GetMgr("SkillLearningMgr").OnSkillSlot(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.GetMengXinLevelGift] = {
        file = "ModuleMgr/NewPlayerMgr",
        func = function(msg)
            ---@type ModuleMgr.NewPlayerMgr
            MgrMgr:GetMgr("NewPlayerMgr").OnGetMengXinLevelGift(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.SkillReset] = {
        file = "ModuleMgr/SkillLearningMgr",
        func = function(msg)
            ---@type ModuleMgr.SkillLearningMgr
            MgrMgr:GetMgr("SkillLearningMgr").OnResetSkill(msg)
        end,
        override = true --是否覆盖c#协议
    },
    --道具
    [Network.Define.Rpc.SortBag] = {
        file = "ModuleMgr/PropMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.PropMgr
            MgrMgr:GetMgr("PropMgr").OnSortBag(msg, arg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.MoveItem] = {
        file = "ModuleMgr/PropMgr",
        func = function(msg)
            ---@type ModuleMgr.PropMgr
            MgrMgr:GetMgr("PropMgr").OnMoveItem(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.UseItem] = {
        file = "ModuleMgr/PropMgr",
        func = function(msg, arg, additionalData)
            ---@type ModuleMgr.PropMgr
            MgrMgr:GetMgr("PropMgr").OnUseItem(msg, arg, additionalData)
        end,
        override = true --是否覆盖c#协议
    },

    [Network.Define.Rpc.ExchangeAwardPack] = {
        file = "ModuleMgr/PropMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.PropMgr
            MgrMgr:GetMgr("PropMgr").ResponseChooseGift(msg, arg)
        end,
        override = true --覆盖C#协议
    },

    [Network.Define.Rpc.UnlockBlank] = {
        file = "ModuleMgr/PropMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.PropMgr
            MgrMgr:GetMgr("PropMgr").OnUnlockBlank(msg, arg)
        end,
        override = true --是否覆盖c#协议
    },

    [Network.Define.Rpc.AppraiseEquip] = {
        file = "ModuleMgr/EquipMgr",
        func = function(msg, _, id)
            ---@type ModuleMgr.EquipMgr
            MgrMgr:GetMgr("EquipMgr").OnAppraiseEquipResponse(msg, _, id)
        end,
        override = true --是否覆盖c#协议
    },

    [Network.Define.Rpc.AddEquipTask] = {
        file = "ModuleMgr/ForgeMgr",
        func = function(msg, data)
            ---@type ModuleMgr.ForgeMgr
            MgrMgr:GetMgr("ForgeMgr").ReceiveAddEquipTask(msg, data)
        end,
        override = true --是否覆盖c#协议
    },

    [Network.Define.Rpc.DelEquipTask] = {
        file = "ModuleMgr/ForgeMgr",
        func = function(msg, data)
            ---@type ModuleMgr.ForgeMgr
            MgrMgr:GetMgr("ForgeMgr").ReceiveDevEquipTask(msg, data)
        end,
        override = true --是否覆盖c#协议
    },

    --任务相关
    [Network.Define.Rpc.GetTaskRecord] = {
        file = "ModuleMgr/TaskMgr",
        func = function(msg, arg, customData)
            ---@type ModuleMgr.TaskMgr
            local mgr = MgrMgr:GetMgr("TaskMgr")
            TaskMgr.OnGetTaskRecord(msg, arg, customData)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.TaskCheck] = {
        file = "ModuleMgr/TaskMgr",
        func = function(msg, arg, customData)
            ---@type ModuleMgr.TaskMgr
            MgrMgr:GetMgr("TaskMgr").OnTaskCheck(msg, arg, customData)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.TaskAccept] = {
        file = "ModuleMgr/TaskMgr",
        func = function(msg, arg, customData)
            ---@type ModuleMgr.TaskMgr
            MgrMgr:GetMgr("TaskMgr").OnTaskAccept(msg, arg, customData)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.TaskFinish] = {
        file = "ModuleMgr/TaskMgr",
        func = function(msg, arg, customData)
            ---@type ModuleMgr.TaskMgr
            MgrMgr:GetMgr("TaskMgr").OnTaskFinish(msg, arg, customData)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.TaskGiveup] = {
        file = "ModuleMgr/TaskMgr",
        func = function(msg, arg, customData)
            ---@type ModuleMgr.TaskMgr
            MgrMgr:GetMgr("TaskMgr").OnTaskGiveup(msg, arg, customData)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.TaskTrackGotoDungeon] = {
        file = "ModuleMgr/TaskMgr",
        func = function(msg)
            ---@type ModuleMgr.TaskMgr
            MgrMgr:GetMgr("TaskMgr").OnTaskTrackGotoDungeon(msg)
        end,
        override = true
    },
    [Network.Define.Rpc.TaskReport] = {
        file = "ModuleMgr/TaskMgr",
        func = function(msg)
            ---@type ModuleMgr.TaskMgr
            MgrMgr:GetMgr("TaskMgr").OnTaskReport(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.GetTaskConvoyPosition] = {
        file = "ModuleMgr/TaskMgr",
        func = function(msg, arg, customData)
            ---@type ModuleMgr.TaskMgr
            MgrMgr:GetMgr("TaskMgr").OnGetConvoyNpcPosition(msg, arg, customData)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.EasyShowNavigate] = {
        file = "ModuleMgr/TaskMgr",
        func = function(msg)
            ---@type ModuleMgr.TaskMgr
            MgrMgr:GetMgr("TaskMgr").OnTaskNavigation(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.RandomNavigate] = {
        file = "ModuleMgr/TaskMgr",
        func = function(msg, args, customData)
            MgrMgr:GetMgr("TaskMgr").OnTaskRandomNavigation(msg, args, customData)
        end,
        override = true --是否覆盖c#协议
    },
    --任务相关结束
    [Network.Define.Rpc.CreateArenaPvpCustom] = {
        file = "ModuleMgr/PvpArenaMgr",
        func = function(msg)
            ---@type ModuleMgr.PvpArenaMgr
            MgrMgr:GetMgr("PvpArenaMgr").OnCreateArenaPvpCustom(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.ActiveJoinArenaRoom] = {
        file = "ModuleMgr/PvpArenaMgr",
        func = function(msg)
            ---@type ModuleMgr.PvpArenaMgr
            MgrMgr:GetMgr("PvpArenaMgr").OnActiveJoinArenaRoom(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.ChangeArenaRoomCondition] = {
        file = "ModuleMgr/PvpArenaMgr",
        func = function(msg)
            ---@type ModuleMgr.PvpArenaMgr
            MgrMgr:GetMgr("PvpArenaMgr").OnChangeArenaRoomCondition(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.ShowArenaRoomList] = {
        file = "ModuleMgr/PvpArenaMgr",
        func = function(msg)
            ---@type ModuleMgr.PvpArenaMgr
            MgrMgr:GetMgr("PvpArenaMgr").OnShowArenaRoomList(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.WearFashion] = {
        file = "ModuleMgr/GarderobeMgr",
        func = function(msg)
            MgrProxy:GetGarderobeMgr().OnWearFashion(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.WearOrnament] = {
        file = "ModuleMgr/GarderobeMgr",
        func = function(msg)
            MgrProxy:GetGarderobeMgr().OnWearOrnament(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.FashionCountSendAward] = {
        file = "ModuleMgr/GarderobeMgr",
        func = function(msg, args, customData)
            MgrProxy:GetGarderobeMgr().OnFashionCountSendAward(msg, args, customData)
        end,
        override = true --是否覆盖c#协议
    },

    [Network.Define.Rpc.GetMvpInfo] = {
        file = "ModuleMgr/MvpMgr",
        func = function(msg)
            ---@type ModuleMgr.MvpMgr
            MgrMgr:GetMgr("MvpMgr").OnGetMvpInfoRsp(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.ArenaInviteRequet] = {
        file = "ModuleMgr/PvpArenaMgr",
        func = function(msg)
            ---@type ModuleMgr.PvpArenaMgr
            MgrMgr:GetMgr("PvpArenaMgr").OnArenaInviteResponse(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.ArenaSetMemberInvite] = {
        file = "ModuleMgr/PvpArenaMgr",
        func = function(msg)
            ---@type ModuleMgr.PvpArenaMgr
            MgrMgr:GetMgr("PvpArenaMgr").OnArenaSetMemberInvite(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.EquipCompound] = {
        file = "ModuleMgr/CompoundMgr",
        func = function(msg, arg)
            ---@type CompoundMgr
            MgrMgr:GetMgr("CompoundMgr").OnEquipCompound(msg, arg);
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GetMVPRankInfo] = {
        file = "ModuleMgr/MvpMgr",
        func = function(msg)
            ---@type ModuleMgr.MvpMgr
            MgrMgr:GetMgr("MvpMgr").OnGetMVPRankInfoRsp(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.ChangeHair] = {
        file = "ModuleMgr/BarberShopMgr",
        func = function(msg)
            ---@type BarberShopMgr
            MgrMgr:GetMgr("BarberShopMgr").OnChangeHair(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.ChangeEye] = {
        file = "ModuleMgr/BeautyShopMgr",
        func = function(msg)
            ---@type BeautyShopMgr
            MgrMgr:GetMgr("BeautyShopMgr").ChangeEyeRsp(msg)
        end,
        override = true --是否覆盖c#协议
    }, [Network.Define.Rpc.UnlockHair] = {
        file = "ModuleMgr/BarberShopMgr",
        func = function(msg)
            ---@type BarberShopMgr
            MgrMgr:GetMgr("BarberShopMgr").OnUnlockHair(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.UnlockEye] = {
        file = "ModuleMgr/BeautyShopMgr",
        func = function(msg)
            ---@type BeautyShopMgr
            MgrMgr:GetMgr("BeautyShopMgr").OnUnlockEye(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.OpenSystemReward] = {
        file = "ModuleMgr/OpenSystemMgr",
        func = function(msg)
            ---@type ModuleMgr.OpenSystemMgr
            MgrMgr:GetMgr("OpenSystemMgr").GetReward(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.RequestShopItem] = {
        file = "ModuleMgr/ShopMgr",
        func = function(msg)
            ---@type ModuleMgr.ShopMgr
            MgrMgr:GetMgr("ShopMgr").GetShopItems(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.RequestBuyShopItem] = {
        file = "ModuleMgr/ShopMgr",
        func = function(...)
            ---@type ModuleMgr.ShopMgr
            MgrMgr:GetMgr("ShopMgr").ReceiveBuyShopItem(...)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.BattlefieldApply] = {
        file = "ModuleMgr/PvpMgr",
        func = function(msg)
            ---@type ModuleMgr.PvpMgr
            MgrMgr:GetMgr("PvpMgr").OnBattlefieldApply(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.TakeVehicle] = {
        file = "ModuleMgr/VehicleMgr",
        func = function(msg)
            ---@type ModuleMgr.VehicleMgr
            MgrMgr:GetMgr("VehicleMgr").OnTakeVehicle(msg)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Rpc.TakeBattleVehicle] = {
        file = "ModuleMgr/VehicleMgr",
        func = function(msg)
            ---@type ModuleMgr.VehicleMgr
            MgrMgr:GetMgr("VehicleMgr").OnTakeBattleVehicle(msg)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Rpc.AskTakeVehicle] = {
        file = "ModuleMgr/VehicleMgr",
        func = function(msg,arg,customData)
            ---@type ModuleMgr.VehicleMgr
            MgrMgr:GetMgr("VehicleMgr").OnAskTakeVehicle(msg,arg,customData)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.GetOnVehicleAgree] = {
        file = "ModuleMgr/VehicleMgr",
        func = function(msg)
            ---@type ModuleMgr.VehicleMgr
            MgrMgr:GetMgr("VehicleMgr").OnGetOnVehicleAgree(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.AccelerateVehicle] = {
        file = "ModuleMgr/VehicleMgr",
        func = function(msg)
            ---@type ModuleMgr.VehicleMgr
            MgrMgr:GetMgr("VehicleMgr").OnAccelerateVehicle(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.RideCommonVehicle] = {
        file = "ModuleMgr/VehicleMgr",
        func = function(msg)
            ---@type ModuleMgr.VehicleMgr
            MgrMgr:GetMgr("VehicleMgr").OnRideCommonVehicle(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.EnableVehicle] = {
        file = "ModuleMgr/VehicleInfoMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.VehicleInfoMgr
            MgrMgr:GetMgr("VehicleInfoMgr").OnEnableVehicleMsg(msg, arg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.UpgradeVehicle] = {
        file = "ModuleMgr/VehicleInfoMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.VehicleInfoMgr
            MgrMgr:GetMgr("VehicleInfoMgr").OnUpgradeVehicleMsg(msg, arg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.UpgradeVehicleLimit] = {
        file = "ModuleMgr/VehicleInfoMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.VehicleInfoMgr
            MgrMgr:GetMgr("VehicleInfoMgr").OnUpgradeVehicleLimitMsg(msg, arg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.DevelopVehicleQuality] = {
        file = "ModuleMgr/VehicleInfoMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.VehicleInfoMgr
            MgrMgr:GetMgr("VehicleInfoMgr").OnDevelopVehicleQualityMsg(msg, arg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.ConfirmVehicleQuality] = {
        file = "ModuleMgr/VehicleInfoMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.VehicleInfoMgr
            MgrMgr:GetMgr("VehicleInfoMgr").OnConfirmVehicleQualityMsg(msg, arg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.ExchangeSpecialVehicle] = {
        file = "ModuleMgr/VehicleInfoMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.VehicleInfoMgr
            MgrMgr:GetMgr("VehicleInfoMgr").OnExchangeSpecialVehicleMsg(msg, arg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.AddOrnamentDye] = {
        file = "ModuleMgr/VehicleInfoMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.VehicleInfoMgr
            MgrMgr:GetMgr("VehicleInfoMgr").OnAddOrnamentDyeMsg(msg, arg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.UseOrnamentDye] = {
        file = "ModuleMgr/VehicleInfoMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.VehicleInfoMgr
            MgrMgr:GetMgr("VehicleInfoMgr").OnUseOrnamentDyeMsg(msg, arg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.SingleCookingStart] = {
        file = "ModuleMgr/CookingSingleMgr",
        func = function(msg)
            ---@type ModuleMgr.CookingSingleMgr
            MgrMgr:GetMgr("CookingSingleMgr").OnSingleCookingStart(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.SingleCookingFinish] = {
        file = "ModuleMgr/CookingSingleMgr",
        func = function(msg)
            ---@type ModuleMgr.CookingSingleMgr
            MgrMgr:GetMgr("CookingSingleMgr").OnSingleCookingFinish(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.ForgeEquip] = {
        file = "ModuleMgr/ForgeMgr",
        func = function(msg)
            ---@type ModuleMgr.ForgeMgr
            MgrMgr:GetMgr("ForgeMgr").ReceiveForgeEquip(msg)
        end,
        override = true --是否覆盖c#协议
    },
    --[Network.Define.Rpc.GetLimitCardPool] = {
    --    file = "ModuleMgr/CardExchangeShopMgr",
    --    func = function(msg)
    --        MgrMgr:GetMgr("CardExchangeShopMgr").ReceiveGetLimitCardPool(msg)
    --    end,
    --    override = true --是否覆盖c#协议
    --},
    --[Network.Define.Rpc.BuyLimitCard] = {
    --    file = "ModuleMgr/CardExchangeShopMgr",
    --    func = function(msg)
    --        MgrMgr:GetMgr("CardExchangeShopMgr").ReceiveBuyLimitCard(msg)
    --    end,
    --    override = true --是否覆盖c#协议
    --},
    [Network.Define.Rpc.DailyActivityShow] = {
        file = "ModuleMgr/DailyTaskMgr",
        func = function(msg)
            ---@type ModuleMgr.DailyTaskMgr
            MgrMgr:GetMgr("DailyTaskMgr").OnDailyActivityShow(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.DailyActivityShowToMS] = {
        file = "ModuleMgr/DailyTaskMgr",
        func = function(msg)
            ---@type ModuleMgr.DailyTaskMgr
            MgrMgr:GetMgr("DailyTaskMgr").OnDailyActivityShowToMS(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.DrawBoLiPointAward] = {
        file = "ModuleMgr/DailyTaskMgr",
        func = function(msg)
            ---@type ModuleMgr.DailyTaskMgr
            MgrMgr:GetMgr("DailyTaskMgr").OnDrawBoLiPointAwardRsp(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.EquipRefineUpgrade] = {
        file = "ModuleMgr/RefineMgr",
        func = function(msg)
            ---@type ModuleMgr.RefineMgr
            MgrMgr:GetMgr("RefineMgr").ReceiveEquipRefineUpgrade(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.EquipRefineUpgrade] = {
        file = "ModuleMgr/RefineMgr",
        func = function(msg)
            MgrMgr:GetMgr("RefineMgr").ReceiveEquipRefineUpgrade(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.UseRedEnvelope] = {
        file = "ModuleMgr/RefineMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildHuntMgr
            MgrMgr:GetMgr("GuildHuntMgr").OnReqUseRedEnvelope(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.EquipRefineRepair] = {
        file = "ModuleMgr/RefineMgr",
        func = function(msg)
            ---@type ModuleMgr.RefineMgr
            MgrMgr:GetMgr("RefineMgr").ReceiveEquipRepair(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.IsAssist] = {
        file = "ModuleMgr/DungeonMgr",
        func = function(msg,arg)
            ---@type ModuleMgr.DungeonMgr
            MgrMgr:GetMgr("DungeonMgr").OnSetIsAssist(msg,arg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.GetCountInfo] = {
        file = "ModuleMgr/LimitBuyMgr",
        func = function(msg)
            ---@type ModuleMgr.LimitBuyMgr
            MgrMgr:GetMgr("LimitBuyMgr").OnGetCountInfoRsp(msg)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Rpc.GetTradeInfo] = {
        file = "ModuleMgr/TradeMgr",
        func = function(msg)
            ---@type ModuleMgr.TradeMgr
            MgrMgr:GetMgr("TradeMgr").OnGetTradeInfoRsp(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.TradeBuyItem] = {
        file = "ModuleMgr/TradeMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.TradeMgr
            MgrMgr:GetMgr("TradeMgr").OnTradeBuyItemRsp(msg, arg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.TradeSellItem] = {
        file = "ModuleMgr/TradeMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.TradeMgr
            MgrMgr:GetMgr("TradeMgr").OnTradeSellItemRsp(msg, arg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.TradeFollowItem] = {
        file = "ModuleMgr/TradeMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.TradeMgr
            MgrMgr:GetMgr("TradeMgr").OnTradeFollowItemRsp(msg, arg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.GetValidName] = {
        file = "ModuleMgr/SelectRoleMgr",
        func = function(msg)
            ---@type ModuleMgr.SelectRoleMgr
            MgrMgr:GetMgr("SelectRoleMgr").OnGetRoleRandomName(msg);
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.YuanQiRequest] = {
        file = "ModuleMgr/LifeProfessionMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.LifeProfessionMgr
            MgrMgr:GetMgr("LifeProfessionMgr").OnYuanQiRequest(msg, arg);
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GuildCreate] = {
        file = "ModuleMgr/GuildMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildMgr
            MgrMgr:GetMgr("GuildMgr").OnReqCreateGuild(msg);
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GuildGetInfo] = {
        file = "ModuleMgr/GuildMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildMgr
            MgrMgr:GetMgr("GuildMgr").OnReqGuildInfo(msg);
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GetJoinGuildTime] = {
        file = "ModuleMgr/GuildMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildMgr
            MgrMgr:GetMgr("GuildMgr").OnReqJoinTime(msg);
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GuildGetList] = {
        file = "ModuleMgr/GuildMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildMgr
            MgrMgr:GetMgr("GuildMgr").OnReqGetGuildList(msg);
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GuildSearch] = {
        file = "ModuleMgr/GuildMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildMgr
            MgrMgr:GetMgr("GuildMgr").OnReqSearchGuild(msg);
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GuildApply] = {
        file = "ModuleMgr/GuildMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.GuildMgr
            MgrMgr:GetMgr("GuildMgr").OnReqApply(msg, arg);
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GuildDeclarationChange] = {
        file = "ModuleMgr/GuildMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildMgr
            MgrMgr:GetMgr("GuildMgr").OnReqModifyRecruitWords(msg);
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GuildAnnounceChange] = {
        file = "ModuleMgr/GuildMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildMgr
            MgrMgr:GetMgr("GuildMgr").OnReqModifyGuildNotice(msg);
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.RequestEquipForgedList] = {
        file = "ModuleMgr/ForgeMgr",
        func = function(msg)
            ---@type ModuleMgr.ForgeMgr
            MgrMgr:GetMgr("ForgeMgr").ReceiveEquipForgedList(msg);
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.AchievementGetInfo] = {
        file = "ModuleMgr/AchievementMgr",
        func = function(msg)
            ---@type ModuleMgr.AchievementMgr
            MgrMgr:GetMgr("AchievementMgr").ReceiveAchievementGetInfo(msg);
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.AchievementGetFinishRateInfo] = {
        file = "ModuleMgr/AchievementMgr",
        func = function(msg)
            ---@type ModuleMgr.AchievementMgr
            MgrMgr:GetMgr("AchievementMgr").ReceiveAchievementGetFinishRateInfo(msg);
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.AchievementGetBadgeRateInfo] = {
        file = "ModuleMgr/AchievementMgr",
        func = function(msg, m, index)
            ---@type ModuleMgr.AchievementMgr
            MgrMgr:GetMgr("AchievementMgr").ReceiveAchievementGetBadgeRateInfo(msg, m, index);
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.AchievementGetItemReward] = {
        file = "ModuleMgr/AchievementMgr",
        func = function(msg, data)
            ---@type ModuleMgr.AchievementMgr
            MgrMgr:GetMgr("AchievementMgr").ReceiveAchievementGetItemReward(msg, data);
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.AchievementGetPointReward] = {
        file = "ModuleMgr/AchievementMgr",
        func = function(msg)
            ---@type ModuleMgr.AchievementMgr
            MgrMgr:GetMgr("AchievementMgr").ReceiveAchievementGetPointReward(msg);
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.AchievementGetBadgeReward] = {
        file = "ModuleMgr/AchievementMgr",
        func = function(msg, data)
            ---@type ModuleMgr.AchievementMgr
            MgrMgr:GetMgr("AchievementMgr").ReceiveAchievementGetBadgeReward(msg, data);
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.FAQReport] = {
        file = "ModuleMgr/CapraFAQMgr",
        func = function(msg)
            ---@type ModuleMgr.CapraFAQMgr
            MgrMgr:GetMgr("CapraFAQMgr").ReceiveFAQReport(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.ChangeReplicaCardState] = {
        file = "ModuleMgr/CapraCardMgr",
        func = function(msg)
            ---@type ModuleMgr.CapraCardMgr
            MgrMgr:GetMgr("CapraCardMgr").RetChangeReplicaCardState(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GetRolesBattleInfo] = {
        file = "ModuleMgr/PlayerInfoMgr",
        func = function(msg)
            ---@type ModuleMgr.PlayerInfoMgr
            MgrMgr:GetMgr("PlayerInfoMgr").OnRetGetRolesBattleInfo(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GuildQueryMemberList] = {
        file = "ModuleMgr/GuildMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildMgr
            MgrMgr:GetMgr("GuildMgr").OnReqGuildMemberList(msg);
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GuildEmailSend] = {
        file = "ModuleMgr/GuildMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildMgr
            MgrMgr:GetMgr("GuildMgr").OnReqSendGuildEmail(msg);
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GuildMemberSearch] = {
        file = "ModuleMgr/GuildMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildMgr
            MgrMgr:GetMgr("GuildMgr").OnReqSearchGuildMember(msg);
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GuildChangePermission] = {
        file = "ModuleMgr/GuildMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.GuildMgr
            MgrMgr:GetMgr("GuildMgr").OnReqAppoint(msg, arg);
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GuildPermissionNameChange] = {
        file = "ModuleMgr/GuildMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.GuildMgr
            MgrMgr:GetMgr("GuildMgr").OnReqEditPositionName(msg, arg);
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.FindGuildBeautyCandidate] = {
        file = "ModuleMgr/GuildMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.GuildMgr
            local mgr = MgrMgr:GetMgr("GuildMgr")
            mgr.OnFindGuildBeautyCandidate(msg, arg);
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GuildKickOutMember] = {
        file = "ModuleMgr/GuildMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.GuildMgr
            MgrMgr:GetMgr("GuildMgr").OnReqKickOut(msg, arg);
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GuildGetApplicationList] = {
        file = "ModuleMgr/GuildMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildMgr
            MgrMgr:GetMgr("GuildMgr").OnReqApplyList(msg);
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GuildApplyReplay] = {
        file = "ModuleMgr/GuildMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.GuildMgr
            MgrMgr:GetMgr("GuildMgr").OnReqCheckApply(msg, arg);
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GuildAutoApprovalApply] = {
        file = "ModuleMgr/GuildMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.GuildMgr
            MgrMgr:GetMgr("GuildMgr").OnReqSetAutoCheck(msg, arg);
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GuildQuit] = {
        file = "ModuleMgr/GuildMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildMgr
            MgrMgr:GetMgr("GuildMgr").OnReqQuit(msg);
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GuildIconChange] = {
        file = "ModuleMgr/GuildMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.GuildMgr
            MgrMgr:GetMgr("GuildMgr").OnReqModifyGuildIcon(msg, arg);
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GuildGetNewsInfo] = {
        file = "ModuleMgr/GuildMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildMgr
            MgrMgr:GetMgr("GuildMgr").OnReqGuildNews(msg);
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GuildInviteJoin] = {
        file = "ModuleMgr/GuildMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildMgr
            MgrMgr:GetMgr("GuildMgr").OnReqInviteJoin(msg);
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GuildGetBuildingInfo] = {
        file = "ModuleMgr/GuildBuildMgr",
        func = function(msg, arg, customData)
            ---@type ModuleMgr.GuildBuildMgr
            MgrMgr:GetMgr("GuildBuildMgr").OnReqGuildBuildMsg(msg, arg, customData);
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GuildUpBuildingLevel] = {
        file = "ModuleMgr/GuildBuildMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.GuildBuildMgr
            MgrMgr:GetMgr("GuildBuildMgr").OnReqGuildBuildUpgrade(msg, arg);
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GuildDonateMaterials] = {
        file = "ModuleMgr/GuildBuildMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildBuildMgr
            MgrMgr:GetMgr("GuildBuildMgr").OnReqMaterialDonate(msg);
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GuildDonateMoney] = {
        file = "ModuleMgr/GuildBuildMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildBuildMgr
            MgrMgr:GetMgr("GuildBuildMgr").OnReqDiamondContribute(msg);
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GuildCrystalGetInfo] = {
        file = "ModuleMgr/GuildCrystalMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildCrystalMgr
            MgrMgr:GetMgr("GuildCrystalMgr").OnReqGetGuildCrystalInfo(msg);
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GuildCrystalLearn] = {
        file = "ModuleMgr/GuildCrystalMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.GuildCrystalMgr
            MgrMgr:GetMgr("GuildCrystalMgr").OnReqGuildCrystalStudy(msg, arg);
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GuildCrystalQuickUpgrade] = {
        file = "ModuleMgr/GuildCrystalMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildCrystalMgr
            MgrMgr:GetMgr("GuildCrystalMgr").OnReqGuildCrystalQuickUpgrade(msg);
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GuildCrystalPray] = {
        file = "ModuleMgr/GuildCrystalMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildCrystalMgr
            MgrMgr:GetMgr("GuildCrystalMgr").OnReqGuildCrystalPray(msg);
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GuildCrystalGiveEnergy] = {
        file = "ModuleMgr/GuildCrystalMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildCrystalMgr
            MgrMgr:GetMgr("GuildCrystalMgr").OnReqGuildCrystalCharge(msg);
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GuildCrystalCheckAnnounce] = {
        file = "ModuleMgr/GuildCrystalMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildCrystalMgr
            MgrMgr:GetMgr("GuildCrystalMgr").OnReqCheckCrystalChargeAnnounce(msg);
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GuildGetWelfare] = {
        file = "ModuleMgr/GuildWelfareMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildWelfareMgr
            MgrMgr:GetMgr("GuildWelfareMgr").OnReqGetWelfare(msg);
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GuildGiveItem] = {
        file = "ModuleMgr/GuildMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildMgr
            MgrMgr:GetMgr("GuildMgr").OnReqContributeGuildItem(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GuildWelfareAward] = {
        file = "ModuleMgr/GuildWelfareMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildWelfareMgr
            MgrMgr:GetMgr("GuildWelfareMgr").OnReqGetWelfareAward(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GuildBindingRemind] = {
        file = "ModuleMgr/GuildSDKMgr",
        func = function(msg)
            ---@type GuildSDKMgr
            MgrMgr:GetMgr("GuildSDKMgr").OnReqRemindChairmanToBindGroup(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GuildBinding] = {
        file = "ModuleMgr/GuildSDKMgr",
        func = function(msg)
            ---@type GuildSDKMgr
            MgrMgr:GetMgr("GuildSDKMgr").OnReqBindQQGroup(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GuildGiftGetInfo] = {
        file = "ModuleMgr/GuildWelfareMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildWelfareMgr
            MgrMgr:GetMgr("GuildWelfareMgr").OnReqGuildGiftInfo(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GuildGiftHandOut] = {
        file = "ModuleMgr/GuildWelfareMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildWelfareMgr
            MgrMgr:GetMgr("GuildWelfareMgr").OnReqGuildGiftGrant(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GuildHuntGetInfo] = {
        file = "ModuleMgr/GuildHuntMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildHuntMgr
            MgrMgr:GetMgr("GuildHuntMgr").OnReqGetGuildHuntInfo(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GuildHuntOpenRequest] = {
        file = "ModuleMgr/GuildHuntMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildHuntMgr
            MgrMgr:GetMgr("GuildHuntMgr").OnReqOpenHuntActivity(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GuildHuntGetFinalReward] = {
        file = "ModuleMgr/GuildHuntMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildHuntMgr
            MgrMgr:GetMgr("GuildHuntMgr").OnReqGetGuildHuntAwardBox(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GuildHuntFindTeamMate] = {
        file = "ModuleMgr/GuildHuntMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildHuntMgr
            MgrMgr:GetMgr("GuildHuntMgr").OnReqGuildHuntFindTeamMate(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GetGuildRepoInfo] = {
        file = "ModuleMgr/GuildDepositoryMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildDepositoryMgr
            MgrMgr:GetMgr("GuildDepositoryMgr").OnReqGetGuildDepositoryInfo(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GuildRepoSetAttention] = {
        file = "ModuleMgr/GuildDepositoryMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.GuildDepositoryMgr
            MgrMgr:GetMgr("GuildDepositoryMgr").OnReqSetAttention(msg, arg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GuildRepoRemoveItem] = {
        file = "ModuleMgr/GuildDepositoryMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildDepositoryMgr
            MgrMgr:GetMgr("GuildDepositoryMgr").OnReqRemoveItem(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GuildAuctionSetPrice] = {
        file = "ModuleMgr/GuildDepositoryMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildDepositoryMgr
            MgrMgr:GetMgr("GuildDepositoryMgr").OnReqBidItem(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.SetRedPointCommonData] = {
        file = "ModuleMgr/RedSignMgr",
        func = function(msg)
            ---@type ModuleMgr.RedSignMgr
            MgrMgr:GetMgr("RedSignMgr").GetRedPointCommonDataResult(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GetGuildAuctionPublicRecord] = {
        file = "ModuleMgr/GuildDepositoryMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildDepositoryMgr
            MgrMgr:GetMgr("GuildDepositoryMgr").OnReqSaleRecordPublic(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GetGuildAuctionPersonalRecord] = {
        file = "ModuleMgr/GuildDepositoryMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildDepositoryMgr
            MgrMgr:GetMgr("GuildDepositoryMgr").OnReqSaleRecordPersonal(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GuildDinnerViewMenu] = {
        file = "ModuleMgr/GuildDinnerMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildDinnerMgr
            MgrMgr:GetMgr("GuildDinnerMgr").OnGuildDinnerViewMenuRsp(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GuildDinnerTaskAccept] = {
        file = "ModuleMgr/GuildDinnerMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildDinnerMgr
            MgrMgr:GetMgr("GuildDinnerMgr").OnGuildDinnerTaskAcceptRsp(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GuildDinnerGetDishNPCState] = {
        file = "ModuleMgr/GuildDinnerMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.GuildDinnerMgr
            MgrMgr:GetMgr("GuildDinnerMgr").OnGuildDinnerGetDishNPCState(msg, arg)
        end,
        override = false --覆盖C#协议
    },
    [Network.Define.Rpc.GuildDinnerEatDish] = {
        file = "ModuleMgr/GuildDinnerMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildDinnerMgr
            MgrMgr:GetMgr("GuildDinnerMgr").OnReqTasteDish(msg)
        end,
        override = false --覆盖C#协议
    },
    [Network.Define.Rpc.GuildDinnerShareDish] = {
        file = "ModuleMgr/GuildDinnerMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildDinnerMgr
            MgrMgr:GetMgr("GuildDinnerMgr").OnGuildDinnerShareDish(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GuildDinnerCreamMeleeRenshu] = {
        file = "ModuleMgr/GuildDinnerMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildDinnerMgr
            MgrMgr:GetMgr("GuildDinnerMgr").OnReqGuildDinnerCreamMeleeRenshu(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GuildDinnerGetPhotoAward] = {
        file = "ModuleMgr/GuildDinnerMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildDinnerMgr
            MgrMgr:GetMgr("GuildDinnerMgr").OnReqPhotoWithStoneStatueAward(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GuildDinnerOpenChampagne] = {
        file = "ModuleMgr/GuildDinnerMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildDinnerMgr
            MgrMgr:GetMgr("GuildDinnerMgr").OnReqOpenDinnerWish(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GuildDinnerGetPersonResult] = {
        file = "ModuleMgr/GuildDinnerMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.GuildDinnerMgr
            MgrMgr:GetMgr("GuildDinnerMgr").OnReqPersonalCookingScoreInfo(msg, arg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GuildDinnerGetCompetitionResult] = {
        file = "ModuleMgr/GuildDinnerMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildDinnerMgr
            MgrMgr:GetMgr("GuildDinnerMgr").OnReqGuildCookingScoreInfo(msg, arg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.CheckGuildDinnerOpen] = {
        file = "ModuleMgr/GuildDinnerMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildDinnerMgr
            local mgr = MgrMgr:GetMgr("GuildDinnerMgr")
            mgr.OnCheckGuildDinnerOpen(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.ReadPrivateMessage] = {
        file = "ModuleMgr/FriendMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.FriendMgr
            MgrMgr:GetMgr("FriendMgr").ReceiveReadPrivateMessage(msg, arg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.GetFriendInfo] = {
        file = "ModuleMgr/FriendMgr",
        func = function(msg)
            ---@type ModuleMgr.FriendMgr
            MgrMgr:GetMgr("FriendMgr").ReceiveGetFriendInfo(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.StallGetMarkInfo] = {
        file = "ModuleMgr/StallMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.StallMgr
            MgrMgr:GetMgr("StallMgr").OnStallGetMarkInfoRsp(msg, arg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.StallGetItemInfo] = {
        file = "ModuleMgr/StallMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.StallMgr
            MgrMgr:GetMgr("StallMgr").OnStallGetItemInfoRsp(msg, arg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.StallItemBuy] = {
        file = "ModuleMgr/StallMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.StallMgr
            MgrMgr:GetMgr("StallMgr").OnStallItemBuyRsp(msg, arg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.StallRefresh] = {
        file = "ModuleMgr/StallMgr",
        func = function(msg)
            ---@type ModuleMgr.StallMgr
            MgrMgr:GetMgr("StallMgr").OnStallRefreshRsp(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.StallGetSellInfo] = {
        file = "ModuleMgr/StallMgr",
        func = function(msg)
            ---@type ModuleMgr.StallMgr
            MgrMgr:GetMgr("StallMgr").OnStallGetSellInfoRsp(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.StallGetPreSellItemInfo] = {
        file = "ModuleMgr/StallMgr",
        func = function(msg, arg, fastMountingInfo)
            ---@type ModuleMgr.StallMgr
            MgrMgr:GetMgr("StallMgr").OnStallGetPreSellItemInfoRsp(msg, arg, fastMountingInfo)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.StallSellItem] = {
        file = "ModuleMgr/StallMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.StallMgr
            MgrMgr:GetMgr("StallMgr").OnStallSellItemRsp(msg, arg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.StallSellItemCancel] = {
        file = "ModuleMgr/StallMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.StallMgr
            MgrMgr:GetMgr("StallMgr").OnStallSellItemCancelRsp(msg, arg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.StallDrawMoney] = {
        file = "ModuleMgr/StallMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.StallMgr
            MgrMgr:GetMgr("StallMgr").OnStallDrawMoneyRsp(msg, arg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.StallBuyStallCount] = {
        file = "ModuleMgr/StallMgr",
        func = function(msg)
            ---@type ModuleMgr.StallMgr
            MgrMgr:GetMgr("StallMgr").OnStallBuyStallCountRsp(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.StallReSellItem] = {
        file = "ModuleMgr/StallMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.StallMgr
            MgrMgr:GetMgr("StallMgr").OnStallReSellItemRsp(msg, arg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.GetMailList] = {
        file = "ModuleMgr/EmailMgr",
        func = function(msg)
            ---@type ModuleMgr.EmailMgr
            MgrMgr:GetMgr("EmailMgr").OnGetMailList(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.MailOp] = {
        file = "ModuleMgr/EmailMgr",
        func = function(msg)
            ---@type ModuleMgr.EmailMgr
            MgrMgr:GetMgr("EmailMgr").OnMailOp(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.GetOneMail] = {
        file = "ModuleMgr/EmailMgr",
        func = function(msg)
            ---@type ModuleMgr.EmailMgr
            MgrMgr:GetMgr("EmailMgr").OnGetOneMail(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.EquipEnchant] = {
        file = "ModuleMgr/EnchantMgr",
        func = function(msg)
            ---@type ModuleMgr.EnchantMgr
            MgrMgr:GetMgr("EnchantMgr").ReceiveEquipEnchant(msg);
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.EquipEnchantConfirm] = {
        file = "ModuleMgr/EnchantMgr",
        func = function(msg)
            ---@type ModuleMgr.EnchantMgr
            MgrMgr:GetMgr("EnchantMgr").ConfirmEquipEnchant(msg);
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GetServerLevelBonusInfo] = {
        file = "ModuleMgr/RoleInfoMgr",
        func = function(msg)
            ---@type ModuleMgr.RoleInfoMgr
            MgrMgr:GetMgr("RoleInfoMgr").OnGetServerLevelBonusInfo(msg)
        end,
        override = false --覆盖C#协议
    },

    [Network.Define.Rpc.ExchangeHeadGear] = {
        file = "ModuleMgr/HeadShopMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.HeadShopMgr
            MgrMgr:GetMgr("HeadShopMgr").OnExchangeHeadGear(msg, arg)
        end,
        override = true --覆盖C#协议
    },


    [Network.Define.Rpc.HSQueryRoundInfo] = {
        file = "ModuleMgr/HymnTrialMgr",
        func = function(msg)
            ---@type ModuleMgr.HymnTrialMgr
            MgrMgr:GetMgr("HymnTrialMgr").OnReqCurTurnInfo(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.EnterSceneWall] = {
        file = "ModuleMgr/HymnTrialMgr", --场景物件交互返回 暂时写在圣歌管理类里后续有需要请移到公用的地方
        func = function(msg)
            ---@type ModuleMgr.HymnTrialMgr
            MgrMgr:GetMgr("HymnTrialMgr").OnEnterSceneWall(msg)
        end,
        override = false --覆盖C#协议
    },
    [Network.Define.Rpc.PickUpDropBuff] = {
        file = "ModuleMgr/HymnTrialMgr", --buff拾取的返回 暂时写在圣歌管理类里后续有需要请移到公用的地方
        func = function(msg)
            ---@type ModuleMgr.HymnTrialMgr
            MgrMgr:GetMgr("HymnTrialMgr").OnPickBuff(msg)
        end,
        override = false --覆盖C#协议
    },


    [Network.Define.Rpc.PullChatMsg] = {
        file = "ModuleMgr/ChatMgr",
        func = function(msg)
            ---@type ModuleMgr.ChatMgr
            MgrMgr:GetMgr("ChatMgr").OnGuideHistoryMsg(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.AwardPreview] = {
        file = "ModuleMgr/AwardPreviewMgr",
        func = function(msg, arg, customData)
            ---@type AwardPreviewMgr
            MgrMgr:GetMgr("AwardPreviewMgr").OnAwardPreviewMsg(msg, arg, customData)
        end,
        override = true, --覆盖C#协议
    },
    [Network.Define.Rpc.BatchAwardPreview] = {
        file = "ModuleMgr/AwardPreviewMgr",
        func = function(msg, arg, customData)
            ---@type AwardPreviewMgr
            MgrMgr:GetMgr("AwardPreviewMgr").OnBatchAwardPreviewMsg(msg, arg, customData)
        end,
        override = true, --覆盖C#协议
    },
    [Network.Define.Rpc.EquipCardInsert] = {
        file = "ModuleMgr/EquipCardForgeHandlerMgr",
        func = function(msg)
            ---@type ModuleMgr.EquipCardForgeHandlerMgr
            MgrMgr:GetMgr("EquipCardForgeHandlerMgr").EquipCardInsert(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.EquipCardRemove] = {
        file = "ModuleMgr/EquipCardForgeHandlerMgr",
        func = function(msg)
            ---@type ModuleMgr.EquipCardForgeHandlerMgr
            MgrMgr:GetMgr("EquipCardForgeHandlerMgr").EquipCardRemove(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.EquipMakeHole] = {
        file = "ModuleMgr/EquipMakeHoleMgr",
        func = function(msg)
            ---@type ModuleMgr.EquipMakeHoleMgr
            MgrMgr:GetMgr("EquipMakeHoleMgr").ReceiveEquipMakeHole(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.EquipHoleRefoge] = {
        file = "ModuleMgr/EquipMakeHoleMgr",
        func = function(msg)
            ---@type ModuleMgr.EquipMakeHoleMgr
            MgrMgr:GetMgr("EquipMakeHoleMgr").ReceiveEquipHoleRefoge(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.EquipSaveHoleReforge] = {
        file = "ModuleMgr/EquipMakeHoleMgr",
        func = function(msg)
            ---@type ModuleMgr.EquipMakeHoleMgr
            MgrMgr:GetMgr("EquipMakeHoleMgr").ReceiveEquipSaveHoleReforge(msg)
        end,
        override = true --覆盖C#协议
    },

    [Network.Define.Rpc.QueryRandomAwardStart] = {
        file = "ModuleMgr/TurnTableMgr",
        func = function(msg, args, params)
            ---@type TurnTableMgr
            MgrMgr:GetMgr("TurnTableMgr").OnQueryRandomAwardStart(msg, args, params)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GiveGifts] = {
        file = "ModuleMgr/GiftMgr",
        func = function(msg,arg,customData)
            ---@type ModuleMgr.GiftMgr
            MgrMgr:GetMgr("GiftMgr").GiveGiftsSucess(msg,arg,customData)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GetGiftLimitInfo] = {
        file = "ModuleMgr/GiftMgr",
        func = function(msg)
            ---@type ModuleMgr.GiftMgr
            MgrMgr:GetMgr("GiftMgr").GetGiftLimitInfo(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GetBlessInfo] = {
        file = "ModuleMgr/DailyTaskMgr",
        func = function(msg)
            ---@type ModuleMgr.DailyTaskMgr
            MgrMgr:GetMgr("DailyTaskMgr").OnGetBlessInfo(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.BlessOperation] = {
        file = "ModuleMgr/DailyTaskMgr",
        func = function(msg)
            ---@type ModuleMgr.DailyTaskMgr
            MgrMgr:GetMgr("DailyTaskMgr").OnBlessOperate(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.LifeSkillFishing] = {
        file = "ModuleMgr/FishMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.FishMgr
            MgrMgr:GetMgr("FishMgr").OnReqFish(msg, arg)
        end,
        override = false --覆盖C#协议
    },
    [Network.Define.Rpc.LifeEquipChange] = {
        file = "ModuleMgr/FishMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.FishMgr
            MgrMgr:GetMgr("FishMgr").OnReqUseFishItem(msg, arg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.AutoFishPush] = {
        file = "ModuleMgr/FishMgr",
        func = function(msg)
            ---@type ModuleMgr.FishMgr
            MgrMgr:GetMgr("FishMgr").OnReqGetAutoFishInfo(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.AutoCollect] = {
        file = "ModuleMgr/LifeProfessionMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.LifeProfessionMgr
            local mgr = MgrMgr:GetMgr("LifeProfessionMgr")
            mgr.OnReqAutoCollect(msg, arg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GetAutoCollectEndTime] = {
        file = "ModuleMgr/LifeProfessionMgr",
        func = function(msg, arg, customData)
            ---@type ModuleMgr.LifeProfessionMgr
            local mgr = MgrMgr:GetMgr("LifeProfessionMgr")
            mgr.OnGetAutoCollectEndTime(msg, arg, customData)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.LifeSkillUpgrade] = {
        file = "ModuleMgr/LifeProfessionMgr",
        func = function(msg, arg, customData)
            ---@type ModuleMgr.LifeProfessionMgr
            local mgr = MgrMgr:GetMgr("LifeProfessionMgr")
            mgr.OnLifeSkillUpgrade(msg, arg, customData)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.BreakOffAutoCollect] = {
        file = "ModuleMgr/LifeProfessionMgr",
        func = function(msg)
            ---@type ModuleMgr.LifeProfessionMgr
            local mgr = MgrMgr:GetMgr("LifeProfessionMgr")
            mgr.OnBreakOffAutoCollect(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.SevenLoginActivityGetReward] = {
        file = "ModuleMgr/LandingAwardMgr",
        func = function(msg)
            ---@type ModuleMgr.LandingAwardMgr
            MgrMgr:GetMgr("LandingAwardMgr").OnGetLandingAward(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.SevenLoginActivityGetInfo] = {
        file = "ModuleMgr/LandingAwardMgr",
        func = function(msg)
            ---@type ModuleMgr.LandingAwardMgr
            MgrMgr:GetMgr("LandingAwardMgr").OnGetLandingInfo(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.SaveReviveRecord] = {
        file = "ModuleMgr/KplFunctionMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.KplFunctionMgr
            MgrMgr:GetMgr("KplFunctionMgr").OnSaveReviveRecord(msg, arg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.AddFriend] = {
        file = "ModuleMgr/FriendMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.FriendMgr
            MgrMgr:GetMgr("FriendMgr").OnRequestAddFriend(msg, arg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.SendChatMsg] = {
        file = "ModuleMgr/ChatMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.ChatMgr
            MgrMgr:GetMgr("ChatMgr").OnSendChatMsg(msg, arg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.FrequentWords] = {
        file = "ModuleMgr/ChatMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.ChatMgr
            MgrMgr:GetMgr("ChatMgr").OnFrequentWordsMsg(msg, arg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.ChatShareMsg] = {
        file = "ModuleMgr/ChatMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.ChatMgr
            MgrMgr:GetMgr("ChatMgr").OnChatShareC2MMsg(msg, arg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.ChangeChatForbid] = {
        file = "ModuleMgr/ChatMgr",
        func = function(msg, arg,customData)
            ---@type ModuleMgr.ChatMgr
            MgrMgr:GetMgr("ChatMgr").OnChangeChatForbid(msg, arg,customData)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.RoleSearch] = {
        file = "ModuleMgr/FriendMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.FriendMgr
            MgrMgr:GetMgr("FriendMgr").OnSearchRole(msg, arg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.RequestSellShopItem] = {
        file = "ModuleMgr/ShopMgr",
        func = function(msg, arg, customData)
            ---@type ModuleMgr.ShopMgr
            MgrMgr:GetMgr("ShopMgr").ReceiveSellShopItem(msg, arg, customData)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.DoEnterScene] = {
        file = "ModuleMgr/MgrMgr",
        func = function(msg, arg)
            Network.Handler.OnLuaDoEnterScene(msg)
        end,
        override = false --覆盖C#协议
    },

    [Network.Define.Rpc.TowerDefenseFastNextWave] = {
        file = "ModuleMgr/TowerDefenseMgr",
        func = function(msg)
            ---@type ModuleMgr.TowerDefenseMgr
            MgrMgr:GetMgr("TowerDefenseMgr").ReceiveTowerDefenseFastNextWave(msg)
        end,
        override = true --覆盖C#协议
    },

    [Network.Define.Rpc.SetTowerDefenseBless] = {
        file = "ModuleMgr/TowerDefenseMgr",
        func = function(msg)
            ---@type ModuleMgr.TowerDefenseMgr
            local mgr = MgrMgr:GetMgr("TowerDefenseMgr")
            mgr.ReceiveSetTowerDefenseBless(msg)
        end,
        override = true --覆盖C#协议
    },

    [Network.Define.Rpc.GetReturnLoginPrize] = {
        file = "ModuleMgr/ReBackLoginMgr",
        func = function(msg)
            local mgr = MgrMgr:GetMgr("ReBackLoginMgr")
            mgr.ReceiveGetReturnLoginPrize(msg)
        end,
        override = true --覆盖C#协议
    },

    [Network.Define.Rpc.ReturnPrizeWelcomeNext] = {
        file = "ModuleMgr/ReBackMgr",
        func = function(msg)
            local mgr = MgrMgr:GetMgr("ReBackMgr")
            mgr.ResPrizeWelcomeNext(msg)
        end,
        override = true --覆盖C#协议
    },

    [Network.Define.Rpc.GetTowerDefenseWeekAward] = {
        file = "ModuleMgr/TowerDefenseMgr",
        func = function(msg)
            ---@type ModuleMgr.TowerDefenseMgr
            local mgr = MgrMgr:GetMgr("TowerDefenseMgr")
            mgr.ReceiveGetTowerDefenseWeekAward(msg)
        end,
        override = true --覆盖C#协议
    },

    [Network.Define.Rpc.DoubleActiveApply] = {
        file = "ModuleMgr/MultipleActionMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.MultipleActionMgr
            MgrMgr:GetMgr("MultipleActionMgr").OnMultipleAction(msg, arg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.DoubleActiveAgree] = {
        file = "ModuleMgr/MultipleActionMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.MultipleActionMgr
            MgrMgr:GetMgr("MultipleActionMgr").OnAccpetMultipleActionResult(msg, arg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.DoubleActiveEnd] = {
        file = "ModuleMgr/MultipleActionMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.MultipleActionMgr
            MgrMgr:GetMgr("MultipleActionMgr").OnDoubleActiveEnd(msg, arg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.ChatSenderInfo] = {
        file = "ModuleMgr/PlayerInfoMgr",
        func = function(msg, arg, customData)
            ---@type ModuleMgr.PlayerInfoMgr
            MgrMgr:GetMgr("PlayerInfoMgr").OnChatSenderInfo(msg, arg, customData)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.BatchChatSenderInfo] = {
        file = "ModuleMgr/PlayerInfoMgr",
        func = function(msg, arg, customData)
            ---@type ModuleMgr.PlayerInfoMgr
            local mgr = MgrMgr:GetMgr("PlayerInfoMgr")
            mgr.OnBatchGetPlayerInfoFromServer(msg, arg, customData)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GetItemByUid] = {
        file = "ModuleMgr/ItemMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.ItemMgr
            MgrMgr:GetMgr("ItemMgr").OnGetItemByUid(msg, arg)
        end,
        override = false --覆盖C#协议
    },
    [Network.Define.Rpc.JudgeTextForbid] = {
        file = "ModuleMgr/ForbidTextMgr",
        func = function(msg, arg, customData)
            ---@type ForbidTextMgr
            MgrMgr:GetMgr("ForbidTextMgr").OnJudgeTextForbid(msg, arg, customData)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.UnLockRoleIllutration] = {
        file = "ModuleMgr/IllustrationMonsterMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.IllustrationMonsterMgr
            MgrMgr:GetMgr("IllustrationMonsterMgr").ResponseUnLockRoleIllutration(msg, arg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.EquipRefineTransfer] = {
        file = "ModuleMgr/RefineTransferMgr",
        func = function(msg, arg, text)
            ---@type ModuleMgr.RefineTransferMgr
            MgrMgr:GetMgr("RefineTransferMgr").OnRefineTransferEquip(msg, arg, text)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.EquipRefineUnblock] = {
        file = "ModuleMgr/RefineTransferMgr",
        func = function(msg, arg, ...)
            ---@type ModuleMgr.RefineTransferMgr
            MgrMgr:GetMgr("RefineTransferMgr").OnUnlockEquip(msg, arg, ...)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.BeginMatchForBattleField] = {
        file = "ModuleMgr/BattleMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.BattleMgr
            MgrMgr:GetMgr("BattleMgr").OnBeginMatchForBattleField(msg, arg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.ChangeTrolley] = {
        file = "ModuleMgr/RefitTrolleyMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.RefitTrolleyMgr
            MgrMgr:GetMgr("RefitTrolleyMgr").OnReqUseTrolley(msg, arg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.MaterialsMechant] = {
        file = "ModuleMgr/MaterialMakeMgr",
        func = function(msg)
            ---@type ModuleMgr.MaterialMakeMgr
            MgrMgr:GetMgr("MaterialMakeMgr").OnReqMakeMaterial(msg)
        end,
        override = true --覆盖C#协议
    },

    [Network.Define.Rpc.MakeDevice] = {
        file = "ModuleMgr/DisplacerMgr",
        func = function(msg)
            ---@type ModuleMgr.DisplacerMgr
            MgrMgr:GetMgr("DisplacerMgr").OnReqDisplacerMake(msg)
        end,
        override = true --覆盖C#协议
    },

    [Network.Define.Rpc.UseDevice] = {
        file = "ModuleMgr/DisplacerMgr",
        func = function(msg)
            ---@type ModuleMgr.DisplacerMgr
            MgrMgr:GetMgr("DisplacerMgr").OnReqUseDisplacer(msg)
        end,
        override = true --覆盖C#协议
    },

    [Network.Define.Rpc.ExtractCard] = {
        file = "ModuleMgr/MagicExtractMachineMgr",
        func = function(msg)
            ---@type ModuleMgr.MagicExtractMachineMgr
            MgrMgr:GetMgr("MagicExtractMachineMgr").RspExtractItem(msg)
        end,
        override = true --覆盖C#协议
    },

    [Network.Define.Rpc.RecoveCard] = {
        file = "ModuleMgr/MagicRecoveMachineMgr",
        func = function(msg)
            ---@type ModuleMgr.MagicRecoveMachineMgr
            MgrMgr:GetMgr("MagicRecoveMachineMgr").RspRecoveItem(msg)
        end,
        override = true --覆盖C#协议
    },

    [Network.Define.Rpc.RecycleCardPreview] = {
        file = "ModuleMgr/MagicExtractMachineMgr",
        func = function(msg)
            ---@type ModuleMgr.MagicExtractMachineMgr
            MgrMgr:GetMgr("MagicExtractMachineMgr").RspExtractPreview(msg)
        end,
        override = true --覆盖C#协议
    },

    [Network.Define.Rpc.EquipEnchantRebornPreview] = {
        file = "ModuleMgr/EnchantmentExtractMgr",
        func = function(msg)
            ---@type ModuleMgr.EnchantmentExtractMgr
            MgrMgr:GetMgr("EnchantmentExtractMgr").ReceiveEquipEnchantRebornPreview(msg)
        end,
        override = true --覆盖C#协议
    },

    [Network.Define.Rpc.EquipEnchantInherit] = {
        file = "ModuleMgr/EnchantInheritNetMgr",
        func = function(msg)
            ---@type ModuleMgr.EnchantInheritNetMgr
            MgrMgr:GetMgr("EnchantInheritNetMgr").RecvEnchantInherit(msg)
        end,
        override = true --覆盖C#协议
    },

    [Network.Define.Rpc.EquipEnchantReborn] = {
        file = "ModuleMgr/EnchantmentExtractMgr",
        func = function(msg, _, uid)
            ---@type ModuleMgr.EnchantmentExtractMgr
            MgrMgr:GetMgr("EnchantmentExtractMgr").ReceiveEquipEnchantReborn(msg, uid)
        end,
        override = true --覆盖C#协议
    },

    [Network.Define.Rpc.PreviewOrnament] = {
        file = "ModuleMgr/MagicExtractMachineMgr",
        func = function(msg)
            ---@type ModuleMgr.MagicExtractMachineMgr
            MgrMgr:GetMgr("MagicExtractMachineMgr").RspExtractPreview(msg)
        end,
        override = true --覆盖C#协议
    },

    [Network.Define.Rpc.ExtractOrnament] = {
        file = "ModuleMgr/MagicExtractMachineMgr",
        func = function(msg)
            ---@type ModuleMgr.MagicExtractMachineMgr
            MgrMgr:GetMgr("MagicExtractMachineMgr").RspExtractItem(msg)
        end,
        override = true --覆盖C#协议
    },

    [Network.Define.Rpc.RecoveOrnament] = {
        file = "ModuleMgr/MagicRecoveMachineMgr",
        func = function(msg)
            ---@type ModuleMgr.MagicRecoveMachineMgr
            MgrMgr:GetMgr("MagicRecoveMachineMgr").RspRecoveItem(msg)
        end,
        override = true --覆盖C#协议
    },

    [Network.Define.Rpc.PreviewMagicEquipExtract] = {
        file = "ModuleMgr/MagicExtractMachineMgr",
        func = function(msg)
            ---@type ModuleMgr.MagicExtractMachineMgr
            MgrMgr:GetMgr("MagicExtractMachineMgr").RspExtractPreview(msg)
        end,
        override = true --覆盖C#协议
    },

    [Network.Define.Rpc.ExtractEquip] = {
        file = "ModuleMgr/MagicExtractMachineMgr",
        func = function(msg)
            ---@type ModuleMgr.MagicExtractMachineMgr
            MgrMgr:GetMgr("MagicExtractMachineMgr").RspExtractItem(msg)
        end,
        override = true --覆盖C#协议
    },

    [Network.Define.Rpc.RecoveEquip] = {
        file = "ModuleMgr/MagicRecoveMachineMgr",
        func = function(msg)
            ---@type ModuleMgr.MagicRecoveMachineMgr
            MgrMgr:GetMgr("MagicRecoveMachineMgr").RspRecoveItem(msg)
        end,
        override = true --覆盖C#协议
    },

    [Network.Define.Rpc.MedalOp] = {
        file = "ModuleMgr/MedalMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.MedalMgr
            MgrMgr:GetMgr("MedalMgr").ResponseMedalOperate(msg, arg)
        end,
        override = true --覆盖C#协议
    },

    [Network.Define.Rpc.GetPrestigeAddition] = {
        file = "ModuleMgr/MedalMgr",
        func = function(msg)
            ---@type ModuleMgr.MedalMgr
            MgrMgr:GetMgr("MedalMgr").ResponseMedalPrestigeAddition(msg)
        end,
        override = true --是否覆盖c#协议
    },

    [Network.Define.Rpc.CatTradeActivityGetInfo] = {
        file = "ModuleMgr/CatCaravanMgr",
        func = function(msg)
            ---@type ModuleMgr.CatCaravanMgr
            MgrMgr:GetMgr("CatCaravanMgr").OnCatTradeActivityGetInfo(msg)
        end,
        override = true --覆盖C#协议
    },

    [Network.Define.Rpc.CatTradeActivitySellGoods] = {
        file = "ModuleMgr/CatCaravanMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.CatCaravanMgr
            MgrMgr:GetMgr("CatCaravanMgr").OnCatTradeActivitySellGoods(msg, arg)
        end,
        override = true --覆盖C#协议
    },

    [Network.Define.Rpc.CatTradeActivityGetReward] = {
        file = "ModuleMgr/CatCaravanMgr",
        func = function(msg)
            ---@type ModuleMgr.CatCaravanMgr
            MgrMgr:GetMgr("CatCaravanMgr").OnCatTradeActivityGetReward(msg)
        end,
        override = true --覆盖C#协议
    },

    [Network.Define.Rpc.GetTutorialMark] = {
        file = "ModuleMgr/BeginnerGuideMgr",
        func = function(msg)
            ---@type ModuleMgr.BeginnerGuideMgr
            MgrMgr:GetMgr("BeginnerGuideMgr").OnReqBeginnerGuideState(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.UpdateTutorialMark] = {
        file = "ModuleMgr/BeginnerGuideMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.BeginnerGuideMgr
            MgrMgr:GetMgr("BeginnerGuideMgr").OnReqFinishOneGuide(msg, arg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GetPostcardDisplay] = {
        file = "ModuleMgr/AdventureDiaryMgr",
        func = function(msg)
            ModuleMgr.AdventureDiaryMgr.OnReqMissionAwardGetRecord(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.UpdatePostcardDisplay] = {
        file = "ModuleMgr/AdventureDiaryMgr",
        func = function(msg, arg)
            ModuleMgr.AdventureDiaryMgr.OnReqGetMissionAward(msg, arg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GetPostcardOneChapterAward] = {
        file = "ModuleMgr/AdventureDiaryMgr",
        func = function(msg, arg)
            ModuleMgr.AdventureDiaryMgr.OnReqGetSectionAward(msg, arg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.UpdatePostcardChapterAward] = {
        file = "ModuleMgr/AdventureDiaryMgr",
        func = function(msg)
            ModuleMgr.AdventureDiaryMgr.OnReqGetChapterAward(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.PayNotify] = {
        func = function(msg, arg)
            game:GetPayMgr():OnPaySuccessNotify(msg, arg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.CreateChatRoom] = {
        file = "ModuleMgr/ChatRoomMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.ChatRoomMgr
            MgrMgr:GetMgr("ChatRoomMgr").OnCreateChatRoom(msg, arg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.ChangeRoomSetting] = {
        file = "ModuleMgr/ChatRoomMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.ChatRoomMgr
            MgrMgr:GetMgr("ChatRoomMgr").OnChangeRoomSetting(msg, arg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.KickRoomMember] = {
        file = "ModuleMgr/ChatRoomMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.ChatRoomMgr
            MgrMgr:GetMgr("ChatRoomMgr").OnKickRoomMember(msg, arg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.LeaveRoom] = {
        file = "ModuleMgr/ChatRoomMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.ChatRoomMgr
            MgrMgr:GetMgr("ChatRoomMgr").OnLeaveRoom(msg, arg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.DissolveRoom] = {
        file = "ModuleMgr/ChatRoomMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.ChatRoomMgr
            MgrMgr:GetMgr("ChatRoomMgr").OnDissolveRoom(msg, arg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.ApplyJoinRoom] = {
        file = "ModuleMgr/ChatRoomMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.ChatRoomMgr
            MgrMgr:GetMgr("ChatRoomMgr").OnApplyJoinRoom(msg, arg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.RoomChangeCaptain] = {
        file = "ModuleMgr/ChatRoomMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.ChatRoomMgr
            MgrMgr:GetMgr("ChatRoomMgr").OnRoomChangeCaptain(msg, arg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GetChatRoomInfo] = {
        file = "ModuleMgr/ChatRoomMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.ChatRoomMgr
            MgrMgr:GetMgr("ChatRoomMgr").OnGetChatRoomInfo(msg, arg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.WearHeadPortrait] = {
        file = "ModuleMgr/HeadSelectMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.HeadSelectMgr
            MgrMgr:GetMgr("HeadSelectMgr").OnWearHeadPortraitRsp(msg, arg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.RoomAfk] = {
        file = "ModuleMgr/ChatRoomMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.ChatRoomMgr
            MgrMgr:GetMgr("ChatRoomMgr").OnRoomAfk(msg, arg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.SwitchRole] = {
        file = "ModuleMgr/SelectRoleMgr",
        func = function(msg, arg, customData)
            ModuleMgr.SelectRoleMgr.OnSwitchRoleInGame(msg, arg, customData)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.PayFine] = {
        file = "ModuleMgr/PlayerGameStateMgr",
        func = function(msg, arg, customData)
            ModuleMgr.PlayerGameStateMgr.OnPayFine(msg, arg, customData)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.ThirtySignActivityGetInfo] = {
        file = "ModuleMgr/SignInMgr",
        func = function(msg)
            ModuleMgr.SignInMgr.OnThirtySignActivityGetInfo(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.ThirtySignActivityGetReward] = {
        file = "ModuleMgr/SignInMgr",
        func = function(msg)
            ModuleMgr.SignInMgr.OnThirtySignActivityGetReward(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.DeleteRole] = {
        file = "ModuleMgr/SelectRoleMgr",
        func = function(msg)
            ---@type ModuleMgr.SelectRoleMgr
            MgrMgr:GetMgr("SelectRoleMgr").OnDeleteRole(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.ResumeRole] = {
        file = "ModuleMgr/SelectRoleMgr",
        func = function(msg)
            ---@type ModuleMgr.SelectRoleMgr
            MgrMgr:GetMgr("SelectRoleMgr").OnResumeRole(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GetAccountRoleData] = {
        file = "ModuleMgr/SelectRoleMgr",
        func = function(msg)
            ---@type ModuleMgr.SelectRoleMgr
            MgrMgr:GetMgr("SelectRoleMgr").OnGetAccountRoleData(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.SceneTriggerSummonMonster] = {
        file = "ModuleMgr.DungeonMgr",
        func = function(msg)
            ---@type ModuleMgr.DungeonMgr
            MgrMgr:GetMgr("DungeonMgr").OnGetSceneTriggerRes(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.AttrRaisedChoose] = {
        file = "ModuleMgr.DungeonMgr",
        func = function(msg)
            ---@type ModuleMgr.DungeonMgr
            MgrMgr:GetMgr("DungeonMgr").OnAttrRaisedChooseRes(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.DelegationAward] = {
        file = "ModuleMgr/DelegateModuleMgr",
        func = function(msg)
            ---@type ModuleMgr.DelegateModuleMgr
            MgrMgr:GetMgr("DelegateModuleMgr").OnTakeReward(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.SetArrow] = {
        file = "ModuleMgr/ArrowMgr",
        func = function(msg, sendArg, customData)
            ---@type ModuleMgr.ArrowMgr
            MgrMgr:GetMgr("ArrowMgr").OnSetUpArrow(msg, sendArg, customData)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.UpdateTitleStatus] = {
        file = "ModuleMgr/TitleStickerMgr",
        func = function(msg, sendInfo)
            MgrMgr:GetMgr("TitleStickerMgr").OnUpdateTitleStatus(msg, sendInfo)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.RequestGridState] = {
        file = "ModuleMgr/TitleStickerMgr",
        func = function(msg)
            MgrMgr:GetMgr("TitleStickerMgr").OnRequestGridState(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.RequestChangeSticker] = {
        file = "ModuleMgr/TitleStickerMgr",
        func = function(msg)
            MgrMgr:GetMgr("TitleStickerMgr").OnRequestChangeSticker(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.RequestAllOwnStickers] = {
        file = "ModuleMgr/TitleStickerMgr",
        func = function(msg)
            MgrMgr:GetMgr("TitleStickerMgr").OnRequestAllOwnStickers(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.RequestUnlockGrid] = {
        file = "ModuleMgr/TitleStickerMgr",
        func = function(msg, sendArg)
            MgrMgr:GetMgr("TitleStickerMgr").OnRequestUnlockGrid(msg, sendArg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.SaveStickersInGrid] = {
        file = "ModuleMgr/TitleStickerMgr",
        func = function(msg, sendArg)

        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.ShareStickers] = {
        file = "ModuleMgr/TitleStickerMgr",
        func = function(msg, sendArg)
            MgrMgr:GetMgr("TitleStickerMgr").OnShareSticker(msg, sendArg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.RequestFashionEvaluationInfo] = {
        file = "ModuleMgr/FashionRatingMgr",
        func = function(msg, sendArg)
            ---@type ModuleMgr.FashionRatingMgr
            MgrMgr:GetMgr("FashionRatingMgr").OnFashionEvaluationInfo(msg, sendArg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.RequestFashionEvaluationNpc] = {
        file = "ModuleMgr/FashionRatingMgr",
        func = function(msg, sendArg)
            ---@type ModuleMgr.FashionRatingMgr
            local mgr = MgrMgr:GetMgr("FashionRatingMgr")
            mgr.OnFashionEvaluationNpc(msg, sendArg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.EvaluateFashion] = {
        file = "ModuleMgr/FashionRatingMgr",
        func = function(msg, sendArg)
            ---@type ModuleMgr.FashionRatingMgr
            MgrMgr:GetMgr("FashionRatingMgr").OnEvaluateFashion(msg, sendArg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.RequestFashionMagazine] = {
        file = "ModuleMgr/FashionRatingMgr",
        func = function(msg, sendArg)
            ---@type ModuleMgr.FashionRatingMgr
            MgrMgr:GetMgr("FashionRatingMgr").OnFashionMagazine(msg, sendArg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.FashionHistory] = {
        file = "ModuleMgr/FashionRatingMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.FashionRatingMgr
            local mgr = MgrMgr:GetMgr("FashionRatingMgr")
            mgr.OnFashionHistory(msg, arg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.RequestRoleFashionScore] = {
        file = "ModuleMgr/FashionRatingMgr",
        func = function(msg, _, arg)
            ---@type ModuleMgr.FashionRatingMgr
            MgrMgr:GetMgr("FashionRatingMgr").OnRoleFashionScore(msg, _, arg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.FetchFashionTicket] = {
        file = "ModuleMgr/FashionRatingMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.FashionRatingMgr
            local mgr = MgrMgr:GetMgr("FashionRatingMgr")
            mgr.OnFashionTicket(msg, arg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GetCobblestoneInfo] = {
        file = "ModuleMgr/StoneSculptureMgr",
        func = function(msg, arg, customData)
            ---@type ModuleMgr.StoneSculptureMgr
            MgrMgr:GetMgr("StoneSculptureMgr").OnGetCobblestoneInfo(msg, arg, customData)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.CarveStone] = {
        file = "ModuleMgr/StoneSculptureMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.StoneSculptureMgr
            MgrMgr:GetMgr("StoneSculptureMgr").OnCarveStone(msg, arg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.AskForCarveStone] = {
        file = "ModuleMgr/StoneSculptureMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.StoneSculptureMgr
            MgrMgr:GetMgr("StoneSculptureMgr").OnAskForCarveStone(msg, arg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.AskForPersonalCarveStone] = {
        file = "ModuleMgr/StoneSculptureMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.StoneSculptureMgr
            local mgr = MgrMgr:GetMgr("StoneSculptureMgr")
            mgr.OnAskForPersonalCarveStone(msg, arg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GetGuildStoneHelper] = {
        file = "ModuleMgr/StoneSculptureMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.StoneSculptureMgr
            local mgr = MgrMgr:GetMgr("StoneSculptureMgr")
            mgr.OnGetGuildStoneHelper(msg, arg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.MakeStone] = {
        file = "ModuleMgr/StoneSculptureMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.StoneSculptureMgr
            MgrMgr:GetMgr("StoneSculptureMgr").OnMakeStone(msg, arg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.MakeSouvenirStone] = {
        file = "ModuleMgr/StoneSculptureMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.StoneSculptureMgr
            local mgr = MgrMgr:GetMgr("StoneSculptureMgr")
            mgr.OnMakeSouvenirStone(msg, arg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.AssignSouvenirCrystal] = {
        file = "ModuleMgr/StoneSculptureMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.StoneSculptureMgr
            local mgr = MgrMgr:GetMgr("StoneSculptureMgr")
            mgr.OnAssignSouvenirCrystal(msg, arg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.CertifyRequest] = {
        func = function(msg)
            game:GetAuthMgr():OnLoginLoginServer(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.QueryGateIPNew] = {
        file = "ModuleMgr/CommonServerInfoMgr",
        func = function(msg, sendArg, customData)
            ---@type ModuleMgr.CommonServerInfoMgr
            MgrMgr:GetMgr("CommonServerInfoMgr").OnQueryGateIPNew(msg, sendArg, customData)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.RunRoulette] = {
        file = "ModuleMgr/MazeDungeonMgr",
        func = function(msg)
            ---@type ModuleMgr.MazeDungeonMgr
            MgrMgr:GetMgr("MazeDungeonMgr").OnRunRoulette(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.SendGuildRedEnvelope] = {
        file = "ModuleMgr/RedEnvelopeMgr",
        func = function(msg)
            ---@type ModuleMgr.RedEnvelopeMgr
            MgrMgr:GetMgr("RedEnvelopeMgr").OnReqSendRedEnvelope(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GetGuildRedEnvelopeInfo] = {
        file = "ModuleMgr/RedEnvelopeMgr",
        func = function(msg)
            ---@type ModuleMgr.RedEnvelopeMgr
            MgrMgr:GetMgr("RedEnvelopeMgr").OnReqCheckRedEnvelopeState(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GrabGuildRedEnvelope] = {
        file = "ModuleMgr/RedEnvelopeMgr",
        func = function(msg)
            ---@type ModuleMgr.RedEnvelopeMgr
            MgrMgr:GetMgr("RedEnvelopeMgr").OnReqGetRedEnvelope(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GetGuildRedEnvelopeResult] = {
        file = "ModuleMgr/RedEnvelopeMgr",
        func = function(msg)
            ---@type ModuleMgr.RedEnvelopeMgr
            MgrMgr:GetMgr("RedEnvelopeMgr").OnReqGetRedEnvelopeResultRecord(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GetGuildOrganizationInfo] = {
        file = "ModuleMgr/GuildMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildMgr
            local mgr = MgrMgr:GetMgr("GuildMgr")
            mgr.OnGetGuildOrganizationInfo(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GetGuildOrganizationRank] = {
        file = "ModuleMgr/GuildMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildMgr
            local mgr = MgrMgr:GetMgr("GuildMgr")
            mgr.OnGetGuildOrganizationRank(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GetGuildOrganizationPersonalAward] = {
        file = "ModuleMgr/GuildMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.GuildMgr
            local mgr = MgrMgr:GetMgr("GuildMgr")
            mgr.OnGetGuildOrganizationPersonalAward(msg, arg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GetThemeDungeonWeeklyAward] = {
        file = "ModuleMgr/ThemeDungeonMgr",
        func = function(msg, sendArg, customData)
            ---@type ModuleMgr.ThemeDungeonMgr
            MgrMgr:GetMgr("ThemeDungeonMgr").OnRequestGetThemeWeekAward(msg, sendArg, customData)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GetThemeDungeonInfo] = {
        file = "ModuleMgr/ThemeDungeonMgr",
        func = function(msg, sendArg, customData)
            ---@type ModuleMgr.ThemeDungeonMgr
            local mgr = MgrMgr:GetMgr("ThemeDungeonMgr")
            mgr.OnGetThemeDungeonInfo(msg, sendArg, customData)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.FinishClientAchievement] = {
        func = function(msg, sendArg, customData)
            ---@type FinishClientAchievementRes
            local l_info = ParseProtoBufToTable("FinishClientAchievementRes", msg)
            if l_info.result ~= 0 then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
            end
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.QueryKapulaSign] = {
        func = function(msg, arg)
            ---@type ModuleMgr.FriendMgr
            MgrMgr:GetMgr("FriendMgr").OnQueryKapulaSign(msg, arg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.ReadKapulaAssis] = {
        func = function(msg, arg)
            ---@type ModuleMgr.FriendMgr
            MgrMgr:GetMgr("FriendMgr").OnReadKapulaAssis(msg, arg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.PreCheckOperateLegal] = {
        func = function(msg, arg)
            ---@type ModuleMgr.SyncTakePhotoStatusMgr
            MgrMgr:GetMgr("SyncTakePhotoStatusMgr").OnPreCheckOperateLegalRes(msg, arg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.AcceptGameAgreement] = {
        file = "ModuleMgr/UseAgreementProtoMgr",
        func = function(msg)
            ---@type ModuleMgr.UseAgreementProtoMgr
            MgrMgr:GetMgr("UseAgreementProtoMgr").RspAcceptGameAgreement(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.RoleActivityStatusNtf] = {
        func = function(msg, arg)
            ---@type ModuleMgr.TimeLimitPayMgr
            MgrMgr:GetMgr("TimeLimitPayMgr").OnRoleActivityStatusNtf(msg, arg)
        end,
        override = true --覆盖C#协议
    },

    [Network.Define.Rpc.MerchantGetShopInfo] = {
        file = "ModuleMgr/MerchantMgr",
        func = function(msg, sendArg)
            ---@type ModuleMgr.MerchantMgr
            MgrMgr:GetMgr("MerchantMgr").OnMerchantGetShopInfo(msg, sendArg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.MerchantShopBuy] = {
        file = "ModuleMgr/MerchantMgr",
        func = function(msg, sendArg)
            ---@type ModuleMgr.MerchantMgr
            MgrMgr:GetMgr("MerchantMgr").OnMerchantShopBuy(msg, sendArg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.MerchantShopSell] = {
        file = "ModuleMgr/MerchantMgr",
        func = function(msg, sendArg)
            ---@type ModuleMgr.MerchantMgr
            MgrMgr:GetMgr("MerchantMgr").OnMerchantShopSell(msg, sendArg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.MerchantTaskComplete] = {
        file = "ModuleMgr/MerchantMgr",
        func = function(msg, sendArg)
            ---@type ModuleMgr.MerchantMgr
            MgrMgr:GetMgr("MerchantMgr").OnMerchantTaskComplete(msg, sendArg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.MerchantGetEventInfo] = {
        file = "ModuleMgr/MerchantMgr",
        func = function(msg, sendArg, ...)
            ---@type ModuleMgr.MerchantMgr
            MgrMgr:GetMgr("MerchantMgr").OnGetEvent(msg, sendArg, ...)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.MerchantEventPreBuy] = {
        file = "ModuleMgr/MerchantMgr",
        func = function(msg, sendArg)
            ---@type ModuleMgr.MerchantMgr
            MgrMgr:GetMgr("MerchantMgr").OnMerchantEventPreBuy(msg, sendArg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.MerchantEventBuy] = {
        file = "ModuleMgr/MerchantMgr",
        func = function(msg, sendArg)
            ---@type ModuleMgr.MerchantMgr
            MgrMgr:GetMgr("MerchantMgr").OnMerchantEventBuy(msg, sendArg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.BarterItem] = {
        file = "ModuleMgr/PropMgr",
        func = function(msg, sendArg)
            ---@type ModuleMgr.PropMgr
            MgrMgr:GetMgr("PropMgr").OnBarterItem(msg, sendArg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GetThemePartyInvitation] = {
        file = "ModuleMgr/ThemePartyMgr",
        func = function(msg, sendArg)
            ---@type ModuleMgr.ThemePartyMgr
            MgrMgr:GetMgr("ThemePartyMgr").OnGetThemePartyInvitation(msg, sendArg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.RequestLotteryDrawInfo] = {
        file = "ModuleMgr/ThemePartyMgr",
        func = function(msg, sendArg)
            ---@type ModuleMgr.ThemePartyMgr
            MgrMgr:GetMgr("ThemePartyMgr").OnRequestLotteryDrawInfo(msg, sendArg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GetThemePartyActivityInfo] = {
        file = "ModuleMgr/ThemePartyMgr",
        func = function(msg, sendArg)
            ---@type ModuleMgr.ThemePartyMgr
            MgrMgr:GetMgr("ThemePartyMgr").OnGetThemePartyActivityInfo(msg, sendArg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.SetLoopDanceGroup] = {
        file = "ModuleMgr/ThemePartyMgr",
        func = function(msg, sendArg)
            ---@type ModuleMgr.ThemePartyMgr
            MgrMgr:GetMgr("ThemePartyMgr").OnSetLoopDanceGroup(msg, sendArg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.ThemePartySendLove] = {
        file = "ModuleMgr/ThemePartyMgr",
        func = function(msg, sendArg)
            ---@type ModuleMgr.ThemePartyMgr
            MgrMgr:GetMgr("ThemePartyMgr").OnThemePartySendLove(msg, sendArg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.ThemePartyGetLoveInfo] = {
        file = "ModuleMgr/ThemePartyMgr",
        func = function(msg, sendArg)
            ---@type ModuleMgr.ThemePartyMgr
            MgrMgr:GetMgr("ThemePartyMgr").OnThemePartyGetLoveInfo(msg, sendArg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.ThemePartyGetNearbyPerson] = {
        file = "ModuleMgr/ThemePartyMgr",
        func = function(msg, sendArg)
            ---@type ModuleMgr.ThemePartyMgr
            MgrMgr:GetMgr("ThemePartyMgr").OnThemePartyGetNearbyPerson(msg, sendArg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.ThemePartyGetPrizeMember] = {
        file = "ModuleMgr/ThemePartyMgr",
        func = function(msg, sendArg, ...)
            ---@type ModuleMgr.ThemePartyMgr
            MgrMgr:GetMgr("ThemePartyMgr").OnThemePartyGetPrizeMember(msg, sendArg, ...)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GetMallInfo] = {
        file = "ModuleMgr/MallMgr",
        func = function(msg, sendArg)
            ---@type ModuleMgr.MallMgr
            MgrMgr:GetMgr("MallMgr").OnGetMallInfo(msg, sendArg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.FreshMallItem] = {
        file = "ModuleMgr/MallMgr",
        func = function(msg, sendArg)
            ---@type ModuleMgr.MallMgr
            MgrMgr:GetMgr("MallMgr").ReceiveFreshMallItem(msg, sendArg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.BuyMallItem] = {
        file = "ModuleMgr/MallMgr",
        func = function(msg, sendArg)
            ---@type ModuleMgr.MallMgr
            MgrMgr:GetMgr("MallMgr").OnBuyMallItem(msg, sendArg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.ManualRefreshMallItem] = {
        file = "ModuleMgr/MallMgr",
        func = function(msg, sendArg)
            ---@type ModuleMgr.MallMgr
            MgrMgr:GetMgr("MallMgr").OnManualRefreshMallItem(msg, sendArg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GetNextLimitedOfferOpenTime] = {
        file = "ModuleMgr/TimeLimitPayMgr",
        func = function(msg, sendArg)
            ---@type ModuleMgr.TimeLimitPayMgr
            MgrMgr:GetMgr("TimeLimitPayMgr").OnGetNextLimitedOfferOpenTime(msg, sendArg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GetMallTimestamp] = {
        file = "ModuleMgr/MallMgr",
        func = function(msg, sendArg)
            ---@type ModuleMgr.MallMgr
            MgrMgr:GetMgr("MallMgr").OnGetMallTimestamp(msg, sendArg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.ReceiveLevelGift] = {
        file = "ModuleMgr/LevelRewardMgr",
        func = function(msg, sendArg)
            ---@type ModuleMgr.LevelRewardMgr
            MgrMgr:GetMgr("LevelRewardMgr").OnReceiveLevelGift(msg, sendArg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.BackstageActRequest] = {
        file = "ModuleMgr/FestivalMgr",
        func = function(msg, sendArg)
            ---@type ModuleMgr.LevelRewardMgr
            MgrMgr:GetMgr("FestivalMgr").ReceiveBackStageActResult(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GetJobAward] = {
        file = "ModuleMgr/SkillLearningMgr",
        func = function(msg, sendArg)
            ---@type ModuleMgr.SkillLearningMgr
            MgrMgr:GetMgr("SkillLearningMgr").OnReceiveJobReward(msg, sendArg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.RequestKillMonsterCount] = {
        file = "ModuleMgr/HeadShopMgr",
        func = function(msg)
            ---@type ModuleMgr.HeadShopMgr
            MgrMgr:GetMgr("HeadShopMgr").OnRequestKillMonsterCount(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.TowerDungeonsAward] = {
        file = "ModuleMgr/InfiniteTowerDungeonMgr",
        func = function(msg)
            ---@type ModuleMgr.InfiniteTowerDungeonMgr
            MgrMgr:GetMgr("InfiniteTowerDungeonMgr").OnTowerDungeonsAward(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GetDungeonsMonster] = {
        file = "ModuleMgr/DungeonMgr",
        func = function(msg)
            ---@type ModuleMgr.DungeonMgr
            MgrMgr:GetMgr("DungeonMgr").OnGetDungeonsMonster(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.SendGuildAid] = {
        file = "ModuleMgr/ChatMgr",
        func = function(msg)
            ---@type ModuleMgr.ChatMgr
            MgrMgr:GetMgr("ChatMgr").OnSendGuildAid(msg, arg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GetSimpleBattleRevenue] = {
        file = "ModuleMgr/BattleStatisticsMgr",
        func = function(msg)
            ---@type ModuleMgr.BattleStatisticsMgr
            MgrMgr:GetMgr("BattleStatisticsMgr").SimpleBattleRevenueResp(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.OpenMultiTalent] = {
        file = "ModuleMgr/MultiTalentMgr",
        func = function(msg, sendArg)
            ---@type ModuleMgr.MultiTalentMgr
            MgrMgr:GetMgr("MultiTalentMgr").OnOpenMultiTalent(msg, sendArg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.ChangeMultiTalent] = {
        file = "ModuleMgr/MultiTalentMgr",
        func = function(msg, sendArg)
            ---@type ModuleMgr.MultiTalentMgr
            MgrMgr:GetMgr("MultiTalentMgr").OnChangeMultiTalent(msg, sendArg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.RenameMultiTalent] = {
        file = "ModuleMgr/MultiTalentMgr",
        func = function(msg, sendArg)
            ---@type ModuleMgr.MultiTalentMgr
            MgrMgr:GetMgr("MultiTalentMgr").OnRenameMultiTalent(msg, sendArg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GetBattleRevenue] = {
        file = "ModuleMgr/BattleStatisticsMgr",
        func = function(msg)
            ---@type ModuleMgr.BattleStatisticsMgr
            MgrMgr:GetMgr("BattleStatisticsMgr").BattleRevenueResp(msg)
        end,
        override = true --覆盖C#协议
    },
    --gm rpc协议
    [Network.Define.Rpc.GSLocalGMCmd] = {
        file = "ModuleMgr/GmMgr",
        func = function(msg, sendArg)
            ---@type ModuleMgr.GmMgr
            MgrMgr:GetMgr("GmMgr").OnGmRpcReceived(msg, sendArg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GetWatchRoomList] = {
        file = "ModuleMgr/WatchWarMgr",
        func = function(msg, args, ...)
            ---@type ModuleMgr.WatchWarMgr
            MgrMgr:GetMgr("WatchWarMgr").OnGetWatchRoomList(msg, args, ...)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.LikeWatchRoom] = {
        file = "ModuleMgr/WatchWarMgr",
        func = function(msg, args)
            ---@type ModuleMgr.WatchWarMgr
            MgrMgr:GetMgr("WatchWarMgr").OnLikeWatchRoom(msg, args)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.SearchWatchRoom] = {
        file = "ModuleMgr/WatchWarMgr",
        func = function(msg, args)
            ---@type ModuleMgr.WatchWarMgr
            MgrMgr:GetMgr("WatchWarMgr").OnSearchWatchRoom(msg, args)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.RequestWatchDungeons] = {
        file = "ModuleMgr/WatchWarMgr",
        func = function(msg, args, customData)
            ---@type ModuleMgr.WatchWarMgr
            MgrMgr:GetMgr("WatchWarMgr").OnRequestWatchDungeons(msg, args, customData)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GetRoleWatchRecord] = {
        file = "ModuleMgr/WatchWarMgr",
        func = function(msg, args)
            ---@type ModuleMgr.WatchWarMgr
            MgrMgr:GetMgr("WatchWarMgr").OnGetRoleWatchRecord(msg, args)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.WatcherSwitchPlayer] = {
        file = "ModuleMgr/WatchWarMgr",
        func = function(msg, args)
            ---@type ModuleMgr.WatchWarMgr
            MgrMgr:GetMgr("WatchWarMgr").OnWatcherSwitchPlayer(msg, args)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.GetWatchRoomInfo] = {
        file = "ModuleMgr/WatchWarMgr",
        func = function(msg, args)
            ---@type ModuleMgr.WatchWarMgr
            MgrMgr:GetMgr("WatchWarMgr").OnGetWatchRoomInfo(msg, args)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.SavePearsonalSetting] = {
        file = "ModuleMgr/SettingMgr",
        func = function(msg, args)
            ---@type ModuleMgr.SettingMgr
            MgrMgr:GetMgr("SettingMgr").OnSavePearsonalSetting(msg, args)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.DirTeleport] = {
        file = nil,
        func = nil,
        override = true --是否覆盖c#协议
    },
    --佣兵相关
    [Network.Define.Rpc.MercenarySkillSlot] = {
        file = "ModuleMgr/MercenaryMgr",
        func = function(msg, sendArg)
            ---@type ModuleMgr.MercenaryMgr
            MgrMgr:GetMgr("MercenaryMgr").OnMercenarySkillSlot(msg, sendArg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.MercenaryEquipUpgrade] = {
        file = "ModuleMgr/MercenaryMgr",
        func = function(msg, sendArg)
            ---@type ModuleMgr.MercenaryMgr
            MgrMgr:GetMgr("MercenaryMgr").OnMercenaryEquipUpgrade(msg, sendArg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.MercenaryTalentRequest] = {
        file = "ModuleMgr/MercenaryMgr",
        func = function(msg, sendArg)
            ---@type ModuleMgr.MercenaryMgr
            MgrMgr:GetMgr("MercenaryMgr").OnMercenaryTalentRequest(msg, sendArg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.MercenaryTakeToFight] = {
        file = "ModuleMgr/MercenaryMgr",
        func = function(msg, sendArg)
            ---@type ModuleMgr.MercenaryMgr
            MgrMgr:GetMgr("MercenaryMgr").OnMercenaryTakeToFight(msg, sendArg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.MercenaryRequestUpgrade] = {
        file = "ModuleMgr/MercenaryMgr",
        func = function(msg, sendArg)
            ---@type ModuleMgr.MercenaryMgr
            MgrMgr:GetMgr("MercenaryMgr").OnMercenaryRequestUpgrade(msg, sendArg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.MercenaryChangeFightStatus] = {
        file = "ModuleMgr/MercenaryMgr",
        func = function(msg, sendArg)
            ---@type ModuleMgr.MercenaryMgr
            local mgr = MgrMgr:GetMgr("MercenaryMgr")
            mgr.OnMercenaryChangeFightStatus(msg, sendArg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Rpc.CheckTowerDefenseCondition] = {
        file = "ModuleMgr/TowerDefenseMgr",
        func = function(msg)
            ---@type ModuleMgr.TowerDefenseMgr
            MgrMgr:GetMgr("TowerDefenseMgr").RspCheckTowerDefenseCondition(msg)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Rpc.TowerDefenseSummon] = {
        file = "ModuleMgr/TowerDefenseMgr",
        func = function(msg, arg, ...)
            ---@type ModuleMgr.TowerDefenseMgr
            MgrMgr:GetMgr("TowerDefenseMgr").RspAdminSpirit(msg, arg, ...)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Rpc.TowerDefenseServant] = {
        file = "ModuleMgr/TowerDefenseMgr",
        func = function(msg, arg, ...)
            ---@type ModuleMgr.TowerDefenseMgr
            MgrMgr:GetMgr("TowerDefenseMgr").RspCommandSpirit(msg, arg, ...)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Rpc.PushInfoSwitchInfo] = {
        file = "ModuleMgr/SettingMgr",
        func = function(msg)
            ---@type ModuleMgr.SettingMgr
            MgrMgr:GetMgr("SettingMgr").RspPushSwitchInfo(msg)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Rpc.PushInfoSwitchModify] = {
        file = "ModuleMgr/SettingMgr",
        func = function(msg)
            ---@type ModuleMgr.SettingMgr
            MgrMgr:GetMgr("SettingMgr").RspPushSwitchInfoModify(msg)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Rpc.RoleDetached] = {
        file = "ModuleMgr/SettingMgr",
        func = function(msg, arg, ...)
            ---@type ModuleMgr.SettingMgr
            MgrMgr:GetMgr("SettingMgr").OnRoleDetached(msg, arg, ...)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Rpc.UpgradeLevel] = {
        file = "ModuleMgr/GmMgr",
        func = function(msg, arg, ...)
            ---@type ModuleMgr.GmMgr
            MgrMgr:GetMgr("GmMgr").OnUpgradeLevel(msg, arg, ...)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Rpc.GetGuildFlowers] = {
        file = "ModuleMgr/GuildMatchMgr",
        func = function(msg, arg, ...)
            ---@type ModuleMgr.GuildMatchMgr
            MgrMgr:GetMgr("GuildMatchMgr").OnGetGuildFlowers(msg, arg, ...)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Rpc.GuildMatchConvene] = {
        file = "ModuleMgr/GuildMatchMgr",
        func = function(msg, arg, ...)
            ---@type ModuleMgr.GuildMatchMgr
            MgrMgr:GetMgr("GuildMatchMgr").OnGuildMatchConvene(msg, arg, ...)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Rpc.GuildBattleTeamApply] = {
        file = "ModuleMgr/GuildMatchMgr",
        func = function(msg, arg, ...)
            ---@type ModuleMgr.GuildMatchMgr
            MgrMgr:GetMgr("GuildMatchMgr").OnGuildBattleTeamApply(msg, arg, ...)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Rpc.EnterGuildMatchWaitingRoomRequest] = {
        file = "ModuleMgr/GuildMatchMgr",
        func = function(msg, arg, ...)
            ---@type ModuleMgr.GuildMatchMgr
            MgrMgr:GetMgr("GuildMatchMgr").OnEnterGuildMatchWaitingRoomRequest(msg, arg, ...)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Rpc.GetGuildBattleMgrTeamInfo] = {
        file = "ModuleMgr/GuildMatchMgr",
        func = function(msg, arg, ...)
            ---@type ModuleMgr.GuildMatchMgr
            MgrMgr:GetMgr("GuildMatchMgr").OnGetGuildBattleMgrTeamInfo(msg, arg, ...)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Rpc.GetGuildBattleTeamInfo] = {
        file = "ModuleMgr/GuildMatchMgr",
        func = function(msg, arg, ...)
            ---@type ModuleMgr.GuildMatchMgr
            MgrMgr:GetMgr("GuildMatchMgr").OnGetGuildBattleTeamInfo(msg, arg, ...)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Rpc.ChangeGuildBattleTeam] = {
        file = "ModuleMgr/GuildMatchMgr",
        func = function(msg, arg, ...)
            ---@type ModuleMgr.GuildMatchMgr
            MgrMgr:GetMgr("GuildMatchMgr").OnChangeGuildBattleTeam(msg, arg, ...)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Rpc.GetGuildBattleWatchInfo] = {
        file = "ModuleMgr/WatchWarMgr",
        func = function(msg, arg, ...)
            MgrMgr:GetMgr("WatchWarMgr").OnGetGuildBattleWatchInfo(msg, arg, ...)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Rpc.GuildBattleTeamReApply] = {
        file = "ModuleMgr/GuildMatchMgr",
        func = function(msg, arg, ...)
            ---@type ModuleMgr.GuildMatchMgr
            MgrMgr:GetMgr("GuildMatchMgr").OnGuildBattleTeamReApply(msg, arg, ...)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Rpc.GetGuildBattleResult] = {
        file = "ModuleMgr/GuildMatchMgr",
        func = function(msg, arg, ...)
            ---@type ModuleMgr.GuildMatchMgr
            MgrMgr:GetMgr("GuildMatchMgr").OnGetGuildBattleResult(msg, arg, ...)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Rpc.GiveGuildFlower] = {
        file = "ModuleMgr/WatchWarMgr",
        func = function(msg, arg, ...)
            MgrMgr:GetMgr("WatchWarMgr").OnGiveGuildFlower(msg, arg, ...)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Rpc.RequestLeaderBoardInfo] = {
        file = "ModuleMgr/RankMgr",
        func = function(msg, arg, ...)
            MgrMgr:GetMgr("RankMgr").OnRequestLeaderBoardInfo(msg, arg, ...)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.IsAllMemberAssist] = {
        file = "ModuleMgr/TeamMgr",
        func = function(msg, arg, ...)
            MgrMgr:GetMgr("TeamMgr").OnIsAllMemberAssist(msg, arg, ...)
        end,
        override = false --是否覆盖c#协议
    },
    -- 一次存储系统
    [Network.Define.Rpc.SetOnceData] = {
        file = "ModuleMgr/OnceSystemMgr",
        func = function(msg, arg, ...)
            MgrMgr:GetMgr("OnceSystemMgr").OnSetOnceData(msg, arg, ...)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Rpc.GetPollyAward] = {
        file = "ModuleMgr/BoliGroupMgr",
        func = function(msg)
            MgrMgr:GetMgr("BoliGroupMgr").OnModifyPollyAward(msg, false)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Rpc.GetPollyAward] = {
        file = "ModuleMgr/BoliGroupMgr",
        func = function(msg)
            MgrMgr:GetMgr("BoliGroupMgr").OnModifyPollyAward(msg, false)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Rpc.SendMagicPaper] = {
        file = "ModuleMgr/MagicLetterMgr",
        func = function(msg, arg, ...)
            MgrMgr:GetMgr("MagicLetterMgr").OnRetSendMagicPaper(msg, arg, ...)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Rpc.GrabMagicPaper] = {
        file = "ModuleMgr/MagicLetterMgr",
        func = function(msg, arg, ...)
            MgrMgr:GetMgr("MagicLetterMgr").OnRetGrabRedEnvelope(msg, arg, ...)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Rpc.QueryMagicPaper] = {
        file = "ModuleMgr/MagicLetterMgr",
        func = function(msg, arg, ...)
            MgrMgr:GetMgr("MagicLetterMgr").OnRetQueryMagicPaper(msg, arg, ...)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Rpc.QueryGrapPaper] = {
        file = "ModuleMgr/MagicLetterMgr",
        func = function(msg, arg, ...)
            MgrMgr:GetMgr("MagicLetterMgr").OnRetMagicLetterDetailInfo(msg, arg, ...)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Rpc.ThanksMagicPaper] = {
        file = "ModuleMgr/MagicLetterMgr",
        func = function(msg, arg, ...)
            MgrMgr:GetMgr("MagicLetterMgr").OnRetThanksMagicPaper(msg, arg, ...)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Rpc.QueryCanBuyMonthCard] = {
        file = "ModuleMgr/MonthCardMgr",
        func = function(msg, arg, ...)
            MgrMgr:GetMgr("MonthCardMgr").OnQueryCanBuyMonthCard(msg, arg, ...)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Rpc.TestBuyMonthCard] = {
        file = "ModuleMgr/MonthCardMgr",
        func = function(msg, arg, ...)
            MgrMgr:GetMgr("MonthCardMgr").OnTestBuyMonthCard(msg, arg, ...)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Rpc.RequestBuyQualifiedPack] = {
        file = "ModuleMgr/MonthCardMgr",
        func = function(msg, arg, ...)
            MgrMgr:GetMgr("MonthCardMgr").OnRequestBuyQualifiedPack(msg, arg, ...)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Rpc.RequestPickFreeGiftPack] = {
        file = "ModuleMgr/MonthCardMgr",
        func = function(msg, arg, ...)
            MgrMgr:GetMgr("MonthCardMgr").OnRequestPickFreeGiftPack(msg, arg, ...)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Rpc.MonthCardExpireConfirm] = {
        file = "ModuleMgr/MonthCardMgr",
        func = function(msg, arg, ...)
            MgrMgr:GetMgr("MonthCardMgr").OnMonthCardExpireConfirm(msg, arg, ...)
        end,
        override = false --是否覆盖c#协议
    },

    [Network.Define.Rpc.GuildRankActivityRpc] = {
        file = "ModuleMgr/GuildRankMgr",
        func = function(msg, arg, ...)
            MgrMgr:GetMgr("GuildRankMgr").OnSelfGuildRankInfoRsp(msg, arg, ...)
        end,
        override = false --是否覆盖c#协议
    },

    [Network.Define.Rpc.GetGuildLeaderBoardByRank] = {
        file = "ModuleMgr/GuildRankMgr",
        func = function(msg, arg, ...)
            MgrMgr:GetMgr("GuildRankMgr").OnRankInfoRsp(msg, arg, ...)
        end,
        override = false --是否覆盖c#协议
    },

    [Network.Define.Rpc.QueryRoleSmallPhotoRpc] = {
        file = "ModuleMgr/CommonIconNetMgr",
        func = function(msg, arg, ...)
            MgrMgr:GetMgr("CommonIconNetMgr").OnRsp(msg, arg, ...)
        end,
        override = false --是否覆盖c#协议
    },

    [Network.Define.Rpc.ClientGetRoleLeaderBoardRank] = {
        file = "ModuleMgr/CommonGroupDataNetMgr",
        func = function(msg, arg, ...)
            MgrMgr:GetMgr("CommonGroupDataNetMgr").OnGroupDataRsp(msg, arg, ...)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Rpc.SetWorldEventSign] = {
        file = "ModuleMgr/WorldPveMgr",
        func = function(msg)
            ---@type ModuleMgr.WorldPveMgr
            local mgr = MgrMgr:GetMgr("WorldPveMgr")
            mgr.OnResponseEventSgin(msg)
        end,
        override = true --是否覆盖c#协议
    },
    -- 黑市
    [Network.Define.Rpc.GetBlackMarketItemPrice] = {
        file = "ModuleMgr/AuctionMgr",
        func = function(msg)
            MgrMgr:GetMgr("AuctionMgr").OnGetBlackMarketItemPrice(msg)
        end,
        override = false --是否覆盖c#协议
    },
    -- 拍卖
    [Network.Define.Rpc.GetAuctionInfo] = {
        file = "ModuleMgr/AuctionMgr",
        func = function(msg)
            MgrMgr:GetMgr("AuctionMgr").OnGetAuctionInfo(msg)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Rpc.AuctionFollowItem] = {
        file = "ModuleMgr/AuctionMgr",
        func = function(msg, sendArg)
            MgrMgr:GetMgr("AuctionMgr").OnAuctionFollowItem(msg, sendArg)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Rpc.AuctionItemBib] = {
        file = "ModuleMgr/AuctionMgr",
        func = function(msg)
            MgrMgr:GetMgr("AuctionMgr").OnAuctionItemBib(msg)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Rpc.AuctionBillCancel] = {
        file = "ModuleMgr/AuctionMgr",
        func = function(msg)
            MgrMgr:GetMgr("AuctionMgr").OnAuctionBillCancel(msg)
        end,
        override = false --是否覆盖c#协议
    },
    -- 卡片解封
    [Network.Define.Rpc.EquipCardUnSeal] = {
        file = "ModuleMgr/SealCardMgr",
        func = function(msg, arg, customData)
            ---@type ModuleMgr.SealCardMgr
            MgrMgr:GetMgr("SealCardMgr").OnEquipCardUnSeal(msg, arg, customData)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.EquipReform] = {
        file = "ModuleMgr/EquipReformMgr",
        func = function(msg)
            MgrMgr:GetMgr("EquipReformMgr").OnEquipReformConfirmed(msg)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Rpc.GetMonsterAward] = {
        file = "ModuleMgr/IllustrationMonsterMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.IllustrationMonsterMgr
            local mgr = MgrMgr:GetMgr("IllustrationMonsterMgr")
            mgr.OnGetMonsterAward(msg, arg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.SetClientCommonDataRpc] = {
        file = "ModuleMgr/CommonDataMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.CommonDataMgr
            local mgr = MgrMgr:GetMgr("CommonDataMgr")
            mgr.OnSetClientCommonDataRpc(msg, arg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.SurveyTreasure] = {
        file = "ModuleMgr/TreasureHunterMgr",
        func = function(msg)
            ---@type ModuleMgr.TreasureHunterMgr
            local mgr = MgrMgr:GetMgr("TreasureHunterMgr")
            mgr.OnSurveyTreasure(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.GetTreasurePanelInfo] = {
        file = "ModuleMgr/TreasureHunterMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.TreasureHunterMgr
            local mgr = MgrMgr:GetMgr("TreasureHunterMgr")
            mgr.OnGetTreasurePanelInfo(msg, arg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.HelpTreasure] = {
        file = "ModuleMgr/TreasureHunterMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.TreasureHunterMgr
            local mgr = MgrMgr:GetMgr("TreasureHunterMgr")
            mgr.OnHelpTreasure(msg, arg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.ChangeSceneLine] = {
        file = "ModuleMgr/SettingMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.SettingMgr
            local mgr = MgrMgr:GetMgr("SettingMgr")
            mgr.OnChangeLineRes(msg, arg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.GetStaticSceneLine] = {
        file = "ModuleMgr/SettingMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.SettingMgr
            local sMgr = MgrMgr:GetMgr("SettingMgr")
            sMgr.OnSceneLinesDataReceived(msg, arg)
        end,
        override = false
    },
    [Network.Define.Rpc.StartTreasureHunter] = {
        file = "ModuleMgr/TreasureHunterMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.TreasureHunterMgr
            local mgr = MgrMgr:GetMgr("TreasureHunterMgr")
            mgr.OnStartTreasureHunter(msg, arg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.RecallOperate] = {
        file = "ModuleMgr/BackCityMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.BackCityMgr
            local mgr = MgrMgr:GetMgr("BackCityMgr")
            mgr.OnRecallOperate(msg, arg)
            end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.GetCommonAward] = {
        file = "ModuleMgr/GiftPackageMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.GiftPackageMgr
            local mgr = MgrMgr:GetMgr("GiftPackageMgr")
            mgr.OnGetCommonAward(msg, arg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.GetTimeGiftInfo] = {
        file = "ModuleMgr/GiftPackageMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.GiftPackageMgr
            local mgr = MgrMgr:GetMgr("GiftPackageMgr")
            mgr.OnGetTimeGiftInfo(msg, arg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.BuyRebateCard] = {
        file = "ModuleMgr/RebateMonthCardMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.RebateMonthCardMgr
            local mgr = MgrMgr:GetMgr("RebateMonthCardMgr")
            mgr.OnBuyRebateCard(msg, arg)
            end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.GetTeamMatchStatus] = {
        file = "ModuleMgr/TeamMgr",
        func = function(msg, arg)
            ---@type ModuleMgr.TeamMgr
            local mgr = MgrMgr:GetMgr("TeamMgr")
            mgr.OnGetTeamMatchStatus(msg, arg)
        end,
        override = true --是否覆盖c#协议
    },
    -- 活动新王的号角
    [Network.Define.Rpc.ActivityNewKingGetReward] = {
        file = "ModuleMgr/ActivityNewKingMgr",
        func = function(msg, sendArg)
            ---@type ModuleMgr.ActivityNewKingMgr
            local mgr = MgrMgr:GetMgr("ActivityNewKingMgr")
            mgr.OnGetReward(msg, sendArg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.ActivityGetData] = {
        file = "ModuleMgr/FestivalMgr",
        func = function(msg, sendArg)
            ---@type ModuleMgr.FestivalMgr
            local mgr = MgrMgr:GetMgr("FestivalMgr")
            mgr.OnGetActData(msg, sendArg)
        end,
        override = true --是否覆盖c#协议
    },
    -- Bingo活动
    [Network.Define.Rpc.QueryBingoGuess] = {
        file = "ModuleMgr/BingoMgr",
        func = function(msg, sendArg)
            ---@type ModuleMgr.BingoMgr
            local mgr = MgrMgr:GetMgr("BingoMgr")
            mgr.OnQueryBingoGuess(msg, sendArg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.QueryBingoLight] = {
        file = "ModuleMgr/BingoMgr",
        func = function(msg, sendArg)
            ---@type ModuleMgr.BingoMgr
            local mgr = MgrMgr:GetMgr("BingoMgr")
            mgr.OnQueryBingoLight(msg, sendArg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.QueryBingoZone] = {
        file = "ModuleMgr/BingoMgr",
        func = function(msg, sendArg)
            ---@type ModuleMgr.BingoMgr
            local mgr = MgrMgr:GetMgr("BingoMgr")
            mgr.OnQueryBingoZone(msg, sendArg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Rpc.GetBingoAward] = {
        file = "ModuleMgr/BingoMgr",
        func = function(msg, sendArg)
            ---@type ModuleMgr.BingoMgr
            local mgr = MgrMgr:GetMgr("BingoMgr")
            mgr.OnGetBingoAward(msg, sendArg)
        end,
        override = true --是否覆盖c#协议
    },
}

--ptc lua协议的注册
local l_ptcHandlers = {
    -- @tm todo 收到此协议后再登录比较慢，需要服务器确认此协议的用途
    -- [Network.Define.Ptc.LoginChallenge] = {
    --     func = function(msg)
    --         game:GetAuthMgr():LoginGateServer()
    --     end,
    --     override = true
    -- },

    [Network.Define.Ptc.BattleFieldPVPCounterNtf] = {
        func = function(msg)
            MgrMgr:GetMgr("BattleMgr").OnBattleDataSync(msg)
        end,
        override = false --是否覆盖c#协议
    },

    [Network.Define.Ptc.UpdateChatTag] = {
        func = function(msg)
            MgrMgr:GetMgr("ChatTagMgr").OnTagUpdate(msg)
        end,
        override = false --是否覆盖c#协议
    },

    [Network.Define.Ptc.ReconnectSyncNotify] = {
        func = function(msg)
            Network.Handler.OnReconnected(msg)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Ptc.SelectRoleNtf] = {
        file = "ModuleMgr/SelectRoleMgr",
        func = function(msg)
            ---@type ModuleMgr.SelectRoleMgr
            MgrMgr:GetMgr("SelectRoleMgr").OnSelectRoleNtf(msg)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Ptc.PushAdData2Client] = {
        file = "ModuleMgr/AdMgr",
        func = function(msg)
            ---@type ModuleMgr.SelectRoleMgr
            MgrMgr:GetMgr("AdMgr").PushAdData(msg)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Ptc.GuildMatchActivityNtf] = {
        file = "ModuleMgr/GuildMatchMgr",
        func = function(msg, arg, ...)
            ---@type ModuleMgr.GuildMatchMgr
            local mgr = MgrMgr:GetMgr("GuildMatchMgr")
            mgr.OnGuildMatchActivityNtf(msg)
        end,
        override = true --是否覆盖c#协议
    },
    --- 更新和同步道具协议
    [Network.Define.Ptc.UpdateItemNtf] = {
        file = "ModuleMgr/ItemContainerMgr",
        func = function(msg)
            ---@type ModuleMgr.ItemContainerMgr
            local mgr = MgrMgr:GetMgr("ItemContainerMgr")
            mgr.OnUpdateItemNtf(msg)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Ptc.RoleNameChangeNotify] = {
        file = "ModuleMgr/SelectRoleMgr",
        func = function(msg)
            ---@type ModuleMgr.SelectRoleMgr
            MgrMgr:GetMgr("SelectRoleMgr").OnSomeOneNameModified(msg)
        end,
        override = false --是否覆盖c#协议
    },
    --组队相关
    [Network.Define.Ptc.CreateTeamNtf] = {
        file = "ModuleMgr/TeamMgr",
        func = function(msg)
            ---@type ModuleMgr.TeamMgr
            MgrMgr:GetMgr("TeamMgr").CreateTeamNtf(msg)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Ptc.NewTeamInvatationNtf] = {
        file = "ModuleMgr/TeamMgr",
        func = function(msg)
            ---@type ModuleMgr.TeamMgr
            MgrMgr:GetMgr("TeamMgr").NewTeamInvatationNtf(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.RecommondJoinTeamNtf] = {
        file = "ModuleMgr/TeamMgr",
        func = function(msg)
            ---@type ModuleMgr.TeamMgr
            MgrMgr:GetMgr("TeamMgr").RecommondJoinTeamNtf(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.NewTeamMemberNtf] = {
        file = "ModuleMgr/TeamMgr",
        func = function(msg)
            ---@type ModuleMgr.TeamMgr
            MgrMgr:GetMgr("TeamMgr").NewTeamMemberNtf(msg)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Ptc.LeaveTeamNtf] = {
        file = "ModuleMgr/TeamMgr",
        func = function(msg)
            ---@type ModuleMgr.TeamMgr
            MgrMgr:GetMgr("TeamMgr").LeaveTeamNtf(msg)
        end,
        override = false --是否覆盖c#协议
    }, [Network.Define.Ptc.TeamMercenaryChangeNtf] = {
        file = "ModuleMgr/TeamMgr",
        func = function(msg)
            ---@type ModuleMgr.TeamMgr
            MgrMgr:GetMgr("TeamMgr").TeamMercenaryChangeNtf(msg)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Ptc.AllMemberStatusNtf] = {
        file = "ModuleMgr/TeamMgr",
        func = function(msg)
            ---@type ModuleMgr.TeamMgr
            MgrMgr:GetMgr("TeamMgr").OnAllMemberStatusNtf(msg)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Ptc.TeamApplicationNtf] = {
        file = "ModuleMgr/TeamMgr",
        func = function(msg)
            ---@type ModuleMgr.TeamMgr
            MgrMgr:GetMgr("TeamMgr").OnTeamApplicationNtf(msg)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Ptc.BackstageActNtf] = {
        file = "ModuleMgr/FestivalMgr",
        func = function(msg)
            ---@type ModuleMgr.TeamMgr
            MgrMgr:GetMgr("FestivalMgr").OnBackstageAct(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.CaptainChangeNtf] = {
        file = "ModuleMgr/TeamMgr",
        func = function(msg)
            ---@type ModuleMgr.TeamMgr
            MgrMgr:GetMgr("TeamMgr").OnCaptainChangeNtf(msg)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Ptc.KickTeamMemberNtf] = {
        file = "ModuleMgr/TeamMgr",
        func = function(msg)
            ---@type ModuleMgr.TeamMgr
            MgrMgr:GetMgr("TeamMgr").OnKickTeamMemberNtf(msg)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Ptc.PairOverNtf] = {
        file = "ModuleMgr/TeamMgr",
        func = function(msg)
            ---@type ModuleMgr.TeamMgr
            MgrMgr:GetMgr("TeamMgr").OnPairOverNtf(msg)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Ptc.MemberPosNtf] = {
        file = "ModuleMgr/TeamMgr",
        func = function(msg)
            ---@type ModuleMgr.TeamMgr
            MgrMgr:GetMgr("TeamMgr").OnMemberPosNtf(msg)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Ptc.AskFollowNtf] = {
        file = "ModuleMgr/TeamMgr",
        func = function(msg)
            ---@type ModuleMgr.TeamMgr
            MgrMgr:GetMgr("TeamMgr").OnAskFollowNtf(msg)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Ptc.BeginFollowNtf] = {
        file = "ModuleMgr/TeamMgr",
        func = function(msg)
            ---@type ModuleMgr.TeamMgr
            MgrMgr:GetMgr("TeamMgr").OnBeginFollowNtf(msg)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Ptc.TeamSettingNtf] = {
        file = "ModuleMgr/TeamMgr",
        func = function(msg)
            ---@type ModuleMgr.TeamMgr
            MgrMgr:GetMgr("TeamMgr").OnTeamSettingNtf(msg)
        end,
        override = false --是否覆盖c#协议
    },

    [Network.Define.Ptc.SetSpecialSupplyDicePtc] = {
        file = "ModuleMgr/ActivityCheckInMgr",
        func = function(msg)
            MgrMgr:GetMgr("ActivityCheckInMgr").OnPtcSetSpecialSupplyDice(msg)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Ptc.SpecialSupplyRandomDiceNtf] = {
        file = "ModuleMgr/ActivityCheckInMgr",
        func = function(msg)
            MgrMgr:GetMgr("ActivityCheckInMgr").OnPtcRandomDiceValue(msg)
        end,
        override = false --是否覆盖c#协议
    },

    [Network.Define.Ptc.TowerDefenseWaveBegin] = {
        file = "ModuleMgr/TowerDefenseMgr",
        func = function(msg)
            ---@type ModuleMgr.TowerDefenseMgr
            MgrMgr:GetMgr("TowerDefenseMgr").ReceiveTowerDefenseWaveBegin(msg)
        end,
        override = false --是否覆盖c#协议
    },

    [Network.Define.Ptc.TowerDefenseEndlessStartNtf] = {
        file = "ModuleMgr/TowerDefenseMgr",
        func = function(msg)
            ---@type ModuleMgr.TowerDefenseMgr
            local mgr = MgrMgr:GetMgr("TowerDefenseMgr")
            mgr.ReceiveTowerDefenseEndlessStartNtf(msg)
        end,
        override = false --是否覆盖c#协议
    },

    [Network.Define.Ptc.TowerDefenseMagicPowerNtf] = {
        file = "ModuleMgr/TowerDefenseMgr",
        func = function(msg)
            ---@type ModuleMgr.TowerDefenseMgr
            MgrMgr:GetMgr("TowerDefenseMgr").ReceiveTowerDefenseMagicPowerNtf(msg)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Ptc.TowerDefenseSyncMonster] = {
        file = "ModuleMgr/TowerDefenseMgr",
        func = function(msg)
            ---@type ModuleMgr.TowerDefenseMgr
            MgrMgr:GetMgr("TowerDefenseMgr").ReceiveTowerDefenseSyncMonster(msg)
        end,
        override = false --是否覆盖c#协议
    },

    [Network.Define.Ptc.StopFollowMS] = {
        file = "ModuleMgr/TeamMgr",
        func = function(msg)
            ---@type ModuleMgr.TeamMgr
            MgrMgr:GetMgr("TeamMgr").OnStopFollowMS(msg)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Ptc.TeamShoutNtf] = {
        file = "ModuleMgr/TeamMgr",
        func = function(msg)
            ---@type ModuleMgr.TeamMgr
            MgrMgr:GetMgr("TeamMgr").OnTeamShoutNtf(msg)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Ptc.TeamMemberStatusNtf] = {
        file = "ModuleMgr/TeamMgr",
        func = function(msg)
            ---@type ModuleMgr.TeamMgr
            MgrMgr:GetMgr("TeamMgr").OnTeamMemberStatusNtf(msg)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Ptc.ApplyCaptainNtf] = {
        file = "ModuleMgr/TeamMgr",
        func = function(msg)
            ---@type ModuleMgr.TeamMgr
            MgrMgr:GetMgr("TeamMgr").OnApplyCaptainNtf(msg)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Ptc.RefuseCaptainApplyNtf] = {
        file = "ModuleMgr/TeamMgr",
        func = function(msg)
            ---@type ModuleMgr.TeamMgr
            MgrMgr:GetMgr("TeamMgr").OnRefuseCaptainApplyNtf(msg)
        end,
        override = false --是否覆盖c#协议
    },
    --
    [Network.Define.Ptc.AttrUpdateNotify] = {
        file = "ModuleMgr/RoleInfoMgr",
        func = function(msg)
            ---@type ModuleMgr.RoleInfoMgr
            MgrMgr:GetMgr("RoleInfoMgr").OnAttrChange(msg)
        end,
        override = false --是否覆盖c#协议
    },
    --道具相关
    [Network.Define.Ptc.JobLevelChangeNtf] = {
        file = "ModuleMgr/PropMgr",
        func = function(msg)
            ---@type ModuleMgr.PropMgr
            MgrMgr:GetMgr("PropMgr").OnJobLevelChangeNtf(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.LevelChangeNtf] = {
        file = "ModuleMgr/PropMgr",
        func = function(msg)
            ---@type ModuleMgr.PropMgr
            MgrMgr:GetMgr("PropMgr").OnLevelChangeNtf(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.ItemChangeNtf] = {
        file = "ModuleMgr/PropMgr",
        func = function(msg)
            ---@type ModuleMgr.PropMgr
            MgrMgr:GetMgr("PropMgr").OnItemChangeNtf(msg)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Ptc.ItemAwardNtf] = {
        file = "ModuleMgr/NoticeMgr",
        func = function(msg)
            ---@type ModuleMgr.NoticeMgr
            MgrMgr:GetMgr("NoticeMgr").OnItemAwardNtf(msg)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Ptc.BagFullSendMailNtf] = {
        file = "ModuleMgr/PropMgr",
        func = function(msg)
            ---@type ModuleMgr.PropMgr
            MgrMgr:GetMgr("PropMgr").OnBagFullSendMailNtf(msg)
        end,
        override = true --是否覆盖c#协议
    },

    --任务相关
    [Network.Define.Ptc.TaskUpdate] = {
        file = "ModuleMgr/TaskMgr",
        func = function(msg)
            ---@type ModuleMgr.TaskMgr
            MgrMgr:GetMgr("TaskMgr").OnTaskUpdate(msg)
        end,
        override = true
    },
    [Network.Define.Ptc.TaskDelete] = {
        file = "ModuleMgr/TaskMgr",
        func = function(msg)
            ---@type ModuleMgr.TaskMgr
            MgrMgr:GetMgr("TaskMgr").OnTaskDelete(msg)
        end,
        override = true
    },
    [Network.Define.Ptc.TaskTriggerAllNotify] = {
        file = "ModuleMgr/TaskTriggerMgr",
        func = function(msg)
            ---@type ModuleMgr.TaskTriggerMgr
            MgrMgr:GetMgr("TaskTriggerMgr").OnTaskTriggerEventAllNotify(msg)
        end,
        override = true
    },
    [Network.Define.Ptc.TaskTriggerNotify] = {
        file = "ModuleMgr/TaskTriggerMgr",
        func = function(msg)
            ---@type ModuleMgr.TaskTriggerMgr
            MgrMgr:GetMgr("TaskTriggerMgr").OnTaskTriggerNotify(msg)
        end,
        override = true
    },
    [Network.Define.Ptc.TaskTriggerDelete] = {
        file = "ModuleMgr/TaskTriggerMgr",
        func = function(msg)
            ---@type ModuleMgr.TaskTriggerMgr
            MgrMgr:GetMgr("TaskTriggerMgr").OnTaskTriggerEventAllNotify(msg, true)
        end,
        override = true
    },
    [Network.Define.Ptc.AcceptTaskFailedNotifyMs] = {
        file = "ModuleMgr/TaskMgr",
        func = function(msg)
            ---@type ModuleMgr.TaskMgr
            MgrMgr:GetMgr("TaskMgr").OnTaskAcceptFailedNotify(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.AcceptTaskFailedNotify] = {
        file = "ModuleMgr/TaskMgr",
        func = function(msg)
            ---@type ModuleMgr.TaskMgr
            MgrMgr:GetMgr("TaskMgr").OnTaskAcceptFailedNotify(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.TaskDanceStatusNtf] = {
        file = "ModuleMgr/TaskMgr",
        func = function(msg)
            MgrMgr:GetMgr("TaskMgr").OnDanceStatusModified(msg)
        end,
        override = true --是否覆盖c#协议
    },
    --任务结束
    --暂时还没用到的协议
    [Network.Define.Ptc.test] = {
        file = "ModuleMgr/TeamMgr",
        func = function(msg)
            ---@type ModuleMgr.TeamMgr
            MgrMgr:GetMgr("TeamMgr").testNtf(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.SyncArenaRoomBriefInfoNtf] = {
        file = "ModuleMgr/PvpArenaMgr",
        func = function(msg)
            ---@type ModuleMgr.PvpArenaMgr
            MgrMgr:GetMgr("PvpArenaMgr").OnSyncArenaRoomBriefInfoNtf(msg)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Ptc.ChatMsgNtf] = {
        file = "ModuleMgr/ChatMgr",
        func = function(msg)
            ---@type ModuleMgr.ChatMgr
            MgrMgr:GetMgr("ChatMgr").OnChatMsgNtf(msg, true)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Ptc.ChattingMsgNtf] = {
        file = "ModuleMgr/ChatMgr",
        func = function(msg)
            ---@type ModuleMgr.ChatMgr
            MgrMgr:GetMgr("ChatMgr").OnChattingMsgNtf(msg, true)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Ptc.ShowBubbleNotify] = {
        file = "ModuleMgr/ChatMgr",
        func = function(msg)
            ---@type ModuleMgr.ChatMgr
            MgrMgr:GetMgr("ChatMgr").OnChatMsgNtf(msg, false)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Ptc.ChatForbidNtfOnLogin] = {
        file = "ModuleMgr/ChatMgr",
        func = function(msg)
            ---@type ModuleMgr.ChatMgr
            MgrMgr:GetMgr("ChatMgr").OnChatForbidNtfOnLogin(msg)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Ptc.ArenaRoomStateNtf] = {
        file = "ModuleMgr/PvpArenaMgr",
        func = function(msg)
            ---@type ModuleMgr.PvpArenaMgr
            MgrMgr:GetMgr("PvpArenaMgr").OnArenaRoomStateNtf(msg)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Ptc.ArenaInviteNtf] = {
        file = "ModuleMgr/PvpArenaMgr",
        func = function(msg)
            ---@type ModuleMgr.PvpArenaMgr
            MgrMgr:GetMgr("PvpArenaMgr").ArenaInviteNtf(msg)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Ptc.TransferProfessionPtc] = {
        file = "ModuleMgr/ProfessionMgr",
        func = function(msg)
            ---@type ModuleMgr.ProfessionMgr
            MgrMgr:GetMgr("ProfessionMgr").OnTransferProfessionPtc(msg)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Ptc.PushAnnouceNtf] = {
        file = "ModuleMgr/NoticeMgr",
        func = function(msg)
            ---@type ModuleMgr.NoticeMgr
            MgrMgr:GetMgr("NoticeMgr").OnPushAnnouceNtf(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.PushHornNtf] = {
        file = "ModuleMgr/NoticeMgr",
        func = function(msg)
            ---@type ModuleMgr.NoticeMgr
            MgrMgr:GetMgr("NoticeMgr").OnPushHornNtf(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.OpenSystemInfoNtf] = {
        file = "ModuleMgr/OpenSystemMgr",
        func = function(msg)
            ---@type ModuleMgr.OpenSystemMgr
            MgrMgr:GetMgr("OpenSystemMgr").OnOpenSystemInfoNtf(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.MSOpenSystemInfoNtf] = {
        file = "ModuleMgr/OpenSystemMgr",
        func = function(msg)
            ---@type ModuleMgr.OpenSystemMgr
            MgrMgr:GetMgr("OpenSystemMgr").OnMSOpenSystemInfoNtf(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.FailEnterFBNtf] = {
        file = "ModuleMgr/DungeonMgr",
        func = function(msg)
            ---@type ModuleMgr.DungeonMgr
            MgrMgr:GetMgr("DungeonMgr").OnFailEnterFBNtf(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.AskMemberEnterFBNtf] = {
        file = "ModuleMgr/DungeonMgr",
        func = function(msg)
            ---@type ModuleMgr.DungeonMgr
            MgrMgr:GetMgr("DungeonMgr").OnAskMemberEnterFBNtf(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.SyncMemberReplyEnterFBNtf] = {
        file = "ModuleMgr/DungeonMgr",
        func = function(msg)
            ---@type ModuleMgr.DungeonMgr
            MgrMgr:GetMgr("DungeonMgr").OnSyncMemberReplyEnterFBNtf(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.DungeonsResult] = {
        file = "ModuleMgr/DungeonMgr",
        func = function(msg)
            ---@type ModuleMgr.DungeonMgr
            MgrMgr:GetMgr("DungeonMgr").OnDungeonsResult(msg)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Ptc.NotifyDungeonsEncourage] = {
        file = "ModuleMgr/DungeonMgr",
        func = function(msg)
            ---@type ModuleMgr.DungeonMgr
            MgrMgr:GetMgr("DungeonMgr").OnNotifyDungeonsEncourage(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.NotifyTowerRefresh] = {
        file = "ModuleMgr/InfiniteTowerDungeonMgr",
        func = function(msg)
            ---@type ModuleMgr.InfiniteTowerDungeonMgr
            MgrMgr:GetMgr("InfiniteTowerDungeonMgr").OnNotifyTowerRefresh(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.UpdateVehicleAttrs] = {
        file = "ModuleMgr/VehicleInfoMgr",
        func = function(msg)
            ---@type ModuleMgr.VehicleInfoMgr
            MgrMgr:GetMgr("VehicleInfoMgr").OnUpdateVehicleAttrs(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.AddTempVehicle] = {
        file = "ModuleMgr/VehicleInfoMgr",
        func = function(msg)
            ---@type ModuleMgr.VehicleInfoMgr
            MgrMgr:GetMgr("VehicleInfoMgr").OnAddTempVehicle(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.UpdateVehicleRecordForGM] = {
        file = "ModuleMgr/VehicleInfoMgr",
        func = function(msg)
            ---@type ModuleMgr.VehicleInfoMgr
            MgrMgr:GetMgr("VehicleInfoMgr").OnUpdateVehicleRecordForGM(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.AskTakeVehicleNotify] = {
        file = "ModuleMgr/VehicleMgr",
        func = function(msg)
            ---@type ModuleMgr.VehicleMgr
            MgrMgr:GetMgr("VehicleMgr").OnAskTakeVehicleNotify(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.EffectShow] = {
        file = "ModuleMgr/TransmissionMgr",
        func = function(msg)
            ---@type ModuleMgr.TransmissionMgr
            MgrMgr:GetMgr("TransmissionMgr").ReceiveEffectShow(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.DungeonsPrompt] = {
        file = "ModuleMgr/DungeonMgr",
        func = function(msg)
            ---@type ModuleMgr.DungeonMgr
            MgrMgr:GetMgr("DungeonMgr").OnDungeonsPrompt(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.BossTimeline] = {
        file = "ModuleMgr/DungeonMgr",
        func = function(msg)
            ---@type ModuleMgr.DungeonMgr
            MgrMgr:GetMgr("DungeonMgr").OnBossTimeline(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.ShowCutSceneNtf] = {
        file = "ModuleMgr/DungeonMgr",
        func = function(msg)
            ---@type ModuleMgr.DungeonMgr
            MgrMgr:GetMgr("DungeonMgr").OnShowCutSceneNtf(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.DungeonsUpdateNotify] = {
        file = "ModuleMgr/DungeonMgr",
        func = function(msg)
            ---@type ModuleMgr.DungeonMgr
            MgrMgr:GetMgr("DungeonMgr").OnUpdateLeftTime(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.TradeInfoUpdateNotify] = {
        file = "ModuleMgr/TradeMgr",
        func = function(msg)
            ---@type ModuleMgr.TradeMgr
            MgrMgr:GetMgr("TradeMgr").OnTradeInfoUpdateNotify(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.TradeItemStockChangeNtf] = {
        file = "ModuleMgr/TradeMgr",
        func = function(msg)
            ---@type ModuleMgr.TradeMgr
            MgrMgr:GetMgr("TradeMgr").OnTradeItemStockChangeNtf(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.CountInfoUpdateNotify] = {
        file = "ModuleMgr/LimitBuyMgr",
        func = function(msg)
            ---@type ModuleMgr.LimitBuyMgr
            MgrMgr:GetMgr("LimitBuyMgr").OnCountInfoUpdateNotify(msg)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Ptc.GuildEnterNotify] = {
        file = "ModuleMgr/GuildMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildMgr
            MgrMgr:GetMgr("GuildMgr").OnGuildEnterNotify(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.GuildTodayMoney] = {
        file = "ModuleMgr/GuildMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildMgr
            MgrMgr:GetMgr("GuildMgr").OnGuildTodayMoneyUpdated(msg)
        end,
        override = true --没有对应C#协议
    },
    [Network.Define.Ptc.GuildKickOutNotify] = {
        file = "ModuleMgr/GuildMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildMgr
            MgrMgr:GetMgr("GuildMgr").OnGuildKickOutNotify(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.GuildInviteNotify] = {
        file = "ModuleMgr/GuildMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildMgr
            MgrMgr:GetMgr("GuildMgr").OnGetGuildInvite(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.GuildRoleInfoSyncNotifyToClient] = {
        file = "ModuleMgr/GuildMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildMgr
            MgrMgr:GetMgr("GuildMgr").OnSelfGuildMsgChangeNotify(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.GuildRoleInfoSyncNotifyToNeighbor] = {
        file = "ModuleMgr/GuildMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildMgr
            MgrMgr:GetMgr("GuildMgr").OnOtherGuildMsgChangeNotify(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.GuildUpgradeNotify] = {
        file = "ModuleMgr/GuildBuildMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildBuildMgr
            MgrMgr:GetMgr("GuildBuildMgr").OnGuildBuildUpgradeCompletedNotify(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.GuildCrystalUpdateNotfiy] = {
        file = "ModuleMgr/GuildCrystalMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildCrystalMgr
            MgrMgr:GetMgr("GuildCrystalMgr").OnGuildCrystalUpgradeNotify(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.GuildHuntOpenNotify] = {
        file = "ModuleMgr/GuildHuntMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildHuntMgr
            MgrMgr:GetMgr("GuildHuntMgr").OnGuildHuntOpenNotify(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.GuildHuntFinishNtf] = {
        file = "ModuleMgr/GuildHuntMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildHuntMgr
            MgrMgr:GetMgr("GuildHuntMgr").OnGuildHuntReward(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.NtfGuildHuntReward] = {
        file = "ModuleMgr/GuildHuntMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildHuntMgr
            MgrMgr:GetMgr("GuildHuntMgr").OnGuildHuntResult(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.GuildHuntSealPieceCount] = {
        file = "ModuleMgr/GuildHuntMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildHuntMgr
            MgrMgr:GetMgr("GuildHuntMgr").OnGuildHuntSealPieceCount(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.GuildHuntDungeonUpdateNotify] = {
        file = "ModuleMgr/GuildHuntMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildHuntMgr
            MgrMgr:GetMgr("GuildHuntMgr").OnGuildHuntDungeonUpdateNotify(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.GuildAuctionPersonalRecord] = {
        file = "ModuleMgr/GuildDepositoryMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildDepositoryMgr
            MgrMgr:GetMgr("GuildDepositoryMgr").OnGuildEnterNotify(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.GuildDinnerShareDishToClient] = {
        file = "ModuleMgr/GuildDinnerMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildDinnerMgr
            MgrMgr:GetMgr("GuildDinnerMgr").OnGuildDinnerShareDishNtf(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.GuildDinnerCreamMeleeStart] = {
        file = "ModuleMgr/GuildDinnerMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildDinnerMgr
            MgrMgr:GetMgr("GuildDinnerMgr").OnGuildDinnerCreamMeleeStart(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.GuildDinnerCreamMeleeMemberChange] = {
        file = "ModuleMgr/GuildDinnerMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildDinnerMgr
            MgrMgr:GetMgr("GuildDinnerMgr").OnGuildDinnerCreamMeleeMemberChange(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.GuildDinnerCreamMeleeEnd] = {
        file = "ModuleMgr/GuildDinnerMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildDinnerMgr
            MgrMgr:GetMgr("GuildDinnerMgr").OnGuildDinnerCreamMeleeEnd(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.ReturnTaskReset] = {
        file = "ModuleMgr/ReBackMgr",
        func = function(msg)
            ---@type ModuleMgr.ReBackMgr
            MgrMgr:GetMgr("ReBackMgr").OnReturnTaskReset(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.ReturnPrizeWelcomeNtf] = {
        file = "ModuleMgr/ReBackMgr",
        func = function(msg)
            ---@type ModuleMgr.ReBackMgr
            MgrMgr:GetMgr("ReBackMgr").OnReturnStatusNtf(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.ReturnTaskUpdate] = {
        file = "ModuleMgr/ReBackMgr",
        func = function(msg)
            ---@type ModuleMgr.ReBackMgr
            MgrMgr:GetMgr("ReBackMgr").OnReturnTaskUpdate(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.ReturnPrizeLoginAwardUpdate] = {
        file = "ModuleMgr/ReBackLoginMgr",
        func = function(msg)
            MgrMgr:GetMgr("ReBackLoginMgr").ReceiveReturnPrizeLoginAwardUpdate(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.ArenaSyncScoreNtf] = {
        file = "ModuleMgr/ArenaMgr",
        func = function(msg)
            MgrMgr:GetMgr("ArenaMgr").ReceiveArenaSyncScoreNtf(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.GuildDinnerPetrifactionNtf] = {
        file = "ModuleMgr/GuildDinnerMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildDinnerMgr
            MgrMgr:GetMgr("GuildDinnerMgr").OnGuildDinnerPetrifactionNtf(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.GuildDinnerPetrifactionEndNtf] = {
        file = "ModuleMgr/GuildDinnerMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildDinnerMgr
            MgrMgr:GetMgr("GuildDinnerMgr").OnGuildDinnerPetrifactionEndNtf(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.GuildDinnerOpenChampagneNtf] = {
        file = "ModuleMgr/GuildDinnerMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildDinnerMgr
            MgrMgr:GetMgr("GuildDinnerMgr").OnGuildDinnerOpenChampagneNtf(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.GuildDinnerRandomEventNtf] = {
        file = "ModuleMgr/GuildDinnerMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildDinnerMgr
            MgrMgr:GetMgr("GuildDinnerMgr").OnGuildDinnerRandomEventNtf(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.GuildOrganizePersonAwardNtf] = {
        file = "ModuleMgr/GuildDinnerMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildDinnerMgr
            MgrMgr:GetMgr("GuildMgr").OnGuildOrganizePersonAwardNtf(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.PrivateChatNtf] = {
        file = "ModuleMgr/FriendMgr",
        func = function(msg)
            ---@type ModuleMgr.FriendMgr
            MgrMgr:GetMgr("FriendMgr").ReceivePrivateChatNtf(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.UnReadMessageCountNtf] = {
        file = "ModuleMgr/FriendMgr",
        func = function(msg)
            ---@type ModuleMgr.FriendMgr
            MgrMgr:GetMgr("FriendMgr").ReceiveUnReadMessageCountNtf(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.UpdateOrAddFriendNtf] = {
        file = "ModuleMgr/FriendMgr",
        func = function(msg)
            ---@type ModuleMgr.FriendMgr
            MgrMgr:GetMgr("FriendMgr").ReceiveUpdateOrAddFriendNtf(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.DeleteFriendNtf] = {
        file = "ModuleMgr/FriendMgr",
        func = function(msg)
            ---@type ModuleMgr.FriendMgr
            MgrMgr:GetMgr("FriendMgr").ReceiveDeleteFriendNtf(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.AddFriendTipNtf] = {
        file = "ModuleMgr/FriendMgr",
        func = function(msg)
            ---@type ModuleMgr.FriendMgr
            MgrMgr:GetMgr("FriendMgr").ReceiveAddFriendTipNtf(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.FriendIntimacyDegreeNtf] = {
        file = "ModuleMgr/FriendMgr",
        func = function(msg)
            ---@type ModuleMgr.FriendMgr
            MgrMgr:GetMgr("FriendMgr").ReceiveFriendIntimacyDegreeNtf(msg)
        end,
        override = true --是否覆盖c#协议
    },

    [Network.Define.Ptc.HSDungeonsOneRoundStart] = {
        file = "ModuleMgr/HymnTrialMgr",
        func = function(msg)
            ---@type ModuleMgr.HymnTrialMgr
            MgrMgr:GetMgr("HymnTrialMgr").OnOneRoundStart(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.HSCloseRoulette] = {
        file = "ModuleMgr/HymnTrialMgr",
        func = function(msg)
            ---@type ModuleMgr.HymnTrialMgr
            MgrMgr:GetMgr("HymnTrialMgr").OnStartFight(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.HSDungeonsOneRoundOver] = {
        file = "ModuleMgr/HymnTrialMgr",
        func = function(msg)
            ---@type ModuleMgr.HymnTrialMgr
            MgrMgr:GetMgr("HymnTrialMgr").OnOneRoundOver(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.PraiseRole] = {
        file = "ModuleMgr/HymnTrialMgr",
        func = function(msg)
            ---@type ModuleMgr.HymnTrialMgr
            MgrMgr:GetMgr("HymnTrialMgr").OnPraiseShow(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.DiscoverYahhNtf] = {
        file = "ModuleMgr/BoliGroupMgr",
        func = function(msg)
            ---@type ModuleMgr.BoliGroupMgr
            MgrMgr:GetMgr("BoliGroupMgr").OnFindBoliNtf(msg)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Ptc.YahhAwardNtf] = {
        file = "ModuleMgr/BoliGroupMgr",
        func = function(msg)
            ---@type ModuleMgr.BoliGroupMgr
            local mgr = MgrMgr:GetMgr("BoliGroupMgr")
            mgr.OnModifyPollyAward(msg, true)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Ptc.StallItemSoldNotify] = {
        file = "ModuleMgr/StallMgr",
        func = function(msg)
            ---@type ModuleMgr.StallMgr
            MgrMgr:GetMgr("StallMgr").OnStallItemSoldNotify(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.UpdateMailNtf] = {
        file = "ModuleMgr/EmailMgr",
        func = function(msg)
            ---@type ModuleMgr.EmailMgr
            MgrMgr:GetMgr("EmailMgr").OnUpdateMailNtf(msg)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Ptc.HintNotifyMS] = {
        file = "ModuleMgr/WeakGuideMgr",
        func = function(msg)
            ---@type ModuleMgr.WeakGuideMgr
            MgrMgr:GetMgr("WeakGuideMgr").OnHintNotifyMS(msg)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Ptc.TaskUnlockSkillNtf] = {
        file = "ModuleMgr/SkillLearningMgr",
        func = function(msg)
            ---@type ModuleMgr.SkillLearningMgr
            MgrMgr:GetMgr("SkillLearningMgr").OnTaskUnlockSkill(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.TriggerAddSkillNtf] = {
        file = "ModuleMgr/SkillLearningMgr",
        func = function(msg)
            ---@type ModuleMgr.SkillLearningMgr
            MgrMgr:GetMgr("SkillLearningMgr").OnTriggerAddSkillNtf(msg)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Ptc.LifeSkillNtf] = {
        file = "ModuleMgr/LifeProfessionMgr",
        func = function(msg)
            ---@type ModuleMgr.LifeProfessionMgr
            MgrMgr:GetMgr("LifeProfessionMgr").OnLifeSkillNtf(msg)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Ptc.AutoCollectEndNtf] = {
        file = "ModuleMgr/LifeProfessionMgr",
        func = function(msg)
            ---@type ModuleMgr.LifeProfessionMgr
            local mgr = MgrMgr:GetMgr("LifeProfessionMgr")
            mgr.OnAutoCollectEndNtf(msg)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Ptc.UpdateLifeSkillAward] = {
        file = "ModuleMgr/LifeProfessionMgr",
        func = function(msg)
            ---@type ModuleMgr.LifeProfessionMgr
            local mgr = MgrMgr:GetMgr("LifeProfessionMgr")
            mgr.OnUpdateLifeSkillAward(msg)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Ptc.WaBaoAwardIdNtf] = {
        file = "ModuleMgr/WabaoAwardMgr",
        func = function(msg)
            ---@type ModuleMgr.WabaoAwardMgr
            MgrMgr:GetMgr("WabaoAwardMgr").OnQueryRandomAwardByWabao(msg)
        end,
        override = true, --是否覆盖c#协议
    },
    [Network.Define.Ptc.BeHatredDisappearNotify] = {
        file = "ModuleMgr/DeadDlgMgr",
        func = function(msg)
            MgrMgr:GetMgr("DeadDlgMgr").SetHatorId(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.MSErrorNotify] = {
        file = "ModuleMgr/ServerNotifyMgr",
        func = function(msg)
            ---@type ModuleMgr.ServerNotifyMgr
            MgrMgr:GetMgr("ServerNotifyMgr").OnMSErrorNotify(msg, "masterserver")
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.GSErrorNotify] = {
        file = "ModuleMgr/ServerNotifyMgr",
        func = function(msg)
            ---@type ModuleMgr.ServerNotifyMgr
            MgrMgr:GetMgr("ServerNotifyMgr").OnMSErrorNotify(msg, "gameserver")
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.TradeErrorNotify] = {
        file = "ModuleMgr/ServerNotifyMgr",
        func = function(msg)
            ---@type ModuleMgr.ServerNotifyMgr
            MgrMgr:GetMgr("ServerNotifyMgr").OnMSErrorNotify(msg, "tradeserver")
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.SevenLoginActivityUpdateNotify] = {
        file = "ModuleMgr/LandingAwardMgr",
        func = function(msg)
            ---@type ModuleMgr.LandingAwardMgr
            MgrMgr:GetMgr("LandingAwardMgr").OnNotifyLandingInfo(msg)
        end,
        override = true --是否覆盖c#协议
    },

    [Network.Define.Ptc.RedPointNotify] = {
        file = "ModuleMgr/RedSignCheckMgr",
        func = function(msg)
            ---@type ModuleMgr.RedSignCheckMgr
            MgrMgr:GetMgr("RedSignCheckMgr").ReceiveRedPointNotify(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.LifeEquipNtf] = {
        file = "ModuleMgr/FishMgr",
        func = function(msg)
            ---@type ModuleMgr.FishMgr
            MgrMgr:GetMgr("FishMgr").OnLifeEquipNtf(msg)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Ptc.AutoFishResultNtf] = {
        file = "ModuleMgr/FishMgr",
        func = function(msg)
            ---@type ModuleMgr.FishMgr
            MgrMgr:GetMgr("FishMgr").OnAutoFishResultNtf(msg)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Ptc.KickRoleNtf] = {
        func = function(msg)
            local l_info = ParseProtoBufToTable("LogOutData", msg)
            Network.Handler.OnKickout(l_info.last_error, l_info.ban_info)
            --game:GetAuthMgr():OnKickRoleNtf(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.AnnounceClearNotify] = {
        file = "ModuleMgr/NoticeMgr",
        func = function(msg)
            ---@type ModuleMgr.NoticeMgr
            MgrMgr:GetMgr("NoticeMgr").DeleteGMMessage(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.RoleOnlineNtf] = {
        file = "ModuleMgr/FriendMgr",
        func = function(msg)
            ---@type ModuleMgr.FriendMgr
            MgrMgr:GetMgr("FriendMgr").ReceiveRoleOnlineNtf(msg)
        end,
        override = true --是否覆盖c#协议
    },

    [Network.Define.Ptc.DoubleActiveApplyPush] = {
        file = "ModuleMgr/MultipleActionMgr",
        func = function(msg)
            ---@type ModuleMgr.MultipleActionMgr
            MgrMgr:GetMgr("MultipleActionMgr").OnRequestMultipleActionPush(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.DoubleActiveSuc] = {
        file = "ModuleMgr/MultipleActionMgr",
        func = function(msg)
            ---@type ModuleMgr.MultipleActionMgr
            MgrMgr:GetMgr("MultipleActionMgr").OnMultipleActionSuccess(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.DoubleActiveRefused] = {
        file = "ModuleMgr/MultipleActionMgr",
        func = function(msg)
            ---@type ModuleMgr.MultipleActionMgr
            MgrMgr:GetMgr("MultipleActionMgr").OnMultipleActionRefused(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.DoubleActiveRevoked] = {
        file = "ModuleMgr/MultipleActionMgr",
        func = function(msg)
            ---@type ModuleMgr.MultipleActionMgr
            MgrMgr:GetMgr("MultipleActionMgr").OnMultipleActionRevoked(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.TowerStartCountdown] = {
        file = "ModuleMgr/InfiniteTowerDungeonMgr",
        func = function(msg)
            ---@type ModuleMgr.InfiniteTowerDungeonMgr
            MgrMgr:GetMgr("InfiniteTowerDungeonMgr").TowerStartCountdown(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.TowerLucky] = {
        file = "ModuleMgr/InfiniteTowerDungeonMgr",
        func = function(msg)
            ---@type ModuleMgr.InfiniteTowerDungeonMgr
            MgrMgr:GetMgr("InfiniteTowerDungeonMgr").TowerLuckyPlayer(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.NotifyFirstKillMonster] = {
        file = "ModuleMgr/IllustrationMonsterMgr",
        func = function(msg)
            ---@type ModuleMgr.IllustrationMonsterMgr
            MgrMgr:GetMgr("IllustrationMonsterMgr").ResponseFirstKillMonster(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.SingleAchievementNotify] = {
        file = "ModuleMgr/AchievementMgr",
        func = function(msg)
            ---@type ModuleMgr.AchievementMgr
            MgrMgr:GetMgr("AchievementMgr").ReceiveSingleAchievementNotify(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.RoleWorldEventNotify] = {
        file = "ModuleMgr/WorldPveMgr",
        func = function(msg)
            ---@type ModuleMgr.WorldPveMgr
            MgrMgr:GetMgr("WorldPveMgr").OnRoleWorldEventNotify(msg)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Ptc.RoleWorldEventDBNotify] = {
        file = "ModuleMgr/WorldPveMgr",
        func = function(msg)
            ---@type ModuleMgr.WorldPveMgr
            MgrMgr:GetMgr("WorldPveMgr").OnRoleWorldEventDBNotify(msg)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Ptc.NotityTeamBattlefieldMatch] = {
        file = "ModuleMgr/BattleMgr",
        func = function(msg)
            ---@type ModuleMgr.BattleMgr
            MgrMgr:GetMgr("BattleMgr").OnNotityTeamBattlefieldMatch(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.MedalChangedNofity] = {
        file = "ModuleMgr/MedalMgr",
        func = function(msg)
            ---@type ModuleMgr.MedalMgr
            MgrMgr:GetMgr("MedalMgr").ResponseMedalChangedNotify(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.RedPointNotifyGs] = {
        file = "ModuleMgr/CatCaravanMgr",
        func = function(msg)
            ---@type ModuleMgr.CatCaravanMgr
            MgrMgr:GetMgr("CatCaravanMgr").OnRedPointNotifyGs(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.UpdateDungeonsTarget] = {
        file = "ModuleMgr/DungeonTargetMgr",
        func = function(msg)
            ---@type ModuleMgr.DungeonTargetMgr
            MgrMgr:GetMgr("DungeonTargetMgr").OnUpdateDungeonsTarget(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.DungeonsTargetSection] = {
        file = "ModuleMgr/DungeonTargetMgr",
        func = function(msg)
            ---@type ModuleMgr.DungeonTargetMgr
            MgrMgr:GetMgr("DungeonTargetMgr").OnDungeonsTargetSection(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.GarbageCollectNtf] = {
        file = "ModuleMgr/PropMgr",
        func = function(msg)
            ---@type ModuleMgr.PropMgr
            MgrMgr:GetMgr("PropMgr").ReceiveGarbageCollectNtf(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.CheckQueuingNtf] = {
        func = function(msg)
            game:GetAuthMgr():OnQueuingNtf(msg)
        end,
        override = true
    },
    [Network.Define.Ptc.WaBaoStartNotify] = {
        file = "ModuleMgr/WabaoAwardMgr",
        func = function(msg)
            ---@type ModuleMgr.WabaoAwardMgr
            MgrMgr:GetMgr("WabaoAwardMgr").OnWaBaoStartNotify(msg)
        end,
        override = true
    },
    [Network.Define.Ptc.BuyGoodUrlNtf] = {
        func = function(msg)
            game:GetPayMgr():PayGoods(msg)
        end,
        override = true
    },
    [Network.Define.Ptc.PayMoneySuccessFromGs] = {
        func = function(msg)
            game:GetPayMgr():OnPayMoneySuccessFromGs(msg)
        end,
        override = true
    },
    [Network.Define.Ptc.PayMoneySuccessFromMs] = {
        func = function(msg)
            game:GetPayMgr():OnPayMoneySuccessFromMs(msg)
        end,
        override = true
    },
    [Network.Define.Ptc.LeaveRoomNft] = {
        file = "ModuleMgr/ChatRoomMgr",
        func = function(msg)
            ---@type ModuleMgr.ChatRoomMgr
            MgrMgr:GetMgr("ChatRoomMgr").OnLeaveRoomNft(msg)
        end,
        override = true
    },
    [Network.Define.Ptc.RoomChangeCaptainNtf] = {
        file = "ModuleMgr/ChatRoomMgr",
        func = function(msg)
            ---@type ModuleMgr.ChatRoomMgr
            MgrMgr:GetMgr("ChatRoomMgr").OnRoomChangeCaptainNtf(msg)
        end,
        override = true
    },
    [Network.Define.Ptc.RoomDissolveNtf] = {
        file = "ModuleMgr/ChatRoomMgr",
        func = function(msg)
            ---@type ModuleMgr.ChatRoomMgr
            MgrMgr:GetMgr("ChatRoomMgr").OnRoomDissolveNtf(msg)
        end,
        override = true
    },
    [Network.Define.Ptc.RoomKickMemberNtf] = {
        file = "ModuleMgr/ChatRoomMgr",
        func = function(msg)
            ---@type ModuleMgr.ChatRoomMgr
            MgrMgr:GetMgr("ChatRoomMgr").OnRoomKickMemberNtf(msg)
        end,
        override = true
    },
    [Network.Define.Ptc.RoomSettingChangeNtf] = {
        file = "ModuleMgr/ChatRoomMgr",
        func = function(msg)
            ---@type ModuleMgr.ChatRoomMgr
            MgrMgr:GetMgr("ChatRoomMgr").OnRoomSettingChangeNtf(msg)
        end,
        override = true
    },
    [Network.Define.Ptc.RoomInfoNtf] = {
        file = "ModuleMgr/ChatRoomMgr",
        func = function(msg)
            ---@type ModuleMgr.ChatRoomMgr
            MgrMgr:GetMgr("ChatRoomMgr").OnRoomInfoNtf(msg)
        end,
        override = true
    },
    [Network.Define.Ptc.NewRoomMemberNtf] = {
        file = "ModuleMgr/ChatRoomMgr",
        func = function(msg)
            ---@type ModuleMgr.ChatRoomMgr
            MgrMgr:GetMgr("ChatRoomMgr").OnNewRoomMemberNtf(msg)
        end,
        override = true
    },
    [Network.Define.Ptc.RoomMerberStatusNft] = {
        file = "ModuleMgr/ChatRoomMgr",
        func = function(msg)
            ---@type ModuleMgr.ChatRoomMgr
            MgrMgr:GetMgr("ChatRoomMgr").OnRoomMerberStatusNft(msg)
        end,
        override = true
    },
    [Network.Define.Ptc.NotifyFlop] = {
        file = "ModuleMgr/LuckyDrawMgr",
        func = function(msg)
            ---@type ModuleMgr.LuckyDrawMgr
            MgrMgr:GetMgr("LuckyDrawMgr").OnNotifyFlop(msg)
        end,
        override = true
    },
    [Network.Define.Ptc.NotifyRollStart] = {
        file = "ModuleMgr/RollMgr",
        func = function(msg)
            ---@type ModuleMgr.RollMgr
            MgrMgr:GetMgr("RollMgr").OnNotifyRollStart(msg)
        end,
        override = true
    },
    [Network.Define.Ptc.RollConfirmNtf] = {
        file = "ModuleMgr/RollMgr",
        func = function(msg)
            ---@type ModuleMgr.RollMgr
            MgrMgr:GetMgr("RollMgr").OnRollConfirmNtf(msg)
        end,
        override = true
    },
    [Network.Define.Ptc.ChatMsgClearNtf] = {
        file = "ModuleMgr/ChatMgr",
        func = function(msg)
            ---@type ModuleMgr.ChatMgr
            MgrMgr:GetMgr("ChatMgr").OnChatMsgClearNtf(msg)
        end,
        override = true
    },
    [Network.Define.Ptc.PVPBroadcastNtf] = {
        file = "ModuleMgr/BattleMgr",
        func = function(msg)
            ---@type ModuleMgr.BattleMgr
            MgrMgr:GetMgr("BattleMgr").OnShowBattleTips(msg)
        end,
        override = true
    },
    [Network.Define.Ptc.FashionCountNtf] = {
        file = "ModuleMgr/GarderobeMgr",
        func = function(msg)
            MgrProxy:GetGarderobeMgr().OnFashionCountNtf(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.GMAnnouncePtc] = {
        func = function(msg)
            ---@type GMAnnouncePtcData
            local l_info = ParseProtoBufToTable("GMAnnouncePtcData", msg)
            CommonUI.Dialog.ShowOKDlg(true, nil, l_info.data)
        end,
        override = true
    },
    [Network.Define.Ptc.FashionLevelChange] = {
        func = function(msg)
            ---@type FashionLevelChangeData
            local l_info = ParseProtoBufToTable("FashionLevelChangeData", msg)
            MgrMgr:GetMgr("GarderobeMgr").FashionLevelChangePtc(msg)
        end,
        override = true
    },
    [Network.Define.Ptc.TeamSyncBuff] = {
        func = function(msg)
            ---@type ModuleMgr.BuffMgr
            MgrMgr:GetMgr("BuffMgr").OnTeamSyncBuff(msg)
        end,
        override = true
    },
    [Network.Define.Ptc.RoomBriefNeighbourNtf] = {
        func = function(msg)
            ---@type ModuleMgr.ChatRoomBubbleMgr
            MgrMgr:GetMgr("ChatRoomBubbleMgr").OnRoomBriefNeighbourNtf(msg)
        end,
        override = true
    },
    [Network.Define.Ptc.ThirtySignActivityUpdateNotify] = {
        func = function(msg)
            ---@type ModuleMgr.SignInMgr
            MgrMgr:GetMgr("SignInMgr").OnThirtySignActivityUpdateNotify(msg)
        end,
        override = true
    },
    [Network.Define.Ptc.AISyncVarListNtf] = {
        file = "ModuleMgr.DungeonMgr",
        func = function(msg)
            ---@type ModuleMgr.DungeonMgr
            MgrMgr:GetMgr("DungeonMgr").OnAISyncVarListNtf(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Ptc.DelegationRefresh] = {
        file = "ModuleMgr/DelegateModuleMgr",
        func = function(msg)
            ---@type DelegationSetData
            local l_info = ParseProtoBufToTable("DelegationSetData", msg)
            ---@type ModuleMgr.DelegateModuleMgr
            MgrMgr:GetMgr("DelegateModuleMgr").OnDelegationRefresh(l_info)
        end,
        override = true
    },
    [Network.Define.Ptc.EquipBuffAttachSkillNtf] = {
        file = "ModuleMgr/SkillLearningMgr",
        func = function(msg)
            ---@type BuffSkill
            local l_info = ParseProtoBufToTable("BuffSkill", msg)
            ---@type ModuleMgr.SkillLearningMgr
            MgrMgr:GetMgr("SkillLearningMgr").OnBuffSkillNtf(l_info)
        end,
        override = false
    },
    [Network.Define.Ptc.DelegationUpdate] = {
        file = "ModuleMgr/DelegateModuleMgr",
        func = function(msg)
            ---@type DelegationSetData
            local l_info = ParseProtoBufToTable("DelegationSetData", msg)
            ---@type ModuleMgr.DelegateModuleMgr
            MgrMgr:GetMgr("DelegateModuleMgr").OnDelegationUpdate(l_info)
        end,
        override = true
    },
    [Network.Define.Ptc.OwnStickersNtf] = {
        file = "ModuleMgr/TitleStickerMgr",
        func = function(msg)
            MgrMgr:GetMgr("TitleStickerMgr").OnOwnStickersNtf(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Ptc.AntiAddictionNtf] = {
        file = "ModuleMgr/AntiAdditionMgr",
        func = function(msg)
            ---@type ModuleMgr.AntiAdditionMgr
            MgrMgr:GetMgr("AntiAdditionMgr").ProcessAntiAddictionMsg(msg)
        end,
        override = true
    },
    [Network.Define.Ptc.AttrRaisedNotify] = {
        file = "ModuleMgr/DungeonMgr",
        func = function(msg)
            ---@type ModuleMgr.DungeonMgr
            MgrMgr:GetMgr("DungeonMgr").OnAttrRaisedNotify(msg)
        end,
        override = true
    },
    [Network.Define.Ptc.CobbleStoneHelp] = {
        file = "ModuleMgr/StoneSculptureMgr",
        func = function(msg)
            ---@type ModuleMgr.StoneSculptureMgr
            MgrMgr:GetMgr("StoneSculptureMgr").OnCobbleStoneHelp(msg)
        end,
        override = true
    },
    [Network.Define.Ptc.CobblleStoneCarvedNtf] = {
        file = "ModuleMgr/StoneSculptureMgr",
        func = function(msg)
            ---@type ModuleMgr.StoneSculptureMgr
            MgrMgr:GetMgr("StoneSculptureMgr").OnCobblleStoneCarvedNtf(msg)
        end,
        override = true
    },
    [Network.Define.Ptc.FollowOutRangeNft] = {
        file = "ModuleMgr/DungeonMgr",
        func = function(msg)
            ---@type ModuleMgr.DungeonMgr
            MgrMgr:GetMgr("DungeonMgr").OnFollowOutRangeNft(msg)
        end,
        override = true
    },
    [Network.Define.Ptc.WeakQteGuideNotify] = {
        file = "ModuleMgr/BeginnerGuideMgr",
        func = function(msg)
            ---@type ModuleMgr.BeginnerGuideMgr
            MgrMgr:GetMgr("BeginnerGuideMgr").OnWeakQteGuideNotify(msg)
        end,
        override = true
    },
    [Network.Define.Ptc.QteGuideNotify] = {
        file = "ModuleMgr/QTEGuideMgr",
        func = function(msg)
            ---@type ModuleMgr.QTEGuideMgr
            MgrMgr:GetMgr("QTEGuideMgr").OnQteGuideNotify(msg)
        end,
        override = true
    },
    [Network.Define.Ptc.MazeDungeonsMapNtf] = {
        file = "ModuleMgr/MazeDungeonMgr",
        func = function(msg)
            ---@type ModuleMgr.MazeDungeonMgr
            MgrMgr:GetMgr("MazeDungeonMgr").OnMazeDungeonsMapNtf(msg)
        end,
        override = true
    },
    [Network.Define.Ptc.MazeDungeonsIncreaseMapNtf] = {
        file = "ModuleMgr/MazeDungeonMgr",
        func = function(msg)
            ---@type ModuleMgr.MazeDungeonMgr
            MgrMgr:GetMgr("MazeDungeonMgr").OnMazeDungeonsIncreaseMapNtf(msg)
        end,
        override = true
    },
    [Network.Define.Ptc.RunRouletteNtf] = {
        file = "ModuleMgr/MazeDungeonMgr",
        func = function(msg)
            ---@type ModuleMgr.MazeDungeonMgr
            MgrMgr:GetMgr("MazeDungeonMgr").OnRunRouletteNtf(msg)
        end,
        override = true
    },
    [Network.Define.Ptc.MazeRoomStartOrEndNtf] = {
        file = "ModuleMgr/MazeDungeonMgr",
        func = function(msg)
            ---@type ModuleMgr.MazeDungeonMgr
            MgrMgr:GetMgr("MazeDungeonMgr").OnMazeRoomStartOrEndNtf(msg)
        end,
        override = true
    },
    -- [Network.Define.Ptc.SendRedEnvelopeNtf] = {
    --     file = "ModuleMgr/RedEnvelopeMgr",
    --     func = function(msg)
    --         MgrMgr:GetMgr("RedEnvelopeMgr").OnSendRedEnvelopeNtf(msg)
    --     end,
    --     override = true
    -- },
    [Network.Define.Ptc.SendRenEnvelopePasswordNtf] = {
        file = "ModuleMgr/RedEnvelopeMgr",
        func = function(msg)
            ---@type ModuleMgr.RedEnvelopeMgr
            MgrMgr:GetMgr("RedEnvelopeMgr").OnSendRenEnvelopePasswordNtf(msg)
        end,
        override = true
    },
    [Network.Define.Ptc.CheckStateExclusionFailNtf] = {
        file = "ModuleMgr/ComErrorCodeMgr",
        func = function(msg)
            ---@type ModuleMgr.ComErrorCodeMgr
            MgrMgr:GetMgr("ComErrorCodeMgr").OnCheckStateExclusionFailNtf(msg)
        end,
        override = true
    },
    [Network.Define.Ptc.MerchantUpdateNotify] = {
        file = "ModuleMgr/MerchantMgr",
        func = function(msg)
            ---@type ModuleMgr.MerchantMgr
            MgrMgr:GetMgr("MerchantMgr").OnMerchantUpdateNotify(msg)
        end,
        override = true
    },
    [Network.Define.Ptc.ThemePartyStateNtf] = {
        file = "ModuleMgr/ThemePartyMgr",
        func = function(msg)
            ---@type ModuleMgr.ThemePartyMgr
            MgrMgr:GetMgr("ThemePartyMgr").OnThemePartyStateNtf(msg)
        end,
        override = true
    },
    [Network.Define.Ptc.DanceActionNtf] = {
        file = "ModuleMgr/ThemePartyMgr",
        func = function(msg)
            ---@type ModuleMgr.ThemePartyMgr
            MgrMgr:GetMgr("ThemePartyMgr").OnDanceActionNtf(msg)
        end,
        override = true
    },
    [Network.Define.Ptc.ThemePartyLoveNtf] = {
        file = "ModuleMgr/ThemePartyMgr",
        func = function(msg)
            ---@type ModuleMgr.ThemePartyMgr
            MgrMgr:GetMgr("ThemePartyMgr").OnThemePartyLoveNtf(msg)
        end,
        override = true
    },
    [Network.Define.Ptc.ThemePartyLotteryDrawNtf] = {
        file = "ModuleMgr/ThemePartyMgr",
        func = function(msg)
            ---@type ModuleMgr.ThemePartyMgr
            MgrMgr:GetMgr("ThemePartyMgr").OnThemePartyLotteryDrawNtf(msg)
        end,
        override = true
    },
    [Network.Define.Ptc.SwichSceneBgmNtf] = {
        file = "ModuleMgr/ThemePartyMgr",
        func = function(msg)
            ---@type ModuleMgr.ThemePartyMgr
            MgrMgr:GetMgr("ThemePartyMgr").OnSwichSceneBgmNtf(msg)
        end,
        override = true
    },
    [Network.Define.Ptc.NtfClientLimitedOfferStatus] = {
        file = "ModuleMgr/TimeLimitPayMgr",
        func = function(msg)
            ---@type ModuleMgr.TimeLimitPayMgr
            MgrMgr:GetMgr("TimeLimitPayMgr").OnNtfClientLimitedOfferStatus(msg)
        end,
        override = true
    },
    [Network.Define.Ptc.MidasExceptionNtf] = {
        func = function(msg)
            game:GetPayMgr():OnMidasExceptionNtf(msg)
        end,
        override = true
    },
    [Network.Define.Ptc.AllSceneInfluenceNtf] = {
        file = "ModuleMgr/WorldMapInfoMgr",
        func = function(msg)
            ---@type ModuleMgr.WorldMapInfoMgr
            MgrMgr:GetMgr("WorldMapInfoMgr").OnAllSceneInfluenceNtf(msg)
        end,
        override = true
    },
    [Network.Define.Ptc.SceneInfluenceUpdate] = {
        file = "ModuleMgr/WorldMapInfoMgr",
        func = function(msg)
            ---@type ModuleMgr.WorldMapInfoMgr
            MgrMgr:GetMgr("WorldMapInfoMgr").OnSceneInfluenceUpdate(msg)
        end,
        override = true
    },
    [Network.Define.Ptc.DynamicDisplayNpcNtf] = {
        file = "ModuleMgr/WorldMapInfoMgr",
        func = function(msg)
            ---@type ModuleMgr.WorldMapInfoMgr
            MgrMgr:GetMgr("WorldMapInfoMgr").OnDynamicDisplayNpcNtf(msg)
        end,
        override = true
    },
    [Network.Define.Ptc.DynamicDisplayNpcUpdate] = {
        file = "ModuleMgr/WorldMapInfoMgr",
        func = function(msg)
            ---@type ModuleMgr.WorldMapInfoMgr
            MgrMgr:GetMgr("WorldMapInfoMgr").OnDynamicDisplayNpcUpdate(msg)
        end,
        override = true
    },
    [Network.Define.Ptc.ActivityMailTipNtf] = {
        file = "ModuleMgr/EmailMgr",
        func = function(msg)
            ---@type ModuleMgr.EmailMgr
            MgrMgr:GetMgr("EmailMgr").OnActivityMailTipNtf(msg)
        end,
        override = true
    },
    [Network.Define.Ptc.CallBlackCurtainNtf] = {
        file = "ModuleMgr/ServerNotifyMgr",
        func = function(msg)
            MgrMgr:GetMgr("ServerNotifyMgr").ExecuteActionByServerNotify(msg)
        end,
        override = true
    },
    [Network.Define.Ptc.ChatCDNotify] = {
        file = "ModuleMgr/ChatMgr",
        func = function(msg)
            ---@type ModuleMgr.ChatMgr
            MgrMgr:GetMgr("ChatMgr").OnChatCDNotify(msg)
        end,
        override = true
    },
    [Network.Define.Ptc.QualityPointUpdateNotify] = {
        file = "ModuleMgr/RoleInfoMgr",
        func = function(msg)
            ---@type ModuleMgr.RoleInfoMgr
            MgrMgr:GetMgr("RoleInfoMgr").OnQualityPointUpdateNotify(msg)
        end,
        override = true
    },
    [Network.Define.Ptc.BattleRevenueChangeNtf] = {
        file = "ModuleMgr/BattleStatisticsMgr",
        func = function(msg)
            ---@type ModuleMgr.BattleStatisticsMgr
            MgrMgr:GetMgr("BattleStatisticsMgr").OnBattleRevenueChangeNtf(msg)
        end,
        override = true
    },
    [Network.Define.Ptc.BagLoadUnlockNtf] = {
        file = "ModuleMgr/PropMgr",
        func = function(msg)
            ---@type ModuleMgr.PropMgr
            MgrMgr:GetMgr("PropMgr").OnBagLoadUnlockNtf(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.DungeonWatchAllMemberStatusNtf] = {
        file = "ModuleMgr/WatchWarMgr",
        func = function(msg)
            ---@type ModuleMgr.WatchWarMgr
            MgrMgr:GetMgr("WatchWarMgr").OnDungeonWatchAllMemberStatusNtf(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.DungeonWatchBriefStatusNft] = {
        file = "ModuleMgr/WatchWarMgr",
        func = function(msg)
            ---@type ModuleMgr.WatchWarMgr
            MgrMgr:GetMgr("WatchWarMgr").OnDungeonWatchBriefStatusNft(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.UpdateRoomWatchInfo] = {
        file = "ModuleMgr/WatchWarMgr",
        func = function(msg)
            ---@type ModuleMgr.WatchWarMgr
            MgrMgr:GetMgr("WatchWarMgr").OnUpdateRoomWatchInfo(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.WatchSwitch] = {
        file = "ModuleMgr/WatchWarMgr",
        func = function(msg)
            ---@type ModuleMgr.WatchWarMgr
            MgrMgr:GetMgr("WatchWarMgr").OnWatchSwitch(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.DungeonsWatchInit] = {
        file = "ModuleMgr/WatchWarMgr",
        func = function(msg)
            ---@type ModuleMgr.WatchWarMgr
            MgrMgr:GetMgr("WatchWarMgr").OnDungeonsWatchInit(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.TeamWatchStatusNtf] = {
        file = "ModuleMgr/WatchWarMgr",
        func = function(msg)
            ---@type ModuleMgr.WatchWarMgr
            local mgr = MgrMgr:GetMgr("WatchWarMgr")
            mgr.OnTeamWatchStatusNtf(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.NotifySkillPlan] = {
        file = "ModuleMgr/SkillLearningMgr",
        func = function(msg)
            ---@type ModuleMgr.SkillLearningMgr
            MgrMgr:GetMgr("SkillLearningMgr").OnSkillPlanChange(msg)
        end,
        override = true --是否覆盖c#协议
    },

    --佣兵
    [Network.Define.Ptc.MercenaryAttrUpdateNtf] = {
        file = "ModuleMgr/MercenaryMgr",
        func = function(msg)
            ---@type ModuleMgr.MercenaryMgr
            MgrMgr:GetMgr("MercenaryMgr").OnMercenaryAttrUpdateNtf(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.MercenaryRecruitNtf] = {
        file = "ModuleMgr/MercenaryMgr",
        func = function(msg)
            ---@type ModuleMgr.MercenaryMgr
            MgrMgr:GetMgr("MercenaryMgr").OnMercenaryRecruitNtf(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.MercenaryAdvanceNtf] = {
        file = "ModuleMgr/MercenaryMgr",
        func = function(msg)
            ---@type ModuleMgr.MercenaryMgr
            MgrMgr:GetMgr("MercenaryMgr").OnMercenaryAdvanceNtf(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.MercenaryDeadNtf] = {
        file = "ModuleMgr/MercenaryMgr",
        func = function(msg)
            ---@type ModuleMgr.MercenaryMgr
            MgrMgr:GetMgr("MercenaryMgr").OnMercenaryDeadNtf(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.MercenaryUidNtf] = {
        file = "ModuleMgr/MercenaryMgr",
        func = function(msg)
            ---@type ModuleMgr.MercenaryMgr
            MgrMgr:GetMgr("MercenaryMgr").OnMercenaryUidNtf(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.MercenaryEquipInfoNtf] = {
        file = "ModuleMgr/MercenaryMgr",
        func = function(msg)
            ---@type ModuleMgr.MercenaryMgr
            MgrMgr:GetMgr("MercenaryMgr").OnMercenaryEquipInfoNtf(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.MercenaryFightNumNtf] = {
        file = "ModuleMgr/MercenaryMgr",
        func = function(msg)
            ---@type ModuleMgr.MercenaryMgr
            local mgr = MgrMgr:GetMgr("MercenaryMgr")
            mgr.OnMercenaryFightNumNtf(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.MercenarySkillOpenNtf] = {
        file = "ModuleMgr/MercenaryMgr",
        func = function(msg)
            ---@type ModuleMgr.MercenaryMgr
            local mgr = MgrMgr:GetMgr("MercenaryMgr")
            mgr.OnMercenarySkillOpenNtf(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.CommondataNtf] = {
        file = "ModuleMgr/CommonBroadcastMgr",
        func = function(msg)
            ---@type ModuleMgr.CommonBroadcastMgr
            MgrMgr:GetMgr("CommonBroadcastMgr").OnCommonMsg(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.HealthExpNtf] = {
        file = "ModuleMgr/BattleStatisticsMgr",
        func = function(msg)
            ---@type ModuleMgr.BattleStatisticsMgr
            MgrMgr:GetMgr("BattleStatisticsMgr").OnHealthExpNtf(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.RoleAttributeNtf] = {
        file = "ModuleMgr/SelectRoleMgr",
        func = function(msg)
            MgrMgr:GetMgr("SelectRoleMgr").OnRoleAttributeNtf(msg)
        end,
        override = false --是否覆盖c#协议
    },
    [Network.Define.Ptc.GuildMatchSyncRoleLife] = {
        file = "ModuleMgr/WatchWarMgr",
        func = function(msg)
            MgrMgr:GetMgr("WatchWarMgr").OnRoleLifeUpdate(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.MengXinLevelGiftsInfoNtf] = {
        file = "ModuleMgr/NewPlayerMgr",
        func = function(msg)
            MgrMgr:GetMgr("NewPlayerMgr").OnQueryMengXinLevelGiftInfo(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.RefreshGuildBattrleMgrTeamInfoNtf] = {
        file = "ModuleMgr/GuildMatchMgr",
        func = function(msg)
            MgrMgr:GetMgr("GuildMatchMgr").OnRefreshGuildBattrleMgrTeamInfoNtf(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.GuildBattleResultNtf] = {
        file = "ModuleMgr/GuildMatchMgr",
        func = function(msg)
            MgrMgr:GetMgr("GuildMatchMgr").OnGuildBattleResultNtf(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.GuildFlowersChangeNtf] = {
        file = "ModuleMgr/WatchWarMgr",
        func = function(msg)
            MgrMgr:GetMgr("WatchWarMgr").OnGuildFlowersChangeNtf(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.GuildMatchTeamCacheNtf] = {
        file = "ModuleMgr/GuildMatchMgr",
        func = function(msg)
            MgrMgr:GetMgr("GuildMatchMgr").OnGuildTeamCache(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.GuildMatchBattleTeamApplyResultNtf] = {
        file = "ModuleMgr/GuildMatchMgr",
        func = function(msg)
            MgrMgr:GetMgr("GuildMatchMgr").OnGuildMatchBattleTeamApplyResultNtf(msg)
        end,
        override = true --是否覆盖c#协议
    },
    [Network.Define.Ptc.DPSInfoNtf] = {
        file = "ModuleMgr/GmMgr",
        func = function(msg)
            ---@type ModuleMgr.GmMgr
            MgrMgr:GetMgr("GmMgr").OnDpsInfoNtf(msg)
        end,
        override = true --覆盖C#协议
    },
    -- 拍卖
    [Network.Define.Ptc.AuctionItemChangeNotify] = {
        file = "ModuleMgr/AuctionMgr",
        func = function(msg)
            ---@type ModuleMgr.GmMgr
            local mgr = MgrMgr:GetMgr("AuctionMgr")
            mgr.OnAuctionItemChangeNotify(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Ptc.UpdateTeamProfessions] = {
        file = "ModuleMgr/TeamMgr",
        func = function(msg)
            ---@type ModuleMgr.TeamMgr
            local mgr = MgrMgr:GetMgr("TeamMgr")
            mgr.UpdateTeamProfessionsNTF(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Ptc.UpdateMonsterKilledNum] = {
        file = "ModuleMgr/IllustrationMonsterMgr",
        func = function(msg)
            ---@type ModuleMgr.IllustrationMonsterMgr
            MgrMgr:GetMgr("IllustrationMonsterMgr").UpdateMonsterKilledNumNtf(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Ptc.UseItemReplyClientPtc] = {
        file = "ModuleMgr/PropMgr",
        func = function(msg)
            ---@type ModuleMgr.PropMgr
            local mgr = MgrMgr:GetMgr("PropMgr")
            mgr.OnUseItemReplyClientPtc(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Ptc.RefreshGuildMatchTeamInfoNtf] = {
        file = "ModuleMgr/GuildMatchMgr",
        func = function(msg)
            ---@type ModuleMgr.GuildMatchMgr
            local mgr = MgrMgr:GetMgr("GuildMatchMgr")
            mgr.RefreshGuildMatchTeamInfoNtf(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Ptc.MonsterTreasureDelNtf] = {
        file = "ModuleMgr/TreasureHunterMgr",
        func = function(msg)
            ---@type ModuleMgr.TreasureHunterMgr
            local mgr = MgrMgr:GetMgr("TreasureHunterMgr")
            mgr.OnMonsterTreasureDelNtf(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Ptc.TreasureHunterInfoNtf] = {
        file = "ModuleMgr/TreasureHunterMgr",
        func = function(msg)
            ---@type ModuleMgr.TreasureHunterMgr
            local mgr = MgrMgr:GetMgr("TreasureHunterMgr")
            mgr.OnTreasureHunterInfoNtf(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Ptc.TreasureHunterShowSurveyBtn] = {
        file = "ModuleMgr/TreasureHunterMgr",
        func = function(msg)
            ---@type ModuleMgr.TreasureHunterMgr
            local mgr = MgrMgr:GetMgr("TreasureHunterMgr")
            mgr.OnTreasureHunterShowSurveyBtn(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Ptc.OpenSystemChangeNtf] = {
        file = "ModuleMgr/OpenSystemMgr",
        func = function(msg)
            ---@type ModuleMgr.OpenSystemMgr
            local l_mgr = MgrMgr:GetMgr("OpenSystemMgr")
            l_mgr.OnOpenSystemChangeNtf(msg)
        end,
        override = true --覆盖C#协议
    },

    [Network.Define.Ptc.RoleRecallNtf] = {
        file = "ModuleMgr/BackCityMgr",
        func = function(msg)
            ---@type ModuleMgr.BackCityMgr
            local l_mgr = MgrMgr:GetMgr("BackCityMgr")
            l_mgr.OnRoleRecallNtf(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Ptc.RoleDeadNtf] = {
        file = "ModuleMgr/DeadDlgMgr",
        func = function(msg)
            ---@type ModuleMgr.DeadDlgMgr
            local mgr = MgrMgr:GetMgr("DeadDlgMgr")
            mgr.OnRoleDeadNtf(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Ptc.PaySDKOrderResult] = {
        file = "ModuleMgr/BasePayMgr",
        func = function(msg)
            ---@type ModuleMgr.BasePayMgr
            game:GetPayMgr():OnPaySDKOrderResultData(msg)
        end,
        override = true --覆盖C#协议
    },

    [Network.Define.Ptc.NtfActivityTimeInfo] = {
        file = "ModuleMgr/ActivityMgr",
        func = function(msg)
            ---@type ModuleMgr.ActivityMgr
            local mgr = MgrMgr:GetMgr("ActivityMgr")
            mgr.OnNtfActivityTimeInfo(msg)
        end,
        override = true --覆盖C#协议
    },

    [Network.Define.Ptc.NtfActivityState] = {
        file = "ModuleMgr/ActivityMgr",
        func = function(msg)
            ---@type ModuleMgr.ActivityMgr
            local mgr = MgrMgr:GetMgr("ActivityMgr")
            mgr.OnNtfActivityState(msg)
        end,
        override = true --覆盖C#协议
    },
    [Network.Define.Ptc.SyncTeamMemberInfo] = {
        file = "ModuleMgr/TeamMgr",
        func = function(msg)
            ---@type ModuleMgr.TeamMgr
            local mgr = MgrMgr:GetMgr("TeamMgr")
            mgr.OnSyncTeamMemberInfo(msg)
        end,
        override = true --覆盖C#协议
    },
}

local l_luaMsgIds = nil
function GetLuaMsgIds()
    if l_luaMsgIds == nil then
        l_luaMsgIds = {}

        for k, v in pairs(l_rpcHandlers) do
            if v.override == true then
                l_luaMsgIds[k] = true
            else
                l_luaMsgIds[k] = false
            end
        end

        for k, v in pairs(l_ptcHandlers) do
            if v.override == true then
                l_luaMsgIds[k] = true
            else
                l_luaMsgIds[k] = false
            end
        end
    end

    return l_luaMsgIds
end

--#region 周期类
--onConnected的注册
local l_onConnectedHandlers = {
    [MStageEnum.Login] = function()
        game:GetAuthMgr():OnConnected()
    end
}

--onConnectFailed的注册
local l_onConnectFailedHandlers = {
    [MStageEnum.Login] = function()
        game:GetAuthMgr():OnConnectFailed()
    end
}

--onReconnected的注册
local l_reconnectCount = 0
local l_onReconnectedHandlers = function(msg)
    local l_info = ParseProtoBufToTable("ReconectSync", msg)
    MgrMgr:OnReconnected(l_info) --数据先行
    --Data.DeadDlgModel:OnReconnected(l_info) --todo@马鑫 统一改为datamgr
    --UIMgr:OnReconnected()

    l_reconnectCount = 0
end

local l_onReconnectFailedHandlers = function()
    if MNetClient.NetLoginStep == ENetLoginStep.Begin
            or MNetClient.NetLoginStep == ENetLoginStep.SDKLogged
            or MNetClient.NetLoginStep == ENetLoginStep.LoginServerFetched
    then
        logError("[onReconntFailed]invalid NetLoginStep={0}", MNetClient.NetLoginStep)
        return
    end

    local l_delayTime, l_txt
    l_reconnectCount = l_reconnectCount + 1
    if l_reconnectCount <= 3 then
        l_txt = Common.Utils.Lang("NET_RECONNECT_FAILED_RETRY")
        l_delayTime = 15
    else
        l_txt = Common.Utils.Lang("NET_RECONNECT_FAILED")
        l_delayTime = 0
    end

    local l_txtConfirm = Common.Utils.Lang("NET_RECONNECT_FAILED_BTN_RETRY")
    local l_txtCancel = Common.Utils.Lang("NET_RECONNECT_FAILED_BTN")
    CommonUI.Dialog.ShowDlg(CommonUI.Dialog.DialogType.YES_NO, true, nil, l_txt, l_txtConfirm, l_txtCancel,
            Network.Handler.Reconnect,
            function()
                l_reconnectCount = 0
                game:GetAuthMgr():LogoutToAccount()
            end,
            l_delayTime, 0, nil,
            function(ctrl)
                ctrl:SetOverrideSortLayer(UI.UILayerSort.Top + 1)
            end,
            nil, true)
end

--onClosed的注册
local l_onClosedHandlers = function(loginStep, errCode)
    if loginStep == ENetLoginStep.LoginServerFetched
            or loginStep == ENetLoginStep.LoginServerConnected
            or loginStep == ENetLoginStep.LoginServerLogged
    then
        game:GetAuthMgr():OnAuthingGameDisconnected(errCode)
    elseif loginStep == ENetLoginStep.GateServerFetched
            or loginStep == ENetLoginStep.GateServerConnected
            or loginStep == ENetLoginStep.GateServerLogged
            or loginStep == ENetLoginStep.RoleCreated
            or loginStep == ENetLoginStep.RoleSelected
    then
        game:GetAuthMgr():OnEnteringGameDisconnected(errCode)
    elseif loginStep == ENetLoginStep.GameEntered then
        game:GetAuthMgr():OnGamePlayingDisconnected(errCode)
    end
end

--ErrorNotify和KickRoleNtf都会调到此有一份
--ErrorNotify 是各种原因登录失败，或者gs宕机，或者另外一端登录被踢下线等
--KickRoleNtf 是后台封号等各种原因被踢出
local l_onKickoutHandlers = function(errCode, banInfo)
    logRed("[OnKickout]OnKickOutByServer error code={0}", errCode)

    if errCode == KickType.KICK_GMFORBID then
        game:GetAuthMgr():ShowImportantDialog(Lang("NET_KICKOUT_GMFORBID"), function()
            game:GetAuthMgr():LogoutToAccount()
        end)
    elseif errCode == KickType.KICK_RELOGIN then
        --被相同用户顶下线
        game:GetAuthMgr():ShowImportantDialog(Lang("NET_KICKOUT_RELOGIN"), function()
            game:GetAuthMgr():LogoutToAccount()
        end)
    elseif errCode == KickType.KICK_SERVER_SHUTDOWN then
        game:GetAuthMgr():ShowImportantDialog(Lang("NET_CLOSED_BY_SERVER"), function()
            game:GetAuthMgr():LogoutToAccount()
        end)

    elseif errCode == ErrorCode.ERR_ROLE_BAN then
        if banInfo ~= nil and banInfo.endtime ~= nil then
            MgrMgr:GetMgr("PlayerGameStateMgr").ShowPlayerBanInfo(banInfo, true, function()
                game:GetAuthMgr():LogoutToAccount()
            end)
        else
            logError("baninfo_error!!!!")
        end
    elseif errCode == ErrorCode.ERR_PLAT_BANACC then
        if banInfo ~= nil and banInfo.endtime ~= nil then
            MgrMgr:GetMgr("PlayerGameStateMgr").ShowPlayerBanInfo(banInfo, false, function()
                game:GetAuthMgr():LogoutToAccount()
            end)
        else
            logError("baninfo_error!!!!")
        end
    elseif errCode == ErrorCode.ERR_RECOVER_STATUS then
        if banInfo ~= nil and banInfo.endtime ~= nil then
            MgrMgr:GetMgr("PlayerGameStateMgr").ShowRecoverPayDlgForKick(banInfo, function()
                game:GetAuthMgr():LogoutToAccount()
            end)
        else
            logError("baninfo_error!!!!")
        end
    else
        game:GetAuthMgr():ShowImportantDialog(Lang("NET_CLOSED_BY_SERVER"), function()
            game:GetAuthMgr():LogoutToAccount()
        end)
    end
end

local l_onSwitchSceneFailedHandlers = function()
    logError("SwitchSceneFailed")
    local l_txt = Common.Utils.Lang("NET_CLOSED_BY_SERVER")
    game:GetAuthMgr():ShowImportantDialog(l_txt, function()
        game:GetAuthMgr():LogoutToGame()
    end)
end

local l_OnLuaDoEnterSceneHandlers = function(msg)
    ---@type DoEnterSceneRes
    local l_info = ParseProtoBufToTable("DoEnterSceneRes", msg)
    game:OnLuaDoEnterScene(l_info)
    --Data.DeadDlgModel:OnLuaDoEnterScene(l_info) --todo@马鑫 统一改为datamgr
end
--#endregion 周期类

Network.Handler.RpcHandlers = l_rpcHandlers
Network.Handler.PtcHandlers = l_ptcHandlers
Network.Handler.OnConnectedHandlers = l_onConnectedHandlers
Network.Handler.OnConnectFailedHandlers = l_onConnectFailedHandlers
Network.Handler.OnClosedHandlers = l_onClosedHandlers
Network.Handler.OnReconnectedHandlers = l_onReconnectedHandlers
Network.Handler.OnReconnectFailedHandlers = l_onReconnectFailedHandlers
Network.Handler.OnKickoutHandlers = l_onKickoutHandlers
Network.Handler.OnSwitchSceneFailedHandlers = l_onSwitchSceneFailedHandlers
Network.Handler.OnLuaDoEnterSceneHandlers = l_OnLuaDoEnterSceneHandlers