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
---@class DisplacerPropertyItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Prefab MoonClient.MLuaUICom

---@class DisplacerPropertyItemTemplate : BaseUITemplate
---@field Parameter DisplacerPropertyItemTemplateParameter

DisplacerPropertyItemTemplate = class("DisplacerPropertyItemTemplate", super)
--lua class define end

--lua functions
function DisplacerPropertyItemTemplate:Init()
	
	    super.Init(self)
	
end --func end
--next--
function DisplacerPropertyItemTemplate:OnDeActive()
	
	
end --func end
--next--
function DisplacerPropertyItemTemplate:OnSetData(data)
	
	    self.Parameter.Prefab.LabText = data.description
	    --BUFF描述为橙色 材料二说明为灰色
	    if data.isBuff then 
	        self.Parameter.Prefab.LabColor = Color.New(217/255.0, 122/255.0, 46/255.0)
	    else
	        self.Parameter.Prefab.LabColor = Color.New(151/255.0, 152/255.0, 153/255.0)
	    end
	
end --func end
--next--
function DisplacerPropertyItemTemplate:BindEvents()
	
	
end --func end
--next--
function DisplacerPropertyItemTemplate:OnDestroy()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return DisplacerPropertyItemTemplate