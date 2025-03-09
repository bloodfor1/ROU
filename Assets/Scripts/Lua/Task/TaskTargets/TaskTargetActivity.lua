require "Task/TaskTargets/TaskTargetBase"

--活动类型任务目标类
module("Task", package.seeall)
local super = Task.TaskTargetBase
TaskTargetActivity = class("TaskTargetActivity",super)

function TaskTargetActivity:ctor(targetIndex,taskId, taskData, targetData, stepInfo)
    super.ctor(self,targetIndex,taskId, taskData, targetData, stepInfo)
end

function TaskTargetActivity:GetTaskTargetName()
    local activityTableRow = TableUtil.GetDailyActivitiesTable().GetRowById(self.targetId)
    if activityTableRow == nil then
        logError("activity :<"..self.targetId.."> not exists in DailyActivitiesTable")
        return ""
    end
    return activityTableRow.ActivityName
end

function TaskTargetActivity:TaskTargetNavigation()
    if self.navData == nil then
        self:OpenSystemByActivityId()
    else
        MgrMgr:GetMgr("ActionTargetMgr").MoveToPos(self.navData.sceneId,self.navData.position,function( ... )
            self:OpenSystemByActivityId()
        end)
    end
end

function TaskTargetActivity:OpenSystemByActivityId( )
    local l_activityData = TableUtil.GetDailyActivitiesTable().GetRowById(self.targetId)
    if l_activityData == nil then 
        logError("activity :<"..self.targetId.."> not exists in DailyActivitiesTable")
        return
    end
    local l_systemId =  l_activityData.FunctionID
    local l_systemFunction = MgrMgr:GetMgr("SystemFunctionEventMgr").GetSystemFunctionEvent(l_systemId)
    if l_systemFunction ~= nil then
        l_systemFunction()
    end
end