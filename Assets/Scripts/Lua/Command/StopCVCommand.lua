
-- 停止播CV
module("Command", package.seeall)

require "Command/BaseCommand"

local super = Command.BaseCommand
StopCVCommand = class("StopCVCommand", super)

function StopCVCommand:HandleCommand(command, block, args)

    MAudioMgr:StopCV()

    command:FinishCommand()
end


return StopCVCommand