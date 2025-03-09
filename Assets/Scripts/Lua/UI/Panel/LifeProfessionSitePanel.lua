--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
LifeProfessionSitePanel = {}

--lua model end

--lua functions
---@class LifeProfessionSitePanel.Prefab
---@field PanelRef MoonClient.MLuaUIPanel
---@field GoBtn MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom

---@class LifeProfessionSitePanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Parent MoonClient.MLuaUICom
---@field Floor MoonClient.MLuaUICom
---@field CloseBtn MoonClient.MLuaUICom
---@field Prefab LifeProfessionSitePanel.Prefab

---@return LifeProfessionSitePanel
function LifeProfessionSitePanel.Bind(ctrl)

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
return UI.LifeProfessionSitePanel