--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/BaseUITemplate"
require "UI/Template/AchievementDetailsButtonTemplate"
--lua requires end

--lua model
module("UITemplate", package.seeall)

--lua model end

--lua fields
local super = UITemplate.BaseUITemplate
--lua fields end

--lua class define
---@class AchievementButtonTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field RedPrompt MoonClient.MLuaUICom
---@field ProgressSlider MoonClient.MLuaUICom
---@field ON MoonClient.MLuaUICom
---@field Off MoonClient.MLuaUICom
---@field ButtonName2 MoonClient.MLuaUICom
---@field ButtonName1 MoonClient.MLuaUICom
---@field Arrow2 MoonClient.MLuaUICom
---@field Arrow1 MoonClient.MLuaUICom
---@field AchievementDetailsButtonParent MoonClient.MLuaUICom
---@field AchievementDetailsButton MoonClient.MLuaUIGroup

---@class AchievementButtonTemplate : BaseUITemplate
---@field Parameter AchievementButtonTemplateParameter

AchievementButtonTemplate = class("AchievementButtonTemplate", super)
--lua class define end

--lua functions
function AchievementButtonTemplate:Init()
	
	    super.Init(self)
	self.Data=nil
	self.detailsCount=0
	self._isSelect=false
	self.Parameter.AchievementDetailsButton.gameObject:SetActiveEx(false)
	self.Parameter.RedPrompt:SetActiveEx(false)
	self.detailsButtonTemplatePool=self:NewTemplatePool({
		UITemplateClass=UITemplate.AchievementDetailsButtonTemplate,
		TemplateParent=self.Parameter.AchievementDetailsButtonParent.transform,
		TemplatePrefab=self.Parameter.AchievementDetailsButton.gameObject
	})
	self.Parameter.ON:AddClick(function()
		if self.detailsCount>0 then
			self:HidDetailsButton()
		end
	end)
	self.Parameter.Off:AddClick(function()
		self:ClickButton()
	end)
	self.Parameter.ProgressSlider:SetActiveEx(false)
	self.Parameter.AchievementDetailsButtonParent:SetActiveEx(false)
	self.Parameter.ON:SetActiveEx(false)
	self.Parameter.Off:SetActiveEx(true)	
	
end --func end
--next--
function AchievementButtonTemplate:BindEvents()
	
	self:BindEvent(MgrMgr:GetMgr("AchievementMgr").EventDispatcher,MgrMgr:GetMgr("AchievementMgr").AchievementGetItemRewardEvent,
		function()
		self:_showRedSign()
	end)
	
end --func end
--next--
function AchievementButtonTemplate:OnDestroy()
	
	self.detailsButtonTemplatePool=nil
	
end --func end
--next--
function AchievementButtonTemplate:OnSetData(data)
	
	self.Data=data
	self:showButton(data)
	
end --func end
--next--
function AchievementButtonTemplate:OnDeActive()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function AchievementButtonTemplate:showButton(index)
	local l_tableInfo= TableUtil.GetAchievementIndexTable().GetRowByIndex(index)
	self.Parameter.ButtonName1.LabText=l_tableInfo.Name
	self.Parameter.ButtonName2.LabText=l_tableInfo.Name

	local l_table= TableUtil.GetAchievementIndexTable().GetTable()
	local l_id={}
	for i = 1, #l_table do
		if l_table[i].Type==index then
			table.insert(l_id,l_table[i].Index)
		end
	end

	self.detailsCount=#l_id
	if self.detailsCount>0 then
		self.Parameter.Arrow1:SetActiveEx(true)
		self.Parameter.Arrow2:SetActiveEx(true)

	else
		self.Parameter.Arrow1:SetActiveEx(false)
		self.Parameter.Arrow2:SetActiveEx(false)
	end
	self.detailsButtonTemplatePool:ShowTemplates({
		Datas=l_id,
	})

	local l_mgr=MgrMgr:GetMgr("AchievementMgr")
	--if index==l_mgr.PandectIndex or index==l_mgr.SearchIndex then
	--	self.Parameter.ProgressSlider:SetActiveEx(false)
	--else
	--	self.Parameter.ProgressSlider:SetActiveEx(true)
	--	local l_achievements= l_mgr.GetAchievementWithMainIndex(index)
	--	local l_totalCurrentGrade,l_totalFinishGrade= l_mgr.GetAchievementTotalPointProgress(l_achievements)
    --
	--	local l_sliderValue=l_totalCurrentGrade/l_totalFinishGrade
	--	self.Parameter.ProgressSlider.Slider.value=l_sliderValue
	--end

	self:_showRedSign()


	if index==l_mgr.GetShowAchievementMainButtonIndex() then
		self:ClickButton()
	end

end

function AchievementButtonTemplate:_showRedSign()

	if self._isSelect then
		self.Parameter.RedPrompt:SetActiveEx(false)
		return
	end

	local l_achievements= MgrMgr:GetMgr("AchievementMgr").GetAchievementWithMainIndex(self.Data)

	if MgrMgr:GetMgr("AchievementMgr").IsHaveCanAwardAchievement(l_achievements) then
		self.Parameter.RedPrompt:SetActiveEx(true)
	else
		self.Parameter.RedPrompt:SetActiveEx(false)
	end
end

function AchievementButtonTemplate:HidDetailsButton()

	self._isSelect=false

	if self.detailsCount>0 then
		self.Parameter.AchievementDetailsButtonParent:SetActiveEx(false)
	end
	self.Parameter.ON:SetActiveEx(false)
	self.Parameter.Off:SetActiveEx(true)

	self:_showRedSign()
end

function AchievementButtonTemplate:ClickButton()

	self._isSelect=true

    local achievementMgr = MgrMgr:GetMgr("AchievementMgr")
	achievementMgr.EventDispatcher:Dispatch(achievementMgr.OnButtonEvent,self)
	if self.detailsCount>0 then
		self.Parameter.AchievementDetailsButtonParent:SetActiveEx(true)
	end

	--点总览直接选择即将完成按钮
	if self.Data==MgrMgr:GetMgr("AchievementMgr").PandectIndex then
		local l_goingButton= self.detailsButtonTemplatePool:GetItem(1)
		if l_goingButton then
		    l_goingButton:ClickButton()
		end
	end


	self.Parameter.ON:SetActiveEx(true)
	self.Parameter.Off:SetActiveEx(false)

	self.Parameter.RedPrompt:SetActiveEx(false)
end
--lua custom scripts end
return AchievementButtonTemplate