module("Task", package.seeall)
require "Task/TaskBase"
local super = Task.TaskBase
TaskCircle = class("TaskCircle", super)

function TaskCircle:ctor(taskTableData)
    super.ctor(self,taskTableData)
    self.isCycTask = true
end

function TaskCircle:GetTaskProgress()
    return StringEx.Format("({0}/{1})",self:GetCurrentStep(),self:GetMaxStep())
end

function TaskCircle:GetNotTakeTargetDesc( )
    local l_targetsDesc = {}
    local l_targetInfo = {}
    l_targetInfo.desc = Lang("TASK_TARGET_TIP_16")
    l_targetInfo.step = nil
    l_targetInfo.completed = false
    table.insert(l_targetsDesc,l_targetInfo)
    return l_targetsDesc
end