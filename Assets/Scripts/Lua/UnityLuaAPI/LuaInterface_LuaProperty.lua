---@class LuaInterface.LuaProperty

---@type LuaInterface.LuaProperty
LuaInterface.LuaProperty = { }
---@return LuaInterface.LuaProperty
---@param prop System.Reflection.PropertyInfo
---@param t string
function LuaInterface.LuaProperty.New(prop, t) end
---@return number
---@param L number
function LuaInterface.LuaProperty:Get(L) end
---@return number
---@param L number
function LuaInterface.LuaProperty:Set(L) end
return LuaInterface.LuaProperty
