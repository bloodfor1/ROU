
module("Command", package.seeall)

require "Command/BaseCommand"

local super = Command.BaseCommand
PlaySoundCommand = class("PlaySoundCommand", super)

function PlaySoundCommand:HandleCommand(command, block, args)
    local eventName = args[0].Value
    if Common.Utils.IsNilOrEmpty(eventName) then return end

    MAudioMgr:Play(eventName)
    command:FinishCommand()
end

function PlaySoundCommand:CheckCommand(argStrArray)
    if argStrArray.Length < 1 then
        logError("当前命令参数数量错误")
        return false
    end
    return true
end

return PlaySoundCommand