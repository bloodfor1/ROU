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
---@class AchievementBadgeProgressTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field TaskImage MoonClient.MLuaUICom
---@field ProgressText MoonClient.MLuaUICom
---@field ProgressSlider MoonClient.MLuaUICom
---@field Point MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field GotoButton MoonClient.MLuaUICom
---@field Finish MoonClient.MLuaUICom
---@field AchievementImage MoonClient.MLuaUICom

---@class AchievementBadgeProgressTemplate : BaseUITemplate
---@field Parameter AchievementBadgeProgressTemplateParameter

AchievementBadgeProgressTemplate = class("AchievementBadgeProgressTemplate", super)
--lua class define end

--lua functions
function AchievementBadgeProgressTemplate:Init()
	
	    super.Init(self)
	
end --func end
--next--
function AchievementBadgeProgressTemplate:OnDestroy()
	
	
end --func end
--next--
function AchievementBadgeProgressTemplate:OnDeActive()
	
	
end --func end
--next--
function AchievementBadgeProgressTemplate:OnSetData(data)
	
	self.Parameter.AchievementImage:SetActiveEx(false)
	self.Parameter.TaskImage:SetActiveEx(false)
	local l_color
	if self:_isFinish(data) then
		self.Parameter.Finish:SetActiveEx(true)
		self.Parameter.GotoButton:SetActiveEx(false)
		l_color = RoColor.Hex2Color(RoColor.WordColor.None[1])
	else
		self.Parameter.Finish:SetActiveEx(false)
		self.Parameter.GotoButton:SetActiveEx(true)
		l_color = RoColor.Hex2Color(RoColor.WordColor.Red[1])
	end
	if data.TaskId==nil then
		self.Parameter.AchievementImage:SetActiveEx(true)
		self.Parameter.ProgressText:SetActiveEx(true)
		self.Parameter.ProgressSlider:SetActiveEx(true)
		self.Parameter.Point:SetActiveEx(false)
		self.Parameter.Name.LabText=Lang("Achievement_BadgeProgressPointText")
		self.Parameter.ProgressText.LabText=tostring(MgrMgr:GetMgr("AchievementMgr").TotalAchievementPoint).."/"..tostring(data.TableInfo.Point)
		self.Parameter.ProgressSlider.Slider.value = MgrMgr:GetMgr("AchievementMgr").TotalAchievementPoint / data.TableInfo.Point
		self.Parameter.GotoButton:AddClick(function()
			MgrMgr:GetMgr("AchievementMgr").OpenAchievementPanel()
		end)
	else
		local l_taskInfo = MgrMgr:GetMgr("TaskMgr").GetTaskTableInfoByTaskId(data.TaskId)
		if l_taskInfo == nil then
			return
		end
		self.Parameter.ProgressText:SetActiveEx(false)
		self.Parameter.ProgressSlider:SetActiveEx(false)
		self.Parameter.Point:SetActiveEx(true)
		self.Parameter.TaskImage:SetActiveEx(true)
		self.Parameter.Name.LabText=Lang("Achievement_BadgeProgressTaskText")
		self.Parameter.Point.LabText=l_taskInfo.name
		self.Parameter.GotoButton:AddClick(function()
			MgrMgr:GetMgr("TaskMgr").NavToTaskAcceptNpc(data.TaskId)
		end)
		self.Parameter.Point.LabColor=l_color
	end
	
end --func end
--next--
function AchievementBadgeProgressTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function AchievementBadgeProgressTemplate:_isFinish(data)
	if data.TaskId==nil then
		return MgrMgr:GetMgr("AchievementMgr").TotalAchievementPoint>=data.TableInfo.Point
	else
		return MgrMgr:GetMgr("TaskMgr").CheckTaskFinished(data.TaskId)
	end
end
--lua custom scripts end
return AchievementBadgeProgressTemplate