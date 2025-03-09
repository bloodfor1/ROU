---@class MoonClient.CommandSystem.CommandBlockStringArg : MoonClient.CommandSystem.CommandBlockArg
---@field public ArgsRegex string
---@field public _formatArgs System.Collections.Generic.List_MoonClient.CommandSystem.BaseArg
---@field public OriginString string
---@field public Value string

---@type MoonClient.CommandSystem.CommandBlockStringArg
MoonClient.CommandSystem.CommandBlockStringArg = { }
---@return MoonClient.CommandSystem.CommandBlockStringArg
function MoonClient.CommandSystem.CommandBlockStringArg.New() end
---@return MoonClient.CommandSystem.CommandBlockStringArg
---@param origin string
function MoonClient.CommandSystem.CommandBlockStringArg:Init(origin) end
function MoonClient.CommandSystem.CommandBlockStringArg:Release() end
---@return System.Object
function MoonClient.CommandSystem.CommandBlockStringArg:Clone() end
return MoonClient.CommandSystem.CommandBlockStringArg
