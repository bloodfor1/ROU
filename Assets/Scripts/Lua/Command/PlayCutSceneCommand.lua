
module("Command", package.seeall)

require "Command/BaseCommand"

local super = Command.BaseCommand
PlayCutSceneCommand = class("PlayCutSceneCommand", super)

function PlayCutSceneCommand:HandleCommand(command, block, args)
    
    MCutSceneMgr:PlayImmById(tonumber(args[0].Value), DirectorWrapMode.Hold, function()
        command:FinishCommand()
    end)
end


return PlayCutSceneCommand