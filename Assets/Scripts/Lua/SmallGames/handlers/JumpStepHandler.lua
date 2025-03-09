require "SmallGames/SGameHandlerBase"
module("SGame", package.seeall)

local super=SGame.SGameHandlerBase

JumpStepHandler=class("JumpStepHandler",super)

function JumpStepHandler:ctor()
    self.handlerType=HandlerType.JumpStep
end
function JumpStepHandler:Execute(handlerArg,resultData)
    if handlerArg==nil then
        return
    end
    local l_procedureCtrl= self:GetProcedureCtrl()
    if l_procedureCtrl~=nil then
        if handlerArg.objectName==nil then
            logError("JumpStepHandler:Execute handlerArg.objectName==nil:"..tostring(resultData.sGameObj~=nil))
            if resultData.sGameObj~=nil then
                l_procedureCtrl:JumpStep(resultData.sGameObj.objectName,handlerArg.toStepId)
            else
                logError("JumpStepHandler:Execute error:resultData.sGameObj is nil!")
            end
        else
            l_procedureCtrl:JumpStep(handlerArg.objectName,handlerArg.toStepId)
        end
    end
end
function JumpStepHandler:ParseArg(infoStr)
    local l_splitArray=Common.Utils.ParseString(infoStr,"_",1)
    if l_splitArray==nil then
        logError("JumpStepHandler:ParseArg error!")
        return
    end
    local data={}
    data.toStepId=tonumber(infoStr)
    if #l_splitArray>1 then
        data.objectName=l_splitArray[2]
    end
    return data
end