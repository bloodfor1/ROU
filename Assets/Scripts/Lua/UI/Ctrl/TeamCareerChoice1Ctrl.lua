--this file is gen by script
--you can edit this file in custom part

--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/TeamCareerChoice1Panel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
local EMatchState = GameEnum.ETeamMatchOption
local teamMatchMgr = MgrMgr:GetMgr("TeamMatchOptionMgr")
local leaderMatchMgr = MgrMgr:GetMgr("TeamLeaderMatchMgr")
local tipsMgr = MgrMgr:GetMgr("TipsMgr")
--lua fields end

--lua class define
TeamCareerChoice1Ctrl = class("TeamCareerChoice1Ctrl", super)
--lua class define end

--lua functions
function TeamCareerChoice1Ctrl:ctor()
    super.ctor(self, CtrlNames.TeamCareerChoice1, UILayer.Function, nil, ActiveType.Exclusive)
end --func end
--next--
function TeamCareerChoice1Ctrl:Init()
    self.panel = UI.TeamCareerChoice1Panel.Bind(self)
    super.Init(self)
    self.teamSetting = nil
    self:_initConfig()
    self:_initWidgets()
    self.panel.Tog_ShowNextTime.Tog.onValueChanged:AddListener(function(isOn)
        teamMatchMgr.AutoPair = isOn
    end)
end --func end
--next--
function TeamCareerChoice1Ctrl:Uninit()
    super.Uninit(self)
    self.panel = nil
    self.teamSetting = nil
end --func end
--next--
function TeamCareerChoice1Ctrl:OnActive()
    self._playerDutyList = {}
    self:_onActive(self.uiPanelData)
end --func end
--next--
function TeamCareerChoice1Ctrl:OnDeActive()
    -- do nothing
end --func end
--next--
function TeamCareerChoice1Ctrl:Update()
    -- do nothing
end --func end
--next--
function TeamCareerChoice1Ctrl:BindEvents()
    self:BindEvent(MgrMgr:GetMgr("TeamLeaderMatchMgr").EventDispatcher, MgrMgr:GetMgr("TeamLeaderMatchMgr").LEADER_MATCH_SELECT_DUTY, self._refreshTeamTem)

end --func end
--next--
--lua functions end

--lua custom scripts

function TeamCareerChoice1Ctrl:_initConfig()
    leaderMatchMgr.SetDefaultDutyList()
    self._matchMap = {
        [EMatchState.MatchTeam] = self._setSingleMode,
        [EMatchState.MatchMember] = self._setTeamMode,
    }
    self._onConfirmFunc = {
        [EMatchState.MatchTeam] = self._onPlayerMatchConfirm,
        [EMatchState.MatchMember] = self._onLeaderMatchConfirm,
    }
    self._playerDutyList = {}
    self._currentState = EMatchState.None
    self._doNotShowNextTime = false
    self._memberDutyConfig = {
        TemplateClassName = "TeamDutySingle",
        TemplatePath = "UI/Prefabs/TeamDutySingle",
        TemplateParent = self.panel.Dummy_Career.transform,
        Method = function(dutyID, isOn)
            self:_onTogValueChanged(dutyID, isOn)
        end
    }
    self._memberTeamConfig = {
        TemplateClassName = "TeamMemberSingle",
        TemplatePath = "UI/Prefabs/TeamMemberSingle",
        TemplateParent = self.panel.Widget_Member.transform,
        Method = function(showIndex)
            self:_onDutyClick(showIndex)
        end
    }
end

function TeamCareerChoice1Ctrl:_initWidgets()
    self._playerDutyOptions = self:NewTemplatePool(self._memberDutyConfig)
    self._teamMemberOptions = self:NewTemplatePool(self._memberTeamConfig)
    local onCloseClick = function()
        self:_onClose()
    end

    local onConfirmClick = function()
        self:_onConfirm()
    end

    self.panel.ButtonClose:AddClick(onCloseClick)
    self.panel.Btn_Start:AddClick(onConfirmClick)
end

function TeamCareerChoice1Ctrl:_onClose()
    UIMgr:DeActiveUI(UI.CtrlNames.TeamCareerChoice1)
end

--- 响应tog发生变化
function TeamCareerChoice1Ctrl:_onTogValueChanged(dutyID, isOn)
    if nil == dutyID or nil == isOn then
        logError("[TeamDuty] invalid param", dutyID, isOn)
        return
    end
    if isOn then
        self._playerDutyList[dutyID] = 1
    else
        self._playerDutyList[dutyID] = nil
    end

    self:_updateDutyList()
end

function TeamCareerChoice1Ctrl:_onDoNotShowNextTime(isOn)
    self._doNotShowNextTime = isOn
end

function TeamCareerChoice1Ctrl:_onConfirm()
    local func = self._onConfirmFunc[self._currentState]
    if nil == func then
        logError("[TeamDuty] invalid state: " .. tostring(self._currentState))
        return
    end

    func(self)
    UIMgr:DeActiveUI(UI.CtrlNames.TeamCareerChoice1)
end

function TeamCareerChoice1Ctrl:_onPlayerMatchConfirm()
    if self._doNotShowNextTime then
        teamMatchMgr.AddDoNotShowHint()
    end

    local data = {}
    for dutyID, value in pairs(self._playerDutyList) do
        table.insert(data, dutyID)
    end
    if 0 >= #data then
        tipsMgr.ShowNormalTips(Common.Utils.Lang("TEAM_CAREER_CHOICE1"))
        return
    end
    local teamData = DataMgr:GetData("TeamData").myTeamInfo
    if teamData then
        local target = DataMgr:GetData("TeamData").autoPairTarget
        if target then
            if not DataMgr:GetData("TeamData").isAutoPair then
                MgrMgr:GetMgr("TeamMgr").AutoPairOperate(DataMgr:GetData("TeamData").EAutoPairType.autoTypeStart, target, data, teamMatchMgr.GetLeaderDefault())
            else
                MgrMgr:GetMgr("TeamMgr").AutoPairOperate(DataMgr:GetData("TeamData").EAutoPairType.autoTypeEnd, target)
            end
        end
    end

end

--- 写入数据
function TeamCareerChoice1Ctrl:_updateDutyList()
    local data = {}
    for dutyID, value in pairs(self._playerDutyList) do
        table.insert(data, dutyID)
    end
    teamMatchMgr.SetDutyList(data)
end

---@param option TeamMatchParam
function TeamCareerChoice1Ctrl:_onActive(option)
    if nil == option then
        logError("[TeamMatch] invalid param")
        return
    end

    self._currentState = option.state
    local func = self._matchMap[option.state]
    if nil == func then
        logError("[TeamMatch] invalid match state: " .. tostring(option.state))
        return
    end

    self:_resetState()
    func(self, option)
end

--- 重置所有状态
function TeamCareerChoice1Ctrl:_resetState()
    self.panel.Dummy_Career.gameObject:SetActiveEx(false)
    self.panel.Widget_Member.gameObject:SetActiveEx(false)
end

--- 设置单人模式
---@param option TeamMatchParam
function TeamCareerChoice1Ctrl:_setSingleMode(option)
    if nil == option then
        logError("[TeamMatch] invalid param")
        return
    end
    self.panel.TxtMsg.LabText = Common.Utils.Lang("TEAM_MATCH_CHOICE_SINGLE")
    self.panel.Dummy_Career.gameObject:SetActiveEx(true)
    local templateParam = {}
    local validDutyCount = 0
    local validIndex = 0
    local dutyMap = teamMatchMgr.GetTeamDutyOptions(option.profession)
    for i = 1, #dutyMap do
        local singleDutyConfig = dutyMap[i]
        ---@type TeamDutyTemplateParam
        local singleParam = {
            dutyOption = singleDutyConfig,
            onTogChangeSelf = self,
            canPick = true
        }

        table.insert(templateParam, singleParam)
        if singleDutyConfig.active then
            validDutyCount = validDutyCount + 1
            validIndex = i
        end
    end
    if validDutyCount == 1 then
        for i = 1, #templateParam do
            templateParam[i].canPick = false
        end
        local templateParamWrap = { Datas = templateParam }
        self._playerDutyOptions:ShowTemplates(templateParamWrap)
        self._playerDutyOptions:SelectTemplate(validIndex)
        self:_onTogValueChanged(validIndex, true)
    else
        local templateParamWrap = { Datas = templateParam }
        self._playerDutyOptions:ShowTemplates(templateParamWrap)
    end
    local showCheckBox = teamMatchMgr.ShowCheckBox()
    self.panel.Tog_ShowNextTime.gameObject:SetActiveEx(validDutyCount == 1)
    self.panel.Txt_Hint.gameObject:SetActiveEx(1 < validDutyCount)

    --self:_selectDefault(dutyMap)
end

--- 利用职责参数设置默认值
---@param dutyConfigList TeamDutyShowPair[]
function TeamCareerChoice1Ctrl:_selectDefault(dutyConfigList)
    if nil == dutyConfigList then
        logError("[TeamDuty] invalid param")
        return
    end

    local C_DEFAULT_VALUE = -1
    local defaultDutyIdx = C_DEFAULT_VALUE
    for i = 1, #dutyConfigList do
        local configPair = dutyConfigList[i]
        if configPair.active then
            if C_DEFAULT_VALUE == defaultDutyIdx then
                defaultDutyIdx = i
            else
                return
            end
        end
    end

    self._playerDutyOptions:SelectTemplate(defaultDutyIdx)
end

--- 设置多人模式
---@param option TeamMatchParam
function TeamCareerChoice1Ctrl:_setTeamMode(option)
    if nil == option then
        logError("[TeamMatch] invalid param")
        return
    end
    self.panel.Tog_ShowNextTime:SetActiveEx(false)
    self.panel.TxtMsg.LabText = Common.Utils.Lang("TEAM_MATCH_CHOICE_TEAMLEADER")
    self:_refreshTeamTem()

end

function TeamCareerChoice1Ctrl:_refreshTeamTem()
    self.panel.Widget_Member.gameObject:SetActiveEx(true)
    local param = leaderMatchMgr.GetMemberShowConfig()
    ---@type TeamIconParam[]
    local TemData = {}
    for i = 1, #param do
        local singleConfig = param[i]
        singleConfig.isEmptyPos = false
        table.insert(TemData, singleConfig)
    end
    for i = #param + 1, DataMgr:GetData("TeamData").maxTeamNumber do
        table.insert(TemData, { dutyID = leaderMatchMgr.GetSlotDuty(i), isEmptyPos = true, canpick = true })
    end
    local templateParam = { Datas = TemData }
    self._teamMemberOptions:ShowTemplates(templateParam)
end

--- 主面板上点击队员的槽位对应的回调，主要是弹出面板，而且要对面板设置数据
function TeamCareerChoice1Ctrl:_onDutyClick(idx)
    if nil == idx then
        logError("[TeamDuty] invalid param")
        return
    end

    ---@type TeamSingleSlotOption
    local param = {
        showIdx = idx,
        onDutySelected = self._onDutyChange,
        onDutySelectSelf = self,
    }

    UIMgr:ActiveUI(UI.CtrlNames.TeamMemberDutyChoice, param)
end

function TeamCareerChoice1Ctrl:_onDutyChange(slotIdx, dutyID)
    leaderMatchMgr.SetFirstTimeDirty()
    leaderMatchMgr.SetSlotDuty(slotIdx, dutyID)
end

---队长匹配队员模式下点击确认
function TeamCareerChoice1Ctrl:_onLeaderMatchConfirm()

    local data = {}
    local teamData = DataMgr:GetData("TeamData")
    local target = teamData.myTeamInfo.teamSetting.target
    for i = #teamData.myTeamInfo.memberList + 1, teamData.maxTeamNumber do
        table.insert(data, MgrMgr:GetMgr("TeamLeaderMatchMgr").GetSlotDuty(i))
    end
    MgrMgr:GetMgr("TeamMgr").AutoPairOperate(DataMgr:GetData("TeamData").EAutoPairType.autoTypeStart, target, data)
    UIMgr:DeActiveUI(UI.CtrlNames.TeamCareerChoice1)
end

--lua custom scripts end
return TeamCareerChoice1Ctrl