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
---@class SelectElementFaceExpressionTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field BtnFaceExpressionInstance MoonClient.MLuaUICom

---@class SelectElementFaceExpressionTemplate : BaseUITemplate
---@field Parameter SelectElementFaceExpressionTemplateParameter

SelectElementFaceExpressionTemplate = class("SelectElementFaceExpressionTemplate", super)
--lua class define end

--lua functions
function SelectElementFaceExpressionTemplate:Init()
	
	    super.Init(self)
	
end --func end
--next--
function SelectElementFaceExpressionTemplate:OnDeActive()
	
	
end --func end
--next--
function SelectElementFaceExpressionTemplate:OnSetData(data)
	
	self:CustomSetData(data)
	
end --func end
--next--
function SelectElementFaceExpressionTemplate:BindEvents()
	
	
end --func end
--next--
function SelectElementFaceExpressionTemplate:OnDestroy()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function SelectElementFaceExpressionTemplate:CustomSetData(row)
	
	self.Parameter.BtnFaceExpressionInstance:SetSprite("PhotoExpression01", row.Icon)

	self.Parameter.BtnFaceExpressionInstance:AddClick(function()
		if self.MethodCallback then
			self.MethodCallback(row)
		end
	end)
end
--lua custom scripts end
return SelectElementFaceExpressionTemplate