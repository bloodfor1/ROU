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
---@class ThemeDungeonAffixItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Title MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom
---@field Desc MoonClient.MLuaUICom
---@field AffixItem MoonClient.MLuaUICom

---@class ThemeDungeonAffixItemTemplate : BaseUITemplate
---@field Parameter ThemeDungeonAffixItemTemplateParameter

ThemeDungeonAffixItemTemplate = class("ThemeDungeonAffixItemTemplate", super)
--lua class define end

--lua functions
function ThemeDungeonAffixItemTemplate:Init()
	
	    super.Init(self)
	
end --func end
--next--
function ThemeDungeonAffixItemTemplate:OnDestroy()
	
	
end --func end
--next--
function ThemeDungeonAffixItemTemplate:OnDeActive()
	
	
end --func end
--next--
function ThemeDungeonAffixItemTemplate:OnSetData(...)
	
	    self:CustomSetData(...)
	
end --func end
--next--
function ThemeDungeonAffixItemTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function ThemeDungeonAffixItemTemplate:CustomSetData(id)
    
    local l_affixRow = TableUtil.GetAffixTable().GetRowById(id)
    
    self.Parameter.Icon:SetSprite("Buffbox", l_affixRow.AffixIcon)
    self.Parameter.Title.LabText = l_affixRow.Name
    self.Parameter.Desc.LabText = l_affixRow.Description
end
--lua custom scripts end
return ThemeDungeonAffixItemTemplate