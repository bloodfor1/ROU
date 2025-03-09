require "Task/TaskTargets/TaskTargetBase"

--打怪(对应EntityTable)类型任务目标类
module("Task", package.seeall)

local super = Task.TaskTargetBase
TaskTargetKillEnemy = class("TaskTargetKillEnemy", super)

function TaskTargetKillEnemy:ctor(targetIndex,taskId, taskData, targetData, stepInfo)
    super.ctor(self,targetIndex,taskId, taskData, targetData, stepInfo)
end


--各目标不同导航处理逻辑  由不同子类实现
function TaskTargetKillEnemy:TaskTargetNavigation()

    if self.navData then
        MgrMgr:GetMgr("ActionTargetMgr")
            .MoveToPos(self.navData.sceneId, self.navData.position)
            .KillMonster(self.targetId)
    end

end

--获取任务面板任务目标描述
function TaskTargetKillEnemy:GetTaskTargetDescribe()
    return self:GetTaskTargetName()
end

--获取任务目标的飘字提示
function TaskTargetKillEnemy:GetTaskTargetTip()
    local l_str = GetColorText(self:GetTaskTargetName() .. ":", RoColorTag.Yellow) .. GetColorText(self:GetTaskTargetStepTip(), RoColorTag.None)
    return l_str
end

--获取任务目标的名称
function TaskTargetKillEnemy:GetTaskTargetName()
    local l_entityData = TableUtil.GetEntityTable().GetRowById(self.targetId)
    if l_entityData == nil then
        logError("entity:<"..tostring(self.targetId).."> not exists in EntityTable")
        return ""
    end
    return l_entityData.Name
end
