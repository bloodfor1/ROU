--摄像机看玩家
module("Command", package.seeall)

require "Command/BaseCommand"

local super = Command.BaseCommand
FocusToPlayerCommand = class("FocusToPlayerCommand", super)

function FocusToPlayerCommand:HandleCommand(command, block, args)
    MPlayerInfo:Focus2Player(tonumber(args[0].Value))
    command:FinishCommand()
end

function FocusToPlayerCommand:CheckCommand(argStrArray)
    if argStrArray.Length < 1 then
        logError("当前命令参数数量错误")
        return false
    end
    return true
end

return FocusToPlayerCommand