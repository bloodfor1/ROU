---@class LuaInterface.EventObject
---@field public op number
---@field public func (fun():void)
---@field public name string

---@type LuaInterface.EventObject
LuaInterface.EventObject = { }
---@return LuaInterface.EventObject
---@param name string
function LuaInterface.EventObject.New(name) end
---@return LuaInterface.EventObject
---@param a LuaInterface.EventObject
---@param b (fun():void)
function LuaInterface.EventObject.op_Addition(a, b) end
---@return LuaInterface.EventObject
---@param a LuaInterface.EventObject
---@param b (fun():void)
function LuaInterface.EventObject.op_Subtraction(a, b) end
---@return string
function LuaInterface.EventObject:ToString() end
return LuaInterface.EventObject
