require "Task/TaskTargets/TaskTargetBase"

--单人公共载具(对应VehiclePublicTable)类型任务目标类
module("Task", package.seeall)

local super = Task.TaskTargetBase
TaskTargetPublicVehicleSingle = class("TaskTargetPublicVehicleSingle",super)

function TaskTargetPublicVehicleSingle:ctor(targetIndex,taskId, taskData, targetData, stepInfo)
    super.ctor(self,targetIndex,taskId, taskData, targetData, stepInfo)
end

--各目标不同导航处理逻辑  由不同子类实现
function TaskTargetPublicVehicleSingle:TaskTargetNavigation()
    
    if self.navData then
        MgrMgr:GetMgr("ActionTargetMgr")
            .MoveToPos(self.navData.sceneId, self.navData.position)
            .PublicVehicle(self.targetId)
    else
        MgrMgr:GetMgr("ActionTargetMgr").PublicVehicle(self.targetId)
    end
        
end

function TaskTargetPublicVehicleSingle:GetTaskTargetStepTip()
    return nil
end

--获取任务目标的名称 
function TaskTargetPublicVehicleSingle:GetTaskTargetName()
    local l_vehicleData = TableUtil.GetVehiclePublicTable().GetRowByID(self.targetId)
    if l_vehicleData == nil then
        logError("vehicle:<"..tostring(self.targetId).."> not exists in VehiclePublicTable !")
        return ""
    end
    return l_vehicleData.Name
end
