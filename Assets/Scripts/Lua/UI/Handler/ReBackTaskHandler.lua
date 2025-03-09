--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseHandler"
require "UI/Panel/ReBackTaskPanel"
require "UI/Template/ReturnTaskItem"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseHandler
--lua fields end

--lua class define
ReBackTaskHandler = class("ReBackTaskHandler", super)
--lua class define end

--lua functions
function ReBackTaskHandler:ctor()
	
	super.ctor(self, HandlerNames.ReBackTask, 0)
	
end --func end
--next--
function ReBackTaskHandler:Init()
	
	self.panel = UI.ReBackTaskPanel.Bind(self)
	super.Init(self)

	self.mgr = MgrMgr:GetMgr("ReBackMgr")

	self.taskItemPool = self:NewTemplatePool({
		UITemplateClass = UITemplate.ReturnTaskItem,
		ScrollRect = self.panel.TaskItemRoot.LoopScroll,
		TemplatePrefab = self.panel.ReturnTaskItem.gameObject
	})
	
end --func end
--next--
function ReBackTaskHandler:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	self.leftTimer=nil
	
end --func end
--next--
function ReBackTaskHandler:OnActive()

	
end --func end
--next--
function ReBackTaskHandler:OnDeActive()

	
end --func end
--next--
function ReBackTaskHandler:Update()
	
	
end --func end
--next--
function ReBackTaskHandler:BindEvents()

	self:BindEvent(self.mgr.l_eventDispatcher, self.mgr.SIG_RETURN_TASK_UPDATE,self.OnDataUpdate,self)
	self:BindEvent(self.mgr.l_eventDispatcher, self.mgr.OnReconnectedEvent,self.OnDataUpdate,self)

end --func end
--next--
--lua functions end

--lua custom scripts

function ReBackTaskHandler:OnShow()
	self:OnDataUpdate()
	self:InitLeftTime()
end

function ReBackTaskHandler:OnHide()
	if self.leftTimer then
		self:StopUITimer(self.leftTimer)
		self.leftTimer=nil
	end
end

function ReBackTaskHandler:OnDataUpdate()
	self.taskData = self.mgr.GetSortedTaskData()
	self:RefreshPanel()
	MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(eRedSignKey.ReBackTask)
end

function ReBackTaskHandler:RefreshPanel()
	self.taskItemPool:ShowTemplates({ Datas = self.taskData})
end

function ReBackTaskHandler:InitLeftTime()
	local leftTime = self.mgr.GetLeftTime()
	if leftTime <= 0 then
		self.panel.LeftTimeRoot:SetActiveEx(false)
	else
		self.panel.LeftTimeRoot:SetActiveEx(true)
		self.panel.LeftTime.LabText = self.mgr.GetFormatTime(leftTime)
		self.leftTimer = self:NewUITimer(function()
			self.panel.LeftTime.LabText = self.mgr.GetFormatTime(leftTime)
			leftTime = leftTime - 1
			if leftTime <= 0 then
				self.panel.LeftTimeRoot:SetActiveEx(false)
				self:StopUITimer(self.leftTimer)
			end
		end,1,-1,true)
		self.leftTimer:Start()
	end
end

--lua custom scripts end
return ReBackTaskHandler