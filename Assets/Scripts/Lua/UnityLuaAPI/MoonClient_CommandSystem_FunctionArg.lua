---@class MoonClient.CommandSystem.FunctionArg : MoonClient.CommandSystem.BaseArg
---@field public Value string

---@type MoonClient.CommandSystem.FunctionArg
MoonClient.CommandSystem.FunctionArg = { }
---@return MoonClient.CommandSystem.FunctionArg
function MoonClient.CommandSystem.FunctionArg.New() end
function MoonClient.CommandSystem.FunctionArg:Release() end
---@return System.Object
function MoonClient.CommandSystem.FunctionArg:Clone() end
---@return MoonClient.CommandSystem.FunctionArg
---@param func (fun():string)
function MoonClient.CommandSystem.FunctionArg:Init(func) end
return MoonClient.CommandSystem.FunctionArg
