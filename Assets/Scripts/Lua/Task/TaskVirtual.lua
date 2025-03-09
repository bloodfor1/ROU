module("Task", package.seeall)
require "Task/TaskBase"
local super = Task.TaskBase
local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
TaskVirtual = class("TaskVirtual", super)

function TaskVirtual:ctor(taskTableData, virtualType, targetID)
    super.ctor(self, taskTableData)
    self.virtualType = virtualType
    self.virtualTargetId = targetID
    --道具获取计数类
    self.countUpdateProcessor = Data.ItemUpdateCountProcessor.new()
end

function TaskVirtual:SyncTaskData(taskInfo)
    
    local l_status = taskInfo.taskStatus
    self.time = taskInfo.time
    self.showTime = taskInfo.showTime
    if self.taskTargetList == nil then
        if taskInfo.targets == nil or #taskInfo.targets == 0 then
            self.taskTargetList = {}
        else
            self:CreateTaskTargets(taskInfo.targets)
            self:CreateCountTrack()  --创建数量追踪
        end
    end

    return self:ChangeTaskStatus(l_status)
end

--创建数量追踪
function TaskVirtual:CreateCountTrack()
    --清理计数器
    self.countUpdateProcessor:Clear()
    --每一个目标创建对应的计数器
    for i = 1, #self.taskTargetList do
        self.countUpdateProcessor:Reg(self.taskTargetList[i].targetId, function ()
            self:SyncVirtualTaskData()
        end)
    end
end

function TaskVirtual:CancelTrack(...)
    MgrMgr:GetMgr("ForgeMgr").RequestDevEquipTask(self.virtualTargetId)
end

function TaskVirtual:SyncVirtualTaskData()
    local l_status = self.taskStatus
    if self.taskTargetList == nil then
        self:ChangeTaskStatus(l_status)
        return
    end
    local l_completedCnt = 0
    for i = 1, #self.taskTargetList do
        local l_target = self.taskTargetList[i]
        local l_taskTargetStep = {}
        l_taskTargetStep.step = Data.BagModel:GetCoinOrPropNumById(l_target.targetId)
        l_taskTargetStep.maxStep = l_target.maxStep
        local l_completed = l_target:SyncTargetStep(l_taskTargetStep, true)
        if l_completed then
            l_completedCnt = l_completedCnt + 1
        end
    end
    if l_completedCnt >= #self.taskTargetList then
        l_status = MgrMgr:GetMgr("TaskMgr").ETaskStatus.CanFinish
    else
        l_status = MgrMgr:GetMgr("TaskMgr").ETaskStatus.Taked
    end

    self:ChangeTaskStatus(l_status)
    GlobalEventBus:Dispatch(EventConst.Names.RefreshQuickTaskPanel)
    return l_status
end

function TaskVirtual:GetNavigationData()
    return nil
end

function TaskVirtual:ChangeTaskStatus(status)
    self:UpdateShowPriorityWithStatus(status)
    --如果修改前后内容相同则直接返回
    if self.taskStatus == status then
        self:UpdateTargetsStatus()
        return false
    end
    self.taskStatus = status
    self:UpdateTargetsStatus()
    --状态变更事件
    GlobalEventBus:Dispatch(EventConst.Names.TaskStatusUpdate, self.taskId, self.taskStatus)
    if self.taskStatus == MgrMgr:GetMgr("TaskMgr").ETaskStatus.Taked then
        return true
    end
    return false
end

function TaskVirtual:ParseTargetData(index, targetInfo)
    local l_targetData = {}
    l_targetData.targetType = targetInfo.type
    l_targetData.targetId = targetInfo.targetId
    l_targetData.targetArg = targetInfo.targetArg
    l_targetData.step = targetInfo.step
    l_targetData.maxStep = targetInfo.maxStep
    l_targetData.navPosition = nil
    l_targetData.dungeonPosition = nil
    l_targetData.msgEx = nil
    l_targetData.desc = nil
    l_targetData.ignoreNav = false
    return l_targetData
end

function TaskVirtual:GetTaskLimitStrForUI()
    return nil
end

function TaskVirtual:GetTaskTakedLimitStr()
    return nil
end

function TaskVirtual:GetTaskNotTakeLimitStr()
    return nil
end

function TaskVirtual:GetTaskDescribe()
    return nil
end

function TaskVirtual:UpdateTaskStatuWithLvUp()
end

function TaskVirtual:MiniMapFilter()
    return false
end

function TaskVirtual:NavigateAtOnce()
    return false
end

function TaskVirtual:NeedShow(isTaskUI)
    return not isTaskUI
end

function TaskVirtual:FinishNormal(...)
    return true
end

--根据当前状态更新目标数据
function TaskVirtual:UpdateTargetsStatus()
    for i = 1, #self.taskTargetList do
        local l_taskTarget = self.taskTargetList[i]
        if l_taskTarget ~= nil then
            if l_taskTarget:CheckTargetComplete() then
                l_taskTarget:RemoveTaskEvent()
            else
                l_taskTarget:AddTaskEvent()
            end
        end
    end
end

function TaskVirtual:NavigationByFinish(navType)
    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("Task_ForgeTaskFinishText"))
    MgrMgr:GetMgr("ForgeMgr").GotoForgeWithId(self.virtualTargetId)
end

function TaskVirtual:NeewShowTargets()
    return true
end

function TaskVirtual:QuickGiveUp(...)
    return true
end

function TaskVirtual:Destroy(...)
    for i = 1, #self.taskTargetList do
        self.taskTargetList[i]:Destroy()
    end

    self.taskTargetList = nil
    self.currentTaskTarget = nil

    --销毁道具获取计数类
    if self.countUpdateProcessor then
        self.countUpdateProcessor:Clear()
        self.countUpdateProcessor = nil
    end
end


