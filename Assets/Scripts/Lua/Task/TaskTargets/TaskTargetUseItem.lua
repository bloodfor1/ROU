require "Task/TaskTargets/TaskTargetBase"

--使用道具(对应ItemTable)类型任务目标类
module("Task", package.seeall)

local super = Task.TaskTargetBase
TaskTargetUseItem = class("TaskTargetUseItem", super)

function TaskTargetUseItem:ctor(targetIndex, taskId, taskData, targetData, stepInfo)
    super.ctor(self, targetIndex, taskId, taskData, targetData, stepInfo)
end

--获取任务目标的名称
function TaskTargetUseItem:GetTaskTargetName()
    local l_itemData = TableUtil.GetItemTable().GetRowByItemID(self.targetId)
    if l_itemData == nil then
        logError("item:<" .. tostring(self.targetId) .. "> not exists in ItemTable")
        return ""
    end
    return l_itemData.ItemName
end

function TaskTargetUseItem:ExecutePlayerStopEventLogic(sceneId, position)
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
        btnName = l_ItemUseTableRow.UseItemName,
        taskTarget = self,
        callBack = function()
            local l_itemId = l_ItemUseTableRow.UseItem
            local l_uid = self:_getFirstItemUID(l_itemId)
            if l_uid ~= nil then
                MgrMgr:GetMgr("PropMgr").RequestUseItem(l_uid, l_itemUseNum, l_itemId, 1)
                UIMgr:DeActiveUI(UI.CtrlNames.PropIcon)
            else
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ITEM_NOT_ENOUGH"))
            end
        end,
        closeCondition = function()
            return self:CheckPosInRange(MScene.SceneID, MEntityMgr.PlayerEntity.Position)
        end,
    }

    local panelData={
        ShowQuickUseType=MgrMgr:GetMgr("QuickUseMgr").EShowQuickUseType.SetPropInfo,
        MethodData=l_propInfo
    }
    UIMgr:ActiveUI(UI.CtrlNames.PropIcon, panelData)
end

function TaskTargetUseItem:_getFirstItemUID(tid)
    local items = self:_getBagItemByTID(tid)
    if nil == items then
        return nil
    end

    if 0 == #items then
        return nil
    end

    return items[1]
end

---@return ItemData[]
function TaskTargetUseItem:_getBagItemByTID(tid)
    local itemFuncUtil = MgrProxy:GetItemDataFuncUtil()
    ---@type FiltrateCond
    local condition = { Cond = itemFuncUtil.ItemMatchesTid, Param = tid }
    local conditions = { condition }
    local types = { GameEnum.EBagContainerType.Bag }
    local items = Data.BagApi:GetItemsByTypesAndConds(types, conditions)
    return items
end