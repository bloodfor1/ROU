--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
BackCityOfferPanel = {}

--lua model end

--lua functions
---@class BackCityOfferPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Slider MoonClient.MLuaUICom
---@field Info MoonClient.MLuaUICom
---@field CloseBtn MoonClient.MLuaUICom
---@field CancelBtn MoonClient.MLuaUICom
---@field ButtonJoinTxt MoonClient.MLuaUICom

---@return BackCityOfferPanel
---@param ctrl UIBase
function BackCityOfferPanel.Bind(ctrl)
	
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
return UI.BackCityOfferPanel