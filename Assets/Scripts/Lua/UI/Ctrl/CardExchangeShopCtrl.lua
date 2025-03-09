--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/CardExchangeShopPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
---@class CardExchangeShopCtrl : UIBaseCtrl
CardExchangeShopCtrl = class("CardExchangeShopCtrl", super)
--lua class define end

--lua functions
function CardExchangeShopCtrl:ctor()

    super.ctor(self, CtrlNames.CardExchangeShop, UILayer.Function, nil, ActiveType.Exclusive)
    self.IsGroup = true

end --func end
--next--
function CardExchangeShopCtrl:Init()

    self.panel = UI.CardExchangeShopPanel.Bind(self)
    super.Init(self)

    self.mallMgr = MgrMgr:GetMgr("MallMgr")
    self.cardExchangeShopMgr = MgrMgr:GetMgr("CardExchangeShopMgr")
    self.currentShopId = self.cardExchangeShopMgr.LowCardExchangeShopId
    self.isClickRefreshButton = false

    self.shopItemPool = self:NewTemplatePool({
        TemplateClassName = "CardExchangeItemTemplate",
        ScrollRect = self.panel.CardItemScroll.LoopScroll,
        TemplatePrefab = self.panel.CardExchangeItemPrefab.gameObject,
    })

    self.panel.LowCardToggle:OnToggleExChanged(function(value)
        if value == true then
            self:_showLowCardShow()
        end
    end)
    self.panel.LowCardToggle.TogEx.isOn = true

    self.panel.HighCardToggle:OnToggleExChanged(function(value)
        if value == true then
            self:_showHighCardShow()
        end
    end)

    self.panel.RefreshPriceText.LabText = tostring(self.cardExchangeShopMgr.RefreshCost[1])

    self.panel.ShowCardInfoButton:AddClickWithLuaSelf(self._onShowCardInfoButton, self)
    self.panel.HideCardInfoButton:AddClickWithLuaSelf(self._onHideCardInfoButton, self)
    self.panel.ShowDetailsButton.Listener:SetActionClick(self._onShowDetailsButton, self)
    self.panel.CloseButton:AddClickWithLuaSelf(self._onCloseButton, self)
    self.panel.RefreshButton:AddClickWithLuaSelf(self._onRefreshButton, self)

    self.cacheEffectTexture=nil
    self.cacheEffectTextureMaterial=nil

    local l_fxData = {}
    l_fxData.rawImage = self.panel.CacheEffectRawImage.RawImg
    l_fxData.loadedCallback = function(go)
        self:_cacheEffectLoadedCallback()
    end
    self.fxId = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/Fx_Ui_ShiKongShangRen_KaPian_01",l_fxData)



end --func end
--next--
function CardExchangeShopCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil
    self.fxId=nil
    self.cacheEffectTexture=nil
    self.cacheEffectTextureMaterial=nil

end --func end
--next--
function CardExchangeShopCtrl:OnActive()
    self.isClickRefreshButton = false

end --func end
--next--
function CardExchangeShopCtrl:OnDeActive()


end --func end
--next--
function CardExchangeShopCtrl:Update()


end --func end
--next--
function CardExchangeShopCtrl:BindEvents()
    self:BindEvent(self.mallMgr.EventDispatcher, self.mallMgr.Event.ResetData, self._refreshShopWithId)
    self:BindEvent(self.mallMgr.EventDispatcher, self.mallMgr.Event.FreshMallItemEvent, self._onRefreshShopEvent)

end --func end
--next--
--lua functions end

--lua custom scripts

function CardExchangeShopCtrl:_onRefreshShopEvent()
    self.isClickRefreshButton = false
end

function CardExchangeShopCtrl:_refreshShopWithId(shopId)
    if self.currentShopId ~= shopId then
        return
    end
    self:_refreshShop()
end

function CardExchangeShopCtrl:_refreshShop()

    if self.cacheEffectTexture == nil then
        return
    end

    local l_refresh, l_data = self.mallMgr.GetMallData(self.currentShopId, true)
    if l_refresh then
        return
    end
    if l_data.data == nil then
        logError("l_data.data == nil")
        return
    end
    self.panel.ShowCardInfoButton:SetActiveEx(true)
    self.panel.HideCardInfoButton:SetActiveEx(false)
    MgrMgr:GetMgr("CardExchangeShopMgr").IsShowCardInfo = false
    self.isClickRefreshButton = false
    local additionalData = {}
    additionalData.CurrentShopId = self.currentShopId
    additionalData.EffectTexture = self.cacheEffectTexture
    additionalData.EffectTextureMaterial = self.cacheEffectTextureMaterial
    self.shopItemPool:ShowTemplates({ Datas = l_data.data, AdditionalData = additionalData })

    local refreshCount = self:_getRefreshCount()

    if refreshCount == 0 then
        self.panel.RefreshPriceGameObject:SetActiveEx(false)
        self.panel.FreeText:SetActiveEx(true)
    else
        self.panel.RefreshPriceGameObject:SetActiveEx(true)
        self.panel.FreeText:SetActiveEx(false)
    end
end

function CardExchangeShopCtrl:_showLowCardShow()
    self.currentShopId = self.cardExchangeShopMgr.LowCardExchangeShopId
    self:_refreshShop()
end
function CardExchangeShopCtrl:_showHighCardShow()
    self.currentShopId = self.cardExchangeShopMgr.HighCardExchangeShopId
    self:_refreshShop()
end

function CardExchangeShopCtrl:_onShowCardInfoButton()
    self.panel.ShowCardInfoButton:SetActiveEx(false)
    self.panel.HideCardInfoButton:SetActiveEx(true)
    MgrMgr:GetMgr("CardExchangeShopMgr").IsShowCardInfo = true
    self.cardExchangeShopMgr.EventDispatcher:Dispatch(self.cardExchangeShopMgr.ShowAllCardInfoEvent)
end

function CardExchangeShopCtrl:_onHideCardInfoButton()
    self.panel.ShowCardInfoButton:SetActiveEx(true)
    self.panel.HideCardInfoButton:SetActiveEx(false)
    MgrMgr:GetMgr("CardExchangeShopMgr").IsShowCardInfo = false
    self.cardExchangeShopMgr.EventDispatcher:Dispatch(self.cardExchangeShopMgr.HideAllCardInfoEvent)
end
function CardExchangeShopCtrl:_onShowDetailsButton(go, eventData)
    local l_anchor = Vector2.New(0.5, 1)
    local pos = Vector2.New(eventData.position.x, eventData.position.y)
    eventData.position = pos
    MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(Common.Utils.Lang("Space_Card_Description"), eventData, l_anchor)
end
function CardExchangeShopCtrl:_onCloseButton()
    self:Close()
end

function CardExchangeShopCtrl:_getRefreshCount()
    local limitBuyMgr = MgrMgr:GetMgr("LimitBuyMgr")
    local limitDataByKey = limitBuyMgr.GetCountDataByKey(limitBuyMgr.g_limitType.CardExchangeShopRefreshCount, "1")
    local refreshCount = 0
    if limitDataByKey then
        refreshCount = limitDataByKey.limt - limitDataByKey.count
    end
    if refreshCount == nil then
        refreshCount = 0
    end
    return refreshCount
end
function CardExchangeShopCtrl:_onRefreshButton()
    if self.isClickRefreshButton then
        return
    end
    local refreshCount = self:_getRefreshCount()
    if refreshCount == 0 then
        self:_requestFreshMallItem()
    else
        local refreshItemId = self.cardExchangeShopMgr.RefreshCost[0]
        local l_itemInfo = TableUtil.GetItemTable().GetRowByItemID(refreshItemId)
        local refreshMoneyCount = self.cardExchangeShopMgr.RefreshCost[1]
        local yesNoTest = Common.Utils.Lang("CardExchangeShop_RefreshShopTipsText", refreshMoneyCount, l_itemInfo.ItemName)
        CommonUI.Dialog.ShowYesNoDlg(true, nil, yesNoTest, function()
            self:_requestFreshMallItem()
        end, nil, nil, 2, "CardExchangeShop_RefreshShopTipsText")
    end
end

function CardExchangeShopCtrl:_requestFreshMallItem()
    self.isClickRefreshButton = true
    local mallIdTable = {}
    table.insert(mallIdTable, self.cardExchangeShopMgr.LowCardExchangeShopId)
    table.insert(mallIdTable, self.cardExchangeShopMgr.HighCardExchangeShopId)
    self.mallMgr.RequestFreshMallItem(mallIdTable)
end

function CardExchangeShopCtrl:_cacheEffectLoadedCallback()
    self.panel.CacheEffectRawImage:SetActiveEx(false)
    self.cacheEffectTexture=self.panel.CacheEffectRawImage.RawImg.texture
    self.cacheEffectTextureMaterial=self.panel.CacheEffectRawImage.RawImg.material
    self:_refreshShop()
end
--lua custom scripts end
return CardExchangeShopCtrl