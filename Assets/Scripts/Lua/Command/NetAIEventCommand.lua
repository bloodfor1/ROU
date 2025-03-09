
module("Command", package.seeall)

require "Command/BaseCommand"

local super = Command.BaseCommand
NetAIEventCommand = class("NetAIEventCommand", super)

function NetAIEventCommand:HandleCommand(command, block, args)
    
    local l_msgId = Network.Define.Ptc.CommandScriptSendEvent
    ---@type CommandScriptInfo
    local l_sendInfo = GetProtoBufSendTable("CommandScriptInfo")

    if args.Count ~= 1 then
        command:FinishCommand()
        return
    end
    l_sendInfo.name=args[0].Value

    Network.Handler.SendPtc(l_msgId, l_sendInfo)
    command:FinishCommand()
end

function NetAIEventCommand:CheckCommand(argStrArray)
    if argStrArray.Length < 1 then
        logError("当前命令参数数量错误")
        return false
    end
    return true
end

return NetAIEventCommand