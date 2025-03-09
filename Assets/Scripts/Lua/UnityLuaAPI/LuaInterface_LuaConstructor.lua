---@class LuaInterface.LuaConstructor

---@type LuaInterface.LuaConstructor
LuaInterface.LuaConstructor = { }
---@return LuaInterface.LuaConstructor
---@param func System.Reflection.ConstructorInfo
---@param types System.Type[]
function LuaInterface.LuaConstructor.New(func, types) end
---@return number
---@param L number
function LuaInterface.LuaConstructor:Call(L) end
function LuaInterface.LuaConstructor:Destroy() end
return LuaInterface.LuaConstructor
