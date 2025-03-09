


module("Command", package.seeall)

require "Command/BaseCommand"

local super = Command.BaseCommand
AddTaskBtnCommand = class("AddTaskBtnCommand", super)

function AddTaskBtnCommand:HandleCommand(command, block, args)
    local l_selectName = args[0].Value
    local l_file = args[1].Value
    require(l_file)
    local l_func = loadstring(args[2].Value.."(...)")
    if l_func == nil then
        l_func = function() end
        logError("不存在该函数："..tostring(args[2].Value))
    end
    local l_hideAfterSelect = true
    if args.Count > 3 then
        l_hideAfterSelect = tostring(args[3].Value) == "true"
    end
    MgrMgr:GetMgr("NpcTalkDlgMgr").AddSelectInfo(l_selectName, l_func, l_hideAfterSelect, MgrMgr:GetMgr("NpcMgr").NPC_SELECT_TYPE.FUNC, false)
    command:FinishCommand()
end

function AddTaskBtnCommand:CheckCommand(argStrArray)
    if argStrArray.Length < 3 then
        logError("当前命令参数数量错误")
        return false
    end
    return true
end

return AddTaskBtnCommand