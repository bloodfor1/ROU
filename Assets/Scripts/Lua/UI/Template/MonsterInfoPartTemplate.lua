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
---@class MonsterInfoPartTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Halo MoonClient.MLuaUICom

---@class MonsterInfoPartTemplate : BaseUITemplate
---@field Parameter MonsterInfoPartTemplateParameter

MonsterInfoPartTemplate = class("MonsterInfoPartTemplate", super)
--lua class define end

--lua functions
function MonsterInfoPartTemplate:Init()
	
	    super.Init(self)
	
end --func end
--next--
function MonsterInfoPartTemplate:OnDeActive()
	
	
end --func end
--next--
function MonsterInfoPartTemplate:OnSetData(data)
	
	
end --func end
--next--
function MonsterInfoPartTemplate:BindEvents()
	
	
end --func end
--next--
function MonsterInfoPartTemplate:OnDestroy()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function MonsterInfoPartTemplate:ctor(data)
	if data == nil then
		data={}
	end
	data.TemplatePath = "UI/Prefabs/MonsterInfoPart"
    super.ctor(self, data)
end
--lua custom scripts end
return MonsterInfoPartTemplate