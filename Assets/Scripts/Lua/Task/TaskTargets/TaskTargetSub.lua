require "Task/TaskTargets/TaskTargetBase"

module("Task", package.seeall)

local super = Task.TaskTargetBase
TaskTargetSub = class("TaskTargetSub", super)

function TaskTargetSub:ctor(targetIndex,taskId, taskData, targetData, stepInfo)
    super.ctor(self,targetIndex,taskId, taskData, targetData, stepInfo)
end

--获取任务面板任务目标描述 
function TaskTargetSub:GetTaskTargetDescribe()
    local l_str = Lang("TASK_TARGET_TIP_"..tostring(self.targetType))
    return l_str
end

function TaskTargetSub:TargetNavigation(navType)
    local l_subTaskId = self.targetId
    if l_subTaskId == 0 then
        return
    end
    local l_mgr = MgrMgr:GetMgr("TaskMgr")
    if l_mgr.GetPreShowTaskStatusWithTaskId(l_subTaskId) == l_mgr.ETaskStatus.Taked then
        l_mgr.OnQuickTaskClickWithTaskId(l_subTaskId)
    end
end

function TaskTargetSub:GetTaskTargetStepTip()
	return nil
end

