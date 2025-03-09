require "Task/TaskTargets/TaskTargetBase"

--收集(回收)(对应ItemTable)类型任务目标类
module("Task", package.seeall)


local super = Task.TaskTargetBase
TaskTargetDynamicRecycle = class("TaskTargetDynamicRecycle", super)

function TaskTargetDynamicRecycle:ctor(targetIndex,taskId, taskData, targetData, stepInfo)
    super.ctor(self,targetIndex,taskId, taskData, targetData, stepInfo)
end

--各目标不同导航处理逻辑  由不同子类实现
function TaskTargetDynamicRecycle:TaskTargetNavigation()
    MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(self.targetId, nil, nil, nil, true)
end

--获取任务目标的飘字提示
function TaskTargetDynamicRecycle:GetTaskTargetTip()
    local l_str = GetColorText(self:GetTaskTargetName() .. ":", RoColorTag.Yellow) .. GetColorText(self:GetTaskTargetStepTip(), RoColorTag.None)
    return l_str
end

--获取任务目标的名称
function TaskTargetDynamicRecycle:GetTaskTargetName()
    local l_itemData = TableUtil.GetItemTable().GetRowByItemID(self.targetId)
    if l_itemData == nil then
        logError("item:<"..tostring(self.targetId).."> not exists in ItemTable")
        return ""
    end
    return l_itemData.ItemName
end
