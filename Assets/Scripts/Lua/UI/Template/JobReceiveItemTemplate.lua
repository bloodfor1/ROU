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
---@class JobReceiveItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Icon MoonClient.MLuaUICom
---@field Text MoonClient.MLuaUICom

---@class JobReceiveItemTemplate : BaseUITemplate
---@field Parameter JobReceiveItemTemplateParameter

JobReceiveItemTemplate = class("JobReceiveItemTemplate", super)
--lua class define end

--lua functions
function JobReceiveItemTemplate:Init()
	
	super.Init(self)
	
end --func end
--next--
function JobReceiveItemTemplate:OnDestroy()
	
	
end --func end
--next--
function JobReceiveItemTemplate:OnDeActive()
	
	
end --func end
--next--
function JobReceiveItemTemplate:OnSetData(data)
	
	self.Parameter.Icon:SetSpriteAsync(data.atlas, data.sprite)
	local v = data.attr
	local attr = {type = v[0], id = v[1], val = v[2]}
	self.Parameter.Text.LabText = MgrMgr:GetMgr("EquipMgr").GetAttrStrByData(attr)
	
end --func end
--next--
function JobReceiveItemTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return JobReceiveItemTemplate