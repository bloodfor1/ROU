module("Command", package.seeall)

require "Command/BaseCommand"

local super = Command.BaseCommand
CameraTargetCommand = class("CameraTargetCommand", super)

function CameraTargetCommand:HandleCommand(command, block, args)
   
    local l_target = tonumber(args[0].Value)
    if l_target == nil then
        l_target = args[0].Value
    else
        local l_npc = MNpcMgr:FindNpcInViewport(l_target)
        if l_npc ~= nil then
            l_target = l_npc
        else
            local l_entity = MEntityMgr:GetEntity(l_target)
            if l_entity ~= nil then
                l_target = l_entity
            end
        end
    end
    local l_offsetStrArr = string.ro_split(args[1].Value, ",")
    local l_offset = Vector3.New(
        tonumber(l_offsetStrArr[1]), 
        tonumber(l_offsetStrArr[2]), 
        tonumber(l_offsetStrArr[3]))
    local l_desDis = tonumber(args[2].Value)
    local l_desRotX = tonumber(args[3].Value)
    local l_desRotY = tonumber(args[4].Value)
    local l_fov = 30
    local l_canRotate = true
    if args.Count > 5 then
        l_fov = tonumber(args[5].Value)
    end
    if args.Count > 6 then
        l_canRotate = args[2].Value == "true"
    end
    MEventMgr:LuaFireEvent(MEventType.MEvent_CamTrgTarget, MScene.GameCamera, l_target, l_offset, l_desDis, l_desRotX, l_desRotY, l_fov, l_canRotate)
    command:FinishCommand()
end

function CameraTargetCommand:CheckCommand(argStrArray)
    if argStrArray.Length < 5 then
        logError("当前命令参数数量错误")
        return false
    end
    return true
end

return CameraTargetCommand