--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/TaskMailPanel"


--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
TaskMailCtrl = class("TaskMailCtrl", super)
--lua class define end

--lua functions
function TaskMailCtrl:ctor()

	super.ctor(self, CtrlNames.TaskMail, UILayer.Function, nil, ActiveType.Standalone)
end --func end
--next--
function TaskMailCtrl:Init()

	self.panel = UI.TaskMailPanel.Bind(self)
	super.Init(self)
	self.taskId = nil
	-- self.taskMailModel = nil
	self.animationTimer = nil
end --func end
--next--
function TaskMailCtrl:Uninit()

	super.Uninit(self)
	self.panel = nil

end --func end
--next--
function TaskMailCtrl:OnActive()
 	self.panel.TaskMailBtn.UObj:SetActiveEx(true)
	self.panel.BgMaskBtn.UObj:SetActiveEx(true)
    self.panel.Fx_Ui_XinFeng_00_New.UObj:SetActiveEx(true)

	self.panel.BgMaskBtn:AddClick(function( ... )
		self:CloseTaskMail()
	end)

	self.panel.TaskMailBtn:AddClick(function( ... )
		if self.taskId == nil then
			return
		end
		self.panel.TaskMailBtn.UObj:SetActiveEx(false)
		self.panel.BgMaskBtn.UObj:SetActiveEx(false)
		local l_taskMailInfo = TableUtil.GetTaskFlyAcceptTable().GetRowByTaskId(self.taskId)
		if l_taskMailInfo == nil then
	        local l_debugInfo = MgrMgr:GetMgr("TaskMgr").DEBUT_TASK_NAMES[self.taskData.tableData.taskType]
			logError("<"..l_debugInfo[2]..">中task <"..self.taskId.."> not exists in TaskFlyAcceptTable @"..l_debugInfo[1])
			return
		end

		if string.ro_isEmpty(l_mailImgPath) then
    		self.panel.Fx_Ui_XinFeng_01_New.UObj:SetActiveEx(true)
		else
    		self.panel.Fx_Ui_XinFeng_02_New.UObj:SetActiveEx(true)
		end
	    if self.animationTimer ~= nil then
			self:StopUITimer(self.animationTimer)
	    end
	    self.animationTimer = self:NewUITimer(function()
	    	-- self.animationTask = nil
	    	MgrMgr:GetMgr("TaskMgr").ShowTaskAcceptMail(self.taskId)
	    	self.animationTimer = self:NewUITimer(function()
	    		self.animationTimer = nil
	    		self:CloseTaskMail()
			end,0.05)
			self.animationTimer:Start()
		end,0.6)
		self.animationTimer:Start()
	end)

end --func end
--next--
function TaskMailCtrl:OnDeActive()
	self.taskId = nil
	-- if self.taskMailModel ~= nil then
 --    	self:DestroyUIEffect(self.taskMailModel)
 --    	self.taskMailModel = nil
	-- end

	if 	self.animationTimer ~= nil then
		self:StopUITimer(self.animationTimer)
		self.animationTimer = nil
	end
end --func end
--next--
function TaskMailCtrl:Update()


end --func end



--next--
function TaskMailCtrl:BindEvents()

	--dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts

function TaskMailCtrl:CloseTaskMail()
    UIMgr:DeActiveUI(UI.CtrlNames.TaskMail)
end

function TaskMailCtrl:ShowTaskMailReceive( taskId )
	self.taskId = taskId
	if self.taskId == nil then
		return
	end
	if not MgrMgr:GetMgr("TaskMgr").CheckMailTaskExists(taskId) then
        table.insert(MgrMgr:GetMgr("TaskMgr").taskShowMailFlag, taskId)
    end
end

--lua custom scripts end
