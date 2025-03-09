---@class LuaInterface.LuaField

---@type LuaInterface.LuaField
LuaInterface.LuaField = { }
---@return LuaInterface.LuaField
---@param info System.Reflection.FieldInfo
---@param t string
function LuaInterface.LuaField.New(info, t) end
---@return number
---@param L number
function LuaInterface.LuaField:Get(L) end
---@return number
---@param L number
function LuaInterface.LuaField:Set(L) end
return LuaInterface.LuaField
