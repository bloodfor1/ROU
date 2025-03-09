
--摄像机看NPC
module("Command", package.seeall)

require "Command/BaseCommand"

local super = Command.BaseCommand
PlayBlackCurtainCommand = class("PlayBlackCurtainCommand", super)

function PlayBlackCurtainCommand:HandleCommand(command, block, args)

    MgrMgr:GetMgr("BlackCurtainMgr").PlayBlackCurtain(tonumber(args[0].Value), function()
        command:FinishCommand()
    end)
end

return PlayBlackCurtainCommand