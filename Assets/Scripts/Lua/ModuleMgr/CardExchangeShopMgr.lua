module("ModuleMgr.CardExchangeShopMgr", package.seeall)

EventDispatcher = EventDispatcher.new()

local _cardExchangeShopData = DataMgr:GetData("CardExchangeShopData")
local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")

RefreshCost=MGlobalConfig:GetSequenceOrVectorInt("RefreshCost")

LowCardExchangeShopId=501
HighCardExchangeShopId=601

CurrencyType=nil
IsShowCardInfo=false

function OnInit()
    gameEventMgr.Register(gameEventMgr.OnBagUpdate, _onItemUpdate)

    local currencyType = MGlobalConfig:GetSequenceOrVectorInt("SpaceCardShowCurrency")
    CurrencyType={}
    for i = 1, currencyType.Length do
        table.insert(CurrencyType,currencyType[i-1])
    end
end

ShowAllCardInfoEvent="ShowAllCardInfoEvent"
HideAllCardInfoEvent="HideAllCardInfoEvent"

function ShowCardDestroyDisplay()
    local cardDestroyDisplayData=_cardExchangeShopData.GetCardDestroyDisplayData()
    if cardDestroyDisplayData == nil then
        return
    end
    UIMgr:ActiveUI(UI.CtrlNames.CardDestroyDisplay,cardDestroyDisplayData)
    _cardExchangeShopData.ClearCardDestroyDisplayData()
end

function ShowCardExchangeShop()
    --MgrMgr:GetMgr("CurrencyMgr").SetCurrencyDisplayWithData(CurrencyType)
    local groupData={}
    local currencyPanelData= {}
    currencyPanelData.CurrencyDisplay=CurrencyType
    groupData[UI.CtrlNames.Currency]=currencyPanelData
    MgrMgr:GetMgr("MallMgr").SendGetMallInfo(LowCardExchangeShopId)
    MgrMgr:GetMgr("MallMgr").SendGetMallInfo(HighCardExchangeShopId)
    UIMgr:ActiveUI(UI.CtrlNames.CardExchangeShop,groupData)
end

---@param itemUpdateDataList ItemUpdateData[]
function _onItemUpdate(itemUpdateDataList)
    if nil == itemUpdateDataList then
        logError("nil == itemUpdateDataList")
        return
    end
    for i = 1, #itemUpdateDataList do
        local itemUpdateData=itemUpdateDataList[i]
        if itemUpdateData:ItemRemoved() and ItemChangeReason.ITEM_REASON_LIMITED_TIME_OFFER == itemUpdateData.Reason then
            local oldItemData=itemUpdateData:GetNewOrOldItem()
            _setCardDestroyDisplayData(oldItemData)
        end
    end
end

function _setCardDestroyDisplayData(itemData)
    if itemData == nil then
        return
    end
    if itemData:ItemMatchesType(GameEnum.EItemType.Card) == false then
        return
    end
    local tableId = itemData.TID
    _cardExchangeShopData.SetCardDestroyDisplayData(tableId)
end

function OnLogout()
    _cardExchangeShopData.Logout()
end

return ModuleMgr.CardExchangeShopMgr