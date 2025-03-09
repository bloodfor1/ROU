--this file is gen by script
--you can edit this file in custom part

--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/QuickPanelPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
QuickPanelCtrl = class("QuickPanelCtrl", super)
--lua class define end

--lua functions
function QuickPanelCtrl:ctor()
    super.ctor(self, CtrlNames.QuickPanel, UILayer.Normal, UITweenType.Right, ActiveType.Normal)
    self.cacheGrade = EUICacheLv.VeryLow
end --func end
--next--
function QuickPanelCtrl:Init()
    self.panel = UI.QuickPanelPanel.Bind(self)
    super.Init(self)
    self.tweenId=0
    self:AddHandlerToToggleEx(HandlerNames.QuickTaskPanel, self.panel.ToggleTask, "ActiveTask", self.panel.QuickPanel.gameObject.transform)
    self:AddHandlerToToggleEx(HandlerNames.QuickTeamPanel, self.panel.ToggleTeam, "ActiveTeam", self.panel.QuickPanel.gameObject.transform)
    self:AddHandlerToToggleEx(HandlerNames.QuickBattleLogPanel, self.panel.ToggleBattle, "ActiveBattleLog", self.panel.QuickPanel.gameObject.transform)
    self:CustomInit()
    self.RedSignProcessorTeamAndTask = self:NewRedSign({
        Key = eRedSignKey.TeamAndTask,
        RedSignParent = self.panel.RedSignParentTeamAndTask.Transform
    })
    self.RedSignProcessorTeam = self:NewRedSign({
        Key = eRedSignKey.Team,
        RedSignParent = self.panel.RedSignParentTeam.Transform
    })
    self.panel.ToggleTask.TogEx.isOn = true
end --func end
--next--
function QuickPanelCtrl:Uninit()
    self.RedSignProcessorTeamAndTask = nil
    self.RedSignProcessorTeam = nil
    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function QuickPanelCtrl:OnActive()
    local l_isBattleStatisticOpen = MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(141)
    --版本需求 战斗统计按钮同是否打开GM处理
    if MGameContext.IsOpenGM and l_isBattleStatisticOpen then
        if MgrMgr:GetMgr("DungeonMgr").CheckPlayerInDungeon() then
            if self.panel.ToggleBattle.TogEx.isOn then
                self.panel.ToggleTeam.TogEx.isOn = true
            end
            self.panel.ToggleBattle.gameObject:SetActiveEx(false)
        else
            self.panel.ToggleBattle.gameObject:SetActiveEx(true)
        end
    else
        self.panel.ToggleBattle.gameObject:SetActiveEx(false)
    end
    self:FreshTeamNum()
end --func end
--next--
function QuickPanelCtrl:OnDeActive()
    --self.selected = ""
    --self.panel.ToggleTask.TogEx.isOn = false
    self:UnInitToggles()
end --func end
--next--
function QuickPanelCtrl:Update()
    super.Update(self)

end --func end
--next--
function QuickPanelCtrl:Refresh()


end --func end
--next--
function QuickPanelCtrl:OnLogout()
    if self.selected ~= "Task" then
        self.panel.ToggleTask.TogEx.isOn = true
    end
end --func end
--next--
function QuickPanelCtrl:OnShow()

end --func end
--next--
function QuickPanelCtrl:OnHide()

end --func end
--next--
function QuickPanelCtrl:BindEvents()

    local l_logoutMgr = MgrMgr:GetMgr("LogoutMgr")
    self:BindEvent(l_logoutMgr.EventDispatcher, l_logoutMgr.OnLogoutEvent, self.OnLogout)
    self:BindEvent(GlobalEventBus, EventConst.Names.RefreshQuickTaskPanel,
        function(self)
            if self.selected == "Task" and self.panel.ToggleTask.TogEx.isOn == true then
                return
            end
        end)
    --刷新左侧列表按钮至组队页签
    local NewMemberFunc = function()
        local stage = StageMgr:GetCurStageEnum()
        if not (stage == MStageEnum.ArenaPre or stage == MStageEnum.Arena) then
            self:QuickFreshTeam()
        end
    end
    self:BindEvent(MgrMgr:GetMgr("TeamMgr").EventDispatcher, DataMgr:GetData("TeamData").ON_NEW_TEAM_MEMBER, NewMemberFunc)
    self:BindEvent(MgrMgr:GetMgr("BeginnerGuideMgr").EventDispatcher, MgrMgr:GetMgr("BeginnerGuideMgr").QUICK_TASK_GUIDE_EVENT, function(self, guideStepInfo)
        self:ShowBeginnerGuide(guideStepInfo)
    end)
    local l_openSysMgr = MgrMgr:GetMgr("OpenSystemMgr")
    self:BindEvent(l_openSysMgr.EventDispatcher, l_openSysMgr.OpenSystemUpdate, function(self)
        local l_isBattleStatisticOpen = l_openSysMgr.IsSystemOpen(141)
        self.panel.ToggleBattle.gameObject:SetActiveEx(l_isBattleStatisticOpen and MGameContext.IsOpenGM)
        if self.selected == "Task" or self.selected == "" then
            if self.panel.ToggleTask.TogEx.isOn ~= true then
                self.panel.ToggleTask.TogEx.isOn = true
            end
        elseif self.selected == "Team" then
            if self.panel.ToggleTeam.TogEx.isOn ~= true then
                self.panel.ToggleTeam.TogEx.isOn = true
            end
        else
            if self.panel.ToggleBattle.TogEx.isOn ~= true then
                self.panel.ToggleBattle.TogEx.isOn = true
            end
        end
    end)
    self:BindEvent(MgrMgr:GetMgr("TeamMgr").EventDispatcher, DataMgr:GetData("TeamData").ON_TEAM_INFO_UPDATE, self.FreshTeamNum)
end --func end

--next--
--lua functions end

--lua custom scripts
function QuickPanelCtrl:CustomInit()
    --缩进按钮
    self.isTweenLeft = true
    self.panel.RedSignParentTeamAndTask:SetActiveEx(false)
    self.panel.shrink_btn:AddClick(function()
        if self.isTweenLeft then
            self:TweenToLeft()
            self.isTweenLeft = false
            self.panel.shrink_btn.transform.localRotation = Vector3.New(0, 0, 180)
            self.panel.RedSignParentTeamAndTask:SetActiveEx(true)
        else
            self:TweenToRight()
            self.isTweenLeft = true
            self.panel.shrink_btn.transform.localRotation = Vector3.New(0, 0, 0)
            self.panel.RedSignParentTeamAndTask:SetActiveEx(false)
            if MgrMgr:GetMgr("TeamMgr").CheckRedSignMethod() > 0 then
                self.panel.ToggleTeam.TogEx.isOn = true
            end
        end
    end)

end

function QuickPanelCtrl:ToggleFunc(funcName, value)
    --log(funcName, value)
    if funcName == "ActiveTask" then
        self:ActiveTask(value)
    elseif funcName == "ActiveTeam" then
        self:ActiveTeam(value)
    elseif funcName == "ActiveBattleLog" then
        self:ActiveBattleLog(value)
    end
end

function QuickPanelCtrl:ActiveTask(value)
    if value then
        if self.selected == "Task" then
            UIMgr:ActiveUI(UI.CtrlNames.Task)
            return
        end

        self.selected = "Task"
        local handler = UIMgr:GetHandler(UI.CtrlNames.QuickPanel, UI.HandlerNames.QuickTaskPanel)
        if handler then
            handler:RefreshTaskPanel()
        end
    else
        self.selected = ""
    end
end
function QuickPanelCtrl:ActiveTeam(value)
    if value then
        if self.selected == "Team" then
            MgrMgr:GetMgr("TeamMgr").ShowTeamView()
            return
        end

        self.selected = "Team"
        local handler = UIMgr:GetHandler(UI.CtrlNames.QuickPanel, UI.HandlerNames.QuickTeamPanel)
        if handler then
            handler:RefreshTeamPanel()
        end
    else
        self.selected = ""
    end
end
function QuickPanelCtrl:ActiveBattleLog(value)
    if value then
        if self.selected == "BattleLog" then
            UIMgr:ActiveUI(UI.CtrlNames.BattleStatistics)
            return
        end

        self.selected = "BattleLog"
        MgrMgr:GetMgr("BattleStatisticsMgr").BattleRevenueReq()
    else
        self.selected = ""
    end
end

function QuickPanelCtrl:UnInitToggles()
end

function QuickPanelCtrl:HideAllTask()
    local handler = UIMgr:GetHandler(UI.CtrlNames.QuickPanel, UI.HandlerNames.QuickTaskPanel)
    if handler then
        handler:HideAllTask()
    end
end

function QuickPanelCtrl:TweenToLeft()
    if self.tweenId > 0 then
        MUITweenHelper.KillTween(self.tweenId)
        self.tweenId = 0
    end
    --self.panel.shrink_btn.gameObject:SetActiveEx(false)
    local gameObject = self.panel.QuickPanel.gameObject
    local srcPos = gameObject.transform.localPosition
    local destPos = gameObject.transform.localPosition
    destPos.x = destPos.x - 32
    local callBack = function()
        MLuaCommonHelper.SetLocalPos(gameObject, 0, 0, 0)
        self.tweenId = 0
        self:HideAllTask()
        --MLuaCommonHelper.SetRectTransformPos(self.panel.shrink_btn.gameObject, 30, -162)
        self.panel.shrink_btn.gameObject:SetActiveEx(true)
        self.panel.QuickPanel.gameObject.gameObject:SetActiveEx(false)
    end
    self.tweenId = MUITweenHelper.TweenPosAlpha(gameObject, srcPos, destPos, 1, 0, 0.3, callBack)
end

function QuickPanelCtrl:TweenToRight()
    if self.tweenId > 0 then
        MUITweenHelper.KillTween(self.tweenId)
        self.tweenId = 0
    end
    --self.panel.shrink_btn.gameObject:SetActiveEx(false)
    self.panel.QuickPanel.gameObject.gameObject:SetActiveEx(true)
    local gameObject = self.panel.QuickPanel.gameObject
    local srcPos = gameObject.transform.localPosition
    local destPos = gameObject.transform.localPosition
    srcPos.x = srcPos.x - 32
    local callBack = function()
        MLuaCommonHelper.SetLocalPos(gameObject, 0, 0, 0)
        self.tweenId = 0
        --MLuaCommonHelper.SetRectTransformPos(self.panel.shrink_btn.gameObject, 227.5, -162)
        self.panel.shrink_btn.gameObject:SetActiveEx(true)
    end
    self.tweenId = MUITweenHelper.TweenPosAlpha(gameObject, srcPos, destPos, 0, 1, 0.3, callBack)
    local handler = UIMgr:GetHandler(UI.CtrlNames.QuickPanel, UI.HandlerNames.QuickTaskPanel)
    if handler then
        handler:RefreshTaskPanel()
    end

end
--展示快捷任务面板的新手指引  这里只负责切换到任务面板 具体展示由QuickTaskPanelHandler负责
function QuickPanelCtrl:ShowBeginnerGuide(guideStepInfo)
    --如果被隐藏则显示
    if not self.isTweenLeft then
        self:TweenToRight()
        self.isTweenLeft = true
        self.panel.shrink_btn.transform.localRotation = Vector3.New(0, 0, 0)
        self.panel.RedSignParentTeamAndTask:SetActiveEx(false)
        if MgrMgr:GetMgr("TeamMgr").CheckRedSignMethod() > 0 then
            self.panel.ToggleTeam.TogEx.isOn = true
        end
    end
    --如果目前是组队面板则切换
    if self.selected ~= "Task" then
        self.panel.ToggleTask.TogEx.isOn = true
        self.selected = "Task"
        local handler = UIMgr:GetHandler(UI.CtrlNames.QuickPanel, UI.HandlerNames.QuickTaskPanel)
        if handler then
            handler:RefreshTaskPanel()
        end
    end
end

function QuickPanelCtrl:SetButton(txt, state)
    if state then
        txt.LabColor = Color.New(255 / 255, 255 / 255, 255 / 255, 1)
    else
        txt.LabColor = Color.New(111 / 255, 111 / 255, 111 / 255, 1)
    end
end

--刷新到组队小界面
function QuickPanelCtrl:QuickFreshTeam()
    self.panel.ToggleTeam.TogEx.isOn = true
end

function QuickPanelCtrl:FreshTeamNum()
    local teamData = DataMgr:GetData("TeamData")
    if teamData.myTeamInfo.captainId ~= -1 then
        self.panel.MemberNumBg:SetActiveEx(true)
        self.panel.MemberNumTxt.LabText = #teamData.myTeamInfo.memberList
    else
        self.panel.MemberNumBg:SetActiveEx(false)
    end
end
--lua custom scripts end
return QuickPanelCtrl