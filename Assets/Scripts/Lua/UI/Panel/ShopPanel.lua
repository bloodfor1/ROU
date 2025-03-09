--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
ShopPanel = {}

--lua model end

--lua functions
---@class ShopPanel.BuyItemPrefab
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_NeedNum MoonClient.MLuaUICom
---@field SellOut MoonClient.MLuaUICom
---@field SelectImage MoonClient.MLuaUICom
---@field PriceIcon MoonClient.MLuaUICom
---@field PriceCount MoonClient.MLuaUICom
---@field Prefab MoonClient.MLuaUICom
---@field NeedNum MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field ItemParent MoonClient.MLuaUICom
---@field ImgCd MoonClient.MLuaUICom
---@field Discount MoonClient.MLuaUICom
---@field Details MoonClient.MLuaUICom
---@field Count MoonClient.MLuaUICom
---@field BuyItemButton MoonClient.MLuaUICom

---@class ShopPanel.SellItemPrefab
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

---@class ShopPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TotalPrice MoonClient.MLuaUICom
---@field TogHide MoonClient.MLuaUICom
---@field ToggleShowPrice MoonClient.MLuaUICom
---@field TipBtn MoonClient.MLuaUICom
---@field TextSetPrice MoonClient.MLuaUICom
---@field SpecialCoin MoonClient.MLuaUICom
---@field ShopName MoonClient.MLuaUICom
---@field SellScrollRect MoonClient.MLuaUICom
---@field SellPanel MoonClient.MLuaUICom
---@field SellingPrice2 MoonClient.MLuaUICom
---@field SellingPrice1 MoonClient.MLuaUICom
---@field Price2 MoonClient.MLuaUICom
---@field Price1 MoonClient.MLuaUICom
---@field PanelAddationPrice MoonClient.MLuaUICom
---@field InComeOutIfRange MoonClient.MLuaUICom
---@field ImgCoin2 MoonClient.MLuaUICom
---@field ImgCoin1 MoonClient.MLuaUICom
---@field ImgAddationPrice MoonClient.MLuaUICom
---@field CoinNum MoonClient.MLuaUICom
---@field CoinName MoonClient.MLuaUICom
---@field CoinIcon MoonClient.MLuaUICom
---@field BuyScrollRect MoonClient.MLuaUICom
---@field BuyPanel MoonClient.MLuaUICom
---@field BuyDiscountPriceText MoonClient.MLuaUICom
---@field BtnConfirmSell MoonClient.MLuaUICom
---@field BgSellOutOfRange MoonClient.MLuaUICom
---@field BgSell MoonClient.MLuaUICom
---@field BgDiscountPrice MoonClient.MLuaUICom
---@field AddationPrice MoonClient.MLuaUICom
---@field BuyItemPrefab ShopPanel.BuyItemPrefab
---@field SellItemPrefab ShopPanel.SellItemPrefab

---@return ShopPanel
---@param ctrl UIBase
function ShopPanel.Bind(ctrl)
	
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
return UI.ShopPanel