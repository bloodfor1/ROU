---@class MoonClient.MEventMgr : MoonCommonLib.MSingleton_MoonClient.MEventMgr

---@type MoonClient.MEventMgr
MoonClient.MEventMgr = { }
---@return MoonClient.MEventMgr
function MoonClient.MEventMgr.New() end
---@return boolean
function MoonClient.MEventMgr:Init() end
function MoonClient.MEventMgr:Uninit() end
---@param eventType number
---@param firer MoonClient.IEventDispatcher
---@param args MoonClient.IEventArg
function MoonClient.MEventMgr:FireEvent(eventType, firer, args) end
---@param eventType number
---@param firer MoonClient.IEventDispatcher
---@param args0 System.Object
---@param args1 System.Object
---@param args2 System.Object
---@param args3 System.Object
---@param args4 System.Object
---@param args5 System.Object
---@param args6 System.Object
---@param args7 System.Object
function MoonClient.MEventMgr:LuaFireEvent(eventType, firer, args0, args1, args2, args3, args4, args5, args6, args7) end
---@param eventType number
---@param args MoonClient.IEventArg
function MoonClient.MEventMgr:FireGlobalEvent(eventType, args) end
---@return number
---@param eventType number
---@param delay number
---@param args MoonClient.IEventArg
function MoonClient.MEventMgr:FireGlobalEventDelay(eventType, delay, args) end
---@param token number
function MoonClient.MEventMgr:CancelDelayGlobalEvent(token) end
---@param eventType number
---@param args0 System.Object
---@param args1 System.Object
---@param args2 System.Object
---@param args3 System.Object
---@param args4 System.Object
---@param args5 System.Object
---@param args6 System.Object
---@param args7 System.Object
function MoonClient.MEventMgr:LuaFireGlobalEvent(eventType, args0, args1, args2, args3, args4, args5, args6, args7) end
---@param eventType number
---@param callback MoonClient.MEventHandler
function MoonClient.MEventMgr:RegisterGlobalEvent(eventType, callback) end
---@param eventType number
---@param callback MoonClient.MEventHandler
function MoonClient.MEventMgr:RemoveGlobalEvent(eventType, callback) end
---@param epc (fun():void)
function MoonClient.MEventMgr:RegisterEventPool(epc) end
function MoonClient.MEventMgr:Clear() end
return MoonClient.MEventMgr
