module("Command", package.seeall)

require "Command/BaseCommand"

local l_const = CommandBlockManager.InterruptWhenSwitchScene

local super = Command.BaseCommand
BackTrackingCommand = class("BackTrackingCommand", super)

function BackTrackingCommand:HandleCommand(command, block, args)
    
    local l_jumpLine = tonumber(args[0].Value)

    block:AddCustomVar(l_const, block.CurrentLine + l_jumpLine)
    command:FinishCommand()
end

return BackTrackingCommand