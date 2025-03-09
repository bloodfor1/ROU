---
--- Created by husheng.
--- DateTime: 2018/5/24 19:21
---
---@module ModuleMgr.LimitBuyMgr
module("ModuleMgr.LimitBuyMgr", package.seeall)

-----------------------------事件------------------------------------
EventDispatcher = EventDispatcher.new()
LIMIT_BUY_COUNT_UPDATE = "LIMIT_BUY_COUNT_UPDATE"
BUSSINESS_MAN_UPDATE = "BUSSINESS_MAN_UPDATE"
MVP_REWARD_UPDATE = "MVP_REWARD_UPDATE"  --MVP次数刷新                 
LIMIT_BUY_COUNT_ALL_UPDATE = "LIMIT_BUY_COUNT_ALL_UPDATE"  --请求所有数据 设置完成后 并抛出事件
-----------------------------事件------------------------------------

g_limitType = {
    TRADE_BUY = "1",
    TRADE_SELL = "2",
    SHOP_BUY = "3",
    SHOP_SELL = "4",
    LEYUAN_TASK = "5",
    STALL_UP = "6",
    STALL_LIST = "7",
    HEAD_EXCHANGE = "8",
    LIFE_PROFE = "9",
    MVP_REWARD = "10",
    BUSSINESS_MAN = "14",
    EXTRACT_CARD = "15",
    DELEGATE = "17",
    ASSISTDAY = "24",
    ASSISTWEEK = "25",
    ATTR_RESET = "27",
    SKILL_RESET = "28",
    TRADE_BUY_LIMIT = "29",
    TRADE_SELL_LIMIT = "30",
    TOWER_DEFENSE_LIMIT = "36",
    EXTRACT_EQUIP = "37",
    VEHICLE_LEVELUP_LIMIT = "38",
    MONTH_CARD = "40",
    ThemeDungeon = "41",
    CatCaravan = "44",
    GiftPackage = "46", -- 礼包
    ReviveInSitu = "45",
    CardExchangeShopRefreshCount = "48",
    DaBaoTang = "49",
}

eRefreshType = {
    None = 0,
    Daily_PM_0 = 1,
    Daily_PM_5 = 2,
    Weekly_PM_0 = 3,
    Weekly_PM_5 = 4,
}

g_allInfo = {}

local l_tableInfo = {}

function UpdateInfo(info)
    ----CountItemInfo
    local l_type = tostring(info.type)
    local l_id = tostring(info.id)
    local l_count = info.count
    if l_tableInfo[l_type] == nil or l_tableInfo[l_type][l_id] == nil then
        l_count = 0
    else
        l_count = l_tableInfo[l_type][l_id].limt - l_count
    end

    if g_allInfo[l_type] == nil then
        g_allInfo[l_type] = {}
    end
    if g_allInfo[l_type][l_id] == nil then
        g_allInfo[l_type][l_id] = {}
    end
    g_allInfo[l_type][l_id].count = l_count

    --TODO:服务器发过来客户端不存在的id,这里临时处理!
    if l_tableInfo[l_type] == nil or l_tableInfo[l_type][l_id] == nil then
        --logError(StringEx.Format("[LimitBuyMgr]服务器发送至客户端不存在的类型：type={0},id={1}",l_type,l_id))
        return
    end
    g_allInfo[l_type][l_id].limt = l_tableInfo[l_type][l_id].limt
    g_allInfo[l_type][l_id].RefreshNum = l_tableInfo[l_type][l_id].RefreshNum
    g_allInfo[l_type][l_id].RefreshType = l_tableInfo[l_type][l_id].RefreshType
    if l_type == g_limitType.DELEGATE then
        MgrMgr:GetMgr("DelegateModuleMgr").OnLimitCountRefresh(info)
    end
    EventDispatcher:Dispatch(LIMIT_BUY_COUNT_UPDATE, l_type, l_id)
    if l_type == g_limitType.BUSSINESS_MAN then
        EventDispatcher:Dispatch(BUSSINESS_MAN_UPDATE)
    elseif l_type == g_limitType.MVP_REWARD then
        EventDispatcher:Dispatch(MVP_REWARD_UPDATE)
    end
end

function GetCountDataByKey(type, key)
    if g_allInfo == nil then
        return nil
    end
    if g_allInfo[type] == nil then
        return nil
    end
    return g_allInfo[type][key]
end

function InitTable()
    l_tableInfo = {}
    local l_tab = TableUtil.GetCountTable().GetTable()
    for k, v in pairs(l_tab) do
        local l_type = tostring(v.Action)
        local l_itemId = tostring(v.Key)
        if l_tableInfo[l_type] == nil then
            l_tableInfo[l_type] = {}
        end
        if l_tableInfo[l_type][l_itemId] == nil then
            l_tableInfo[l_type][l_itemId] = {}
        end
        l_tableInfo[l_type][l_itemId].limt = v.Limit
        l_tableInfo[l_type][l_itemId].RefreshNum = v.RefreshNum
        l_tableInfo[l_type][l_itemId].RefreshType = v.RefreshType
    end
end

function GetLimitByKey(type, key)
    local l_data = GetLimitDataByKey(type, key)

    --没有数据会报错，返回个错误值
    if l_data == nil then
        return -1
    else
        return l_data.limt
    end
end

function GetLimitDataByKey(type, key)
    key = tostring(key)
    if table.ro_size(l_tableInfo) <= 0 then
        InitTable()
    end

    if l_tableInfo[type][key] == nil then
        logError("CountTable表没有这行数据，Action：" .. tostring(type) .. "  Key:" .. tostring(key))
        return nil
    else
        return l_tableInfo[type][key]
    end
end

function GetRefreshTypeByKey(type, key)
    key = tostring(key)
    if table.ro_size(l_tableInfo) <= 0 then
        InitTable()
    end

    if not l_tableInfo[type] or not l_tableInfo[type][key] then
        logError("CountTable表没有这行数据，Action：" .. tostring(type) .. "  Key:" .. tostring(key))
        return 0
    else
        return l_tableInfo[type][key].RefreshType
    end
end

--断线重连 重新请求数据
function OnReconnected(arg1, arg2, arg3)
    SendGetCountInfoReq()
end

----获取购买次数
function SendGetCountInfoReq()
    g_allInfo = {}
    InitTable()
    ---初始化数据表;
    local l_msgId = Network.Define.Rpc.GetCountInfo
    ---@type GetCountInfoArg
    local l_sendInfo = GetProtoBufSendTable("GetCountInfoArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

----购买次数
function OnGetCountInfoRsp(msg)
    InitTable()
    ---初始化数据表;
    g_allInfo = {}
    ---@type GetCountInfoRes
    local l_info = ParseProtoBufToTable("GetCountInfoRes", msg)
    if l_info.error_code ~= 0 then
        logError("OnGetCountInfoRsp ErrorCode:" .. l_info.error_code)
        return
    end

    local l_itemList = l_info.item_list
    if #l_itemList < 1 then
        return
    end

    for i = 1, #l_itemList do
        UpdateInfo(l_itemList[i])
    end

    local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
    gameEventMgr.RaiseEvent(gameEventMgr.ItemPurchaseInfoUpdated)
    EventDispatcher:Dispatch(LIMIT_BUY_COUNT_ALL_UPDATE)
end

----购买次数更新
function OnCountInfoUpdateNotify(msg)
    ---@type CountUpdateSyncInfo
    local l_info = ParseProtoBufToTable("CountUpdateSyncInfo", msg)
    local l_list = l_info.item_list
    if #l_list < 1 then
        return
    end
    for i = 1, #l_list do
        UpdateInfo(l_list[i])
    end

    local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
    gameEventMgr.RaiseEvent(gameEventMgr.ItemPurchaseInfoUpdated)
end

----获取购买限制次数接口
function GetItemLimitCount(type, id)
    local l_type_limit_table = l_tableInfo[tostring(type)]
    if not l_type_limit_table then
        return -1
    end

    local l_item_config = l_type_limit_table[tostring(id)]
    return l_item_config and l_item_config.limt or -1
end

----获取还可以购买次数接口
function GetItemCanBuyCount(type, id)
    local l_type_buy_table = g_allInfo[tostring(type)]
    if not l_type_buy_table then
        return 0
    end

    local l_item_info = l_type_buy_table[tostring(id)]
    return l_item_info and l_item_info.count or 0
end

-- 获取当前数量
function GetItemCount(type, id)
    local l_type_buy_table = g_allInfo[tostring(type)]
    if not l_type_buy_table then
        return 0
    end

    local l_item_info = l_type_buy_table[tostring(id)]
    return l_item_info and l_item_info.limt and l_item_info.limt - l_item_info.count or 0
end

---获取刷新数量
function GetRefreshNum(type, id)
    return g_allInfo[tostring(type)] and g_allInfo[tostring(type)][tostring(id)] and g_allInfo[tostring(type)][tostring(id)].RefreshNum or 0
end