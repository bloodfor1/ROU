---@class LuaInterface.LuaMethod

---@type LuaInterface.LuaMethod
LuaInterface.LuaMethod = { }
---@return LuaInterface.LuaMethod
---@param md System.Reflection.MethodInfo
---@param t string
---@param types System.Type[]
function LuaInterface.LuaMethod.New(md, t, types) end
---@return number
---@param L number
function LuaInterface.LuaMethod:Call(L) end
function LuaInterface.LuaMethod:Destroy() end
return LuaInterface.LuaMethod
