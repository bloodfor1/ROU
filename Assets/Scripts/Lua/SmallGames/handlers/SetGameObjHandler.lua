require "SmallGames/SGameHandlerBase"
module("SGame", package.seeall)

local super=SGame.SGameHandlerBase

SetGameObjHandler=class("SetGameObjHandler",super)

function SetGameObjHandler:ctor()
    self.handlerType=HandlerType.SetGameObj
end
function SetGameObjHandler:Execute(handlerArg,resultData)
    if handlerArg==nil then
        return
    end
    local l_procedureCtrl= self:GetProcedureCtrl()
    if l_procedureCtrl==nil then
        return
    end
    if handlerArg.objectName==nil then
        logError("SetGameObjHandler:Execute error:handlerArg.objectName==nil!")
        return
    end
    local l_gameObjCom=l_procedureCtrl.sGameCtrl:GetOperableObject(handlerArg.objectName)
    if MLuaCommonHelper.IsNull(l_gameObjCom) then
        logError("SetGameObjHandler:Execute error:gameObj not exist!")
        return
    end
    if handlerArg.delayTime~=nil then
        self:DelayExecute(function()
            if not MLuaCommonHelper.IsNull(l_gameObjCom) then
                l_gameObjCom:SetActiveEx(handlerArg.active)
            end
        end ,handlerArg.delayTime)
    else
        l_gameObjCom:SetActiveEx(handlerArg.active)
    end
end
function SetGameObjHandler:ParseArg(infoStr)
    local l_splitArray=Common.Utils.ParseString(infoStr,"_",2)
    if l_splitArray==nil then
        logError("SetGameObjHandler:ParseArg error!")
        return
    end
    local data={}
    data.objectName=l_splitArray[1]
    data.active=(tonumber(l_splitArray[2])==1 and {true} or {false})[1]
    if #l_splitArray>2 then
        data.delayTime=tonumber(#l_splitArray[3])
    end
    return data
end