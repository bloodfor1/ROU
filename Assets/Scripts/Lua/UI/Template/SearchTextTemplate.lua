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
---@class SearchTextTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field SearchTextButton MoonClient.MLuaUICom
---@field SearchText MoonClient.MLuaUICom

---@class SearchTextTemplate : BaseUITemplate
---@field Parameter SearchTextTemplateParameter

SearchTextTemplate = class("SearchTextTemplate", super)
--lua class define end

--lua functions
function SearchTextTemplate:Init()
	
	    super.Init(self)
	    self.Parameter.SearchText:GetText().useEllipsis=true
	self.Data=nil
	self.Parameter.SearchTextButton:AddClick(function()
		self.MethodCallback(self.Data)
	end)
	
end --func end
--next--
function SearchTextTemplate:OnDeActive()
	
	
end --func end
--next--
function SearchTextTemplate:OnSetData(data)
	
	self.Data=data
	self.Parameter.SearchText.LabText=data
	
end --func end
--next--
function SearchTextTemplate:OnDestroy()
	
	
end --func end
--next--
function SearchTextTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return SearchTextTemplate