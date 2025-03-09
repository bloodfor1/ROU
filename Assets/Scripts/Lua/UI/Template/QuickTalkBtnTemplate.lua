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
---@class QuickTalkBtnTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Text MoonClient.MLuaUICom
---@field Star MoonClient.MLuaUICom
---@field QuickTalkBtn MoonClient.MLuaUICom
---@field Image MoonClient.MLuaUICom

---@class QuickTalkBtnTemplate : BaseUITemplate
---@field Parameter QuickTalkBtnTemplateParameter

QuickTalkBtnTemplate = class("QuickTalkBtnTemplate", super)
--lua class define end

--lua functions
function QuickTalkBtnTemplate:Init()
	
	super.Init(self)
	
end --func end
--next--
function QuickTalkBtnTemplate:OnDestroy()
	
	
end --func end
--next--
function QuickTalkBtnTemplate:OnDeActive()
	
	self:ClearTemplateInfo()
	
end --func end
--next--
function QuickTalkBtnTemplate:OnSetData(data)
	
	if data.data==nil then
		self:ClearTemplateInfo()
		return
	end
	self:DisplayTemplate(true)
	self.Parameter.Image:SetActiveEx(data.data.isStar)
	    local l_showStr
	if data.data.hasHref then
	        l_showStr=data.data.hrefStr
	else
		l_showStr=data.data.content
	end
	    l_showStr=MoonClient.DynamicEmojHelp.ReplaceInputTextEmojiContent(l_showStr)
	    self.Parameter.Text:GetRichText().useEllipsis=true
	self.Parameter.Text.LabText=l_showStr
	self.Parameter.QuickTalkBtn:AddClick(data.ButtonMethod,true)
	self.Parameter.Star:AddClick(function()
		if DataMgr:GetData("ChatData").ChangeQuickTalkInfoStarState(data.data) then
			self.Parameter.Image:SetActiveEx(data.data.isStar)
		end
	 end,true)
	
end --func end
--next--
function QuickTalkBtnTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function QuickTalkBtnTemplate:ClearTemplateInfo()
	self:DisplayTemplate(false)
end
function QuickTalkBtnTemplate:DisplayTemplate(show)
	self.Parameter.QuickTalkBtn.Img.enabled=show
	self.Parameter.Star:SetActiveEx(show)
	self.Parameter.Text:SetActiveEx(show)
end
--lua custom scripts end
return QuickTalkBtnTemplate