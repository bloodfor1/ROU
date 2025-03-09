
-- 播CV
module("Command", package.seeall)

require "Command/BaseCommand"

local super = Command.BaseCommand
PlayCVCommand = class("PlayCVCommand", super)

function PlayCVCommand:HandleCommand(command, block, args)

    MAudioMgr:PlayCV(tonumber(args[0].Value))

    command:FinishCommand()
end

return PlayCVCommand