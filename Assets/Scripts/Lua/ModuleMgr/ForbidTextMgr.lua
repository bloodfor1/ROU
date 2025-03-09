---@module ForbidTextMgr
module("ModuleMgr.ForbidTextMgr", package.seeall)



---RequestJudgeTextForbid
---@param txt string 需要过滤的文本
---@param callback function(string) 回调函数
function RequestJudgeTextForbid(txt, callback)
    local l_msgId = Network.Define.Rpc.JudgeTextForbid
    ---@type JudgeTextForbidArg
    local l_sendInfo = GetProtoBufSendTable("JudgeTextForbidArg")
    l_sendInfo.text = txt
    Network.Handler.SendRpc(l_msgId, l_sendInfo, callback)
end


---OnJudgeTextForbid
---@param msg text
---@param arg table
---@param callback function
function OnJudgeTextForbid(msg, arg, callback)
    ---@type JudgeTextForbidRes
    local l_info = ParseProtoBufToTable("JudgeTextForbidRes", msg)
    local result = ""
    local l_hasForbid = false

    if l_info.result == 0 then
        l_info.text = arg.text
    end
    if callback ~= nil then
        callback(l_info)
    else
        logWarn("callback is null")
    end
end