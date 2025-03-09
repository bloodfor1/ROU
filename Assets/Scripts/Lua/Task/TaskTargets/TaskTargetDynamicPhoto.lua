require "Task/TaskTargets/TaskTargetBase"

--拍照类型任务目标类
module("Task", package.seeall)
local super = Task.TaskTargetBase
TaskTargetDynamicPhoto = class("TaskTargetDynamicPhoto",super)

function TaskTargetDynamicPhoto:ctor(targetIndex,taskId, taskData, targetData, stepInfo)
    super.ctor(self,targetIndex,taskId, taskData, targetData, stepInfo)
    local l_photoAimRow = TableUtil.GetCheckInViewPortTable().GetRowById(self.targetId)
    self.targetPosition = Vector3.New(0,0,0)   
    self.scene = 0
    if l_photoAimRow then
        self.photoAimId = l_photoAimRow.TriggerId
        local l_position = l_photoAimRow.Position
        self.targetPosition = Vector3.New(l_position[0],l_position[1],l_position[2])   
        self.scene = l_photoAimRow.SceneId
    else
        self.photoAimId = nil
        logError(" CheckInViewPortTable 中不能存在 <"..self.targetId.."> 的缩略图,请检查前端配置 @张博榕")
    end
    self.desc = Lang("TASK_TARGET_DYNC_PHOTO_DESC")
end

function TaskTargetDynamicPhoto:TaskTargetNavigation()
    UIMgr:ActiveUI(UI.CtrlNames.TaskPhoto,function( ctrl )
        ctrl:SetViewportId(self.targetId)
    end)
end

function TaskTargetDynamicPhoto:GetTaskTargetDescribe()
    local l_str = Lang("TASK_TARGET_TIP_"..tostring(self.targetType))
    return l_str
end


function TaskTargetDynamicPhoto:GetTaskTargetStepTip()
    return StringEx.Format("{0}/{1}", self.taskData:GetCurrentStep(), self.taskData:GetMaxStep())
end


--监听事件添加
function TaskTargetDynamicPhoto:AddTaskEvent()

    if self.isEventAdded then return end
    super.AddTaskEvent(self)
    --创建拍摄点的提示相机图标物件
    MoonClient.MCheckInCameraManager.AddViewPort(self.targetId)

end

--监听事件移除
function TaskTargetDynamicPhoto:RemoveTaskEvent()
    if not self.isEventAdded then return end
    super.RemoveTaskEvent(self)
    --移除拍摄点的提示相机图标物件
    MoonClient.MCheckInCameraManager.RemoveViewPort(self.targetId)
end

function TaskTargetDynamicPhoto:ExecuteEventLogic(eventData)
    if self.photoAimId == nil then
        return
    end
    local l_photoIds = Common.Functions.ListToTable(eventData[1])
    if table.ro_contains(l_photoIds, self.photoAimId) then
        local l_taskName = self.taskData.tableData.name
        local l_color = self.taskData:GetTitleColor()
        MEventMgr:LuaFireEvent(MEventType.MEvent_PhotoStopGuide, MEntityMgr.PlayerEntity)
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(GetColorText("<"..l_taskName..">:", l_color) .. Lang("TAKE_PHOTO_COMPLETED"))
        self:ReportTaskTargetComplete()
    end
end

function TaskTargetDynamicPhoto:TaskReportInfo()
    ---@type TaskReportArg
    local l_sendInfo = GetProtoBufSendTable("TaskReportArg")
    l_sendInfo.photo.photo_id = self.targetId
    l_sendInfo.photo.task_id = self.taskId
    return l_sendInfo
end

return TaskTargetDynamicPhoto