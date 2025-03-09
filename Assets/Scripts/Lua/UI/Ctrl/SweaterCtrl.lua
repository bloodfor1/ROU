--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/SweaterPanel"


--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
SweaterCtrl = class("SweaterCtrl", super)
--lua class define end

--lua functions
function SweaterCtrl:ctor()

	super.ctor(self, CtrlNames.Sweater, UILayer.Function, UITweenType.UpAlpha, ActiveType.Exclusive)

end --func end
--next--
function SweaterCtrl:Init()
	self.panel = UI.SweaterPanel.Bind(self)
	super.Init(self)

    MgrMgr:GetMgr("StallMgr").g_init = false

    self.panel.CloseBtn:AddClick(function()
        UIMgr:DeActiveUI(CtrlNames.Sweater)
    end)

end --func end
--next--
function SweaterCtrl:Uninit()
	super.Uninit(self)
	self.panel = nil

    MgrMgr:GetMgr("StallMgr").g_init = false
    self.RedSignProcessor = nil
end --func end
--next--
function SweaterCtrl:OnActive()
    local l_sweaterMgr = MgrMgr:GetMgr("SweaterMgr")
    if self.uiPanelData and self.uiPanelData.openSweaterType then
        l_sweaterMgr.LastSweaterType = self.uiPanelData.openSweaterType
    end

    local l_openSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
    local l_isTradeOpen = l_openSystemMgr.IsSystemOpen(l_openSystemMgr.eSystemId.Trade)
    local l_isStallOpen = l_openSystemMgr.IsSystemOpen(l_openSystemMgr.eSystemId.Stall)
    local l_isAuctionOpen = l_openSystemMgr.IsSystemOpen(l_openSystemMgr.eSystemId.Auction)

    if l_sweaterMgr.LastSweaterType == l_sweaterMgr.ESweaterType.Trade then
        if l_isTradeOpen then
            self:SelectOneHandler(UI.HandlerNames.Trade)
        else
            l_sweaterMgr.LastSweaterType = l_sweaterMgr.ESweaterType.Stall
        end
    end
    if l_sweaterMgr.LastSweaterType == l_sweaterMgr.ESweaterType.Stall then
        if l_isStallOpen then
            self:SelectOneHandler(UI.HandlerNames.Stall)
        else
            l_sweaterMgr.LastSweaterType = l_sweaterMgr.ESweaterType.Auction
        end
    end
    if l_sweaterMgr.LastSweaterType == l_sweaterMgr.ESweaterType.Auction then
        if l_isAuctionOpen then
            self:SelectOneHandler(UI.HandlerNames.Auction)
        else
            l_sweaterMgr.LastSweaterType = l_sweaterMgr.ESweaterType.Trade
        end
    end
    
    UIMgr:ActiveUI(UI.CtrlNames.Currency, nil, {InsertPanelName = CtrlNames.Sweater})
end --func end
--next--
function SweaterCtrl:OnDeActive()


end --func end
--next--
--function SweaterCtrl:Update()
--
--	super.Update()
--
--end --func end



--next--
function SweaterCtrl:BindEvents()

	--dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts

function SweaterCtrl:SetupHandlers()
    local l_openSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
    local l_isTradeOpen = l_openSystemMgr.IsSystemOpen(l_openSystemMgr.eSystemId.Trade)
    local l_isStallOpen = l_openSystemMgr.IsSystemOpen(l_openSystemMgr.eSystemId.Stall)
    local l_isAuctionOpen = l_openSystemMgr.IsSystemOpen(l_openSystemMgr.eSystemId.Auction)
    local l_handlerTb = {}
    if l_isTradeOpen then
        table.insert(l_handlerTb, {HandlerNames.Trade, Lang("TRADE"),"CommonIcon","UI_CommonIcon_Tab_shanghui_01.png","UI_CommonIcon_Tab_shanghui_02.png"})
    end
    if l_isStallOpen then
        table.insert(l_handlerTb, {HandlerNames.Stall, Lang("STALL"),"CommonIcon","UI_CommonIcon_Tab_baitan_01.png","UI_CommonIcon_Tab_baitan_02.png"})
    end
    if l_isAuctionOpen then
        table.insert(l_handlerTb, {HandlerNames.Auction, Lang("AUCTION"),"CommonIcon","UI_CommonIcon_Tab_baitan_01.png","UI_CommonIcon_Tab_baitan_02.png"})
    end
    self:InitHandler(l_handlerTb, self.panel.ToggleTpl, nil, false)

    -- 红点
    local l_stallTogEx = self:GetHandlerTogExByName(UI.HandlerNames.Stall, true)
    if not self.RedSignProcessor and l_stallTogEx then
        self.RedSignProcessor = self:NewRedSign({
            Key = eRedSignKey.StallHandler,
            ClickTogEx = l_stallTogEx,
            RedSignParent = l_stallTogEx.gameObject.transform:Find("GameObject")
        })
    end
end


function SweaterCtrl:OnHandlerActive(handlerName)
    local l_sweaterMgr = MgrMgr:GetMgr("SweaterMgr")
    if handlerName == HandlerNames.Trade then
        l_sweaterMgr.LastSweaterType = l_sweaterMgr.ESweaterType.Trade
    elseif handlerName == HandlerNames.Stall then
        l_sweaterMgr.LastSweaterType = l_sweaterMgr.ESweaterType.Stall

        MgrMgr:GetMgr("StallMgr").g_init = true
        MgrMgr:GetMgr("StallMgr").RequestStallInfo()
    elseif handlerName == HandlerNames.Auction then
        l_sweaterMgr.LastSweaterType = l_sweaterMgr.ESweaterType.Auction
    end
end

--lua custom scripts end
return SweaterCtrl
