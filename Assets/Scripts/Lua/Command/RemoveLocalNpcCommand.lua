module("Command", package.seeall)

require "Command/BaseCommand"

local super = Command.BaseCommand
RemoveLocalNpcCommand = class("RemoveLocalNpcCommand", super)

function RemoveLocalNpcCommand:HandleCommand(command, block, args)

    local l_sceneId = tonumber(args[0].Value)
    local l_npcId = tonumber(args[1].Value)

    MNpcMgr:RemoveLocalNpc(l_sceneId, l_npcId)
    command:FinishCommand()

end

function RemoveLocalNpcCommand:CheckCommand(argStrArray)
    if argStrArray.Length < 2 then
        logError("当前命令参数数量错误")
        return false
    end
    return true
end

return RemoveLocalNpcCommand