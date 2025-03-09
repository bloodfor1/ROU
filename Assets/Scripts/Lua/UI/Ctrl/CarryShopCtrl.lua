--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/CarryShopPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
---@class CarryShopCtrl : UIBaseCtrl
CarryShopCtrl = class("CarryShopCtrl", super)
--lua class define end

--lua functions
function CarryShopCtrl:ctor()

    super.ctor(self, CtrlNames.CarryShop, UILayer.Function, nil, ActiveType.Exclusive)
    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor = BlockColor.Dark
    self.ClosePanelNameOnClickMask = UI.CtrlNames.CarryShop
end --func end
--next--
function CarryShopCtrl:Init()

    self.panel = UI.CarryShopPanel.Bind(self)
    super.Init(self)
    self.shopId = 0
    self.buyCount = 0
    self.carryshopTemPool = nil
    self.ItemTem = nil
    self.ItemPoolDontLoop = nil
    self.ItemPoolLoop = nil
    self.leftNum = 0
    self.SelectTableId = 0
    self.ShowIndex = 0
    self.TipsType = DataMgr:GetData("IllustrationMonsterData").ECarryShopTypes.None
    self.panel.InputCount.InputNumber.OnMaxValueMethod = function()
        self:CheckTips()
    end
    self.panel.Btn_synthesis:AddClickWithLuaSelf(self.BuyItem, self)
    self.panel.CloseBtn:AddClickWithLuaSelf(function()
        UIMgr:DeActiveUI(UI.CtrlNames.CarryShop)
    end, self)
    self.panel.InputCount.InputNumber.OnValueChange = function(value)
        self:RefreshRightPanel(value)
    end
end --func end
--next--
function CarryShopCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil
    self.carryshopTemPool = nil
    self.ItemTem = nil
    self.ItemPoolDontLoop = nil
    self.ItemPoolLoop = nil
    self.leftNum = 0
    self.SelectTableId = 0
    self.ShowIndex = 0
    self.TipsType = DataMgr:GetData("IllustrationMonsterData").ECarryShopTypes.None
end --func end
--next--
function CarryShopCtrl:OnActive()

    if self.uiPanelData ~= nil then
        self.shopId = self.uiPanelData.shopId
    end
    if self.carryshopTemPool == nil then
        self.carryshopTemPool = self:NewTemplatePool({
            TemplateClassName = "CarryShopTem",
            TemplatePrefab = self.panel.CarryShopTem.gameObject,
            ScrollRect = self.panel.ScrollRect.LoopScroll,
            Method = function(Index, tableID, data)
                self:SelectItem(Index, tableID, data)
            end
        })
    end
    if self.ItemTem == nil then
        self.ItemTem = self:NewTemplate("ItemTemplate", {
            TemplateParent = self.panel.ItemParent.transform,
        })
    end
    if self.ItemPoolDontLoop == nil then
        self.ItemPoolDontLoop = self:NewTemplatePool({
            TemplateClassName = "ItemTemplate",
            TemplatePath = "UI/Prefabs/ItemPrefab",
            TemplateParent = self.panel.NeedList.transform,
        })
    end
    if self.ItemPoolLoop == nil then
        self.ItemPoolLoop = self:NewTemplatePool({
            TemplateClassName = "ItemTemplate",
            TemplatePath = "UI/Prefabs/ItemPrefab",
            ScrollRect = self.panel.LoopScroll.LoopScroll,
        })
    end
    self.ShowIndex = 1
    self.SelectTableId = MgrMgr:GetMgr("ShopMgr").BuyShopItems[self.ShowIndex].table_id
    self.showBuyItemId = MgrMgr:GetMgr("ShopMgr").ShowBuyItemId
    self:CheckSelect()
    self:RefreshAll()
end --func end
--next--
function CarryShopCtrl:OnDeActive()


end --func end
--next--
function CarryShopCtrl:Update()


end --func end
--next--
function CarryShopCtrl:BindEvents()
    self:BindEvent(MgrMgr:GetMgr("ShopMgr").EventDispatcher, MgrMgr:GetMgr("ShopMgr").BuyCommodity, self.RefreshAll)

end --func end
--next--
--lua functions end

--lua custom scripts
function CarryShopCtrl:SelectItem(index, tableID, data)
    self.carryshopTemPool:SelectTemplate(index)
    self.ShowIndex = index
    local l_data = TableUtil.GetShopCommoditTable().GetRowById(tableID)
    local ItemData = {
        ID = l_data.ItemId,
        Count = l_data.ItemPerMount,
        IsShowCount = true,
    }
    self.panel.LcokTips:SetActiveEx(data.is_lock)
    if data.is_lock then
        self.panel.LcokTips.LabText = Lang("MONSTER_BOOK_LVL_LIMIT", l_data.HandBookLvLimit)
    end
    self.ItemTem:SetData(ItemData)
    self.leftNum = data.left_time
    self.SelectTableId = tableID
    local maxValue = 0
    if self.leftNum == -1 then
        maxValue = 4294967295
    else
        maxValue = self.leftNum
    end
    self.panel.Btn_synthesis:SetActiveEx(not data.is_lock and self.leftNum > 0)
    if maxValue > MgrMgr:GetMgr("ShopMgr").CheckCanBuyNum(tableID) then
        maxValue = MgrMgr:GetMgr("ShopMgr").CheckCanBuyNum(tableID)
        self.TipsType = DataMgr:GetData("IllustrationMonsterData").ECarryShopTypes.NoMoney
    else
        self.TipsType = DataMgr:GetData("IllustrationMonsterData").ECarryShopTypes.LeftTime
    end
    maxValue = math.min(maxValue, MgrMgr:GetMgr("ShopMgr").CheckCanBuyNum(tableID))
    maxValue = math.max(maxValue, 1)
    self.panel.InputCount.InputNumber.MaxValue = maxValue
    self:RefreshRightPanel(1)
end

function CarryShopCtrl:RefreshRightPanel(count)
    count = count and count or 1
    if tonumber(self.panel.InputCount.InputNumber:GetValue()) ~= tonumber(count) then
        self.panel.InputCount.InputNumber:SetValue(count)
    end
    self.buyCount = count
    local tabledata = TableUtil.GetShopCommoditTable().GetRowById(self.SelectTableId)
    local l_PriceItemData = {}
    for i = 0, tabledata.ItemPerPrice.Length - 1 do
        table.insert(l_PriceItemData, {
            ID = tabledata.ItemPerPrice[i][0],
            RequireCount = tabledata.ItemPerPrice[i][1] * count,
            IsShowCount = false,
            IsShowRequire = true
        })
    end
    if #l_PriceItemData <= 3 then
        self.panel.NeedList:SetActiveEx(true)
        self.panel.LoopScroll:SetActiveEx(false)
        self.ItemPoolLoop:ShowTemplates({ Datas = {} })
        self.ItemPoolDontLoop:ShowTemplates({ Datas = l_PriceItemData })
    else
        self.panel.NeedList:SetActiveEx(false)
        self.panel.LoopScroll:SetActiveEx(true)
        self.ItemPoolLoop:ShowTemplates({ Datas = l_PriceItemData })
        self.ItemPoolDontLoop:ShowTemplates({ Datas = {} })
    end

end

function CarryShopCtrl:BuyItem()
    if MgrMgr:GetMgr("ShopMgr").CheckCanBuyNum(self.SelectTableId) == 0 then
        self:CheckTips()
        local needCoin = TableUtil.GetShopCommoditTable().GetRowById(self.SelectTableId).ItemPerPrice
        for i = 0, needCoin.Length - 1 do
            local Count = MgrMgr:GetMgr("ItemContainerMgr").GetItemCountByContAndID(GameEnum.EBagContainerType.VirtualItem, needCoin[i][0])
            if Count < needCoin[i][1] then
                MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(needCoin[i][0], nil, nil, nil, false)
            end
        end
        return
    end
    MgrMgr:GetMgr("ShopMgr").RequestBuyShopItem(self.SelectTableId, MLuaCommonHelper.Long2Int(self.buyCount))
end

function CarryShopCtrl:RefreshAll()
    MgrMgr:GetMgr("ShopMgr").SortBuyItemsSoldOutAtLast()
    self.carryshopTemPool:ShowTemplates({ Datas = MgrMgr:GetMgr("ShopMgr").BuyShopItems, StartScrollIndex = self.ShowIndex })
    local shopItems = MgrMgr:GetMgr("ShopMgr").BuyShopItems
    self:SelectItem(self.ShowIndex, self.carryshopTemPool:getData(self.ShowIndex).table_id, shopItems[self.ShowIndex])
end

function CarryShopCtrl:CheckTips()
    if self.TipsType == DataMgr:GetData("IllustrationMonsterData").ECarryShopTypes.LeftTime then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("MAX_LIMIT_EXCHANGE"))
    elseif self.TipsType == DataMgr:GetData("IllustrationMonsterData").ECarryShopTypes.NoMoney then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("ITEM_NOT_ENOUGH"))
    end
end

function CarryShopCtrl:CheckSelect()
    local shopItems = MgrMgr:GetMgr("ShopMgr").BuyShopItems
    for i = 1, #shopItems do
        local data = TableUtil.GetShopCommoditTable().GetRowById(shopItems[i].table_id)
        if data.ItemId == self.showBuyItemId then
            self.ShowIndex = i
            return
        end
    end
    self.ShowIndex = 1
end

--lua custom scripts end
return CarryShopCtrl