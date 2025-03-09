--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
TowerDefenseSpiritPanel = {}

--lua model end

--lua functions
---@class TowerDefenseSpiritPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtTitle MoonClient.MLuaUICom
---@field TxtTips MoonClient.MLuaUICom
---@field TxtSpiritNum MoonClient.MLuaUICom
---@field TxtMagicPower MoonClient.MLuaUICom
---@field TxtAdminOn MoonClient.MLuaUICom
---@field TxtAdminOff MoonClient.MLuaUICom
---@field TogAdmin MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom

---@return TowerDefenseSpiritPanel
---@param ctrl UIBase
function TowerDefenseSpiritPanel.Bind(ctrl)
	
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
return UI.TowerDefenseSpiritPanel