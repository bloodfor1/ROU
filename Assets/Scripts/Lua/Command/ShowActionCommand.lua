module("Command", package.seeall)

require "Command/BaseCommand"

local super = Command.BaseCommand
ShowActionCommand = class("ShowActionCommand", super)

function ShowActionCommand:HandleCommand(command, block, args)
    
    local l_uid = tonumber(args[0].Value)
    local l_actionId = tonumber(args[1].Value)
    local l_time = -1
    if args.Count > 2 then
        l_time = tonumber(args[2].Value)
    end

    local l_targetEntity = MEntityMgr:GetEntity(l_uid);
    if not l_targetEntity  then
        l_targetEntity = MNpcMgr:FindNpcInViewport(l_uid)
    end

    if not l_targetEntity then
        command:FinishCommand()
        return
    end

    MEventMgr:LuaFireEvent(MEventType.MEvent_Special, l_targetEntity, ROGameLibs.kEntitySpecialType_Action, l_actionId)

    block:AddInternalCallback(function()
        MEventMgr:LuaFireEvent(MEventType.MEvent_StopSpecial, l_targetEntity)
    end)

    if l_time < 0 then
        command:FinishCommand()
    else
        local l_timer = Timer.New(function()
            command:FinishCommand()
        end, l_time)
        l_timer:Start()
        block:AddInternalCallback(function()
            if l_waitTask ~= nil then
                l_waitTask:Kill()
                l_waitTask = nil
            end
        end)
    end

end

function ShowActionCommand:CheckCommand(argStrArray)
    if argStrArray.Length < 2 then
        logError("当前命令参数数量错误")
        return false
    end
    return true
end

return ShowActionCommand