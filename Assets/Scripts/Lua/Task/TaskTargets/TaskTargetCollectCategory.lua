require "Task/TaskTargets/TaskTargetBase"
--采集(对应CollectTable)类型任务目标类
module("Task", package.seeall)
local super = Task.TaskTargetBase
TaskTargetCollectCategory = class("TaskTargetCollectCategory", super)

function TaskTargetCollectCategory:ctor(targetIndex,taskId, taskData, targetData, stepInfo)
    super.ctor(self,targetIndex,taskId, taskData, targetData, stepInfo)
end

--获取任务面板任务目标描述 
function TaskTargetCollectCategory:GetTaskTargetDescribe()
    local l_str = Lang("TASK_TARGET_TIP_"..tostring(self.targetType))
    return l_str
end

function TaskTargetCollectCategory:GetTaskTargetTip()
    return nil
end
