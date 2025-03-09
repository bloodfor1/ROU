require "Task/TaskTargets/TaskTargetBase"
--进入副本(对应DungeonsTable)类型任务目标类
module("Task", package.seeall)

local super = Task.TaskTargetBase
TaskTargetEnterDungeons = class("TaskTargetEnterDungeons",super)

function TaskTargetEnterDungeons:ctor(targetIndex,taskId, taskData, targetData, stepInfo)
    super.ctor(self,targetIndex,taskId, taskData, targetData, stepInfo)
end

--各目标不同导航处理逻辑  由不同子类实现
function TaskTargetEnterDungeons:TaskTargetNavigation()
    
    MgrMgr:GetMgr("ActionTargetMgr").EnterDungeons(self.targetId)
        
end

--获取任务目标的名称 
function TaskTargetEnterDungeons:GetTaskTargetName()
    local l_dungeonData = TableUtil.GetDungeonsTable().GetRowByDungeonsID(self.targetId)
    if l_dungeonData == nil then
        logError("dungeon:<"..tostring(self.targetId).."> not exists in DungeonsTable !")
        return ""
    end
    return l_dungeonData.DungeonsName
end
