--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
RunningBusinessPanel = {}

--lua model end

--lua functions
---@class RunningBusinessPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TradeTime MoonClient.MLuaUICom
---@field TradeBg MoonClient.MLuaUICom
---@field TogSelling MoonClient.MLuaUICom
---@field TogBuying MoonClient.MLuaUICom
---@field Text MoonClient.MLuaUICom
---@field Tanhao MoonClient.MLuaUICom
---@field SellTotalPrice MoonClient.MLuaUICom
---@field SellTotalCoin MoonClient.MLuaUICom
---@field SellShopTime MoonClient.MLuaUICom
---@field SellPanel MoonClient.MLuaUICom
---@field ScrollView MoonClient.MLuaUICom
---@field RefreshTime MoonClient.MLuaUICom
---@field MerchantGoods MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom
---@field CoinIcon2 MoonClient.MLuaUICom
---@field CoinIcon1 MoonClient.MLuaUICom
---@field CoinDetail MoonClient.MLuaUICom
---@field CloseButton MoonClient.MLuaUICom
---@field CargoBag MoonClient.MLuaUICom
---@field BtnSell MoonClient.MLuaUICom
---@field Btn_Submit MoonClient.MLuaUICom
---@field BagScroll MoonClient.MLuaUICom
---@field BagContent MoonClient.MLuaUICom
---@field RunningBusinessTradeTemplate MoonClient.MLuaUIGroup

---@return RunningBusinessPanel
function RunningBusinessPanel.Bind(ctrl)

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
return UI.RunningBusinessPanel