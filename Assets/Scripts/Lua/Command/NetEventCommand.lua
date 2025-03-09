
module("Command", package.seeall)

require "Command/BaseCommand"

local super = Command.BaseCommand
NetEventCommand = class("NetEventCommand", super)

function NetEventCommand:HandleCommand(command, block, args)
    
    local l_msgId = Network.Define.Ptc.NpcTalkScriptEvent
    ---@type NpcTalkScriptEventData
    local l_sendInfo = GetProtoBufSendTable("NpcTalkScriptEventData")

    if args.Count < 1 then
        logError("参数数量错误")
        command:FinishCommand()
        return
    end
    local l_npc = MNpcMgr:FindNpcInViewport(tonumber(args[0].Value))
    if l_npc == nil then
        logError("找不到Npc "..args[0].Value)
        command:FinishCommand()
        return
    end
    l_sendInfo.npc_uid = tostring(l_npc.UID)
    l_sendInfo.event_type = args[1].Value
    l_sendInfo.role_id = tostring(MEntityMgr.PlayerEntity.UID)
    
    if args.Count == 2 then
        Network.Handler.SendPtc(l_msgId, l_sendInfo)
        command:FinishCommand()
        return
    end

    local l_args = string.ro_split(args[2].Value, ",")
    for _,arg in ipairs(l_args) do
        local l_param = l_sendInfo.param:add()
        if StringEx.IsFloat(arg) or StringEx.IsInt(arg) then
            l_param.float_arg = tonumber(string.ro_trim(arg))
        else
            l_param.string_arg = arg
        end
    end

    Network.Handler.SendPtc(l_msgId, l_sendInfo)
    command:FinishCommand()
    
end

function NetEventCommand:CheckCommand(argStrArray)
    if argStrArray.Length < 2 then
        logError("当前命令参数数量错误")
        return false
    end
    return true
end

return NetEventCommand