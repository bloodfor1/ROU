--摄像机看点
module("Command", package.seeall)

require "Command/BaseCommand"

local super = Command.BaseCommand
FocusToPosCommand = class("FocusToPosCommand", super)

function FocusToPosCommand:HandleCommand(command, block, args)

    local l_id = tonumber(args[0].Value)

    local l_posArr = string.ro_split(args[1].Value, ",")
    local l_targetPos = Vector3.New(tonumber(l_posArr[1]), tonumber(l_posArr[2]), tonumber(l_posArr[3]))

    local l_face = 0
    if args.Count > 2 then
        l_face  = tonumber(args[2].Value)
    end

    local l_isHidePlayer = true
    if args.Count > 3 then
        l_isHidePlayer = args[3].Value == "true"
    end

    MPlayerInfo:Focus2Pos(l_id, l_targetPos, l_face, l_isHidePlayer)
    command:FinishCommand()
end

function FocusToPosCommand:CheckCommand(argStrArray)
    if argStrArray.Length < 2 then
        logError("当前命令参数数量错误")
        return false
    end
    return true
end

return FocusToPosCommand