module("Command", package.seeall)

require "Command/BaseCommand"

local super = Command.BaseCommand
AddLocalNpcCommand = class("AddLocalNpcCommand", super)

function AddLocalNpcCommand:HandleCommand(command, block, args)
    local l_sceneId = tonumber(args[0].Value)
    local l_npcId = tonumber(args[1].Value)
    local l_vecStr = string.ro_split(args[2].Value, ',')
    local l_position = Vector3.New(tonumber(l_vecStr[1]), tonumber(l_vecStr[2]), tonumber(l_vecStr[3]))
    local l_face = tonumber(args[3].Value)

    MNpcMgr:AddLocalNpc(l_sceneId, l_npcId, l_position, l_face, block.BlockLocation, block.CurrentLine)
    command:FinishCommand()
end

function AddLocalNpcCommand:CheckCommand(argStrArray)
    if argStrArray.Length < 4 then
        logError("当前命令参数数量错误")
        return false
    end
    return true
end

return AddLocalNpcCommand