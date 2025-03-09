--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
AuctionCommodityDescriptionPanel = {}

--lua model end

--lua functions
---@class AuctionCommodityDescriptionPanel.AuctionDesItem
---@field PanelRef MoonClient.MLuaUIPanel
---@field Name MoonClient.MLuaUICom
---@field ItemIcon MoonClient.MLuaUICom
---@field IsFollow MoonClient.MLuaUICom
---@field FollowTog MoonClient.MLuaUICom
---@field FollowBtn MoonClient.MLuaUICom

---@class AuctionCommodityDescriptionPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtMsg MoonClient.MLuaUICom
---@field TogRoleText1 MoonClient.MLuaUICom
---@field TogPanel MoonClient.MLuaUICom
---@field ShowFollowTog MoonClient.MLuaUICom
---@field RightEmptyText MoonClient.MLuaUICom
---@field RightEmpty MoonClient.MLuaUICom
---@field PageText MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom
---@field CloseBtn MoonClient.MLuaUICom
---@field BtnPageUp MoonClient.MLuaUICom
---@field BtnPageDown MoonClient.MLuaUICom
---@field AuctionItemScroll MoonClient.MLuaUICom
---@field AuctionDesItem AuctionCommodityDescriptionPanel.AuctionDesItem

---@return AuctionCommodityDescriptionPanel
---@param ctrl UIBase
function AuctionCommodityDescriptionPanel.Bind(ctrl)
	
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
return UI.AuctionCommodityDescriptionPanel