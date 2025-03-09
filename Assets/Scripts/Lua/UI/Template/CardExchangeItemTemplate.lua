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
---@class CardExchangeItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field CardParent MoonClient.MLuaUICom
---@field BuyButton MoonClient.MLuaUICom

---@class CardExchangeItemTemplate : BaseUITemplate
---@field Parameter CardExchangeItemTemplateParameter

CardExchangeItemTemplate = class("CardExchangeItemTemplate", super)
--lua class define end

--lua functions
function CardExchangeItemTemplate:Init()

    super.Init(self)
    self.mallTableInfo = nil
    self.data = nil
    self.currentShopId = 0
    self.cardExchangeShopMgr = MgrMgr:GetMgr("CardExchangeShopMgr")

    ---@type CardTemplate
    self.cardTemplate = self:NewTemplate("CardTemplate", {
        TemplateParent = self.Parameter.CardParent.transform,
    })

    self.Parameter.BuyButton:AddClickWithLuaSelf(self._onBuyButton, self)

end --func end
--next--
function CardExchangeItemTemplate:BindEvents()
    self:BindEvent(self.cardExchangeShopMgr.EventDispatcher, self.cardExchangeShopMgr.ShowAllCardInfoEvent, self._showCardInfo)
    self:BindEvent(self.cardExchangeShopMgr.EventDispatcher, self.cardExchangeShopMgr.HideAllCardInfoEvent, self._hideCardInfo)
    local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
    self:BindEvent(gameEventMgr.l_eventDispatcher, gameEventMgr.OnBagUpdate, self._showMoneyCount)

end --func end
--next--
function CardExchangeItemTemplate:OnDestroy()
    self.mallTableInfo = nil
    self.data = nil
    self.currentShopId = 0

end --func end
--next--
function CardExchangeItemTemplate:OnDeActive()


end --func end
--next--
function CardExchangeItemTemplate:OnSetData(data, additionalData)
    self.currentShopId = additionalData.CurrentShopId
    self:_showTemplate(data, additionalData)

end --func end
--next--
--lua functions end

--lua custom scripts
local CardExchangeItem_ShowUseTimeText="CardExchangeItem_ShowUseTimeText"
local CardExchangeShop_BuyShopItemNotEnoughTipsText="CardExchangeShop_BuyShopItemNotEnoughTipsText"
local CardExchangeShop_BuyShopItemTipsText="CardExchangeShop_BuyShopItemTipsText"
---@param data MallItem
function CardExchangeItemTemplate:_showTemplate(data,currentAdditionalData)
    self.data = data
    if data == nil then
        return
    end
    self.mallTableInfo = TableUtil.GetMallTable().GetRowByMajorID(data.seq_id, true)
    if self.mallTableInfo == nil then
        return
    end

    self:_showMoneyCount()

    local itemData = Data.BagApi:CreateLocalItemData(self.mallTableInfo.ItemID)
    local useTime = itemData:GetExistTime()
    useTime = useTime / 86400
    local cardTemplateData = {}
    cardTemplateData.ItemData = itemData
	local additionalData={}
	additionalData.ShowUseTimeText=Lang(CardExchangeItem_ShowUseTimeText, tostring(useTime))
    additionalData.IsShowCardInfo=MgrMgr:GetMgr("CardExchangeShopMgr").IsShowCardInfo
    additionalData.EffectTexture=currentAdditionalData.EffectTexture
    additionalData.EffectTextureMaterial=currentAdditionalData.EffectTextureMaterial

    self.cardTemplate:SetData(cardTemplateData,additionalData )
end

function CardExchangeItemTemplate:_showMoneyCount()
    local l_hasCoinNum = Data.BagApi:GetItemCountByContListAndTid({ GameEnum.EBagContainerType.Bag }, self.data.money_type)

    local color
    if l_hasCoinNum >= self.data.now_price then
        color = RoColorTag.Green
    else
        color = RoColorTag.Red
    end
    local moneyCountText = GetColorText(tostring(self.data.now_price), color)

    self.Parameter.MoneyCount.LabText = moneyCountText
end
function CardExchangeItemTemplate:_onBuyButton()
    if self.data == nil then
        return
    end
    local l_hasCoinNum = Data.BagApi:GetItemCountByContListAndTid({ GameEnum.EBagContainerType.Bag }, self.data.money_type)
    if l_hasCoinNum < self.data.now_price then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang(CardExchangeShop_BuyShopItemNotEnoughTipsText))
        MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(self.data.money_type, nil, nil, nil, true)
        return
    end
    local l_itemInfo = TableUtil.GetItemTable().GetRowByItemID(self.data.money_type)
    local cardData = Data.BagApi:CreateLocalItemData(self.mallTableInfo.ItemID)
    local yesNoTest = Common.Utils.Lang(CardExchangeShop_BuyShopItemTipsText, self.data.now_price, l_itemInfo.ItemName, cardData:GetName())
    CommonUI.Dialog.ShowYesNoDlg(true, nil, yesNoTest, function()
        MgrMgr:GetMgr("MallMgr").SendBuyMallItem(self.currentShopId, self.data.seq_id, 1, self.data.now_price)
    end, nil, nil, 2, CardExchangeShop_BuyShopItemTipsText)

end
function CardExchangeItemTemplate:_showCardInfo()
    if self.cardTemplate == nil then
        return
    end
    self.cardTemplate:AddLoadCallback(function(template)
        template:ShowCardInfo()
    end)
end
function CardExchangeItemTemplate:_hideCardInfo()
    if self.cardTemplate == nil then
        return
    end
    self.cardTemplate:AddLoadCallback(function(template)
        template:HideCardInfo()
    end)
end
--lua custom scripts end
return CardExchangeItemTemplate