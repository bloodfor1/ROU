require "Task/TaskTargets/TaskTargetBase"

--使用道具(对应ItemTable)类型任务目标类
module("Task", package.seeall)
local super = Task.TaskTargetBase
---@class TaskTargetFakeUseItem:TaskTargetBase
TaskTargetFakeUseItem = class("TaskTargetFakeUseItem", super)

function TaskTargetFakeUseItem:ctor(targetIndex, taskId, taskData, targetData, stepInfo)
    super.ctor(self, targetIndex, taskId, taskData, targetData, stepInfo)
end

--获取任务目标的名称 
function TaskTargetFakeUseItem:GetTaskTargetName()
    local l_itemData = TableUtil.GetTaskItemUseTable().GetRowByUseItem(self.targetId)
    if l_itemData == nil then
        local l_debugInfo = MgrMgr:GetMgr("TaskMgr").DEBUT_TASK_NAMES[self.taskData.tableData.taskType]
        logError("<" .. l_debugInfo[2] .. ">中" .. "任务 <" .. self.taskId .. "> 第" .. self.targetIndex .. "个目标,item:<" .. tostring(self.targetId) .. "> not exists in TaskItemUseTable @" .. l_debugInfo[1])
        return ""
    end
    return l_itemData.ItemName
end

--监听事件添加
function TaskTargetFakeUseItem:AddTaskEvent()
    if self.isEventAdded then
        return
    end

    super.AddTaskEvent(self)
    if MEntityMgr.PlayerEntity ~= nil then
        self:ExecutePlayerStopEventLogic(MScene.SceneID, MEntityMgr.PlayerEntity.Position)
    end
end

function TaskTargetFakeUseItem:ExecutePlayerStopEventLogic(sceneId, position)
    if not self:CheckPosInRange(sceneId, position) then
        return
    end
    local l_itemUseId = self.targetId
    local l_itemUseNum = self.maxStep
    local l_ItemUseTableRow = TableUtil.GetTaskItemUseTable().GetRowByUseItem(l_itemUseId)
    if l_ItemUseTableRow == nil then
        local l_debugInfo = MgrMgr:GetMgr("TaskMgr").DEBUT_TASK_NAMES[self.taskData.tableData.taskType]
        logError("<" .. l_debugInfo[2] .. ">中" .. "任务 <" .. self.taskId .. "> 第" .. self.targetIndex .. "个目标,使用道具,itemId:<" .. l_itemUseId .. "> not exists in TaskItemUseTable @" .. l_debugInfo[1])
        return
    end

    local l_propInfo = {
        itemId = l_ItemUseTableRow.UseItem,
        itemNum = l_itemUseNum,
        itemName = l_ItemUseTableRow.ItemName,
        btnName = l_ItemUseTableRow.UseItemName,
        ItemAtlas = l_ItemUseTableRow.ItemAtlas,
        ItemIcon = l_ItemUseTableRow.ItemIcon,
        taskTarget = self,
        callBack = function()
            local l_itemId = l_ItemUseTableRow.UseItem
            self:UseItemFake(l_itemId)
            UIMgr:DeActiveUI(UI.CtrlNames.PropIcon)
        end,
        closeCondition = function()
            if MEntityMgr.PlayerEntity == nil then
                return false
            end
            return self:CheckPosInRange(MScene.SceneID, MEntityMgr.PlayerEntity.Position)
        end,
    }
    local panelData={
        ShowQuickUseType=MgrMgr:GetMgr("QuickUseMgr").EShowQuickUseType.SetFakeItem,
        MethodData=l_propInfo
    }
    UIMgr:ActiveUI(UI.CtrlNames.PropIcon, panelData)
end

function TaskTargetFakeUseItem:TaskReportInfo()
    ---@type TaskReportArg
    local l_sendInfo = GetProtoBufSendTable("TaskReportArg")
    l_sendInfo.fakeitemid = self.targetId
    return l_sendInfo
end

function TaskTargetFakeUseItem:UseItemFake(itemId)
    self:DoUseItemAction(itemId)
    self:ShowUseItemFx(itemId)
    self:ReportTaskTargetComplete()
    if not Common.Utils.IsNilOrEmpty(self.msgEx) then
        MEntityMgr.PlayerEntity.Rotation = Quaternion.Euler(0, tonumber(self.msgEx), 0)
    end
end

function TaskTargetFakeUseItem:DoUseItemAction(itemId)
    local l_data = TableUtil.GetTaskItemUseTable().GetRowByUseItem(itemId)
    if l_data == nil then
        return
    end
    local l_actiondId = l_data.ItemAction
    if l_actiondId == 0 then
        return
    end
    local l_actiondData = TableUtil.GetAnimationTable().GetRowByID(l_actiondId)
    if l_actiondData == nil then
        logError("actionId :<" .. l_actiondId .. "> not exists in AnimationTable")
        return
    end

    MEventMgr:LuaFireEvent(MEventType.MEvent_Special, MEntityMgr.PlayerEntity,
            ROGameLibs.kEntitySpecialType_Action, l_actiondId)
    local l_actionTime = l_actiondData.MaxTime
    MgrMgr:GetMgr("TaskMgr").TaskUseItem(itemId, l_actionTime)
end

function TaskTargetFakeUseItem:ShowUseItemFx(itemId)
    local l_data = TableUtil.GetTaskItemUseTable().GetRowByUseItem(itemId)
    if l_data == nil then
        return
    end
    local l_target = Common.Functions.SequenceToTable((l_data.EffectPos))
    local l_sceneId = l_target[1]
    if MScene.SceneID ~= l_sceneId then
        return
    end
    local l_pos = Vector3.New(l_target[2], l_target[3], l_target[4])
    local l_effectData = TableUtil.GetEffectTable().GetRowById(l_data.ItemEffect)
    if l_effectData == nil then
        return
    end
    MPlayerInfo:FocusToPosition(l_pos)
    local l_fxData = MFxMgr:GetDataFromPool()
    l_fxData.playTime = l_effectData.PlayTime
    l_fxData.position = l_pos
    l_fxData.scaleFac = Vector3.New(l_effectData.ScaleX, l_effectData.ScaleY, l_effectData.ScaleZ)
    MFxMgr:CreateFx("Effects/Prefabs/" .. l_effectData.Path, l_fxData)
    MFxMgr:ReturnDataToPool(l_fxData)
end