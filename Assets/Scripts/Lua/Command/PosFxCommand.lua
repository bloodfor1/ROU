module("Command", package.seeall)

require "Command/BaseCommand"

local super = Command.BaseCommand
PosFxCommand = class("PosFxCommand", super)

function PosFxCommand:HandleCommand(command, block, args)

    local l_effectId = tonumber(args[0].Value)
    local l_position = args[1].Value
    local l_time = tonumber(args[2].Value)

    local fxData = MFxMgr:GetDataFromPool()
    fxData.playTime = l_time
    local l_posArr =string.ro_split(l_position, ",")
    fxData.position = Vector3.New(tonumber(l_posArr[1]), tonumber(l_posArr[2]), tonumber(l_posArr[3]))
    local l_fx = MFxMgr:CreateFx(l_effectId, fxData)
    MFxMgr:ReturnDataToPool(fxData)

    block:AddInternalCallback(function()
        if l_fx ~= nil then
            MFxMgr:DestroyFx(l_fx)
        end
    end)
    command:FinishCommand()
end

function PosFxCommand:CheckCommand(argStrArray)
    if argStrArray.Length < 3 then
        logError("当前命令参数数量错误")
        return false
    end
    return true
end

return PosFxCommand