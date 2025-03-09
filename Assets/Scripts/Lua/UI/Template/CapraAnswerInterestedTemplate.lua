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
---@class CapraAnswerInterestedTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Text MoonClient.MLuaUICom
---@field Button MoonClient.MLuaUICom

---@class CapraAnswerInterestedTemplate : BaseUITemplate
---@field Parameter CapraAnswerInterestedTemplateParameter

CapraAnswerInterestedTemplate = class("CapraAnswerInterestedTemplate", super)
--lua class define end

--lua functions
function CapraAnswerInterestedTemplate:Init()
	
	super.Init(self)
	self.question=nil
	self.Parameter.Button:AddClick(function()
		if self.question == nil then
			return
		end
		local l_mgr=MgrMgr:GetMgr("CapraFAQMgr")
		l_mgr.EventDispatcher:Dispatch(l_mgr.SendAskQuestionEvent, self.question)
	end)
	
end --func end
--next--
function CapraAnswerInterestedTemplate:BindEvents()
	
	
end --func end
--next--
function CapraAnswerInterestedTemplate:OnDestroy()
	
	self.question=nil
	
end --func end
--next--
function CapraAnswerInterestedTemplate:OnDeActive()
	
	
end --func end
--next--
function CapraAnswerInterestedTemplate:OnSetData(data)
	
	self.question=data
	self.Parameter.Text.LabText=data
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return CapraAnswerInterestedTemplate