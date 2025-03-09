require "Task/TaskTargets/TaskTargetBase"

--播放黑幕(对应BlackCurtain)类型任务目标类
module("Task", package.seeall)

local super = Task.TaskTargetBase
TaskTargetPlayBlackCurtain = class("TaskTargetPlayBlackCurtain", super)

function TaskTargetPlayBlackCurtain:ctor(targetIndex,taskId, taskData, targetData, stepInfo)
    super.ctor(self,targetIndex,taskId, taskData, targetData, stepInfo)
end

function TaskTargetPlayBlackCurtain:GetTaskTargetDescribeQuick()
    return nil
end

--获取任务面板任务目标描述 
function TaskTargetPlayBlackCurtain:GetTaskTargetDescribe()
    local l_str = Lang("TASK_TARGET_TIP_"..tostring(self.targetType))
    return l_str
end

function TaskTargetPlayBlackCurtain:GetTaskTargetStepTip()
    return nil
end

--各目标不同导航处理逻辑  由不同子类实现
function TaskTargetPlayBlackCurtain:TaskTargetNavigation()
    
    if self.navData then
        MgrMgr:GetMgr("ActionTargetMgr")
            .MoveToPos(self.navData.sceneId, self.navData.position, function()
                MgrMgr:GetMgr("BlackCurtainMgr").PlayBlackCurtain(self.targetId)               
            end)
    else
        MgrMgr:GetMgr("BlackCurtainMgr").PlayBlackCurtain(self.targetId)               
    end       
end

--监听事件执行体
function TaskTargetPlayBlackCurtain:ExecuteEventLogic(eventData)
    local l_blackCurtainId = tonumber(eventData)
    if l_blackCurtainId == self.targetId then
        self:ReportTaskTargetComplete()
    end
end

function TaskTargetPlayBlackCurtain:TaskReportInfo()
    ---@type TaskReportArg
    local l_sendInfo = GetProtoBufSendTable("TaskReportArg")
    l_sendInfo.black_curtainid = tonumber(self.targetId)
    return l_sendInfo
end
