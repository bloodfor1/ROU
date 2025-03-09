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
local l_shopSystemID = MGlobalConfig:GetInt("EntrustShopSystemID")
local moneyId = MGlobalConfig:GetInt("EntrustExchangeMoneyID")
local l_openSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
local l_isOpen = l_openSystemMgr.IsSystemOpen(l_shopSystemID)
--lua fields end

--lua class define
---@class DelegateWheelItemParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Text MoonClient.MLuaUICom
---@field Number MoonClient.MLuaUICom
---@field Image MoonClient.MLuaUICom
---@field CurrentImg MoonClient.MLuaUICom
---@field changeBtn MoonClient.MLuaUICom

---@class DelegateWheelItem : BaseUITemplate
---@field Parameter DelegateWheelItemParameter

DelegateWheelItem = class("DelegateWheelItem", super)
--lua class define end

--lua functions
function DelegateWheelItem:Init()
	
	    super.Init(self)
	
end --func end
--next--
function DelegateWheelItem:OnDestroy()
	
	
end --func end
--next--
function DelegateWheelItem:OnDeActive()
	
	
end --func end
--next--
function DelegateWheelItem:OnSetData(data)
	
	    self.info = data
	    if not self.item then
	        self.item = self:NewTemplate("ItemTemplate", {
	            TemplateParent = self.Parameter.Image.gameObject.transform,
	        })
	    end
	    local l_itemId = self.info.data.ItemId
	    local l_item = TableUtil.GetItemTable().GetRowByItemID(tonumber(l_itemId))
	    local l_count = MPlayerInfo.Debris
	    if self.info.count == nil or self.info.count < 0 then
	        self.item:SetData({ ID = l_itemId, IsShowCount = false, IsShowTips = true })
	        self.Parameter.changeBtn:AddClick(function()
	            if l_isOpen and MLuaCommonHelper.Long(self.info.price) <=l_count then
	                MgrMgr:GetMgr("ShopMgr").RequestBuyShopItem(self.info.data.Id, 1)
	            end
	        end)
	        self.Parameter.changeBtn:SetGray(not l_isOpen or MLuaCommonHelper.Long(self.info.price) > l_count)
	    else
	        self.item:SetData({ ID = l_itemId, IsShowCount = true,
	                            Count = self.info.count, IsShowTips = true, })
	        self.Parameter.changeBtn:AddClick(function()
	            if l_isOpen and MLuaCommonHelper.Long(self.info.price) <= l_count and self.info.count > 0 then
	                MgrMgr:GetMgr("ShopMgr").RequestBuyShopItem(self.info.data.Id, 1)
	            end
	        end)
	        self.Parameter.changeBtn:SetGray(not l_isOpen or MLuaCommonHelper.Long(self.info.price) > l_count or self.info.count <= 0)
	    end
	    self.Parameter.Number.LabText = tostring(self.info.price)
	    self.Parameter.Text.LabText = tostring(l_item.ItemName)
	    if moneyId then
	        local itemSdata = TableUtil.GetItemTable().GetRowByItemID(moneyId)
	        if itemSdata then
	            self.Parameter.CurrentImg:SetSpriteAsync(itemSdata.ItemAtlas, itemSdata.ItemIcon)
	        end
	    end
	
end --func end
--next--
function DelegateWheelItem:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return DelegateWheelItem