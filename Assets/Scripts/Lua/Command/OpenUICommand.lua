
module("Command", package.seeall)

require "Command/BaseCommand"

local super = Command.BaseCommand
OpenUICommand = class("OpenUICommand", super)

function OpenUICommand:HandleCommand(command, block, args)
    UIMgr:ActiveUI(UI.CtrlNames[args[0].Value])
    command:FinishCommand()
end

function OpenUICommand:CheckCommand(argStrArray)
    if argStrArray.Length < 1 then
        logError("当前命令参数数量错误")
        return false
    end
    return true
end

return OpenUICommand