--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseHandler"
require "UI/Panel/SelectElementShowActionPanel"




require "UI/Template/SelectElementShowActionTemplate"




--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseHandler
SelectElementShowActionHandler = class("SelectElementShowActionHandler", super)
--lua class define end

--lua functions
function SelectElementShowActionHandler:ctor()

    super.ctor(self, HandlerNames.SelectElementShowAction, 0)

end --func end
--next--
function SelectElementShowActionHandler:Init()

    self.panel = UI.SelectElementShowActionPanel.Bind(self)
    super.Init(self)

    self.single_action_pool = self:NewTemplatePool({
        UITemplateClass = UITemplate.SelectElementShowActionTemplate,
        TemplateParent = self.panel.SingleActionContent.transform,
        TemplatePrefab = self.panel.SelectElementShowAction.BtnSingleInstance.gameObject,
        ScrollRect = self.panel.Scroll1.LoopScroll,
    })

    self.multiple_action_pool = self:NewTemplatePool({
        UITemplateClass = UITemplate.SelectElementShowActionTemplate,
        TemplateParent = self.panel.MultActionContent.transform,
        TemplatePrefab = self.panel.SelectElementShowAction.BtnSingleInstance.gameObject,
        ScrollRect = self.panel.Scroll2.LoopScroll,
    })

    self.target_info = nil
end --func end
--next--
function SelectElementShowActionHandler:Uninit()

    self.single_action_pool = nil
    self.multiple_action_pool = nil
    self.target_info = nil

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function SelectElementShowActionHandler:OnActive()

    local l_single_action_data = {}
    local l_multiple_action_data = {}

    local l_actionTable = TableUtil.GetShowActionTable().GetTable()
    for _,row in pairs(l_actionTable) do
        local l_useSex = row.UseSex
        local l_sex = MPlayerInfo.IsMale
        if l_useSex == 0 or (l_useSex == 1 and l_sex == true) or (l_useSex == 2 and l_sex == false) then
            if row.Type == 0 then
                if row.ID == 2 then
                    -- 时尚评分屏蔽躺下动作
                    if not MgrMgr:GetMgr("FashionRatingMgr").IsFashionRatingPhoto then
                        table.insert(l_single_action_data, row)
                    end
                else
                    table.insert(l_single_action_data, row)
                end
            else
                table.insert(l_multiple_action_data, row)
            end
        end
    end

    self.single_action_pool:ShowTemplates({Datas = l_single_action_data, Method = function(row)
        self:ShowAction(row)
    end})

    self.multiple_action_pool:ShowTemplates({Datas = l_multiple_action_data, Method = function(row)
        self:ShowAction(row)
    end})

    self:RequestTargetInfo()
end --func end
--next--
function SelectElementShowActionHandler:OnDeActive()

end --func end
--next--
function SelectElementShowActionHandler:Update()


end --func end


--next--
function SelectElementShowActionHandler:BindEvents()

    --dont override this function
    self:BindEvent(MgrMgr:GetMgr("TeamMgr").EventDispatcher,DataMgr:GetData("TeamData").ON_GET_PLAYER_TEAM_FRIEND_INFO,function(self, teamFriendInfo)
        self:RefreshPlayerMenuTeam(teamFriendInfo)
    end)

    self:BindEvent(MgrMgr:GetMgr("FriendMgr").EventDispatcher,MgrMgr:GetMgr("FriendMgr").AddFriendEvent,function()
        self:RequestTargetInfo()
    end)

    self:BindEvent(MgrMgr:GetMgr("FriendMgr").EventDispatcher,MgrMgr:GetMgr("FriendMgr").IntimacyDegreeChangeEvent,function()
        self:RequestTargetInfo()
    end)

    self:BindEvent(MgrMgr:GetMgr("FriendMgr").EventDispatcher,MgrMgr:GetMgr("FriendMgr").FriendStageChangeEvent,function()
        self:RequestTargetInfo()
    end)

    self:BindEvent(MgrMgr:GetMgr("PlayerInfoMgr").EventDispatcher,MgrMgr:GetMgr("PlayerInfoMgr").SET_MAIN_TARGET_EVENT,function(_, uid, name, lv, isRole)
        if isRole then
            MgrMgr:GetMgr("MultipleActionMgr").SetTargetInfo(uid, lv)
            self:RequestTargetInfo()
        else
            MgrMgr:GetMgr("MultipleActionMgr").ClearCacheTargetInfo()
            self.target_info = nil
        end
    end)
end --func end
--next--
--lua functions end

--lua custom scripts

function SelectElementShowActionHandler:ProcessSingleAction(row)

    local l_state = self:CheckActionUnLockedByRow(row, MPlayerInfo.Lv)
    if not l_state then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("NEED") .. Lang("BASE_LEVEL_LIMIT", row.BaseLevel))
        return
    end

    MgrMgr:GetMgr("MultipleActionMgr").ProcessSingleAction(row.Action, row.ID)
end

function SelectElementShowActionHandler:ProcessMultipleAction(row)

    if row then
        --状态互斥 双人片段判断
        if row.Type == 2 then
            if not StateExclusionManager:GetIsCanChangeState(MExlusionStates.State_X_CoupleActionFragment) then
                return
            end
        else --状态互斥 双人持续判断
            if not StateExclusionManager:GetIsCanChangeState(MExlusionStates.State_X_CoupleActionContinue) then
                return
            end
        end
    else
        return
    end

    local l_target_id, l_target_lv, flag = MgrMgr:GetMgr("MultipleActionMgr").GetTargetInfo()
    if (not l_target_id) or (tonumber(tostring(l_target_id)) <= 0) then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("MULTIPLE_ACTION_SELECT"))
        return
    end

    if flag then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ErrStateAGToStateOthers"))
        return
    end

    -- 检查等级是否足够
    local l_result = self:CheckActionUnLockedByRow(row, MPlayerInfo.Lv)
    if not l_result then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("NEED") .. Lang("BASE_LEVEL_LIMIT", row.BaseLevel))
        return
    end

    -- 检查对方的等级是否足够
    local l_result = self:CheckActionUnLockedByRow(row, l_target_lv)
    if not l_result then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("NEED") .. Lang("MULTIPLE_ACTION_TARGET") .. Lang("BASE_LEVEL_LIMIT", row.BaseLevel))
        return
    end

    self.target_info = nil
    if row.FriendIntimacy > 0 then
        -- 检查是否是好友,好友度服务器检查
        if self.target_info then
            if not self.target_info.is_friend then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("MULTIPLE_ACTION_FRIEND_LIMIT"))
                return
            end

            if self.target_info.intimacy_degree < row.FriendIntimacy then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("MULTIPLE_ACTION_FRIEND_INTIMACY_LIMIT", row.FriendIntimacy - self.target_info.intimacy_degree))
                return
            end
        end
    end

    if row.Type == 1 then
        -- 组队判定
        local l_self_inteam = DataMgr:GetData("TeamData").GetUserIsInTeamAndSceneId(tostring(MPlayerInfo.UID))
        local l_target_inteam = DataMgr:GetData("TeamData").GetUserIsInTeamAndSceneId(tostring(l_target_id))
        if not l_self_inteam or not l_target_inteam then
            CommonUI.Dialog.ShowYesNoDlg(true, nil, Lang("MULTIPLE_ACTION_NEED_TEAM"), function()

                MgrMgr:GetMgr("TeamMgr").InviteJoinTeam(l_target_id)
            end)
            return
        end
    end


    MgrMgr:GetMgr("MultipleActionMgr").RequestMultipleAction(l_target_id, row.ID)

    --跟随中 播放单人动作 停止跟随
    if DataMgr:GetData("TeamData").Isfollowing then
        MgrMgr:GetMgr("TeamMgr").FollowSet(false)
    end
end

function SelectElementShowActionHandler:ShowAction(row)

    if MgrMgr:GetMgr("MultipleActionMgr").CheckLimitScene(row) then
        log("Scene Limited", MScene.SceneID)
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("MULTIPLE_ACTION_SCENE_LIMIT"))
        return
    end

    if row.Type == 0 then
        self:ProcessSingleAction(row)
    else
        self:ProcessMultipleAction(row)
    end
end


function SelectElementShowActionHandler:RefreshPlayerMenuTeam(data)

    self.target_info = nil
    --如果点的是自己则好友按钮和组队按钮均不显示
    if tostring(self.uid) == tostring(MPlayerInfo.UID) then
        return
    end

    self.target_info = data
end

function SelectElementShowActionHandler:RequestTargetInfo()

    local l_target_id = MgrMgr:GetMgr("MultipleActionMgr").GetTargetInfo()
    if l_target_id then
        MgrMgr:GetMgr("TeamMgr").GetUserInTeamOrNot(l_target_id)
    end
end


-- 检查动作时候已经解锁
function SelectElementShowActionHandler:CheckActionUnLockedByRow(row, lv)

    local l_result = true

    if not row then
        logError("CheckActionUnLockedByRow fail, row is null")
        l_result = false
    else
        local l_base = lv
        if row.BaseLevel > l_base then
            l_result = false
        end
    end

    return l_result
end

--lua custom scripts end
