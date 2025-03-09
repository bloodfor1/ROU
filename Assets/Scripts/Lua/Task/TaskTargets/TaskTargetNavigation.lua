--寻路(对应SceneTable)类型任务目标类
require "Task/TaskTargets/TaskTargetBase"

module("Task", package.seeall)

local super = Task.TaskTargetBase
TaskTargetNavigation = class("TaskTargetNavigation", super)

function TaskTargetNavigation:ctor(targetIndex,taskId, taskData, targetData, stepInfo)
    super.ctor(self,targetIndex,taskId, taskData, targetData, stepInfo)
end

function TaskTargetNavigation:GetTaskTargetDescribeQuick()
    return nil
end

--获取任务面板任务目标描述 
function TaskTargetNavigation:GetTaskTargetDescribe()
    local l_str = Lang("TASK_TARGET_TIP_"..tostring(self.targetType))
    return l_str
end

function TaskTargetNavigation:GetTaskTargetStepTip()
    return nil
end

function TaskTargetNavigation:ExecutePlayerStopEventLogic(sceneId,position)
	if not self:CheckPosInRange(sceneId, position) then 
		return 
	end
    self:ReportTaskTargetComplete()
end

function TaskTargetNavigation:TaskReportInfo( )
    ---@type TaskReportArg
    local l_sendInfo = GetProtoBufSendTable("TaskReportArg")
    l_sendInfo.postion.sceneid = self.navData.sceneId
    l_sendInfo.postion.x = self.navData.position.x
    l_sendInfo.postion.z = self.navData.position.z
    return l_sendInfo
end


