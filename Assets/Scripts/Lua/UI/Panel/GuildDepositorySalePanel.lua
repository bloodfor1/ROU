--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
GuildDepositorySalePanel = {}

--lua model end

--lua functions
---@class GuildDepositorySalePanel.GuildDepositorySaleItemPrefab
---@field PanelRef MoonClient.MLuaUIPanel
---@field PriceText MoonClient.MLuaUICom
---@field Prefab MoonClient.MLuaUICom
---@field ItemSlot MoonClient.MLuaUICom
---@field ItemName MoonClient.MLuaUICom
---@field IsSelected MoonClient.MLuaUICom
---@field IsBidded MoonClient.MLuaUICom
---@field IsAttented MoonClient.MLuaUICom

---@class GuildDepositorySalePanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field SelfPriceText MoonClient.MLuaUICom
---@field SelfPriceBg MoonClient.MLuaUICom
---@field SaleScrollView MoonClient.MLuaUICom
---@field ReservePriceText MoonClient.MLuaUICom
---@field OwnText MoonClient.MLuaUICom
---@field ItemName MoonClient.MLuaUICom
---@field ItemDetailContent MoonClient.MLuaUICom
---@field ItemDescription MoonClient.MLuaUICom
---@field CountDownText MoonClient.MLuaUICom
---@field BtnPlus MoonClient.MLuaUICom
---@field BtnModifyText MoonClient.MLuaUICom
---@field BtnModify MoonClient.MLuaUICom
---@field BtnMinus MoonClient.MLuaUICom
---@field BtnCancel MoonClient.MLuaUICom
---@field BtnBidText MoonClient.MLuaUICom
---@field BtnBid MoonClient.MLuaUICom
---@field BidPriceBox MoonClient.MLuaUICom
---@field BidPrice MoonClient.MLuaUICom
---@field GuildDepositorySaleItemPrefab GuildDepositorySalePanel.GuildDepositorySaleItemPrefab

---@return GuildDepositorySalePanel
function GuildDepositorySalePanel.Bind(ctrl)

	--dont override this function
	---@type MoonClient.MLuaUIPanel
	local panelRef = ctrl.uObj:GetComponent("MLuaUIPanel")
	ctrl:OnBindPanel(panelRef)
	return BindMLuaPanel(panelRef)
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return UI.GuildDepositorySalePanel