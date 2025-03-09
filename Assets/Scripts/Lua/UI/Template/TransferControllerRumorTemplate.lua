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
---@class TransferControllerRumorTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Rumor MoonClient.MLuaUICom

---@class TransferControllerRumorTemplate : BaseUITemplate
---@field Parameter TransferControllerRumorTemplateParameter

TransferControllerRumorTemplate = class("TransferControllerRumorTemplate", super)
--lua class define end

--lua functions
function TransferControllerRumorTemplate:Init()
	
	super.Init(self)
	
end --func end
--next--
function TransferControllerRumorTemplate:OnDestroy()
	
	
end --func end
--next--
function TransferControllerRumorTemplate:OnDeActive()
	
	
end --func end
--next--
function TransferControllerRumorTemplate:OnSetData(data)
	
	self:CustomSetData(data)
	
end --func end
--next--
function TransferControllerRumorTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function TransferControllerRumorTemplate:CustomSetData(data)

	MLuaCommonHelper.SetRectTransformPos(self.Parameter.Rumor.gameObject, data.posx, data.posy)
end
--lua custom scripts end
return TransferControllerRumorTemplate