module("Command", package.seeall)

require "Command/BaseCommand"

local super = Command.BaseCommand
ShowTipCommand = class("ShowTipCommand", super)

function ShowTipCommand:HandleCommand(command, block, args)
    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(tostring(args[0].Value))
    command:FinishCommand()
end

function ShowTipCommand:CheckCommand(argStrArray)
    if argStrArray.Length < 1 then
        logError("当前命令参数数量错误")
        return false
    end
    return true
end

return ShowTipCommand