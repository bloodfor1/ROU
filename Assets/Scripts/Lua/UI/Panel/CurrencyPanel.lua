--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
CurrencyPanel = {}

--lua model end

--lua functions
---@class CurrencyPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field ShowCreditsButton MoonClient.MLuaUICom
---@field Main MoonClient.MLuaUICom
---@field Details MoonClient.MLuaUICom
---@field CurrencyItemParent MoonClient.MLuaUICom
---@field CreditsPanelCloseButton MoonClient.MLuaUICom
---@field CreditsPanel MoonClient.MLuaUICom
---@field CreditsItemParent MoonClient.MLuaUICom
---@field CreditsDetailsPanel MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom
---@field CurrencyItemPrefab MoonClient.MLuaUIGroup
---@field CreditsItemPrefab MoonClient.MLuaUIGroup

---@return CurrencyPanel
---@param ctrl UIBase
function CurrencyPanel.Bind(ctrl)
	
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
return UI.CurrencyPanel