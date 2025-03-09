module("Command", package.seeall)

require "Command/BaseCommand"

local super = Command.BaseCommand
ScenarioChatCommand = class("ScenarioChatCommand", super)

function ScenarioChatCommand:HandleCommand(command, block, args)

    local temp = block:GetBlockConst("model")
    temp:Chat(args[0].Value,args[1].Value)
    command:FinishCommand()
end

function ScenarioChatCommand:CheckCommand(argStrArray)
    if argStrArray.Length < 2 then
        logError("当前命令参数数量错误")
        return false
    end
    return true
end

return ScenarioChatCommand