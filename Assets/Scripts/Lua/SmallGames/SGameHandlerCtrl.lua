module("SGame", package.seeall)

SGameHandlerCtrl=class("SGameHandlerCtrl")

function SGameHandlerCtrl:ctor()
    self.handlerTable={}
end
function SGameHandlerCtrl:ExecuteHandler(handlerArg,resultData)
    local l_handler=self:GetHandler(handlerArg.handlerType)
    if l_handler==nil then
        return
    end
    l_handler:Execute(handlerArg.data,resultData)
end
function SGameHandlerCtrl:GetHandler(handlerType)
    local l_handler=self.handlerTable[handlerType]
    if l_handler~=nil then
        return l_handler
    end
    if handlerType==HandlerType.JumpStep then
        require("SmallGames/handlers/JumpStepHandler")
        l_handler=SGame.JumpStepHandler.new()
    elseif handlerType==HandlerType.SetGameObj then
        require("SmallGames/handlers/SetGameObjHandler")
        l_handler=SGame.SetGameObjHandler.new()
    elseif handlerType==HandlerType.AwakeSGameObj then
        require("SmallGames/handlers/AwakeSGameObjHandler")
        l_handler=SGame.AwakeSGameObjHandler.new()
    elseif handlerType==HandlerType.UpdateSlideValue then
        require("SmallGames/handlers/UpdateSlideHandler")
        l_handler=SGame.UpdateSlideHandler.new()
    elseif handlerType==HandlerType.NotifyResult then
        require("SmallGames/handlers/NotifyResultHandler")
        l_handler=SGame.NotifyResultHandler.new()
    elseif handlerType==HandlerType.PlayEffect then
        require("SmallGames/handlers/PlayUIEffectHandler")
        l_handler=SGame.PlayUIEffectHandler.new()
    elseif handlerType==HandlerType.PlaySound then
        require("SmallGames/handlers/PlaySoundHandler")
        l_handler=SGame.PlaySoundHandler.new()
    else
        logError("SGameHandlerCtrl:GetHandler error:not exist "..tostring(handlerType))
    end
    self.handlerTable[handlerType]=l_handler
    return l_handler
end
function SGameHandlerCtrl:ParseHandlerArg(infoStr)
    local parseData=nil
    local l_splitArray=Common.Utils.ParseString(infoStr,SGame.ParseSeparator.HandlerInfo,1)
    local l_handlerType=tonumber(l_splitArray[1])
    local l_handlerArg=l_splitArray[2]

    local l_handler=self:GetHandler(l_handlerType)
    if l_handler~=nil then
        parseData=l_handler:ParseHandlerArg(l_handlerArg)
    end
    return parseData
end