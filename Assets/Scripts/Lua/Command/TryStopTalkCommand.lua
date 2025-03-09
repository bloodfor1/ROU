module("Command", package.seeall)

require "Command/BaseCommand"

local super = Command.BaseCommand
TryStopTalkCommand = class("TryStopTalkCommand", super)

function TryStopTalkCommand:HandleCommand(command, block, args)
    
    MgrMgr:GetMgr("NpcTalkDlgMgr").TryStopTalk()
    logRed("TryClose!!!")
    command:FinishCommand()
end

return TryStopTalkCommand