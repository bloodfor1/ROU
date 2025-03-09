module("SGame", package.seeall)

SGameHandlerBase=class("SGameHandlerBase")

function SGameHandlerBase:ctor()

end
function SGameHandlerBase:Execute(handlerArg,resultData)
    logError("SGameHandlerBase:Execute handler 没有实现！")
end
function SGameHandlerBase:ParseArg(infoStr)
end
function SGameHandlerBase:ParseHandlerArg(infoStr)
    local data={}
    data.handlerType=self.handlerType
    data.data=self:ParseArg(infoStr)
    return data
end
function SGameHandlerBase:GetProcedureCtrl()
    return MgrMgr:GetMgr("SmallGameMgr").GetProcedureCtrl()
end
function SGameHandlerBase:DelayExecute(func,duration)
    local l_timer= Timer.New(func, duration, 1, false)
    l_timer:Start()
    self:GetProcedureCtrl().RegisterTimer(l_timer)
end