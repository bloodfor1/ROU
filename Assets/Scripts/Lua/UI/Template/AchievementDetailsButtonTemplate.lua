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
---@class AchievementDetailsButtonTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field RedPrompt MoonClient.MLuaUICom
---@field ProgressSlider MoonClient.MLuaUICom
---@field ON MoonClient.MLuaUICom
---@field Off MoonClient.MLuaUICom
---@field ButtonName2 MoonClient.MLuaUICom
---@field ButtonName1 MoonClient.MLuaUICom
---@field Button MoonClient.MLuaUICom

---@class AchievementDetailsButtonTemplate : BaseUITemplate
---@field Parameter AchievementDetailsButtonTemplateParameter

AchievementDetailsButtonTemplate = class("AchievementDetailsButtonTemplate", super)
--lua class define end

--lua functions
function AchievementDetailsButtonTemplate:Init()
	
	    super.Init(self)
	self._isSelect=false
	self.Parameter.RedPrompt:SetActiveEx(false)
	self.Parameter.Button:AddClick(function()
		self:ClickButton()
	end)
	self.Parameter.ProgressSlider:SetActiveEx(false)	
	
end --func end
--next--
function AchievementDetailsButtonTemplate:OnDeActive()
	
	
end --func end
--next--
function AchievementDetailsButtonTemplate:OnSetData(data)
	
	self.Data=data
	self:showButton(data)
	
end --func end
--next--
function AchievementDetailsButtonTemplate:BindEvents()
	
	self:BindEvent(MgrMgr:GetMgr("AchievementMgr").EventDispatcher,MgrMgr:GetMgr("AchievementMgr").AchievementGetItemRewardEvent,function()
		self:_showRedSign()
	end)
	
end --func end
--next--
function AchievementDetailsButtonTemplate:OnDestroy()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function AchievementDetailsButtonTemplate:showButton(index)
    local l_tableInfo= TableUtil.GetAchievementIndexTable().GetRowByIndex(index)
    self.Parameter.ButtonName1.LabText=l_tableInfo.Name
    self.Parameter.ButtonName2.LabText=l_tableInfo.Name

	local l_mgr=MgrMgr:GetMgr("AchievementMgr")

	self:_showRedSign()

	if index == l_mgr.GetShowAchievementDetailsButtonIndex() then
		self:ClickButton()
	end
end

function AchievementDetailsButtonTemplate:_showRedSign()

	if self._isSelect then
		self.Parameter.RedPrompt:SetActiveEx(false)
		return
	end

	local l_achievements= MgrMgr:GetMgr("AchievementMgr").GetAchievementWithIndex(self.Data)

	if MgrMgr:GetMgr("AchievementMgr").IsHaveCanAwardAchievement(l_achievements) then
		self.Parameter.RedPrompt:SetActiveEx(true)
	else
		self.Parameter.RedPrompt:SetActiveEx(false)
	end
end

function AchievementDetailsButtonTemplate:Hid()

	self._isSelect=false

	self.Parameter.ON:SetActiveEx(false)
	self.Parameter.Off:SetActiveEx(true)

	self:_showRedSign()
end

function AchievementDetailsButtonTemplate:ClickButton()

	self._isSelect=true

    local achievementMgr = MgrMgr:GetMgr("AchievementMgr")
    achievementMgr.EventDispatcher:Dispatch(achievementMgr.OnDetailsButtonEvent,self)
	self.Parameter.ON:SetActiveEx(true)
	self.Parameter.Off:SetActiveEx(false)

	self.Parameter.RedPrompt:SetActiveEx(false)
end
--lua custom scripts end
return AchievementDetailsButtonTemplate