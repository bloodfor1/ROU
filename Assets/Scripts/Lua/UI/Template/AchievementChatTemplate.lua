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
---@class AchievementChatTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Text MoonClient.MLuaUICom
---@field Number MoonClient.MLuaUICom
---@field AchieBtn MoonClient.MLuaUICom

---@class AchievementChatTemplate : BaseUITemplate
---@field Parameter AchievementChatTemplateParameter

AchievementChatTemplate = class("AchievementChatTemplate", super)
--lua class define end

--lua functions
function AchievementChatTemplate:Init()
	
	super.Init(self)
	
end --func end
--next--
function AchievementChatTemplate:OnDestroy()
	
	
end --func end
--next--
function AchievementChatTemplate:OnDeActive()
	
	self:ClearTemplate();
	
end --func end
--next--
function AchievementChatTemplate:OnSetData(data)
	
	if data.data==nil then
		self:ClearTemplate();
		return;
	end
	local l_achiDetailItem=data.data:GetDetailTableInfo()
	if MLuaCommonHelper.IsNull(l_achiDetailItem) then
		return
	end
	self:DisplayTemplate(true)
	self.Parameter.Number.LabText=l_achiDetailItem.Point
	self.Parameter.Text.LabText=l_achiDetailItem.Name
	self.Parameter.AchieBtn:AddClick(data.ButtonMethod,true)
	
end --func end
--next--
function AchievementChatTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function AchievementChatTemplate:ClearTemplate()
	self:DisplayTemplate(false)
end
function AchievementChatTemplate:DisplayTemplate(show)
	self.Parameter.Text:SetActiveEx(show)
	self.Parameter.AchieBtn.Img.enabled=show
	self.Parameter.Number.Transform.parent.gameObject:SetActiveEx(show);
end
--lua custom scripts end
return AchievementChatTemplate