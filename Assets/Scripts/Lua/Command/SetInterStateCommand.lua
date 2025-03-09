module("Command", package.seeall)

require "Command/BaseCommand"

local super = Command.BaseCommand
SetInterStateCommand = class("SetInterStateCommand", super)

function SetInterStateCommand:HandleCommand(command, block, args)

    local npcId = tonumber(args[0].Value)
    local state = tostring(args[1].Value) == "true" and true or false
    MgrMgr:GetMgr("NpcMgr").SetNpcInterState(npcId, state)
    command:FinishCommand()
end

function SetInterStateCommand:CheckCommand(argStrArray)
    if argStrArray.Length < 2 then
        logError("当前命令参数数量错误")
        return false
    end
    return true
end

return SetInteractFlagCommand