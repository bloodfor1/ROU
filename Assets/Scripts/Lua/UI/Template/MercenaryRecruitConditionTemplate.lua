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
---@class MercenaryRecruitConditionTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field TaskImage MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field GotoButton MoonClient.MLuaUICom
---@field Finish MoonClient.MLuaUICom
---@field CostText MoonClient.MLuaUICom
---@field Cost MoonClient.MLuaUICom
---@field ConditionText MoonClient.MLuaUICom

---@class MercenaryRecruitConditionTemplate : BaseUITemplate
---@field Parameter MercenaryRecruitConditionTemplateParameter

MercenaryRecruitConditionTemplate = class("MercenaryRecruitConditionTemplate", super)
--lua class define end

--lua functions
function MercenaryRecruitConditionTemplate:Init()
	
	    super.Init(self)
	    self.Parameter.GotoButton:AddClick(function()
	        if self.taskId then
	            UIMgr:DeActiveUI(UI.CtrlNames.Mercenary)
	            MgrMgr:GetMgr("TaskMgr").NavToTaskAcceptNpc(self.taskId)
	        elseif self.lockLevel then
	            l_isFinish = self.lockLevel <= MPlayerInfo.Lv
	        elseif self.achievementId then
	            UIMgr:DeActiveUI(UI.CtrlNames.Mercenary)
	            MgrMgr:GetMgr("AchievementMgr").OpenAchievementPanel(self.achievementId)
	        elseif self.achievementPoint then
	            UIMgr:DeActiveUI(UI.CtrlNames.Mercenary)
	            MgrMgr:GetMgr("AchievementMgr").OpenAchievementPanel()
	        end
	    end)
	
end --func end
--next--
function MercenaryRecruitConditionTemplate:OnDestroy()
	
	
end --func end
--next--
function MercenaryRecruitConditionTemplate:OnDeActive()
	
	
end --func end
--next--
function MercenaryRecruitConditionTemplate:OnSetData(data)
	
	    self.taskId = data.taskId
	    self.finishTaskId = data.finishTaskId
	    self.lockLevel = data.lockLevel
	    self.achievementId = data.achievementId
	    self.achievementPoint = data.achievementPoint
	    local l_isFinish = false
	    if self.taskId then
	        l_isFinish = MgrMgr:GetMgr("TaskMgr").CheckTaskFinished(self.finishTaskId)
	        local l_taskName = MgrMgr:GetMgr("TaskMgr").GetTaskNameByTaskId(self.finishTaskId)
	        self.Parameter.ConditionText.LabText = Lang("TASK_FINISH") .. "[" .. l_taskName .. "]"
	    elseif self.lockLevel then
	        l_isFinish = self.lockLevel <= MPlayerInfo.Lv
	        self.Parameter.ConditionText.LabText = Lang("MERCENARY_RECRUIT_LEVEL", self.lockLevel)
	    elseif self.achievementId then
	        l_isFinish = MgrMgr:GetMgr("AchievementMgr").IsFinishWithId(self.achievementId)
	        local l_achievementInfo = MgrMgr:GetMgr("AchievementMgr").GetAchievementTableInfoWithId(self.achievementId)
	        if l_achievementInfo then
	            self.Parameter.ConditionText.LabText = Lang("ACHIEVEMENT_LIMIT", l_achievementInfo.Name)
	        end
	    elseif self.achievementPoint then
	        l_isFinish = MgrMgr:GetMgr("AchievementMgr").TotalAchievementPoint >= self.achievementPoint
	        self.Parameter.ConditionText.LabText = StringEx.Format(Common.Utils.Lang("ACHIEVEMENTPOINT_LIMIT"), self.achievementPoint)
	    end
	    self.Parameter.Finish:SetActiveEx(l_isFinish)
	    if l_isFinish then
	        self.Parameter.ConditionText.LabColor = RoColor.Hex2Color(RoColor.WordColor.Green[1])
	    else
	        self.Parameter.ConditionText.LabColor = RoColor.Hex2Color(RoColor.WordColor.Red[1])
	    end
	    self.Parameter.GotoButton:SetActiveEx(not l_isFinish and (self.taskId ~= nil or self.achievementId ~= nil or self.achievementPoint ~= nil))
	    self.Parameter.Cost:SetActiveEx(false)
	
end --func end
--next--
function MercenaryRecruitConditionTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return MercenaryRecruitConditionTemplate