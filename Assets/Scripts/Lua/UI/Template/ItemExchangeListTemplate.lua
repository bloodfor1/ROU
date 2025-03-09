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
---@class ItemExchangeListTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Name MoonClient.MLuaUICom
---@field Light MoonClient.MLuaUICom
---@field Item MoonClient.MLuaUICom
---@field Desc MoonClient.MLuaUICom
---@field Btn MoonClient.MLuaUICom

---@class ItemExchangeListTemplate : BaseUITemplate
---@field Parameter ItemExchangeListTemplateParameter

ItemExchangeListTemplate = class("ItemExchangeListTemplate", super)
--lua class define end

--lua functions
function ItemExchangeListTemplate:Init()
	
	    super.Init(self)
	self.itemTemplate = nil
	
end --func end
--next--
function ItemExchangeListTemplate:OnDestroy()
	
	self.itemTemplate = nil
	
end --func end
--next--
function ItemExchangeListTemplate:OnDeActive()
	
	
end --func end
--next--
function ItemExchangeListTemplate:OnSetData(data)
	
	self:CustomSetData(data)
	
end --func end
--next--
function ItemExchangeListTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function ItemExchangeListTemplate:CustomSetData(BuyShopItem)
	
	local l_buyTable=TableUtil.GetShopCommoditTable().GetRowById(BuyShopItem.table_id)
	if l_buyTable == nil then
		logError("ShopCommoditTable表数据没有id:"..tostring(BuyShopItem.table_id))
		return
	end

	local l_itemTable = TableUtil.GetItemTable().GetRowByItemID(l_buyTable.ItemId)
	if l_itemTable == nil then
		logError("ItemTable表数据没有id:"..l_buyTable.ItemId)
		return
	end

	if self.itemTemplate == nil then
		self.itemTemplate = self:NewTemplate("ItemTemplate", {
			TemplateParent = self.Parameter.Item.Transform,
			IsActive = true,
		})
		MLuaCommonHelper.SetLocalPos(self.itemTemplate:gameObject(), -72, 0, 0)
	end

	self.itemTemplate:SetData({ID = l_buyTable.ItemId, IsShowCount=false, CustomBtnAtlas = "Common", CustomBtnSprite = "UI_Common_ItemBG_01.png"})

	self:SetSelect(MgrMgr:GetMgr("ShopMgr").g_currentSelectIndex == self.ShowIndex)

	self.Parameter.Name.LabText = l_itemTable.ItemName
	self.Parameter.Desc.LabText = ""

	self.Parameter.Btn:AddClick(function()
		self:SetSelect(true)
		self:MethodCallback(self)
		--local l_limitType, l_limitCount= MgrMgr:GetMgr("ShopMgr").GetBuyLimitType(l_buyTable)
		--if l_limitType ~= MgrMgr:GetMgr("ShopMgr").eBuyLimitType.None then
			--if BuyShopItem.left_time == 0 then
				--MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("Shop_CountInsufficient"))
				--return
			--end
		--end
	end)
end

--选中
function ItemExchangeListTemplate:SetSelect(isShow)
	self.Parameter.Light.gameObject:SetActiveEx(isShow)
end
--lua custom scripts end
return ItemExchangeListTemplate