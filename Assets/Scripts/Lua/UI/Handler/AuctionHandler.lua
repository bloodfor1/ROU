--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseHandler"
require "UI/Panel/AuctionPanel"
require "UI/Template/AuctionItem"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseHandler
--lua fields end

--lua class define
AuctionHandler = class("AuctionHandler", super)
--lua class define end

--lua functions
function AuctionHandler:ctor()
	
	super.ctor(self, HandlerNames.Auction, 0)
	
end --func end
--next--
function AuctionHandler:Init()
	
	self.panel = UI.AuctionPanel.Bind(self)
	super.Init(self)

    self.auctionMgr = MgrMgr:GetMgr("AuctionMgr")

    -- 当前显示的分类
    self.showAuctionIndex = nil
    -- 当前展示的物品
    self.showAuctionItemUid = nil
    -- 当前页
    self.curPage = 1
    -- 最大页数
    self.maxPage = 1
    -- 每页数量
    self.perPage = 10

    self.isTogPanelInit = false

    self.panel.BtnTips:AddClick(function()
        local l_content = Common.Utils.Lang("AUCTION_TIPS")
        l_content = MgrMgr:GetMgr("RichTextFormatMgr").FormatRichTextContent(l_content)
        MgrMgr:GetMgr("TipsMgr").ShowExplainPanelTips({
            content = l_content,
            alignment = UnityEngine.TextAnchor.UpRight,
            pos = {
                x = 360,
                y = 40,
            },
            width = 400,
        })
    end)

    -- 商品说明
    self.panel.BtnExplain:AddClick(function()
        UIMgr:ActiveUI(UI.CtrlNames.AuctionCommodityDescription)
    end)

    -- 关注
    self.panel.FollowBtn:AddClick(function()
        local l_auctionItemData = self.auctionMgr.GetAuctionDataByUid(self.showAuctionItemUid)
        if l_auctionItemData then
            self.auctionMgr.AuctionFollowItem(l_auctionItemData.itemId, false)
        end
    end)
    -- 取消关注
    self.panel.UnFollowBtn:AddClick(function()
        local l_auctionItemData = self.auctionMgr.GetAuctionDataByUid(self.showAuctionItemUid)
        if l_auctionItemData then
            self.auctionMgr.AuctionFollowItem(l_auctionItemData.itemId, true)
        end
    end)

    -- 上一页
    self.panel.BtnPageUp:AddClick(function()
        self:SetPage(self.curPage - 1)
    end)
    -- 下一页
    self.panel.BtnPageDown:AddClick(function()
        self:SetPage(self.curPage + 1)
    end)

    -- 仅显示已关注
    self.panel.ShowFollowTog.Tog.isOn = false
    self.panel.ShowFollowTog.Tog.onValueChanged:AddListener(function(isOn)
        self:RefreshAuctionItems()
    end)

    -- 加价倍数
    self.panel.PriceFactor.InputNumber.OnValueChange = function(value)
        self:RefreshDetail()
    end

    -- 确认出价
    self.panel.BidConfirmBtn:AddClick(function()
        if not self.showAuctionItemUid then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("AUCTION_SELECT"))
            return
        end
        local l_auctionItemData = self.auctionMgr.GetAuctionDataByUid(self.showAuctionItemUid)
        if l_auctionItemData then
            local l_price = l_auctionItemData.curBidPrice + l_auctionItemData.auctionTableInfo.BaseRaisePrice[1] * tonumber(self.panel.PriceFactor.InputNumber:GetValue())
            --if l_auctionItemData.moneyId == 102 and MPlayerInfo.ZenyCoin < l_price then
            --    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("ZENY_NOT_ENOUGH"))
            --    return
            --elseif l_auctionItemData.moneyId == 103 and MPlayerInfo.Diamond < l_price then
            --    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("DIAMOND_NOT_ENOUGH"))
            --    return
            --end

            local l_isAutoBid = self.panel.AutoBidTog.Tog.isOn

            local l_finalBidFunc = function()
                local  l_bidStr = ""
                if self.panel.AutoBidTog.Tog.isOn then
                    l_bidStr = Lang("AUCTION_AUTO_BID_TEXT")
                end
                if self.panel.ManualBidTog.Tog.isOn then
                    l_bidStr = Lang("AUCTION_MANUAL_BID_TEXT")
                end
                --钱币图标
                local l_itemInfo = TableUtil.GetItemTable().GetRowByItemID(l_auctionItemData.moneyId)
                local l_msg = Lang("AUCTION_BID_PRICE", l_auctionItemData.itemTableInfo.ItemName, l_bidStr, l_price, Lang("RICH_IMAGE", l_itemInfo.ItemIcon, l_itemInfo.ItemAtlas, 20, 1))
                CommonUI.Dialog.ShowYesNoDlg(true, nil, l_msg, function()
                    self.auctionMgr.AuctionItemBid(l_auctionItemData.uid, l_isAutoBid, l_price)
                end)
            end

            local l_isSelfBid = l_auctionItemData.billState == AuctionBillState.kAuctionBillStateAutoBib or l_auctionItemData.billState == AuctionBillState.kAuctionBillStateManualBib
            local l_bidedFunc = function()
                -- 已出价，是否继续出价
                if l_isSelfBid then
                    CommonUI.Dialog.ShowYesNoDlg(true, nil, Lang("AUCTION_BID_CONTINUE"), function()
                        l_finalBidFunc()
                    end)
                else
                    l_finalBidFunc()
                end
            end

            -- 是否存在未被出价的相同物品
            local l_item = self.auctionItemPool:FindShowTem(function(item)
                return item:IsInitAndSameItem(l_auctionItemData.itemId)
            end)
            if not l_auctionItemData.isInit and not l_isSelfBid and l_item then
                CommonUI.Dialog.ShowYesNoDlg(true, nil, Lang("AUCTION_BID_GOTO_ANOTHER"), function()
                    if not self.panel then return end

                    self.auctionItemPool:SelectTemplate(l_item.ShowIndex)
                    self.auctionItemPool:ScrollToCell(l_item.ShowIndex, 2000)
                    self:OnSelectItem(l_item:GetUid())
                    self:RefreshDetail()
                end, l_bidedFunc)
            else
                l_bidedFunc()
            end

        end
    end)

    -- 取消出价
    self.panel.BidCancelBtn:AddClick(function()
        local l_auctionItemData = self.auctionMgr.GetAuctionDataByUid(self.showAuctionItemUid)
        if l_auctionItemData then
            CommonUI.Dialog.ShowYesNoDlg(true, nil, Lang("AUCTION_BID_CANCEL_IF"), function()
                self.auctionMgr.AuctionBillCancel(l_auctionItemData.uid)
            end)
        end
    end)

    self.isBidTogSilent = false
    -- 默认自动出价处理
    self.panel.AutoBidTog.Tog.onValueChanged:AddListener(function(isOn)
        if isOn then
            DataMgr:GetData("AuctionData").isAutoBidSelected = true
            if not self.isBidTogSilent then
                self:RefreshDetail()
            end
            if tonumber(self.panel.PriceFactor.InputNumber:GetValue()) <= 1 then
                self:ResetBidTog()
            end
        end
    end)
    self.panel.ManualBidTog.Tog.onValueChanged:AddListener(function(isOn)
        if isOn then
            DataMgr:GetData("AuctionData").isAutoBidSelected = false
            if not self.isBidTogSilent then
                self:RefreshDetail()
            end
            if tonumber(self.panel.PriceFactor.InputNumber:GetValue()) <= 1 then
                self:ResetBidTog()
            end
        end
    end)
    self.panel.ManualBidTogDisableBtn:AddClick(function()
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("AUCTION_NOT_MANUAL_BID"))
    end)


    self.auctionItemPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.AuctionItem,
        TemplatePrefab = self.panel.AuctionItem.LuaUIGroup.gameObject,
        ScrollRect = self.panel.AuctionItemScroll.LoopScroll,
        Method = function(index, itemUid)
            self.auctionItemPool:SelectTemplate(index)
            self:OnSelectItem(itemUid)
        end
    })

    -- 请求数据
    self.auctionMgr.GetAuctionInfo()

    self:RefreshAuctionItems()

    self:RefreshPageUI()

    -- 心跳
    self.auctionMgr.AuctionKeepAliveNotify()
    self.beatTimer = self:NewUITimer(function()
        self.auctionMgr.AuctionKeepAliveNotify()
    end, 20, -1, true)
    self.beatTimer:Start()
end --func end
--next--
function AuctionHandler:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function AuctionHandler:OnActive()
	
	self.panel.BidText.LabText = Lang("AUCTION_MANUAL_BID_TEXT")
end --func end
--next--
function AuctionHandler:OnDeActive()
    if self.beatTimer then
        self:StopUITimer(self.beatTimer)
        self.beatTimer = nil
    end
end --func end
--next--
function AuctionHandler:Update()
	self.panel.AuctionTime.LabText = self:GetAuctionTimeDes()
	
end --func end
--next--
function AuctionHandler:BindEvents()
    self:BindEvent(self.auctionMgr.EventDispatcher, self.auctionMgr.EEventType.AuctionItemRefresh, function()
        self:RefreshAuctionItems()
        self:InitTogPanel()
        self:RefreshTogsVisible()
    end)
    self:BindEvent(self.auctionMgr.EventDispatcher, self.auctionMgr.EEventType.AuctionItemFollowRefresh, function()
        self:RefreshDetail()
    end)
    self:BindEvent(self.auctionMgr.EventDispatcher, self.auctionMgr.EEventType.BilledItemRefresh, function()
        self:RefreshAuctionItems()
    end)

    self:BindEvent(self.auctionMgr.EventDispatcher, self.auctionMgr.EEventType.AuctionItemUpdateList, function(_, updateDatas)
        -- 单个刷新每一个物品
        for _, data in ipairs(updateDatas) do
            local l_item = self.auctionItemPool:FindShowTem(function(item)
                return item:IsUidEqual(data.uid)
            end)
            if l_item then
                l_item:SetData(data)
                self:RefreshDetail()
            end
        end
    end)
end --func end
--next--
--lua functions end

--lua custom scripts

function AuctionHandler:InitTogPanel()
    if self.isTogPanelInit then return end
    self.isTogPanelInit = true

    self.panel.TogPanel.TogPanel.OnTogOn = function(index)
        self:OnIndexSelected(index)
    end
    local l_firstParentIndex = nil
    local l_firstChildIndex = nil
    local l_notEmptyState = self.auctionMgr.GetIndexNotEmptyState()
    for _, parentIndex in ipairs(self.auctionMgr.auctionParentIndexList) do
        if not l_firstParentIndex and l_notEmptyState[parentIndex.index] then l_firstParentIndex = parentIndex.index end
        local l_indexList = {}
        local l_nameList = {}
        table.insert(l_indexList, parentIndex.index)
        table.insert(l_nameList, parentIndex.name)
        for _, childIndex in ipairs(parentIndex.childIndexList) do
            if l_firstParentIndex == parentIndex.index and not l_firstChildIndex then l_firstChildIndex = childIndex.index end
            table.insert(l_indexList, childIndex.index)
            table.insert(l_nameList, childIndex.name)
        end
        self.panel.TogPanel.TogPanel:AddTogGroup(l_indexList, l_nameList)
    end

    if self.auctionMgr.lastSelectIndex and self.panel.TogPanel.TogPanel:IsIndexVisible(self.auctionMgr.lastSelectIndex) then
        self.panel.TogPanel.TogPanel:SetTogOn(self.auctionMgr.lastSelectIndex)
    else
        -- 默认选中第一个非空
        if l_firstChildIndex then
            self.panel.TogPanel.TogPanel:SetTogOn(l_firstChildIndex)
        elseif l_firstParentIndex then
            self.panel.TogPanel.TogPanel:SetTogOn(l_firstParentIndex)
        end
    end

    self:RefreshTogsVisible()
end

function AuctionHandler:RefreshTogsVisible()
    local l_notEmptyState = self.auctionMgr.GetIndexNotEmptyState()
    -- 一些选项需要隐藏
    local l_indexVisible = {}
    for _, parentIndex in ipairs(self.auctionMgr.auctionParentIndexList) do
        l_indexVisible[parentIndex.index] = parentIndex.index < 0 or not not l_notEmptyState[parentIndex.index]
        for _, childIndex in ipairs(parentIndex.childIndexList) do
            l_indexVisible[childIndex.index] = not not l_notEmptyState[childIndex.index]
        end
    end
    for index, visible in pairs(l_indexVisible) do
        self.panel.TogPanel.TogPanel:SetIndexVisible(index, visible)
    end
end

function AuctionHandler:OnIndexSelected(index)
    if index > 0 and self.auctionMgr.IsParentIndex(index) then return end
    -- logError(index)
    if self.showAuctionIndex ~= index then
        -- 清空选择
        self.auctionItemPool:CancelSelectTemplate()
        self:OnSelectItem(nil)
    end
    DataMgr:GetData("AuctionData").lastSelectIndex = index
    self.showAuctionIndex = index
    self.curPage = 1
    self:RefreshAuctionItems()
end

function AuctionHandler:OnSelectItem(itemUid)
    self.showAuctionItemUid = itemUid
    self:RefreshDetail()
end

function AuctionHandler:RefreshAuctionItems()
    local l_conFunc = nil
    if self.panel.ShowFollowTog.Tog.isOn then
        l_conFunc = function(itemData)
            return self.auctionMgr.IsFollow(itemData.itemId)
        end
    end
    local l_itemDatas, l_itemNum = self.auctionMgr.GetAuctionItemsSorted(self.showAuctionIndex, l_conFunc)
    local l_itemNum = #l_itemDatas
    self.maxPage = math.ceil(l_itemNum / self.perPage)
    if self.maxPage == 0 then self.maxPage = 1 end
    self.curPage = math.min(self.curPage, self.maxPage)

    local l_bI = (self.curPage - 1) * self.perPage + 1
    local l_eI = l_bI + self.perPage - 1
    local l_itemDatasByPage = {}
    for i = l_bI, l_eI do
        table.insert(l_itemDatasByPage, l_itemDatas[i])
    end

    self:RefreshPageUI()
    self.auctionItemPool:ShowTemplates({Datas = l_itemDatasByPage})

    self:RefreshDetail()
end

function AuctionHandler:ResetBidTog()
    local l_auctionItemData = self.auctionMgr.GetAuctionDataByUid(self.showAuctionItemUid)
    if l_auctionItemData and tonumber(self.panel.PriceFactor.InputNumber:GetValue()) <= 1 then
        local l_initInputNum = 1
        if l_auctionItemData.isInit and self.panel.ManualBidTog.Tog.isOn then
            l_initInputNum = 0
        end
        self.panel.PriceFactor.InputNumber.MinValue = l_initInputNum
        self.panel.PriceFactor.InputNumber.MaxValue = MGlobalConfig:GetInt("AuctionRaiseMultipleLimit")
        self.panel.PriceFactor.InputNumber:SetValue(l_initInputNum)
    end
end

function AuctionHandler:RefreshDetail()
    local l_auctionItemData = self.auctionMgr.GetAuctionDataByUid(self.showAuctionItemUid)
    local l_hasItem = l_auctionItemData ~= nil
    self.panel.ItemInfo:SetActiveEx(l_hasItem)
    self.panel.ItemEmpty:SetActiveEx(not l_hasItem)
    local l_itemNum = #self.auctionItemPool:getDatas()
    if l_itemNum == 0 then
        self.panel.ItemEmptyText.LabText = Lang("TRADE_BUY_EMPTY")
    else
        self.panel.ItemEmptyText.LabText = Lang("TRADE_BUY_SELECT")
    end
    if l_auctionItemData then
        self.panel.ManualBidTogDisableBtn:SetActiveEx(not l_auctionItemData.isInAuction)
        if not l_auctionItemData.isInAuction then
            self.isBidTogSilent = true
            self.panel.AutoBidTog.Tog.isOn = true
            self.panel.ManualBidTog.Tog.isOn = false
            self.isBidTogSilent = false
        else
            self.isBidTogSilent = true
            self.panel.AutoBidTog.Tog.isOn = DataMgr:GetData("AuctionData").isAutoBidSelected
            self.panel.ManualBidTog.Tog.isOn = not DataMgr:GetData("AuctionData").isAutoBidSelected
            self.isBidTogSilent = false
        end
        if self.panel.AutoBidTog.Tog.isOn then
            self.panel.BidText.LabText = Lang("AUCTION_AUTO_BID_TEXT")
        end
        if self.panel.ManualBidTog.Tog.isOn then
            self.panel.BidText.LabText = Lang("AUCTION_MANUAL_BID_TEXT")
        end
        if l_auctionItemData.itemTableInfo then
            self.panel.ItemName.LabText = l_auctionItemData.itemTableInfo.ItemName
        end
        if l_auctionItemData.auctionTableInfo then
            self.panel.BasePrice.LabText = l_auctionItemData.auctionTableInfo.BaseRaisePrice[1]
            if self.lastRefreshDetailUid ~= self.showAuctionItemUid or (not l_auctionItemData.isInit and tonumber(self.panel.PriceFactor.InputNumber:GetValue()) == 0) then
                self:ResetBidTog()
            end
            local l_price = l_auctionItemData.curBidPrice + l_auctionItemData.auctionTableInfo.BaseRaisePrice[1] * tonumber(self.panel.PriceFactor.InputNumber:GetValue())
            self.panel.FinalPrice.LabText = l_price
        end
        -- 关注状态
        local l_isFollow = self.auctionMgr.IsFollow(l_auctionItemData.itemId)
        self.panel.FollowBtn:SetActiveEx(l_isFollow)
        self.panel.UnFollowBtn:SetActiveEx(not l_isFollow)

        -- 详细信息
        self.panel.DetailDes.LabText = MgrMgr:GetMgr("ItemPropertiesMgr").GetDetailInfo(l_auctionItemData.itemId)
        Common.CommonUIFunc.CalculateLowLevelTipsInfo(self.panel.DetailDes)
        --强制刷新content大小
        LayoutRebuilder.ForceRebuildLayoutImmediate(self.panel.DetailDes.RectTransform.parent)
        --重置位置
        self.panel.DetailDes.RectTransform.parent.anchoredPosition = Vector3.New(0, 0, 0)

        -- 设置货币图片
        local l_row = TableUtil.GetItemTable().GetRowByItemID(l_auctionItemData.moneyId)
        if l_row then
            self.panel.BasePriceIcon:SetSprite(l_row.ItemAtlas, l_row.ItemIcon)
            self.panel.FinalPriceIcon:SetSprite(l_row.ItemAtlas, l_row.ItemIcon)
        end

        self.panel.BidCancelBtn:SetActiveEx(l_auctionItemData.billState == AuctionBillState.kAuctionBillStateAutoBib and not self:IsAuctionBegin())
    else
        self.panel.BasePrice.LabText = 0
        self.panel.PriceFactor.InputNumber.MinValue = 0
        self.panel.PriceFactor.InputNumber.MaxValue = 0
        self.panel.PriceFactor.InputNumber:SetValue(0)
        self.panel.FinalPrice.LabText = 0

        self.panel.BidCancelBtn:SetActiveEx(false)
    end

    self.lastRefreshDetailUid = self.showAuctionItemUid
end

function AuctionHandler:SetPage(page)
    if page < 1 or page > self.maxPage then return end
    self.curPage = page
    self:RefreshPageUI()
    self:RefreshAuctionItems()

    -- 翻页时维持当前选择
    local l_item = self.auctionItemPool:FindShowTem(function(item)
        return item:IsUidEqual(self.showAuctionItemUid)
    end)
    if l_item then
        self.auctionItemPool:SelectTemplate(l_item.ShowIndex)
    else
        self.auctionItemPool:CancelSelectTemplate()
    end
end

function AuctionHandler:RefreshPageUI()
    self.panel.PageText.LabText = self.curPage .. "/" .. self.maxPage
end

-- 拍卖是否开始
function AuctionHandler:IsAuctionBegin()
    local l_curTimestamp = Common.TimeMgr.GetLocalNowTimestamp()
    local l_auctionBeginTimestamp = Common.TimeMgr.GetCustomTimestamp({hour = 20})
    return l_curTimestamp > l_auctionBeginTimestamp
end

function AuctionHandler:GetAuctionTimeDes()
    local l_auctionFinish = self.auctionMgr.IsAuctionItemsEmpty()
    local l_curTimestamp = Common.TimeMgr.GetLocalNowTimestamp()
    local l_refreshTimestamp = Common.TimeMgr.GetCustomTimestamp({hour = 5})
    local l_auctionBeginTimestamp = Common.TimeMgr.GetCustomTimestamp({hour = 20})
    if l_curTimestamp > l_refreshTimestamp and l_curTimestamp < l_auctionBeginTimestamp then
        return Lang("AUCTION_BEGIN_TIME", Common.TimeMgr.GetSecondToHMS(l_auctionBeginTimestamp - l_curTimestamp))
    elseif l_auctionFinish then
        local l_lastRefreshTimestamp = Common.TimeMgr.GetCustomTimestamp({hour = 5, dayOffset = 1})
        local l_leftTime = l_lastRefreshTimestamp - l_curTimestamp
        if l_leftTime > Common.TimeMgr.DAY_SECONDS then
            l_leftTime = l_leftTime - Common.TimeMgr.DAY_SECONDS
        end
        return Lang("AUCTION_REFRESH_TIME", Common.TimeMgr.GetSecondToHMS(l_leftTime))
    else
        return ""
    end
end

--lua custom scripts end
return AuctionHandler