--恢复摄像机
module("Command", package.seeall)

require "Command/BaseCommand"

local super = Command.BaseCommand
ResetCameraCommand = class("ResetCameraCommand", super)

function ResetCameraCommand:HandleCommand(command, block, args)

    MPlayerInfo:FocusToMyPlayer()
    command:FinishCommand()
end

return ResetCameraCommand
