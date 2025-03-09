require "SmallGames/SGameHandlerBase"
module("SGame", package.seeall)

local super=SGame.SGameHandlerBase

NotifyResultHandler=class("NotifyResultHandler",super)

function NotifyResultHandler:ctor()
    self.handlerType=HandlerType.NotifyResult
end
function NotifyResultHandler:Execute(handlerArg,resultData)
    if handlerArg==nil then
        return
    end
    local l_data={}
    l_data.win=handlerArg.win
    MgrMgr:GetMgr("SmallGameMgr").NotifySmallGameResult(l_data)
end
function NotifyResultHandler:ParseArg(infoStr)
    local l_data={}
    l_data.win=(tonumber(infoStr)==1 and {true} or {false})[1]
    return l_data
end