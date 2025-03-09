---@module ModuleMgr.CommonBroadcastMgr
module("ModuleMgr.CommonBroadcastMgr", package.seeall)

local gameEventMgr = MgrProxy:GetGameEventMgr()

function OnCommonMsg(msg)
    if nil == msg then
        return
    end

    ---@type CommondataRepeated
    local l_info = ParseProtoBufToTable("CommondataRepeated", msg)
    _onCommonDataChange(l_info.commondata_map)
end

---@param info RoleAllInfo
function OnSelectRoleNtf(info)
    _onCommonDataChange(info.common_data.commondata_map)
    _onCommonDataChange(info.commondata_0.commondata_list.commondata_map)
    _onCommonDataChange(info.commondata_1.commondata_list.commondata_map)
    _onCommonDataChange(info.commondata_2.commondata_list.commondata_map)
    _onCommonDataChange(info.commondata_3.commondata_list.commondata_map)
end

---@param reconnectData ReconectSync
function OnReconnected(reconnectData)
    local roleData = reconnectData.role_data
    _onCommonDataChange(roleData.common_data.commondata_map)
    _onCommonDataChange(roleData.commondata_0.commondata_list.commondata_map)
    _onCommonDataChange(roleData.commondata_1.commondata_list.commondata_map)
    _onCommonDataChange(roleData.commondata_2.commondata_list.commondata_map)
    _onCommonDataChange(roleData.commondata_3.commondata_list.commondata_map)
end

function _onCommonDataChange(commonDataPairs)
    ---@type table<number, number>
    local param = {}
    for i = 1, table.maxn(commonDataPairs) do
        local l_commonDataPair = commonDataPairs[i]
        --logYellow("commondata_key:"..tostring(l_commonDataPair.commondata_key))
        --logYellow("commondata_value:"..tostring(l_commonDataPair.commondata_value))
        param[l_commonDataPair.commondata_key] = l_commonDataPair.commondata_value
    end
    gameEventMgr.RaiseEvent(gameEventMgr.OnCommonBroadcast, param)
end
