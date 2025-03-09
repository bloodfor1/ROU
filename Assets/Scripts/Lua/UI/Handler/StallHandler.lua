--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseHandler"
require "UI/Panel/StallPanel"
require "UI.Template.StallButtonTemplate"
require "UI.Template.StallSellItemTemplate"
require "UI.Template.StallSellSonBtnTemplate"
require "UI/Template/StallBagItemTemplate"

--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

SCROLLRECT_UPDATE_COUNT = 3

--lua class define
local super = UI.UIBaseHandler
StallHandler = class("StallHandler", super)
--lua class define end

--lua functions
function StallHandler:ctor()

    super.ctor(self, HandlerNames.Stall, 0)

end --func end
--next--
function StallHandler:Init()

    self.panel = UI.StallPanel.Bind(self)
    super.Init(self)
    self:InitPanel()

end --func end
--next--
function StallHandler:Uninit()

    self:UnInitPanel()
    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function StallHandler:OnActive()

    self.frame = 0
    self:RefreshIcon()

end --func end
--next--
function StallHandler:OnDeActive()


end --func end
--next--
function StallHandler:Update()

    local l_stallMgr = MgrMgr:GetMgr("StallMgr")
    ---5s定时刷新界面
    if l_stallMgr.g_lastTime <= 0 then
        l_stallMgr.g_lastTime = Time.realtimeSinceStartup
    end
    if Time.realtimeSinceStartup - l_stallMgr.g_lastTime > l_stallMgr.G_FIXED_REFRESH_INTERVAL then
        if l_mgr.g_curTypeIndex then
            self:OnTimerComing()
            l_stallMgr.g_lastTime = Time.realtimeSinceStartup
        end
    end

    if self.forceUpdateState then
        self.buyContentWrap:ForceUpdate()
        if self.nextUpdate == nil then
            self.nextUpdate = SCROLLRECT_UPDATE_COUNT
        end
        self.nextUpdate = self.nextUpdate - 1
        if self.nextUpdate == 0 then
            self.nextUpdate = nil
            self.forceUpdateState = false
        end
        return
    end
    ---没使用scrollview，自己刷新
    if self.tweenId ~= nil and self.tweenId > 0 and self.buyContentWrap then
        self.frame = self.frame + 1
        if self.frame > 2 then
            self.buyContentWrap:ForceUpdate()
            self.frame = 0
        end
    else
        self.frame = 0
    end

end --func end


--next--
function StallHandler:BindEvents()

    self:AddEvent()

end --func end
--next--
--lua functions end

--lua custom scripts
function StallHandler:_onItemChange()
    if self.panel.Sell.gameObject.activeSelf then
        self:InitSellSelectPanel()
    end

    if self.panel.Buy.gameObject.activeSelf then
        --if l_requireItem == nil then
        --    return
        --end
        self:RefrashNeedTag()
    end
end

function StallHandler:OnShow()
    self.panel.dropBtn.gameObject:SetActiveEx(false)
end

function StallHandler:OnHide()

    self.panel.dropBtn.gameObject:SetActiveEx(false)
end

l_mgr = MgrMgr:GetMgr("StallMgr")
l_event = MgrMgr:GetMgr("StallMgr").EventDispatcher

---临时点击记录，用于等待辣鸡网络回馈
local l_curTypeIndex = nil
local l_curSecTypeIndex = nil
local l_curTargetIndex = nil

local l_curUUid = nil ---当前选中的要购买的东西
local l_curCount = nil
local l_curPrice = nil
local l_curItemId = nil

local l_itemBtn = {}  ---当前滑动类表里面的item

local l_buyTypeBtn = {} ---左侧按钮

local l_refreshTimer = nil  ---刷新lab定时器
local l_buyScrollViewInit = true   ---是否初始化滑动列表

local l_sellStall = {}  ---出售摊位item
local l_sellScrollViewInit = true   ---是否初始化滑动列表

local l_isPriceUp = true           ---摆摊购买的物品排序，默认升序排序

local l_sellId = nil
local l_sellUid = nil
local l_sellNum = nil

local l_repeatId = nil
local l_repeatUid = nil
local l_repeatPrice = nil
local l_repeatCount = nil

local l_sellItemSelected = nil

local l_sellBagSelectItem = nil

--local l_sellItemPrefab = {}
local l_sellItemMap = {}

local l_buyItemPrefab = {}
local l_buyItemMap = {}

local l_curOpenBtn = nil
local l_curOpenSonPanel = nil

--local l_requireItem = nil
local l_requireType = nil

---===========================================初始化===================================================================

function StallHandler:StopTimer()
    if l_refreshTimer then
        self:StopUITimer(l_refreshTimer)
        l_refreshTimer = nil
    end
end

function StallHandler:InitPanel()
    self.panel.Sell.gameObject:SetActiveEx(false)
    self.panel.Buy.gameObject:SetActiveEx(true)


    --快速下架按钮
    self.panel.fastDownBtn:AddClick(function()
        local l_nowWeight = MgrMgr:GetMgr("ItemWeightMgr").GetCurrentWeightByType(GameEnum.EBagContainerType.Bag)
        local l_maxWeight = MgrMgr:GetMgr("ItemWeightMgr").GetMaxWeightByType(GameEnum.EBagContainerType.Bag)
        local l_isOverWeight = false
        local l_uidList = {}
        for _, v in pairs(l_mgr.g_sellItemInfo) do
            if v.leftTime <= 0 then
                local l_itemWeight = 0
                local l_row = TableUtil.GetItemTable().GetRowByItemID(v.id)
                if l_row then
                    l_itemWeight = l_row.Weight
                end
                if l_nowWeight + l_itemWeight * v.count > l_maxWeight then
                    l_isOverWeight = true
                    break
                end
                l_nowWeight = l_nowWeight + l_itemWeight * v.count
                table.insert(l_uidList, v.uid)
            end
        end
        if l_isOverWeight then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ERR_BAG_MAX_LOAD"))
        end
        l_mgr.SendStallSellItemCancelReq(l_uidList)
    end)
    --快速上架按钮
    self.panel.fastUpBtn:AddClick(function()
        UIMgr:ActiveUI(UI.CtrlNames.Fastmounting)
    end)
    --升序降序按钮
    self.panel.priceUpBtn:AddClick(function()
        l_isPriceUp = false
        self:InitBuyItemList()
    end)
    self.panel.priceDownBtn:AddClick(function()
        l_isPriceUp = true
        self:InitBuyItemList()
    end)

    self.panel.fastDownBtn.gameObject:SetActiveEx(false)
    --售卖右侧物品滑动区
    self.sellRightScrollTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.StallBagItemTemplate,
        TemplatePrefab = self.panel.StallBagItemTemplate.LuaUIGroup.gameObject,
        ScrollRect = self.panel.sellRightScroll.LoopScroll
    })

    --绑定指示箭头
    self.panel.sellLeftScroll:SetScrollRectGameObjListener(self.panel.sellUpArrow.gameObject, self.panel.sellDownArrow.gameObject, nil, nil)
    self.panel.buy:SetScrollRectGameObjListener(self.panel.buyUpArrow.gameObject, self.panel.buyDownArrow.gameObject, nil, nil)

    l_sellId = nil
    l_sellUid = nil
    l_sellNum = nil

    l_repeatId = nil
    l_repeatUid = nil
    l_repeatPrice = nil
    l_repeatCount = nil

    l_sellItemSelected = nil
    l_sellBagSelectItem = nil

    l_curOpenSonPanel = nil
    l_curOpenBtn = nil

    l_mgr.g_curSelectFilter = nil

    self.RedSignProcessor = nil

    self.forceUpdateState = false
    self.nextUpdate = nil
    self.sellForceUpdateState = false
    self.sellNextUpdate = nil

    self.buyPanelInit = false

    --l_requireItem = nil
    l_requireType = nil
    --l_requireType = UIMgr:GetShowItemNeedsAndCtrlName()
    --if l_requireType ~= nil and l_requireType ~= "" then
    --    l_requireItem = MgrMgr:GetMgr("RequireItemMgr").GetRequireItems(l_requireType)
    --end

    self.tweenId = 0
    l_buyScrollViewInit = true
    l_sellScrollViewInit = true
    self:SyncIndexState()
    self:InitSwitchBtn()
    self:RefreshMoney()
end

function StallHandler:UnInitPanel()
    self.sellRightScrollTemplatePool = nil

    self:StopTimer()
    for k, v in pairs(l_buyTypeBtn) do
        if #v.son > 0 then
            for k2, v2 in pairs(v.son) do
                self:UninitTemplate(v.btn)
            end
        end
        self:UninitTemplate(v.btn)
    end
    l_buyTypeBtn = {}
    l_buyScrollViewInit = true
    l_sellScrollViewInit = true
    l_curUUid = nil
    l_itemBtn = {}

    for k, v in pairs(l_sellStall) do
        self:UninitTemplate(v.btn)
    end
    l_sellStall = {}

    self.RedSignProcessor = nil

    --for i, v in pairs(l_sellItemPrefab) do
    --    self:UninitTemplate(v)
    --end
    --l_sellItemPrefab = {}
    l_sellItemMap = {}
    for i, v in pairs(l_buyItemPrefab) do
        self:UninitTemplate(v)
    end
    l_buyItemPrefab = {}
    l_buyItemMap = {}
end

--界面操作mark
function StallHandler:SyncIndexState()
    l_curTypeIndex = l_mgr.g_curTypeIndex
    l_curSecTypeIndex = l_mgr.g_curSecTypeIndex
    l_curTargetIndex = l_mgr.g_curTargetIndex
end


---=============================================事件=================================================================

function StallHandler:AddEvent()
    self:BindEvent(l_event, l_mgr.ON_STALL_GET_MARK_INFO_RSP, function(self, id)
        --二级页签信息
        self:OnStallGetMarkInfoEvent(id)

        self:InitBuyItemList()
    end)
    self:BindEvent(l_event, l_mgr.ON_STALL_GET_ITEM_INFO_RSP, function(self, id)
        --物品信息
        self:OnStallGetItemInfoEvent(id)
    end)
    self:BindEvent(l_event, l_mgr.ON_STALL_ITEM_BUY_RSP, function(self, id)
        --购买
        self:OnStallItemBuyEvent(id)
    end)
    self:BindEvent(l_event, l_mgr.ON_STALL_REFRESH_RSP, function()
        --刷新
        self:OnStallRefreshEvent()
    end)
    self:BindEvent(l_event, l_mgr.ON_STALL_SELL_ITEM_RSP, function(self, itemList)
        --上架
        self:OnStallSellItemEvent(itemList)
    end)
    self:BindEvent(l_event, l_mgr.ON_STALL_SELL_ITEM_CANCEL_RSP, function(self, uidList)
        --下架
        self:OnStallSellItemCancelEvent(uidList)
    end)
    self:BindEvent(l_event, l_mgr.ON_STALL_DRAWMONEY_RSP, function(self, id)
        --提现
        self:OnStallDrawMoneyEvent(id)
    end)
    self:BindEvent(l_event, l_mgr.ON_STALL_BUY_STALL_COUNT_RSP, function()
        --摊位购买
        self:OnStallBuyStallCountEvent()
    end)
    self:BindEvent(l_event, l_mgr.ON_CLICK_STALL_BUY_BTN, function(self, id)
        --点击按钮信息
        self:OnClickStallBuyBtnEvent(id)
    end)
    self:BindEvent(l_event, l_mgr.ON_CLICK_STALL_PARENT_BTN, function(self, id)
        --点击按钮信息
        self:OnClickStallParentBtnEvent(id)
    end)
    self:BindEvent(l_event, l_mgr.ON_STALL_GET_SELL_INFO_RSP, function()
        self:OnStallGetSellInfoEvent()
    end)
    self:BindEvent(l_event, l_mgr.ON_STALL_GET_PRE_SELL_ITEM_INFO_RSP, function(self, id)
        self:OnStallGetPreSellItemInfoEvent(id)
    end)
    self:BindEvent(l_event, l_mgr.ON_STALL_ITEM_SOLD_NOTIFY, function()
        self:OnStallItemSoldNotifyEvent()
    end)

    local l_currencyMgr = MgrMgr:GetMgr("CurrencyMgr")
    self:BindEvent(l_currencyMgr.EventDispatcher, l_currencyMgr.EXCHANGE_MONEY_SUCCESS, function()
        self:RefreshMoney()
    end)

    self:BindEvent(l_event, l_mgr.ON_CLICK_REPEAT_BTN, function(self, id, price, count, uid)
        self:OnClickRepeatBtn(id, price, count, uid)
    end)

    local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
    self:BindEvent(gameEventMgr.l_eventDispatcher, gameEventMgr.OnBagUpdate, self._onItemChange)

    self:BindEvent(l_event, l_mgr.ON_CLICK_SELL_ITEM, function(self, go)
        self:OnClickSellItemEvent(go)
    end)

    --售卖物品选择item点击事件
    self:BindEvent(l_event, l_mgr.ON_CLICK_SELL_SELECT_ITEM, function(self, template)
        self:OnClickSellSelectItemEvent(template)
    end)
end

--二级页签信息
function StallHandler:OnStallGetMarkInfoEvent(id)
    if (not self.panel) or l_buyScrollViewInit then
        return
    end
    if l_curTypeIndex == id and
            l_curSecTypeIndex == nil then
        if l_curTypeIndex ~= l_mgr.g_curTypeIndex then
            self:ResetWrap()
        end
        local l_ref = false
        if l_curTypeIndex ~= l_mgr.g_curTypeIndex then
            l_ref = true
            self:ClearOpenBtnInfo()
            self:CloseSonPanel()
        end

        l_mgr.g_curTypeIndex = id
        l_mgr.g_curSecTypeIndex = nil
        l_mgr.g_curTargetIndex = nil
        --logGreen("--->>>"..tostring(l_mgr.g_curTypeIndex))
        --Common.Functions.DumpTable(l_buyTypeBtn, "<var>", 6)
        self:SyncIndexState()
        l_curUUid = nil
        self:InitBuyItemList()
        if l_ref then
            local l_curIndex = l_mgr.g_curTypeIndex
            if l_mgr.g_tab[l_curIndex] then
                l_curOpenBtn = l_buyTypeBtn[l_curIndex]
                l_curOpenBtn.btn:SetState(true)
            else
                local l_curParentId = l_mgr.GetParentIdBySonId(l_curIndex)
                if l_curParentId then
                    l_curOpenBtn = l_buyTypeBtn[l_curParentId]
                    l_curOpenBtn.btn:SetState(true)
                    l_curOpenSonPanel = l_curOpenBtn.sonPanel
                    if l_curOpenSonPanel then
                        l_curOpenSonPanel:SetActiveEx(true)
                    end
                    l_curOpenBtn.btn:SetState(true)
                    local l_targetBtn = l_curOpenBtn.son[l_mgr.g_curTypeIndex]
                    if l_targetBtn then
                        l_targetBtn.btn:SetState(true)
                    end
                end
            end
        end
    end
end

--物品信息
function StallHandler:OnStallGetItemInfoEvent(id)
    if (not self.panel) or l_buyScrollViewInit then
        return
    end
    ---不操作,网络刷新
    if l_curTypeIndex == l_mgr.g_curTypeIndex and
            l_curSecTypeIndex == l_mgr.g_curSecTypeIndex and
            l_curTargetIndex == l_mgr.g_curTargetIndex then
        local l_itemId = l_mgr.GetItemIdByTargetIndex(l_mgr.g_curTypeIndex, l_mgr.g_curSecTypeIndex,
                l_mgr.g_curTargetIndex)
        if l_itemId == id then
            self:InitBuyItemList()
            return
        end
    end
    ---切换等级索引刷新
    --if l_curTypeIndex == l_mgr.g_curTypeIndex and
    --l_curSecTypeIndex == l_mgr.g_curSecTypeIndex then
    if l_curTypeIndex == l_mgr.g_curTypeIndex then
        local l_result = l_mgr.g_tableInfo[l_curTypeIndex].secList[l_curSecTypeIndex]
        if l_result == nil then
            return
        end
        ---没等级选项的情况
        local l_limit = l_result.limitIndexList
        if l_limit == nil then
            if l_result.target.ItemID == id then
                l_mgr.g_curSecTypeIndex = l_curSecTypeIndex
                l_mgr.g_curTargetIndex = l_curTargetIndex
                self:SyncIndexState()
                l_curUUid = nil
                self:InitBuyItemList()
                return
            end
        end
        ---有等级选项的情况
        local l_targetIndex = l_mgr.GetTargetIndexByItemId(l_curTypeIndex, l_curSecTypeIndex, id)
        if l_targetIndex == nil then
            return
        end
        if l_curTargetIndex == l_targetIndex then
            l_mgr.g_curSecTypeIndex = l_curSecTypeIndex
            l_mgr.g_curTargetIndex = l_curTargetIndex
            self:SyncIndexState()
            l_curUUid = nil
            self:InitBuyItemList()
            self:ResetWrap()
        end
    end
end
--购买
function StallHandler:OnStallItemBuyEvent(id)

    if self.panel then
        self:OnTimerComing()
    end
end
--刷新
function StallHandler:OnStallRefreshEvent()
    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Common.Utils.Lang("STALL_REFRESH_SUCCESS"), tostring(self.refPrice),
            MgrMgr:GetMgr("TipsMgr").GetItemIconTips(102)))
    self:ClearSelectedState()
    if self.panel then
        self:RefreshMoney()
        self:OnTimerComing()
    end
end

--摊位信息更新
function StallHandler:OnStallGetSellInfoEvent()
    if self.panel and self.panel.Sell.gameObject.activeSelf then
        self:InitSellItemPanel()
    end
end

---@return ItemData
function StallHandler:_getBagItemByUID(uid)
    if nil == uid then
        logError("[ItemMgr] uid got nil")
        return nil
    end

    local types = { GameEnum.EBagContainerType.Bag }
    local itemFuncUtil = MgrProxy:GetItemDataFuncUtil()
    ---@type FiltrateCond
    local condition = { Cond = itemFuncUtil.IsItemUID, Param = uid }
    local conditions = { condition }
    local ret = Data.BagApi:GetItemsByTypesAndConds(types, conditions)
    return ret[1]
end

---点击背包物品信息
function StallHandler:OnStallGetPreSellItemInfoEvent(id)
    if l_sellNum ~= nil and l_sellId ~= nil and l_sellUid ~= nil then
        if l_sellId == id then
            local l_tempId = l_sellId
            local l_tempUid = l_sellUid
            local l_tempNum = l_sellNum
            local l_itemInfo = self:_getBagItemByUID(l_sellUid)
            --- 如果售卖的货物已卖出的情况下，l_itemInfo可能为nil
            if l_itemInfo ~= nil then
                ---async
                MgrMgr:GetMgr("ItemTipsMgr").ShowStallTipsWithInfo(l_itemInfo,
                        function(ctrl)
                            ctrl:ShowStallPutOnPanel(l_tempId, l_tempUid, l_mgr.g_basePriceInfo[l_tempId],
                                    l_tempNum, function(itemId, uid, num, price, const)
                                        --if MLuaCommonHelper.Long(const) > MPlayerInfo.Coin101 then
                                        --MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("STALL_NOT_ZENY"))
                                        --else
                                        l_mgr.SendStallSellItemReq({ { uid = uid, id = itemId, count = num, price = price } },const)
                                        --end
                                    end)
                        end)
            end
            return
        end
    end
    if l_repeatId ~= nil and l_repeatPrice ~= nil and l_repeatCount ~= nil and l_repeatUid ~= nil then
        if l_repeatId == id then
            local l_targetInfo = nil
            for k, v in pairs(l_mgr.g_sellItemInfo) do
                local l_uid = v.uid
                local l_id = v.id
                if l_repeatId == l_id and l_repeatUid == l_uid then
                    l_targetInfo = v
                    break
                end
            end
            if l_targetInfo == nil then
                return
            end

            ---@type ItemData
            local l_itemInfo = l_targetInfo.itemInfo
            MgrMgr:GetMgr("ItemTipsMgr").ShowStallTipsWithInfo(l_itemInfo,
                    function()
                        local l_ui = UIMgr:GetUI(UI.CtrlNames.CommonItemTips)
                        if l_ui then
                            local l_basePrice = l_mgr.g_basePriceInfo[l_repeatId]
                            l_ui:ShowStallRepeatSellPanel(l_repeatId, l_basePrice, l_basePrice, l_repeatCount,
                                    function(itemId, num, price, isOvertime, cost)
                                        if isOvertime then
                                            if MLuaCommonHelper.Long(cost) > MPlayerInfo.Coin101 then
                                                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("STALL_NOT_ZENY"))
                                            else
                                                l_mgr.SendStallReSellItemReq(l_repeatId, l_repeatUid, price, l_repeatCount)
                                            end
                                        else
                                            l_mgr.SendStallSellItemCancelReq({ l_repeatUid })
                                        end
                                    end)
                        end
                    end)
        end
    end

end
--上架
function StallHandler:OnStallSellItemEvent(itemList)
    for _, item in ipairs(itemList) do
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("STALL_PUTON_SUCCESS", MgrMgr:GetMgr("TipsMgr").GetNormalItemTips(item.id, item.count)))
    end
    l_mgr.SendStallGetSellInfoReq()
end
--下架
function StallHandler:OnStallSellItemCancelEvent(uidList)
    l_mgr.SendStallGetSellInfoReq()
end
--提现
function StallHandler:OnStallDrawMoneyEvent(id)
    l_mgr.SendStallGetSellInfoReq()
end
--摊位购买
function StallHandler:OnStallBuyStallCountEvent()
    l_mgr.SendStallGetSellInfoReq()
end
--点击按钮信息
function StallHandler:OnClickStallBuyBtnEvent(id)
    l_mgr.g_curSelectFilter = nil
    l_curTypeIndex = id
    l_curSecTypeIndex = nil
    l_curTargetIndex = nil
    if l_curTypeIndex == l_mgr.g_curTypeIndex then
        if l_curOpenBtn and l_curOpenBtn.id ~= id then
            if not (l_mgr.GetParentIdBySonId(id) == l_curOpenBtn.id) then
                self:ClearOpenBtnInfo()
                self:CloseSonPanel()
            end
        end
        if l_buyTypeBtn[id] then
            l_curOpenBtn = l_buyTypeBtn[id]
            if not MLuaCommonHelper.IsNull(l_curOpenBtn.sonPanel) then
                l_curOpenSonPanel = l_curOpenBtn.sonPanel
                l_curOpenSonPanel:SetActiveEx(true)
            end
            l_curOpenBtn.btn:SetState(true)
            local l_targetBtn = l_curOpenBtn.son[l_mgr.g_curTypeIndex]
            if l_targetBtn then
                l_targetBtn.btn:SetState(true)
            end
        end
    end
end

function StallHandler:OnClickStallParentBtnEvent(id)
    local l_open = true
    if l_curOpenBtn then
        if l_curOpenBtn.id == id then
            l_open = false
        end
        self:ClearOpenBtnInfo()
    end
    self:CloseSonPanel()
    if l_open then
        if l_buyTypeBtn[id] and (not MLuaCommonHelper.IsNull(l_buyTypeBtn[id].sonPanel)) then
            l_curOpenBtn = l_buyTypeBtn[id]
            l_curOpenSonPanel = l_curOpenBtn.sonPanel
            l_curOpenSonPanel:SetActiveEx(true)
            l_curOpenBtn.btn:SetState(true)
            local l_targetBtn = l_curOpenBtn.son[l_mgr.g_curTypeIndex]
            if l_targetBtn then
                l_targetBtn.btn:SetState(true)
            end
        end
    end
end

function StallHandler:OnStallItemSoldNotifyEvent()
    l_mgr.SendStallGetSellInfoReq()
end

function StallHandler:OnClickSellItemEvent(go)
    if not MLuaCommonHelper.IsNull(l_sellItemSelected) then
        l_sellItemSelected:SetActiveEx(false)
    end
    l_sellItemSelected = go
    l_sellItemSelected:SetActiveEx(true)
end

--售卖右侧item点击处理
function StallHandler:OnClickSellSelectItemEvent(template)
    ---@type ItemData
    local l_data = template.itemData

    l_sellId = nil
    l_sellUid = nil
    l_sellNum = nil
    local l_limitMgr = MgrMgr:GetMgr("LimitBuyMgr")
    local l_stallMgr = MgrMgr:GetMgr("StallMgr")
    local l_count = l_limitMgr.GetItemCanBuyCount(l_limitMgr.g_limitType.STALL_UP,1)
    local l_limit = l_limitMgr.GetItemLimitCount(l_limitMgr.g_limitType.STALL_UP,1)
    local l_haveCount = l_limit - l_count
    if l_haveCount > #l_stallMgr.g_sellItemInfo then
        l_repeatId = nil
        l_repeatUid = nil
        l_repeatPrice = nil
        l_repeatCount = nil
        l_sellId = l_data.TID
        l_sellUid = l_data.UID
        l_sellNum = l_data.ItemCount
        l_mgr.SendStallGetPreSellItemInfoReq(l_data.TID)
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("STALL_NOT_ENOUGTH"))
    end
    if l_sellBagSelectItem then
        l_sellBagSelectItem.template:SetSelected(false)
        l_sellBagSelectItem = nil
    end
    template:SetSelected(true)
    l_sellBagSelectItem = {}
    l_sellBagSelectItem.id = l_data.TID
    l_sellBagSelectItem.uid = l_data.UID
    l_sellBagSelectItem.template = template
end

---=============================================购买=================================================================

function StallHandler:InitSwitchBtn()
    ---初始化btn
    self.panel.BuyOffBtn:AddClick(function()
        self:SetPanelState(true)
        --UIWrapContent有bug,先setactive true,才能初始化
        if not self.buyPanelInit then
            self:InitBuyPanel()
            l_curUUid = nil
            self:InitBuyItemList()
            self.buyPanelInit = true
        end
    end)
    self.panel.SellOffBtn:AddClick(function()
        self:SetPanelState(false)
        self:InitSellItemPanel()
    end)
    if l_mgr.g_init then
        if self.buyPanelInit then
            l_curUUid = nil
            self:InitBuyItemList()
        end
        if l_mgr.g_isBuyPanel then
            if not self.buyPanelInit then
                self:InitBuyPanel()
                l_curUUid = nil
                self:InitBuyItemList()
                self.buyPanelInit = true
            end
            self:SetPanelState(true)
        else
            self:SetPanelState(false)
            self:InitSellItemPanel()
        end
    end
end

function StallHandler:SetPanelState(state)
    self.panel.Buy.gameObject:SetActiveEx(state)
    self.panel.Sell.gameObject:SetActiveEx(not state)
    self.panel.BuyOffBtn.gameObject:SetActiveEx(not state)
    self.panel.BuyOnBtn.gameObject:SetActiveEx(state)
    self.panel.SellOffBtn.gameObject:SetActiveEx(state)
    self.panel.SellOnBtn.gameObject:SetActiveEx(not state)
end

function StallHandler:InitBuyPanel()
    self.forceUpdateState = false
    self.nextUpdate = nil

    if self.RedSignProcessor == nil then
        self.RedSignProcessor = self:NewRedSign({
            Key = eRedSignKey.SweaterStall,
            ClickButton = self.panel.SellOffBtn,
            RedSignParent = self.panel.SellOffBtn.gameObject.transform.parent:Find("GameObject")
        })
    end
    ---初始化按钮列表
    l_buyTypeBtn = {}

    local l_table = l_mgr.g_tab --- TableUtil.GetStallIndexTable().GetTable()
    local l_typeBtn = self.panel.StallButtonTemplate
    local l_parent = l_typeBtn.LuaUIGroup.gameObject.transform.parent
    local l_p2 = self.panel.SonPanel.gameObject.transform.parent.gameObject
    for i = 1, #l_table do
        local l_info = l_table[i]
        local l_id = l_info.id
        local l_table = TableUtil.GetStallIndexTable().GetRowByID(l_id)
        if MPlayerInfo.ServerLevel >= l_table.ServerLevelLimit then
            l_buyTypeBtn[l_id] = {}
            l_buyTypeBtn[l_id].id = l_id
            l_buyTypeBtn[l_id].son = {}
            l_buyTypeBtn[l_id].btn = self:NewTemplate("StallButtonTemplate", {
                Data = l_info,
                TemplatePrefab = l_typeBtn.LuaUIGroup.gameObject,
                TemplateParent = l_parent,
                IsActive = true
            })
            l_buyTypeBtn[l_id].sonPanel = nil
            if l_info.son and #l_info.son > 0 then
                local l_go = self:CloneObj(self.panel.SonPanel.gameObject)
                MLuaCommonHelper.SetParent(l_go, l_p2)
                l_go:SetLocalScaleOne()
                l_go.gameObject:SetActiveEx(false)
                l_buyTypeBtn[l_id].sonPanel = l_go
                for i = 1, #l_info.son do
                    local l_sonId = l_info.son[i]
                    local l_sonTable = TableUtil.GetStallIndexTable().GetRowByID(l_sonId)
                    if MPlayerInfo.ServerLevel >= l_sonTable.ServerLevelLimit then
                        l_buyTypeBtn[l_id].son[l_sonId] = {}
                        l_buyTypeBtn[l_id].son[l_sonId].id = l_sonId
                        l_buyTypeBtn[l_id].son[l_sonId].btn = self:NewTemplate("StallSellSonBtnTemplate", {
                            Data = l_sonId,
                            TemplatePrefab = self.panel.StallSellSonBtnTemplate.LuaUIGroup.gameObject,
                            TemplateParent = l_go.transform,
                            IsActive = true
                        })
                    end
                end
            end
        end
    end
    self:RefrashNeedTag()
    --l_buyTypeBtn[l_mgr.g_curTypeIndex].btn:SetState(true)
    local l_cufIndex = l_mgr.g_curTypeIndex
    if l_mgr.g_tab[l_cufIndex] then
        l_curOpenBtn = l_buyTypeBtn[l_cufIndex]
        l_curOpenBtn.btn:SetState(true)
        self:CloseSonPanel()
    else
        local l_curParentId = l_mgr.GetParentIdBySonId(l_cufIndex)
        if l_curParentId then
            l_curOpenBtn = l_buyTypeBtn[l_curParentId]
            l_curOpenBtn.btn:SetState(true)
            if l_curParentId ~= l_cufIndex then
                l_curOpenBtn.son[l_cufIndex].btn:SetState(true)
            end
            local l_curPanel = l_curOpenBtn.sonPanel
            if l_curPanel ~= l_curOpenSonPanel then
                self:CloseSonPanel()
                if l_curPanel and (not MLuaCommonHelper.IsNull(l_curPanel)) then
                    l_curOpenSonPanel = l_curPanel
                    l_curOpenSonPanel:SetActiveEx(true)
                end
            end
        end
    end

    ----点击购买
    self.panel.BuyBtn:AddClick(function()
        if l_curUUid then
            if l_curCount == nil then
                return
            end
            local l_targetInfo = nil
            local l_info = l_mgr.g_allItemInfo[l_curItemId]
            l_curPrice = nil
            for i = 1, #l_info do
                if l_info[i].uid == l_curUUid then
                    l_curPrice = l_info[i].price
                    l_targetInfo = l_info[i]
                    break
                end
            end
            if l_curPrice == nil or l_targetInfo == nil then
                return
            end
            if l_curCount == 1 then
                self:BuyItem(l_curUUid, 1, l_curPrice, l_curItemId)
                return
            end
            if l_curCount > 1 then
                ---@type ItemData
                local l_itemInfo = l_targetInfo.itemInfo
                local buyNum = 1
                buyNum = MgrMgr:GetMgr("RequireItemMgr").GetNeedItemCountByID(l_curItemId) - Data.BagModel:GetBagItemCountByTid(tonumber(l_targetInfo.uid))
                if buyNum <= 0 then
                    buyNum = 1
                end
                MgrMgr:GetMgr("ItemTipsMgr").ShowStallTipsWithInfo(l_itemInfo,
                        function()
                            local l_ui = UIMgr:GetUI(UI.CtrlNames.CommonItemTips)
                            if l_ui then
                                l_ui:ShowStallBuyPanel(l_curItemId, l_curPrice, l_curCount,
                                        function(itemId, num)
                                            self:BuyItem(l_curUUid, num, l_curPrice, itemId)
                                        end, buyNum)
                                --居中显示
                                l_ui:SetPositionCenter()
                            end
                        end, { stallUid = l_targetInfo.uid })
                return
            end
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("STALL_SELECTED_NO"))
        end
    end)
    -----点击刷新
    self.panel.refBtn:AddClick(function()
        local l_limitBuyMgr = MgrMgr:GetMgr("LimitBuyMgr")
        local l_stallRefreshId = 1
        local l_count = l_limitBuyMgr.GetItemCount(l_limitBuyMgr.g_limitType.STALL_LIST,l_stallRefreshId) + 1
        local l_table = TableUtil.GetStallRefreshTable().GetTable()
        local l_target = nil
        local l_max = nil
        for i, v in pairs(l_table) do
            if v.count >= l_count then
                if l_target == nil then
                    l_target = v
                end
                if l_target.count > v.count then
                    l_target = v
                end
            end
            if l_max == nil then
                l_max = v
            end
            if l_max.count < v.count then
                l_max = v
            end
        end
        if l_target == nil then
            l_target = l_max
        end
        self.refPrice = l_target.cost
        local l_itemInfo = TableUtil.GetItemTable().GetRowByItemID(102)

        CommonUI.Dialog.ShowYesNoDlg(true, nil, StringEx.Format(Common.Utils.Lang("STALL_CONSUM"), MNumberFormat.GetNumberFormat(tostring(self.refPrice)), MgrMgr:GetMgr("TipsMgr").GetItemIconTips(102)),
                function()
                    --屏蔽掉金币不足的提示 在刷新回调里面做
                    --if MPlayerInfo.Coin102 >= MLuaCommonHelper.Long(self.refPrice) then
                    if l_mgr.g_curTargetIndex == nil then
                        self:ResetWrap()
                        l_mgr.SendStallRefreshReq(l_mgr.g_curSecTypeIndex,self.refPrice)
                        return
                    end
                    local l_result = l_mgr.g_tableInfo[l_mgr.g_curTypeIndex].secList[l_mgr.g_curSecTypeIndex]
                    local l_limit = l_result.limitIndexList
                    local l_id = nil
                    if l_limit == nil then
                        l_id = l_result.target.ItemID
                    else
                        local l_secIndex = l_limit[l_mgr.g_curTargetIndex]

                        for k, v in pairs(l_result.detailIndexList) do
                            if l_secIndex == v.Index2 then
                                l_id = v.ItemID
                                break
                            end
                        end
                    end
                    if l_id then
                        self:ResetWrap()
                        l_mgr.SendStallRefreshReq(l_id,self.refPrice)
                    else
                        logError("[StallHandler]InitBuyPanel,id == nil")
                    end
                    -- else
                    --     MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("STALL_RO_NOT_ENOUGTH"))
                    -- end
                end, nil)
    end)
    self:RefreshMoney()
end

function StallHandler:RefrashNeedTag()
    local l_table = l_mgr.g_tab --- TableUtil.GetStallIndexTable().GetTable()
    for i = 1, #l_table do
        local l_info = l_table[i]
        local l_id = l_info.id
        local l_parent = l_buyTypeBtn[l_id]
        if l_parent then
            local l_parentBtn = l_parent.btn
            if l_info.son and #l_info.son > 0 then
                local l_need = false
                for i = 1, #l_info.son do
                    local l_sonId = l_info.son[i]
                    local l_son = l_parent.son[l_sonId]
                    if l_son then
                        local l_sonBtn = l_son.btn
                        local l_state = l_sonBtn:RefrashNeedTag()
                        l_need = l_need or l_state
                    end
                end
                l_parentBtn:SetNeedTag(l_need)
            else
                l_parentBtn:RefrashNeedTag()
            end
        end
    end
end

function StallHandler:RefreshIcon()
    self:InitBuyItemList()
    if table.ro_size(l_buyTypeBtn) > 0 then
        for k, v in pairs(l_buyTypeBtn) do
            v.btn:SetUIInfo()
        end
    end
end

function StallHandler:CloseSonPanel()
    if l_curOpenSonPanel and (not MLuaCommonHelper.IsNull(l_curOpenSonPanel)) then
        l_curOpenSonPanel:SetActiveEx(false)
        l_curOpenSonPanel = nil
    end
end

function StallHandler:ClearOpenBtnInfo()
    if l_curOpenBtn then
        l_curOpenBtn.btn:SetState(false)
        local l_targetBtn = l_curOpenBtn.son[l_mgr.g_curTypeIndex]
        if l_targetBtn then
            l_targetBtn.btn:SetState(false)
        end
        l_curOpenBtn = nil
    end
end

function StallHandler:InitRefreshTimer()
    self:StopTimer()
    if self.panel then
        local l_duration = tonumber(l_mgr.g_nextRefreshTime) or 0
        if l_duration < 1 then
            self.panel.refText.LabText = RoColor.FormatWord(Lang("STALL_REFRESH_TIMER", StringEx.Format("{0:00}:{1:00}", 0, 0)))
            return
        end
        local l_seconds = l_duration % 60
        local l_mins = math.floor(l_duration / 60)
        self.panel.refText.LabText = RoColor.FormatWord(Lang("STALL_REFRESH_TIMER", StringEx.Format("{0:00}:{1:00}", l_mins, l_seconds)))
        l_refreshTimer = self:NewUITimer(function()
            l_duration = l_duration - 1
            local l_seconds = l_duration % 60
            local l_mins = math.floor(l_duration / 60)
            self.panel.refText.LabText = RoColor.FormatWord(Lang("STALL_REFRESH_TIMER", StringEx.Format("{0:00}:{1:00}", l_mins, l_seconds)))
            if l_duration < 1 then
                self.panel.refText.LabText = RoColor.FormatWord(Lang("STALL_REFRESH_TIMER", StringEx.Format("{0:00}:{1:00}", 0, 0)))
                self:StopTimer()
                ---发送更新协议;
                self:ResetWrap()
                self:ClearSelectedState()
                self:OnTimerComing()
            end
        end, 1, -1, true)
        l_refreshTimer:Start()
    end
end

function StallHandler:OnTimerComing()
    if l_mgr.g_curSecTypeIndex == nil then
        l_mgr.SendStallGetMarkInfoReq(l_mgr.g_curTypeIndex)
        return
    end
    local l_id = nil
    local l_result = l_mgr.g_tableInfo[l_mgr.g_curTypeIndex].secList[l_mgr.g_curSecTypeIndex]
    ---没等级选项的情况
    local l_limit = l_result.limitIndexList
    if l_limit == nil then
        l_id = l_result.target.ItemID
        if l_id then
            l_mgr.SendStallGetItemInfoReq(l_id)
        end
        return
    end
    local l_itemid = l_mgr.GetItemIdByTargetIndex(l_mgr.g_curTypeIndex, l_mgr.g_curSecTypeIndex,
            l_mgr.g_curTargetIndex)
    if l_itemid then
        l_mgr.SendStallGetItemInfoReq(l_itemid)
    end
end

function StallHandler:ResetWrap()
    if not self.buyContentWrap then
        return
    end
    self.buyContentWrap.gameObject:SetLocalPosY(0)
    self.forceUpdateState = true
end

function StallHandler:RefreshMoney()
    if self.panel then
        if self.DirectBuy and self.targetUid == l_curUUid then
            self:BuyItem(l_curUUid, self.targetNum, l_curPrice, l_curItemId)
        end
    end
    self.DirectBuy = false
end

function StallHandler:OnClickRepeatBtn(id, price, count, uid)
    l_sellId = nil
    l_sellUid = nil
    l_sellNum = nil
    l_repeatId = id
    l_repeatCount = count
    l_repeatPrice = price
    l_repeatUid = uid
    l_mgr.SendStallGetPreSellItemInfoReq(l_repeatId)
end

function StallHandler:BuyItem(uid, num, price, itemId)
    if num == nil or uid == nil or itemId == nil or price == nil then
        return
    end
    local l_price = price * num
    -- if MPlayerInfo.Coin101 >= MLuaCommonHelper.Long(l_price) then
        l_mgr.SendStallItemBuyReq(uid, num, l_price)
    -- else
    --     MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("STALL_ZENY_NOT_ENOUGTH"))
    --     local propInfo = Data.BagModel:CreateItemWithTid(101)
    --     MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplay(propInfo, nil, nil, nil, true)
    -- end
end

function StallHandler:InitBuyItemList()
    self:InitRefreshTimer()
    l_itemBtn = {}
    --l_curUUid = nil
    if l_buyScrollViewInit and not self.panel.Buy.gameObject.activeSelf then
        return
    end
    if l_buyScrollViewInit then
        self.buyContentWrap = self.panel.buyContent.gameObject:GetComponent("UIWrapContent")
        self.buyContentWrap:InitContent()
        l_buyScrollViewInit = false
    end
    self.panel.buyPanel.gameObject:SetActiveEx(true)
    self.targetScrollRect = self.panel.buyPanel.gameObject.transform:Find("buy").gameObject:GetComponent("ScrollRect")
    self.pageObj = self.panel.Buy.gameObject.transform:Find("Page").gameObject
    self.panel.noObject.gameObject:SetActiveEx(false)
    self.panel.priceUpBtn.gameObject:SetActiveEx(false)
    self.panel.priceDownBtn.gameObject:SetActiveEx(false)
    local l_seconds = l_mgr.g_curSecTypeIndex == nil ---是否显示的二级目录
    local l_count = 0
    local l_result = {}
    self.panel.dropBtn.DropDown.onValueChanged:RemoveAllListeners()
    if l_seconds then
        l_result = l_mgr.g_tableInfo[l_mgr.g_curTypeIndex].indexList
        local l_searchList = {}
        local l_tempResult = {}
        l_searchList[1] = Common.Utils.Lang("AllText")
        local l_table = TableUtil.GetStallIndexDescTable()
        local l_serverLimitResult = {}
        for i = 1, #l_result do
            local l_temp = l_table.GetRowByID(l_result[i])
            if l_temp and MPlayerInfo.ServerLevel >= l_temp.ServerLevelLimit then
                l_serverLimitResult[#l_serverLimitResult + 1] = l_result[i]
                if l_temp.Fliter ~= "" then
                    local l_exit = false
                    for i = 1, #l_searchList do
                        if l_searchList[i] == l_temp.Fliter then
                            l_exit = true
                            break
                        end
                    end
                    if not l_exit then
                        l_searchList[#l_searchList + 1] = l_temp.Fliter
                    end
                    if l_mgr.g_curSelectFilter then
                        if l_temp.Fliter == l_mgr.g_curSelectFilter then
                            l_tempResult[#l_tempResult + 1] = l_result[i]
                        end
                    end
                end
            end
        end
        l_result = l_serverLimitResult
        if #l_searchList > 1 then
            self.panel.dropBtn.gameObject:SetActiveEx(true)
            self.panel.dropBtn.DropDown:ClearOptions()
            self.panel.dropBtn:SetDropdownOptions(l_searchList)
            if l_mgr.g_curSelectFilter then
                local l_value = 1
                for i = 1, #l_searchList do
                    if l_mgr.g_curSelectFilter == l_searchList[i] then
                        l_value = i
                        break
                    end
                end
                self.panel.dropBtn.DropDown.value = l_value - 1
            else
                self.panel.dropBtn.DropDown.value = 0
                l_mgr.g_curSelectFilter = nil
            end
            self.panel.dropBtn.DropDown.onValueChanged:AddListener(function(index)
                if index == 0 then
                    l_mgr.g_curSelectFilter = nil
                else
                    l_mgr.g_curSelectFilter = l_searchList[index + 1]
                end
                self.panel.dropBtn.DropDown.onValueChanged:RemoveAllListeners()
                self:InitBuyItemList()
            end)
        else
            self.panel.dropBtn.gameObject:SetActiveEx(false)
        end

        if l_mgr.g_curSelectFilter then
            l_result = l_tempResult
        end
        l_count = #l_result
        self.buyContentWrap.updateOneItem = function(obj, index)
            --self:HideBuyItem(index)
            ---@type StallItemClone
            local l_item = {}
            self:ExportBuyItem(l_item, obj)
            l_item.canvasGroup.alpha = 1
            l_item.price:SetActiveEx(false)
            l_item.selected:SetActiveEx(false)
            l_item.sellOut:SetActiveEx(false)
            l_item.sellCount.gameObject:SetActiveEx(true)
            l_item.itemCount.gameObject:SetActiveEx(false)
            l_item.needPanle.gameObject:SetActiveEx(false)
            if l_mgr.g_allMarkInfo[l_result[index + 1]] == nil then
                return
            end
            local l_sellCount = l_mgr.g_allMarkInfo[l_result[index + 1]].num
            --local l_chooseNumber = l_mgr.g_tableInfo[l_mgr.g_curTypeIndex].secList[l_result[index + 1]].ChooseNumber
            l_item.sellCount.LabText = Common.Utils.Lang("STALL_IN_SELL") .. tostring(l_sellCount)
            --if l_sellCount > l_chooseNumber then
            --    l_item.sellCount.LabText = Common.Utils.Lang("STALL_IN_SELL") .. tostring(l_chooseNumber) .. "+"
            --end
            local l_name, l_atlas, l_icon = l_mgr.GetTypeInfoByIndex(l_result[index + 1])
            l_item.name.LabText = l_name
            l_item.btn:AddClick(function()
                --TODO:暂时直接发默认id
                l_curSecTypeIndex = l_result[index + 1]
                local l_info = l_mgr.g_tableInfo[l_mgr.g_curTypeIndex].secList[l_curSecTypeIndex]
                l_curTargetIndex = l_info.targetIndex
                local l_id = l_info.target.ItemID
                local l_netInfo = l_mgr.g_allMarkInfo[l_result[index + 1]]
                if l_curTargetIndex and l_netInfo.secNum then
                    if l_netInfo.secNum[l_id] == nil or l_netInfo.secNum[l_id] < 1 then
                        local l_temp, l_tempIndex = l_mgr.GetSuperLimitTargetIndex(l_curSecTypeIndex, l_info.detailIndexList)
                        if l_temp then
                            l_id = l_temp.ItemID
                            l_curTargetIndex = l_tempIndex
                        end
                    end
                end
                if l_id == nil then
                    logError("[StallHandler]InitBuyItemList,id == nil")
                    return
                else
                    l_mgr.SendStallGetItemInfoReq(l_id)
                end
            end)
            local l_tempSecTypeIndex = l_result[index + 1]
            local l_tempInfo = l_mgr.g_tableInfo[l_mgr.g_curTypeIndex].secList[l_tempSecTypeIndex]
            local l_tempTargetIndex = l_tempInfo.targetIndex
            local l_tempId = l_tempInfo.target.ItemID
            self:SetNeedNumTxt(l_tempId, l_item)
            self:CreateDisplayItem(obj, index, l_item.icon, l_tempId, function()

            end)

        end
        self.panel.buyTipsText.gameObject:SetActiveEx(true)
        self.targetScrollRect.enabled = true
    else
        self.panel.buyTipsText.gameObject:SetActiveEx(false)
        self.targetScrollRect.enabled = false
        --设置上下指示箭头
        self.panel.buyUpArrow.gameObject:SetActiveEx(false)
        self.panel.buyDownArrow.gameObject:SetActiveEx(false)

        l_result = l_mgr.g_tableInfo[l_mgr.g_curTypeIndex].secList[l_mgr.g_curSecTypeIndex]
        local l_limit = l_result.limitIndexList
        local l_target = l_result.target
        local l_targetItemId = l_target.ItemID
        if l_mgr.g_curTargetIndex ~= nil then
            l_target = l_limit[l_mgr.g_curTargetIndex]
        end
        if l_limit == nil then
            self.panel.dropBtn.gameObject:SetActiveEx(false)
        else
            local l_searchList = {}
            local l_value = 0
            local l_serverLimit = {}
            local l_serverTarget = nil
            for i = 1, #l_limit do
                for k, v in pairs(l_result.detailIndexList) do
                    if l_limit[i] == v.Index2 and MPlayerInfo.ServerLevel >= v.ServerLevelLimit then
                        l_serverLimit[#l_serverLimit + 1] = l_limit[i]
                        table.insert(l_searchList, v.Name)
                        if l_limit[i] == l_target then
                            l_serverTarget = l_target
                        end
                        break
                    end
                end
            end
            if #l_serverLimit < 1 then
                self.panel.dropBtn.gameObject:SetActiveEx(false)
                l_value = -1
            else
                l_limit = l_serverLimit
                if not l_serverTarget then
                    l_serverTarget = l_limit[1]
                end
                for i = 1, #l_limit do
                    if l_limit[i] == l_target then
                        l_value = i
                    end
                end
                ---设置下拉列表
                self.panel.dropBtn.gameObject:SetActiveEx(true)
                self.panel.dropBtn.DropDown:ClearOptions()
                self.panel.dropBtn:SetDropdownOptions(l_searchList)
                self.panel.dropBtn.DropDown.onValueChanged:AddListener(function(index)
                    self:OnDropDownClick(index + 1)
                end)
                self.panel.dropBtn.DropDown.value = l_value - 1
            end
            l_mgr.g_curTargetIndex = l_value
            local l_itemId = l_mgr.GetItemIdByTargetIndex(l_mgr.g_curTypeIndex, l_mgr.g_curSecTypeIndex,
                    l_mgr.g_curTargetIndex)
            l_targetItemId = l_itemId
        end

        local l_info = l_targetItemId == nil and {} or l_mgr.g_allItemInfo[l_targetItemId]
        l_info = l_info or {}
        l_count = #l_info
        if l_count == 0 then
            self.panel.buyPanel.gameObject:SetActiveEx(false)
            self.panel.noObject.gameObject:SetActiveEx(true)
            self.panel.PageText.LabText = "0/0"
            self.pageObj:SetActiveEx(false)
            return
        end

        --对物品进行排序
        self.panel.priceUpBtn.gameObject:SetActiveEx(l_isPriceUp)
        self.panel.priceDownBtn.gameObject:SetActiveEx(not l_isPriceUp)
        table.sort(l_info, function(i1, i2)
            if l_isPriceUp then
                return tonumber(i1.price) < tonumber(i2.price)
            else
                return tonumber(i2.price) < tonumber(i1.price)
            end
        end)
        self.pageObj:SetActiveEx(true)
        self.buyContentWrap.updateOneItem = function(obj, index)
            --self:HideBuyItem(index)
            local l_item = {}
            self:ExportBuyItem(l_item, obj)
            l_item.price:SetActiveEx(true)
            local l_targetInfo = l_info[index + 1]
            l_item.needPanle.gameObject:SetActiveEx(false)
            if l_isPriceUp and index == 0 then
                self:SetNeedNumTxt(l_targetInfo.uid, l_item)
            elseif not l_isPriceUp and index + 1 == #l_info then
                self:SetNeedNumTxt(l_targetInfo.uid, l_item)
            end
            local l_sellOut = (tonumber(l_targetInfo.count) < 1)
            l_item.sellCount.gameObject:SetActiveEx(false)
            l_item.sellOut.gameObject:SetActiveEx(false)
            l_item.itemCount.gameObject:SetActiveEx(true)
            l_item.itemCount.LabText = tostring(l_targetInfo.count)
            l_item.canvasGroup.alpha = 1
            if l_sellOut then
                l_item.sellOut.gameObject:SetActiveEx(true)
                l_item.canvasGroup.alpha = 0.6
            end
            local l_data = TableUtil.GetItemTable().GetRowByItemID(l_targetItemId)
            local l_name = l_data.ItemName
            local l_atlas = l_data.ItemAtlas
            local l_icon = l_data.ItemIcon
            l_item.name.LabText = l_name
            l_item.priceCount.LabText = tostring(l_targetInfo.price)
            l_item.icon:SetSprite(l_atlas, l_icon, true)
            local l_uid = l_targetInfo.uid
            l_item.selected:SetActiveEx(false)
            if l_curUUid ~= nil and l_curUUid == l_uid then
                if l_sellOut then
                    l_curUUid = nil
                    --return
                end
                l_item.selected:SetActiveEx(true)
                l_curCount = tonumber(l_targetInfo.count)
                l_curItemId = l_targetItemId
            end
            l_itemBtn[obj] = l_uid
            l_item.btn:AddClick(function()
                if l_sellOut then
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("STALL_SELL_OUT"))
                    return
                end

                if l_curUUid == l_uid then
                    return
                end

                for k, v in pairs(l_itemBtn) do
                    if v == l_curUUid then
                        k.transform:Find("Selected").gameObject:SetActiveEx(false)
                        break
                    end
                end

                l_curUUid = l_uid
                l_curCount = tonumber(l_targetInfo.count)
                l_curItemId = l_targetItemId
                l_item.selected:SetActiveEx(true)
            end)

            self:CreateBuyItem(obj, index, l_item.icon, l_targetInfo.count, l_targetItemId, function()
                ---@type ItemData
                local l_itemInfo = l_targetInfo.itemInfo
                MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithInfo(l_itemInfo, l_item.icon.gameObject.transform)
                if l_sellOut then
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("STALL_SELL_OUT"))
                    return
                end
                if l_curUUid == l_uid then
                    return
                end
                for k, v in pairs(l_itemBtn) do
                    if v == l_curUUid then
                        k.transform:Find("Selected").gameObject:SetActiveEx(false)
                        break
                    end
                end
                l_curUUid = l_uid
                l_curCount = tonumber(l_targetInfo.count)
                l_curItemId = l_targetItemId
                l_item.selected:SetActiveEx(true)
            end)
        end
    end
    for i, v in pairs(l_buyItemPrefab) do
        self:UninitTemplate(v)
    end
    l_buyItemPrefab = {}
    l_buyItemMap = {}
    -- 是否被服务器数据初始化
    if not next(l_mgr.g_allMarkInfo) then
        self.buyContentWrap:SetContentCount(0)
    else
        self.buyContentWrap:SetContentCount(l_count)
    end

    --设置上下指示箭头，防止第一次设置不会触发箭头的显示隐藏
    self.panel.buyDownArrow.gameObject:SetActiveEx(self.targetScrollRect.enabled and self.panel.buy.Scroll.content.rect.height > self.panel.buy.Scroll.viewport.rect.height)

    if not l_seconds then
        if self.seconds then
            self:ResetWrap()
        end
        self:InitPageAction(l_count)
    else
        self.pageObj:SetActiveEx(false)
        self.panel.PageText.LabText = "0/0"
        local l_go = self.panel.buyPanel.gameObject.transform:Find("buy").gameObject
        local l_listener = MUIEventListener.Get(l_go)
        l_listener.onDrag = function(go, data)
        end
        l_listener.onDragEnd = function(go, data)
        end
        self.panel.buyButtonUp:AddClick(function()
        end)
        self.panel.buyButtonDown:AddClick(function()
        end)
    end
    self:RefreshMoney()
    self.seconds = l_seconds
end

function StallHandler:CreateDisplayItem(obj, index, parent, id, func)
    local l_itemTargetIndex
    if l_buyItemMap[obj] then
        l_itemTargetIndex = l_buyItemMap[obj]
    else
        l_buyItemMap[obj] = index + 1
        l_itemTargetIndex = index + 1
    end
    if not l_buyItemPrefab[l_itemTargetIndex] then
        l_buyItemPrefab[l_itemTargetIndex] = self:NewTemplate("ItemTemplate", {
            TemplateParent = parent.transform.parent,
        })
    end
    if l_buyItemPrefab[l_itemTargetIndex] then
        l_buyItemPrefab[l_itemTargetIndex]:SetData({ ID = id, IsShowCount = false,
                                                     IsShowTips = true, IsShowRequireSign = true, RequireSignType = l_requireType })
    end
end

function StallHandler:CreateBuyItem(obj, index, parent, num, id, func)
    local l_itemTargetIndex
    if l_buyItemMap[obj] then
        l_itemTargetIndex = l_buyItemMap[obj]
    else
        l_buyItemMap[obj] = index + 1
        l_itemTargetIndex = index + 1
    end
    if not l_buyItemPrefab[l_itemTargetIndex] then
        l_buyItemPrefab[l_itemTargetIndex] = self:NewTemplate("ItemTemplate", {
            TemplateParent = parent.transform.parent,
        })
    end
    if l_buyItemPrefab[l_itemTargetIndex] then
        if num < 1 then
            l_buyItemPrefab[l_itemTargetIndex]:SetData({ ID = id, IsShowCount = true,
                                                         Count = num, IsShowTips = true, ButtonMethod = func })
        else
            l_buyItemPrefab[l_itemTargetIndex]:SetData({ ID = id, IsShowCount = true,
                                                         Count = num, IsShowTips = true, ButtonMethod = func, IsShowRequireSign = true, RequireSignType = l_requireType })
        end
    end
end

function StallHandler:HideBuyItem(index)
    if l_buyItemPrefab[index + 1] then
        l_buyItemPrefab[index + 1]:SetData({ IsActive = false })
    end
end

function StallHandler:InitPageAction(count)
    --self.forceUpdateState = true
    self.panel.buyButtonUp:AddClick(function()
    end)
    self.panel.buyButtonDown:AddClick(function()
    end)
    self.panel.PageText.LabText = "1/1"
    local l_go = self.panel.buyPanel.gameObject.transform:Find("buy").gameObject
    local l_listener = MUIEventListener.Get(l_go)
    l_listener.onDrag = function(go, data)
    end
    l_listener.onDragEnd = function(go, data)
    end
    if count <= 8 then
        return
    end
    local l_ten, l_one = math.modf(count / 8)
    if l_one > 0 then
        l_ten = l_ten + 1
    end
    --logGreen("===>>>count:"..tostring(count))
    self.allPage = l_ten
    --self.panel.PageText.LabText = "1/"..tostring(self.allPage)
    self.posInterverl = (self.buyContentWrap.itemSize.y) * 4
    local l_maxNum, l_temp = math.modf((count - 8) / 8)
    if l_temp > 0 then
        l_maxNum = l_maxNum + 1
    end
    self.posMax = self.buyContentWrap.itemSize.y * l_maxNum * 4

    local l_x, l_y = math.modf(self.buyContentWrap.gameObject.transform.localPosition.y / self.posInterverl)
    l_x = l_x + 1
    self.curPage = l_x
    if l_y * self.posInterverl > 30 then
        self.curPage = self.curPage + 1
    end
    self.panel.PageText.LabText = self.curPage .. "/" .. tostring(self.allPage)

    self.startPos = nil
    self.lastPoint = nil
    l_listener.onDrag = function(go, data)
        if self.tweenId > 0 then
            return
        end
        if self.startPos == nil then
            self.startPos = data.position.y
        end
    end
    l_listener.onDragEnd = function(go, data)
        if self.tweenId > 0 then
            return
        end
        if self.lastPoint == nil then
            self.lastPoint = data.position.y
        end
        self:UpdateContentWrapPos()
    end
    self.panel.buyButtonDown:AddClick(function()
        if self.tweenId > 0 then
            return
        end
        self.lastPoint = 1
        self.startPos = 0
        self:UpdateContentWrapPos()
    end)
    self.panel.buyButtonUp:AddClick(function()
        if self.tweenId > 0 then
            return
        end
        self.lastPoint = -1
        self.startPos = 0
        self:UpdateContentWrapPos()
    end)
end

function StallHandler:UpdateContentWrapPos()
    if self.startPos == nil or self.lastPoint == nil then
        self.startPos = nil
        self.lastPoint = nil
        return
    end
    local l_y = self.buyContentWrap.gameObject.transform.localPosition.y
    local l_targetY
    if self.lastPoint - self.startPos > 0 then
        if math.abs(l_y - self.posMax) < 30 then
            self.startPos = nil
            self.lastPoint = nil
            return
        end
        l_targetY = l_y + self.posInterverl
        l_targetY = math.min(self.posMax, l_targetY)
    else
        if math.abs(l_y - 0) < 30 then
            self.startPos = nil
            self.lastPoint = nil
            return
        end
        l_targetY = l_y - self.posInterverl
        l_targetY = math.max(0, l_targetY)
    end
    self.startPos = nil
    self.lastPoint = nil
    self.tweenId = MUITweenHelper.TweenPos(self.buyContentWrap.gameObject, Vector3.New(0, l_y, 0), Vector3.New(0, l_targetY, 0), 0.2,
            function()
                local l_x, l_y = math.modf(self.buyContentWrap.gameObject.transform.localPosition.y / self.posInterverl)
                l_x = l_x + 1
                self.curPage = l_x
                if l_y * self.posInterverl > 30 then
                    self.curPage = self.curPage + 1
                end

                self.panel.PageText.LabText = self.curPage .. "/" .. tostring(self.allPage)
                MUITweenHelper.KillTweenDeleteCallBack(self.tweenId)
                self.tweenId = 0
                self.buyContentWrap:ForceUpdate()
                self:ClearSelectedState()
            end)
end

function StallHandler:ClearSelectedState()
    if l_curUUid then
        for k, v in pairs(l_itemBtn) do
            if v == l_curUUid then
                k.transform:Find("Selected").gameObject:SetActiveEx(false)
                break
            end
        end
        l_curUUid = nil
    end
end

function StallHandler:OnDropDownClick(index)
    local l_id = nil
    if l_curTargetIndex == index then
        return
    end
    l_curTargetIndex = index
    --=.=GetItemIdByTargetIndex
    local l_result = l_mgr.g_tableInfo[l_mgr.g_curTypeIndex].secList[l_mgr.g_curSecTypeIndex]
    local l_limit = l_result.limitIndexList
    local l_secIndex = l_limit[l_curTargetIndex]
    for i, v in pairs(l_result.detailIndexList) do
        if l_secIndex == v.Index2 then
            l_id = v.ItemID
            break
        end
    end
    if l_id == nil then
        logError("[StallHandler]OnDropDownClick,id == nil")
        return
    end
    l_mgr.SendStallGetItemInfoReq(l_id)
end

function StallHandler:ExportBuyItem(item, go)
    --item = {}
    ---@module StallItemClone
    item.go = go
    item.icon = go.transform:Find("EquipIconBg/EquipIcon").gameObject:GetComponent("MLuaUICom")
    item.equipIconBg = go.transform:Find("EquipIconBg").gameObject:GetComponent("MLuaUICom")
    item.itemCount = go.transform:Find("EquipIconBg/ItemCount").gameObject:GetComponent("MLuaUICom")
    item.name = go.transform:Find("Name").gameObject:GetComponent("MLuaUICom")
    item.price = go.transform:Find("Price").gameObject
    item.priceCount = go.transform:Find("Price/PriceCount").gameObject:GetComponent("MLuaUICom")
    item.sellCount = go.transform:Find("AmountText").gameObject:GetComponent("MLuaUICom")
    item.selected = go.transform:Find("Selected").gameObject
    item.btn = go.transform:Find("ItemButton").gameObject:GetComponent("MLuaUICom")
    item.sellOut = go.transform:Find("SellOut").gameObject
    item.canvasGroup = go.transform:GetComponent("CanvasGroup")
    item.needPanle = go.transform:Find("NeedNum").gameObject
    item.needCount = go.transform:Find("NeedNum/Txt_NeedNum").gameObject:GetComponent("MLuaUICom")
end

---=============================================出售=================================================================

function StallHandler:InitSellItemPanel()
    l_sellItemSelected = nil
    self.sellForceUpdateState = false
    self.sellNextUpdate = nil
    local l_limitMgr = MgrMgr:GetMgr("LimitBuyMgr")
    local l_count = l_limitMgr.GetItemCanBuyCount(l_limitMgr.g_limitType.STALL_UP,1)
    local l_limit = l_limitMgr.GetItemLimitCount(l_limitMgr.g_limitType.STALL_UP,1)
    local l_haveCount = l_limit - l_count
    --self.panel.myCount.LabText = "("..tostring(l_haveCount).."/"..tostring(l_limit)..")"
    local l_tempSellStall = {}
    local l_typeBtn = self.panel.StallSellItemTemplate
    local l_parent = l_typeBtn.LuaUIGroup.gameObject.transform.parent
    local l_haveIndex = #l_sellStall
    --设置快速下架按钮
    local l_hasOverTime = false
    for _, v in pairs(l_mgr.g_sellItemInfo) do
        if v.leftTime <= 0 then
            l_hasOverTime = true
            break
        end
    end
    self.panel.fastDownBtn:SetActiveEx(l_hasOverTime)

    ---有物品的摊位
    for k, v in pairs(l_mgr.g_sellItemInfo) do
        local l_id = v.id
        local l_index = #l_tempSellStall + 1
        if l_index > l_haveIndex then
            l_tempSellStall[l_index] = {}
            l_tempSellStall[l_index].id = l_id
            l_tempSellStall[l_index].btn = self:NewTemplate("StallSellItemTemplate", {
                Data = v,
                TemplatePrefab = l_typeBtn.LuaUIGroup.gameObject,
                TemplateParent = l_parent,
                IsActive = true
            })
        else
            l_tempSellStall[l_index] = l_sellStall[l_index]
            l_tempSellStall[l_index].btn:SetData(v)
            l_tempSellStall[l_index].btn:SetGameObjectActive(true)
        end

    end
    self.panel.myCount.LabText = "（" .. tostring(table.ro_size(l_mgr.g_sellItemInfo)) .. "/" ..
            tostring(l_haveCount) .. "）"

    ---空位
    local l_remain = tonumber(l_haveCount) - #l_mgr.g_sellItemInfo
    if l_remain > 0 then
        for i = 1, l_remain do
            local l_index = #l_tempSellStall + 1
            if l_index > l_haveIndex then
                l_tempSellStall[l_index] = {}
                l_tempSellStall[l_index].id = 0
                l_tempSellStall[l_index].btn = self:NewTemplate("StallSellItemTemplate", {
                    Data = "empty",
                    TemplatePrefab = l_typeBtn.LuaUIGroup.gameObject,
                    TemplateParent = l_parent,
                    IsActive = true
                })
            else
                l_tempSellStall[l_index] = l_sellStall[l_index]
                l_tempSellStall[l_index].btn:SetData("empty")
                l_tempSellStall[l_index].btn:SetGameObjectActive(true)
            end
        end
    end
    if l_haveCount < l_limit then
        local l_index = #l_tempSellStall + 1
        if l_index > l_haveIndex then
            l_tempSellStall[l_index] = {}
            l_tempSellStall[l_index].id = 0
            l_tempSellStall[l_index].btn = self:NewTemplate("StallSellItemTemplate", {
                Data = "next",
                TemplatePrefab = l_typeBtn.LuaUIGroup.gameObject,
                TemplateParent = l_parent,
                IsActive = true
            })
        else
            l_tempSellStall[l_index] = l_sellStall[l_index]
            l_tempSellStall[l_index].btn:SetData("next")
            l_tempSellStall[l_index].btn:SetGameObjectActive(true)
        end
    end

    local l_i = #l_sellStall - #l_tempSellStall
    if l_i > 0 then
        for i = 1, l_i do
            local l_index = #l_tempSellStall + i
            l_tempSellStall[l_index] = l_sellStall[l_index]
            l_tempSellStall[l_index].btn:SetGameObjectActive(false)
        end
    end
    l_sellStall = l_tempSellStall
    l_tempSellStall = {}

    self.panel.getBtn:AddClick(function()
        local l_state = false
        for k, v in pairs(l_sellStall) do
            l_state = v.btn:GetMoneyState()
            if l_state then
                break
            end
        end
        if l_state then
            l_mgr.SendStallDrawMoneyReq(0)
            return
        end
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("STALL_NO_MONEY"))
    end)
    self:InitSellSelectPanel()
end

function StallHandler:InitSellSelectPanel()
    l_sellId = nil
    l_sellUid = nil
    l_sellNum = nil
    self.cansell = false
    local l_limitMgr = MgrMgr:GetMgr("LimitBuyMgr")
    local l_result = l_mgr.GetStallItems()
    local l_allCount = #l_result
    if l_allCount == 0 then
        self.panel.NotCreated.gameObject:SetActiveEx(true)
        self.panel.sellRightScroll.gameObject:SetActiveEx(false)
        self.cansell = false
    else
        self.cansell = true
        self.panel.NotCreated.gameObject:SetActiveEx(false)
        self.panel.sellRightScroll.gameObject:SetActiveEx(true)

        local l_targetCount = (l_allCount <= 24) and 24 or l_allCount
        local l_ten, l_one = math.modf(l_targetCount / 4)
        if l_one > 0 then
            l_targetCount = (l_ten + 1) * 4
        end

        self.sellRightScrollTemplatePool:ShowTemplates({ Datas = l_result, ShowMinCount = l_targetCount, IsToStartPosition = false })
        --处理已选中的情况
        if l_mgr.g_targetSellItemId then
            for i = 1, self.sellRightScrollTemplatePool:getDataCount() do
                local l_template = self.sellRightScrollTemplatePool:GetItem(i)
                if l_template and l_template.itemData.UID == l_mgr.g_targetSellItemId then
                    self:OnClickSellSelectItemEvent(l_template)
                    self:SetSellContentIndex(i)
                    break
                end
            end
        end
    end
    l_mgr.g_cansell = self.cansell == nil and false or self.cansell

    l_mgr.g_targetSellItemId = nil
end

function StallHandler:SetNeedNumTxt(id, l_item)
    local needNum = MgrMgr:GetMgr("RequireItemMgr").GetNeedItemCountByID(id)
    local haveNum = Data.BagModel:GetBagItemCountByTid(tonumber(id))
    if needNum > 0 then
        l_item.needPanle.gameObject:SetActiveEx(true)
        l_item.needCount.LabText = StringEx.Format("{0}/{1}", tostring(haveNum), tostring(needNum))
        if haveNum >= needNum then
            l_item.needCount.LabColor = RoColor.Hex2Color(RoColor.WordColor.Green[1])
        else
            l_item.needCount.LabColor = RoColor.Hex2Color(RoColor.WordColor.Red[1])
        end
    end
end

function StallHandler:SetSellContentIndex(index)
    self.sellRightScrollTemplatePool:ScrollToCell(index, 2000)
end

--lua custom scripts end

return StallHandler
