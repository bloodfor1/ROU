module("SGame", package.seeall)
require("SmallGames/SGameObject")
SGameProcedureCtrl=class("SGameProcedureCtrl")

function SGameProcedureCtrl:ctor()
    self.hasGame=false
    self.gameID=0
    self.sGameCtrl=nil
    self.operableObjects={}
    self.smallGameTimers={}
end
function SGameProcedureCtrl:Clear() --todo
    self.hasGame=false
    self.gameID=0
    self.sGameCtrl=nil
    self.operableObjects={}
    if #self.smallGameTimers>0 then
        for k,v in pairs(self.smallGameTimers) do
            if v~=nil then
                v:Stop()
            end
        end
        self.smallGameTimers={}
    end
end
function SGameProcedureCtrl:BuildGameProcedure(gameData,sGameCtrl)
    if self.hasGame then
        logError("打开小游戏失败， SmallGame ID:"..tostring(self.gameID).." 正在进行中！")
        return
    end
    self.sGameCtrl=sGameCtrl
    local l_objectArray=Common.Utils.ParseString(gameData,SGame.ParseSeparator.SmallGameObject,1)--小游戏 对象间用‘;’分隔
    if l_objectArray==nil then
        self:LoadSmallGameFailed("no object exist!")
        return
    end
    for i = 1, #l_objectArray do
        local operableObject= SGame.SGameObject.new(l_objectArray[i],self)
        self.operableObjects[operableObject.objectName]=operableObject
    end
    self.hasGame=true
end
function SGameProcedureCtrl:GetObjectInfo(objectName)
    if not self.hasGame then
        return
    end
    return self.operableObjects[objectName]
end
function SGameProcedureCtrl:ClearGameData()
    if not self.hasGame then
        return
    end
    self.operableObjects={}
    self.hasGame=false
end
function SGameProcedureCtrl:PrintObjectInfo()
    if not self.hasGame then
        self:LoadErrorLog("current not exist game!")
        return
    end
    logError("gameID:"..tostring(self.gameID))
    for k,v in pairs(self.operableObjects) do
        logError("objectName:"..k)
        v:PrintObjectInfo()
    end
end
function SGameProcedureCtrl:ExecuteOneStep(objectName)
    if not self.hasGame then
        return
    end
    local l_object= self.operableObjects[objectName]
    if l_object==nil then
        logError("SGameProcedureCtrl:ExecuteOneStep error!not exist ："..tostring(objectName))
        return
    end
    l_object:ExecuteOneStep()
end
function SGameProcedureCtrl:AwakeSGameObj(objectName,isExecuteOneStep)
    if not self.hasGame then
        return
    end
    local l_object= self.operableObjects[objectName]
    if l_object==nil then
        logError("SGameProcedureCtrl:AwakeSGameObj error!not exist ："..tostring(objectName))
        return
    end
    l_object:AwakeObject(isExecuteOneStep)
end
function SGameProcedureCtrl:CloseCurrentGame()
    self:ClearGameData()
end
function SGameProcedureCtrl:JumpStep(objectName,toStepId)
    if not self.hasGame then
        return
    end
    local l_sGameObject= self.operableObjects[objectName]
    if l_sGameObject==nil then
        logError("SGameProcedureCtrl:JumpStep error:"..objectName)
        return
    end
    l_sGameObject:SetNextStep(toStepId)
end
function SGameProcedureCtrl:RegisterTimer(timer)
    if timer==nil then
        return
    end
    table.insert( self.smallGameTimers,timer)
end
function SGameProcedureCtrl:OperateObject(data)

end
function SGameProcedureCtrl:LoadErrorLog(error)
    logError(error)
end
function SGameProcedureCtrl:LoadSmallGameFailed(reason)
    logError(reason)
end

return SGameProcedureCtrl