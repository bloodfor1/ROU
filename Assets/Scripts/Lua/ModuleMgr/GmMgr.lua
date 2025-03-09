---@module ModuleMgr.GmMgr
module("ModuleMgr.GmMgr", package.seeall)

require "Data/Model/PlayerInfoModel"

EventDispatcher = EventDispatcher.new()
UPDATE_DPS_EVENT = "UPDATE_DPS_EVENT"
STOP_DPS_EVENT = "STOP_DPS_EVENT"

local tempTestData = {}

--gm command
--同时发送ptc和rpc协议
function SendCommand(msg)
    local l_msgId = Network.Define.Rpc.GSLocalGMCmd
    ---@type GSLocalGMCmdArg
    local l_sendInfo = GetProtoBufSendTable("GSLocalGMCmdArg")
    l_sendInfo.args = msg
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnGmRpcReceived(msg, sendArg)
    ---@type GSLocalGMCmdRes
    local l_resInfo = ParseProtoBufToTable("GSLocalGMCmdRes", msg)
    local gmCtrl = UIMgr:GetUI(UI.CtrlNames.GM)
    if gmCtrl then
        gmCtrl:ShowGMInfo(l_resInfo.result_msg)
    end

    if sendArg then
        local sendCmd = string.lower(sendArg.args)
        local fieldNum = 0
        if string.find(sendCmd, "battlefieldnum") then
            fieldNum = tonumber(string.match(sendCmd, "%w+%s+(%d)")) or 0
            MgrMgr:GetMgr("BattleMgr").SetTeamRequireNum(fieldNum)
        elseif string.find(sendCmd, "platform") then
            fieldNum = tonumber(string.match(sendCmd, "renshu%s+platform%s+(%d)")) or 0
            MgrMgr:GetMgr("ArenaMgr").SetTeamRequireNum(fieldNum)
        elseif string.find(sendCmd, "battle") then
            fieldNum = tonumber(string.match(sendCmd, "renshu%s+battle%s+(%d)")) or 0
            MgrMgr:GetMgr("BattleMgr").SetTeamRequireNum(fieldNum)
        end
    end
end

function GetRPCExam()
    return [[
    --示例代码begin
    local l_msgId = 1129592379
    --local l_sendInfo = PbcMgr.get_pbc_scene_pb().GetSceneYArg()
    --l_sendInfo.level = 10
    --l_sendInfo.type = 1

    Network.Handler.SendRpc(l_msgId, l_sendInfo)
    MgrMgr:GetMgr("TipsMgr").ShowNormalTips("send rpc msgId:" .. tostring(l_msgId))
    ]]
end

function GetPtcExam()
    return [[
    --示例代码
    local l_msgId = 1129592379
    local l_sendInfo = PbcMgr.get_pbc_unclassified_pb().LocalGMCmdArg()
    l_sendInfo.cmd_and_args = "additem 1 1"

    Network.Handler.SendPtc(l_msgId, l_sendInfo)
    MgrMgr:GetMgr("TipsMgr").ShowNormalTips("send ptc msgId:" .. tostring(l_msgId))
    ]]
end

function GetUIExam()
    return "UIMgr:ActiveUI(\"Bag\")"
end

function RegisterTestFunc(funcName, callback)
    table.insert(tempTestData, {
        funcName = funcName,
        method = callback,
    })
end
function GetTestFuncData()
    if tempTestData == nil then
        tempTestData = {}
    end
    return tempTestData
end

function AddTempInfo(info)
    local l_gmCtrl = UIMgr:GetUI(UI.CtrlNames.GM)
    if l_gmCtrl ~= nil then
        l_gmCtrl:AddTempTestInfo(info)
    end
end

function OnEnterScene(sceneId)
    EventDispatcher:Dispatch(STOP_DPS_EVENT)
end

-----------------------------------调协议区域begin-----------------------------------

--[Comment]
--收到ptc协议（自己在这里写要打印的协议体）
function OnTestReceivePtc(msgId, luaBuffer, msgLen)
    MgrMgr:GetMgr("TipsMgr").ShowNormalTips("received ptc msgId:" .. tostring(msgId))
    local l_info = nil

    --示例代码begin
    if msgId == 22138 then
        l_info = ParseProtoBufToTable("SelectRoleNtfData", luaBuffer)
    elseif msgId == 2 then
        --l_info = PbcMgr.get_pbc_unclassified_pb().xxx()
    end
    --示例代码end

    if l_info ~= nil then
        Common.Functions.DumpTable(l_info, "<var>", 6)
    end
end

--[Comment]
--收到rpc协议（自己在这里写要打印的协议体）
function OnTestReceiveRpc(msgId, receivedMsg, receivedMsgLen)
    MgrMgr:GetMgr("TipsMgr").ShowNormalTips("received rpc msgId:" .. tostring(msgId))
    local l_info = nil

    --示例代码begin
    if msgId == 12656 then
        l_info = ParseProtoBufToTable("GetTeamInfoRes", receivedMsg)
    elseif msgId == 2 then
        --l_info = PbcMgr.get_pbc_unclassified_pb().xxx()
    end
    --示例代码end

    if l_info ~= nil then
        Common.Functions.DumpTable(l_info, "<var>", 6)
    end
end

function RequestUpgradeLevel(isBase)
    local l_msgId = Network.Define.Rpc.UpgradeLevel
    ---@type UpgradeLevelArg
    local l_sendInfo = GetProtoBufSendTable("UpgradeLevelArg")
    l_sendInfo.base_or_job = isBase
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnUpgradeLevel(msg)
    ---@type UpgradeLevelRes
    local l_info = ParseProtoBufToTable("UpgradeLevelRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
    end
end

function OnDpsInfoNtf(msg)
    local l_info = ParseProtoBufToTable("DPSInfoData", msg)
    local finalTime = tonumber(l_info.total_time) / 1000
    EventDispatcher:Dispatch(UPDATE_DPS_EVENT, string.format("%.2f", finalTime) .. " S", l_info.total_damage, l_info.dps_damage)
end

function DpsOpenAndClose()
    MgrMgr:GetMgr("TipsMgr").ShowNormalTips("Dps Stop")
    MgrMgr:GetMgr("GmMgr").SendCommand("dps")
end

function Dpsclear()
    MgrMgr:GetMgr("TipsMgr").ShowNormalTips("Dps Stop")
    MgrMgr:GetMgr("GmMgr").SendCommand("dpsclear")
end
-----------------------------------调协议区域end-----------------------------------

return GmMgr