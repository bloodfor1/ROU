--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/BaseUITemplate"
--lua requires end

--lua model
module("UITemplate", package.seeall)

--lua model end

--lua fields
local super = UITemplate.BaseUITemplate
--lua fields end

--lua class define
---@class AuctionItemParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Time MoonClient.MLuaUICom
---@field Select MoonClient.MLuaUICom
---@field PriceIcon MoonClient.MLuaUICom
---@field PriceCount MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field ItemIcon MoonClient.MLuaUICom
---@field IsBid MoonClient.MLuaUICom
---@field Highest MoonClient.MLuaUICom
---@field Exceed MoonClient.MLuaUICom
---@field BidCancel MoonClient.MLuaUICom
---@field BackBtn MoonClient.MLuaUICom
---@field AutoBidBtn MoonClient.MLuaUICom

---@class AuctionItem : BaseUITemplate
---@field Parameter AuctionItemParameter

AuctionItem = class("AuctionItem", super)
--lua class define end

--lua functions
function AuctionItem:Init()
	
	super.Init(self)
	    self.auctionMgr = MgrMgr:GetMgr("AuctionMgr")
	    self.Parameter.BackBtn:AddClick(function()
	        if self.auctionItemData then
	            self.MethodCallback(self.ShowIndex, self.auctionItemData.uid)
	        end
	    end)
	    self.Parameter.AutoBidBtn.Listener.onDown=function(go,eventData)
	        if self.auctionItemData then
	            --钱币图标
	            local l_itemInfo = TableUtil.GetItemTable().GetRowByItemID(self.auctionItemData.moneyId)
				local priceCountText=MNumberFormat.GetNumberFormat(self.auctionItemData.myBidPrice)
	            local l_msg = Lang("AUCTION_AUTO_BID", priceCountText, Lang("RICH_IMAGE", l_itemInfo.ItemIcon, l_itemInfo.ItemAtlas, 20, 1))
	            MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(l_msg, eventData, Vector2(0, 0), true)
	        end
	    end
	    self.itemTemplate = self:NewTemplate("ItemTemplate",{
	        TemplateParent = self.Parameter.ItemIcon.transform
	    })
	    self.timeTimer = self:NewUITimer(function()
	        self:RefreshTime()
	    end, 0.3, -1, true)
	    self.timeTimer:Start()
	    self:OnDeselect()
	
end --func end
--next--
function AuctionItem:BindEvents()
	
	
end --func end
--next--
function AuctionItem:OnDestroy()
	
	    if self.timeTimer then
			self:StopUITimer(self.timeTimer)
	        self.timeTimer = nil
	    end
	
end --func end
--next--
function AuctionItem:OnDeActive()
	
	
end --func end
--next--
function AuctionItem:OnSetData(data)
	
	self.auctionItemData = data
	    if self.auctionItemData.itemTableInfo then
	        self.Parameter.Name.LabText = self.auctionItemData.itemTableInfo.ItemName
	    end
	    local l_isBid = self.auctionMgr.IsBidedState(self.auctionItemData.billState)
	    self.Parameter.IsBid:SetActiveEx(l_isBid
	            and self.auctionItemData.billState ~= AuctionBillState.kAuctionBillStateBibBeOvertaken
	            and self.auctionItemData.billState ~= AuctionBillState.kAuctionBillStateCancelBib)
	    self.Parameter.PriceCount.LabText = self.auctionItemData.curBidPrice
	    local l_isHighest = self.auctionItemData.billState == AuctionBillState.kAuctionBillStateAutoBib or self.auctionItemData.billState == AuctionBillState.kAuctionBillStateManualBib
	    local l_isBidCancel = self.auctionItemData.billState == AuctionBillState.kAuctionBillStateCancelBib
	    self.Parameter.Highest:SetActiveEx(l_isHighest)
	    self.Parameter.AutoBidBtn:SetActiveEx(self.auctionItemData.billState == AuctionBillState.kAuctionBillStateAutoBib)
	    LayoutRebuilder.ForceRebuildLayoutImmediate(self.Parameter.Highest.transform)
	    self.Parameter.Exceed:SetActiveEx(self.auctionItemData.billState == AuctionBillState.kAuctionBillStateBibBeOvertaken)
	    self.Parameter.BidCancel:SetActiveEx(l_isBidCancel)
	    self.itemTemplate:SetData({ID = self.auctionItemData.itemId, Count = self.auctionItemData.count, IsShowTips = true})
	    local l_row = TableUtil.GetItemTable().GetRowByItemID(self.auctionItemData.moneyId)
	    if l_row then
	        self.Parameter.PriceIcon:SetSprite(l_row.ItemAtlas, l_row.ItemIcon)
	    end
	    self:RefreshTime()
	
end --func end
--next--
--lua functions end

--lua custom scripts
function AuctionItem:IsInitAndSameItem(itemId)
    return self.auctionItemData and self.auctionItemData.isInit and self.auctionItemData.itemId == itemId
end

function AuctionItem:IsUidEqual(uid)
    return self.auctionItemData and self.auctionItemData.uid == uid
end

function AuctionItem:GetUid()
    return self.auctionItemData and self.auctionItemData.uid
end

function AuctionItem:RefreshTime()
    local l_time, l_color = self:GetAuctionTimeDesAndColor()
    self.Parameter.Time.LabText = l_time
    self.Parameter.Time.LabColor = l_color
end

function AuctionItem:OnSelect()
    self.Parameter.Select:SetActiveEx(true)
end

function AuctionItem:OnDeselect()
    self.Parameter.Select:SetActiveEx(false)
end

function AuctionItem:GetAuctionTimeDesAndColor()
    local l_color = RoColor.Hex2Color(RoColor.WordColor.None[1])
    if not self.auctionItemData then return "", l_color end
    if self.auctionItemData.isInAuction then
        local l_curTimestamp = Common.TimeMgr.GetNowTimestamp()
        local l_leftTime = self.auctionItemData.endTimeStamp - l_curTimestamp
        if l_leftTime < MGlobalConfig:GetInt("AuctionExtendTime") then
            l_color = RoColor.Hex2Color(RoColor.WordColor.Red[1])
        end
        return Common.TimeMgr.GetSecondToHMS(l_leftTime), l_color
    else
        return Lang("AUCTION_NOT_BEGIN"), l_color
    end
end
--lua custom scripts end
return AuctionItem