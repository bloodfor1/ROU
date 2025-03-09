module("Command", package.seeall)

require "Command/BaseCommand"

local super = Command.BaseCommand
CameraToNormalCommand = class("CameraToNormalCommand", super)

function CameraToNormalCommand:HandleCommand(command, block, args)
    
    MEventMgr:LuaFireEvent(MEventType.MEvent_TriggerCamToNormal, MScene.GameCamera)
    command:FinishCommand()
end

return CameraToNormalCommand