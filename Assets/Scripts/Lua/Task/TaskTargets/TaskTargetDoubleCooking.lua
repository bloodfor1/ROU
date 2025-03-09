require "Task/TaskTargets/TaskTargetBase"

--双人烹饪(副本)(对应DungeonsTable)类型任务目标类
module("Task", package.seeall)

local super = Task.TaskTargetBase
TaskTargetDoubleCooking = class("TaskTargetDoubleCooking", super)

function TaskTargetDoubleCooking:ctor(targetIndex,taskId, taskData, targetData, stepInfo)
    super.ctor(self,targetIndex,taskId, taskData, targetData, stepInfo)
end

--各目标不同导航处理逻辑  由不同子类实现
function TaskTargetDoubleCooking:TaskTargetNavigation()
    
    if MgrMgr:GetMgr("TaskMgr").TaskAcceptValidateIdentity(self.taskId) ~= MgrMgr:GetMgr("TaskMgr").ETaskAcceptFailed.None then
        -- logGreen("not request")
        return
    end
    --确认是否已经在双人烹饪的副本中
    if MgrMgr:GetMgr("DungeonMgr").CheckPlayerInDungeon(self.targetId) then
        return
    end
    --请求进入双人烹饪副本
    local l_msgId = Network.Define.Ptc.CaptainRequestEnterFBPtc
    ---@type CaptainRequestEnterFBData
    local l_sendInfo = GetProtoBufSendTable("CaptainRequestEnterFBData")
    l_sendInfo.dungeon_id = self.targetId
    Network.Handler.SendPtc(l_msgId, l_sendInfo)
        
end

--获取任务目标的名称 
function TaskTargetDoubleCooking:GetTaskTargetName()
    local l_dungeonData = TableUtil.GetDungeonsTable().GetRowByDungeonsID(self.targetId)
    if l_dungeonData == nil then
        logError("dungeon:<"..tostring(self.targetId).."> not exists in DungeonsTable !")
        return ""
    end
    return l_dungeonData.DungeonsName
end
