--- 负责通用的批量向服务器获取头像的处理
---@module ModuleMgr.CommonIconNetMgr
module("ModuleMgr.CommonIconNetMgr", package.seeall)

local _cb = nil
local _cbSelf = nil

--- 因为这个是通用mgr，所以使用上需要将回调传进来
--- 这里不会统一发消息，原因在于，不希望非指定模块也能接收到数据变更
function ReqPlayerIconDataList(uidArray, callBack, callBackSelf)
    _cb = callBack
    _cbSelf = callBackSelf
    local l_msgId = Network.Define.Rpc.QueryRoleSmallPhotoRpc

    ---@type QueryRoleSmallPhotoArg
    local l_sendInfo = GetProtoBufSendTable("QueryRoleSmallPhotoArg")
    for i = 1, #uidArray do
        l_sendInfo.role_id_list[i] = uidArray[i]
    end

    Network.Handler.SendRpc(l_msgId, l_sendInfo, nil, nil, nil, _onReqTimeOut)
end

function OnRsp(msg)
    ---@type QueryRoleSmallPhotoRes
    local rsp = ParseProtoBufToTable("QueryRoleSmallPhotoRes", msg)
    if nil == _cb then
        return
    end

    if nil == _cbSelf then
        _cb(rsp.photo_list)
        _cb = nil
        _cbSelf = nil
        return
    end

    _cb(_cbSelf, rsp.photo_list)
    _cb = nil
    _cbSelf = nil
end

--- 请求超时的提示回调
function _onReqTimeOut(msgId)
    local str = Lang("SVR_TIME_OUT") .. tostring(msgId)
    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(str)
end

return ModuleMgr.CommonIconNetMgr