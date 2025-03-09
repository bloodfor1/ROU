---@class MoonClient.CommandSystem.BlockVarArg : MoonClient.CommandSystem.CommandBlockArg
---@field public Value string

---@type MoonClient.CommandSystem.BlockVarArg
MoonClient.CommandSystem.BlockVarArg = { }
---@return MoonClient.CommandSystem.BlockVarArg
function MoonClient.CommandSystem.BlockVarArg.New() end
---@return MoonClient.CommandSystem.BlockVarArg
---@param varName string
function MoonClient.CommandSystem.BlockVarArg:Init(varName) end
function MoonClient.CommandSystem.BlockVarArg:Release() end
---@return System.Object
function MoonClient.CommandSystem.BlockVarArg:Clone() end
return MoonClient.CommandSystem.BlockVarArg
