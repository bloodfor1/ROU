module("Command", package.seeall)

require "Command/BaseCommand"

local super = Command.BaseCommand
GotoNpcCommand = class("GotoNpcCommand", super)

function GotoNpcCommand:HandleCommand(command, block, args)
    local l_sceneId
    local l_npcId
    local l_upperRange = -1
    if args[0].Value == "" then
        l_sceneId = MScene.SceneID
    else
        l_sceneId = tonumber(args[0].Value)
    end

    l_npcId = tonumber(args[1].Value)

    if args.Count > 2 then
        l_upperRange = tonumber(args[2].Value)
    end
    
    MTransferMgr:GotoNpc(l_sceneId, l_npcId, function()
        command:FinishCommand()
    end, function()
       block:Quit()
    end, l_upperRange)
end

function GotoNpcCommand:CheckCommand(argStrArray)
    if argStrArray.Length < 1 then
        logError("当前命令参数数量错误")
        return false
    end
    return true
end

return GotoNpcCommand