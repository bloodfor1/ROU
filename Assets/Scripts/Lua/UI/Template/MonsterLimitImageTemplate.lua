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
---@class MonsterLimitImageTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field MonsterLimitText MoonClient.MLuaUICom

---@class MonsterLimitImageTemplate : BaseUITemplate
---@field Parameter MonsterLimitImageTemplateParameter

MonsterLimitImageTemplate = class("MonsterLimitImageTemplate", super)
--lua class define end

--lua functions
function MonsterLimitImageTemplate:Init()
	
	    super.Init(self)
	
end --func end
--next--
function MonsterLimitImageTemplate:OnDeActive()
	
	
end --func end
--next--
function MonsterLimitImageTemplate:OnSetData(data)
	
	local levelLimitText = StringEx.Format(Lang("ILLUSTRATION_MONSTER_LEVEL_LIMIT_TEXT"), data.startLevel, data.endLevel)
	self.Parameter.MonsterLimitText.LabText = levelLimitText
	
end --func end
--next--
function MonsterLimitImageTemplate:BindEvents()
	
	
end --func end
--next--
function MonsterLimitImageTemplate:OnDestroy()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return MonsterLimitImageTemplate