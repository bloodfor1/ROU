---@class MLuaStringBuffer
---@field public buffer System.Byte[]
---@field public buffLen number

---@type MLuaStringBuffer
MLuaStringBuffer = { }
---@return MLuaStringBuffer
---@param initSize number
function MLuaStringBuffer.New(initSize) end
---@param L number
---@param buffer MLuaStringBuffer
function MLuaStringBuffer.Push(L, buffer) end
---@return boolean
---@param buf System.Byte[]
---@param length number
function MLuaStringBuffer:Copy(buf, length) end
return MLuaStringBuffer
