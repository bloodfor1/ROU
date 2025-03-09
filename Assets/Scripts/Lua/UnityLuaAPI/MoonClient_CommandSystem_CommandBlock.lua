---@class MoonClient.CommandSystem.CommandBlock
---@field public CurrentLine number
---@field public BlockUID number
---@field public Running boolean
---@field public BlockArgs System.Object[]
---@field public BlockLocation string
---@field public BlockData MoonClient.CommandSystem.CommandBlockData
---@field public CallbackFuncList System.Collections.Generic.List_System.Action_MoonClient.CommandSystem.CommandBlock
---@field public InternalCallbacks System.Collections.Generic.List_System.Action_MoonClient.CommandSystem.CommandBlock

---@type MoonClient.CommandSystem.CommandBlock
MoonClient.CommandSystem.CommandBlock = { }
---@return MoonClient.CommandSystem.CommandBlock
function MoonClient.CommandSystem.CommandBlock.New() end
---@return MoonClient.CommandSystem.CommandBlock
---@param location string
function MoonClient.CommandSystem.CommandBlock.CreateBlockWithLocation(location) end
---@param commandScript string
---@param tag string
---@param location string
---@param args System.Object[]
function MoonClient.CommandSystem.CommandBlock.RunBlock(commandScript, tag, location, args) end
---@return MoonClient.CommandSystem.CommandBlock
---@param location string
---@param startTag string
---@param args System.Object[]
function MoonClient.CommandSystem.CommandBlock.OpenAndRunBlock(location, startTag, args) end
---@param commandBlock MoonClient.CommandSystem.CommandBlock
function MoonClient.CommandSystem.CommandBlock.StopBlock(commandBlock) end
function MoonClient.CommandSystem.CommandBlock:TodoNextLine() end
---@param line number
function MoonClient.CommandSystem.CommandBlock:GotoLine(line) end
---@param tag string
function MoonClient.CommandSystem.CommandBlock:GotoTag(tag) end
---@return MoonClient.CommandSystem.CommandBlock
---@param key string
---@param value System.Object
function MoonClient.CommandSystem.CommandBlock:AddBlockConst(key, value) end
---@return System.Object
---@param key string
function MoonClient.CommandSystem.CommandBlock:GetBlockConst(key) end
---@return MoonClient.CommandSystem.CommandBlock
---@param callback (fun(obj:MoonClient.CommandSystem.CommandBlock):void)
function MoonClient.CommandSystem.CommandBlock:SetCallback(callback) end
---@return MoonClient.CommandSystem.CommandBlock
---@param callback (fun(obj:MoonClient.CommandSystem.CommandBlock):void)
function MoonClient.CommandSystem.CommandBlock:AddCallback(callback) end
---@return MoonClient.CommandSystem.CommandBlock
---@param callback (fun(obj:MoonClient.CommandSystem.CommandBlock):void)
function MoonClient.CommandSystem.CommandBlock:AddInternalCallback(callback) end
---@param startTag string
---@param location string
---@param args System.Object[]
function MoonClient.CommandSystem.CommandBlock:StartBlock(startTag, location, args) end
function MoonClient.CommandSystem.CommandBlock:Interrupt() end
---@param doCallback boolean
function MoonClient.CommandSystem.CommandBlock:Quit(doCallback) end
---@param key string
---@param value System.Object
function MoonClient.CommandSystem.CommandBlock:AddCustomVar(key, value) end
---@return System.Object
---@param key string
function MoonClient.CommandSystem.CommandBlock:GetCustomVar(key) end
---@return boolean
---@param key string
function MoonClient.CommandSystem.CommandBlock:IsDefineCustomVar(key) end
---@param addNum number
function MoonClient.CommandSystem.CommandBlock:ModifyCurrentLine(addNum) end
---@return boolean
---@param data MoonClient.CommandSystem.CommandData
---@param command MoonClient.CommandSystem.BaseCommand
function MoonClient.CommandSystem.CommandBlock:GetCommand(data, command) end
return MoonClient.CommandSystem.CommandBlock
