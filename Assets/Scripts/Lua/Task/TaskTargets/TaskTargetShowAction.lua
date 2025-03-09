require "Task/TaskTargets/TaskTargetBase"

--指定动作(对应showactiontable)
module("Task", package.seeall)

local super = Task.TaskTargetBase
TaskTargetShowAction = class("TaskTargetShowAction", super)

function TaskTargetShowAction:ctor(targetIndex,taskId, taskData, targetData, stepInfo)
    super.ctor(self,targetIndex,taskId, taskData, targetData, stepInfo)
end

--各目标不同导航处理逻辑  由不同子类实现
function TaskTargetShowAction:TaskTargetNavigation()
    if self.navData then
        MgrMgr:GetMgr("ActionTargetMgr")
            .MoveToPos(self.navData.sceneId, self.navData.position,function( ... )
                MgrMgr:GetMgr("MultipleActionMgr").OpenActionHandler()
            end)
    else
        MgrMgr:GetMgr("MultipleActionMgr").OpenActionHandler()
    end
end

--获取任务目标的名称 
function TaskTargetShowAction:GetTaskTargetName()
    local l_actionData = TableUtil.GetShowActionTable().GetRowByID(self.targetId)
    if l_actionData == nil then
        logError("action:<"..tostring(self.targetId).."> not exists in ShowActionTable")
        return ""
    end
    return l_actionData.Name

end

--监听事件执行体
function TaskTargetShowAction:ExecuteEventLogic(eventData)
    local l_actionId = eventData
    if l_actionId ~= self.targetId then
        return
    end

    if self.navData ~= nil then
        local l_playerPos = MEntityMgr.PlayerEntity.Position
        local l_nowSceneId = MScene.SceneID
        if not self:CheckPosInRange(l_nowSceneId,l_playerPos) then
            return
        end
    end
    self:ReportTaskTargetComplete()
end

function TaskTargetShowAction:TaskReportInfo()
    ---@type TaskReportArg
    local l_sendInfo = GetProtoBufSendTable("TaskReportArg")
    l_sendInfo.play_action.action_id = self.targetId
    l_sendInfo.play_action.task_id = self.taskId
    return l_sendInfo
end

