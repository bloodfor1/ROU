require "Task/TaskTargets/TaskTargetBase"

--打怪掉落(对应ItemTable)类型任务目标类
module("Task", package.seeall)

local super = Task.TaskTargetBase
TaskTargetMonsterLoot = class("TaskTargetMonsterLoot", super)

function TaskTargetMonsterLoot:ctor(targetIndex,taskId, taskData, targetData, stepInfo)
    super.ctor(self,targetIndex,taskId, taskData, targetData, stepInfo)
end


--各目标不同导航处理逻辑  由不同子类实现
function TaskTargetMonsterLoot:TaskTargetNavigation()

    local l_monster = nil   
    if self.Id == 0 then
        local l_dropData = TableUtil.GetTaskDropTable().GetRowByID(self.taskId)
        if l_dropData ~= nil and l_dropData.type == 1 then
            l_monster = l_dropData
        end
    else
        local l_dropData = TableUtil.GetTaskDropTable().GetRowByID(self.Id)
        if l_dropData ~= nil and l_dropData.type == 2 then
            l_monster = l_dropData
        end
    end

    if l_monster ~= nil and self.navData then
        local l_monsterLoot = Common.Functions.VectorSequenceToTable(l_monster.MonsterDrop)
        local l_monsterIds = {}
        for i=1,#l_monsterLoot do
            local l_monsterData = l_monsterLoot[i]
            if l_monsterData ~= nil then
                local l_monsterId = l_monsterData[1]
                local l_monsterLoot = l_monsterData[2]
                if l_monsterLoot == self.targetId then
                    table.insert(l_monsterIds,l_monsterId)
                end
            end
        end
        MgrMgr:GetMgr("ActionTargetMgr")
            .MoveToPos(self.navData.sceneId, self.navData.position)
            .KillMonster(l_monsterIds)
    end

end

--获取任务目标的飘字提示
function TaskTargetMonsterLoot:GetTaskTargetTip()
    local l_str = GetColorText(self:GetTaskTargetName() .. ":", RoColorTag.Yellow) .. GetColorText(self:GetTaskTargetStepTip(), RoColorTag.None)
    return l_str
end

--获取任务目标的名称
function TaskTargetMonsterLoot:GetTaskTargetName()
    local l_itemData = TableUtil.GetItemTable().GetRowByItemID(self.targetId)
    if l_itemData == nil then
        logError("item:<"..tostring(self.targetId).."> not exists in ItemTable")
        return ""
    end
    return l_itemData.ItemName
end

