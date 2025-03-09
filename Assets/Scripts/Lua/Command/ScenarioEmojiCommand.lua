module("Command", package.seeall)

require "Command/BaseCommand"

local super = Command.BaseCommand
ScenarioEmojiCommand = class("ScenarioEmojiCommand", super)

function ScenarioEmojiCommand:HandleCommand(command, block, args)

    local temp = block:GetBlockConst("model")
    temp:Emoji(args[0].Value)
    command:FinishCommand()
end

function ScenarioEmojiCommand:CheckCommand(argStrArray)
    if argStrArray.Length < 1 then
        logError("当前命令参数数量错误")
        return false
    end
    return true
end

return ScenarioEmojiCommand