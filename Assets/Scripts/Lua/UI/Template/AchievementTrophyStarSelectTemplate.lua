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
---@class AchievementTrophyStarSelectTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Select MoonClient.MLuaUICom
---@field SecondBg2 MoonClient.MLuaUICom
---@field SecondBg1 MoonClient.MLuaUICom
---@field RedSignPrompt MoonClient.MLuaUICom
---@field Name2 MoonClient.MLuaUICom
---@field Name1 MoonClient.MLuaUICom
---@field LastBg2 MoonClient.MLuaUICom
---@field LastBg1 MoonClient.MLuaUICom
---@field FirstBg2 MoonClient.MLuaUICom
---@field FirstBg1 MoonClient.MLuaUICom
---@field Button MoonClient.MLuaUICom

---@class AchievementTrophyStarSelectTemplate : BaseUITemplate
---@field Parameter AchievementTrophyStarSelectTemplateParameter

AchievementTrophyStarSelectTemplate = class("AchievementTrophyStarSelectTemplate", super)
--lua class define end

--lua functions
function AchievementTrophyStarSelectTemplate:Init()
	
	    super.Init(self)
	self.Parameter.Select:SetActiveEx(false)
	self.Parameter.RedSignPrompt:SetActiveEx(false)
	self.Parameter.Button:AddClick(function()
		self.MethodCallback(self.ShowIndex)
	end)
	
end --func end
--next--
function AchievementTrophyStarSelectTemplate:OnDestroy()
	
	
end --func end
--next--
function AchievementTrophyStarSelectTemplate:OnDeActive()
	
	
end --func end
--next--
function AchievementTrophyStarSelectTemplate:OnSetData(data,count)
	
	self.Data=data
	self.Parameter.FirstBg1:SetActiveEx(false)
	self.Parameter.SecondBg1:SetActiveEx(false)
	self.Parameter.LastBg1:SetActiveEx(false)
	self.Parameter.FirstBg2:SetActiveEx(false)
	self.Parameter.SecondBg2:SetActiveEx(false)
	self.Parameter.LastBg2:SetActiveEx(false)
	if self.ShowIndex==1 then
		self.Parameter.FirstBg1:SetActiveEx(true)
		self.Parameter.FirstBg2:SetActiveEx(true)
	elseif self.ShowIndex==count then
		self.Parameter.LastBg1:SetActiveEx(true)
		self.Parameter.LastBg2:SetActiveEx(true)
	else
		self.Parameter.SecondBg1:SetActiveEx(true)
		self.Parameter.SecondBg2:SetActiveEx(true)
	end
	local l_name=tostring(self.ShowIndex)..Lang("Achievement_StarText")
	self.Parameter.Name1.LabText=l_name
	self.Parameter.Name2.LabText=l_name
	self:_showRedSign()
	
end --func end
--next--
function AchievementTrophyStarSelectTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function AchievementTrophyStarSelectTemplate:OnSelect()
	self.Parameter.Select:SetActiveEx(true)
	self.Parameter.RedSignPrompt:SetActiveEx(false)
end

function AchievementTrophyStarSelectTemplate:OnDeselect()
	self.Parameter.Select:SetActiveEx(false)
	self:_showRedSign()
end
function AchievementTrophyStarSelectTemplate:_showRedSign()
	if self.Data==nil then
		return
	end
	if MgrMgr:GetMgr("AchievementMgr").IsAchievementBadgeCanReward(self.Data) then
		self.Parameter.RedSignPrompt:SetActiveEx(true)
	else
		self.Parameter.RedSignPrompt:SetActiveEx(false)
	end

end
--lua custom scripts end
return AchievementTrophyStarSelectTemplate