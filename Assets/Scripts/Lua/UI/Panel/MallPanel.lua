--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
MallPanel = {}

--lua model end

--lua functions
---@class MallPanel.MallItemPrefab
---@field PanelRef MoonClient.MLuaUIPanel
---@field TextTime MoonClient.MLuaUICom
---@field SellOut MoonClient.MLuaUICom
---@field PriceNum MoonClient.MLuaUICom
---@field PriceIcon MoonClient.MLuaUICom
---@field Lock MoonClient.MLuaUICom
---@field LimitText MoonClient.MLuaUICom
---@field Light MoonClient.MLuaUICom
---@field ItemName MoonClient.MLuaUICom
---@field Item MoonClient.MLuaUICom
---@field Discounts MoonClient.MLuaUICom
---@field Btn MoonClient.MLuaUICom

---@class MallPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Toggle MoonClient.MLuaUICom
---@field TicketImage MoonClient.MLuaUICom
---@field Ticket MoonClient.MLuaUICom
---@field TextRefresh MoonClient.MLuaUICom
---@field TextNum MoonClient.MLuaUICom
---@field TableGroup MoonClient.MLuaUICom
---@field ResetTime MoonClient.MLuaUICom
---@field RawImage MoonClient.MLuaUICom
---@field MainView MoonClient.MLuaUICom
---@field CloseBtn MoonClient.MLuaUICom
---@field ButtonRefresh MoonClient.MLuaUICom
---@field ButtonMail MoonClient.MLuaUICom
---@field Button MoonClient.MLuaUICom
---@field MallItemPrefab MallPanel.MallItemPrefab

---@return MallPanel
---@param ctrl UIBase
function MallPanel.Bind(ctrl)
	
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
return UI.MallPanel