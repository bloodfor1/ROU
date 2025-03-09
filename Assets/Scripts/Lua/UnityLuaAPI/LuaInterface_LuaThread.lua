---@class LuaInterface.LuaThread : LuaInterface.LuaBaseRef

---@type LuaInterface.LuaThread
LuaInterface.LuaThread = { }
---@return LuaInterface.LuaThread
---@param reference number
---@param state LuaInterface.LuaState
function LuaInterface.LuaThread.New(reference, state) end
---@return number
function LuaInterface.LuaThread:Resume() end
return LuaInterface.LuaThread
