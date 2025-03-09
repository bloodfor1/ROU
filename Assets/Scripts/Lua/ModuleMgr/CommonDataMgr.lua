require("ModuleMgr/CommonMsgProcessor")

---@module ModuleMgr.CommonDataMgr
module("ModuleMgr.CommonDataMgr", package.seeall)

require "ModuleMgr/CommonMsgProcessor"

EventDispatcher = EventDispatcher.new()

EEventType = {
    OnClientCommonDataChanged = 1,
}

-- 客户端专用数据存储
clientCommonData = {}

---@param commondataId CommondataId
---@param valueInt64 number
function OnClientCommonData(commondataId, valueInt64)
    --logError(tostring(commondataId) .. "---" .. tostring(valueInt64))
    local l_value = tonumber(valueInt64)
    clientCommonData[commondataId] = l_value
    EventDispatcher:Dispatch(EEventType.OnClientCommonDataChanged, commondataId, l_value)
end


function OnInit()
    ---@type CommonMsgProcessor
    local l_commonData = Common.CommonMsgProcessor.new()
    local l_data = {}
    table.insert(l_data, {
        ModuleEnum = CommondataType.kCDT_CLIENT,
        Callback = OnClientCommonData,
    })

    l_commonData:Init(l_data)
end

function OnLogout()
    clientCommonData = {}
end

---@param commondataId CommondataId
---@return int64
function GetClientCommonData(commondataId)
    return clientCommonData[commondataId] or 0
end


---@param commondataId CommondataId
---@param value number
function SetClientCommonData(commondataId, value)
    ---@type SetCommonDataArg
    local l_sendInfo = GetProtoBufSendTable("SetCommonDataArg")
    l_sendInfo.key = commondataId
    l_sendInfo.value = value
    Network.Handler.SendRpc(Network.Define.Rpc.SetClientCommonDataRpc, l_sendInfo)
    -- 表现先行
    clientCommonData[commondataId] = value
end


function OnSetClientCommonDataRpc(msg)
    local l_info = ParseProtoBufToTable("SetCommonDataRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
    end
end


return ModuleMgr.CommonDataMgr