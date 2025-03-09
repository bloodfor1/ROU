
--摄像机看NPC
module("Command", package.seeall)

require "Command/BaseCommand"

local super = Command.BaseCommand
FocusToNpcCommand = class("FocusToNpcCommand", super)

function FocusToNpcCommand:HandleCommand(command, block, args)

    local l_isHidePlayer = true
    if args.Count > 2 then
        l_isHidePlayer = args[2].Value == true
    end

    MPlayerInfo:Focus2Npc(tonumber(args[0].Value), tonumber(args[1].Value), l_isHidePlayer)
    command:FinishCommand()
end

function FocusToNpcCommand:CheckCommand(argStrArray)
    if argStrArray.Length < 2 then
        logError("当前命令参数数量错误")
        return false
    end
    return true
end

return FocusToNpcCommand