--this file is gen by script
--you can edit this file in custom part

--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/TeamMemberDutyChoicePanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
TeamMemberDutyChoiceCtrl = class("TeamMemberDutyChoiceCtrl", super)
--lua class define end

--lua functions
function TeamMemberDutyChoiceCtrl:ctor()
    super.ctor(self, CtrlNames.TeamMemberDutyChoice, UILayer.Function, nil, ActiveType.Standalone)
end --func end
--next--
function TeamMemberDutyChoiceCtrl:Init()
    self.panel = UI.TeamMemberDutyChoicePanel.Bind(self)
    super.Init(self)
    self.panel.CloseButton:AddClick(function()
        MgrMgr:GetMgr("TeamLeaderMatchMgr").SetSlotDuty(self.slotId, self.dutyID)
        MgrMgr:GetMgr("TeamLeaderMatchMgr").SetFirstTimeDirty()
        UIMgr:DeActiveUI(UI.CtrlNames.TeamMemberDutyChoice)
    end)
    self:_initConfig()
    self:_initWidgets()
end --func end
--next--
function TeamMemberDutyChoiceCtrl:Uninit()
    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function TeamMemberDutyChoiceCtrl:OnActive()
    local param = self.uiPanelData
    self:_onActive(param)
end --func end
--next--
function TeamMemberDutyChoiceCtrl:OnDeActive()
    -- do nothing
end --func end
--next--
function TeamMemberDutyChoiceCtrl:Update()
    -- do nothing
end --func end
--next--
function TeamMemberDutyChoiceCtrl:BindEvents()
    -- do nothing
end --func end
--next--
--lua functions end

--lua custom scripts

function TeamMemberDutyChoiceCtrl:_initConfig()
    self._memberDutyConfig = {
        TemplateClassName = "TeamDutySingle",
        TemplatePath = "UI/Prefabs/TeamDutySingle",
        TemplateParent = self.panel.Parent.transform,
        Method = function(dutyID, isOn, showIndex)
            self:_onTogValueChanged(dutyID, isOn, showIndex)
        end
    }
    self.slotId = 0
    self.dutyID = 0
end

function TeamMemberDutyChoiceCtrl:_initWidgets()
    self._options = self:NewTemplatePool(self._memberDutyConfig)
end

---@param data TeamSingleSlotOption
function TeamMemberDutyChoiceCtrl:_onActive(data)
    if nil == data then
        logError("[TeamDuty] invalid data")
        return
    end
    self.slotId = data.showIdx
    local EDutyType = GameEnum.ETeamDuty
    ---@type TeamIconParam[]
    local paramList = {}
    for i = EDutyType.Tank, EDutyType.Attack do
        local singleType = i
        ---@type TeamDutyShowPair
        local singleParam = {
            dutyID = singleType,
            active = true,
        }

        table.insert(paramList, { dutyOption = singleParam ,canPick = true})
    end
    --EDutyType.Free 放在最后 特殊需求 添加特判
    local singleParam = {
        dutyID = EDutyType.Free,
        active = true,
    }
    table.insert(paramList,{dutyOption = singleParam ,canPick = true})
    local paramWrap = { Datas = paramList }
    self._options:ShowTemplates(paramWrap)
end

function TeamMemberDutyChoiceCtrl:_onTogValueChanged(dutyID, isOn, showIndex)
    self._options:SelectTemplate(showIndex)
    self.dutyID = dutyID
    MgrMgr:GetMgr("TeamLeaderMatchMgr").SetSlotDuty(self.slotId, self.dutyID)
    MgrMgr:GetMgr("TeamLeaderMatchMgr").SetFirstTimeDirty()
    UIMgr:DeActiveUI(UI.CtrlNames.TeamMemberDutyChoice)
end

--lua custom scripts end
return TeamMemberDutyChoiceCtrl