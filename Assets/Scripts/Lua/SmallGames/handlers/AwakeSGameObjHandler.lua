require "SmallGames/SGameHandlerBase"
module("SGame", package.seeall)

local super=SGame.SGameHandlerBase

AwakeSGameObjHandler=class("AwakeSGameObjHandler",super)

function AwakeSGameObjHandler:ctor()
    self.handlerType=HandlerType.AwakeSGameObj
end
function AwakeSGameObjHandler:Execute(handlerArg,resultData)
    if handlerArg==nil or handlerArg.awakeObjName==nil then
        return
    end
    local l_procedureCtrl= self:GetProcedureCtrl()
    if l_procedureCtrl==nil then
        return
    end
    if handlerArg.delayTime~=nil then
        self:DelayExecute(function()
            l_procedureCtrl:AwakeSGameObj(handlerArg.awakeObjName,handlerArg.needExecuteOneStep)
        end ,handlerArg.delayTime)
    else
        l_procedureCtrl:AwakeSGameObj(handlerArg.awakeObjName,handlerArg.needExecuteOneStep)
    end
end
function AwakeSGameObjHandler:ParseArg(infoStr)
    local l_splitArray=Common.Utils.ParseString(infoStr,"_",2)
    if l_splitArray==nil then
        logError("AwakeSGameObjHandler ParseArg error:"..tostring(infoStr))
        return
    end
    local data={}
    data.awakeObjName=l_splitArray[1]
    data.needExecuteOneStep=(tonumber(l_splitArray[2])==1 and {true} or {false})[1]
    if #l_splitArray>2 then
        data.delayTime=tonumber(l_splitArray[3])
    end
    return data
end
return AwakeSGameObjHandler