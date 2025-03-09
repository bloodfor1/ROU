require "Task/TaskTargets/TaskTargetBase"

--与NPC交互
module("Task", package.seeall)
local super = Task.TaskTargetBase
TaskTargetNpcAction = class("TaskTargetNpcAction", super)

function TaskTargetNpcAction:ctor(targetIndex,taskId, taskData, targetData, stepInfo)
    super.ctor(self,targetIndex,taskId, taskData, targetData, stepInfo)
    local l_tmp = string.ro_split(self.msgEx, "=")
    self.actionNpc = tonumber(l_tmp[1])
    self.actionScript = l_tmp[3]
    self.actionTag = l_tmp[4]
end

--获取任务面板任务目标描述
function TaskTargetNpcAction:GetTaskTargetDescribe()
    local l_taskTipsCon = Lang("TASK_TARGET_TIP_"..tostring(self.targetType))
    local l_npcData = TableUtil.GetNpcTable().GetRowById(self.actionNpc)
    if l_npcData == nil then
        logError("npc:<"..tostring(self.actionNpc).."> not exists in NpcTable")
        return l_taskTipsCon
    end
    local l_npcName = l_npcData.Name
    local l_str = StringEx.Format(l_taskTipsCon,l_npcName)
    return l_str
end

--获取任务目标的飘字提示
function TaskTargetNpcAction:GetTaskTargetTip()
    return nil
end

--监听事件添加
function TaskTargetNpcAction:AddTaskEvent()

    if self.isEventAdded then return end
    super.AddTaskEvent(self)
    MgrMgr:GetMgr("PlayerInfoMgr").AddTaskNpcAction(self.actionNpc,self.targetId,self.actionScript,self.actionTag)
end

--监听事件移除
function TaskTargetNpcAction:RemoveTaskEvent()

    if not self.isEventAdded then return end
    super.RemoveTaskEvent(self)
    MgrMgr:GetMgr("PlayerInfoMgr").RemoveTaskNpcAction(self.actionNpc)
end

function TaskTargetNpcAction:ExecuteEventLogic(eventData)
    local l_actionId = eventData[0]
    local l_npcId = eventData[1]
    if l_actionId == self.targetId and l_npcId == self.actionNpc then
        self:ReportTaskTargetComplete()
    end
end

function TaskTargetNpcAction:TaskReportInfo()
    ---@type TaskReportArg
    local l_sendInfo = GetProtoBufSendTable("TaskReportArg")
    l_sendInfo.npc_action.action_id = self.targetId
    l_sendInfo.npc_action.npc_id = self.actionNpc
    l_sendInfo.npc_action.task_id = self.taskId
    return l_sendInfo
end