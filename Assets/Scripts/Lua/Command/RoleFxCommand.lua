module("Command", package.seeall)

require "Command/BaseCommand"

local super = Command.BaseCommand
RoleFxCommand = class("RoleFxCommand", super)

function RoleFxCommand:HandleCommand(command, block, args)

    local l_effectId = tonumber(args[0].Value)
    local l_roleId = tonumber(args[1].Value)
    local l_time = tonumber(args[2].Value)

    local l_targetEntity = MEntityMgr:GetEntity(l_roleId);
    if l_targetEntity == nil then
        l_targetEntity = MNpcMgr:FindNpcInViewport(l_roleId)
    end

    if l_targetEntity == nil then
        return
    end

    local fxData = MFxMgr:GetDataFromPool()
    fxData.playTime = l_time
    local l_fx = l_targetEntity.VehicleOrModel:CreateFx(l_effectId, EModelBone.ERoot, fxData)
    MFxMgr:ReturnDataToPool(fxData)

    block:AddInternalCallback(function()
        if l_fx ~= nil then
            MFxMgr:DestroyFx(l_fx)
        end
    end)
    command:FinishCommand()

end

function RoleFxCommand:CheckCommand(argStrArray)
    if argStrArray.Length < 3 then
        logError("当前命令参数数量错误")
        return false
    end
    return true
end

return RoleFxCommand