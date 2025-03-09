require "Task/TaskTargets/TaskTargetBase"

--完成N次指定玩法类型任务目标类
module("Task", package.seeall)
local super = Task.TaskTargetBase
TaskTargetPlayActivity = class("TaskTargetPlayActivity",super)

function TaskTargetPlayActivity:ctor(targetIndex,taskId, taskData, targetData, stepInfo)
    super.ctor(self,targetIndex,taskId, taskData, targetData, stepInfo)
end

function TaskTargetPlayActivity:GetTaskTargetDescribe()
    local l_row = TableUtil.GetTaskActivityTable().GetRowByID(self.targetId)
    if l_row == nil then
        logError("ID :<"..self.targetId.."> not exists in TaskActivityTable")
        return ""
    end
    return l_row.ActivityName
end

function TaskTargetPlayActivity:TaskTargetNavigation()
    if self.navData == nil then
        self:OpenSystemByActivityId()
    else
        MgrMgr:GetMgr("ActionTargetMgr").MoveToPos(self.navData.sceneId, self.navData.position, 
            function( ... )
                self:OpenSystemByActivityId()
            end)
    end
end

function TaskTargetPlayActivity:OpenSystemByActivityId( )
    local l_row = TableUtil.GetTaskActivityTable().GetRowByID(self.targetId)
    if l_row == nil then
        logError("ID :<"..self.targetId.."> not exists in TaskActivityTable")
        return
    end
    local l_systemId =  l_row.ActivityId
    local l_systemFunction = MgrMgr:GetMgr("SystemFunctionEventMgr").GetSystemFunctionEvent(l_systemId)
    if l_systemFunction ~= nil then
        l_systemFunction()
    end
end