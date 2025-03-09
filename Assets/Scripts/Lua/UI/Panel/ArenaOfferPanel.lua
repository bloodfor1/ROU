--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
ArenaOfferPanel = {}

--lua model end

--lua functions
---@class ArenaOfferPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Slider MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom
---@field ButtonJoinTxt MoonClient.MLuaUICom
---@field ButtonJoin MoonClient.MLuaUICom
---@field ButtonClose MoonClient.MLuaUICom

---@return ArenaOfferPanel
---@param ctrl UIBaseCtrl
function ArenaOfferPanel.Bind(ctrl)
	
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
return UI.ArenaOfferPanel