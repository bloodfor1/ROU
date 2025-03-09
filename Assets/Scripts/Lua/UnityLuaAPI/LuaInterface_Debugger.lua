---@class LuaInterface.Debugger
---@field public useLog boolean
---@field public threadStack string
---@field public logger LuaInterface.ILogger

---@type LuaInterface.Debugger
LuaInterface.Debugger = { }
---@overload fun(str:string): void
---@overload fun(message:System.Object): void
---@overload fun(str:string, arg0:System.Object): void
---@overload fun(str:string, param:System.Object[]): void
---@overload fun(str:string, arg0:System.Object, arg1:System.Object): void
---@param str string
---@param arg0 System.Object
---@param arg1 System.Object
---@param arg2 System.Object
function LuaInterface.Debugger.Log(str, arg0, arg1, arg2) end
---@overload fun(str:string): void
---@overload fun(message:System.Object): void
---@overload fun(str:string, arg0:System.Object): void
---@overload fun(str:string, param:System.Object[]): void
---@overload fun(str:string, arg0:System.Object, arg1:System.Object): void
---@param str string
---@param arg0 System.Object
---@param arg1 System.Object
---@param arg2 System.Object
function LuaInterface.Debugger.LogWarning(str, arg0, arg1, arg2) end
---@overload fun(str:string): void
---@overload fun(message:System.Object): void
---@overload fun(str:string, arg0:System.Object): void
---@overload fun(str:string, param:System.Object[]): void
---@overload fun(str:string, arg0:System.Object, arg1:System.Object): void
---@param str string
---@param arg0 System.Object
---@param arg1 System.Object
---@param arg2 System.Object
function LuaInterface.Debugger.LogError(str, arg0, arg1, arg2) end
---@overload fun(e:System.Exception): void
---@param str string
---@param e System.Exception
function LuaInterface.Debugger.LogException(str, e) end
return LuaInterface.Debugger
