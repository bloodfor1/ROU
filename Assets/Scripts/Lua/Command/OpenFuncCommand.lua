module("Command", package.seeall)

require "Command/BaseCommand"

local super = Command.BaseCommand
OpenFuncCommand = class("OpenFuncCommand", super)

function OpenFuncCommand:HandleCommand(command, block, args)
    local l_funcId = tonumber(args[0].Value)
    local l_method = MgrMgr:GetMgr("SystemFunctionEventMgr").GetSystemFunctionEvent(l_funcId)
    if l_method ~= nil then
        l_method()
    end
    command:FinishCommand()
end

function OpenFuncCommand:CheckCommand(argStrArray)
    if argStrArray.Length < 1 then
        logError("当前命令参数数量错误")
        return false
    end
    return true
end

return OpenFuncCommand