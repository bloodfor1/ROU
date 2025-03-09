---@module ModuleMgr.ShopMgr
module("ModuleMgr.ShopMgr", package.seeall)

EventDispatcher = EventDispatcher.new()
RemoveSellItem = "RemoveSellItem"
SellCommodityChangeAdd = "SellCommodityChangeAdd"
SellCommodityChangeSubtract = "SellCommodityChangeSubtract"
SellCommodityChange = "SellCommodityChange"
BuyCommodity = "BuyCommodity"
RecycleItemsEvent = "RecycleItemsEvent"
SellSucceedEvent = "SellSucceedEvent"

DELEGATE_SHOP = "DELEGATE_SHOP"

--是购买还是出售
IsBuy = true
-- 是否是黑市售卖
IsBlackShopSell = false
--存着的出售数据
---@type SellData[]
SellDatas = {}
--购买商店id
ShopId = 0
--刷新次数
RefreshCount = 0
--服务器发过来的商店货物ShopItemBrief类型
---@type ShopItemBrief[]
BuyShopItems = {}
--服务器发过来的装备数据Item类型
BuyShopEquips = {}
--显示tips使用，购买商店点击商品、出售点击背包物品、购买商店点击背包物品
eTipsType = { Buy = 1, Sell = 2, Bag = 3 }
--当前的tips弹出类型
TipsType = eTipsType.Bag
--打开购买商店时可以直接弹出相应的物品的tips
ShowBuyItemId = 0
ShowBuyItemCount = 1
CurrentShopId = 0
CachedCantSellTypes = {}
--当前选中的商品索引
g_currentSelectIndex = 0
--获取的其他功能的需求，在购买item上显示需求标记
OtherNeedCommodity = {}
--商人的职业ID
BussinessManProfessionId = 6000
--手推车改造的FuncId
TrolleyFuncId = 1110

LastCtrlName = nil
------------------------------商人低价买进相关-------------------
--是否显示商人低价买进折扣
IsShowBusinessmanBuyDisCount = false
--商人低价买进折扣数额
BussinessmanBuyDisCountNum = 1
--界面上的Toggle状态
ShopBuyToggleState = true
--低价买进累积当前数额
CurBusinessmanBuyCoinNum = 0
--低价买进总数额
BusinessmanBuyCoinTotalNum = 0
--是否达到了今日买进上限
IsExceedShopBuyLimit = false
---------------------------------------------------------------
------------------------------商人高价卖出相关-------------------
--是否显示商人高价卖出折扣
IsShowBusinessmanSellDisCount = false
--商人高价卖出折扣数额
BussinessmanSellDisCountNum = 1
--界面上的Toggle状态
ShopSellToggleState = true
--高价卖出累积当前数额
CurBusinessmanSellCoinNum = 0
--高价卖出总数额
BusinessmanSellCoinTotalNum = 0
--是否达到了今日卖出上限
IsExceedShopSellLimit = false
--用于存储每一组出售额外获得金币数量的Table 弹出Tips结算后 清除这个table
AddZenyNumTable = {}
---------------------------------------------------------------
eBuyLimitType = {
    None = 0,
    Daily = 1,
    Weekly = 2,
    Always = 3
}

function OnInit()

end

function OnLogout()
    IsShowBusinessmanSellDisCount = false
end

function GetBuyLimitType(buyTableInfo)
    if buyTableInfo.PurchaseTimesLimit == 0 then
        return eBuyLimitType.None, 0
    end
    local l_limitBuyMgr = MgrMgr:GetMgr("LimitBuyMgr")
    local l_limitData = l_limitBuyMgr.GetLimitDataByKey(l_limitBuyMgr.g_limitType.SHOP_BUY, tostring(buyTableInfo.Id))
    if l_limitData == nil then
        logError("CountTable表里没有配这个id：" .. buyTableInfo.Id)
        return eBuyLimitType.None, 0
    end
    local l_limit = l_limitData.limt
    if l_limitData.RefreshType == l_limitBuyMgr.eRefreshType.Daily_PM_0 or l_limitData.RefreshType == l_limitBuyMgr.eRefreshType.Daily_PM_5 then
        return eBuyLimitType.Daily, l_limit
    end
    if l_limitData.RefreshType == l_limitBuyMgr.eRefreshType.Weekly_PM_0 or l_limitData.RefreshType == l_limitBuyMgr.eRefreshType.Weekly_PM_5 then
        return eBuyLimitType.Weekly, l_limit
    end
    if l_limitData.RefreshType == l_limitBuyMgr.eRefreshType.None then
        return eBuyLimitType.Always, l_limit
    end
    return eBuyLimitType.None, 0
end

function OpenBuyShop(shopId, showBuyItemId, showBuyItemCount)
    --这个商店特殊处理 但是不会指向某个道具
    if shopId == GameEnum.EShopType.EquipShardShop then
        UIMgr:ActiveUI(UI.CtrlNames.EquipCarryShop)
        return
    end

    -- 主题派对商店需要特判商店功能是否开启
    if shopId == GameEnum.EShopType.ThemePartyShop then
        if not MgrMgr:GetMgr("ThemePartyMgr").CheckIsInThemeParty() then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("CAN_NOT_INTO_DANCEPARTY"))
            return
        end
    end

    if showBuyItemId ~= nil then
        ShowBuyItemId = showBuyItemId
    else
        ShowBuyItemId = 0
    end
    if showBuyItemCount ~= nil then
        ShowBuyItemCount = showBuyItemCount
    else
        ShowBuyItemCount = 1
    end
    InintBusinessManData()
    ResetBusinessManDataByShopId(shopId)
    IsBuy = true
    RequestShopItem(shopId, true)
end

function GoToGuildShop()

    MgrMgr:GetMgr("GuildMgr").GuildFindPath_FuncId(DataMgr:GetData("GuildData").EGuildFunction.GuildShop)

end

function OpenGuildShopEvent(type, command, args)

    OpenBuyShop(tonumber(args[1].Value))

end

function OpenSellShop(shop_id)
    CurrentShopId = shop_id or 0
    CachedCantSellTypes = {}

    local l_shop_row = TableUtil.GetShopTable().GetRowByShopId(CurrentShopId)
    if not l_shop_row then
        logError("找不到商店id:" .. tostring(CurrentShopId))
        return
    else
        for i = 0, l_shop_row.CantSellGoodsType.Length - 1 do
            CachedCantSellTypes[l_shop_row.CantSellGoodsType[i]] = true
        end
    end

    InintBusinessManData()
    IsBuy = false
    IsBlackShopSell = false
    ActiveShop()
end

-- 打开黑市
function OpenBlackShop()
    CurrentShopId = 0
    IsBuy = false
    IsBlackShopSell = true
    ActiveShop(true)
end

function ActiveShop(isBlackShop)
    if IsBuy then
        Data.BagModel:mdOpenModel(Data.BagModel.OpenModel.Shop)
    else
        Data.BagModel:mdOpenModel(Data.BagModel.OpenModel.Sale)
    end

    UIMgr:ActiveUI(UI.CtrlNames.Shop, { [UI.CtrlNames.Shop] = { isBlackShop = isBlackShop } })
end

function RequestShopItem(shopId, isRefresh)
    local l_msgId = Network.Define.Rpc.RequestShopItem
    ---@type RequestShopItemArg
    local l_sendInfo = GetProtoBufSendTable("RequestShopItemArg")
    l_sendInfo.shop_type = shopId
    l_sendInfo.refresh = isRefresh
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function GetShopItems(msg)
    ---@type RequestShopItemRes
    local l_info = ParseProtoBufToTable("RequestShopItemRes", msg)
    RefreshCount = l_info.refreshcount
    local shop = l_info.shop
    ShopId = shop.shop_id
    BuyShopItems = shop.items
    BuyShopEquips = shop.equips

    --x=1时，表示当该商品为受限商品时，沉底置灰显示。此时y无意义，可以配成1=0；
    --x=2时，表示当该商品为受限商品时，需要根据玩家等级进行显示还是隐藏，此时y为玩家等级。
    local l_buyTableInfo = nil
    for i = #BuyShopItems, 1, -1 do
        if BuyShopItems[i].is_lock then
            l_buyTableInfo = TableUtil.GetShopCommoditTable().GetRowById(BuyShopItems[i].table_id)
            if l_buyTableInfo.LimitDisplay.Length == 0 or l_buyTableInfo.LimitDisplay:get_Item(0, 0) == 0 or (l_buyTableInfo.LimitDisplay:get_Item(0, 0) == 2 and l_buyTableInfo.LimitDisplay:get_Item(0, 1) > MPlayerInfo.Lv) then
                --不显示
                table.remove(BuyShopItems, i)
            end
        end
    end

    local buyTable = TableUtil.GetShopCommoditTable().GetTable()
    local monsterHandBookLvl = MgrMgr:GetMgr("IllustrationMonsterMgr").GetHandBookLvl()
    for i = 1, #buyTable do
        if buyTable[i].ShopId == shop.shop_id then
            if buyTable[i].LimitDisplay.Length ~= 0 then
                if (buyTable[i].LimitDisplay:get_Item(0, 0) == 1
                        or (buyTable[i].LimitDisplay:get_Item(0, 0) == 2 and buyTable[i].LimitDisplay:get_Item(0, 1) <= MPlayerInfo.Lv)) then
                    if not IsBuyShopItemsContain(buyTable[i].Id) then
                        local buyItem = {}
                        buyItem.table_id = buyTable[i].Id
                        buyItem.itemID = buyTable[i].ItemId
                        buyItem.is_lock = true
                        buyItem.left_time = 0

                        local l_limitType, l_limitCount = GetBuyLimitType(buyTable[i])
                        if l_limitType ~= eBuyLimitType.None then
                            buyItem.left_time = l_limitCount
                        end
                        buyItem.buy_cost = 0
                        table.insert(BuyShopItems, buyItem)
                    end
                end

            end
            ---魔物推荐等级限制添加
            if buyTable[i].HandBookLvLimit ~= 0 and monsterHandBookLvl < buyTable[i].HandBookLvLimit then
                local buyItem = {}
                buyItem.table_id = buyTable[i].Id
                buyItem.itemID = buyTable[i].ItemId
                buyItem.is_lock = true
                buyItem.left_time = 0

                local l_limitType, l_limitCount = GetBuyLimitType(buyTable[i])
                if l_limitType ~= eBuyLimitType.None then
                    buyItem.left_time = l_limitCount
                end
                buyItem.buy_cost = 0
                table.insert(BuyShopItems, buyItem)
            end
        end
    end

    --不限制的置顶
    table.sort(BuyShopItems, function(a, b)
        local l_aValue = 0
        local l_bValue = 0
        if a.is_lock then
            l_aValue = 1
        end
        if b.is_lock then
            l_bValue = 1
        end
        if l_aValue == 1 and l_bValue == 1 then
            return a.table_id < b.table_id
        end

        if l_aValue == 0 and l_bValue == 0 then
            return a.table_id < b.table_id
        end

        return l_aValue < l_bValue
    end)
    local l_shopRow = TableUtil.GetShopTable().GetRowByShopId(ShopId)
    if l_shopRow then
        if l_shopRow.ShopId == 126 then
            UIMgr:ActiveUI(UI.CtrlNames.CarryShop)
            return
        end
        if MGlobalConfig:GetInt("EntrustShopID") == l_shopRow.ShopId then
            EventDispatcher:Dispatch(DELEGATE_SHOP)
            return
        end
        if l_shopRow.CurrencyType == 1 then
            UIMgr:ActiveUI(UI.CtrlNames.ItemExchangeShop)
        else
            MgrMgr:GetMgr("CurrencyMgr").SetCurrencyDisplay(ShopId)
            ActiveShop()
        end
    end
end
---将已售罄的物品排序到最后
function SortBuyItemsSoldOutAtLast()
    table.sort(BuyShopItems, function(a, b)
        local l_aValue = 0
        local l_bValue = 0
        if a.left_time == 0 then
            l_aValue = 2
        end
        if a.is_lock then
            l_aValue = 1
        end

        if b.left_time == 0 then
            l_bValue = 2
        end
        if b.is_lock then
            l_bValue = 1
        end

        if l_aValue == l_bValue then
            return a.table_id < b.table_id
        end

        return l_aValue < l_bValue
    end)
end

function IsBuyShopItemsContain(id)
    for i = 1, #BuyShopItems do
        if BuyShopItems[i].table_id == id then
            return true
        end
    end

    return false
end

-- count isNotCheck 是否进行快捷兑换的检测
function RequestBuyShopItem(tableID, count, isNotCheck)

    --以下逻辑检测货币是否充足 不足兑换后购买
    local l_shopMgr = MgrMgr:GetMgr("ShopMgr")
    local l_shopTableData = TableUtil.GetShopCommoditTable().GetRowById(tableID)
    local l_totalPrice = 0
    if l_shopTableData and not isNotCheck then
        local l_priceData = Common.Functions.VectorSequenceToTable(l_shopTableData.ItemPerPrice)
        if l_priceData[1][1] and (l_priceData[1][1] == GameEnum.l_virProp.Coin101 or l_priceData[1][1] == GameEnum.l_virProp.Coin102) then
            local l_curCoinId = l_priceData[1][1]
            local l_discount = 1
            if l_shopTableData.Discount == 0 then
            else
                l_discount = l_shopTableData.Discount / 10000
            end
            -- 非商人总价
            l_totalPrice = l_priceData[1][2] * count * l_discount
            --设置商人价格 如果是商人
            if Common.CommonUIFunc.GetProfessionBelongState(MPlayerInfo.ProID, l_shopMgr.BussinessManProfessionId) then
                if l_shopMgr.GetItemIsHaveMerchantDiscount(tableID) then
                    l_totalPrice = l_shopMgr.GetShopShowPrice(l_totalPrice * l_shopMgr.BussinessmanBuyDisCountNum)
                end
            end
            local _, l_needNum = Common.CommonUIFunc.ShowCoinStatusText(l_curCoinId, l_totalPrice)
            if l_needNum > 0 and not isNotCheck then
                MgrMgr:GetMgr("CurrencyMgr").ShowQuickExchangePanel(l_curCoinId, l_needNum, function()
                    RequestBuyShopItem(tableID, count, true)
                end)
                return
            end
        end
    end

    local l_msgId = Network.Define.Rpc.RequestBuyShopItem
    ---@type BuyShopItemArg
    local l_sendInfo = GetProtoBufSendTable("BuyShopItemArg")
    l_sendInfo.shop_type = ShopId
    local item = l_sendInfo.items:add()
    item.table_id = tableID
    item.count = tostring(count)
    Network.Handler.SendRpc(l_msgId, l_sendInfo, count)
end

BuyItem = {}
BuyItemData = {}
function ReceiveBuyShopItem(msg, arg, count)
    ---@type BuyShopItemRes
    local l_info = ParseProtoBufToTable("BuyShopItemRes", msg)
    local l_error = l_info.error
    local l_errorNo = l_error.errorno or ErrorCode.ERR_SUCCESS
    if l_errorNo == ErrorCode.ERR_SUCCESS then
        if #BuyShopItems > 0 then
            for i = 1, #BuyShopItems do
                if BuyShopItems[i].table_id == arg.items[1].table_id then
                    if BuyShopItems[i].left_time ~= nil then
                        local l_count = BuyShopItems[i].left_time - count
                        if l_count < 0 then
                            l_count = 0
                        end
                        BuyShopItems[i].left_time = l_count
                    end
                end
            end
        end
        EventDispatcher:Dispatch(BuyCommodity)
    else
        MgrMgr:GetMgr("ComErrorCodeMgr").ShowMarkedWords(l_error)
    end
end

function RequestSellShopItem(isBlackShop)
    if #SellDatas == 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("Shop_SellEmpty"))
        return
    end

    sellItems(isBlackShop)
end

--是否包含带有精炼、附魔、插卡的装备以及有词条的稀有装备
function IsHaveBetterEquip()
    local l_haveType = 0
    local l_propInfoComp
    for i = 1, #SellDatas do
        if SellDatas[i].propInfo.ItemConfig.TypeTab == Data.BagModel.PropType.Weapon then
            l_propInfoComp = SellDatas[i].propInfo.EquipConfig
            if l_propInfoComp ~= nil then
                if MgrMgr:GetMgr("EquipMgr").IsRaity(SellDatas[i].propInfo) then
                    l_haveType = 2
                end
            end

            if l_haveType == 2 then
                break
            end
        end
    end

    return l_haveType
end

function sellItems(isBlackShop)
    local l_msgId = Network.Define.Rpc.RequestSellShopItem
    ---@type SellShopItemArg
    local l_sendInfo = GetProtoBufSendTable("SellShopItemArg")

    l_sendInfo.shop_id = CurrentShopId or 0
    l_sendInfo.black_market_type = not not isBlackShop
    local l_cached_data = {}

    local l_isCanSell = false
    local l_isChange = false

    for i = 1, #SellDatas do
        local l_propId = SellDatas[i].propInfo.TID
        local l_count = SellDatas[i].count
        local l_currentBagCount = Data.BagModel:GetBagItemCountByTid(l_propId)
        if l_count > l_currentBagCount then
            l_count = l_currentBagCount
            l_isChange = true
        end

        if l_count > 0 then
            local item = l_sendInfo.items:add()
            item.item_uid = SellDatas[i].propInfo.UID
            item.count = tonumber(l_count)

            l_cached_data[l_propId] = l_cached_data[l_propId] and (l_cached_data[l_propId] + l_count) or l_count
            l_isCanSell = true
        end

    end

    if l_isCanSell == false then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("Shop_SellNonexistence"))
        return
    end

    local l_customData = {}
    l_customData.isChange = l_isChange
    l_customData.sellDatas = l_cached_data

    Network.Handler.SendRpc(l_msgId, l_sendInfo, l_customData)
end

function ReceiveSellShopItem(msg, sendArg, customData)
    ---@type SellShopItemRes
    local l_info = ParseProtoBufToTable("SellShopItemRes", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
    else

        SellDatas = {}

        EventDispatcher:Dispatch(SellSucceedEvent)

        if customData.isChange then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("Shop_SellDataChangeTipsText"))
        end

        if not sendArg.black_market_type then
            HandleSellNotice(customData.sellDatas)
        end
    end
end

--- 获取背包中的道具
---@return ItemData[]
function _getItemsInBag()
    local types = { GameEnum.EBagContainerType.Bag }
    local items = Data.BagApi:GetItemsByTypesAndConds(types, nil)
    return items
end

function OnRecycleItems()
    local propInfos = _getItemsInBag()
    local l_itamTableInfo
    local l_canSellItems = {}

    for i = 1, #propInfos do
        if propInfos[i] ~= nil then
            l_itamTableInfo = propInfos[i].ItemConfig
            if IsCanSell(l_itamTableInfo) then
                if l_itamTableInfo.ShowRecycleButton == 1 then
                    table.insert(l_canSellItems, propInfos[i])

                end
            end
        end
    end

    if #l_canSellItems == 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("Shop_SellCantRecycleItems"))
        return
    end

    CommonUI.Dialog.ShowYesNoDlg(true, nil, Common.Utils.Lang("Shop_Sell_RecycleItemsText"), function()
        for i = 1, #l_canSellItems do
            if not AddSellCommodity(l_canSellItems[i], l_canSellItems[i].ItemCount) then
                return
            end
        end
    end, function()
        -- do nothing
    end, nil, 2, "Shop_Sell_RecycleItems")
end

EventDispatcher:Add(RecycleItemsEvent, OnRecycleItems, ModuleMgr.ShopMgr)

function IsCanSell(itemTableInfo)
    if (not itemTableInfo.RecycleValue) or (itemTableInfo.RecycleValue.Count < 2) then
        return false
    end

    if itemTableInfo.RecycleValue:get_Item(0) <= 0 then
        return false
    end

    if IsShopTypeCantSell(itemTableInfo.TypeTab) then
        return false
    end

    return true
end

---@param itemData ItemData
function IsBagItemCanSell(itemData, isShowTips)
    -- 黑市判断
    if IsBlackShopSell then
        local l_canSell = MgrMgr:GetMgr("AuctionMgr").CanBlackShopSell(itemData.TID)
        if isShowTips and not l_canSell then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("Shop_CantSell"))
        end
        return l_canSell
    end

    local l_isTalentEquip, l_name, l_c = MgrProxy:GetMultiTalentEquipMgr().IsInMultiTalentEquip(itemData)
    if l_isTalentEquip then
        if isShowTips then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Common.Utils.Lang("MultiTalent_EquipCantChangeWithShopSell"), l_name))
        end
        return false
    end

    local itemTableInfo = itemData.ItemConfig
    if (not itemTableInfo.RecycleValue) or (itemTableInfo.RecycleValue.Count < 2) then
        if isShowTips then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("Shop_CantSell"))
        end

        return false
    end

    if itemTableInfo.RecycleValue:get_Item(0) <= 0 then
        if isShowTips then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("Shop_CantSell"))
        end
        return false
    end

    if IsShopTypeCantSell(itemTableInfo.TypeTab) then
        if isShowTips then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("Shop_CantSell"))
        end
        return false
    end

    if itemData.ItemConfig.TypeTab == Data.BagModel.PropType.Weapon then
        if itemData.EquipConfig ~= nil then
            if itemData.RefineLv > 0 then
                if isShowTips then
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("Shop_CantSellBetterEquipText"))
                end
                return false
            end

            if MgrMgr:GetMgr("EnchantMgr").IsEnchanted(itemData) then
                if isShowTips then
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("Shop_CantSellBetterEquipText"))
                end
                return false
            end

            if #MgrMgr:GetMgr("EquipMakeHoleMgr").GetCardIds(itemData) > 0 then
                if isShowTips then
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("Shop_CantSellBetterEquipText"))
                end
                return false
            end
        end
    end

    return true
end

---@param itemData ItemData
function OnBagItem(itemData)
    if IsBuy then
        MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithInfo(itemData, nil)
    else
        if not IsBagItemCanSell(itemData, true) then
            return
        end

        if itemData.ItemCount > 1 then
            local cShopData = {
                isBag = true,
                count = 1,
            }

            MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithInfo(itemData, nil, Data.BagModel.WeaponStatus.TO_SHOP, cShopData)
        else
            AddSellCommodity(itemData, 1)
        end
    end
end

function AddSellCommodity(propInfo, count)
    if #SellDatas >= 50 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("Shop_CantSellText"))
        return false
    end

    UIMgr:DeActiveUI(UI.CtrlNames.CommonItemTips)
    local l_ui = UIMgr:GetUI(UI.CtrlNames.Shop)
    if l_ui then
        if DealWithSellDatas(propInfo, count) then
            l_ui:ShowSellItem(propInfo, count)
            EventDispatcher:Dispatch(SellCommodityChangeAdd, { propInfo = propInfo, count = count })
            EventDispatcher:Dispatch(SellCommodityChange)
        end
    end

    return true
end

---@param propInfo ItemData
function DealWithSellDatas(propInfo, count)
    for i = 1, #SellDatas do
        if SellDatas[i].propInfo == propInfo then
            local sellData = SellDatas[i]
            local currentSellCount = sellData.count + count
            local bagItemData = Data.BagApi:GetItemByUID(propInfo.UID)
            if bagItemData == nil then
                return false
            end
            if currentSellCount > bagItemData.ItemCount then
                return false
            end
            sellData.count = currentSellCount
            return true
        end
    end

    ---@type SellData
    local sellData = {
        propInfo = propInfo,
        count = count,
    }

    table.insert(SellDatas, sellData)
    return true
end

function GetSellItemPropInfoCount(sellItem)
    local l_count = 0
    for i = 1, #sellItem do
        l_count = l_count + sellItem[i].count
    end
    return l_count
end

function SubtractSellCommodity(sellData)
    EventDispatcher:Dispatch(SellCommodityChangeSubtract, sellData)
    EventDispatcher:Dispatch(SellCommodityChange)
end

function IsShopTypeCantSell(type)
    if CachedCantSellTypes[type] then
        return true
    end
    return false
end

local function FormatRichText(id, count, flag)
    require "Common/Utils"
    if not flag then
        local l_count = tostring(count)
        if MgrMgr:GetMgr("PropMgr").IsCoin(id) then
            l_count = MNumberFormat.GetNumberFormat(l_count)
        end
        return l_count .. GetItemIconText(id, 14, 1)
    end

    return GetItemText(id, { num = count, icon = { size = 14, width = 1 } })
end

function HandleSellNotice(args)

    local l_result = {}
    for k, v in pairs(args) do
        local itemTableInfo = TableUtil.GetItemTable().GetRowByItemID(tonumber(k))
        if itemTableInfo then
            if itemTableInfo.RecycleValue.Count >= 2 then
                local l_id = itemTableInfo.RecycleValue:get_Item(0)
                local l_value = itemTableInfo.RecycleValue:get_Item(1)
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("SHOP_SELL_FORMAT", FormatRichText(k, v, true), FormatRichText(l_id, l_value * v)))
            end
        else
            logError("找不到道具id:" .. tostring(k))
        end
    end

    local l_finShowNum = 0
    for key, value in ipairs(AddZenyNumTable) do
        l_finShowNum = l_finShowNum + value
    end
    if l_finShowNum > 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GET_ADDITION_ZENY_COIN", l_finShowNum) .. Lang("RICH_ZENY_COIN"))
    end
    AddZenyNumTable = {}
end

----------------------------------------------------------以下为商人低卖高卖逻辑相关---------------------------------------
--初始化商店界面与商人有关基础数据
function InintBusinessManData()
    if Common.CommonUIFunc.GetProfessionBelongState(MPlayerInfo.ProID, BussinessManProfessionId) then
        --商人判定
        --判断商人有没有学习低价买进的技能
        BusinessmanBuyCoinTotalNum = MgrMgr:GetMgr("LimitBuyMgr").GetLimitByKey(MgrMgr:GetMgr("LimitBuyMgr").g_limitType.BUSSINESS_MAN, '1')
        BusinessmanSellCoinTotalNum = MgrMgr:GetMgr("LimitBuyMgr").GetLimitByKey(MgrMgr:GetMgr("LimitBuyMgr").g_limitType.BUSSINESS_MAN, '2')
        local merchantBuySkillID = MGlobalConfig:GetInt("MerchantBuySkillID")
        local merchantSellSkillID = MGlobalConfig:GetInt("MerchantSellSkillID")
        if merchantBuySkillID > 0 then
            MskillBuyInfo = MPlayerInfo:GetCurrentSkillInfo(merchantBuySkillID)
            if MskillBuyInfo.lv > 0 then
                IsShowBusinessmanBuyDisCount = true
                BussinessmanBuyDisCountNum = GetBussinessManDisCountNumBySkillInfo(MskillBuyInfo, "Buy") --0.8--MskillBuyInfo.lv
                CurBusinessmanBuyCoinNum = BusinessmanBuyCoinTotalNum - GetBussinessManCountInfo(MgrMgr:GetMgr("LimitBuyMgr").g_limitType.BUSSINESS_MAN, '1')
                IsExceedShopBuyLimit = CurBusinessmanBuyCoinNum >= BusinessmanBuyCoinTotalNum
            else
                IsShowBusinessmanBuyDisCount = false
                BussinessmanBuyDisCountNum = 0
                ShopBuyToggleState = true
            end
        end
        if merchantSellSkillID > 0 then
            MskillSellInfo = MPlayerInfo:GetCurrentSkillInfo(merchantSellSkillID)
            if MskillSellInfo.lv > 0 then
                IsShowBusinessmanSellDisCount = true
                BussinessmanSellDisCountNum = GetBussinessManDisCountNumBySkillInfo(MskillSellInfo, "Sell") --1.2--MskillSellInfo.lv
                CurBusinessmanSellCoinNum = BusinessmanSellCoinTotalNum - GetBussinessManCountInfo(MgrMgr:GetMgr("LimitBuyMgr").g_limitType.BUSSINESS_MAN, '2')
                IsExceedShopSellLimit = CurBusinessmanSellCoinNum >= BusinessmanSellCoinTotalNum
            else
                IsShowBusinessmanSellDisCount = false
                BussinessmanSellDisCountNum = 0
                ShopSellToggleState = true
            end
        end
    else
        IsShowBusinessmanBuyDisCount = false
        IsShowBusinessmanSellDisCount = false
        BussinessmanBuyDisCountNum = 0
        BussinessmanSellDisCountNum = 0
    end
end

--根据商店配置 重置下该商店是否受影响
function ResetBusinessManDataByShopId(shopId)
    local shopData = TableUtil.GetShopTable().GetRowByShopId(shopId)
    if shopData then
        if IsShowBusinessmanBuyDisCount then
            IsShowBusinessmanBuyDisCount = shopData.MerchantDiscount
        end
    else
        logError("shopData is nil shopId-->>" .. shopId)
    end
end

--获取Count表的数值 剩余数额 如果总量5000 返回剩余的值1000 5000-1000 则为使用了4000
function GetBussinessManCountInfo(type, key)
    return MgrMgr:GetMgr("LimitBuyMgr").GetItemCanBuyCount(type, key)
end

--设置商人低买高卖的数额
--每出售一个同类型的物品 就会走到这个函数这里设置一次
function SetBussinessManDiscountNum()
    local l_limitBuyMgr = MgrMgr:GetMgr("LimitBuyMgr")
    local l_addZenyNum = (BusinessmanSellCoinTotalNum - l_limitBuyMgr.GetItemCanBuyCount(l_limitBuyMgr.g_limitType.BUSSINESS_MAN, 2)) - CurBusinessmanSellCoinNum
    table.insert(AddZenyNumTable, l_addZenyNum)
    CurBusinessmanBuyCoinNum = BusinessmanBuyCoinTotalNum - l_limitBuyMgr.GetItemCanBuyCount(l_limitBuyMgr.g_limitType.BUSSINESS_MAN, 1)
    CurBusinessmanSellCoinNum = BusinessmanSellCoinTotalNum - l_limitBuyMgr.GetItemCanBuyCount(l_limitBuyMgr.g_limitType.BUSSINESS_MAN, 2)
    IsExceedShopBuyLimit = CurBusinessmanBuyCoinNum >= BusinessmanBuyCoinTotalNum
    IsExceedShopSellLimit = CurBusinessmanSellCoinNum >= BusinessmanSellCoinTotalNum
end

--获取Item是否受低价买进的影响
function GetItemIsHaveMerchantDiscount(id)
    local l_tbData = TableUtil.GetShopCommoditTable().GetRowById(tonumber(id))
    if l_tbData then
        return l_tbData.MerchantDiscount
    end
    return false
end

--获取Item是否受高价卖出的影响
function GetItemIsHaveMerchantAddition(itemId)
    local l_tbData = TableUtil.GetItemTable().GetRowByItemID(tonumber(itemId))
    if l_tbData then
        return l_tbData.MerchantAddition
    end
    return false
end

--用于商人价格计算的接口
function GetShopShowPrice(price)
    return math.floor(math.floor(price) / 10000)
end

--根据Skillinfo获取商人低价买进和高价卖出的折扣价格
function GetBussinessManDisCountNumBySkillInfo(skillInfo, type)
    if skillInfo ~= nil then
        local effectId = skillInfo.effectId
        local passiveData = TableUtil.GetPassivitySkillEffectTable().GetRowById(effectId)
        if passiveData then
            local tb = string.ro_split(passiveData.ExtraNum, '|')
            for i = 1, #tb do
                if string.ro_split(tb[i], '=')[1] == type then
                    return tonumber(string.ro_split(tb[i], '=')[2])
                end
            end
        else
            return 1
        end
    end
    return 1
end
----------------------------------------------------------以上面为商人低卖高卖逻辑相关-------------------------------------
--计算当前货币可以购买的最大数量
function CheckCanBuyNum(id)
    local needCoin = TableUtil.GetShopCommoditTable().GetRowById(id).ItemPerPrice
    local maxBuyNum = 4294967295
    for i = 0, needCoin.Length - 1 do
        local Count = MgrMgr:GetMgr("ItemContainerMgr").GetItemCountByContAndID(GameEnum.EBagContainerType.VirtualItem, needCoin[i][0])
        local buyCount = math.floor(Count / needCoin[i][1])
        if buyCount < maxBuyNum then
            maxBuyNum = buyCount
        end
    end
    return maxBuyNum
end

function OnUnInit()
    EventDispatcher:RemoveObjectAllFunc(RecycleItemsEvent, ModuleMgr.ShopMgr)
end

return ModuleMgr.ShopMgr