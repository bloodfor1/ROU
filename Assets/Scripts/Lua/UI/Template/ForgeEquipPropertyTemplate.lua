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
---@class ForgeEquipPropertyTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field PropertyText MoonClient.MLuaUICom
---@field EntryImage MoonClient.MLuaUICom

---@class ForgeEquipPropertyTemplate : BaseUITemplate
---@field Parameter ForgeEquipPropertyTemplateParameter

ForgeEquipPropertyTemplate = class("ForgeEquipPropertyTemplate", super)
--lua class define end

--lua functions
function ForgeEquipPropertyTemplate:Init()
    super.Init(self)
end --func end
--next--
function ForgeEquipPropertyTemplate:OnDestroy()
    -- do nothing
end --func end
--next--
function ForgeEquipPropertyTemplate:OnDeActive()
    -- do nothing
end --func end
--next--
function ForgeEquipPropertyTemplate:OnSetData(data)
    self.Parameter.PropertyText.LabText = data.Text
    self.Parameter.EntryImage:SetActiveEx(true)
end --func end
--next--
function ForgeEquipPropertyTemplate:BindEvents()
    -- do nothing
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return ForgeEquipPropertyTemplate