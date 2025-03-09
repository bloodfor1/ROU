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
---@class ServerBtnTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Text MoonClient.MLuaUICom
---@field Checkmark MoonClient.MLuaUICom
---@field Background MoonClient.MLuaUICom

---@class ServerBtnTemplate : BaseUITemplate
---@field Parameter ServerBtnTemplateParameter

ServerBtnTemplate = class("ServerBtnTemplate", super)
--lua class define end

--lua functions
function ServerBtnTemplate:Init()
	
	super.Init(self)
	
end --func end
--next--
function ServerBtnTemplate:OnDestroy()
	
	
end --func end
--next--
function ServerBtnTemplate:OnDeActive()
	
	
end --func end
--next--
function ServerBtnTemplate:OnSetData(data)
	
	    self.Parameter.Checkmark:SetActiveEx(false)
	self.Parameter.Background:AddClick(function()
		if data.ctrl then
			data.ctrl:SelectServerBtn(data.datas, self.ShowIndex)
		end
	end)
		self.Parameter.Text.LabText = data.name
		self.Parameter.TextSelect.LabText = data.name
		
end --func end
--next--
function ServerBtnTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function ServerBtnTemplate:OnSelect()
	self.Parameter.Checkmark:SetActiveEx(true)
	self.Parameter.Text:SetActiveEx(false)
	
end

function ServerBtnTemplate:OnDeselect()
	self.Parameter.Checkmark:SetActiveEx(false)
	self.Parameter.Text:SetActiveEx(true)
end
--lua custom scripts end
return ServerBtnTemplate