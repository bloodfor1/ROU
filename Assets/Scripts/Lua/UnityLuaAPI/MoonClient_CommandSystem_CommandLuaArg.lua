---@class MoonClient.CommandSystem.CommandLuaArg : MoonClient.CommandSystem.CommandBlockArg
---@field public Value string

---@type MoonClient.CommandSystem.CommandLuaArg
MoonClient.CommandSystem.CommandLuaArg = { }
---@return MoonClient.CommandSystem.CommandLuaArg
function MoonClient.CommandSystem.CommandLuaArg.New() end
---@return MoonClient.CommandSystem.CommandLuaArg
---@param macro string
function MoonClient.CommandSystem.CommandLuaArg:Init(macro) end
function MoonClient.CommandSystem.CommandLuaArg:Release() end
---@return System.Object
function MoonClient.CommandSystem.CommandLuaArg:Clone() end
return MoonClient.CommandSystem.CommandLuaArg
