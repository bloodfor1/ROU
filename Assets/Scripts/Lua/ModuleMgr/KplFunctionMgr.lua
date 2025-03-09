---@module ModuleMgr.KplFunctionMgr
module("ModuleMgr.KplFunctionMgr", package.seeall)

--复活点Id本地保存
l_reviveSceneId = nil

--断线重连 重置信息
function OnReconnected(reconnectData)
    local l_roleAllInfo = reconnectData.role_data
    if l_roleAllInfo.brief and l_roleAllInfo.brief.record_scene_id ~= 0 then
        l_reviveSceneId = l_roleAllInfo.brief.record_scene_id
    end
end

function RequestSaveReviveRecord(sceneId)
    local l_msgId = Network.Define.Rpc.SaveReviveRecord
    ---@type SaveReviveRecordArg
    local l_sendInfo = GetProtoBufSendTable("SaveReviveRecordArg")
    l_sendInfo.scene_id=sceneId
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnSaveReviveRecord(msg, arg)
    ---@type SaveReviveRecordRes
    local l_info = ParseProtoBufToTable("SaveReviveRecordRes", msg)
    local l_err = l_info.result or ErrorCode.ERR_SUCCESS
    if l_err == ErrorCode.ERR_SUCCESS then
        local sceneRow = TableUtil.GetSceneTable().GetRowByID(arg.scene_id)
        local l_sceneName = sceneRow.MiniMap
        l_reviveSceneId = arg.scene_id
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Lang("KPL_SAVE_SUCCESS"), l_sceneName))
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_err))
    end
end