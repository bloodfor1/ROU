---@class LuaInterface.LuaByteBuffer : System.ValueType
---@field public buffer System.Byte[]
---@field public Length number

---@type LuaInterface.LuaByteBuffer
LuaInterface.LuaByteBuffer = { }
---@overload fun(buf:System.Byte[]): LuaInterface.LuaByteBuffer
---@overload fun(stream:System.IO.MemoryStream): LuaInterface.LuaByteBuffer
---@overload fun(source:number, len:number): LuaInterface.LuaByteBuffer
---@return LuaInterface.LuaByteBuffer
---@param buf System.Byte[]
---@param len number
function LuaInterface.LuaByteBuffer.New(buf, len) end
---@return LuaInterface.LuaByteBuffer
---@param stream System.IO.MemoryStream
function LuaInterface.LuaByteBuffer.op_Implicit(stream) end
return LuaInterface.LuaByteBuffer
