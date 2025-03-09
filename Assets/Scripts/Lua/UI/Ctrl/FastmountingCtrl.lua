--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/FastmountingPanel"
require "UI/Template/StallBagItemTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
FastmountingCtrl = class("FastmountingCtrl", super)
--lua class define end

--lua functions
function FastmountingCtrl:ctor()

    super.ctor(self, CtrlNames.Fastmounting, UILayer.Function, nil, ActiveType.Standalone)

    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor = BlockColor.Dark
    self.ClosePanelNameOnClickMask = UI.CtrlNames.Fastmounting

end --func end
--next--
function FastmountingCtrl:Init()

    self.panel = UI.FastmountingPanel.Bind(self)
    super.Init(self)

    self.stallMgr = MgrMgr:GetMgr("StallMgr")
    self.propMgr = MgrMgr:GetMgr("PropMgr")
    --当前显示物品的uid
    self.curShownItemUid = nil
    --需要上架的信息
    self.putOnItemInfos = {}

    --item设置
    self.leftItemTemplate = self:NewTemplate("ItemTemplate", {
        TemplateParent = self.panel.leftItemIcon.Transform
    })

    --遮罩设置
    --self:SetBlockOpt(BlockColor.Dark, function()
    --	UIMgr:DeActiveUI(UI.CtrlNames.Fastmounting)
    --end)

    self.panel.CloseBtn:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.Fastmounting)
    end)

    --快速上架按钮
    self.panel.fastUpBtn:AddClick(function()
        self:OnFastUpBtnClicked()
    end)

    self.panel.emptyText.LabText = Lang("STALL_NOTHING_TO_SELL")

    self:InitLeftInfoPanel()

    self.rightScrollTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.StallBagItemTemplate,
        TemplatePrefab = self.panel.StallBagItemTemplate.LuaUIGroup.gameObject,
        ScrollRect = self.panel.rightScrollView.LoopScroll
    })
    self:FreshRightScroll()

end --func end
--next--
function FastmountingCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil

    self.rightScrollTemplatePool = nil
end --func end
--next--
function FastmountingCtrl:OnActive()


end --func end
--next--
function FastmountingCtrl:OnDeActive()


end --func end
--next--
function FastmountingCtrl:Update()


end --func end

--next--
function FastmountingCtrl:BindEvents()
    self:BindEvent(self.stallMgr.EventDispatcher, self.stallMgr.ON_FAST_SELL_ITEM_CLICKED, self.OnItemClicked)
    self:BindEvent(self.stallMgr.EventDispatcher, self.stallMgr.ON_STALL_GET_PRE_SELL_ITEM_INFO_RSP_FASTMOUNTING, self.OnStallGetPreSellItemInfoEvent)

    --物品变化刷新列表
    local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
    self:BindEvent(gameEventMgr.l_eventDispatcher, gameEventMgr.OnBagUpdate, self.FreshRightScroll)
end --func end
--next--
--lua functions end

--lua custom scripts

function FastmountingCtrl:InitLeftInfoPanel()
    --推荐价格信息
    self.tipTemplate = self:NewTemplate("CommonItemTipsOtherTemplent", { TemplateParent = self.panel.infoPanel.transform })
    --单价
    self.itemPriceTemplate = self:NewTemplate("CommonItemTipsSetNumPassiveComponent", { TemplateParent = self.panel.infoPanel.transform })
    self.itemPriceTemplate:SetInfo("", 0, function()
        self:OnPriceAdded()
    end, function()
        self:OnPriceSubed()
    end)
    --数量
    self.totalNumTemplate = self:NewTemplate("CommonItemTipsSetNumTemplent", { TemplateParent = self.panel.infoPanel.transform })
    self.totalNumTemplate:SetInputNumListener(function(value)
        if not self.panel then return end
        self:OnNumChanged(value)
    end)
    --总价
    self.totalPriceTemplate = self:NewTemplate("CommonItemTipsSetInfoTemplent", { TemplateParent = self.panel.infoPanel.transform })
    --摊位费
    self.tablePriceTemplate = self:NewTemplate("CommonItemTipsSetInfoTemplent", { TemplateParent = self.panel.infoPanel.transform })

    self.tipTemplate:SetInfo(true, false)
    self:SetTipInfo(1, 1)

    self:FreshItemShown()
end

function FastmountingCtrl:OnPriceAdded()
    if self.curShownItemUid and self.putOnItemInfos[self.curShownItemUid].isValid then
        local l_info = self.putOnItemInfos[self.curShownItemUid]
        if l_info.isPriceLimit then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("STALL_PRICE_LIMIT"))
            return
        end
        l_info.putOnPrice = l_info.putOnPrice + l_info.priceInterval
        if l_info.putOnPrice >= l_info.maxPrice then
            l_info.putOnPrice = l_info.maxPrice
            if l_info.putOnPrice == l_info.originMaxPrice then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("STALL_PRICE_UPPER_LIMIT"))
            else
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("STALL_FLOAT_UPPER_LIMIT"))
            end
        end

        self:FreshItemShown()
    end
end

function FastmountingCtrl:OnPriceSubed()
    if self.curShownItemUid and self.putOnItemInfos[self.curShownItemUid].isValid then
        local l_info = self.putOnItemInfos[self.curShownItemUid]
        if l_info.isPriceLimit then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("STALL_PRICE_LIMIT"))
            return
        end
        l_info.putOnPrice = l_info.putOnPrice - l_info.priceInterval
        if l_info.putOnPrice <= l_info.minPrice then
            l_info.putOnPrice = l_info.minPrice
            if l_info.minPrice == l_info.originMinPrice then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("STALL_PRICE_LOWER_LIMIT"))
            else
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("STALL_FLOAT_LOWER_LIMIT"))
            end
        end

        self:FreshItemShown()
    end
end

function FastmountingCtrl:OnNumChanged(value)
    value = MLuaCommonHelper.Long2Int(value)
    if self.curShownItemUid and self.putOnItemInfos[self.curShownItemUid] then
        self.putOnItemInfos[self.curShownItemUid].putOnNum = value

        self:FreshItemShown()
    end
end

function FastmountingCtrl:SetTipInfo(curPrice, basePrice)
    local l_str, l_color = MgrMgr:GetMgr("StallMgr").GetRecommendedPriceTextAndColor(curPrice, basePrice)
    self.tipTemplate.Parameter.OtherTipsInfo.LabText = l_str
    self.tipTemplate.Parameter.OtherTipsInfo.LabColor = l_color
end

function FastmountingCtrl:FreshRightScroll()
    local l_result = MgrMgr:GetMgr("StallMgr").GetStallItems()
    local l_allCount = #l_result
    --标记信息，用于确定信息来源与快速上架界面
    for i = 1, #l_result do
        l_result[i].isFastMounting = true
    end
    if l_allCount == 0 then
        self.panel.rightEmpty.gameObject:SetActiveEx(true)
        self.panel.rightScrollView.gameObject:SetActiveEx(false)
        self.cansell = false
    else
        self.cansell = true
        self.panel.rightEmpty.gameObject:SetActiveEx(false)
        self.panel.rightScrollView.gameObject:SetActiveEx(true)

        local l_targetCount = (l_allCount <= 24) and 24 or l_allCount
        local l_ten, l_one = math.modf(l_targetCount / 4)
        if l_one > 0 then
            l_targetCount = (l_ten + 1) * 4
        end

        self.rightScrollTemplatePool:ShowTemplates { Datas = l_result, ShowMinCount = l_targetCount }
    end
end

function FastmountingCtrl:OnItemClicked(itemTemplate)
    if itemTemplate:IsSelected() then
        itemTemplate:SetSelected(false)
        self.curShownItemUid = nil
        self.putOnItemInfos[itemTemplate.itemData.UID] = nil
        self:FreshItemShown()
    else
        self.stallMgr.SendStallGetPreSellItemInfoReq(itemTemplate.itemData.TID, { uid = itemTemplate.itemData.UID })
        self.putOnItemInfos[itemTemplate.itemData.UID] = { isValid = false, itemData = itemTemplate.itemData, itemTemplate = itemTemplate }
    end
end

function FastmountingCtrl:OnStallGetPreSellItemInfoEvent(uid)
    if self.putOnItemInfos[uid] then
        local l_itemId = self.putOnItemInfos[uid].itemData.TID
        local l_basePrice = self.stallMgr.g_basePriceInfo[l_itemId]
        local _, l_minPrice, l_maxPrice, l_priceInterval, l_isPriceLimit, l_originMinPrice, l_originMaxPrice = self.stallMgr.GetPriceRange(l_itemId, l_basePrice)
        self.putOnItemInfos[uid].isValid = true
        self.putOnItemInfos[uid].basePrice = l_basePrice
        self.putOnItemInfos[uid].putOnPrice = l_basePrice
        self.putOnItemInfos[uid].putOnNum = self.putOnItemInfos[uid].itemData.ItemCount
        self.putOnItemInfos[uid].minPrice = l_minPrice
        self.putOnItemInfos[uid].maxPrice = l_maxPrice
        self.putOnItemInfos[uid].priceInterval = l_priceInterval
        self.putOnItemInfos[uid].isPriceLimit = l_isPriceLimit
        self.putOnItemInfos[uid].originMinPrice = l_originMinPrice
        self.putOnItemInfos[uid].originMaxPrice = l_originMaxPrice

        if self:CanPutOn(self.putOnItemInfos[uid]) then
            self.curShownItemUid = uid
            self.putOnItemInfos[uid].itemTemplate:SetSelected(true)
            self:FreshItemShown()
        else
            self.putOnItemInfos[uid] = nil
        end
    end
end

--快速上架点击事件处理
function FastmountingCtrl:OnFastUpBtnClicked()
    local l_itemList = {}
    for _, itemInfo in pairs(self.putOnItemInfos) do
        if not itemInfo.isValid then
            return
        end
        table.insert(l_itemList, {
            uid = itemInfo.itemData.UID,
            id = itemInfo.itemData.TID,
            count = itemInfo.putOnNum,
            price = itemInfo.putOnPrice
        })
    end

    for _, itemInfo in pairs(self.putOnItemInfos) do
        itemInfo.itemTemplate:SetSelected(false)
    end

    if #l_itemList == 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("STALL_SELECTED_TO_SELL"))
    end

    self.stallMgr.SendStallSellItemReq(l_itemList)
    self.putOnItemInfos = {}
    self.curShownItemUid = nil
    self:FreshItemShown()
end


--计算摊位费等数据
function FastmountingCtrl:CalculateTablePrice(totalPrice)
    local l_stallRate = MGlobalConfig:GetInt("StallRate")
    local l_stallMin = MGlobalConfig:GetInt("StallRateMinValue")
    local l_stallMax = MGlobalConfig:GetInt("StallRateMaxValue")

    local l_tablePrice = math.floor(tonumber(totalPrice) * l_stallRate / 10000)
    l_tablePrice = math.min(l_tablePrice, l_stallMax)
    l_tablePrice = math.max(l_tablePrice, l_stallMin)
    return l_tablePrice
end

--是否可以上架
function FastmountingCtrl:CanPutOn(itemInfo)
    local l_curSelectedNum = 0
    local l_wholeTablePrice = 0
    for _, info in pairs(self.putOnItemInfos) do
        if info.isValid and info.itemData.UID ~= itemInfo.itemData.UID then
            l_curSelectedNum = l_curSelectedNum + 1
            l_wholeTablePrice = l_wholeTablePrice + self:CalculateTablePrice(info.putOnPrice * info.putOnNum)
        end
    end
    local l_limitMgr = MgrMgr:GetMgr("LimitBuyMgr")
    local l_count = l_limitMgr.GetItemCanBuyCount(l_limitMgr.g_limitType.STALL_UP,1)
    local l_limit = l_limitMgr.GetItemLimitCount(l_limitMgr.g_limitType.STALL_UP,1)
    local l_leftCount = l_limit - l_count - #self.stallMgr.g_sellItemInfo
    if l_leftCount <= l_curSelectedNum then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("STALL_NOT_ENOUGTH"))
        return false
    end
    if MLuaCommonHelper.Long(l_wholeTablePrice + self:CalculateTablePrice(itemInfo.putOnPrice * itemInfo.putOnNum)) > MPlayerInfo.Coin101 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("STALL_NOT_ZENY"))
        return false
    end
    return true
end

--刷新物品信息显示
function FastmountingCtrl:FreshItemShown()
    local l_isItemShown = self.curShownItemUid ~= nil
    self.panel.leftEmpty.gameObject:SetActiveEx(not l_isItemShown)
    self.panel.leftItem.gameObject:SetActiveEx(l_isItemShown)

    local l_basePrice = 0
    local l_price = 0
    local l_initNum = 0
    local l_minNum = 0
    local l_maxNum = 0
    local l_totalPrice = 0
    local l_tablePrice = 0
    if self.curShownItemUid then
        local l_itemInfo = self.putOnItemInfos[self.curShownItemUid]
        l_basePrice = l_itemInfo.basePrice
        l_price = l_itemInfo.putOnPrice
        l_initNum = l_itemInfo.putOnNum
        l_minNum = 1
        l_maxNum = l_itemInfo.itemData.ItemCount
        l_totalPrice = l_price * l_itemInfo.putOnNum
        l_tablePrice = self:CalculateTablePrice(l_totalPrice)

        --设置左侧item信息
        self.leftItemTemplate:SetData({ ID = l_itemInfo.itemData.TID, Count = l_itemInfo.putOnNum, ButtonMethod = function()
            MgrMgr:GetMgr("ItemTipsMgr").ShowStallTipsWithInfo(l_itemInfo.itemData)
            --MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithInfo(l_itemInfo.itemData)
        end })
        self.panel.itemName.LabText = l_itemInfo.itemData.ItemConfig.ItemName
    end
    self:SetTipInfo(l_price, l_basePrice)
    self.itemPriceTemplate:SetInfo(Common.Utils.Lang("ONE_ITEM_PRICE"), l_price, nil, nil, nil, nil, { ItemAtlas = "Icon_ItemConsumables01", ItemIcon = "UI_icon_item_Zeng.png" })
    self.totalNumTemplate:SetInfo(Common.Utils.Lang("TOTAL_NUM"), l_initNum, l_minNum, l_maxNum, 1, nil, nil, nil, nil)
    self.totalPriceTemplate:SetInfo(Common.Utils.Lang("TOTAL_ITEM_PRICE"), l_totalPrice, nil, nil, { ItemAtlas = "Icon_ItemConsumables01", ItemIcon = "UI_icon_item_Zeng.png" }, nil)
    local maxCountText=MNumberFormat.GetNumberFormat(MGlobalConfig:GetInt("StallRateMaxValue"))
    local tipsData = { text = StringEx.Format(Common.Utils.Lang("STALL_HELPINFO"), (MGlobalConfig:GetInt("StallRate") / 100) .. "%", MGlobalConfig:GetInt("StallRateMinValue"), maxCountText) }
    self.tablePriceTemplate:SetInfo(Common.Utils.Lang("STALL_PRICE"), l_tablePrice, nil, nil, {ItemID = GameEnum.l_virProp.Coin101, ItemAtlas = "Icon_ItemConsumables01", ItemIcon = "UI_icon_item_Zeng.png" }, tipsData)
end


--lua custom scripts end
return FastmountingCtrl