require "SmallGames/SGameHandlerBase"
module("SGame", package.seeall)

local super=SGame.SGameHandlerBase

PlayUIEffectHandler=class("PlayUIEffectHandler",super)

function PlayUIEffectHandler:ctor()
    self.handlerType=HandlerType.PlayEffect
end
function PlayUIEffectHandler:Execute(handlerArg,resultData)
    if handlerArg==nil then
        return
    end
    local l_procedureCtrl= self:GetProcedureCtrl()
    if l_procedureCtrl==nil then
        return
    end

    if handlerArg.delayTime~=nil then
        self:DelayExecute(function()
            if l_procedureCtrl.sGameCtrl==nil then
                return
            end
            l_procedureCtrl.sGameCtrl:NoticeShowEffect(handlerArg.effectName,handlerArg.show)
        end ,handlerArg.delayTime)
    else
        l_procedureCtrl.sGameCtrl:NoticeShowEffect(handlerArg.effectName,handlerArg.show)
    end
end
function PlayUIEffectHandler:ParseArg(infoStr)
    local l_splitArray=Common.Utils.ParseString(infoStr,"_",2)
    if l_splitArray==nil then
        logError("PlayUIEffectHandler:ParseArg error!")
        return
    end
    local data={}
    data.effectName=l_splitArray[1]
    data.show=(tonumber(l_splitArray[2])==1 and {true} or {false})[1]
    if #l_splitArray>2 then
        data.delayTime=tonumber(#l_splitArray[3])
    end
    return data
end