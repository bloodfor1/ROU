--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
GMEnvironWeatherPanel = {}

--lua model end

--lua functions
---@class GMEnvironWeatherPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field ThunderRain MoonClient.MLuaUICom
---@field Sunny MoonClient.MLuaUICom
---@field Sandstorm MoonClient.MLuaUICom
---@field ResetBtn MoonClient.MLuaUICom
---@field Morning MoonClient.MLuaUICom
---@field LightSnow MoonClient.MLuaUICom
---@field LightRain MoonClient.MLuaUICom
---@field LateNight MoonClient.MLuaUICom
---@field HeavySnow MoonClient.MLuaUICom
---@field HeavyRain MoonClient.MLuaUICom
---@field Fog MoonClient.MLuaUICom
---@field Evening MoonClient.MLuaUICom
---@field DescInfo MoonClient.MLuaUICom
---@field ConfigWeather MoonClient.MLuaUICom
---@field ConfigPeriod MoonClient.MLuaUICom
---@field Cloudy MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom
---@field ApplyBtn MoonClient.MLuaUICom
---@field AfterSnow MoonClient.MLuaUICom
---@field AfterRain MoonClient.MLuaUICom
---@field Afternoon MoonClient.MLuaUICom

---@return GMEnvironWeatherPanel
function GMEnvironWeatherPanel.Bind(ctrl)

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
return UI.GMEnvironWeatherPanel