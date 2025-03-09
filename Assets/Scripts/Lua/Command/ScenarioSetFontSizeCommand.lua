module("Command", package.seeall)

require "Command/BaseCommand"

local super = Command.BaseCommand
ScenarioSetFontSizeCommand = class("ScenarioSetFontSizeCommand", super)

function ScenarioSetFontSizeCommand:HandleCommand(command, block, args)

    local temp = block:GetBlockConst("model")
    temp:SetFontSize(args[0].Value)
    command:FinishCommand()
end

function ScenarioSetFontSizeCommand:CheckCommand(argStrArray)
    if argStrArray.Length < 1 then
        logError("当前命令参数数量错误")
        return false
    end
    return true
end

return ScenarioSetFontSizeCommand