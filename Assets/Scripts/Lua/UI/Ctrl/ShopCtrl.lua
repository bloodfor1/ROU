--this file is gen by script
--you can edit this file in custom part

--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/ShopPanel"
require "Data/Model/BagModel"
require "UI/Template/BuyItemTemplate"
require "UI/Template/SellItemTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
ShopCtrl = class("ShopCtrl", super)
--lua class define end

local l_zeny_def = MgrMgr:GetMgr("PropMgr").l_virProp.Coin102
local l_coin_def = MgrMgr:GetMgr("PropMgr").l_virProp.Coin101

--lua functions
function ShopCtrl:ctor()
    super.ctor(self, CtrlNames.Shop, UILayer.Function, UITweenType.UpAlpha, ActiveType.Exclusive)
    self.cacheGrade = EUICacheLv.VeryLow
    self.IsGroup = true

    self.GroupSortingOrder = UILayerSort.None
    self.overrideSortLayer = UILayerSort.Function + 1

    self.GroupMaskType = GroupMaskType.Show
end --func end

--next--
function ShopCtrl:Init()

    self.panel = UI.ShopPanel.Bind(self)
    super.Init(self)
    self.panel.BuyItemPrefab.Prefab.gameObject:SetActiveEx(false)
    ---@type SellData[][]
    self.SellItems = {}
    --初始化显示的item数量
    local l_scrollY = self.panel.BuyScrollRect.RectTransform.sizeDelta.y
    local l_prefabY = self.panel.BuyItemPrefab.Prefab.RectTransform.sizeDelta.y
    self.isActiveCount = math.floor(l_scrollY / l_prefabY)

    self.buyItemTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.BuyItemTemplate,
        TemplatePrefab = self.panel.BuyItemPrefab.Prefab.gameObject,
        ScrollRect = self.panel.BuyScrollRect.LoopScroll
    })

    self.sellItemTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.SellItemTemplate,
        TemplatePrefab = self.panel.SellItemPrefab.LuaUIGroup.gameObject,
        ScrollRect = self.panel.SellScrollRect.LoopScroll,
        GetDatasMethod = function()
            return self:getSellDatas()
        end
    })

    self.panel.BtnConfirmSell:AddClick(function()
        local l_haveType = MgrMgr:GetMgr("ShopMgr").IsHaveBetterEquip()
        if l_haveType > 0 then
            local l_haveBetterText
            if l_haveType == 1 then
                l_haveBetterText = Common.Utils.Lang("Shop_SellNotAppraiseEquipText")
            else
                l_haveBetterText = Common.Utils.Lang("Shop_SellBetterEquipText")
            end
            CommonUI.Dialog.ShowYesNoDlg(true, nil, l_haveBetterText, function()
                self:sellShopItems()
            end, function()

            end)
        else
            if self.isBlackShop then
                CommonUI.Dialog.ShowYesNoDlg(true, nil, Lang("SHOP_SELL_CONFIRM"), function()
                    self:sellShopItems()
                end)
            else
                self:sellShopItems()
            end
        end
    end)

    -- 提示信息
    self.panel.TipBtn:SetActiveEx(false)
    self.panel.TipBtn:AddClick(function()
        MgrMgr:GetMgr("TipsMgr").ShowExplainPanelTips({
            content = Lang("BLACKSHOP_DESCRIPTION"),
            alignment = UnityEngine.TextAnchor.MiddleRight,
            pos = {
                x = 23,
                y = -56,
            },
            width = 400,
        })
    end)

end --func end

function ShopCtrl:SetBussinessManPanel()
    ------以下商人设置购买相关-----
    self.panel.TogHide.Tog.isOn = MgrMgr:GetMgr("ShopMgr").ShopBuyToggleState
    if MgrMgr:GetMgr("ShopMgr").IsShowBusinessmanBuyDisCount then
        self.panel.BgDiscountPrice.gameObject:SetActiveEx(not MgrMgr:GetMgr("ShopMgr").IsExceedShopBuyLimit)
        self.panel.InComeOutIfRange.gameObject:SetActiveEx(MgrMgr:GetMgr("ShopMgr").IsExceedShopBuyLimit)
    else
        self.panel.BgDiscountPrice.gameObject:SetActiveEx(false)
        self.panel.InComeOutIfRange.gameObject:SetActiveEx(false)
    end
    self.panel.TogHide.Tog.onValueChanged:AddListener(function(value)
        MgrMgr:GetMgr("ShopMgr").ShopBuyToggleState = value
        self.panel.BuyScrollRect.LoopScroll:RefreshCells()
    end)
    self.panel.BuyDiscountPriceText.LabText = Common.Utils.Lang("BUSSINESSMAN_DISCOUNT_BUY") .. (MgrMgr:GetMgr("ShopMgr").BussinessmanBuyDisCountNum / 100) .. "%"

    ------以下设置商人出售相关------
    self.panel.ToggleShowPrice.Tog.isOn = MgrMgr:GetMgr("ShopMgr").ShopSellToggleState
    if MgrMgr:GetMgr("ShopMgr").IsShowBusinessmanSellDisCount then
        self.panel.BgSell.gameObject:SetActiveEx(not MgrMgr:GetMgr("ShopMgr").IsExceedShopSellLimit)
        self.panel.BgSellOutOfRange.gameObject:SetActiveEx(MgrMgr:GetMgr("ShopMgr").IsExceedShopSellLimit)
    else
        self.panel.BgSell.gameObject:SetActiveEx(false)
        self.panel.BgSellOutOfRange.gameObject:SetActiveEx(false)
    end

    self.panel.ToggleShowPrice.Tog.onValueChanged:AddListener(function(value)
        MgrMgr:GetMgr("ShopMgr").ShopSellToggleState = value
        self.panel.SellScrollRect.LoopScroll:RefreshCells()
    end)

    if not MgrMgr:GetMgr("ShopMgr").IsBuy and not MgrMgr:GetMgr("ShopMgr").IsShowBusinessmanSellDisCount then
        MLuaCommonHelper.SetRectTransformPos(self.panel.TotalPrice.gameObject, -185, 115)
        self.panel.TextSetPrice.LabText = Common.Utils.Lang("TOTAL_COUNT")
    end
end

function ShopCtrl:sellShopItems()
    MgrMgr:GetMgr("ShopMgr").RequestSellShopItem(self.isBlackShop ~= nil)
end

--next--
function ShopCtrl:Uninit()
    self.SellItems = nil
    self.isActiveCount = 0
    self.buyItemTemplatePool = nil
    self.sellItemTemplatePool = nil
    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function ShopCtrl:OnActive()
    --MgrMgr:GetMgr("ShopMgr").LastCtrlName= UIMgr:GetShowItemNeedsAndCtrlName()
    self.uObj.transform:SetAsLastSibling()
    if self.uiPanelData then
        -- 是否黑市，特殊处理
        self.isBlackShop = self.uiPanelData.isBlackShop
    end
    self.panel.TipBtn:SetActiveEx(self.isBlackShop)
    self:ShowShop()
end --func end
--next--
function ShopCtrl:OnDeActive()
    super.OnDeActive(self)
    local shopMgr = MgrMgr:GetMgr("ShopMgr")
    shopMgr.IsShowBusinessmanSellDisCount = false
    shopMgr.ShowBuyItemId = 0
    shopMgr.CurrentShopId = 0
    shopMgr.CachedCantSellTypes = {}
    self.SellItems = {}
    shopMgr.SellDatas = {}
    shopMgr.ShopSellToggleState = true
    shopMgr.ShopBuyToggleState = true
    shopMgr.LastCtrlName = nil
end --func end
--next--
function ShopCtrl:Update()

end --func end
--next--
function ShopCtrl:OnReconnected()
    if not self:IsActive() then
        return
    end

    if MgrMgr:GetMgr("ShopMgr").IsBuy then
        MgrMgr:GetMgr("ShopMgr").ShowBuyItemId = 0
        MgrMgr:GetMgr("ShopMgr").OpenBuyShop(MgrMgr:GetMgr("ShopMgr").ShopId)

    else
        self.SellItems = {}
        MgrMgr:GetMgr("ShopMgr").SellDatas = {}
        self.sellItemTemplatePool:DeActiveAll()
    end
end --func end
--next--
function ShopCtrl:BindEvents()
    --dont override this function
    self:AddEvent()
end --func end
--next--
--lua functions end

--lua custom scripts
function ShopCtrl:ShowShop()
    if MgrMgr:GetMgr("ShopMgr").IsBuy then
        self.panel.BuyPanel.gameObject:SetActiveEx(true)
        self.panel.SellPanel.gameObject:SetActiveEx(false)
        --清空已选择的商品Index
        MgrMgr:GetMgr("ShopMgr").g_currentSelectIndex = 0

        --判断是否已经有选择的商品了
        local l_index = 1
        local l_buyTable
        if MgrMgr:GetMgr("ShopMgr").ShowBuyItemId ~= 0 then
            for i = 1, #MgrMgr:GetMgr("ShopMgr").BuyShopItems do
                l_buyTable = TableUtil.GetShopCommoditTable().GetRowById(MgrMgr:GetMgr("ShopMgr").BuyShopItems[i].table_id)
                if l_buyTable.ItemId == MgrMgr:GetMgr("ShopMgr").ShowBuyItemId then
                    l_index = i
                    break
                end
            end
            MgrMgr:GetMgr("ShopMgr").g_currentSelectIndex = l_index
        end

        self.buyItemTemplatePool:ShowTemplates({ Datas = MgrMgr:GetMgr("ShopMgr").BuyShopItems, StartScrollIndex = l_index, Method = function(item)
            local l_lastIndex = MgrMgr:GetMgr("ShopMgr").g_currentSelectIndex
            MgrMgr:GetMgr("ShopMgr").g_currentSelectIndex = item.ShowIndex
            self.panel.BuyScrollRect.LoopScroll:RefreshCell(l_lastIndex - 1)
        end })

        local l_shopTableInfo = TableUtil.GetShopTable().GetRowByShopId(MgrMgr:GetMgr("ShopMgr").ShopId)
        self.panel.ShopName.LabText = l_shopTableInfo.ShopName
    else
        self.panel.BuyPanel.gameObject:SetActiveEx(false)
        self.panel.SellPanel.gameObject:SetActiveEx(true)
    end

    MgrMgr:GetMgr("ShopMgr").ShowBuyItemId = 0
    self:RefreshPrice()
    self:SetBussinessManPanel()
    self:ShowSpecialCoin()
end

--显示出售的item
---@param itemData ItemData
function ShopCtrl:ShowSellItem(itemData, count)
    if self.SellItems == nil then
        return
    end

    local l_row = itemData.ItemConfig
    local l_Overlap = l_row.Overlap

    --剩下的数量
    local l_leftCount = count

    --当前sellItemData中的数量
    local l_currentCount
    --算出来的总数量
    local l_totalCount
    for i = 1, #self.SellItems do
        local l_sellItemData = self.SellItems[i]
        --取到当前的个数
        l_currentCount = MgrMgr:GetMgr("ShopMgr").GetSellItemPropInfoCount(l_sellItemData)
        if l_currentCount < l_Overlap --当前数量要小于堆叠数才处理
                and l_sellItemData[1].propInfo.TID == itemData.TID
                and l_sellItemData[1].propInfo.IsBind == itemData.IsBind
                and int64.equals(l_sellItemData[1].propInfo.Price, itemData.Price) then

            --算出来总个数
            l_totalCount = l_currentCount + l_leftCount
            --如果总个数大于最大堆叠个数
            if l_totalCount > l_Overlap then
                --算出来这个数据里还可以放入多少
                local l_nextCount = l_Overlap - l_currentCount
                local l_sellData = {}
                l_sellData.propInfo = itemData
                l_sellData.count = l_nextCount
                table.insert(l_sellItemData, l_sellData)
                self.sellItemTemplatePool:RefreshCell(i)
                --因为总数大于堆叠数，所以算出来这个数据里可装的个数一定小于剩下的数量
                l_leftCount = l_leftCount - l_nextCount
            else
                --如果不大于（就是在这个里面还可以放下），就放在这个数据里面
                local l_sellData = {}
                l_sellData.propInfo = itemData
                l_sellData.count = l_leftCount
                table.insert(l_sellItemData, l_sellData)
                self.sellItemTemplatePool:RefreshCell(i)
                if i ~= #self.SellItems then
                    self.sellItemTemplatePool:ScrollToCell(i, 1200)
                end

                return
            end
        end
    end


    --如果所有的都填充到最大堆叠还有没放下的，则创建一个
    if l_leftCount > 0 then
        local l_sellItem = {}
        local l_sellData = {}
        l_sellData.propInfo = itemData
        l_sellData.count = l_leftCount
        table.insert(l_sellItem, l_sellData)
        table.insert(self.SellItems, l_sellItem)

        self.sellItemTemplatePool:AddTemplate()
        self.sellItemTemplatePool:ScrollToCell(#self.SellItems, 1200)
    end

end

function ShopCtrl:getSellDatas()
    return self.SellItems
end

function ShopCtrl:AddEvent()
    --购买成功回调
    self:BindEvent(MgrMgr:GetMgr("ShopMgr").EventDispatcher, MgrMgr:GetMgr("ShopMgr").BuyCommodity, function()
        for i = 1, #self.buyItemTemplatePool.Datas do
            if self.buyItemTemplatePool.Datas[i].table_id == MgrMgr:GetMgr("ShopMgr").BuyItemData.BuyShopItemData.table_id then
                self.panel.BuyScrollRect.LoopScroll:RefreshCell(i - 1)
                break
            end
        end
        self:ShowSpecialCoin()
    end)

    --出售成功回调
    self:BindEvent(MgrMgr:GetMgr("ShopMgr").EventDispatcher, MgrMgr:GetMgr("ShopMgr").SellSucceedEvent, function()
        self:RefreshPrice()
        self.SellItems = {}
        if self.panel then
            self.panel.SellScrollRect.LoopScroll:ClearActiveCells()
        end
    end)

    self:BindEvent(MgrMgr:GetMgr("ShopMgr").EventDispatcher, MgrMgr:GetMgr("ShopMgr").SellCommodityChange, function()
        self:RefreshPrice()
        -- self.panel.SellingPrice.LabText=tostring(Price)
    end)

    self:BindEvent(MgrMgr:GetMgr("AuctionMgr").EventDispatcher, MgrMgr:GetMgr("AuctionMgr").EEventType.BlackShopItemPriceRefresh, function()
        self:RefreshPrice(true)
    end)

    self:BindEvent(MgrMgr:GetMgr("ShopMgr").EventDispatcher, MgrMgr:GetMgr("ShopMgr").RemoveSellItem, function(self, sellItem)
        local l_index = table.ro_removeOneSameValue(self.SellItems, sellItem)
        self.sellItemTemplatePool:RemoveTemplateByIndex(l_index)
        for i = 1, #sellItem do
            local l_sellItemData = sellItem[i]

            for j = 1, #MgrMgr:GetMgr("ShopMgr").SellDatas do
                if MgrMgr:GetMgr("ShopMgr").SellDatas[j].propInfo.UID == l_sellItemData.propInfo.UID then
                    MgrMgr:GetMgr("ShopMgr").SellDatas[j].count = MgrMgr:GetMgr("ShopMgr").SellDatas[j].count - l_sellItemData.count
                    if int64.equals(MgrMgr:GetMgr("ShopMgr").SellDatas[j].count, 0) then
                        table.remove(MgrMgr:GetMgr("ShopMgr").SellDatas, j)
                        break
                    end
                end
            end
            MgrMgr:GetMgr("ShopMgr").SubtractSellCommodity(l_sellItemData)
        end
    end)

    local SetBussinessManDataAndRefresh = function()
        MgrMgr:GetMgr("ShopMgr").SetBussinessManDiscountNum()
        if MgrMgr:GetMgr("ShopMgr").IsExceedShopBuyLimit or MgrMgr:GetMgr("ShopMgr").IsExceedShopSellLimit then
            --达到上线 设置Toggle
            MgrMgr:GetMgr("ShopMgr").ShopBuyToggleState = true
            MgrMgr:GetMgr("ShopMgr").ShopSellToggleState = true
            self:SetBussinessManPanel()
        end
    end

    self:BindEvent(MgrMgr:GetMgr("LimitBuyMgr").EventDispatcher, MgrMgr:GetMgr("LimitBuyMgr").BUSSINESS_MAN_UPDATE, SetBussinessManDataAndRefresh)
end

function ShopCtrl:ShowPrice1(item_id, count)
    self.panel.SellingPrice1.LabText = tostring(count)
    local l_item1 = TableUtil.GetItemTable().GetRowByItemID(item_id)
    if l_item1 then
        self.panel.ImgCoin1:SetSprite(l_item1.ItemAtlas, l_item1.ItemIcon)
    else
        logError("cannot find item:" .. tostring(item_id))
    end
end

function ShopCtrl:ShowPrice2(item_id, count)
    self.panel.SellingPrice2.LabText = count
    local l_item2 = TableUtil.GetItemTable().GetRowByItemID(item_id)
    if l_item2 then
        self.panel.ImgCoin2:SetSprite(l_item2.ItemAtlas, l_item2.ItemIcon)
    else
        logError("cannot find item:" .. tostring(item_id))
    end
end

--显示出售界面 商人额外收益价格 超出只显示剩余可获得的收益
function ShopCtrl:ShowBussinessManPrice(bussinessCount, Normalcount)
    local addCountMoney = bussinessCount - Normalcount
    local curLeftMoney = MgrMgr:GetMgr("ShopMgr").BusinessmanSellCoinTotalNum - MgrMgr:GetMgr("ShopMgr").CurBusinessmanSellCoinNum
    self.panel.AddationPrice.LabText = tostring(addCountMoney <= curLeftMoney and addCountMoney or curLeftMoney)
end

-- 刷新价格
function ShopCtrl:RefreshPrice(notRequestBlackPrice)
    if not self.panel then
        return
    end

    local l_prices = {}
    local l_bussinessManPrice = {}
    if self.isBlackShop then
        -- 黑市处理
        for i = 1, #MgrMgr:GetMgr("ShopMgr").SellDatas do
            l_prices[l_zeny_def] = l_prices[l_zeny_def] or 0
            local l_price = MgrMgr:GetMgr("AuctionMgr").GetBlackShopSellPrice(MgrMgr:GetMgr("ShopMgr").SellDatas[i].propInfo, nil, notRequestBlackPrice)
            l_prices[l_zeny_def] = l_prices[l_zeny_def] + l_price * MgrMgr:GetMgr("ShopMgr").SellDatas[i].count
        end
    else
        for i = 1, #MgrMgr:GetMgr("ShopMgr").SellDatas do
            local itemTableInfo = MgrMgr:GetMgr("ShopMgr").SellDatas[i].propInfo.ItemConfig
            local l_key = itemTableInfo.RecycleValue:get_Item(0)
            if not l_prices[l_key] then
                l_prices[l_key] = 0
            end
            if not l_bussinessManPrice[l_key] then
                l_bussinessManPrice[l_key] = 0
            end
            l_prices[l_key] = l_prices[l_key] + itemTableInfo.RecycleValue:get_Item(1) * MgrMgr:GetMgr("ShopMgr").SellDatas[i].count
            if MgrMgr:GetMgr("ShopMgr").GetItemIsHaveMerchantAddition(itemTableInfo.ItemID) then
                local curNum = MgrMgr:GetMgr("ShopMgr").GetShopShowPrice(itemTableInfo.RecycleValue:get_Item(1) * MgrMgr:GetMgr("ShopMgr").BussinessmanSellDisCountNum) * MgrMgr:GetMgr("ShopMgr").SellDatas[i].count
                l_bussinessManPrice[l_key] = l_bussinessManPrice[l_key] + curNum
            else
                l_bussinessManPrice[l_key] = l_bussinessManPrice[l_key] + itemTableInfo.RecycleValue:get_Item(1) * MgrMgr:GetMgr("ShopMgr").SellDatas[i].count
            end
        end
    end

    -- 支持两种货币类型显示
    local l_item1 = l_coin_def
    local l_price1 = l_prices[l_coin_def] or 0

    if self.isBlackShop then
        l_item1 = l_zeny_def
        l_price1 = l_prices[l_zeny_def] or 0
    end
    local l_item2, l_price2
    for k, v in pairs(l_prices) do
        if k ~= l_item1 and v > 0 then
            l_item2 = k
            l_price2 = v
            break
        end
    end

    if l_price1 and (l_price1 > 0) and l_price2 then
        self:ShowPrice1(l_coin_def, l_price1)
        self:ShowPrice2(l_item2, l_price2)
        self.panel.Price2.gameObject:SetActiveEx(true)
        self.panel.Price1.RectTransform.anchoredPosition = Vector2.New(0, 19)
        self.panel.Price2.RectTransform.anchoredPosition = Vector2.New(0, -19)
    elseif l_price2 then
        self:ShowPrice1(l_item2, l_price2)
        self.panel.Price2.gameObject:SetActiveEx(false)
        self.panel.Price1.RectTransform.anchoredPosition = Vector2.New(0, 0)
    else
        self:ShowPrice1(l_item1, l_price1)
        self.panel.Price2.gameObject:SetActiveEx(false)
        self.panel.Price1.RectTransform.anchoredPosition = Vector2.New(0, 0)
    end

    --显示商人价格
    local l_bussinessManPrice = l_bussinessManPrice[l_coin_def] ~= nil and l_bussinessManPrice[l_coin_def] or 0
    self:ShowBussinessManPrice(l_bussinessManPrice, l_price1)
end

function ShopCtrl:ShowSpecialCoin()
    local shopId=MgrMgr:GetMgr("ShopMgr").ShopId
    if shopId==nil or shopId==0 then
        return
    end
    local l_shopTableInfo = TableUtil.GetShopTable().GetRowByShopId(MgrMgr:GetMgr("ShopMgr").ShopId)
    if l_shopTableInfo == nil then
        return
    end
    if l_shopTableInfo.ShowSpecialCurrecy and l_shopTableInfo.ShowSpecialCurrecy ~= 0 then
        local itemId = l_shopTableInfo.ShowSpecialCurrecy
        local itemInfo = TableUtil.GetItemTable().GetRowByItemID(itemId)
        self.panel.CoinIcon:SetSprite(itemInfo.ItemAtlas, itemInfo.ItemIcon, true)
        self.panel.CoinIcon.Transform:SetLocalScale(0.35, 0.35, 0.35)
        self.panel.CoinName.LabText = itemInfo.ItemName
        local iconNum = MgrMgr:GetMgr("ItemContainerMgr").GetItemCountByContAndID(GameEnum.EBagContainerType.VirtualItem, itemId) or 0
        self.panel.CoinNum.LabText = tostring(iconNum)
    else
        self.panel.SpecialCoin:SetActiveEx(false)
    end
end

return ShopCtrl
--lua custom scripts end