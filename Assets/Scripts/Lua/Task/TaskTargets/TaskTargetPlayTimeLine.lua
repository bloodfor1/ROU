require "Task/TaskTargets/TaskTargetBase"

--播放TimeLine(对应CutSceneTable)类型任务目标类
module("Task", package.seeall)

local super = Task.TaskTargetBase
TaskTargetPlayTimeLine = class("TaskTargetPlayTimeLine", super)

function TaskTargetPlayTimeLine:ctor(targetIndex,taskId, taskData, targetData, stepInfo)
    super.ctor(self,targetIndex,taskId, taskData, targetData, stepInfo)
end

function TaskTargetPlayTimeLine:GetTaskTargetDescribeQuick()
    return nil
end

--获取任务面板任务目标描述 
function TaskTargetPlayTimeLine:GetTaskTargetDescribe()
    local l_str = Lang("TASK_TARGET_TIP_"..tostring(self.targetType))
    return l_str
end

function TaskTargetPlayTimeLine:GetTaskTargetStepTip()
    return nil
end

--各目标不同导航处理逻辑  由不同子类实现
function TaskTargetPlayTimeLine:TaskTargetNavigation()
    
    if self.navData then
        MgrMgr:GetMgr("ActionTargetMgr")
            .MoveToPos(self.navData.sceneId, self.navData.position, function()
                self:PlayTimeLine()
            end)
    else
        self:PlayTimeLine()
    end       
end

function TaskTargetPlayTimeLine:PlayTimeLine( ... )
    MgrMgr:GetMgr("TaskMgr").PlayTaskTimeLine(self.targetId)
end


--获取任务目标的名称 
function TaskTargetPlayTimeLine:GetTaskTargetName()
    local l_cutSceneData = TableUtil.GetCutSceneTable().GetRowByID(self.targetId)
    if l_cutSceneData == nil then
        logError("cutSceneId :<"..tostring(self.targetId).."> not exists in CutSceneTable !")
        return ""
    end
    return l_cutSceneData.Des
end

--监听事件执行体
function TaskTargetPlayTimeLine:ExecuteEventLogic(eventData)
    local l_timeLineId = tonumber(eventData)
    if l_timeLineId == self.targetId then
        self:ReportTaskTargetComplete()
    end
end

function TaskTargetPlayTimeLine:TaskReportInfo( )
    ---@type TaskReportArg
    local l_sendInfo = GetProtoBufSendTable("TaskReportArg")
    l_sendInfo.timeline_id = tonumber(self.targetId)
    return l_sendInfo
end
