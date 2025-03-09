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
---@class PrivilegeItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Title MoonClient.MLuaUICom
---@field Person MoonClient.MLuaUICom
---@field Describe MoonClient.MLuaUICom

---@class PrivilegeItemTemplate : BaseUITemplate
---@field Parameter PrivilegeItemTemplateParameter

PrivilegeItemTemplate = class("PrivilegeItemTemplate", super)
--lua class define end

--lua functions
function PrivilegeItemTemplate:Init()
	
	super.Init(self)
	
end --func end
--next--
function PrivilegeItemTemplate:BindEvents()
	
	
end --func end
--next--
function PrivilegeItemTemplate:OnDestroy()
	
	
end --func end
--next--
function PrivilegeItemTemplate:OnDeActive()
	
	
end --func end
--next--
function PrivilegeItemTemplate:OnSetData(data)
	self.Parameter.Person:SetSpriteAsync(data.PicAltas, data.PicName, nil, true)
	self.Parameter.Title.LabText = data.TitleText
	self.Parameter.Describe.LabText = data.ContentText
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return PrivilegeItemTemplate