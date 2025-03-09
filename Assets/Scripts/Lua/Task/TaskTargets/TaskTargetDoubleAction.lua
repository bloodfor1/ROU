require "Task/TaskTargets/TaskTargetBase"
--双人交互(对应ShowActionTable)类型任务目标类
module("Task", package.seeall)

local super = Task.TaskTargetBase
TaskTargetDoubleAction = class("TaskTargetDoubleAction",super)

function TaskTargetDoubleAction:ctor(targetIndex,taskId, taskData, targetData, stepInfo)
    super.ctor(self,targetIndex,taskId, taskData, targetData, stepInfo)
end

function TaskTargetDoubleAction:GetTaskTargetDescribe()
    return self:GetTaskTargetName()
end

function TaskTargetDoubleAction:GetTaskTargetName()
    local l_actionData = TableUtil.GetShowActionTable().GetRowByID(self.targetId)
    if l_actionData == nil then
        logError("actionId :<"..self.targetId.."> not exists in ShowActionTable !")
        return ""
    end
    return l_actionData.Name
end


--各目标不同导航处理逻辑  由不同子类实现
function TaskTargetDoubleAction:TaskTargetNavigation()
    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("TASK_TARGET_DOUBLE_ACTION_TIPS"))
end

--获取任务目标的飘字提示
function TaskTargetDoubleAction:GetTaskTargetTip()
    local l_str = GetColorText(self:GetTaskTargetName() .. ":", RoColorTag.Yellow) .. GetColorText(self:GetTaskTargetStepTip(), RoColorTag.None)
    return l_str
end

--获取任务目标的名称
function TaskTargetDoubleAction:GetTaskTargetName()
    local l_actionData = TableUtil.GetShowActionTable().GetRowByID(self.targetId)
    if l_actionData == nil then
        logError("actionId :<"..tostring(self.targetId).."> not exists in ShowActionTable !")
        return ""
    end
    return l_actionData.Name
end

