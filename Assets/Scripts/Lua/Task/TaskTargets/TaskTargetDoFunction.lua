require "Task/TaskTargets/TaskTargetBase"

--完成某项功能(对应OpenSystemTable)类型任务目标类
module("Task", package.seeall)
local super = Task.TaskTargetBase
TaskTargetDoFunction = class("TaskTargetDoFunction", super)

function TaskTargetDoFunction:ctor(targetIndex,taskId, taskData, targetData, stepInfo)
    super.ctor(self,targetIndex,taskId, taskData, targetData, stepInfo)
    self.npcId = nil
    self.sceneId = nil  
    if not string.ro_isEmpty(self.msgEx) then
        local targetArg = string.ro_split(self.msgEx, "=")
        local l_npcId = tonumber(targetArg[1])
        local l_sceneId = tonumber(targetArg[2])
        self.sceneId = l_sceneId
        self.npcId = l_npcId    
    end
end

function TaskTargetDoFunction:ValidateNavData()
    if self.sceneId ~= nil and self.npcId ~= nil then
        local l_npcPos = MSceneMgr:GetNpcPos(self.npcId, self.sceneId,self.taskId)
        if l_npcPos == nil or l_npcPos.x == -1 and l_npcPos.y == -1 and l_npcPos.z == -1 then
            self.navData = nil
        else
            self.navData = {
                sceneId = self.sceneId ,
                position = l_npcPos
            }
        end
    end
end

--各目标不同导航处理逻辑  由不同子类实现
function TaskTargetDoFunction:TaskTargetNavigation()
    if self.navData then
        if self.npcId ~= nil and self.sceneId ~= nil then
            MgrMgr:GetMgr("ActionTargetMgr")
                .MoveToNpc(self.sceneId, self.npcId,function( ... )
                self:OpenSystem()
            end)
        else
            MgrMgr:GetMgr("ActionTargetMgr")
                .MoveToPos(self.navData.sceneId, self.navData.position,function ( ... )
                    self:OpenSystem()
                end)
        end

    else
        self:OpenSystem()
    end
end

function TaskTargetDoFunction:OpenSystem( ... )
    if not MgrMgr:GetMgr("SystemFunctionEventMgr").IsHaveSystemFunctionEvent(self.targetId) then
        return
    end
    local l_systemFunction = MgrMgr:GetMgr("SystemFunctionEventMgr").GetSystemFunctionEvent(self.targetId)
    if l_systemFunction ~= nil then
        l_systemFunction()
    end
end

--获取任务目标的飘字提示
function TaskTargetDoFunction:GetTaskTargetTip()
    local l_str = GetColorText(self:GetTaskTargetName() .. ":", RoColorTag.Yellow) .. GetColorText(self:GetTaskTargetStepTip(), RoColorTag.None)
    return l_str
end

--获取任务目标的名称
function TaskTargetDoFunction:GetTaskTargetName()
    local l_openSysData = TableUtil.GetOpenSystemTable().GetRowById(self.targetId)
    if l_openSysData == nil then
        logError("OpenSystem:<"..tostring(self.targetId).."> not exists in OpenSystemTable")
        return ""
    end
    return l_openSysData.Title
end
