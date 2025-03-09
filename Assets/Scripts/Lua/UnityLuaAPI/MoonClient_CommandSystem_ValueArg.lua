---@class MoonClient.CommandSystem.ValueArg : MoonClient.CommandSystem.BaseArg
---@field public Value string

---@type MoonClient.CommandSystem.ValueArg
MoonClient.CommandSystem.ValueArg = { }
---@return MoonClient.CommandSystem.ValueArg
function MoonClient.CommandSystem.ValueArg.New() end
function MoonClient.CommandSystem.ValueArg:Release() end
---@return System.Object
function MoonClient.CommandSystem.ValueArg:Clone() end
---@return MoonClient.CommandSystem.ValueArg
---@param value string
function MoonClient.CommandSystem.ValueArg:Init(value) end
return MoonClient.CommandSystem.ValueArg
