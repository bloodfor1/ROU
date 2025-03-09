module("Command", package.seeall)

require "Command/BaseCommand"

local super = Command.BaseCommand
GotoPosCommand = class("GotoPosCommand", super)

function GotoPosCommand:HandleCommand(command, block, args)

    local l_sceneId
    local l_position
    local l_face
    if args[0].Value == "" then
        l_sceneId = MScene.SceneID
    else
        l_sceneId = tonumber(args[0].Value)
    end

    l_position = Common.Utils.ParseVector3(args[1].Value)

    l_face = 360
    if args.Count > 2 then
        l_face = tonumber(args[2].Value)
    end
    
    MTransferMgr:GotoPosition(l_sceneId, l_position, function()
        command:FinishCommand()
    end, function()
       block:Quit()
    end, l_face)
end

function GotoPosCommand:CheckCommand(argStrArray)
    if argStrArray.Length < 2 then
        logError("当前命令参数数量错误")
        return false
    end
    return true
end

return GotoPosCommand

