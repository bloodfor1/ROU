--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
StallPanel = {}

--lua model end

--lua functions
---@class StallPanel.StallSellItemTemplate
---@field PanelRef MoonClient.MLuaUIPanel
---@field SellOut MoonClient.MLuaUICom
---@field Selected2 MoonClient.MLuaUICom
---@field Selected MoonClient.MLuaUICom
---@field PriceCount2 MoonClient.MLuaUICom
---@field PriceCount MoonClient.MLuaUICom
---@field Price MoonClient.MLuaUICom
---@field PedlerySellItem02 MoonClient.MLuaUICom
---@field PedlerySellItem01 MoonClient.MLuaUICom
---@field OverTime MoonClient.MLuaUICom
---@field Name2 MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field ItemCountLab MoonClient.MLuaUICom
---@field ItemButtonSell01 MoonClient.MLuaUICom
---@field ItemButton2 MoonClient.MLuaUICom
---@field EquipIcon MoonClient.MLuaUICom

---@class StallPanel.StallBagItemTemplate
---@field PanelRef MoonClient.MLuaUIPanel
---@field Selected MoonClient.MLuaUICom
---@field ItemNumber MoonClient.MLuaUICom
---@field ItemName MoonClient.MLuaUICom
---@field ItemIcon MoonClient.MLuaUICom
---@field ItemCount MoonClient.MLuaUICom
---@field ItemButton MoonClient.MLuaUICom

---@class StallPanel.StallButtonTemplate
---@field PanelRef MoonClient.MLuaUIPanel
---@field Text2 MoonClient.MLuaUICom
---@field Text MoonClient.MLuaUICom
---@field SellOut2 MoonClient.MLuaUICom
---@field SellOut MoonClient.MLuaUICom
---@field parentON MoonClient.MLuaUICom
---@field parentOff MoonClient.MLuaUICom
---@field Img_Icon2 MoonClient.MLuaUICom
---@field Img_Icon MoonClient.MLuaUICom

---@class StallPanel.StallSellSonBtnTemplate
---@field PanelRef MoonClient.MLuaUIPanel
---@field Text2 MoonClient.MLuaUICom
---@field Text1 MoonClient.MLuaUICom
---@field sonON MoonClient.MLuaUICom
---@field sonOff MoonClient.MLuaUICom
---@field SellOut2 MoonClient.MLuaUICom
---@field SellOut MoonClient.MLuaUICom

---@class StallPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_NeedNum MoonClient.MLuaUICom
---@field SonPanel MoonClient.MLuaUICom
---@field sellUpArrow MoonClient.MLuaUICom
---@field sellRightScroll MoonClient.MLuaUICom
---@field SellOut MoonClient.MLuaUICom
---@field SellOnBtn MoonClient.MLuaUICom
---@field SellOffBtn MoonClient.MLuaUICom
---@field sellLeftScroll MoonClient.MLuaUICom
---@field sellDownArrow MoonClient.MLuaUICom
---@field Sell MoonClient.MLuaUICom
---@field Selected MoonClient.MLuaUICom
---@field refText MoonClient.MLuaUICom
---@field refBtn MoonClient.MLuaUICom
---@field priceUpBtn MoonClient.MLuaUICom
---@field priceDownBtn MoonClient.MLuaUICom
---@field PriceCountLab MoonClient.MLuaUICom
---@field Price MoonClient.MLuaUICom
---@field PageText MoonClient.MLuaUICom
---@field NotCreated MoonClient.MLuaUICom
---@field noObject MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field myCount MoonClient.MLuaUICom
---@field ItemStallButton MoonClient.MLuaUICom
---@field itemIcon MoonClient.MLuaUICom
---@field ItemCount111111 MoonClient.MLuaUICom
---@field getBtn MoonClient.MLuaUICom
---@field fastUpBtn MoonClient.MLuaUICom
---@field fastDownBtn MoonClient.MLuaUICom
---@field EquipIconBg MoonClient.MLuaUICom
---@field dropBtn MoonClient.MLuaUICom
---@field Demand MoonClient.MLuaUICom
---@field buyUpArrow MoonClient.MLuaUICom
---@field buyTipsText MoonClient.MLuaUICom
---@field buyPanel MoonClient.MLuaUICom
---@field BuyOnBtn MoonClient.MLuaUICom
---@field BuyOffBtn MoonClient.MLuaUICom
---@field buyDownArrow MoonClient.MLuaUICom
---@field buyContent MoonClient.MLuaUICom
---@field buyButtonUp MoonClient.MLuaUICom
---@field buyButtonDown MoonClient.MLuaUICom
---@field BuyBtn MoonClient.MLuaUICom
---@field Buy MoonClient.MLuaUICom
---@field buy MoonClient.MLuaUICom
---@field AmountText MoonClient.MLuaUICom
---@field StallSellItemTemplate StallPanel.StallSellItemTemplate
---@field StallBagItemTemplate StallPanel.StallBagItemTemplate
---@field StallButtonTemplate StallPanel.StallButtonTemplate
---@field StallSellSonBtnTemplate StallPanel.StallSellSonBtnTemplate

---@return StallPanel
---@param ctrl UIBase
function StallPanel.Bind(ctrl)
	
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
return UI.StallPanel