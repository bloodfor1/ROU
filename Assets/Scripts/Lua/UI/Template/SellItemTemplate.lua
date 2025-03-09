--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/BaseUITemplate"
require "UI/Template/ItemTemplate"
--lua requires end

--lua model
module("UITemplate", package.seeall)

--lua model end

--lua fields
local super = UITemplate.BaseUITemplate
--lua fields end

--lua class define
---@class SellItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field SellItemButton MoonClient.MLuaUICom
---@field PriceIcon MoonClient.MLuaUICom
---@field PriceCount MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field ItemParent MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom
---@field Details MoonClient.MLuaUICom
---@field Count MoonClient.MLuaUICom
---@field CloseButton MoonClient.MLuaUICom

---@class SellItemTemplate : BaseUITemplate
---@field Parameter SellItemTemplateParameter

SellItemTemplate = class("SellItemTemplate", super)
--lua class define end

--lua functions
function SellItemTemplate:Init()
	
	    super.Init(self)
	self.itemTemplate =self:NewTemplate("ItemTemplate",{TemplateParent=self.Parameter.ItemParent.Transform})
	
end --func end
--next--
function SellItemTemplate:OnDestroy()
	
	self.sellItem = nil
	self.itemTemplate=nil
	
end --func end
--next--
function SellItemTemplate:OnSetData(data)
	self.sellItem = data
	self:Refresh()
	
end --func end
--next--
function SellItemTemplate:BindEvents()
    self:BindEvent(MgrMgr:GetMgr("AuctionMgr").EventDispatcher, MgrMgr:GetMgr("AuctionMgr").EEventType.BlackShopItemPriceRefresh, function()
        self:Refresh(true)
    end)
end --func end
--next--
function SellItemTemplate:OnDeActive()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function SellItemTemplate:Refresh(notRequestBlackPrice)
    if not self.sellItem then return end

	local l_propId = self.sellItem[1].propInfo.TID
	local itemTableInfo = TableUtil.GetItemTable().GetRowByItemID(l_propId)
	self.Parameter.Name.LabText=tostring(itemTableInfo.ItemName)

	--self:gameObject().name=tostring(itemTableInfo.ItemName)
	--logGreen("显示的物体名字："..tostring(itemTableInfo.ItemName))

    local l_isBlackShop = MgrMgr:GetMgr("AuctionMgr").CanBlackShopSell(l_propId)
    if l_isBlackShop then     -- 黑市处理
        local l_row = TableUtil.GetItemTable().GetRowByItemID(102)
        if l_row then
            self.Parameter.PriceIcon:SetSprite(l_row.ItemAtlas, l_row.ItemIcon)
        end
        local l_price = MgrMgr:GetMgr("AuctionMgr").GetBlackShopSellPrice(self.sellItem[1].propInfo, function(price)
            if not self.Parameter then return end
            self.Parameter.PriceCount.LabText = tostring(price)
        end,notRequestBlackPrice)
        self.Parameter.PriceCount.LabText = tostring(l_price)
    else
        local l_item_id = itemTableInfo.RecycleValue:get_Item(0)
        local l_item_count = itemTableInfo.RecycleValue:get_Item(1)
        local l_row = TableUtil.GetItemTable().GetRowByItemID(l_item_id)
        if l_row then
            self.Parameter.PriceIcon:SetSprite(l_row.ItemAtlas, l_row.ItemIcon)
        else
            logError("找不到道具id:" .. tostring(l_item_id))
        end
        self.Parameter.PriceCount.LabText=GetColorText(tostring(math.floor(l_item_count)), RoColorTag.Blue, RoColor.Scheme.Dark)

        --设置商人价格
        if not MgrMgr:GetMgr("ShopMgr").ShopSellToggleState and MgrMgr:GetMgr("ShopMgr").GetItemIsHaveMerchantAddition(l_propId) then
            local l_price = MgrMgr:GetMgr("ShopMgr").GetShopShowPrice(l_item_count*MgrMgr:GetMgr("ShopMgr").BussinessmanSellDisCountNum)
            self.Parameter.PriceCount.LabText=GetColorText(tostring(l_price), RoColorTag.Green)
        end
    end


	self.Parameter.Details.gameObject:SetActiveEx(false)
	self.Parameter.CloseButton:AddClick(function()
		MgrMgr:GetMgr("ShopMgr").EventDispatcher:Dispatch(MgrMgr:GetMgr("ShopMgr").RemoveSellItem, self.sellItem)
	end)

	local l_count= MgrMgr:GetMgr("ShopMgr").GetSellItemPropInfoCount(self.sellItem)
	self.itemTemplate:SetData({PropInfo = self.sellItem[1].propInfo,IsShowCount=l_count > 1,Count=l_count})
end

--lua custom scripts end
return SellItemTemplate