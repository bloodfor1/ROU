
module("Command", package.seeall)

require "Command/BaseCommand"
require "CommonUI.ModelAlarm"

local super = Command.BaseCommand
HideModelAlarmCommand = class("HideModelAlarmCommand", super)

function HideModelAlarmCommand:HandleCommand(command, block, args)
    CommonUI.ModelAlarm.HideAlarm()
    command:FinishCommand()
end

return HideModelAlarmCommand

