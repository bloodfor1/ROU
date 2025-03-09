
--摄像机看NPC
module("Command", package.seeall)

require "Command/BaseCommand"

local super = Command.BaseCommand
PlayTheaterCommand = class("PlayTheaterCommand", super)

function PlayTheaterCommand:HandleCommand(command, block, args)

    MTheaterMgr:PlayTheater(tonumber(args[0].Value), function()
        command:FinishCommand()
    end)
end

return PlayTheaterCommand