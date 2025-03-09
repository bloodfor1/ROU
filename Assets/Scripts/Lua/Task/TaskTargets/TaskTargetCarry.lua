--搬运(对应CarryItemTable)类型任务目标类
require "Task/TaskTargets/TaskTargetBase"

module("Task", package.seeall)

local super = Task.TaskTargetBase
TaskTargetCarry = class("TaskTargetCarry", super)

function TaskTargetCarry:ctor(targetIndex,taskId, taskData, targetData, stepInfo)
    super.ctor(self,targetIndex,taskId, taskData, targetData, stepInfo)
    self.startPosition = self.navData
    self.endPosition = nil
    if not string.ro_isEmpty(self.msgEx) then
        local targetArg = string.ro_split(self.msgEx, "=")
        if #targetArg == 4 then
            local l_sceneId = tonumber(targetArg[1])
            local l_posX = tonumber(targetArg[2])
            local l_posY = tonumber(targetArg[3])
            local l_posZ = tonumber(targetArg[4])
            if l_sceneId ~= 0 and l_posX ~= -1 and l_posY ~= -1 and l_posZ ~= -1 then
                self.endPosition = {}
                self.endPosition.sceneId = l_sceneId
                self.endPosition.position = Vector3.New(l_posX,l_posY,l_posZ)
            end
        end
    end

    if self.endPosition == nil then
        local l_debugInfo = MgrMgr:GetMgr("TaskMgr").DEBUT_TASK_NAMES[self.taskData.tableData.taskType]
        logError("任务 <"..self.taskId.."> 第"..self.targetIndex.."个目标搬运目的地配置错误 @"..l_debugInfo[1]..",<"..l_debugInfo[2]..">")
    end
    self.isCarrying  = nil
end

function TaskTargetCarry:Update( ... )
    if MEntityMgr.PlayerEntity == nil then
        return  
    end
    if self.isCarrying  == nil and MEntityMgr.PlayerEntity then
        self.isCarrying = MEntityMgr.PlayerEntity.InCarrying
        MgrMgr:GetMgr("TaskMgr").UpdateSelectTaskNavigation(self.taskData)
        return  
    end
    if self.isCarrying ~= MEntityMgr.PlayerEntity.InCarrying then
        self.isCarrying = MEntityMgr.PlayerEntity.InCarrying
        MgrMgr:GetMgr("TaskMgr").UpdateSelectTaskNavigation(self.taskData)
    end
end

function TaskTargetCarry:ValidateNavData(...)
    if MEntityMgr.PlayerEntity.InCarrying and MEntityMgr.PlayerEntity.CarryingID == self.targetId then
        self.navData = self.endPosition
    else
        self.navData = self.startPosition
    end
end

function TaskTargetCarry:ExecutePlayerStopEventLogic(sceneId,position)
    if not self:CheckPosInRange(sceneId, position) then 
        return 
    end
    self:ReportTaskTargetComplete()
end

function TaskTargetCarry:TaskReportInfo()
    ---@type TaskReportArg
    local l_sendInfo = GetProtoBufSendTable("TaskReportArg")
    l_sendInfo.postion.sceneid = self.endPosition.sceneId
    l_sendInfo.postion.x = self.endPosition.position.x
    l_sendInfo.postion.z = self.endPosition.position.z
    return l_sendInfo
end

--判断位置坐标是否在规定范围内
--sceneId   玩家场景Id
--position  玩家坐标
--range     偏差范围 默认1.5
function TaskTargetCarry:CheckPosInRange(sceneId, position, range)
    -- if self.navData == nil then return false end
    local l_range = range or 1.5
    local l_targetSceneId = self.endPosition.sceneId
    local l_taregtPosition = self.endPosition.position
    if sceneId ~= l_targetSceneId then return false end
    local dis = math.pow((l_taregtPosition.x - position.x), 2) + math.pow((l_taregtPosition.z - position.z), 2)
    local tdis = math.pow(l_range, 2)
    if dis < tdis then
        return true
    end
    return false
end

function TaskTargetCarry:GetTaskTargetName()
    local l_carryItemData = TableUtil.GetCarryItemTable().GetRowByID(self.targetId)
    if l_carryItemData == nil then
        logError("carray item :<"..tostring(self.targetId).."> not exists in CarryItemTable !")
        return ""
    end
    return l_carryItemData.Name
end


function TaskTargetCarry:AddTaskEvent()
    if self.isEventAdded then return end
    super.AddTaskEvent(self)
    MgrMgr:GetMgr("TaskMgr").RegisterUpdater(self)
end

--监听事件移除
function TaskTargetCarry:RemoveTaskEvent()
    if not self.isEventAdded then
        return
    end
    super.RemoveTaskEvent(self)
    MgrMgr:GetMgr("TaskMgr").RemoveUpdater(self)

end

function TaskTargetCarry:Destroy( ... )
    super.Destroy(self)
    self.isCarrying = nil
end


