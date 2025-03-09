require "Task/TaskTargets/TaskTargetBase"

--完成副本(对应DungeonsTable)类型任务目标类
module("Task", package.seeall)

local super = Task.TaskTargetBase
TaskTargetDungeonsComplete = class("TaskTargetDungeonsComplete", super)

function TaskTargetDungeonsComplete:ctor(targetIndex,taskId, taskData, targetData, stepInfo)
    super.ctor(self,targetIndex,taskId, taskData, targetData, stepInfo)
    self.npcData = nil
    if not string.ro_isEmpty(self.msgEx) then
        local targetArg = string.ro_split(self.msgEx, "=")
        if #targetArg == 2 then
            local l_npcId = tonumber(targetArg[1])
            local l_sceneId = tonumber(targetArg[2])
            self.npcData = 
            {
                sceneId = l_sceneId,
                npcId = l_npcId
            }

        else
            logError("task <"..tostring(self.taskId).."> target <".."> SpecialMsg is incorrect format 'npcId = sceneId'")
        end
    end
end

function TaskTargetDungeonsComplete:GetNavigationData( ... )
    if MgrMgr:GetMgr("DungeonMgr").CheckPlayerInDungeon(self.targetId) then
        return nil
    end
    return super.GetNavigationData(self)
end

function TaskTargetDungeonsComplete:ValidateNavData( ... )

    if self.npcData ~= nil then
        local l_npcId = self.npcData.npcId
        local l_sceneId = self.npcData.sceneId
        local l_npcPos = MSceneMgr:GetNpcPos(l_npcId, l_sceneId,self.taskId)
        if l_npcPos == nil or l_npcPos.x == -1 and l_npcPos.y == -1 and l_npcPos.z == -1 then
            self.navData = nil
        else 
            self.navData = {
                sceneId = l_sceneId,
                position = l_npcPos
            }
        end  
    end
end


function TaskTargetDungeonsComplete:TargetNavigation(navType)
    if MPlayerDungeonsInfo.InDungeon then
        if MPlayerInfo.PlayerDungeonsInfo.DungeonID == self.targetId then
            --自身指定副本中的提示
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("TASK_TARGET_DUNGEONS_COMPLETED_IN_DUNGEONS_TIP"))
        else
            --在别的副本中的提示
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("TASK_NAVIGATION_IN_DUNGEON_TIP")) 
        end
        --副本目标提示增强
        MgrMgr:GetMgr("DungeonTargetMgr").TaskGuideToDungeonsTarget()
        return
    end
    super.TargetNavigation(self,navType)
end

--各目标不同导航处理逻辑  由不同子类实现
function TaskTargetDungeonsComplete:TaskTargetNavigation() 
    if self.npcData ~= nil then
        MgrMgr:GetMgr("ActionTargetMgr").MoveToTalkWithNpc(self.npcData.sceneId, self.npcData.npcId)
    else
        if self.navData then
            MgrMgr:GetMgr("ActionTargetMgr").MoveToPos(self.navData.sceneId, self.navData.position)
        end    
    end
end

--获取任务目标的名称 
function TaskTargetDungeonsComplete:GetTaskTargetName()
    local l_dungeonData = TableUtil.GetDungeonsTable().GetRowByDungeonsID(self.targetId)
    if l_dungeonData == nil then
        logError("dungeon:<"..tostring(self.targetId).."> not exists in DungeonsTable !")
        return ""
    end
    return l_dungeonData.DungeonsName
end
