require "SmallGames/SGameHandlerBase"
module("SGame", package.seeall)

local super=SGame.SGameHandlerBase

UpdateSlideHandler=class("UpdateSlideHandler",super)

function UpdateSlideHandler:ctor()
    self.handlerType=HandlerType.UpdateSlideValue
end
function UpdateSlideHandler:Execute(handlerArg,resultData)
    if handlerArg==nil then
        logError("pdateSlideHandler:Execute handlerArg is nil!")
        return
    end
    if MLuaCommonHelper.IsNull(handlerArg.gameObjCom) then
        logError("UpdateSlideHandler:Execute error:gameObjCom not exist!")
        return
    end
    if resultData.data.data.percent==nil then
        logError("UpdateSlideHandler:Execute error:percent==nil!")
        return
    end
    local l_slideValue=resultData.data.data.percent/100
    handlerArg.gameObjCom.Slider.value=l_slideValue
end
function UpdateSlideHandler:ParseArg(infoStr)
    local l_data={}
    local l_procedureCtrl=self:GetProcedureCtrl()
    if l_procedureCtrl==nil then
        logError("UpdateSlideHandler:ParseArg error:ProcedureCtrl is nil!")
        return
    end
    local l_gameObjCom=l_procedureCtrl.sGameCtrl:GetOperableObject(infoStr)
    if MLuaCommonHelper.IsNull(l_gameObjCom) then
        logError("UpdateSlideHandler:ParseArg error:gameObj not exist!")
        return
    end
    l_data.gameObjCom=l_gameObjCom
    return l_data
end
