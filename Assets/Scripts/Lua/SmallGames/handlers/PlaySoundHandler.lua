require "SmallGames/SGameHandlerBase"
module("SGame", package.seeall)

local super=SGame.SGameHandlerBase

PlaySoundHandler=class("PlaySoundHandler",super)

function PlaySoundHandler:ctor()
    self.handlerType=HandlerType.PlaySound
end
function PlaySoundHandler:Execute(handlerArg,resultData)
    if handlerArg==nil then
        return
    end
    if handlerArg.delayTime~=nil then
        self:DelayExecute(function()
            MAudioMgr:Play(handlerArg.soundID)
        end ,handlerArg.delayTime)
    else
        MAudioMgr:Play(handlerArg.soundID)
    end
end
function PlaySoundHandler:ParseArg(infoStr)
    local l_splitArray=Common.Utils.ParseString(infoStr,"_",1)
    if l_splitArray==nil then
        logError("PlaySoundHandler:ParseArg error!")
        return
    end
    local l_data={}
    l_data.soundID=tonumber(l_splitArray[1])

    if #l_splitArray>1 then
        l_data.delayTime=tonumber(#l_splitArray[2])
    end
    return l_data
end
return PlaySoundHandler