--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
TradePanel = {}

--lua model end

--lua functions
---@class TradePanel.TradeParent
---@field PanelRef MoonClient.MLuaUIPanel
---@field parentON MoonClient.MLuaUICom
---@field parentOff MoonClient.MLuaUICom

---@class TradePanel.TradeSon
---@field PanelRef MoonClient.MLuaUIPanel
---@field sonON MoonClient.MLuaUICom
---@field sonOff MoonClient.MLuaUICom

---@class TradePanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field upText MoonClient.MLuaUICom
---@field up MoonClient.MLuaUICom
---@field TradeSellItemSelect MoonClient.MLuaUICom
---@field TradeSellItemBtn MoonClient.MLuaUICom
---@field TradeSellItem MoonClient.MLuaUICom
---@field TradeBuyItem MoonClient.MLuaUICom
---@field tipsBtn MoonClient.MLuaUICom
---@field TargetCount MoonClient.MLuaUICom
---@field stockNumLab MoonClient.MLuaUICom
---@field SonPanel MoonClient.MLuaUICom
---@field SellPriceCountLab MoonClient.MLuaUICom
---@field SellPriceCount MoonClient.MLuaUICom
---@field SellPanel MoonClient.MLuaUICom
---@field SellOnBtn MoonClient.MLuaUICom
---@field SellOffBtn MoonClient.MLuaUICom
---@field SellName MoonClient.MLuaUICom
---@field SellItemEmpty MoonClient.MLuaUICom
---@field SellItemDetails MoonClient.MLuaUICom
---@field SellItemBtn MoonClient.MLuaUICom
---@field SellDetails MoonClient.MLuaUICom
---@field SellCountTarget MoonClient.MLuaUICom
---@field SellCount MoonClient.MLuaUICom
---@field SellContent MoonClient.MLuaUICom
---@field sellBtnPlus MoonClient.MLuaUICom
---@field Selected MoonClient.MLuaUICom
---@field RefreshTime MoonClient.MLuaUICom
---@field PriceSellCount MoonClient.MLuaUICom
---@field PriceCount MoonClient.MLuaUICom
---@field preBuyFlag MoonClient.MLuaUICom
---@field pageLab MoonClient.MLuaUICom
---@field OpenNoticeText MoonClient.MLuaUICom
---@field OpenNotice MoonClient.MLuaUICom
---@field NoticeBtn MoonClient.MLuaUICom
---@field noObject MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field mid MoonClient.MLuaUICom
---@field ItemButtonTrade MoonClient.MLuaUICom
---@field icon001 MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom
---@field HaveCount MoonClient.MLuaUICom
---@field filterBtn MoonClient.MLuaUICom
---@field EquipIcon MoonClient.MLuaUICom
---@field DropDown MoonClient.MLuaUICom
---@field downText MoonClient.MLuaUICom
---@field down MoonClient.MLuaUICom
---@field DetailPanel MoonClient.MLuaUICom
---@field DetailName MoonClient.MLuaUICom
---@field DetailLab MoonClient.MLuaUICom
---@field CountReduceBtn MoonClient.MLuaUICom
---@field CountAddBtn MoonClient.MLuaUICom
---@field contentPanel MoonClient.MLuaUICom
---@field buyTipsText MoonClient.MLuaUICom
---@field BuyTipsLab MoonClient.MLuaUICom
---@field buyScrollView MoonClient.MLuaUICom
---@field BuyPanel MoonClient.MLuaUICom
---@field BuyOnBtn MoonClient.MLuaUICom
---@field BuyOffBtn MoonClient.MLuaUICom
---@field BuyItemEmpty MoonClient.MLuaUICom
---@field BuyIconBtn MoonClient.MLuaUICom
---@field buyDetail MoonClient.MLuaUICom
---@field BuyCountLab MoonClient.MLuaUICom
---@field BuyCount MoonClient.MLuaUICom
---@field buyContent MoonClient.MLuaUICom
---@field buyButtonUp MoonClient.MLuaUICom
---@field buyButtonDown MoonClient.MLuaUICom
---@field BuyBtn MoonClient.MLuaUICom
---@field BtnPrayText MoonClient.MLuaUICom
---@field TradeParent TradePanel.TradeParent
---@field TradeSon TradePanel.TradeSon

---@return TradePanel
---@param ctrl UIBase
function TradePanel.Bind(ctrl)
	
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
return UI.TradePanel