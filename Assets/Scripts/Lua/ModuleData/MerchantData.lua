--
-- @Description: 
-- @Author: haiyaojing
-- @Date: 2019-10-10 11:22:11
--

module("ModuleData.MerchantData", package.seeall)


-- 跑商状态定义
EMerchantState = {
    None = 0, -- 无
    Running = 1, -- 跑商中
    Success = 2, -- 成功
    Failure = 3, -- 失败
}

-- 主界面显示类型
EMerchantBagType = {
    Default = 0, -- 只显示背包
    Shop = 1, -- 显示为商店
}

-- 商店状态
EMerchantShopType = {
    Buy = 0, -- 购买
    Sell = 1, -- 出售
}

-- 当前跑商状态
CurMerchantState = EMerchantState.None
-- 跑商开始时间
MerchantStartTime = 0
-- 跑商持续时间
MerchantDuringTime = 0
-- 跑商任务id
MerchantTaskID = 0
-- 跑商凭证id
BusinessCertificateId = 0
-- 主UI显示类型
MerchantShowBagType = EMerchantBagType.Default
-- 商店状态
MerchantShopType = EMerchantShopType.Sell
-- 上次选择背包的格子
MerchantPotLastPoint = nil

-- 背包数据
-- todo 这个地方数据初始化是通过复制背包中的数据过来的
-- todo 需要修改一下
---@type ItemData[]
MerchantBagProps = nil

-- 出售列表
MerchantPreSellProps = nil
-- npc相关信息
MerchantNpcUid = nil
MerchantNpcId = nil
-- 商店数据
MerchantShopDatas = nil
-- 事件数据
MerchantEventDatas = nil
-- 传闻
MerchantEventRumor = nil
-- 事件刷新时间
MerchantEventRefreshTime = nil
-- 目标场景
MerchantTargetScene = nil
-- 目标npc
MerchantTargetNpcId = nil
-- session时间
MerchantBusinessInterruptSessionTime = 0
-- 背包格子数量
MerchantBusinessBagCount = 0
-- 背包被限制的格子Icon
MerchantBusinessLockedBagIcon = ""

local sceneNpcInfo

function Init()
    CurMerchantState = EMerchantState.None
    MerchantShowBagType = EMerchantBagType.Default
    MerchantShopType = EMerchantShopType.Sell

    MerchantDuringTime = tonumber(TableUtil.GetBusinessGlobalTable().GetRowByName("BusinessTime").Value)
    MerchantTaskID = tonumber(TableUtil.GetBusinessGlobalTable().GetRowByName("BusinessTaskID").Value)
    BusinessCertificateId = tonumber(TableUtil.GetBusinessGlobalTable().GetRowByName("BusinessCertificate").Value)
    MerchantBusinessInterruptSessionTime = tonumber(TableUtil.GetBusinessGlobalTable().GetRowByName("BusinessInterruptSession").Value)
    MerchantBusinessBagCount = tonumber(TableUtil.GetBusinessGlobalTable().GetRowByName("BusinessBagCount").Value)
    MerchantBusinessLockedBagIcon = TableUtil.GetBusinessGlobalTable().GetRowByName("BusinessBagLimitIcon").Value
end


-- 初始化所有数据
function Reset()
    CurMerchantState = EMerchantState.None
    MerchantStartTime = 0
    MerchantShowBagType = EMerchantBagType.Default
    MerchantShopType = EMerchantShopType.Sell
    MerchantPotLastPoint = nil
    MerchantBagProps = nil
    MerchantPreSellProps = nil
    MerchantNpcUid = nil
    MerchantNpcId = nil
    MerchantShopDatas = nil
    MerchantTargetScene = nil

end


-- 登出
function Logout()

    Reset()
end

function OnSelectRoleNtf(info)

    sceneNpcInfo = nil

    MerchantStartTime = info.merchant_record.start_time
    CurMerchantState = EMerchantState.None

    if (not info) or (not info.merchant_record) then
        return
    end

    if MLuaCommonHelper.Int(info.merchant_record.start_time) <= 0 then
        return
    end

    MerchantStartTime = info.merchant_record.start_time
    CurMerchantState = EMerchantState.Running

    return true
end


-- 处理跑商pb数据
local function _fillMerchantShopItemInfo(ret, info)

    local table_insert = table.insert
    for i, v in ipairs(info) do
        table_insert(ret, {
            item_uuid = v.item_uuid,
            item_id = v.item_id,
            item_count = v.item_count,
            price = v.price,
        })
    end
end

-- 收到商人商店消息
function OnMerchantGetShopInfo(info, sendArg)
    MerchantNpcUid = sendArg.npc_uuid
    MerchantNpcId = sendArg.npc_id

    MerchantShopDatas = {}
    MerchantShopDatas.outdate_time = info.outdate_time + Common.TimeMgr.GetNowTimestamp()
    MerchantShopDatas.buy_items = {}
    MerchantShopDatas.sell_items = {}
    _fillMerchantShopItemInfo(MerchantShopDatas.buy_items, info.buy_items)
    _fillMerchantShopItemInfo(MerchantShopDatas.sell_items, info.sell_items)
    RebuildShopSellInfo()
end

-- 购买响应
function OnMerchantShopBuy(itemId, itemCount)
    if MerchantShopDatas and MerchantShopDatas.buy_items then
        for i, v in ipairs(MerchantShopDatas.buy_items) do
            if v.item_id == itemId then
                v.item_count = v.item_count - itemCount
                break
            end
        end
    end
end

function OnGetEvent(info)

    MerchantEventDatas = info.events
    MerchantEventRumor = info.not_own_npc
    MerchantEventRefreshTime = info.outdate_time + Common.TimeMgr.GetNowTimestamp()
end

-- 获取购买数量限制
function GetBuyLimitByPropId(propId)

    if not MerchantShopDatas then
        return 0
    end

    for i, v in ipairs(MerchantShopDatas.buy_items) do
        if v.item_id == propId then
            return v.item_count
        end
    end
    return 0
end

-- 获取道具价格
local function _getPriceByPropId(isBuy, propId)
    if not MerchantShopDatas then
        return -1
    end

    local l_shopItems = isBuy and MerchantShopDatas.buy_items or MerchantShopDatas.sell_items
    for i, v in ipairs(l_shopItems) do
        if v.item_id == propId then
            return v.price
        end
    end
    return -1
end

-- 获取道具售卖价格
function GetSellPriceByPropId(propId)
    return _getPriceByPropId(false, propId)
end

-- 获取道具购买价格
function GetBuyPriceByPropId(propId)
    return _getPriceByPropId(true, propId)
end

-- 建立商品id与出售价格直降的关系，方便查询
function RebuildShopSellInfo()
    MerchantShopDatas.sell_quick_map = {}
    for i, v in ipairs(MerchantShopDatas.sell_items) do
        if not MerchantShopDatas.sell_quick_map[v.item_id] then
            MerchantShopDatas.sell_quick_map[v.item_id] = v.price
        else
            logWarn("RebuildShopSellInfo with error, 重复的商品！", MerchantNpcUid, MerchantNpcId, ToString(v))
        end
    end
end

-- 获取商品出售价格
function GetShopItemSellPrice(propId)
    if not MerchantShopDatas then
        return 0
    end

    return MerchantShopDatas.sell_quick_map[propId] or 0
end


-- 读表
local function _buildSceneNpcInfo(globalKey, tbl)
    local l_value = TableUtil.GetBusinessGlobalTable().GetRowByName(globalKey).Value
    local l_vectorValues = string.ro_split(l_value, "|")
    for i, v in ipairs(l_vectorValues) do
        local l_sequenceValues = string.ro_split(v, "=")
        if #l_sequenceValues >= 2 then
            tbl[tonumber(l_sequenceValues[1])] = tonumber(l_sequenceValues[2])
        end
    end
end

-- 读表
local function _rebuildSceneNpcInfo()
    sceneNpcInfo = {}
    _buildSceneNpcInfo("MerchantQualityNomal", sceneNpcInfo)
    _buildSceneNpcInfo("MerchantQualityMedium", sceneNpcInfo)
    _buildSceneNpcInfo("MerchantQualityHigh", sceneNpcInfo)
end

-- 通过sceme查找npcnpcid
function GetNpcSceneByNpcId(npcId)
    if not sceneNpcInfo then
        _rebuildSceneNpcInfo()
    end

    return sceneNpcInfo[npcId]
end

--返回玩家是否处于跑商状态
function IsInMerchant()
    return CurMerchantState == EMerchantState.Running
end

return ModuleData.MerchantData