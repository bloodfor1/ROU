--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
AuctionPanel = {}

--lua model end

--lua functions
---@class AuctionPanel.AuctionItem
---@field PanelRef MoonClient.MLuaUIPanel
---@field Time MoonClient.MLuaUICom
---@field Select MoonClient.MLuaUICom
---@field PriceIcon MoonClient.MLuaUICom
---@field PriceCount MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field ItemIcon MoonClient.MLuaUICom
---@field IsBid MoonClient.MLuaUICom
---@field Highest MoonClient.MLuaUICom
---@field Exceed MoonClient.MLuaUICom
---@field BidCancel MoonClient.MLuaUICom
---@field BackBtn MoonClient.MLuaUICom
---@field AutoBidBtn MoonClient.MLuaUICom

---@class AuctionPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field UnFollowBtn MoonClient.MLuaUICom
---@field TogPanel MoonClient.MLuaUICom
---@field ShowFollowTog MoonClient.MLuaUICom
---@field PriceFactor MoonClient.MLuaUICom
---@field PageText MoonClient.MLuaUICom
---@field ManualBidTogDisableBtn MoonClient.MLuaUICom
---@field ManualBidTog MoonClient.MLuaUICom
---@field ItemName MoonClient.MLuaUICom
---@field ItemInfo MoonClient.MLuaUICom
---@field ItemEmptyText MoonClient.MLuaUICom
---@field ItemEmpty MoonClient.MLuaUICom
---@field FollowBtn MoonClient.MLuaUICom
---@field FinalPriceIcon MoonClient.MLuaUICom
---@field FinalPrice MoonClient.MLuaUICom
---@field DetailDes MoonClient.MLuaUICom
---@field BtnTips MoonClient.MLuaUICom
---@field BtnPageUp MoonClient.MLuaUICom
---@field BtnPageDown MoonClient.MLuaUICom
---@field BtnExplain MoonClient.MLuaUICom
---@field BidText MoonClient.MLuaUICom
---@field BidConfirmBtn MoonClient.MLuaUICom
---@field BidCancelBtn MoonClient.MLuaUICom
---@field BasePriceIcon MoonClient.MLuaUICom
---@field BasePrice MoonClient.MLuaUICom
---@field AutoBidTog MoonClient.MLuaUICom
---@field AuctionTime MoonClient.MLuaUICom
---@field AuctionItemScroll MoonClient.MLuaUICom
---@field AuctionItem AuctionPanel.AuctionItem

---@return AuctionPanel
---@param ctrl UIBase
function AuctionPanel.Bind(ctrl)
	
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
return UI.AuctionPanel