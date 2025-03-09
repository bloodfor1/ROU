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
---@class SelectBoxCellTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field SelectText MoonClient.MLuaUICom
---@field SelectIcon MoonClient.MLuaUICom
---@field SelectCellButton MoonClient.MLuaUICom

---@class SelectBoxCellTemplate : BaseUITemplate
---@field Parameter SelectBoxCellTemplateParameter

SelectBoxCellTemplate = class("SelectBoxCellTemplate", super)
--lua class define end

--lua functions
function SelectBoxCellTemplate:Init()
	
	    super.Init(self)
	self.Data=nil
	self.Parameter.SelectCellButton:AddClick(function()
		self.MethodCallback(self.ShowIndex)
	end)
	
end --func end
--next--
function SelectBoxCellTemplate:OnDestroy()
	
	
end --func end
--next--
function SelectBoxCellTemplate:OnDeActive()
	
	
end --func end
--next--
function SelectBoxCellTemplate:OnSetData(data)
	
	self.Data=data
	self.Parameter.SelectText.LabText=data.name
	
end --func end
--next--
function SelectBoxCellTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function SelectBoxCellTemplate:OnSelect()
	self.Parameter.SelectIcon.gameObject:SetActiveEx(true)
end
function SelectBoxCellTemplate:OnDeselect()
	self.Parameter.SelectIcon.gameObject:SetActiveEx(false)
end
--lua custom scripts end
return SelectBoxCellTemplate