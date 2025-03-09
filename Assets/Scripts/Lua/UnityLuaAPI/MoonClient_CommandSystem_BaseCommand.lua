---@class MoonClient.CommandSystem.BaseCommand
---@field public IsInMultipleProcess boolean
---@field public DefaultCommand MoonClient.CommandSystem.BaseCommand
---@field public CommandID int64
---@field public Args System.Collections.Generic.List_MoonClient.CommandSystem.BaseArg
---@field public Block MoonClient.CommandSystem.CommandBlock

---@type MoonClient.CommandSystem.BaseCommand
MoonClient.CommandSystem.BaseCommand = { }
---@param block MoonClient.CommandSystem.CommandBlock
---@param args System.Collections.Generic.List_MoonClient.CommandSystem.BaseArg
function MoonClient.CommandSystem.BaseCommand:Init(block, args) end
function MoonClient.CommandSystem.BaseCommand:UnInit() end
---@return string
function MoonClient.CommandSystem.BaseCommand:GetRealCodeId() end
function MoonClient.CommandSystem.BaseCommand:HandleCommand() end
function MoonClient.CommandSystem.BaseCommand:FinishCommand() end
function MoonClient.CommandSystem.BaseCommand:Release() end
return MoonClient.CommandSystem.BaseCommand
