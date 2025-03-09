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
---@class AchievementTrophyTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Select MoonClient.MLuaUICom
---@field RedSignPrompt MoonClient.MLuaUICom
---@field IconGray MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom
---@field Button MoonClient.MLuaUICom

---@class AchievementTrophyTemplate : BaseUITemplate
---@field Parameter AchievementTrophyTemplateParameter

AchievementTrophyTemplate = class("AchievementTrophyTemplate", super)
--lua class define end

--lua functions
function AchievementTrophyTemplate:Init()
	
	    super.Init(self)
	self.Parameter.Select:SetActiveEx(false)
	self.Parameter.RedSignPrompt:SetActiveEx(false)
	self.Parameter.Button:AddClick(function()
		self.MethodCallback(self.ShowIndex)
	end)
	
end --func end
--next--
function AchievementTrophyTemplate:OnDestroy()
	
	
end --func end
--next--
function AchievementTrophyTemplate:OnDeActive()
	
	
end --func end
--next--
function AchievementTrophyTemplate:OnSetData(data)
	
	self.Data=data
	self.Parameter.Icon:SetSpriteAsync(data.Atlas, data.Icon, nil, true)
	self.Parameter.IconGray:SetActiveEx(false)
	if data.Level>MgrMgr:GetMgr("AchievementMgr").BadgeLevel then
		local l_currentBadgeTableInfo=TableUtil.GetAchievementBadgeTable().GetRowByLevel(MgrMgr:GetMgr("AchievementMgr").BadgeLevel)
		local l_buttonBadgeTableInfo=TableUtil.GetAchievementBadgeTable().GetRowByLevel(data.Level)
		if l_currentBadgeTableInfo.Type~=l_buttonBadgeTableInfo.Type then
			self.Parameter.IconGray:SetActiveEx(true)
			self.Parameter.IconGray:SetSpriteAsync(data.Atlas, data.Icon, nil, true)
		end
	end
	self:_showRedSign()
	
end --func end
--next--
function AchievementTrophyTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function AchievementTrophyTemplate:OnSelect()
	self.Parameter.Select:SetActiveEx(true)
	self.Parameter.RedSignPrompt:SetActiveEx(false)
end

function AchievementTrophyTemplate:OnDeselect()
	self.Parameter.Select:SetActiveEx(false)
	self:_showRedSign()
end

function AchievementTrophyTemplate:_showRedSign()
	if self:_isHaveBadgeAward() then
		self.Parameter.RedSignPrompt:SetActiveEx(true)
	else
		self.Parameter.RedSignPrompt:SetActiveEx(false)
	end

end

function AchievementTrophyTemplate:_isHaveBadgeAward()
	if self.Data==nil then
		return false
	end
	local l_table=TableUtil.GetAchievementBadgeTable().GetTable()
	for i = 2, #l_table do
		if l_table[i].Type==self.Data.Type then
			if MgrMgr:GetMgr("AchievementMgr").IsAchievementBadgeCanReward(l_table[i]) then
				return true
			end
		end
	end
	return false
end
--lua custom scripts end
return AchievementTrophyTemplate