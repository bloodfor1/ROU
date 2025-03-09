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
---@class MerchantPathTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Path MoonClient.MLuaUICom

---@class MerchantPathTemplate : BaseUITemplate
---@field Parameter MerchantPathTemplateParameter

MerchantPathTemplate = class("MerchantPathTemplate", super)
--lua class define end

--lua functions
function MerchantPathTemplate:Init()
	
	super.Init(self)
	
end --func end
--next--
function MerchantPathTemplate:OnDestroy()
	
	
end --func end
--next--
function MerchantPathTemplate:OnDeActive()
	
	
end --func end
--next--
function MerchantPathTemplate:OnSetData(data)
	
	self:CustomSetData(data)
	
end --func end
--next--
function MerchantPathTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function MerchantPathTemplate:CustomSetData(data)

	local l_showPathCom = self.Parameter.Path.gameObject:GetComponent("MShowPathNode")
	l_showPathCom.OriginPosition = Vector3.New(data.from[1], data.from[2], 0)
	l_showPathCom.DestinationPostion = Vector3.New(data.to[1], data.to[2], 0)
	l_showPathCom:ShowPath()
end
--lua custom scripts end
return MerchantPathTemplate