--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/BaseUITemplate"
require "Data/Model/BagModel"
--lua requires end

--lua model
module("UITemplate", package.seeall)

--lua model end

--lua fields
local super = UITemplate.BaseUITemplate
--lua fields end

--lua class define
---@class BuyItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_NeedNum MoonClient.MLuaUICom
---@field SellOut MoonClient.MLuaUICom
---@field SelectImage MoonClient.MLuaUICom
---@field PriceIcon MoonClient.MLuaUICom
---@field PriceCount MoonClient.MLuaUICom
---@field Prefab MoonClient.MLuaUICom
---@field NeedNum MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field ItemParent MoonClient.MLuaUICom
---@field ImgCd MoonClient.MLuaUICom
---@field Discount MoonClient.MLuaUICom
---@field Details MoonClient.MLuaUICom
---@field Count MoonClient.MLuaUICom
---@field BuyItemButton MoonClient.MLuaUICom

---@class BuyItemTemplate : BaseUITemplate
---@field Parameter BuyItemTemplateParameter

BuyItemTemplate = class("BuyItemTemplate", super)
--lua class define end

--lua functions
function BuyItemTemplate:Init()

    super.Init(self)
    self.item = self:NewTemplate("ItemTemplate", { TemplateParent = self.Parameter.ItemParent.Transform })
    self._countUpdateProcessor = nil
    self._countUpdateProcessor = Data.ItemUpdateCountProcessor.new()
end --func end
--next--
function BuyItemTemplate:OnDeActive()

    self.data = nil

end --func end
--next--
function BuyItemTemplate:OnSetData(data)
    self._countUpdateProcessor:Clear()
    self:ShowBuyItemInfo(data)

end --func end
--next--
function BuyItemTemplate:OnDestroy()

    self.item = nil
    if self._countUpdateProcessor ~= nil then
        self._countUpdateProcessor:Clear()
        self._countUpdateProcessor = nil
    end
end --func end
--next--
function BuyItemTemplate:BindEvents()
    MgrMgr:GetMgr("GameEventMgr").Register(MgrMgr:GetMgr("GameEventMgr").OnBagUpdate, self._onItemUpdate)
end --func end
--next--
--lua functions end

--lua custom scripts
function BuyItemTemplate:ShowBuyItemInfo(BuyShopItem)
    self.data = BuyShopItem
    self:SetSelect(MgrMgr:GetMgr("ShopMgr").g_currentSelectIndex == self.ShowIndex)
    local buyTable = TableUtil.GetShopCommoditTable().GetRowById(BuyShopItem.table_id)
    if buyTable == nil then
        logError("ShopCommoditTable表数据没有id:" .. tostring(BuyShopItem.table_id))
        return
    end
    local itemTable = TableUtil.GetItemTable().GetRowByItemID(buyTable.ItemId)
    local CatCaravanNeedCount = MgrMgr:GetMgr("RequireItemMgr").GetNeedItemCountByID(buyTable.ItemId)
    self.Parameter.NeedNum:SetActiveEx(CatCaravanNeedCount > 0)
    local UpdateNeedCount = function()
        local haveNum = Data.BagModel:GetBagItemCountByTid(buyTable.ItemId)
        self.Parameter.Txt_NeedNum.LabText = StringEx.Format("{0}/{1}", tostring(haveNum), tostring(CatCaravanNeedCount))
        if haveNum >= CatCaravanNeedCount then
            self.Parameter.Txt_NeedNum.LabColor = RoColor.Hex2Color(RoColor.WordColor.Green[1])
        else
            self.Parameter.Txt_NeedNum.LabColor = RoColor.Hex2Color(RoColor.WordColor.Red[1])
        end
    end
    if CatCaravanNeedCount > 0 then
        --self.Parameter.Txt_NeedNum.LabText = StringEx.Format("{0}/{1}", tostring(Data.BagModel:GetBagItemCountByTid(buyTable.ItemId)), tostring(CatCaravanNeedCount))
        UpdateNeedCount()
        self._countUpdateProcessor:Reg(buyTable.ItemId, UpdateNeedCount)
    end
    if itemTable == nil then
        logError("ItemTable表数据没有id:" .. buyTable.ItemId)
        return
    end

    if buyTable.ItemPerMount == 1 then
        self.Parameter.Count.gameObject:SetActiveEx(false)
    else
        self.Parameter.Count.gameObject:SetActiveEx(true)
    end
    self.Parameter.Count.LabText = "X" .. tostring(buyTable.ItemPerMount)
    self.Parameter.Name.LabText = tostring(itemTable.ItemName)
    local lockDescription
    if BuyShopItem.is_lock then
        self.Parameter.Prefab.CanvasGroup.alpha = 0.5
        self.Parameter.ImgCd.gameObject:SetActiveEx(true)
        local JobLimit = Common.Functions.VectorToTable(buyTable.JobLimit)

        local l_guildBuildingLevel = 0
        local l_guildBuildingLevelLinit = 0
        local l_guildBuildingInfo = nil
        local l_buildingId = nil
        if buyTable.GuildBuildingLvLimit:size() ~= 0 then
            local l_limitData = buyTable.GuildBuildingLvLimit[0]
            if l_limitData.Length == 2 then
                l_buildingId = l_limitData[0]
                l_guildBuildingLevelLinit = l_limitData[1]
                l_guildBuildingInfo = DataMgr:GetData("GuildData").GetGuildBuildInfo(l_buildingId)
                if l_guildBuildingInfo ~= nil then
                    l_guildBuildingLevel = l_guildBuildingInfo.level
                end
            end

        end

        if buyTable.isLock == 0 then
            lockDescription = Common.Utils.Lang("NotOpened")
        elseif JobLimit[1] ~= 0 and not table.ro_contains(JobLimit, MPlayerInfo.ProfessionId) then
            lockDescription = buyTable.JobLimitText
        elseif buyTable.BaseLvLimit ~= 0 and MPlayerInfo.Lv < buyTable.BaseLvLimit then
            lockDescription = StringEx.Format("base" .. Common.Utils.Lang("Level") .. Common.Utils.Lang("Open"), tostring(buyTable.BaseLvLimit))
        elseif l_guildBuildingLevelLinit > l_guildBuildingLevel then
            if l_buildingId ~= nil then
                l_curData = TableUtil.GetGuildBuildingTable().GetRowById(l_buildingId)
                lockDescription = StringEx.Format(Lang("Shop_LockGuildBuildingText"), l_curData.Building, l_guildBuildingLevelLinit)
            end
        else
            lockDescription = buyTable.TaskLimitText
        end

        self.Parameter.Details.LabText = lockDescription
        self.Parameter.Details.gameObject:SetActiveEx(true)
    else
        self.Parameter.Prefab.CanvasGroup.alpha = 1
        self.Parameter.ImgCd.gameObject:SetActiveEx(false)
        self.Parameter.Details.gameObject:SetActiveEx(false)
    end

    self:ShowBuyItemDetails(BuyShopItem)

    local Discount = 1
    if buyTable.Discount == 0 then
        self.Parameter.Discount.gameObject:SetActiveEx(false)
    else
        self.Parameter.Discount.gameObject:SetActiveEx(true)
        Discount = buyTable.Discount / 10000
        self.Parameter.DiscountText.LabText = tostring(buyTable.Discount / 1000) .. Common.Utils.Lang("Discount")
    end

    local price = Common.Functions.VectorSequenceToTable(buyTable.ItemPerPrice)
    self.Parameter.PriceCount.LabText = GetColorText(tostring(math.floor(price[1][2] * Discount)), RoColorTag.Blue, RoColor.Scheme.Dark)

    --设置商人价格
    if MgrMgr:GetMgr("ShopMgr").GetItemIsHaveMerchantDiscount(buyTable.Id) and not MgrMgr:GetMgr("ShopMgr").ShopBuyToggleState then
        local l_price = MgrMgr:GetMgr("ShopMgr").GetShopShowPrice(price[1][2] * Discount * MgrMgr:GetMgr("ShopMgr").BussinessmanBuyDisCountNum)
        self.Parameter.PriceCount.LabText = GetColorText(tostring(l_price), RoColorTag.Green)
    end

    local CoinTable = TableUtil.GetItemTable().GetRowByItemID(price[1][1])
    self.Parameter.PriceIcon:SetSprite(CoinTable.ItemAtlas, CoinTable.ItemIcon, true)

    if buyTable.Discount == 0 then
        self.Parameter.Discount.gameObject:SetActiveEx(false)
    else
        self.Parameter.Discount.gameObject:SetActiveEx(true)
        self.Parameter.DiscountText.LabText = tostring(buyTable.Discount / 1000) .. Common.Utils.Lang("Discount")
    end

    if buyTable.ItemId == MgrMgr:GetMgr("ShopMgr").ShowBuyItemId then
        if not BuyShopItem.is_lock then
            local buycount = 1
            buycount = MgrMgr:GetMgr("RequireItemMgr").GetNeedItemCountByID(buyTable.ItemId) - Data.BagModel:GetBagItemCountByTid(buyTable.ItemId)
            if buycount <= 0 then
                buycount = 1
            end
            self:ShowBuyItemTips(BuyShopItem, buycount)
        end
    end

    --if table.ro_contains(MgrMgr:GetMgr("ShopMgr").OtherNeedCommodity,buyTable.ItemId) then
    --  self.Parameter.TaskMark.gameObject:SetActiveEx(true)
    --else
    --  self.Parameter.TaskMark.gameObject:SetActiveEx(false)
    --end
    self.Parameter.BuyItemButton:AddClick(function()
        self:SetSelect(true)
        self:MethodCallback(self)
        if BuyShopItem.is_lock then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(lockDescription)
            return
        end

        local l_limitType, l_limitCount = MgrMgr:GetMgr("ShopMgr").GetBuyLimitType(buyTable)
        if l_limitType ~= MgrMgr:GetMgr("ShopMgr").eBuyLimitType.None then
            if BuyShopItem.left_time == 0 then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("Shop_CountInsufficient"))
                return
            end
        end
        local buycount = 1
        buycount = MgrMgr:GetMgr("RequireItemMgr").GetNeedItemCountByID(buyTable.ItemId) - Data.BagModel:GetBagItemCountByTid(buyTable.ItemId)
        if buycount <= 0 then
            buycount = 1
        end
        self:ShowBuyItemTips(BuyShopItem, buycount)
    end)

    self.item:SetGameObjectActive(true)
    self.item:SetData({ ID = buyTable.ItemId, IsShowCount = false, IsShowRequireSign = true, RequireSignType = MgrMgr:GetMgr("ShopMgr").LastCtrlName })
end

--选中
function BuyItemTemplate:SetSelect(isShow)
    self.Parameter.SelectImage.gameObject:SetActiveEx(isShow)
end

--显示购买item的Details
function BuyItemTemplate:ShowBuyItemDetails(BuyShopItem)
    local buyTable = TableUtil.GetShopCommoditTable().GetRowById(BuyShopItem.table_id)
    local l_shopMgr = MgrMgr:GetMgr("ShopMgr")
    local l_eBuyLimitType = l_shopMgr.eBuyLimitType
    local l_limitType, l_limitCount = l_shopMgr.GetBuyLimitType(buyTable)
    if l_limitType == l_eBuyLimitType.None then
        self.Parameter.Details.gameObject:SetActiveEx(false)
    else
        if l_limitType == l_eBuyLimitType.Daily then
            self.Parameter.Details.LabText = Common.Utils.Lang("Shop_DailyPurchase") .. ":" .. tostring(BuyShopItem.left_time) .. "/" .. tostring(l_limitCount)
        elseif l_limitType == l_eBuyLimitType.Weekly then
            self.Parameter.Details.LabText = Common.Utils.Lang("Shop_WeeklyPurchase") .. ":" .. tostring(BuyShopItem.left_time) .. "/" .. tostring(l_limitCount)
        elseif l_limitType == l_eBuyLimitType.Always then
            self.Parameter.Details.LabText = Common.Utils.Lang("Shop_PurchaseCount") .. ":" .. tostring(BuyShopItem.left_time) .. "/" .. tostring(l_limitCount)
        end
        self.Parameter.Details.gameObject:SetActiveEx(true)
    end
end

--显示购买item的tips
function BuyItemTemplate:ShowBuyItemTips(BuyShopItem, count)
    local buyTable = TableUtil.GetShopCommoditTable().GetRowById(BuyShopItem.table_id)
    local propInfo = Data.BagModel:CreateItemWithTid(buyTable.ItemId)
    propInfo.ItemCount = ToInt64(buyTable.ItemPerMount)
    MgrMgr:GetMgr("ShopMgr").TipsType = MgrMgr:GetMgr("ShopMgr").eTipsType.Buy
    local cShopData = {
        isBag = false,
        buyShopItem = BuyShopItem,
        count = count,
    }
    MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithInfo(propInfo, nil, Data.BagModel.WeaponStatus.TO_SHOP, cShopData)
end

---@param itemUpdateInfoList ItemUpdateData[]
function BuyItemTemplate:_onItemUpdate(itemUpdateInfoList)

end

--lua custom scripts end
return BuyItemTemplate