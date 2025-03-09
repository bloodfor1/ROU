require "Task/TaskTargets/TaskTargetBase"

--场景交互(对应TaskSceneInteractionTable)类型任务目标类
module("Task", package.seeall)

local super = Task.TaskTargetBase
TaskTargetSceneInteraction = class("TaskTargetSceneInteraction", super)

function TaskTargetSceneInteraction:ctor(targetIndex,taskId, taskData, targetData, stepInfo)
    super.ctor(self,targetIndex,taskId, taskData, targetData, stepInfo)
    self.triggerFlag = false
end

function TaskTargetSceneInteraction:AddTaskEvent( )
    super.AddTaskEvent(self)
    if self.triggerFlag then return end
    local l_eventId = self.targetId
    local l_eventData = TableUtil.GetTaskSceneInteractionTable().GetRowByID(l_eventId)
    if l_eventData == nil then
        logError("eventId:<"..l_eventId.."> not exists in TaskSceneInteractionTable!")
        return
    end
    local l_objectIds = Common.Functions.VectorSequenceToTable(l_eventData.DynamicSceneId)
    for i = 1, #l_objectIds do
        MgrMgr:GetMgr("PlayerInfoMgr").UpdatePlayerTriggerAction(l_objectIds[i][2], l_eventData.PlayerAction)
    end
    self.triggerFlag = true
end


function TaskTargetSceneInteraction:RemoveTaskEvent( )
    if not self.isEventAdded then return end
    super.RemoveTaskEvent(self)
    if not self.triggerFlag then return end
    self.triggerFlag = false
    local l_eventId = self.targetId
    local l_eventData = TableUtil.GetTaskSceneInteractionTable().GetRowByID(l_eventId)
    if l_eventData == nil then
        logError("eventId:<"..l_eventId.."> not exists in TaskSceneInteractionTable!")
        return
    end
    local l_objectIds = Common.Functions.VectorSequenceToTable(l_eventData.DynamicSceneId)
    for i = 1, #l_objectIds do
        MgrMgr:GetMgr("PlayerInfoMgr").RemovePlayerTriggerAction(l_objectIds[i][2])
    end
end

--获取任务面板任务目标描述 
function TaskTargetSceneInteraction:GetTaskTargetDescribe()
    local l_str = self:GetTaskTargetName()
    return l_str
end

--获取任务目标的名称 
function TaskTargetSceneInteraction:GetTaskTargetName()
    local l_actionData = TableUtil.GetTaskSceneInteractionTable().GetRowByID(self.targetId)
    if l_actionData == nil then
        logError("actionId :<"..tostring(self.targetId).."> not exists in TaskSceneInteractionTable !")
        return ""
    end
    return l_actionData.Des
end

--监听事件执行体
function TaskTargetSceneInteraction:ExecuteEventLogic(eventData)

    local l_objectId = tonumber(eventData.Id)  --交互物件Id
    local l_eventId = self.targetId  --交互事件Id
    local l_objectIds = Common.Functions.VectorSequenceToTable(TableUtil.GetTaskSceneInteractionTable().GetRowByID(l_eventId).DynamicSceneId)
    for k = 1, table.maxn(l_objectIds) do
        local l_sceneId = l_objectIds[k][1]
        local l_sceneObjId = l_objectIds[k][2]
        if l_sceneId == MScene.SceneID and l_sceneObjId == l_objectId then
            local l_actionInfo = TableUtil.GetTaskSceneInteractionTable().GetRowByID(l_eventId)
            local l_time = l_actionInfo.DurationTime
            --若无持续时间（例如上秋千）直接判断完成
            if l_time == 0 then
                self:ReportTaskTargetComplete()
                return
            end
            --若有持续时间 做对应逻辑
            MgrMgr:GetMgr("TaskMgr").TaskEventStopSceneObject()  --重置所有相关数据
            --当前交互的场景物件Id获取
            MgrMgr:GetMgr("TaskMgr").currentObjectID = l_objectId
            --相机设置
            local l_cameraId = l_actionInfo.CameraId
            if l_cameraId ~= 0 then
                MPlayerInfo:Focus2Go(l_cameraId, eventData.ObjRef.sceneObj)
            end
            --进度条设置

            local l_actionProgress = MoonClient.MSceneCommonSliderHUD.New()
            MgrMgr:GetMgr("TaskMgr").actionProgress = l_actionProgress 
            l_actionProgress:SetCircularbarIconAndTxt(l_actionInfo.InteractionTxt, l_actionInfo.IconAtlas, l_actionInfo.Icon)
            l_actionProgress.SliderEndFuc = function ()
                self:ReportTaskTargetComplete()
                MPlayerInfo:ExitAdaptiveState()
            end
            if l_actionProgress.IsInit then
                l_actionProgress:SetBarAndPlay(l_time, 0)
            else
                l_actionProgress:Init(l_time, 0, MSliderType.CIRCULAR)
            end
        end
    end
end

function TaskTargetSceneInteraction:TaskReportInfo()
    ---@type TaskReportArg
    local l_sendInfo = GetProtoBufSendTable("TaskReportArg")
    l_sendInfo.sceneobjectid = self.targetId
    return l_sendInfo
end
