


module("Command", package.seeall)

require "Command/BaseCommand"

local super = Command.BaseCommand
AddOpenFuncCommand = class("AddOpenFuncCommand", super)

function AddOpenFuncCommand:HandleCommand(command, block, args)
    local l_funcId = tonumber(args[0].Value)
    local l_gotoTag = nil
    if args.Count > 1 then
        l_gotoTag = tostring(args[1].Value)
    end
    local l_tableData = TableUtil.GetOpenSystemTable().GetRowById(l_funcId)
    if not l_tableData then
        command:FinishCommand()
        return
    end

    local v = MgrMgr:GetMgr("NpcFuncMgr").GetButtonEventInfo(l_tableData, function()
        if l_gotoTag ~= nil then
            block:GotoTag(l_gotoTag)
        end
    end)
    if v then
        MgrMgr:GetMgr("NpcTalkDlgMgr").AddSelectInfo(v.buttonName, v.method, v.isCloseOnClick, v.selectType)
    end

    command:FinishCommand()
end

function AddOpenFuncCommand:CheckCommand(argStrArray)
    if argStrArray.Length < 1 then
        logError("当前命令参数数量错误")
        return false
    end
    return true
end

return AddOpenFuncCommand