---
--- Created by chauncyhu.
--- DateTime: 2019/2/16 14:59
---
---@module ModuleMgr.MvpMgr
module("ModuleMgr.MvpMgr", package.seeall)

EventDispatcher = EventDispatcher.new()

GET_MVP_INFO_SUCCESS = "GET_MVP_INFO_SUCCESS"
GET_MVP_RANK_INFO_SUCCESS = "GET_MVP_RANK_INFO_SUCCESS"

---@type MVPInfo[]
m_mvpInfo = {}
m_mvpTimeTiks = 0
m_mvpRankInfo = {}
--[[
mvp排行榜信息
--]]
function SendGetMvpInfoReq()
    local l_msgId = Network.Define.Rpc.GetMvpInfo
    ---@type GetMVPInfoArg
    local l_sendInfo = GetProtoBufSendTable("GetMVPInfoArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnGetMvpInfoRsp(msg)
    ---@type GetMVPInfoRes
    local l_info = ParseProtoBufToTable("GetMVPInfoRes", msg)
    m_mvpInfo = l_info.mvp_list
    table.sort(m_mvpInfo, _sortMapData)
    m_mvpTimeTiks = Time.realtimeSinceStartup
    EventDispatcher:Dispatch(GET_MVP_INFO_SUCCESS)
end

--- MVP界面数据是开界面的时候主动向服务器申请的，申请之后需要进行排序
---@param a MVPInfo
---@param b MVPInfo
function _sortMapData(a, b)
    if nil == a or nil == b then
        logError("[MvpMgr] mpv data list contains invalid data")
        return false
    end

    local aMvpConfig = TableUtil.GetMvpTable().GetRowByID(a.id)
    local bMvpConfig = TableUtil.GetMvpTable().GetRowByID(b.id)
    if nil == aMvpConfig or nil == bMvpConfig then
        logError("[MvpMgr] mpv data list contains invalid data")
        return false
    end

    local aConfig = TableUtil.GetEntityTable().GetRowById(aMvpConfig.EntityID)
    local bConfig = TableUtil.GetEntityTable().GetRowById(bMvpConfig.EntityID)
    if nil == aConfig or nil == bConfig then
        logError("[MvpMgr] mpv data list contains invalid data")
        return false
    end

    return aConfig.UnitLevel < bConfig.UnitLevel
end

function SendGetMVPRankInfoReq(info, id)
    local l_msgId = Network.Define.Rpc.GetMVPRankInfo
    ---@type GetMVPRankInfoArg
    local l_sendInfo = GetProtoBufSendTable("GetMVPRankInfoArg")
    l_sendInfo.id = id
    m_mvpRankInfo.id = id
    m_mvpRankInfo.staticInfo = info
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnGetMVPRankInfoRsp(msg)
    ---@type GetMVPRankInfoRes
    local l_info = ParseProtoBufToTable("GetMVPRankInfoRes", msg)
    if l_info.result ~= 0 then
        local l_s = Common.Functions.GetErrorCodeStr(l_info.result)
        if l_s ~= nil and l_s ~= "" then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_s)
        end
        return
    end
    m_mvpRankInfo.netInfo = l_info
    EventDispatcher:Dispatch(GET_MVP_RANK_INFO_SUCCESS)
end
return ModuleMgr.MvpMgr