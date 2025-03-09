module("Command", package.seeall)

require "Command/BaseCommand"

local super = Command.BaseCommand
CameraStateCommand = class("CameraStateCommand", super)

function CameraStateCommand:HandleCommand(command, block, args)
    local l_cameraType = args[0].Value
    MEventMgr:LuaFireEvent(MEventType.MEvent_CamChangeState, MScene.GameCamera, MoonClient.MCameraState[l_cameraType])
    command:FinishCommand()
end

function CameraStateCommand:CheckCommand(argStrArray)
    if argStrArray.Length < 1 then
        logError("当前命令参数数量错误")
        return false
    end
    return true
end

return CameraStateCommand