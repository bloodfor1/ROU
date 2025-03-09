---@class MoonClient.CommandSystem.BlockIndexArg : MoonClient.CommandSystem.CommandBlockArg
---@field public Value string

---@type MoonClient.CommandSystem.BlockIndexArg
MoonClient.CommandSystem.BlockIndexArg = { }
---@return MoonClient.CommandSystem.BlockIndexArg
function MoonClient.CommandSystem.BlockIndexArg.New() end
---@return MoonClient.CommandSystem.BlockIndexArg
---@param index number
function MoonClient.CommandSystem.BlockIndexArg:Init(index) end
function MoonClient.CommandSystem.BlockIndexArg:Release() end
---@return System.Object
function MoonClient.CommandSystem.BlockIndexArg:Clone() end
return MoonClient.CommandSystem.BlockIndexArg
