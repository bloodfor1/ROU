require "Task/TaskTargets/TaskTargetBase"

--拍照类型任务目标类
module("Task", package.seeall)

local super = Task.TaskTargetBase
TaskTargetPhotograph = class("TaskTargetPhotograph", super)

function TaskTargetPhotograph:ctor(targetIndex, taskId, taskData, targetData, stepInfo)
    super.ctor(self, targetIndex, taskId, taskData, targetData, stepInfo)
    if self.targetId == 0 then
        self.photoAimIds = nil
        return
    end
    local l_photoAimRow = TableUtil.GetTaskCameraTarget().GetRowByTargetID(self.targetId)
    if l_photoAimRow then
        self.photoAimIds = l_photoAimRow.photoAimId
    else
        self.photoAimIds = nil
        local l_debugInfo = MgrMgr:GetMgr("TaskMgr").DEBUT_TASK_NAMES[self.taskData.tableData.taskType]
        logError("<" .. l_debugInfo[2] .. ">中" .. "任务 <" .. self.taskId .. "> 第" .. self.targetIndex .. "个目标,拍摄物目标表配置缺少 @" .. l_debugInfo[1])
    end

end

function TaskTargetPhotograph:GetTaskTargetDescribeQuick()
    return nil
end

--获取任务面板任务目标描述
function TaskTargetPhotograph:GetTaskTargetDescribe()
    local l_str = Lang("TASK_TARGET_TIP_" .. tostring(self.targetType))
    return l_str
end

function TaskTargetPhotograph:GetTaskTargetStepTip()
    return nil
end

--监听事件添加
function TaskTargetPhotograph:AddTaskEvent()

    if self.isEventAdded then
        return
    end
    super.AddTaskEvent(self)

    if self.photoAimIds then
        for i = 0, self.photoAimIds.Count - 1 do
            MoonClient.MCheckInCameraManager.AddCheckInCameraById(self.photoAimIds[i])
        end
    end
end

--监听事件移除
function TaskTargetPhotograph:RemoveTaskEvent()

    if not self.isEventAdded then
        return
    end
    super.RemoveTaskEvent(self)

    if self.photoAimIds then
        for i = 0, self.photoAimIds.Count - 1 do
            MoonClient.MCheckInCameraManager.RemoveCheckInCameraById(self.photoAimIds[i])
        end
    end
    self:ClosePhotograph()
end

--监听事件执行体
function TaskTargetPhotograph:ExecuteEventLogic(eventData)
    local l_playerPos = MEntityMgr.PlayerEntity.Position
    local l_nowSceneId = MScene.SceneID
    local l_inPosition = self:CheckPosInRange(l_nowSceneId, l_playerPos, 8.0)
    local l_color = self.taskData:GetTitleColor()
    local l_taskName = self.taskData.tableData.name
    local l_tips = GetColorText("<" .. l_taskName .. ">:", l_color) .. Lang("TAKE_PHOTO_COMPLETED")
    if not l_inPosition then
        if MgrMgr:GetMgr("TaskMgr").GetSelectTaskID() == self.taskId then
            l_tips = GetColorText("<" .. l_taskName .. ">:", l_color) .. Lang("TAKE_TASK_PHOTO_NOT_IN_POSITION")
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_tips)
        end
        return
    end
    local l_photoIds = Common.Functions.ListToTable(eventData[1])

    if not self:CheckPhotoAims(l_photoIds) then
        return
    end

    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_tips)
    self:ReportTaskTargetComplete()
end

function TaskTargetPhotograph:TaskReportInfo()
    ---@type TaskReportArg
    local l_sendInfo = GetProtoBufSendTable("TaskReportArg")
    l_sendInfo.photo.photo_id = self.targetId
    l_sendInfo.photo.task_id = self.taskId
    return l_sendInfo
end

function TaskTargetPhotograph:ExecutePlayerStopEventLogic(sceneId, position)
    if MPlayerInfo.IsPhotoMode then
        return
    end
    if not self:CheckPosInRange(sceneId, position, 8.0) then
        return
    end

    local l_functionInfo = {
        functionId = MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Camera,
        param = self.msgEx,
        taskTarget = self,
        closeCondition = function()
            if MEntityMgr.PlayerEntity == nil then
                return false
            end
            return self:CheckPosInRange(MScene.SceneID, MEntityMgr.PlayerEntity.Position, 8.0)
        end,
    }

    local panelData={
        ShowQuickUseType=MgrMgr:GetMgr("QuickUseMgr").EShowQuickUseType.SetFunction,
        MethodData=l_functionInfo
    }
    UIMgr:ActiveUI(UI.CtrlNames.PropIcon, panelData)
end

--检查是否拍全了拍摄物目标
function TaskTargetPhotograph:CheckPhotoAims(eventData)
    if self.photoAimIds then
        for i = 0, self.photoAimIds.Count - 1 do
            if not table.ro_contains(eventData, self.photoAimIds[i]) then
                return false
            end
        end
        return true
    else
        return true
    end
end

function TaskTargetPhotograph:ClosePhotograph()
    if UIMgr:IsActiveUI(UI.CtrlNames.PropIcon) then
        local l_ui = UIMgr:GetUI(UI.CtrlNames.PropIcon)
        if l_ui and l_ui:GetTaskTarget() == self then
            UIMgr:DeActiveUI(UI.CtrlNames.PropIcon)
        end
    end
end

function TaskTargetPhotograph:Destroy()

    super.Destroy(self)
    self.photoAimIds = nil

end
