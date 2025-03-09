module("Command", package.seeall)

require "Command/BaseCommand"

local super = Command.BaseCommand
CameraSetTriggerSlowSpeedCommand = class("CameraSetTriggerSlowSpeedCommand", super)

function CameraSetTriggerSlowSpeedCommand:HandleCommand(command, block, args)
    local l_disSlowSpped = tonumber(args[0].Value)
    local l_rotXSlowSpeed = tonumber(args[1].Value)
    local l_rotYSlowSpeed = tonumber(args[2].Value)
    local l_offsetSlowSpeed = tonumber(args[3].Value)
    MEventMgr:LuaFireEvent(MEventType.MEvent_CamTrgSlowSpeed, MScene.GameCamera, l_disSlowSpped, l_rotXSlowSpeed, l_rotYSlowSpeed, l_offsetSlowSpeed)
    command:FinishCommand()
end

function CameraSetTriggerSlowSpeedCommand:CheckCommand(argStrArray)
    if argStrArray.Length < 4 then
        logError("当前命令参数数量错误")
        return false
    end
    return true
end

return CameraSetTriggerSlowSpeedCommand