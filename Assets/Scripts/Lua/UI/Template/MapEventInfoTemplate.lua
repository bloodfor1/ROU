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
---@class MapEventInfoTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_EventInfoTxtArray MoonClient.MLuaUICom
---@field Img_EventInfoImgArray MoonClient.MLuaUICom

---@class MapEventInfoTemplate : BaseUITemplate
---@field Parameter MapEventInfoTemplateParameter

MapEventInfoTemplate = class("MapEventInfoTemplate", super)
--lua class define end

--lua functions
function MapEventInfoTemplate:Init()
	
	super.Init(self)
	
end --func end
--next--
function MapEventInfoTemplate:OnDestroy()
	
	
end --func end
--next--
function MapEventInfoTemplate:OnDeActive()
	
	
end --func end
--next--
function MapEventInfoTemplate:OnSetData(data)
	
	if data==nil then return end
	self.Parameter.Txt_EventInfoTxtArray.LabText=data.desc
	
end --func end
--next--
function MapEventInfoTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return MapEventInfoTemplate