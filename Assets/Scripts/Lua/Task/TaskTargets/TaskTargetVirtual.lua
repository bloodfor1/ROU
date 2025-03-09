require "Task/TaskTargets/TaskTargetBase"

--道具追踪(虚拟)(对应ItemTable)类型任务目标类
module("Task", package.seeall)


local super = Task.TaskTargetBase
TaskTargetVirtual = class("TaskTargetVirtual", super)

function TaskTargetVirtual:ctor(targetIndex,taskId, taskData, targetData, stepInfo)
    super.ctor(self,targetIndex,taskId, taskData, targetData, stepInfo)
    
end

--同步任务目标进度  并返回该目标是否完成
function TaskTargetVirtual:SyncTargetStep(stepInfo,tips)

    local l_preStep = self.currentStep
    self.currentStep = stepInfo.step
    self.maxStep = stepInfo.maxStep
    local l_completed = self.currentStep >= self.maxStep
    if not tips then
        return l_completed
    end
    if l_preStep < self.currentStep and l_preStep < self.maxStep then
        local l_targetTips = self:GetTaskTargetTip()
        if l_targetTips ~= nil then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_targetTips)
        end
    end
    return l_completed
end

--各目标不同导航处理逻辑  由不同子类实现
function TaskTargetVirtual:TaskTargetNavigation()
    MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(self.targetId, nil, nil, nil, true)
end

--获取任务目标的飘字提示
function TaskTargetVirtual:GetTaskTargetTip()
    local l_str = GetColorText(self:GetTaskTargetName() .. ":", RoColorTag.Yellow) .. GetColorText(self:GetTaskTargetStepTip(), RoColorTag.None)
    return l_str
end

--获取任务目标的名称
function TaskTargetVirtual:GetTaskTargetName()
    local l_itemData = TableUtil.GetItemTable().GetRowByItemID(self.targetId)
    if l_itemData == nil then
        logError("item:<"..tostring(self.targetId).."> not exists in ItemTable")
        return ""
    end
    return l_itemData.ItemName
end



