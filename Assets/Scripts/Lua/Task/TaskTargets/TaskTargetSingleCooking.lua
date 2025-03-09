require "Task/TaskTargets/TaskTargetBase"

--单人烹饪(对应RecipeTable)类型任务目标类
module("Task", package.seeall)

local super = Task.TaskTargetBase
TaskTargetSingleCooking = class("TaskTargetSingleCooking", super)

function TaskTargetSingleCooking:ctor(targetIndex,taskId, taskData, targetData, stepInfo)
    super.ctor(self,targetIndex,taskId, taskData, targetData, stepInfo)
end

--各目标不同导航处理逻辑  由不同子类实现
function TaskTargetSingleCooking:TaskTargetNavigation()
    
    if self.navData == nil then
        logError("move to SingleCooking:nil")
        ResetActionQueue()
        return
    end

    MgrMgr:GetMgr("ActionTargetMgr").MoveToPos(self.navData.sceneId, self.navData.position, function()
        MgrMgr:GetMgr("CookingSingleMgr").selectTaskRecipe = self.targetId
        if string.ro_isEmpty(self.msgEx) then
            logError("检查烹饪任务"..tostring(self.taskId).."寻路后自动打开物件交互id字段:SpecialMes")
            return
        end
        local l_objId = tonumber(self.msgEx)
        MSceneWallTriggerMgr:SelectSceneObjHudByTriggerId(l_objId)
    end,function( ... )
        MgrMgr:GetMgr("CookingSingleMgr").selectTaskRecipe = nil
    end,90)
        
end

--获取任务目标的名称 
function TaskTargetSingleCooking:GetTaskTargetName()
    local l_recipeData = TableUtil.GetRecipeTable().GetRowByID(self.targetId)
    if l_recipeData == nil then
        logError("recipe:<"..tostring(self.targetId).."> not exists in RecipeTable !")
        return ""
    end
    local l_recipeItemId = l_recipeData.ResultID
    local l_itemData = TableUtil.GetItemTable().GetRowByItemID(l_recipeItemId)
    if l_itemData == nil then
        logError("item:<"..tostring(l_recipeItemId).."> not exists in ItemTable from getting recipe:<"..tostring(self.targetId)..">")
        return ""
    end
    return l_itemData.ItemName
end