--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/BaseUITemplate"
--lua requires end

--lua model
module("UITemplate", package.seeall)

--lua model end

--lua fields
local super = UITemplate.BaseUITemplate
--lua fields end

--lua class define
---@class TeamDutySingleParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Tog_Selected MoonClient.MLuaUICom
---@field Label MoonClient.MLuaUICom
---@field IconBg MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom
---@field Checkmark MoonClient.MLuaUICom

---@class TeamDutySingle : BaseUITemplate
---@field Parameter TeamDutySingleParameter

TeamDutySingle = class("TeamDutySingle", super)
--lua class define end

--lua functions
function TeamDutySingle:Init()

    super.Init(self)
    self.DutyId = -1
    self.IsSelect = false
    self.canPick = false
    self.Parameter.Tog_Selected:AddClick(function()
        if self.gray then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Lang("TEAM_MATCH_CANT_PICK"),TableUtil.GetProfessionTable().GetRowById(MPlayerInfo.ProfessionId).Name))
        end
        if self.DutyId ~= -1 and self.canPick then
            self.IsSelect = not self.IsSelect
            self.Parameter.Checkmark:SetActiveEx(self.IsSelect)
            self.MethodCallback(self.DutyId, self.IsSelect, self.ShowIndex)
        end
    end)
end --func end
--next--
function TeamDutySingle:BindEvents()

    -- do nothing

end --func end
--next--
function TeamDutySingle:OnDestroy()

    -- do nothing

end --func end
--next--
function TeamDutySingle:OnDeActive()

    -- do nothing

end --func end
--next--
function TeamDutySingle:OnSetData(data)

    self:_setData(data)

end --func end
--next--
--lua functions end

--lua custom scripts
---@param data TeamDutyTemplateParam
function TeamDutySingle:_setData(data)
    self.canPick = data.dutyOption.active and data.canPick
    self.gray = not data.dutyOption.active
    self.IsSelect = false
    self.DutyId = data.dutyOption.dutyID
    if nil == data then
        logError("[TeamDuty] invalid param")
        return
    end

    --self._onTogValueChange = data.onTogChange
    --self._onTogValueChangeSelf = data.onTogChangeSelf
    local config = TableUtil.GetMatchDutyTable().GetRowByID(data.dutyOption.dutyID)
    if nil == config then
        return
    end

    self.Parameter.Icon:SetSpriteAsync(config.Atlas, config.Icon)
    self.Parameter.Icon.Img:SetNativeSize()
    self.Parameter.Label.LabText = config.DutyName
    local active = data.dutyOption.active
    self.Parameter.Icon:SetGray(not active)
    self.Parameter.IconBg:SetGray(not active)
    self.Parameter.Label:SetGray(not active)
    self.Parameter.Checkmark:SetActiveEx(self.IsSelect)
end

function TeamDutySingle:OnSelect()
    self.IsSelect = true
    self.Parameter.Checkmark:SetActiveEx(self.IsSelect)

end

function TeamDutySingle:OnDeselect()
    self.IsSelect = false
    self.Parameter.Checkmark:SetActiveEx(self.IsSelect)
end

--lua custom scripts end
return TeamDutySingle