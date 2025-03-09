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
---@class GuildBuildingScetionItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field ScetionAText MoonClient.MLuaUICom
---@field Prefab MoonClient.MLuaUICom

---@class GuildBuildingScetionItemTemplate : BaseUITemplate
---@field Parameter GuildBuildingScetionItemTemplateParameter

GuildBuildingScetionItemTemplate = class("GuildBuildingScetionItemTemplate", super)
--lua class define end

--lua functions
function GuildBuildingScetionItemTemplate:Init()
	
	super.Init(self)
	
end --func end
--next--
function GuildBuildingScetionItemTemplate:OnDeActive()
	
	
end --func end
--next--
function GuildBuildingScetionItemTemplate:OnSetData(data)
	
	self.Parameter.ScetionAText.LabText = data
	
end --func end
--next--
function GuildBuildingScetionItemTemplate:BindEvents()
	
	
end --func end
--next--
function GuildBuildingScetionItemTemplate:OnDestroy()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return GuildBuildingScetionItemTemplate