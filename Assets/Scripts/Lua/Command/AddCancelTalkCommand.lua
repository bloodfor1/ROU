module("Command", package.seeall)

require "Command/BaseCommand"

local super = Command.BaseCommand
AddCancelTalkCommand = class("AddCancelTalkCommand", super)

function AddCancelTalkCommand:HandleCommand(command, block, args)
    local l_talkName = args[0].Value
    local l_talkCallBack = function()
        block:Quit(false)
    end
    local l_selectType = MgrMgr:GetMgr("NpcMgr").NPC_SELECT_TYPE.NORMAL
    MgrMgr:GetMgr("NpcTalkDlgMgr").AddSelectInfo(l_talkName, l_talkCallBack, false, l_selectType)

    command:FinishCommand()
end

function AddCancelTalkCommand:CheckCommand(argStrArray)
    if argStrArray.Length ~= 1 then
        logError("当前命令参数数量错误")
        return false
    end
    return true
end

return AddCancelTalkCommand