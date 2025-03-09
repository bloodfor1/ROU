require "Task/TaskTargets/TaskTargetBase"

--收集(回收)(对应ItemTable)类型任务目标类
module("Task", package.seeall)


local super = Task.TaskTargetBase
TaskTargetSearch = class("TaskTargetSearch", super)

function TaskTargetSearch:ctor(targetIndex,taskId, taskData, targetData, stepInfo)
    super.ctor(self,targetIndex,taskId, taskData, targetData, stepInfo)
    
end

--各目标不同导航处理逻辑  由不同子类实现
function TaskTargetSearch:TaskTargetNavigation()

    if string.ro_isEmpty(self.msgEx) then
        if self.navData then
            MgrMgr:GetMgr("ActionTargetMgr").MoveToPos(self.navData.sceneId, self.navData.position)
        end
    else
        MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(self.targetId, nil, nil, nil, true)
    end
end

--获取任务目标的飘字提示
function TaskTargetSearch:GetTaskTargetTip()
    local l_str = GetColorText(self:GetTaskTargetName() .. ":", RoColorTag.Yellow) .. GetColorText(self:GetTaskTargetStepTip(), RoColorTag.None)
    return l_str
end

--获取任务目标的名称
function TaskTargetSearch:GetTaskTargetName()
    local l_itemData = TableUtil.GetItemTable().GetRowByItemID(self.targetId)
    if l_itemData == nil then
        logError("item:<"..tostring(self.targetId).."> not exists in ItemTable")
        return ""
    end
    return l_itemData.ItemName
end

