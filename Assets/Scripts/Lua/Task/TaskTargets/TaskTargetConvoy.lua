--护送类型任务目标类
require "Task/TaskTargets/TaskTargetBase"

module("Task", package.seeall)

local super = Task.TaskTargetBase
TaskTargetConvoy = class("TaskTargetConvoy", super)

function TaskTargetConvoy:ctor(targetIndex,taskId, taskData, targetData, stepInfo)
    super.ctor(self,targetIndex,taskId, taskData, targetData, stepInfo)
    self.startPosition = self.navData
    local l_tmp = string.ro_split(self.msgEx, '=')
    local l_sceneId = tonumber(l_tmp[1]) 
    local l_position = Vector3.New(tonumber(l_tmp[2]),tonumber(l_tmp[3]),tonumber(l_tmp[4]))
    self.navData = {
        sceneId = l_sceneId,
        position = l_position
    }
    self.range = tonumber(l_tmp[6])
end

function TaskTargetConvoy:GetTaskTargetDescribe()
    return self:GetTaskTargetName()
end

function TaskTargetConvoy:GetTaskTargetName()
    local l_npcData = TableUtil.GetNpcTable().GetRowById(self.targetId)
    if l_npcData == nil then
        logError("npc:<"..tostring(self.targetId).."> not exists in NpcTable")
        return ""
    end
    return l_npcData.Name
end

function TaskTargetConvoy:TargetNavigation(navType)
    if self:ValidateIgnoreNavigationInScene() then
        return
    end
    local l_npcPos = MSceneMgr:GetNpcPos(self.targetId, self.navData.sceneId, self.taskId)
    ---@type ModuleMgr.TaskMgr
    local l_taskMgr = MgrMgr:GetMgr("TaskMgr")
    if l_npcPos.x == -1 and l_npcPos.y == -1 and l_npcPos.z == -1 then
        l_taskMgr.GetConvoyNpcPosition(self.taskId,self.targetIndex,navType,function(msg,arg,customData)
                ---@type GetConvoyNpcPosRes
                local l_info = ParseProtoBufToTable("GetConvoyNpcPosRes", msg)
                if l_info.result ~= 0 then
                    return
                end        
                local l_positionData = l_info.pos
                local l_sceneId = l_positionData.scene_id 
                local l_vector3 = l_positionData.pos
                local l_position = Vector3.New(l_vector3.x,l_vector3.y,l_vector3.z)
                self:NavToNpc(l_sceneId,l_position,customData.navType)
        end)
        return true
    end
    if self:IsInConvoy(self.navData.sceneId,l_npcPos) then
        if self.taskData:NavigationInDungeon(self.navData.sceneId) then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("TASK_NAVIGATION_IN_DUNGEON_TIP")) 
            --副本目标提示增强
            MgrMgr:GetMgr("DungeonTargetMgr").TaskGuideToDungeonsTarget()
        else
            self:CheckNavType(navType)
        end
    else
        self:NavToNpc(self.navData.sceneId,l_npcPos,navType)
    end 
end

function TaskTargetConvoy:NavToNpc(npcSceneId,npcPosition,navType)
    local l_taskMgr = MgrMgr:GetMgr("TaskMgr")
    local l_navData = {
        sceneId = npcSceneId,
        position = npcPosition
    }
    l_taskMgr.SetNavData(l_navData)
    if navType == l_taskMgr.ETaskNavType.Normal  then
        MgrMgr:GetMgr("ActionTargetMgr")
                .MoveToPos(npcSceneId, npcPosition)
    end
end

function TaskTargetConvoy:IsInConvoy(npcSceneId,npcPosition)
    local l_playerPos = MEntityMgr.PlayerEntity.Position
    local l_sceneId = MScene.SceneID
    if npcSceneId ~= l_sceneId then return false end
    local dis = math.pow((npcPosition.x - l_playerPos.x), 2) + math.pow((npcPosition.z - l_playerPos.z), 2)
    local tdis = math.pow(self.range, 2)
    if dis < tdis then
        return true
    end
    return false
end

function TaskTargetConvoy:ExecutePlayerStopEventLogic(sceneId,position)
    if not self:CheckPosInRange(sceneId, position) then 
        return 
    end
    self:ReportTaskTargetComplete()
end

function TaskTargetConvoy:TaskReportInfo()
    ---@type TaskReportArg
    local l_sendInfo = GetProtoBufSendTable("TaskReportArg")
    l_sendInfo.postion.sceneid = self.navData.sceneId
    l_sendInfo.postion.x = self.navData.position.x
    l_sendInfo.postion.z = self.navData.position.z
    return l_sendInfo
end


