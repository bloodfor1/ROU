require "Task/TaskTargets/TaskTargetBase"

--拍照类型任务目标类
module("Task", package.seeall)
local super = Task.TaskTargetBase
TaskTargetQTE = class("TaskTargetQTE",super)

function TaskTargetQTE:ctor(targetIndex,taskId, taskData, targetData, stepInfo)
    super.ctor(self,targetIndex,taskId, taskData, targetData, stepInfo)
end

function TaskTargetQTE:GetTaskTargetName()
    local l_qteData = TableUtil.GetSmallGameTable().GetRowByGameID(self.targetId)
    if l_qteData == nil then
        logError("SmallGame :<"..self.targetId.."> not exists in SmallGameTable")
        return ""
    end
    return l_qteData.GameName
end

function TaskTargetQTE:TaskTargetNavigation()
	MgrMgr:GetMgr("SmallGameMgr").ShowSmallGameByID(self.targetId)
end

function TaskTargetQTE:ExecuteEventLogic(eventData)
	if not eventData.win then
		return
	end
	if eventData.gameID == self.targetId then
	    self:ReportTaskTargetComplete()
	end
end

function TaskTargetQTE:TaskReportInfo()
    ---@type TaskReportArg
    local l_sendInfo = GetProtoBufSendTable("TaskReportArg")
    l_sendInfo.qte_id = self.targetId
    return l_sendInfo
end
