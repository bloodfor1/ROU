--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseHandler"
require "UI/Panel/TradePanel"
require "UI/UIBaseCtrl"
require "UI.Template.TradeParent"
require "UI.Template.TradeSon"
--require "PriceFunction"
require "Data.Model.BagModel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

SCROLLRECT_UPDATE_COUNT = 3

--lua class define
local super = UI.UIBaseHandler
TradeHandler = class("TradeHandler", super)
--lua class define end

--lua functions
function TradeHandler:ctor()

    super.ctor(self, HandlerNames.Trade, 0)

end --func end
--next--
function TradeHandler:Init()

    self.panel = UI.TradePanel.Bind(self)
    super.Init(self)
    self:InitPanel()

end --func end
--next--
function TradeHandler:Uninit()

    self:UnInitPanel()

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function TradeHandler:OnActive()
    self.tradeMgr.SendGetTradeInfoReq()
    self:UpdateBuyItemPanel(false, true)--重刷出售列表

end --func end
--next--
function TradeHandler:OnDeActive()


end --func end
--next--
function TradeHandler:Update()

    if self.buyForceUpdateState and self.contentWrap then
        self.contentWrap:ForceUpdate()
        if self.buyNextUpdate == nil then
            self.buyNextUpdate = SCROLLRECT_UPDATE_COUNT
        end
        self.buyNextUpdate = self.buyNextUpdate - 1
        if self.buyNextUpdate == 0 then
            self.buyNextUpdate = nil
            self.buyForceUpdateState = false
            self.panel.buyScrollView.Scroll.enabled = true
        end
    end
    if self.sellForceUpdateState and self.sellContentWrap then
        self.sellContentWrap:ForceUpdate()
        if self.sellNextUpdate == nil then
            self.sellNextUpdate = SCROLLRECT_UPDATE_COUNT
        end
        self.sellNextUpdate = self.sellNextUpdate - 1
        if self.sellNextUpdate == 0 then
            self.sellNextUpdate = nil
            self.sellForceUpdateState = false
            self.sellScrollRect.enabled = true
        end
    end

    -- 刷新库存时间
    if self.isRefreshStockTime then
        local l_refreshTime = MGlobalConfig:GetSequenceOrVectorInt("InventoryRefreshTime")
        local l_timeLimit = {}
        for i = 0, l_refreshTime.Length - 1 do
            local l_hour = math.floor(l_refreshTime[i] / 100)
            local l_minute = l_refreshTime[i] % 100
            local l_second = l_hour * 3600 + l_minute * 60
            table.insert(l_timeLimit, l_second)
        end
        if #l_timeLimit > 0 then
            table.insert(l_timeLimit, l_timeLimit[1] + 24 * 3600)
        end
        -- 寻找距离最近的一次刷新时间
        local l_curTime = Common.TimeMgr.GetNowTimestamp() - Common.TimeMgr.GetDayTimestamp()
        local l_leftTime = 0
        -- 距离上次刷新已经过去的时间
        local l_pastTime = 10000
        for i, limit in ipairs(l_timeLimit) do
            if l_curTime < limit then
                l_leftTime = limit - l_curTime
                if i > 1 then
                    l_pastTime = l_curTime - l_timeLimit[i - 1]
                end
                break
            end
        end
        if l_pastTime < MGlobalConfig:GetSequenceOrVectorInt("ForbidBuyTime2")[1] then
            self.panel.RefreshTime.LabText = Lang("TRADE_INVENTORY_REFRESH", Common.TimeMgr.GetSecondToHMS(MGlobalConfig:GetSequenceOrVectorInt("ForbidBuyTime2")[1] - l_pastTime))
        else
            self.panel.RefreshTime.LabText = Lang("TRADE_STOCK_REFRESH_TIME", Common.TimeMgr.GetSecondToHMS(l_leftTime))
        end
    end

end --func end

--next--
function TradeHandler:BindEvents()

    self:AddEvent()

end --func end

--next--
--lua functions end

--lua custom scripts
local l_limitMgr = MgrMgr:GetMgr("LimitBuyMgr")

local l_sellType = l_limitMgr.g_limitType.TRADE_SELL  -- 出售类型
local l_buyType = l_limitMgr.g_limitType.TRADE_BUY    -- 购买类型

local l_noticeSellType = l_limitMgr.g_limitType.TRADE_SELL_LIMIT     -- 预售出售类型
local l_noticeBuyType = l_limitMgr.g_limitType.TRADE_BUY_LIMIT       -- 预售购买类型

local l_curMainBtn = nil           -- 当前选中的大分类按钮
local l_curSonBtn = nil            -- 当前选中的子分类按钮
local l_curItem = nil              -- 当前选中的物品
local l_itemTable = {}             -- 当前占据prefab实例的item
local l_curItemTable = {}          -- 记录当前展示id集合

local l_scrollViewInit = true      -- 购买滑动列表是否初始化

local l_sellScrollViewInit = true  -- 出售滑动列表是否初始化
local l_curSellItemTable = {}      -- 当前出售集合
local l_curSellItem = nil          -- 当前选中的出售item

local l_item = {}
local l_itemIndex = {}
local l_info = {}     ---当前购买item信息
local l_infoIndex = {} ---info索引

local l_sellItemPrefab = {}
local l_sellItemMap = {}

local l_buyItemPrefab = {}   ---购买item集合
local l_buyItemMap = {}      ---购买item对应

local l_pageNum = 10  ---一页显示item数量

---初始化整个面板;
function TradeHandler:InitPanel()

    ---变量初始化;
    l_curMainBtn = nil
    l_curSonBtn = nil
    l_curItem = nil
    l_scrollViewInit = true
    l_sellScrollViewInit = true

    l_itemTable = {}
    l_curItemTable = {}
    l_info = {}
    l_infoIndex = {}

    l_curSellItemTable = {}
    l_curSellItem = nil
    l_item = {}
    l_itemIndex = {}

    -- 保存一个对商会数据的引用
    self.tradeData = DataMgr:GetData("TradeData")
    self.tradeMgr = MgrMgr:GetMgr("TradeMgr")
    --左侧购买页标签
    self.buyTabItems = {}

    -- 刷新计时器
    self.refreshTimer = nil

    self.buyForceUpdateState = false
    self.buyNextUpdate = nil
    self.sellForceUpdateState = false
    self.sellNextUpdate = nil

    self.buyPanelInit = false

    self.onlyShowInStock = false
    self.allPage = 1
    self.curPage = 1
    self.filterTab = {}
    self.filter = nil

    self.buyPrice = 0
    self.inFollow = false
    self.removeID = {}

    self.panel.BuyOffBtn:AddClick(function()
        self:SelectPanel(true)
    end)
    self.panel.SellOffBtn:AddClick(function()
        self:SelectPanel(false)
    end)
    self.panel.tipsBtn.gameObject:SetActiveEx(true)
    self.panel.tipsBtn:AddClick(function()
        local l_content = Common.Utils.Lang("TRADE_NOTICE_TIPS")
        l_content = MgrMgr:GetMgr("RichTextFormatMgr").FormatRichTextContent(l_content)
        MgrMgr:GetMgr("TipsMgr").ShowExplainPanelTips({
            content = l_content,
            alignment = UnityEngine.TextAnchor.MiddleRight,
            pos = {
                x = 360,
                y = 150,
            },
            width = 400,
        })
    end)

    self.panel.BuyPanel.gameObject:SetActiveEx(true)
    self.panel.SellPanel.gameObject:SetActiveEx(true)
    self.sellScrollRect = self.panel.SellPanel.gameObject.transform:Find("Scroll View"):GetComponent("ScrollRect")
    self.checkMark = self.panel.filterBtn.gameObject.transform:Find("Checkmark").gameObject

    -- 心跳协议
    if self.beatTimer then
        self:StopUITimer(self.beatTimer)
        self.beatTimer = nil
    end
    self.beatTimer = self:NewUITimer(function()
        self.tradeMgr.SendTradeKeepAliveNotify()
    end, 20, -1, true)
    self.beatTimer:Start()

    self:SelectPanel(self.tradeMgr.IsBuyPanel)
end

function TradeHandler:UnInitPanel()
    if self.beatTimer then
        self:StopUITimer(self.beatTimer)
        self.beatTimer = nil
    end
    if self.refreshTimer then
        self:StopUITimer(self.refreshTimer)
        self.refreshTimer = nil
    end
    for k, v in pairs(self.buyTabItems) do
        ---- 销毁模板;
        --MResLoader:DestroyObj(v.sonTarget)
        self:UninitTemplate(v.target)
    end
    self.buyTabItems = {}
    --记录本次打开的信息
    if l_curMainBtn then
        self.tradeMgr.LastMainId = l_curMainBtn.info.info.ClassificationID
    end
    if l_curSonBtn then
        self.tradeMgr.LastSonId = l_curSonBtn.info.info.ClassificationID
    end
    if l_curItem then
        self.tradeMgr.LastItemId = l_curItem.tableInfo.CommoditID
    end

    for i, v in pairs(l_sellItemPrefab) do
        self:UninitTemplate(v)
    end
    l_sellItemPrefab = {}
    l_sellItemMap = {}
    for i, v in pairs(l_buyItemPrefab) do
        self:UninitTemplate(v)
    end
    l_buyItemPrefab = {}
    l_buyItemMap = {}
end

function TradeHandler:AddEvent()
    ----注册事件;
    local l_currencyMgr = MgrMgr:GetMgr("CurrencyMgr")
    self:BindEvent(l_currencyMgr.EventDispatcher, l_currencyMgr.EXCHANGE_MONEY_SUCCESS, function()
        self:OnExchangeMoneySuccessEvent()
    end)
    self:BindEvent(self.tradeMgr.EventDispatcher, self.tradeMgr.ON_TYPE_CLICK, function(self, id)
        self:SelectItemType(id)
    end)
    self:BindEvent(self.tradeMgr.EventDispatcher, self.tradeMgr.ON_ITEM_INFO_UPDATE, function(self, id)
        self:OnItemInfoUpdateEvent(id)
    end)
    self:BindEvent(self.tradeMgr.EventDispatcher, self.tradeMgr.ON_ITEM_INFO_DELETE, function(self, id)
        self:OnItemInfoDelete(id)
    end)
    self:BindEvent(self.tradeMgr.EventDispatcher, self.tradeMgr.ON_BAG_ITEM_CHANGE, function(self, id, count)
        self:OnBagItemChangeEvent(id, count)
    end)
    self:BindEvent(l_limitMgr.EventDispatcher, l_limitMgr.LIMIT_BUY_COUNT_UPDATE, function(self, type, id)
        self:OnBuyCountUpdateEvent(type, id)
    end)
    self:BindEvent(self.tradeMgr.EventDispatcher, self.tradeMgr.FORCE_TO_BUY, function()
        self:Force2Buy()
    end)
    self:BindEvent(self.tradeMgr.EventDispatcher, self.tradeMgr.FORCE_TO_SELL, function()
        self:OnForce2SellEvent()
    end)
    self:BindEvent(self.tradeMgr.EventDispatcher, self.tradeMgr.REFRASH_TRADE_PANEL, function(self)
        self:UpdateBuyItemPanel(false, true)
    end)
    self:BindEvent(self.tradeMgr.EventDispatcher, self.tradeMgr.ITEM_FOLLOW_CHANGED, function(self, id, isFollow)
        self:OnFollowChanged(id, isFollow)
    end)

    self:BindEvent(Data.PlayerInfoModel.COINCHANGE, Data.onDataChange, function()
        self.panel.SellPriceCountLab.LabText = tostring(MPlayerInfo.Coin102)
    end)
end

function TradeHandler:OnExchangeMoneySuccessEvent()
    self:RefreshRightBaseInfo(false)
    if not self.DirectBuy then
        return
    end
    local l_const = math.modf(tonumber(self.buyPrice) + 0.5)
    local l_number = self.panel.BuyCount.InputNumber:GetValue()
    local l_isNotice = l_curItem.netInfo.isNotice
    self.tradeMgr.SendTradeBuyItemReq(l_isNotice, l_curItem.tableInfo.CommoditID,
            MLuaCommonHelper.Long2Int(l_number), false)
end

function TradeHandler:OnItemInfoUpdateEvent(id)
    if self.buyPanelInit then
        --更新网络信息
        if table.ro_contains(l_infoIndex, id) then
            local l_index = l_infoIndex[id]
            l_info[l_index].netInfo = self.tradeData.GetTradeInfo(id)
        end
        --if self.panel.BuyPanel.gameObject.activeSelf then
        --更新显示ui
        if table.ro_contains(l_curItemTable, id) then
            ---item id table
            for k, v in pairs(l_itemTable) do
                if v.itemId == id then
                    local l_info = v.info
                    l_info.netInfo = self.tradeData.GetTradeInfo(id)
                    self:UpdateItem(k, l_info)
                    break
                end
            end
        end
        if l_curItem and l_curItem.tableInfo.CommoditID == id then
            --更新基础信息显示
            self:RefreshRightBaseInfo(false)
        end
        --end
        --更新网络信息
        if l_itemIndex[id] then
            local l_count = #l_itemIndex[id]
            if l_count > 0 then
                for i = 1, l_count do
                    local l_index = l_itemIndex[id][i]
                    local l_temp = self.tradeMgr.GetSellCountLimitInfo(id)
                    if l_temp then
                        l_item[l_index].sellCount = l_temp.count
                    else
                        l_item[l_index].sellCount = 0
                        logError(StringEx.Format("[TradeHandler]can not find the limit info,id:{0}!", tostring(id)))
                    end
                    l_item[l_index].netInfo = self.tradeData.GetTradeInfo(id)
                end
            end
        end
    end
    if not self.panel.BuyPanel.gameObject.activeSelf then
        ---改成uid这里不需要! 改更新显示ui
        for k, v in pairs(l_curSellItemTable) do
            if v.itemId == id then
                local l_info = l_item[v.index]
                self:UpdateSellItem(k, l_info)
            end
        end
        --更新基础信息显示
        self:UpdateSellBaseInfo(false)---刷新价格
    end
end

function TradeHandler:OnItemInfoDelete(id)
    if self.panel.BuyPanel.gameObject.activeSelf then
        --XXX:暂时没有删除物品的需求
        if table.ro_contains(l_curItemTable, id) then
            --self:InitBuyPanel()
        end
    else
        self:InitSellPanel()
    end
end

function TradeHandler:OnBagItemChangeEvent(id, count)
    --刷新网络信息
    local l_curCount = Data.BagModel:GetBagItemCountByTid(id)
    if 0 >= l_curCount then
        self:InitSellPanel()
        return
    end

    if l_curSellItem == nil or l_curSellItem.id ~= id then
        self:InitSellPanel()
        return
    end

    local l_targetItem = l_item[l_curSellItem.index]
    l_targetItem.havaCount = l_targetItem.havaCount - count
    if l_targetItem.havaCount < 1 then
        self:InitSellPanel()
        return
    end
    --刷新ui显示
    if not self.panel.BuyPanel.gameObject.activeSelf then
        ---改成uid这里不需要改！
        for k, v in pairs(l_curSellItemTable) do
            if v.itemId == id then
                local l_info = l_item[v.index]
                local l_temp = self.tradeMgr.GetSellCountLimitInfo(id)
                if l_temp then
                    l_info.sellCount = l_temp.count---刷新点击
                else
                    l_info.sellCount = 0
                    logError(StringEx.Format("[TradeHandler]can not find the limit info,id:{0}!", tostring(id)))
                end
                l_info.netInfo = self.tradeData.GetTradeInfo(id) ---刷新item以便刷新价格
                self:UpdateSellItem(k, l_info)
                ---这里不break是因为存在堆叠;
            end
        end
        self:UpdateSellBaseInfo(false)
    end
end

function TradeHandler:OnBuyCountUpdateEvent(type, id)
    if self.panel == nil then
        return
    end
    ---这里指刷新显示,网络信息在ON_ITEM_INFO_UPDATE事件中会有刷新,此处无bug
    if (type == tostring(l_buyType) or type == tostring(l_noticeBuyType)) and l_curItem then
        local l_target = l_curItem
        local l_id = l_target.tableInfo.CommoditID
        if id == tostring(l_id) then
            self:RefreshRightBaseInfo(false)
        end
        return
    end
    if (type == tostring(l_sellType) or type == tostring(l_noticeSellType)) then
        self:UpdateSellBaseInfo(false)
    end
end

function TradeHandler:OnFollowChanged(id, isFollow)
    if self.inFollow then
        if l_curItem and l_curItem.tableInfo.CommoditID == id then
            l_curItem = nil
        end
        if self.removeID then
            if not table.ro_contains(self.removeID, id) then
                table.insert(self.removeID, id)
            end
        end
        self:UpdateBuyItemPanel(false, false)
    end
    --更新关注状态
    self:RefreshRightBaseInfo(false)
end

function TradeHandler:OnForce2SellEvent()
    --TODO
    if self.tradeMgr.g_noticeDisable and l_curSellItem then
        local l_number = self.panel.SellCountTarget.InputNumber:GetValue()
        self.tradeMgr.SendTradeSellItemReq(l_curSellItem.info.tableInfo.CommoditID, l_curSellItem.uid,
                MLuaCommonHelper.Long2Int(l_number), true)
        return
    end
    self:Force2Sell()
end

---页签切换;
function TradeHandler:SelectPanel(isBuy)
    self.panel.BuyOffBtn.gameObject:SetActiveEx(not isBuy)
    self.panel.BuyOnBtn.gameObject:SetActiveEx(isBuy)
    self.panel.SellOffBtn.gameObject:SetActiveEx(isBuy)
    self.panel.SellOnBtn.gameObject:SetActiveEx(not isBuy)
    self.panel.BuyPanel.gameObject:SetActiveEx(isBuy)
    self.panel.SellPanel.gameObject:SetActiveEx(not isBuy)
    if not isBuy then
        self:InitSellPanel()      ---初始化出售面板
    else
        if not self.buyPanelInit then
            self:InitBuyPanel()       ---初始化购买面板
        end
        self:RefreshRightBaseInfo(true)
    end
end

---=============================================购买面板=================================================================

-- 初始化购买面板;
function TradeHandler:InitBuyPanel()
    --self.panel.HuoquBtn.gameObject:SetActiveEx(false)
    self.panel.BuyCount.InputNumber.MaxValue = 1
    self.panel.BuyCount.InputNumber:SetValue(1)
    --超过最大值弹提醒
    self.buyPerPurchaseLimit = self.buyPerPurchaseLimit or -1
    self.panel.BuyCount.InputNumber.OnMaxValueMethod = function()
        if MLuaCommonHelper.Long2Int(self.panel.BuyCount.InputNumber.MaxValue) == self.buyPerPurchaseLimit then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("TRADE_BUY_EXCEED_MAX", self.buyPerPurchaseLimit))
        end
    end
    self.buyForceUpdateState = false
    self.buyNextUpdate = nil
    local l_parent = self.panel.TradeParent
    local l_son = self.panel.TradeSon
    local l_p1 = l_parent.LuaUIGroup.gameObject.transform.parent
    local l_sonParentPanel = self.panel.SonPanel.gameObject.transform.parent.gameObject
    self.checkMark:SetActiveEx(self.onlyShowInStock)
    self.panel.filterBtn:AddClick(function()
        l_curItem = nil
        self.onlyShowInStock = not self.onlyShowInStock
        self.checkMark:SetActiveEx(self.onlyShowInStock)
        self:UpdateBuyItemPanel(false, true)
    end)

    if not self.buyScrollInfo then
        local l_viewHeight = self.panel.buyScrollView.RectTransform.rect.height
        local l_childCellHeight = self.panel.TradeBuyItem.RectTransform.rect.height
        self.buyScrollInfo = {}
        self.buyScrollInfo.contentRectTransform = self.panel.contentPanel.RectTransform
        self.buyScrollInfo.upY = l_childCellHeight
        self.buyScrollInfo.downY = l_viewHeight - l_childCellHeight
    end

    --滑动区滑到顶部或者底部实现自动翻页
    self.panel.buyScrollView:GetComponent("ScrollRectWithCallback").OnEndDragCallback = function()
        local l_rect = self.buyScrollInfo.contentRectTransform.rect
        local l_anchoredPosition = self.buyScrollInfo.contentRectTransform.anchoredPosition
        local l_downY = math.min(self.buyScrollInfo.downY, l_rect.height - self.buyScrollInfo.upY)
        if -l_anchoredPosition.y > self.buyScrollInfo.upY then
            --向上翻页
            self:HandleBuyButtonUpClicked()
        elseif -l_anchoredPosition.y + l_rect.height < l_downY then
            --向下翻页
            self:HandleBuyButtonDownClicked()
        end
    end


    --要求实时刷新
    for _, v in pairs(self.buyTabItems) do
        if v.target then
            self:UninitTemplate(v.target)
        end
    end
    self.buyTabItems = {}
    local l_tempMainBtn = nil
    local l_tempSonBtn = nil

    local l_noticeInfo = {}
    l_noticeInfo.info = {}
    l_noticeInfo.info.ClassificationID = self.tradeMgr.PreBuyClassId
    l_noticeInfo.info.ClassificationName = Common.Utils.Lang("TRADE_PRE_BUY_DES")
    l_noticeInfo.sonType = {}
    l_noticeInfo.item = {}
    l_noticeInfo.info.ShowRadio = true
    self.buyTabItems[self.tradeMgr.PreBuyClassId] = {}
    -- 关注/预购按钮
    self.buyTabItems[self.tradeMgr.PreBuyClassId].target = self:NewTemplate("TradeParent", {
        Data = l_noticeInfo,
        TemplatePrefab = l_parent.LuaUIGroup.gameObject,
        TemplateParent = l_p1,
        IsActive = true
    })
    self.buyTabItems[self.tradeMgr.PreBuyClassId].info = l_noticeInfo
    --TODO:这里可以优化下;
    local l_sonPanel = self:CloneObj(self.panel.SonPanel.gameObject)
    MLuaCommonHelper.SetParent(l_sonPanel, l_sonParentPanel)
    l_sonPanel:SetLocalScaleOne()
    l_sonPanel.gameObject:SetActiveEx(false)
    self.buyTabItems[self.tradeMgr.PreBuyClassId].sonTarget = l_sonPanel

    --获取分类相关信息
    local l_classInfo = self.tradeData.GetClassInfo()
    for i = 1, #l_classInfo do
        local l_mainClassId = l_classInfo[i].id
        if self.tradeData.IsClassOpen(l_mainClassId) then
            local l_itemClassInfo = self.tradeData.GetItemClassInfoByClassId(l_mainClassId)
            self.buyTabItems[l_mainClassId] = {}
            -- 主分类
            self.buyTabItems[l_mainClassId].target = self:NewTemplate("TradeParent", {
                Data = l_itemClassInfo,
                TemplatePrefab = l_parent.LuaUIGroup.gameObject,
                TemplateParent = l_p1,
                IsActive = true
            })
            self.buyTabItems[l_mainClassId].info = l_itemClassInfo

            local l_go = self:CloneObj(self.panel.SonPanel.gameObject)
            MLuaCommonHelper.SetParent(l_go, l_sonParentPanel)
            l_go:SetLocalScaleOne()
            l_go.gameObject:SetActiveEx(false)

            -- 子分类
            self.buyTabItems[l_mainClassId].sonTarget = l_go

            -- 子分类信息
            local l_sonClassInfo = l_classInfo[i].son
            for j = 1, #l_sonClassInfo do
                local l_sonId = l_sonClassInfo[j]
                if self.tradeData.IsClassOpen(l_sonId) then
                    local l_sonInfo = l_itemClassInfo.sonType[l_sonId]
                    self.buyTabItems[l_sonId] = {}
                    self.buyTabItems[l_sonId].target = self:NewTemplate("TradeSon", {
                        Data = l_sonInfo,
                        TemplatePrefab = l_son.LuaUIGroup.gameObject,
                        TemplateParent = l_go.transform,
                        IsActive = true
                    })
                    self.buyTabItems[l_sonId].info = l_sonInfo
                end
            end
        end

        -- 默认选中分类
        if not self.tradeMgr.LastMainId then
            local l_mainBuyTabItem = self.buyTabItems[l_mainClassId]
            if l_mainBuyTabItem and l_mainBuyTabItem.info.sonType and table.ro_size(l_mainBuyTabItem.info.sonType) >= 1  then
                self.tradeMgr.LastMainId = l_mainClassId
                self.tradeMgr.LastSonId = l_mainBuyTabItem.info.sonTypeList[1]
            end
        end
    end

    if self.tradeMgr.LastMainId then
        l_curMainBtn = self.buyTabItems[self.tradeMgr.LastMainId]
    end
    if self.tradeMgr.SearchTradeMainId then
        l_tempMainBtn = self.buyTabItems[self.tradeMgr.SearchTradeMainId]
    end

    if self.tradeMgr.LastSonId then
        l_curSonBtn = self.buyTabItems[self.tradeMgr.LastSonId]
    end
    if self.tradeMgr.SearchTradeSonId then
        l_tempSonBtn = self.buyTabItems[self.tradeMgr.SearchTradeSonId]
    end

    if l_tempMainBtn then
        l_curMainBtn = l_tempMainBtn
        l_curSonBtn = l_tempSonBtn
        self.tradeMgr.LastItemId = self.tradeMgr.SearchTradeItemId
        self.tradeMgr.SearchTradeItemId = nil
    end

    self.buyPanelInit = true

    if l_curMainBtn then
        l_curMainBtn.target:SetState(true)
        if table.ro_size(l_curMainBtn.info.sonType) < 1 then
            l_curSonBtn = nil
        end
        if l_curSonBtn then
            l_curSonBtn.target:SetState(true)
            l_curMainBtn.sonTarget:SetActiveEx(true)
        end
        self:UpdateBuyItemPanel(true, true)
    end

    self.tradeMgr.TradeFirstIn = false

end

---选中某个分类
---(.target/.info/.sonTarget)
---(.info/.sonType/.item)
---(.target/.info)
---(.info/.item)
function TradeHandler:SelectItemType(id)
    local l_main = false
    local l_target = nil
    if self.buyTabItems[id] then
        l_target = self.buyTabItems[id]
        if l_target.sonTarget then
            ---
            l_main = true
        end
    end
    -- 是否是主分类
    if l_main then
        if l_curMainBtn then
            if l_curMainBtn.info.info.ClassificationID == id then
                local l_child = l_curMainBtn.target:GetChild()
                if not l_child then
                    return
                end
                local l_state = l_curMainBtn.target:GetState()
                l_curMainBtn.target:SetState(not l_state)
                l_curMainBtn.sonTarget:SetActiveEx(not l_state)
                self:UpdateUi()
                return
            else
                l_curMainBtn.target:SetState(false)
                l_curMainBtn.sonTarget:SetActiveEx(false)
                l_curMainBtn = l_target
                l_curMainBtn.target:SetState(true)
            end

            if table.ro_size(l_curMainBtn.info.sonType) < 1 then
                --- 判断是否需要刷新界面,不存在子类型需要刷新
                --刷新并关掉之前选中子类
                if l_curSonBtn then
                    l_curSonBtn.target:SetState(false)
                end
                l_curSonBtn = nil
                l_curItem = nil
                --刷新
                self.curPage = 1
                self.removeID = {}
                self.filterTab = {}
                self.filter = nil
                self.lastFilter = nil
                self:UpdateBuyItemPanel(false, true)
            else
                l_curMainBtn.sonTarget:SetActiveEx(true)
                -- 调整父分类按钮在布局中的位置
                local l_mainRect = l_curMainBtn.target:GetRectTransform()
                local l_mainParentRect = l_mainRect.parent:GetComponent("RectTransform")
                LayoutRebuilder.ForceRebuildLayoutImmediate(l_mainParentRect)
                local l_y = -l_mainRect.anchoredPosition.y - l_mainRect.rect.height / 2
                if l_mainParentRect.anchoredPosition.y > l_y then
                    l_mainParentRect.anchoredPosition = Vector3.New(l_mainParentRect.anchoredPosition.x, l_y, l_mainParentRect.anchoredPosition.z)
                end
            end
        end
    else
        if l_curSonBtn then
            if l_curSonBtn.info.info.ClassificationID == id then
                return
            end
            l_curSonBtn.target:SetState(false)
        end
        l_curSonBtn = l_target
        l_curSonBtn.target:SetState(true)
        l_curItem = nil
        --刷新
        self.curPage = 1
        self.removeID = {}
        self.filterTab = {}
        if self.lastFilter then
            self.filter = self.lastFilter.name
        else
            self.filter = nil
        end
        self:UpdateBuyItemPanel(false, true)
    end
    self:UpdateUi()
end

function TradeHandler:UpdateUi()
    ---刷下按钮滑动列表的显示
    local l_root = self.panel.BuyPanel.gameObject.transform:Find("BtnScrollRect/Viewport/Content").gameObject
    if self.panel.PanelRef then
        LayoutRebuilder.ForceRebuildLayoutImmediate(l_root.transform)
    end
    l_root:SetActiveEx(true)
end

function TradeHandler:HandleBuyButtonUpClicked()
    if self.curPage == 1 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("TRADE_NOT_MORE"))
        return
    end
    self.curPage = self.curPage - 1
    self:UpdateBuyItemPanel(false, true)
end

function TradeHandler:HandleBuyButtonDownClicked()
    if self.curPage == self.allPage then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("TRADE_NOT_MORE"))
        return
    end
    self.curPage = self.curPage + 1
    self:UpdateBuyItemPanel(false, true)
end

---刷新item列表 target:是否刷新显示目标,刷新则先把l_curItem置nil,l_curItem==nil,target ==false,刷新
---(.target/.info/.sonTarget)
---(.info/.sonType/.item)
---(.target/.info)
---(.info/.item)
function TradeHandler:UpdateBuyItemPanel(target, updateScrollPos)
    if not self.buyPanelInit then
        return
    end
    if self.refreshTimer then
        self:StopUITimer(self.refreshTimer)
        self.refreshTimer = nil
    end
    if self.tradeMgr.NextRefreshTime > 0 then
        self.refreshTimer = self:NewUITimer(function()
            NextRefreshTime = -1
            if self.refreshTimer then
                self:StopUITimer(self.refreshTimer)
                self.refreshTimer = nil
            end
            --刷新
            self.tradeMgr.SendGetTradeInfoReq()
        end, NextRefreshTime)
        self.refreshTimer:Start()
    end

    --l_curItem = nil
    self.contentWrap = self.panel.contentPanel.gameObject:GetComponent("UIWrapContent")
    local l_target = l_curSonBtn
    if l_target == nil then
        l_target = l_curMainBtn
    end
    if l_target == nil then
        return
    end
    if self.curBtn == nil or self.curBtn ~= l_target then
        local l_state = l_target.info.info.ShowRadio
        --self.onlyShowInStock = false
        self.checkMark:SetActiveEx(self.onlyShowInStock)
        self.panel.filterBtn:SetActiveEx(l_state)
        self.curBtn = l_target
    end
    self.panel.buyScrollView.gameObject:SetActiveEx(true)
    self.panel.OpenNotice.gameObject:SetActiveEx(false)
    self.panel.BuyItemEmpty:SetActiveEx(false)
    self:SetTradePabelState(true)
    local l_openTarget = self.tradeData.GetOpenState(l_target.info.info.ClassificationID)
    --Common.Functions.DumpTable(self.tradeMgr.g_OpenIndex, "<var>", 6)
    if l_openTarget == nil then
        self.panel.buyScrollView.gameObject:SetActiveEx(false)
        self.panel.OpenNotice.gameObject:SetActiveEx(true)
        self:SetTradePabelState(false)
        self.panel.OpenNoticeText.LabText = Common.Utils.Lang("NotOpened")
        return
    end
    if l_openTarget and (not l_openTarget.isOpen) then
        self.panel.buyScrollView.gameObject:SetActiveEx(false)
        self.panel.OpenNotice.gameObject:SetActiveEx(true)
        self:SetTradePabelState(false)
        self.panel.OpenNoticeText.LabText = StringEx.Format(Common.Utils.Lang("TRADE_WAIT_OPEN"), l_openTarget.openDes)
        return
    end
    if l_scrollViewInit then
        self.contentWrap:InitContent()
        l_scrollViewInit = false
    end
    l_info = {}
    l_curItemTable = {} ---item id table
    l_infoIndex = {}
    l_itemTable = {}
    self.inFollow = false
    if l_target.info.info.ClassificationID == self.tradeMgr.PreBuyClassId then
        self.inFollow = true
        local l_preBuyList = self.tradeData.GetPreBuyList()
        for i = 1, #l_preBuyList do
            local l_id = l_preBuyList[i].id
            table.insert(l_curItemTable, l_id)
            local l_targetTradeInfo = self.tradeData.GetTradeInfo(l_id)
            local l_filter = l_preBuyList[i].table.Fliter
            if l_targetTradeInfo and
                    ((not self.onlyShowInStock) and true or (l_targetTradeInfo.stockNum > LongZero or l_target.info.info.ShowRadio == false)) and
                    (not table.ro_contains(self.removeID, l_id) or l_targetTradeInfo.preBuyNum > LongZero)
            then
                local l_index = #l_info + 1
                l_info[l_index] = {}
                l_info[l_index].tableInfo = l_preBuyList[i].table ----CommoditTable
                l_info[l_index].netInfo = l_targetTradeInfo
                l_infoIndex[l_id] = l_index
            end
        end
        table.sort(l_info, function(x, y)
            return x.tableInfo.SortID < y.tableInfo.SortID
        end)
        if #l_info > 0 then
            local l_preInfo = {}
            local l_followInfo = {}
            for i = 1, #l_info do
                if l_info[i].netInfo.preBuyNum > LongZero then
                    l_preInfo[#l_preInfo + 1] = l_info[i]
                else
                    l_followInfo[#l_followInfo + 1] = l_info[i]
                end
            end
            if #l_followInfo > 0 then
                for i = 1, #l_followInfo do
                    l_preInfo[#l_preInfo + 1] = l_followInfo[i]
                end
            end
            l_info = l_preInfo
        end
    else
        self.filterTab = {}
        for i = 1, #l_target.info.items do
            local l_id = l_target.info.items[i].CommoditID --- 商品id
            local l_OpenSystemLev = l_target.info.items[i].OpenSystemLev --- 商品id
            if l_OpenSystemLev <= self.tradeMgr.ServerLevel then
                table.insert(l_curItemTable, l_id)
                local l_targetTradeInfo = self.tradeData.GetTradeInfo(l_id)
                local l_filter = l_target.info.items[i].Fliter
                self:AddFilter(l_filter)
                -- 筛选所有满足过滤条件的物品
                if l_targetTradeInfo and
                        (l_filter == "" or self.filter == nil or self.filter == l_filter) then
                    if ((not self.onlyShowInStock) or (l_targetTradeInfo.stockNum > LongZero or l_target.info.info.ShowRadio == false)) then
                        local l_index = #l_info + 1
                        l_info[l_index] = {}
                        l_info[l_index].tableInfo = l_target.info.items[i] ----CommoditTable
                        l_info[l_index].netInfo = l_targetTradeInfo
                        l_infoIndex[l_id] = l_index
                    end
                end
            end
        end
        table.sort(l_info, function(x, y)
            return x.tableInfo.SortID < y.tableInfo.SortID
        end)
    end
    --self.panel.DropDown.DropDown.onValueChanged:RemoveAllListeners()
    if #self.filterTab > 1 then
        local l_sort = {}
        l_sort[1] = Common.Utils.Lang("AllText")
        local l_commoditSorted = self.tradeData.GetCommoditSorted()
        for i = 1, #l_commoditSorted do
            local l_name = l_commoditSorted[i].name
            if table.ro_contains(self.filterTab, l_name) then
                l_sort[#l_sort + 1] = l_name
            end
        end
        self.filterTab = l_sort
        self.panel.DropDown.gameObject:SetActiveEx(true)
        self.panel.DropDown.DropDown:ClearOptions()
        self.panel.DropDown:SetDropdownOptions(self.filterTab)
        if self.lastFilter then
            self.filter = self.lastFilter.name
        end
        -- self.filter表示选中的是全部
        if self.filter then
            local l_value = 1
            for i = 1, #self.filterTab do
                if self.filter == self.filterTab[i] then
                    l_value = i
                    break
                end
            end
            self.panel.DropDown.DropDown.value = l_value - 1
        else
            self.panel.DropDown.DropDown.value = 0
        end
        self.panel.DropDown.DropDown.onValueChanged:AddListener(function(index)
            if index == 0 then
                self.filter = nil
            else
                self.filter = self.filterTab[index + 1]
            end
            self.lastFilter = { name = self.filter }
            self.panel.DropDown.DropDown.onValueChanged:RemoveAllListeners()
            self:UpdateBuyItemPanel(false, true)
        end)
    else
        self.panel.DropDown.gameObject:SetActiveEx(false)
        -- 清除上一次选中
        self.lastFilter = nil
    end
    if #l_info > 0 then
        local l_sortInfo = {}
        local l_professionInfo = {}
        for i = 1, #l_info do
            if l_info[i].netInfo.professionSupport == 1 then
                l_sortInfo[#l_sortInfo + 1] = l_info[i]
            else
                l_professionInfo[#l_professionInfo + 1] = l_info[i]
            end
        end
        if #l_professionInfo > 0 then
            for i = 1, #l_professionInfo do
                l_sortInfo[#l_sortInfo + 1] = l_professionInfo[i]
            end
        end
        l_info = l_sortInfo
    end
    --table.sort(l_info,function (x,y)
    --	return x.netInfo.professionSupport>y.netInfo.professionSupport end)

    for i, v in pairs(l_buyItemPrefab) do
        self:UninitTemplate(v)
    end
    l_buyItemPrefab = {}
    l_buyItemMap = {}

    local l_count = #l_info
    if l_count < 1 then
        self.contentWrap:SetContentCount(0)
        self:RefreshRightBaseInfo(true)
        self.panel.pageLab.LabText = "1/1"
        self.panel.BuyTipsLab.LabText = Common.Utils.Lang("TRADE_BUY_EMPTY")
        return
    end
    self.panel.BuyTipsLab.LabText = Common.Utils.Lang("TRADE_BUY_SELECT")
    local l_sourceIndex = 0--来源跳转
    self.allPage = math.ceil(l_count / l_pageNum)
    if self.curPage > self.allPage then
        self.curPage = 1
    end
    if not target or self.tradeMgr.LastItemId == nil then
        if l_curItem == nil then
            --l_curItem = l_info[1] ---(.tableInfo/.netInfo) ==>> (CommoditTable + buyCount/sellCount/curPrice/basePrice)
            l_sourceIndex = 1
        end
    else
        local l_itemid = self.tradeMgr.LastItemId
        if self.tradeData.GetTradeInfo(l_itemid) then
            for i = 1, #l_info do
                if l_info[i].tableInfo.CommoditID == l_itemid then
                    l_curItem = l_info[i]
                    l_sourceIndex = i
                    self.curPage = math.ceil(i / l_pageNum)
                    break
                end
                l_curItem = l_info[1]
            end
        end
    end
    local l_startIndex = (self.curPage - 1) * l_pageNum
    local l_lasIndex = l_count - l_startIndex
    l_count = l_lasIndex > l_pageNum and l_pageNum or l_lasIndex
    self.panel.pageLab.LabText = tostring(self.curPage) .. "/" .. tostring(self.allPage)
    self.panel.buyButtonUp:AddClick(function()
        self:HandleBuyButtonUpClicked()
    end)
    self.panel.buyButtonDown:AddClick(function()
        self:HandleBuyButtonDownClicked()
    end)
    self.contentWrap.updateOneItem = function(obj, index)
        index = index + l_startIndex
        local l_itemInfo = l_info[index + 1]
        local l_itemTargetIndex
        if l_buyItemMap[obj] then
            l_itemTargetIndex = l_buyItemMap[obj]
        else
            l_buyItemMap[obj] = index + 1
            l_itemTargetIndex = index + 1
        end
        if not l_buyItemPrefab[l_itemTargetIndex] then
            local parent = obj.transform:Find("EquipIconBg").gameObject
            l_buyItemPrefab[l_itemTargetIndex] = self:NewTemplate("ItemTemplate", {
                TemplateParent = parent.transform,
            })
        end
        if l_buyItemPrefab[l_itemTargetIndex] then
            l_buyItemPrefab[l_itemTargetIndex]:SetData({
                ID = l_itemInfo.tableInfo.CommoditID, IsShowCount = false, ButtonMethod = function()
                    if l_itemTable[obj] and l_itemTable[obj].HandleItemButtonClicked then
                        l_itemTable[obj].HandleItemButtonClicked()
                    end
                    MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(l_itemInfo.tableInfo.CommoditID, l_buyItemPrefab[l_itemTargetIndex]:transform())
                end })
        end
        self:UpdateItem(obj, l_itemInfo)
    end
    self.contentWrap:SetContentCount(l_count)
    self:RefreshRightBaseInfo(true)

    if updateScrollPos then
        --来源跳转
        if l_sourceIndex == 0 then
            for i = 1, #l_info do
                if l_info[i].tableInfo.CommoditID == l_curItem.tableInfo.CommoditID then
                    l_sourceIndex = i
                    break
                end
            end
        end
        if l_sourceIndex > self.curPage * l_pageNum or l_sourceIndex < (self.curPage - 1) * l_pageNum + 1 then
            l_sourceIndex = 0
        else
            l_sourceIndex = l_sourceIndex - (self.curPage - 1) * l_pageNum
        end
        self:SetBuyContentTrans(l_sourceIndex, #l_info == l_sourceIndex)
    else
        self.buyForceUpdateState = true
    end
end
--[[
添加下拉数据
--]]
function TradeHandler:AddFilter(filter)
    if filter ~= "" then
        local l_have = false
        for i = 1, #self.filterTab do
            if filter == self.filterTab[i] then
                l_have = true
                break
            end
        end
        if not l_have then
            local l_index = #self.filterTab + 1
            self.filterTab[l_index] = filter
        end
    end
end
--[[
设置滑动列表位置
--]]
function TradeHandler:SetBuyContentTrans(index, isLast)
    self.panel.buyScrollView.Scroll.enabled = false
    if index <= 4 then
        self.contentWrap.gameObject:SetLocalPosY(0)
        self.buyForceUpdateState = true
        return
    end
    local l_index = index - 4
    local l_dis = l_index * 100
    if isLast then
        l_dis = l_dis - 30
    end
    self.contentWrap.gameObject:SetLocalPosY(l_dis)
    self.buyForceUpdateState = true
end

---刷新item显示信息
---(.tableInfo/.netInfo) ==>> (CommoditTable + buyCount/sellCount/curPrice/basePrice)
function TradeHandler:UpdateItem(obj, info)
    local l_item = obj:GetComponent("MLuaUICom")
    local l_canvasGroup = l_item.gameObject.transform:GetComponent("CanvasGroup")
    local l_bg = l_item.gameObject.transform:Find("EquipIconBg").gameObject:GetComponent("Image")
    local l_icon = l_item.gameObject.transform:Find("EquipIconBg/EquipIcon").gameObject:GetComponent("MLuaUICom")
    local l_name = l_item.gameObject.transform:Find("Name").gameObject:GetComponent("MLuaUICom")
    local l_down = l_item.gameObject.transform:Find("down").gameObject
    local l_downLab = l_item.gameObject.transform:Find("down/Text").gameObject:GetComponent("MLuaUICom")
    local l_mid = l_item.gameObject.transform:Find("mid").gameObject
    local l_up = l_item.gameObject.transform:Find("up").gameObject
    local l_upLab = l_item.gameObject.transform:Find("up/Text").gameObject:GetComponent("MLuaUICom")
    local l_priceLab = l_item.gameObject.transform:Find("Price/PriceCount").gameObject:GetComponent("MLuaUICom")
    local l_selected = l_item.gameObject.transform:Find("Selected").gameObject
    local l_btn = l_item.gameObject.transform:Find("ItemButton").gameObject:GetComponent("MLuaUICom")
    local l_preBuyFlag = l_item.gameObject.transform:Find("preBuyFlag").gameObject:GetComponent("MLuaUICom")
    local l_stock = l_item.gameObject.transform:Find("stockNumLab").gameObject
    local l_stockNumLab = l_item.gameObject.transform:Find("stockNumLab/stockNumLab").gameObject:GetComponent("MLuaUICom")
    local l_itemInfo = info
    local l_itemId = l_itemInfo.tableInfo.CommoditID ---商品id
    local l_itemRow = TableUtil.GetItemTable().GetRowByItemID(l_itemId)
    l_icon:SetSprite(l_itemRow.ItemAtlas, l_itemRow.ItemIcon, true)
    l_bg.enabled = l_itemRow.TypeTab ~= Data.BagModel.PropType.Card

    l_priceLab.LabText = math.modf(l_itemInfo.netInfo.curPrice + 0.5) ----道具显示价格
    local l_value = ((l_itemInfo.netInfo.curPrice / l_itemInfo.netInfo.basePrice) - 1) * 100    --道具显示涨跌
    if l_value > 0 then
        l_down:SetActiveEx(false)
        l_mid:SetActiveEx(false)
        l_up:SetActiveEx(true)
        l_upLab.LabText = StringEx.Format("{0:F2}", l_value + 0.005) .. "%"
    end
    if l_value == 0 then
        l_down:SetActiveEx(false)
        l_mid:SetActiveEx(true)
        l_up:SetActiveEx(false)
    end
    if l_value < 0 then
        l_down:SetActiveEx(true)
        l_mid:SetActiveEx(false)
        l_up:SetActiveEx(false)
        l_downLab.LabText = StringEx.Format("{0:F2}", math.abs(l_value - 0.005)) .. "%"
    end
    l_preBuyFlag.gameObject:SetActiveEx(l_itemInfo.netInfo.preBuyNum > LongZero)
    local l_curNum = l_itemInfo.netInfo.stockNum
    local l_maxNum = l_itemInfo.tableInfo.ShowUpperLimit
    local l_tips = l_itemInfo.netInfo.isNotice and Common.Utils.Lang("TRADE_PRE_SELL") .. "：" or Common.Utils.Lang("STALL_IN_SELL")
    l_stockNumLab.LabText = l_tips .. (l_curNum > MLuaCommonHelper.Long(l_maxNum) and tostring(l_maxNum) .. "+" or tostring(l_curNum))
    l_stock:SetActiveEx(l_itemInfo.netInfo.isNotice or l_itemInfo.tableInfo.IsPublicity)

    --根据是否是公式商品限制名称的长度
    if l_itemInfo.netInfo.isNotice or l_itemInfo.tableInfo.IsPublicity then
        l_name.LabText = Common.Utils.GetCutOutText(l_itemRow.ItemName, 7)
    else
        l_name.LabText = Common.Utils.GetCutOutText(l_itemRow.ItemName, 12)
    end

    if l_itemTable[obj] == nil then
        l_itemTable[obj] = {}
    end
    l_itemTable[obj].itemId = l_itemId
    l_itemTable[obj].selected = l_selected
    l_itemTable[obj].info = info ---(.tableInfo/.netInfo) ==>> (CommoditTable + buyCount/sellCount/curPrice/basePrice)
    local l_id = l_curItem and l_curItem.tableInfo.CommoditID or -1
    if l_itemId == l_id and (not self.tradeMgr.TradeFirstIn) then
        l_selected:SetActiveEx(true)
    else
        l_selected:SetActiveEx(false)
    end
    l_canvasGroup.alpha = 1
    if l_itemInfo.netInfo.professionSupport == 0 then
        l_canvasGroup.alpha = 0.6
    end

    --保存物品栏点击事件，便于其它地方调用
    l_itemTable[obj].HandleItemButtonClicked = function()
        local l_curId = l_curItem and l_curItem.tableInfo.CommoditID or -1
        if l_curId == l_itemId then
            return
        end
        for k, v in pairs(l_itemTable) do
            if v.itemId == l_curId then
                v.selected:SetActiveEx(false)
                break
            end
        end
        l_curItem = l_itemInfo
        l_selected:SetActiveEx(true)
        self:RefreshRightBaseInfo(true)
    end

    l_btn:AddClick(function()
        l_itemTable[obj].HandleItemButtonClicked()
    end)
end

--[[
设置状态
--]]
function TradeHandler:SetTradePabelState(state)
    local l_go1 = self.panel.PanelRef.gameObject.transform:Find("Panel/BuyPanel/BG").gameObject
    local l_go2 = self.panel.PanelRef.gameObject.transform:Find("Panel/BuyPanel/Detail").gameObject
    local l_go3 = self.panel.PanelRef.gameObject.transform:Find("Panel/BuyPanel/Count").gameObject
    local l_go4 = self.panel.PanelRef.gameObject.transform:Find("Panel/BuyPanel/Price").gameObject
    local l_go5 = self.panel.PanelRef.gameObject.transform:Find("Panel/BuyPanel/PriceOwn").gameObject
    local l_go6 = self.panel.PanelRef.gameObject.transform:Find("Panel/BuyPanel/BuyBtn").gameObject
    l_go1:SetActiveEx(state)
    l_go2:SetActiveEx(state)
    l_go3:SetActiveEx(state)
    l_go4:SetActiveEx(state)
    l_go5:SetActiveEx(state)
    l_go6:SetActiveEx(state)
end

-- 刷新右侧基础信息
function TradeHandler:RefreshRightBaseInfo(updateCount)

    self.panel.BuyCount.InputNumber.OnValueChange = (function(value)
    end)

    if not self.buyPanelInit then
        return
    end
    local addListener = MUIEventListener.Get(self.panel.BuyCount.InputNumber.AddButton.gameObject)
    addListener.onClick = function(go, data)
    end
    local SubtractListener = MUIEventListener.Get(self.panel.BuyCount.InputNumber.SubtractButton.gameObject)
    SubtractListener.onClick = function(go, data)
    end

    -- 库存时间刷新处理
    -- 针对【IsPublicity值为1】且【当前不需要预购(isNotice==false)】且【InventoryRefreshType值为2】的道具，在预购按钮左侧显示更新库存的倒计时
    self.isRefreshStockTime = l_curItem and l_curItem.tableInfo.InventoryRefreshType == 2 and l_curItem.tableInfo.IsPublicity and not l_curItem.netInfo.isNotice
    self.panel.RefreshTime:SetActiveEx(self.isRefreshStockTime)

    if not l_curItem then
        self.panel.buyDetail:SetActiveEx(false)
        self.panel.BuyItemEmpty:SetActiveEx(true)
        self.panel.BuyBtn:SetActiveEx(false)

        self.panel.BuyCount.InputNumber.MaxValue = 0
        self.panel.BuyCount.InputNumber:SetValue(0)
        self.panel.PriceCount.LabText = 0
        self.buyPrice = 0
        self.panel.HaveCount.LabText = tostring(MPlayerInfo.Coin102)
        self.panel.BuyIconBtn:AddClick(function()
            local propInfo = Data.BagModel:CreateItemWithTid(102)
            MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplay(propInfo, nil, nil, nil, true)
        end)

        local l_target = l_curSonBtn
        if l_target == nil then
            l_target = l_curMainBtn
        end
        if l_target ~= nil then
            local l_openTarget = self.tradeData.GetOpenState(l_target.info.info.ClassificationID)
            if l_openTarget == nil then
                self.panel.BuyItemEmpty:SetActiveEx(false)
            end
            if l_openTarget and (not l_openTarget.isOpen) then
                self.panel.BuyItemEmpty:SetActiveEx(false)
            end
        end
        self.panel.NoticeBtn.gameObject:SetActiveEx(false)
        return
    else
        self.panel.NoticeBtn.gameObject:SetActiveEx(true)
        self.panel.buyDetail:SetActiveEx(true)
        self.panel.BuyItemEmpty:SetActiveEx(false)
        self.panel.BuyBtn:SetActiveEx(true)
    end
    ---(.tableInfo/.netInfo) ==>> (CommoditTable + buyCount/sellCount/curPrice/basePrice)
    local l_target = l_curItem
    self:SetTradePabelState(true)
    if not l_target then
        self:SetTradePabelState(false)
        --logError("[TradeHandler]this type is not exit target item!")
        return
    end
    local l_id = l_target.tableInfo.CommoditID
    local l_itemRow = TableUtil.GetItemTable().GetRowByItemID(l_id)
    if l_itemRow == nil then
        return
    end
    self.panel.DetailName.LabText = l_itemRow.ItemName
    self.panel.DetailLab.LabText = MgrMgr:GetMgr("ItemPropertiesMgr").GetDetailInfo(l_id)
    --强制刷新content大小
    LayoutRebuilder.ForceRebuildLayoutImmediate(self.panel.DetailLab.RectTransform.parent)
    Common.CommonUIFunc.CalculateLowLevelTipsInfo(self.panel.DetailLab)
    --重置位置
    self.panel.DetailLab.RectTransform.parent.anchoredPosition = Vector3.New(0, 0, 0)
    ---1为购买类型;
    local l_temp = self.tradeMgr.GetBuyCountLimitInfo(l_id)
    local l_count = 0
    local l_limitBuy = true
    if l_temp then
        l_count = tonumber(l_temp.count)
        l_count = (l_count > 0) and l_count or 0
        l_limitBuy = l_temp.limt ~= -1
    else
        l_count = 0
        logError(StringEx.Format("[TradeHandler]can not find the limit info,id:{0}!", tostring(l_id)))
    end
    -- 单次限购
    local l_oneTime = l_curItem.tableInfo.PerPurchaseLimit
    local l_buyCount = math.min(l_oneTime, l_count)
    --保存PerPurchaseLimit用于超出限制判断
    self.buyPerPurchaseLimit = l_curItem.tableInfo.PerPurchaseLimit
    if l_target.netInfo.isNotice then
        -- 购买公示道具时，可输入数量的上限=math.min(单次限购数量，道具库存-玩家已预购数量，今日总限购数量-玩家已预购数量)
        local l_tempValue = MLuaCommonHelper.MinLong(MLuaCommonHelper.Long(l_buyCount), l_target.netInfo.stockNum - l_target.netInfo.preBuyNum)
        l_tempValue = MLuaCommonHelper.MinLong(l_tempValue, l_temp.limt - l_target.netInfo.preBuyNum)
        l_buyCount = MLuaCommonHelper.Long2Int(l_tempValue)
    end
    self.panel.BuyCountLab.gameObject:SetActiveEx(l_curItem.tableInfo.DayPurchaseLimitDisplay > 0)
    if l_curItem.tableInfo.DayPurchaseLimitDisplay > 0 then
        if l_curItem.netInfo.isNotice then
            -- 已预购数量
            local l_showCount = l_target.netInfo.preBuyNum
            if l_temp.limt ~= -1 then
                self.panel.BuyCountLab.LabText = Common.Utils.Lang("TRADE_PREBUY_COUNT") .. tostring(l_showCount)
                        .. "/" .. tostring(l_temp.limt)
            else
                self.panel.BuyCountLab.LabText = Common.Utils.Lang("TRADE_PREBUY_COUNT") .. tostring(l_showCount)
            end
        else
            self.panel.BuyCountLab.LabText = StringEx.Format(Common.Utils.Lang("TRADE_BUY_COUNT"), l_count)
        end
    end
    local l_limit = l_buyCount == 0
    if not l_limitBuy then
        l_limit = false
        l_buyCount = l_oneTime
    end

    local l_showTips = false
    local l_showState = false
    local l_state, l_num = Data.BagModel:getMaxItemNum(l_id)
    if l_num < 1 then
        l_num = 1
    end

    if l_state then
        if l_num < l_buyCount then
            l_showState = true
        end

        if l_buyCount >= l_num then
            l_buyCount = l_num
        end
    end

    addListener.onClick = function(go, data)
        if l_showState then
            local l_num = self.panel.BuyCount.InputNumber:GetValue()
            local l_state = l_num >= l_buyCount
            if not l_showTips and l_state then
                l_showTips = true
                return
            end
            if l_showTips then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("BAG_LIMIT_BUY"))
            end
        end
    end
    SubtractListener.onClick = function(go, data)
        if l_showState then
            local l_num = self.panel.BuyCount.InputNumber:GetValue()
            local l_state = l_num >= l_buyCount
            if l_showTips and not l_state then
                l_showTips = false
                return
            end
        end
    end

    if l_limit then
        self.panel.BuyCount.InputNumber.MaxValue = 1
        self.panel.BuyCount.InputNumber:SetValue(1)
    else
        local l_curNum = MLuaCommonHelper.Long2Int(self.panel.BuyCount.InputNumber:GetValue())
        self.panel.BuyCount.InputNumber.MaxValue = l_buyCount
        if l_curNum <= l_buyCount and (not updateCount) then
            self.panel.BuyCount.InputNumber:SetValue(l_curNum)
        else
            self.panel.BuyCount.InputNumber:SetValue(1)
        end
    end

    self.panel.BuyCount.InputNumber.OnValueChange = (function(value)
        if self.panel then
            self:UpdateCost(l_target, l_limit)
        end
    end)

    self:UpdateCost(l_target, l_limit)
end
----刷新花费
---(.tableInfo/.netInfo) ==>> (CommoditTable + buyCount/sellCount/curPrice/basePrice)
function TradeHandler:UpdateCost(l_target, l_limit)

    local l_n = MLuaCommonHelper.Long2Int(self.panel.BuyCount.InputNumber:GetValue())
    local l_p0 = tonumber(l_target.tableInfo.InitialPrice)--l_target.netInfo.basePrice
    local l_p1 = tonumber(l_target.netInfo.basePrice)--l_target.netInfo.curPrice
    local l_p2 = tonumber(l_target.netInfo.curPrice)
    local l_s0 = tonumber(l_target.tableInfo.InitialStock)
    local l_t1 = tonumber(l_target.netInfo.buyCount)
    local l_t2 = tonumber(l_target.netInfo.sellCount)
    local l_id = l_target.tableInfo.CommoditID
    local l_isNotice = l_target.netInfo.isNotice      --是否是公示
    local l_stockNum = tonumber(l_target.netInfo.stockNum)      --库存
    local l_isFollow = l_target.netInfo.isFollow
    local l_symbol = tonumber(l_target.tableInfo.PriceType)
    local l_t6 = l_target.netInfo.modifiedFactor

    local l_minPrice = l_target.tableInfo.PriceLimit[0]
    local l_maxPrice = l_target.tableInfo.PriceLimit[1]

    local l_expectPrice, l_range = self.tradeMgr.GetExpectAndRange(l_id)

    local l_func = "Buy"
    if l_isNotice then
        l_symbol = l_target.tableInfo.PublicityPriceType
        l_func = "PublicityBuy"
    end
    local l_const                                   --价格
    if l_n == 0 then
        l_const = 0
    else
        if l_isNotice then
            l_const = math.modf(PriceFunction[l_func](l_symbol, l_n, l_p2) + 0.5)
        else
            l_const = math.modf(PriceFunction[l_func](l_symbol, l_n, l_p0, l_p1, l_s0, l_t1, l_t2, 0, l_minPrice, l_maxPrice, l_expectPrice, l_range, l_t6) + 0.5)
        end
    end
    local l_error = (type(l_const) ~= type(1)) or (l_const == -1)
    local l_showText, l_needNum = Common.CommonUIFunc.ShowCoinStatusText(GameEnum.l_virProp.Coin102, l_const)
    if l_error then
        self.panel.PriceCount.LabText = "--"
        self.buyPrice = 0
    else
        local l_text
        local l_showNum = tonumber(l_const)
        local l_haveCount = Data.BagModel:GetCoinOrPropNumById(GameEnum.l_virProp.Coin102)
        if l_haveCount < l_showNum then
            l_text = RoColor.GetTextWithDefineColor(MNumberFormat.GetNumberFormat(l_showNum), RoColor.UIDefineColorValue.WaringColor)
        else
            l_text = tostring(l_const)
        end
        --self.panel.PriceCount.LabText = l_showText
        self.panel.PriceCount.LabText = l_text
        self.buyPrice = l_const
    end
    self.panel.HaveCount.LabText = tostring(MPlayerInfo.Coin102)
    self.panel.BuyIconBtn:AddClick(function()
        local propInfo = Data.BagModel:CreateItemWithTid(GameEnum.l_virProp.Coin102)
        MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplay(propInfo, nil, nil, nil, true)
    end)

    local l_professionSupport = l_target.netInfo.professionSupport
    local l_text = self.panel.BuyBtn.gameObject.transform:Find("Text"):GetComponent("MLuaUICom")
    if l_isNotice then
        l_text.LabText = Common.Utils.Lang("TRADE_PRE_BUY")
    else
        l_text.LabText = Common.Utils.Lang("Buy")
    end
    self.panel.NoticeBtn:SetActiveEx(l_target.tableInfo.IsPublicity)
    if l_target.tableInfo.IsPublicity then
        self.panel.NoticeBtn:SetGray(not l_isFollow)
        self.panel.NoticeBtn:AddClick(function()
            self.tradeMgr.SendTradeFollowItemReq(l_id, not l_isFollow)
        end)
    end
    local l_buyFunc
    --回调不检测
    l_buyFunc = function(isNotCheck)

        if l_professionSupport == 0 then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("TRADE_PRO_SUPPORT"))
            return
        end
        
        --优先判断库存
        if l_isNotice and l_target.netInfo.buyCount >= l_stockNum then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("LOW_STOCK"))
            return
        end

        local l_func = function()
            if l_const == 0 or l_limit or l_error then
                if l_isNotice then
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("TRADE_STOCK_NUMBER"))
                else
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("TRADE_BUY_LIMIT_COUNT"))
                end
                return
            end
            --if MPlayerInfo.Coin102 >= MLuaCommonHelper.Long(l_const) then
            self.tradeMgr.SendTradeBuyItemReq(l_isNotice, l_id, l_n, false, l_const)
            -- else
            --     MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("STALL_RO_NOT_ENOUGTH"))
            --     local propInfo = Data.BagModel:CreateItemWithTid(102)
            --     MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplay(propInfo, nil, nil, nil, true)
            -- end
        end

        if l_isNotice then
            local l_itemName = ""
            local l_itemRow = TableUtil.GetItemTable().GetRowByItemID(l_id)
            if l_itemRow then
                l_itemName = l_itemRow.ItemName
            end
            local l_costItemData = TableUtil.GetItemTable().GetRowByItemID(102)
            local l_iconStr = StringEx.Format(Common.Utils.Lang("RICH_IMAGE"), l_costItemData.ItemIcon, l_costItemData.ItemAtlas, 20, 1)
            local l_content = RoColor.FormatWord(Lang("TRADE_PUBLICITY_ORDER", MLuaCommonHelper.Long(l_const), l_iconStr, l_itemName, l_n))
            CommonUI.Dialog.ShowYesNoDlg(true, nil, l_content, function()
                l_func()
            end, nil, nil, 2, "TRADE_PUBLICITY_ORDER_KEY", nil, nil, nil, UnityEngine.TextAnchor.MiddleCenter)
        else
            l_func()
        end
    end

    -- 预购按钮
    self.panel.BuyBtn:AddClick(function()
        l_buyFunc()
    end)
end
--[[
强制购买
--]]
function TradeHandler:Force2Buy()
    local l_value = MGlobalConfig:GetFloat("HotSaleBuyPrice") / 10000
    local l_str = StringEx.Format(Common.Utils.Lang("TRADE_ITEM_FORCE_TO_BUY"), l_value)

    UIMgr:ActiveUI(UI.CtrlNames.TradeDialog, function(l_ui)
        local l_const = math.modf(tonumber(self.buyPrice) * l_value + 0.5)
        l_ui:ShowDoubleTradeDialog(l_str,
                l_const,
                function()
                    local l_number = self.panel.BuyCount.InputNumber:GetValue()
                    local l_isNotice = l_curItem.netInfo.isNotice
                    self.tradeMgr.SendTradeBuyItemReq(l_isNotice, l_curItem.tableInfo.CommoditID,
                            MLuaCommonHelper.Long2Int(l_number), true)
                    UIMgr:DeActiveUI(UI.CtrlNames.TradeDialog)
                end,
                function()
                    UIMgr:DeActiveUI(UI.CtrlNames.TradeDialog)
                end)
    end)
end

---=============================================出售面板=================================================================
---
---初始化出售面板;
function TradeHandler:InitSellPanel()
    self.panel.PanelRef.gameObject.transform:Find("Panel/BuyPanel/BG").gameObject:SetActiveEx(false)
    self.sellForceUpdateState = false
    self.sellNextUpdate = nil
    self.panel.SellCountTarget.InputNumber.MaxValue = 0
    self.panel.SellCountTarget.InputNumber:SetValue(0)

    --超过最大值弹提醒
    self.sellPerSellLimit = self.sellPerSellLimit or -1
    self.panel.SellCountTarget.InputNumber.OnMaxValueMethod = function()
        if MLuaCommonHelper.Long2Int(self.panel.SellCountTarget.InputNumber.MaxValue) == self.sellPerSellLimit then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("TRADE_SELL_EXCEED_MAX", self.sellPerSellLimit))
        end
    end

    l_item = {}
    l_itemIndex = {}
    local l_searchIndex = nil
    local l_idTab = {}
    local l_sellInfo = l_limitMgr.g_allInfo[l_sellType]
    if l_sellInfo ~= nil then
        for k, v in pairs(l_sellInfo) do
            local l_tempId = tonumber(k)
            l_idTab[l_tempId] = {}
        end
    end
    local l_noticeSellInfo = l_limitMgr.g_allInfo[l_noticeSellType]
    if l_noticeSellInfo ~= nil then
        for k, v in pairs(l_noticeSellInfo) do
            local l_tempId = tonumber(k)
            l_idTab[l_tempId] = {}
        end
    end

    local l_result = Data.BagModel:getPropList(l_idTab)
    if #l_result > 0 then
        for i = 1, #l_result do
            local l_id = l_result[i].id
            local l_uid = l_result[i].uid
            local l_count = l_result[i].num
            local l_is_bind = l_result[i].is_bind

            if not l_is_bind then
                local l_tab = TableUtil.GetCommoditTable().GetRowByCommoditID(l_id)
                local l_net = self.tradeData.GetTradeInfo(l_id)
                --if l_count>0 and l_tab~=nil and l_net~=nil then
                if l_tab.Enable and l_count > 0 and l_tab ~= nil then
                    local l_index = #l_item + 1
                    l_item[l_index] = {}
                    l_item[l_index].id = l_id
                    l_item[l_index].uid = l_uid
                    l_item[l_index].is_bind = l_is_bind
                    l_item[l_index].index = l_index
                    l_item[l_index].havaCount = l_count--l_count
                    local l_targetInfo = self.tradeMgr.GetSellCountLimitInfo(l_id)
                    l_item[l_index].sellCount = 0
                    if l_targetInfo then
                        l_item[l_index].sellCount = l_targetInfo.count
                        if l_targetInfo.limt == -1 then
                            l_item[l_index].sellCount = l_item[l_index].havaCount + 1
                        end
                    end
                    l_item[l_index].tableInfo = l_tab
                    l_item[l_index].netInfo = l_net
                    ---(.tableInfo/.netInfo/sellCount/havaCount) ==>> (CommoditTable + buyCount/sellCount/curPrice/basePrice)
                    if self.tradeMgr.g_targetSellItemId and l_searchIndex == nil and l_net ~= nil then
                        l_searchIndex = l_uid == self.tradeMgr.g_targetSellItemId and l_index or nil
                    end

                end
            end
        end
    end

    self.tradeMgr.g_targetSellItemId = nil

    --Common.Functions.DumpTable(l_item)
    l_curSellItemTable = {} --- 出售实例item
    l_curSellItem = nil
    if l_searchIndex then
        l_curSellItem = {}
        l_curSellItem.id = l_item[l_searchIndex].id
        l_curSellItem.uid = l_item[l_searchIndex].uid
        l_curSellItem.index = l_searchIndex
        l_curSellItem.info = l_item[l_searchIndex]
    end

    self.sellContentWrap = self.panel.SellContent.gameObject:GetComponent("UIWrapContent")
    if l_sellScrollViewInit then
        self.sellContentWrap:InitContent()
        l_sellScrollViewInit = false
    end
    local l_count = #l_item

    for i, v in pairs(l_sellItemPrefab) do
        self:UninitTemplate(v)
    end
    l_sellItemPrefab = {}
    l_sellItemMap = {}

    self.sellContentWrap.updateOneItem = function(obj, index)
        --TODO!!!
        local l_itemInfo = nil
        if index + 1 > l_count then
            l_itemInfo = nil
        else
            l_itemInfo = l_item[index + 1]
        end
        if l_itemInfo then
            local l_itemTargetIndex
            if l_sellItemMap[obj] then
                l_itemTargetIndex = l_sellItemMap[obj]
            else
                l_sellItemMap[obj] = index + 1
                l_itemTargetIndex = index + 1
            end
            if not l_sellItemPrefab[l_itemTargetIndex] then
                local parent = obj.transform:Find("parent")
                l_sellItemPrefab[l_itemTargetIndex] = self:NewTemplate("ItemTemplate", {
                    TemplateParent = parent,
                })
            end
            if l_sellItemPrefab[l_itemTargetIndex] then
                l_sellItemPrefab[l_itemTargetIndex]:SetData({ ID = l_itemInfo.id, IsShowCount = true,
                                                              Count = l_itemInfo.havaCount, IsShowTips = false,
                                                              IsGray = (l_itemInfo.netInfo == nil) })
            end
        end
        self:UpdateSellItem(obj, l_itemInfo)
    end
    self.sellContentWrap:SetContentCount(l_count <= 42 and 42 or l_count)
    self:UpdateSellBaseInfo(true)
    self.sellScrollRect.enabled = true
    if l_searchIndex then
        self:SetSellContentTrans(l_searchIndex, (l_count - l_searchIndex < 7))
    end
end
--[[
设置位置
--]]
function TradeHandler:SetSellContentTrans(index, isLast)
    self.sellScrollRect.enabled = false
    if (index / 7) <= 5 then
        self.sellContentWrap.gameObject:SetLocalPosY(0)
        self.sellForceUpdateState = true
        return
    end
    local l_index, l_temp = math.modf(index / 7)
    l_index = l_temp > 0 and l_index - 4 or l_index - 5
    local l_dis = l_index * 75
    if isLast then
        l_dis = l_dis - 45
    end
    self.sellContentWrap.gameObject:SetLocalPosY(l_dis)
    self.sellForceUpdateState = true
end

----更新出售item;
---(.tableInfo/.netInfo/sellCount/havaCount) ==>> (CommoditTable + buyCount/sellCount/curPrice/basePrice)
function TradeHandler:UpdateSellItem(obj, l_itemInfo)
    local l_item = obj:GetComponent("MLuaUICom")
    local l_btn = l_item.gameObject.transform:Find("Btn").gameObject:GetComponent("MLuaUICom")
    --local l_icon = l_item.gameObject.transform:Find("EquipIcon").gameObject:GetComponent("MLuaUICom")
    local l_selected = l_item.gameObject.transform:Find("Select").gameObject
    --local l_countLab = l_item.gameObject.transform:Find("Count").gameObject:GetComponent("MLuaUICom")
    if l_itemInfo == nil then
        l_selected:SetActiveEx(false)
        --l_icon.gameObject:SetActiveEx(false)
        --l_countLab.gameObject:SetActiveEx(false)
        l_btn:AddClick(function()
        end)
        l_item.Img.enabled = true
        return
    end
    --l_icon.gameObject:SetActiveEx(true)
    --l_countLab.gameObject:SetActiveEx(true)
    local l_id = l_itemInfo.id
    local l_uid = l_itemInfo.uid
    local l_havaCount = l_itemInfo.havaCount
    local l_itemRow = TableUtil.GetItemTable().GetRowByItemID(l_id)
    if l_itemRow == nil then
        logError("[Lua][TradeHandler]error,can not find item:" .. l_id)
        return
    end
    --l_curSellItem = {}
    --l_curSellItem.id = l_id
    --l_curSellItem.info = l_itemInfo
    l_selected:SetActiveEx(false)
    l_item.Img.enabled = l_itemRow.TypeTab ~= Data.BagModel.PropType.Card
    local l_itemTargetIndex = -1
    if l_sellItemMap[obj] then
        l_itemTargetIndex = l_sellItemMap[obj]
    end
    if l_sellItemPrefab[l_itemTargetIndex] then
        l_sellItemPrefab[l_itemTargetIndex]:SetData({ ID = l_id, IsShowCount = true,
                                                      Count = l_havaCount, IsShowTips = false, IsGray = (l_itemInfo.netInfo == nil) })
    end
    if l_curSellItem then
        l_selected:SetActiveEx(l_curSellItem.id == l_id and l_curSellItem.uid == l_uid
                and l_curSellItem.index == l_itemInfo.index)
    end
    if l_curSellItemTable[obj] == nil then
        l_curSellItemTable[obj] = {}
    end
    l_curSellItemTable[obj].itemId = l_id --(.id/.go)
    l_curSellItemTable[obj].uid = l_uid --(.id/.go)
    l_curSellItemTable[obj].index = l_itemInfo.index
    l_curSellItemTable[obj].selected = l_selected

    if l_itemInfo.sellCount < 1 then
        if l_curSellItem ~= nil then
            if l_id == l_curSellItem.id and l_uid == l_curSellItem.uid
                    and l_curSellItem.index == l_itemInfo.index then
                l_selected:SetActiveEx(false)
            end
        end
        l_curSellItem = nil
        self:UpdateSellBaseInfo(true)
    end

    l_btn:AddClick(function()
        if not l_itemInfo.netInfo then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Common.Utils.Lang("TRADE_SELL_LIMIT"),
                    l_itemInfo.tableInfo.OpenSystemLev))
            return
        end
        if l_curSellItem then
            if l_curSellItem.id == l_id and l_curSellItem.uid == l_uid
                    and l_curSellItem.index == l_itemInfo.index then
                return
            else
                for k, v in pairs(l_curSellItemTable) do
                    if v.itemId == l_curSellItem.id and v.uid == l_curSellItem.uid
                            and v.index == l_curSellItem.index then
                        v.selected:SetActiveEx(false)
                        break
                    end
                end
                l_curSellItem.id = l_id
                l_curSellItem.uid = l_uid
                l_curSellItem.index = l_itemInfo.index
                l_curSellItem.info = l_itemInfo
                l_selected:SetActiveEx(true)
                self:UpdateSellBaseInfo(true)
            end
        else
            l_curSellItem = {}
            l_curSellItem.id = l_id
            l_curSellItem.uid = l_uid
            l_curSellItem.index = l_itemInfo.index
            l_curSellItem.info = l_itemInfo
            l_selected:SetActiveEx(true)
            self:UpdateSellBaseInfo(true)
        end
    end)
end

----更新出售栏右侧信息;
--(--(.id/.info))
---(.tableInfo/.netInfo/sellCount/havaCount) ==>> (CommoditTable + buyCount/sellCount/curPrice/basePrice)
function TradeHandler:UpdateSellBaseInfo(updateCount)

    self.panel.SellPriceCountLab.LabText = tostring(MPlayerInfo.Coin102)
    self.panel.sellBtnPlus:AddClick(function()
        --TODO:打开兑换界面
        local propInfo = Data.BagModel:CreateItemWithTid(102)
        MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplay(propInfo, nil, nil, nil, true)
    end)

    if l_curSellItem == nil then
        ----设置初始界面
        self.panel.SellItemDetails.gameObject:SetActiveEx(false)
        self.panel.SellItemEmpty.gameObject:SetActiveEx(true)
        self.panel.SellCountTarget.InputNumber.MaxValue = 0
        self.panel.SellCountTarget.InputNumber:SetValue(0)
        self.panel.SellCountTarget.InputNumber.OnValueChange = (function(value)
            self.panel.SellCountTarget.InputNumber:SetValue(0)
        end)
        self.panel.SellPriceCount.LabText = 0
        self.panel.SellItemBtn:AddClick(function()
            ---未选择item;
        end)
    else
        self.panel.SellItemDetails.gameObject:SetActiveEx(true)
        self.panel.SellDetails.LabText = MgrMgr:GetMgr("ItemPropertiesMgr").GetDetailInfo(l_curSellItem.info.tableInfo.CommoditID)
        --刷新大小
        LayoutRebuilder.ForceRebuildLayoutImmediate(self.panel.SellDetails.RectTransform.parent)
        --重置位置
        self.panel.SellDetails.RectTransform.parent.anchoredPosition = Vector3.New(0, 0, 0)
        self.panel.SellItemEmpty.gameObject:SetActiveEx(false)
        local l_sellCount = l_curSellItem.info.sellCount
        local l_oneTime = l_curSellItem.info.tableInfo.PerSellLimit
        --保存售出的最大限制，用于超过判断
        self.sellPerSellLimit = l_curSellItem.info.tableInfo.PerSellLimit
        local l_have = l_curSellItem.info.havaCount
        local l_targetCount
        if l_sellCount > l_oneTime then
            l_targetCount = l_oneTime
        else
            l_targetCount = l_sellCount
        end
        if l_targetCount > l_have then
            l_targetCount = l_have
        end
        local l_limit = l_targetCount == 0
        if l_limit then
            l_targetCount = l_targetCount + 1
        end
        local l_curNum = MLuaCommonHelper.Long2Int(self.panel.SellCountTarget.InputNumber:GetValue())
        self.panel.SellCountTarget.InputNumber.MaxValue = l_targetCount
        self.panel.SellCountTarget.InputNumber.OnValueChange = (function(value)
            if l_curSellItem == nil then
                return
            end
            self:UpdateSellCost(l_curSellItem, l_limit)
        end)
        if l_curNum < l_targetCount and (not updateCount) then
            self.panel.SellCountTarget.InputNumber:SetValue(l_curNum)
        else
            self.panel.SellCountTarget.InputNumber:SetValue(l_targetCount)
        end
        self:UpdateSellCost(l_curSellItem, l_limit)
    end
end

---@return ItemData
function TradeHandler:_getBagItemByUID(uid)
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

---更新出售价格;
---(.tableInfo/.netInfo/sellCount/havaCount) ==>> (CommoditTable + buyCount/sellCount/curPrice/basePrice)
function TradeHandler:UpdateSellCost(item, limit)
    local l_count = MLuaCommonHelper.Long2Int(self.panel.SellCountTarget.InputNumber:GetValue())
    local l_n = l_count
    local l_p0 = tonumber(item.info.tableInfo.InitialPrice) --item.info.netInfo.basePrice
    local l_p1 = tonumber(item.info.netInfo.basePrice)--item.info.netInfo.curPrice
    local l_p2 = tonumber(item.info.netInfo.curPrice)
    local l_s0 = tonumber(item.info.tableInfo.InitialStock)
    local l_t1 = tonumber(item.info.netInfo.buyCount)
    local l_t2 = tonumber(item.info.netInfo.sellCount)
    local l_t6 = item.info.netInfo.modifiedFactor

    local l_minPrice = item.info.tableInfo.PriceLimit[0]
    local l_maxPrice = item.info.tableInfo.PriceLimit[1]

    local l_isNotice = item.info.netInfo.isNotice
    local l_symbol = item.info.tableInfo.PriceType
    local l_func = "Sell"
    if l_isNotice then
        l_symbol = item.info.tableInfo.PublicityPriceType
        l_func = "PublicitySell"
    end

    local l_id = item.info.tableInfo.CommoditID
    local l_sellTax = item.info.tableInfo.SellTax
    local l_tax2 = item.info.tableInfo.NormalTax
    local l_uid = item.uid
    local l_target = self:_getBagItemByUID(l_uid)
    local l_avgprice = 0
    if l_target ~= nil and l_target.Price ~= nil then
        l_avgprice = tonumber(l_target.Price)
    end

    local l_expectPrice, l_range = self.tradeMgr.GetExpectAndRange(l_id)
    local l_const = 0
    if l_isNotice then
        l_const = PriceFunction[l_func](l_symbol, l_n, l_p2, l_avgprice, l_sellTax, l_tax2)
    else
        l_const = PriceFunction[l_func](l_symbol, l_n, l_p0, l_p1, l_s0, l_t1, l_t2, 0, l_avgprice, l_sellTax, l_minPrice, l_maxPrice, l_expectPrice, l_range, l_t6, nil, l_tax2)
    end

    self.panel.SellPriceCount.LabText = tostring(math.modf(l_const + 0.5))
    self.panel.SellCount.LabText = math.modf(item.info.netInfo.curPrice + 0.5)
    local l_itemRow = TableUtil.GetItemTable().GetRowByItemID(l_id)
    self.panel.SellName.LabText = l_itemRow.ItemName
    self.panel.SellItemBtn:AddClick(function()
        if limit then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Common.Utils.Lang("TRADE_LIMIT_SELL"), l_itemRow.ItemName))
            return
        end

        local l_isTalentEquip, l_name, l_c = MgrProxy:GetMultiTalentEquipMgr().IsInMultiTalentEquipWithUid(l_uid)
        if l_isTalentEquip then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Common.Utils.Lang("MultiTalent_EquipCantChangeWithStallSell"), l_name))
            return
        end

        self.tradeMgr.SendTradeSellItemReq(l_id, l_uid, l_count, false)
    end)
end
--[[
强制出售
--]]
function TradeHandler:Force2Sell()
    --TODO
    local l_id = l_curSellItem.info.tableInfo.CommoditID
    local l_uid = l_curSellItem.uid
    local l_value = MGlobalConfig:GetFloat("LimitUpSellingPrice") / 10000
    local l_itemRow = TableUtil.GetItemTable().GetRowByItemID(l_id)
    local l_str = RoColor.FormatWord(Lang("TRADE_ITEM_FORCE_TO_SELL", l_itemRow.ItemName, l_value))
    UIMgr:ActiveUI(UI.CtrlNames.TradeDialog, function(l_ui)
        l_ui:ShowDropStopTradeDialog(l_str,
                function()
                    local l_count = MLuaCommonHelper.Long2Int(self.panel.SellCountTarget.InputNumber:GetValue())
                    self.tradeMgr.SendTradeSellItemReq(l_id, l_uid, l_count, true)
                    UIMgr:DeActiveUI(UI.CtrlNames.TradeDialog)
                end,
                function()
                    UIMgr:DeActiveUI(UI.CtrlNames.TradeDialog)
                end)
    end)
end

--lua custom scripts end

return TradeHandler