
module("Command", package.seeall)

require "Command/BaseCommand"

local super = Command.BaseCommand
NetEntityAIEventCommand = class("NetEntityAIEventCommand", super)

function NetEntityAIEventCommand:HandleCommand(command, block, args)

    local l_msgId = Network.Define.Ptc.SendToEntityAINtf
    ---@type SendToEntityAIData
    local l_sendInfo = GetProtoBufSendTable("SendToEntityAIData")

    if args.Count < 1 then
        command:FinishCommand()
        return
    end
    l_sendInfo.event_name=args[0].Value

    local npc_uids = {}
    for i = 1, args.Count - 1 do
        local l_npc = MNpcMgr:FindNpcInViewport(tonumber(args[i].Value))
        if l_npc == nil then
            logError("找不到Npc "..args[i].Value)
        else
            table.insert(npc_uids, l_npc.UID)
        end
    end
    for i, v in ipairs(npc_uids) do
        local item = l_sendInfo.entity_uuids:add()
        item.value = tostring(v)
    end
    Network.Handler.SendPtc(l_msgId, l_sendInfo)
    command:FinishCommand()
end

function NetEntityAIEventCommand:CheckCommand(argStrArray)
    if argStrArray.Length < 1 then
        logError("当前命令参数数量错误")
        return false
    end
    return true
end

return NetEntityAIEventCommand