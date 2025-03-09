require "Task/TaskTargets/TaskTargetBase"

--使用技能(对应SkillTable)类型任务目标类
module("Task", package.seeall)

local super = Task.TaskTargetBase
TaskTargetSkillCast = class("TaskTargetSkillCast", super)

function TaskTargetSkillCast:ctor(targetIndex,taskId, taskData, targetData, stepInfo)
    super.ctor(self,targetIndex,taskId, taskData, targetData, stepInfo)
end

--获取任务目标的名称 
function TaskTargetSkillCast:GetTaskTargetName()
    local l_skillData = TableUtil.GetSkillTable().GetRowById(self.targetId)
    if l_skillData == nil then
        logError("skillId :<"..tostring(self.targetId).."> not exists in SkillTable !")
        return ""
    end
    return l_skillData.Name
end

--监听事件执行体
function TaskTargetSkillCast:ExecuteEventLogic(eventData)
    local l_skillId = tonumber(eventData)
    if l_skillId == self.targetId then
        self:ReportTaskTargetComplete()
    end
end

function TaskTargetSkillCast:TaskReportInfo()
    ---@type TaskReportArg
    local l_sendInfo = GetProtoBufSendTable("TaskReportArg")
    l_sendInfo.skill_id = tonumber(self.targetId)
    return l_sendInfo
end
