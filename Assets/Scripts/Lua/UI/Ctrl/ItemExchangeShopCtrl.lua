--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/ItemExchangeShopPanel"
require "UI/Template/ItemTemplate"
require "UI/Template/ItemExchangeListTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
ItemExchangeShopCtrl = class("ItemExchangeShopCtrl", super)
--lua class define end

local l_shopMgr = MgrMgr:GetMgr("ShopMgr")
--lua functions
function ItemExchangeShopCtrl:ctor()

    super.ctor(self, CtrlNames.ItemExchangeShop, UILayer.Function, nil, ActiveType.Exclusive)

end --func end
--next--
function ItemExchangeShopCtrl:Init()

    self.panel = UI.ItemExchangeShopPanel.Bind(self)
    super.Init(self)

    self.panel.HandlerCloseBtn:AddClick(function()
        UIMgr:DeActiveUI(self.name)
        UIMgr:DeActiveUI(UI.CtrlNames.CommonItemTips)
    end)

    self.panel.SureBtn:AddClick(function()
        self:OnConfirm()
    end)

    self.panel.InputCount.InputNumber.OnValueChange = (function(value)
        self.buyCount = value
        if self.buyCount < self.panel.InputCount.InputNumber.MinValue then
            self.buyCount = self.panel.InputCount.InputNumber.MinValue
        end
        if self.buyCount > self.panel.InputCount.InputNumber.MaxValue then
            self.buyCount = self.panel.InputCount.InputNumber.MaxValue
        end

        self.panel.TargetCount.LabText = tostring(self.buyCount)
        self:RefreshCost()
    end
    )

    self.buyItemTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.ItemExchangeListTemplate,
        TemplatePrefab = self.panel.ItemExchangeListTemplate.LuaUIGroup.gameObject,
        ScrollRect = self.panel.ScrollView.LoopScroll
    })

    self.itemPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.ItemTemplate,
        TemplateParent = self.panel.IngredientsParent.transform,
    })

    self.itemTemplate = self:NewTemplate("ItemTemplate", {
        TemplateParent = self.panel.Cooking.Transform,
        IsActive = true
    })

    self.buyCount = 1
    self.costInfo = nil
    self.buyTableId = nil

    MLuaCommonHelper.SetLocalPos(self.itemTemplate:gameObject(), 73, 133, 0)
end --func end
--next--
function ItemExchangeShopCtrl:Uninit()

    self.buyItemTemplatePool = nil
    self.itemPool = nil
    self.itemTemplate = nil
    self.buyCount = nil
    self.costInfo = nil
    self.buyTableId = nil

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function ItemExchangeShopCtrl:OnActive()

    self:ShowShop()

    if MEntityMgr.PlayerEntity ~= nil then
        MEntityMgr.PlayerEntity.Target = nil
    end
    MPlayerInfo:FocusToNpc(MgrMgr:GetMgr("NpcMgr").CurrentNpcId, 1, 5, 135, 20)
    MEntityMgr.HideNpcAndRole = true
end --func end
--next--
function ItemExchangeShopCtrl:OnDeActive()

    MPlayerInfo:FocusToMyPlayer()
    if MEntityMgr.PlayerEntity then
        MEntityMgr.PlayerEntity.IsVisible = true
    end
    MEntityMgr.HideNpcAndRole = false
end --func end
--next--
function ItemExchangeShopCtrl:Update()


end --func end





--next--
function ItemExchangeShopCtrl:BindEvents()
    --购买成功回调
    self:BindEvent(l_shopMgr.EventDispatcher, l_shopMgr.BuyCommodity, self.RefreshDetailPanel)
end --func end
--next--
--lua functions end

--lua custom scripts

function ItemExchangeShopCtrl:OnConfirm()
    if self.itemLimitBuy then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("Shop_CountInsufficient"))
        return
    end
    l_shopMgr.RequestBuyShopItem(self.buyTableId, MLuaCommonHelper.Long2Int(self.buyCount))
end

function ItemExchangeShopCtrl:OnListItemClick(item)

    local l_lastIndex = l_shopMgr.g_currentSelectIndex
    l_shopMgr.g_currentSelectIndex = item.ShowIndex
    self.panel.ScrollView.LoopScroll:RefreshCell(l_lastIndex - 1)
    self:RefreshDetailPanel()
end

function ItemExchangeShopCtrl:RefreshDetailPanel()

    local l_buyShopItem = l_shopMgr.BuyShopItems[l_shopMgr.g_currentSelectIndex]
    if not l_buyShopItem then
        logError("ItemExchangeShopCtrl:RefreshDetailPanel error, item not exist", l_shopMgr.g_currentSelectIndex)
        return
    end

    local l_buyTable = TableUtil.GetShopCommoditTable().GetRowById(l_buyShopItem.table_id)
    if l_buyTable == nil then
        logError("ShopCommoditTable表数据没有id:" .. tostring(l_buyShopItem.table_id))
        return
    end

    local l_itemTable = TableUtil.GetItemTable().GetRowByItemID(l_buyTable.ItemId)
    if l_itemTable == nil then
        logError("ItemTable表数据没有id:" .. l_buyTable.ItemId)
        return
    end

    self.buyTableId = l_buyShopItem.table_id

    self.panel.Name.LabText = l_itemTable.ItemName

    --限购设置
    self.panel.LeftBuyTime.gameObject:SetActiveEx(l_buyTable.PurchaseTimesLimit ~= 0)
    local l_limitType, l_limitCount = MgrMgr:GetMgr("ShopMgr").GetBuyLimitType(l_buyTable)
    if l_limitType ~= MgrMgr:GetMgr("ShopMgr").eBuyLimitType.None then
        self.panel.LeftBuyTime.LabText = Lang("LEFT_BUY_TIME", l_buyShopItem.left_time .. "/" .. l_limitCount)
    end
    self.itemTemplate:SetData({ ID = l_buyTable.ItemId, IsShowCount = false, CustomBtnAtlas = "Common", CustomBtnSprite = "UI_Common_ItemBG_01.png" })
    --是否限购
    self.itemLimitBuy = l_buyTable.PurchaseTimesLimit ~= 0 and l_buyShopItem.left_time <= 0

    local l_cost_datas = {}
    local l_costs = Common.Functions.VectorSequenceToTable(l_buyTable.ItemPerPrice)
    local l_maxBuyCount = 999
    for i, v in ipairs(l_costs) do
        local l_cur_count = Data.BagModel:GetCoinOrPropNumById(v[1])
        local l_tmp = math.floor(l_cur_count / v[2])
        if l_tmp <= 0 then
            l_maxBuyCount = 1
        else
            if l_maxBuyCount > l_tmp then
                l_maxBuyCount = l_tmp
            end
        end
        --限购数量设置
        if l_buyTable.PurchaseTimesLimit ~= 0 then
            l_maxBuyCount = l_limitCount
        end
        table.insert(l_cost_datas, {
            ID = v[1],
            Count = l_cur_count,
            IsShowRequire = true,
            RequireCount = v[2],
            IsShowCount = false,
            CustomBtnAtlas = "Common",
            CustomBtnSprite = "UI_Common_ItemBG_01.png"
        })
    end

    self.costInfo = l_cost_datas

    self.buyCount = 1
    self.panel.InputCount.InputNumber:SetValue(1)
    self.panel.InputCount.InputNumber.MaxValue = l_maxBuyCount

    self:RefreshCost()
end

function ItemExchangeShopCtrl:RefreshCost()
    local l_cost_datas = table.ro_deepCopy(self.costInfo)
    for i, v in ipairs(l_cost_datas) do
        v.RequireCount = v.RequireCount * self.buyCount
    end

    self.itemPool:ShowTemplates({ Datas = l_cost_datas })

    local l_handleUObj = self.panel.IngredientsParent.gameObject
    if #l_cost_datas >= 4 then
        MLuaCommonHelper.SetRectTransformPivot(l_handleUObj, 0, 0.5)
    else
        MLuaCommonHelper.SetRectTransformPivot(l_handleUObj, 0.5, 0.5)
    end
    MLuaCommonHelper.SetRectTransformPosX(l_handleUObj, 0)
end

function ItemExchangeShopCtrl:ShowShop()
    --清空已选择的商品Index
    l_shopMgr.g_currentSelectIndex = 1

    local l_buyCount = #l_shopMgr.BuyShopItems
    self.buyItemTemplatePool:ShowTemplates({ Datas = l_shopMgr.BuyShopItems, StartScrollIndex = 0, Method = function(item)
        self:OnListItemClick(item)
    end })

    local l_shopTableInfo = TableUtil.GetShopTable().GetRowByShopId(l_shopMgr.ShopId)
    self.panel.Title.LabText = l_shopTableInfo.ShopName

    if l_buyCount > 0 then
        self:RefreshDetailPanel()
        self.panel.Panel.gameObject:SetActiveEx(true)
        self.panel.NonePanel.gameObject:SetActiveEx(false)
    else
        self.panel.Panel.gameObject:SetActiveEx(false)
        self.panel.NonePanel.gameObject:SetActiveEx(true)
    end
end

return ItemExchangeShopCtrl
--lua custom scripts end
