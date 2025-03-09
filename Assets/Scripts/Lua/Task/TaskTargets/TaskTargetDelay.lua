require "Task/TaskTargets/TaskTargetBase"

--拍照类型任务目标类
module("Task", package.seeall)
local super = Task.TaskTargetBase
TaskTargetDelay = class("TaskTargetDelay",super)

function TaskTargetDelay:ctor(targetIndex,taskId, taskData, targetData, stepInfo)
    super.ctor(self,targetIndex,taskId, taskData, targetData, stepInfo)
    self.maxDelayTime = self.targetId 
    self.delayTime = self.customTime + self.targetId - Common.TimeMgr.GetNowTimestamp()
    if self.delayTime <= 0 then
   		self.delayTime = 0
    end
    self.timer = Timer.New(function ( ... )
        self:UpdateTime()
    end , 1, -1, true)
end

--获取快捷任务栏任务目标描述  由子类分别实现
function TaskTargetDelay:GetTaskTargetDescribeQuick()
    return self:GetTaskTargetDescribe()
end

--获取任务面板任务目标描述
--这里给一个较为通用的 其余由子类分别实现
function TaskTargetDelay:GetTaskTargetDescribe()
    local l_taskTipsCon = Lang("TASK_TARGET_TIP_"..tostring(self.targetType))
    local l_delayTime = Common.Functions.SecondsToTimeStr(self.delayTime)
    return StringEx.Format(l_taskTipsCon,l_delayTime)
end

--监听事件添加
function TaskTargetDelay:AddTaskEvent()
    if self.isEventAdded then return end
    if self.timer ~= nil then
    	self.timer:Start()
    end
    super.AddTaskEvent(self)
end

--监听事件移除
function TaskTargetDelay:RemoveTaskEvent()

    if not self.isEventAdded then return end
    super.RemoveTaskEvent(self)
   	if self.timer ~= nil then
    	self.timer:Stop()
    end
end

function TaskTargetDelay:UpdateTime( ... )
	if self.delayTime <= 0 then
		return
	end

	if self.delayTime > 0 then
		self.delayTime = self.delayTime - 1
	end
    GlobalEventBus:Dispatch(EventConst.Names.UpdateTaskTime)
    GlobalEventBus:Dispatch(EventConst.Names.RefreshQuickOneTask,self.taskId)
end


function TaskTargetDelay:UpdataExData( targetInfo )
    self.customTime =  targetInfo.customTime
    self.delayTime = self.customTime + self.targetId - Common.TimeMgr.GetNowTimestamp()
end


function TaskTargetDelay:Destroy( ... )
    super.Destroy(self)
	self.timer = nil	
end
