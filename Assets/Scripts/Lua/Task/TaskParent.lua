module("Task", package.seeall)
require "Task/TaskBase"
local super = Task.TaskBase
TaskParent = class("TaskParent", super)

function TaskParent:ctor(taskTableData)
    super.ctor(self,taskTableData)
    self.isParentTask = true
end

function TaskParent:CreateTargetDataByConfig(  )
    local l_targetDatas = {}
    local l_subTaskIds = self:CreateSubTaskData()
    for i=1,#l_subTaskIds do
        local l_targetData = self:ParseSubTarget(l_subTaskIds[i])
        table.insert(l_targetDatas,l_targetData)
    end
    return l_targetDatas
end

--创建子任务数据
function TaskParent:CreateSubTaskData()
    local l_subTaskIds = {}
    --子任务选择方式
    -- logError("self.tableData.targetSubTaskChoose:"..self.tableData.targetSubTaskChoose)
    if self.tableData.targetSubTaskChoose == MgrMgr:GetMgr("TaskMgr").ETaskSubChoose.Sequence
        or self.tableData.targetSubTaskChoose == MgrMgr:GetMgr("TaskMgr").ETaskSubChoose.ByPlayer then
        for i=1,#self.tableData.targetSubTasks do
            local l_subId = self.tableData.targetSubTasks[i]
            -- logError("l_subId:"..l_subId)
            table.insert(l_subTaskIds,l_subId)
        end
    end
    return l_subTaskIds
end

function TaskParent:ParseSubTarget(subTaskId)
    local l_targetData = {}
    l_targetData.targetType = MgrMgr:GetMgr("TaskMgr").ETaskTargetType.ParentTask
    l_targetData.targetId = subTaskId
    l_targetData.targetArg = 1
    l_targetData.step = 0
    l_targetData.maxStep = 1
    l_targetData.navPosition = nil
    l_targetData.dungeonPosition = nil
    l_targetData.msgEx = nil
    l_targetData.desc = nil
    return l_targetData
end

--根据当前状态更新目标数据
function TaskParent:UpdateTargetsStatus()
    local l_taskMgr = MgrMgr:GetMgr("TaskMgr")
    --若子任务执行类型不为玩家自选则为顺序执行
    local l_hasTarget = false  
    for i=1,#self.taskTargetList do
        local l_taskTarget = self.taskTargetList[i]
        if l_taskTarget ~= nil then
            local l_completed = l_taskTarget:CheckTargetComplete()
            -- logError("TaskBase:UpdateTargetsStatus 111111")
            --如果该目标未完成  设置第一个未完成的目标为当前目标
            if not l_completed then
                -- logError("TaskBase:UpdateTargetsStatus 222222:"..l_taskTarget.targetId)
                if self.currentTaskTarget ~= l_taskTarget then
                    -- logError("UpdateTargetsStatus:"..self.taskId)
                    self.currentTaskTarget = l_taskTarget
                end
                break
            end
        end
    end
end

function TaskParent:NeedShow( isTaskUI )
    if not super.NeedShow(self,isTaskUI) then
    	return false
    end
    local l_taskMgr = MgrMgr:GetMgr("TaskMgr")
    if self.taskStatus == l_taskMgr.ETaskStatus.CanTake or self.taskStatus == l_taskMgr.ETaskStatus.NotTake then
        return true
    end
    return false
end