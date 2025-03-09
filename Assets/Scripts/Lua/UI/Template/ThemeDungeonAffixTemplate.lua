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
---@class ThemeDungeonAffixTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Affix MoonClient.MLuaUICom

---@class ThemeDungeonAffixTemplate : BaseUITemplate
---@field Parameter ThemeDungeonAffixTemplateParameter

ThemeDungeonAffixTemplate = class("ThemeDungeonAffixTemplate", super)
--lua class define end

--lua functions
function ThemeDungeonAffixTemplate:Init()
	
	    super.Init(self)
	
end --func end
--next--
function ThemeDungeonAffixTemplate:OnDestroy()
	
	
end --func end
--next--
function ThemeDungeonAffixTemplate:OnDeActive()
	
	
end --func end
--next--
function ThemeDungeonAffixTemplate:OnSetData(...)
	
	    self:CustomSetData(...)
	
end --func end
--next--
function ThemeDungeonAffixTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function ThemeDungeonAffixTemplate:CustomSetData(id)
    
    local l_affixRow = TableUtil.GetAffixTable().GetRowById(id)
    
    self.Parameter.Affix:SetSprite("Buffbox", l_affixRow.AffixIcon)
end
--lua custom scripts end
return ThemeDungeonAffixTemplate