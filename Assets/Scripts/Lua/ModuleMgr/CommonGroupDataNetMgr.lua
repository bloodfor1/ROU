--- 负责统一处理一些团体数据的服务器操作的
--- 主要是批量请求公会数据，又触发对应的回调
---@module ModuleMgr.CommonGroupDataNetMgr
module("ModuleMgr.CommonGroupDataNetMgr", package.seeall)

local _cb = nil
local _cbSelf = nil

---@param boardID number @排行榜ID
---@param idList number[] @ID列表
---@param svrQueryType number @查询类型，取服务器枚举 LeaderBoardRequestType
---@param callback function @回调方法
---@param callbackSelf table @回调方法对应的self
function ReqGroupData(boardID, idList, svrQueryType, callback, callbackSelf)
    _cb = callback
    _cbSelf = callbackSelf
    local l_msgId = Network.Define.Rpc.ClientGetRoleLeaderBoardRank

    ---@type GetRoleLeaderBoardRankArg
    local l_sendInfo = GetProtoBufSendTable("GetRoleLeaderBoardRankArg")
    l_sendInfo.board_id = boardID
    l_sendInfo.key_id_list = idList
    l_sendInfo.query_type = svrQueryType
    Network.Handler.SendRpc(l_msgId, l_sendInfo, nil, nil, nil, _onReqTimeOut)
end

-- todo 标注一下，这个地方现在是因为只有一个地方在用，而且功能较为单一，所以没有进行任何数据转义，转义行为实在外面做
-- todo 如果又多个地方需要使用，这个地方就需要进行数据转义了
--- 收到回调触发的函数
function OnGroupDataRsp(msg)
    ---@type GetRoleLeaderBoardRankRes
    local rsp = ParseProtoBufToTable("GetRoleLeaderBoardRankRes", msg)
    if ErrorCode.ERR_SUCCESS ~= rsp.result then
        MgrMgr:GetMgr("TipsMgr").ShowErrorCodeTips(rsp.result)
        return
    end

    if nil == _cb then
        return
    end

    if nil == _cbSelf then
        _cb(rsp.datas)
        _cb = nil
        _cbSelf = nil
        return
    end

    _cb(_cbSelf, rsp.datas)
    _cb = nil
    _cbSelf = nil
end

--- 请求超时的提示回调
function _onReqTimeOut(msgId)
    local str = Lang("SVR_TIME_OUT") .. tostring(msgId)
    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(str)
end

return ModuleMgr.CommonGroupDataNetMgr