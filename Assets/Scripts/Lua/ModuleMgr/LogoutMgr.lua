
module("ModuleMgr.LogoutMgr", package.seeall)

EventDispatcher = EventDispatcher.new()

OnLogoutEvent = "OnLogoutEvent"

function OnLogout()
    EventDispatcher:Dispatch(OnLogoutEvent)
end

return LogoutMgr
