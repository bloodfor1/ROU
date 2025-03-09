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
---@class RunningBusinessTradeTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field SellingItemPrefab MoonClient.MLuaUICom
---@field Selected MoonClient.MLuaUICom
---@field Price MoonClient.MLuaUICom
---@field Number MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field ItemButton MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom

---@class RunningBusinessTradeTemplate : BaseUITemplate
---@field Parameter RunningBusinessTradeTemplateParameter

RunningBusinessTradeTemplate = class("RunningBusinessTradeTemplate", super)
--lua class define end

--lua functions
function RunningBusinessTradeTemplate:Init()
	
	    super.Init(self)
	local l_item = TableUtil.GetItemTable().GetRowByItemID(GameEnum.l_virProp.MerchantCoin)
	    if l_item then
	        self.Parameter.Icon:SetSprite(l_item.ItemAtlas, l_item.ItemIcon)
	    else
	        logError("RunningBusinessTradeTemplate:Init() super.Init(self) fail 找不到MerchantCoin配置")
	    end
	
end --func end
--next--
function RunningBusinessTradeTemplate:OnDestroy()
	
	self.itemTemplate = nil
	
end --func end
--next--
function RunningBusinessTradeTemplate:OnDeActive()
	
	
end --func end
--next--
function RunningBusinessTradeTemplate:OnSetData(data)
	
	self:CustomSetData(data)
	
end --func end
--next--
function RunningBusinessTradeTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function RunningBusinessTradeTemplate:CustomSetData(data)

	local l_itemRow = TableUtil.GetItemTable().GetRowByItemID(data.item_id)
	self.Parameter.Name.LabText = l_itemRow.ItemName

	local l_merchantMgr = MgrMgr:GetMgr("MerchantMgr")
	local l_data = DataMgr:GetData("MerchantData")
	local l_sellModel = l_data.MerchantShopType == l_data.EMerchantShopType.Sell
	if l_sellModel then
		self.Parameter.Price.LabText = data.price * tonumber(data.item_count)
		self.Parameter.Number.LabText = ""
	else
		self.Parameter.Price.LabText = data.price
		self.Parameter.Number.LabText = Lang("MERCHANT_INVENTORY_FORMAT", data.item_count)
	end

	if self.itemTemplate == nil then
        self.itemTemplate = self:NewTemplate("ItemTemplate", {
            TemplateParent = self.Parameter.SellingItemPrefab.Transform
		})
		MLuaCommonHelper.SetRectTransformPosX(self.itemTemplate:gameObject(), -155.5)
    end

	local l_showData = {
		ID = data.item_id,
	}
	if l_sellModel and data.item_count > 0 then
		l_showData.Count = data.item_count
		l_showData.IsShowCount = true
	else
		l_showData.IsShowCount = false
	end

    self.itemTemplate:SetData(l_showData)

	self.Parameter.ItemButton:AddClick(function()

		if self.MethodCallback then
			self.MethodCallback(self, data)
		end
	end)
end

function RunningBusinessTradeTemplate:UpdateSelectState(selected)

	self.Parameter.Selected.gameObject:SetActiveEx(selected)
end
--lua custom scripts end
return RunningBusinessTradeTemplate