--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
CurrencyDescPanel = {}

--lua model end

--lua functions
---@class CurrencyDescPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Title MoonClient.MLuaUICom
---@field Floor MoonClient.MLuaUICom
---@field Details MoonClient.MLuaUICom
---@field CreditsDetailsPanel MoonClient.MLuaUICom

---@return CurrencyDescPanel
---@param ctrl UIBaseCtrl
function CurrencyDescPanel.Bind(ctrl)
	
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
return UI.CurrencyDescPanel