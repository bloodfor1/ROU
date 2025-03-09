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
---@class ProgressItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field ProgressText MoonClient.MLuaUICom
---@field ProgressSlider MoonClient.MLuaUICom
---@field GotoButton MoonClient.MLuaUICom
---@field ClassifyName MoonClient.MLuaUICom
---@field BadgeIcon MoonClient.MLuaUICom

---@class ProgressItemTemplate : BaseUITemplate
---@field Parameter ProgressItemTemplateParameter

ProgressItemTemplate = class("ProgressItemTemplate", super)
--lua class define end

--lua functions
function ProgressItemTemplate:Init()
	
	    super.Init(self)
	self.Data=nil
	self.Parameter.GotoButton:AddClick(function()
		self.MethodCallback(self.ShowIndex)
	end)
	
end --func end
--next--
function ProgressItemTemplate:OnDeActive()
	
	
end --func end
--next--
function ProgressItemTemplate:OnSetData(data)
	
	self.Data=data
	local l_achievements= MgrMgr:GetMgr("AchievementMgr").GetAchievementWithMainIndex(data)
	local l_tableInfo=TableUtil.GetAchievementIndexTable().GetRowByIndex(data)
	self.Parameter.ClassifyName.LabText=l_tableInfo.Name
	local l_totalFinishGrade=0
	local l_totalCurrentGrade=0
	local l_cacheTableInfo
	for i = 1, #l_achievements do
		l_cacheTableInfo=l_achievements[i]:GetDetailTableInfo()
		l_totalFinishGrade=l_totalFinishGrade+l_cacheTableInfo.Point
		if MgrMgr:GetMgr("AchievementMgr").IsFinish(l_achievements[i]) then
			l_totalCurrentGrade=l_totalCurrentGrade+l_cacheTableInfo.Point
		end
	end
	local l_sliderValue=l_totalCurrentGrade/l_totalFinishGrade
	local l_textValue=tostring(l_totalCurrentGrade).."/"..tostring(l_totalFinishGrade)
	self.Parameter.ProgressSlider.Slider.value=l_sliderValue
	self.Parameter.ProgressText.LabText=l_textValue
	self.Parameter.BadgeIcon:SetSpriteAsync(l_tableInfo.Atlas, l_tableInfo.Icon, nil, true)
	
end --func end
--next--
function ProgressItemTemplate:OnDestroy()
	
	
end --func end
--next--
function ProgressItemTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return ProgressItemTemplate