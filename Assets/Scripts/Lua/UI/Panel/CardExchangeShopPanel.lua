--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
CardExchangeShopPanel = {}

--lua model end

--lua functions
---@class CardExchangeShopPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TableGroup MoonClient.MLuaUICom
---@field ShowDetailsButton MoonClient.MLuaUICom
---@field ShowCardInfoButton MoonClient.MLuaUICom
---@field RefreshPriceText MoonClient.MLuaUICom
---@field RefreshPriceGameObject MoonClient.MLuaUICom
---@field RefreshButton MoonClient.MLuaUICom
---@field LowCardToggle MoonClient.MLuaUICom
---@field HighCardToggle MoonClient.MLuaUICom
---@field HideCardInfoButton MoonClient.MLuaUICom
---@field FreeText MoonClient.MLuaUICom
---@field CloseButton MoonClient.MLuaUICom
---@field CardItemScroll MoonClient.MLuaUICom
---@field CacheEffectRawImage MoonClient.MLuaUICom
---@field CardExchangeItemPrefab MoonClient.MLuaUIGroup

---@return CardExchangeShopPanel
---@param ctrl UIBase
function CardExchangeShopPanel.Bind(ctrl)
	
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
return UI.CardExchangeShopPanel