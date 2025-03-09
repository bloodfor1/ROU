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
---@class SelectEquipSuitTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field SelectEquipItemPrefab MoonClient.MLuaUICom
---@field Selected MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field GenreText MoonClient.MLuaUICom
---@field EquipIcon MoonClient.MLuaUICom

---@class SelectEquipSuitTemplate : BaseUITemplate
---@field Parameter SelectEquipSuitTemplateParameter

SelectEquipSuitTemplate = class("SelectEquipSuitTemplate", super)
--lua class define end

--lua functions
function SelectEquipSuitTemplate:Init()

    super.Init(self)
    self.SuitId = nil

end --func end
--next--
function SelectEquipSuitTemplate:OnDestroy()

    self.SuitId = nil

end --func end
--next--
function SelectEquipSuitTemplate:OnDeActive()
    -- do nothing
end --func end
--next--
function SelectEquipSuitTemplate:OnSetData(data)
    self:CustomSetData(data)
end --func end
--next--
function SelectEquipSuitTemplate:BindEvents()
    -- do nothing
end --func end
--next--
--lua functions end

--lua custom scripts
function SelectEquipSuitTemplate:CustomSetData(data)
    self.SuitId = data.SuitId
    self.Parameter.Name.LabText = data.Dec
    local l_recomand = MgrMgr:GetMgr("SuitMgr").GetRecommandInfo(data.RecommendSchool)
    if string.len(l_recomand) > 0 then
        self.Parameter.GenreText.LabText = StringEx.Format("Lv.{0} {1}", data.Level, Lang("SETTING_SYSTEM_FIT_QUALITY", l_recomand))
    else
        self.Parameter.GenreText.LabText = StringEx.Format("Lv.{0}", data.Level)
    end
    
    self:SetSelected(data.selected)
    self.Parameter.EquipIcon:SetSpriteAsync(data.ItemAtlas, data.ItemIcon, nil, true)
    self.Parameter.SelectEquipItemPrefab:AddClick(function()
        if self.MethodCallback then
            self.MethodCallback(data.SuitId)
        end
    end)
end

function SelectEquipSuitTemplate:SetSelected(flag)
    self.Parameter.Selected.gameObject:SetActiveEx(flag)
end

--lua custom scripts end
return SelectEquipSuitTemplate