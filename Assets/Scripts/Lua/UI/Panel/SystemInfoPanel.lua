--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
SystemInfoPanel = {}

--lua model end

--lua functions
---@class SystemInfoPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field WifiSignal MoonClient.MLuaUICom[]
---@field SysTimeLab MoonClient.MLuaUICom
---@field Scroll MoonClient.MLuaUICom
---@field SceneLinesUI MoonClient.MLuaUICom
---@field SceneLineNameText MoonClient.MLuaUICom
---@field SceneLineBtn MoonClient.MLuaUICom
---@field QualityLab MoonClient.MLuaUICom
---@field NetWifi MoonClient.MLuaUICom
---@field NetNone MoonClient.MLuaUICom
---@field NetMobile MoonClient.MLuaUICom
---@field MobileSignal MoonClient.MLuaUICom[]
---@field Content MoonClient.MLuaUICom
---@field Charging MoonClient.MLuaUICom
---@field Bg MoonClient.MLuaUICom
---@field BatterySlider MoonClient.MLuaUICom
---@field SceneLinesCell MoonClient.MLuaUIGroup

---@return SystemInfoPanel
---@param ctrl UIBase
function SystemInfoPanel.Bind(ctrl)
	
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
return UI.SystemInfoPanel