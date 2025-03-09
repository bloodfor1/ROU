--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
PictureQualitySettingPanel = {}

--lua model end

--lua functions
---@class PictureQualitySettingPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field SetRolutionBtn MoonClient.MLuaUICom
---@field Role40Btn MoonClient.MLuaUICom
---@field Role30Btn MoonClient.MLuaUICom
---@field Role20Btn MoonClient.MLuaUICom
---@field ResetBtn MoonClient.MLuaUICom
---@field InputHeight MoonClient.MLuaUICom
---@field DeviceResolution MoonClient.MLuaUICom
---@field BtnVeryLow MoonClient.MLuaUICom
---@field BtnMid MoonClient.MLuaUICom
---@field BtnLow MoonClient.MLuaUICom
---@field BtnHigh MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom
---@field ApplyBtn MoonClient.MLuaUICom

---@return PictureQualitySettingPanel
---@param ctrl UIBase
function PictureQualitySettingPanel.Bind(ctrl)
	
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
return UI.PictureQualitySettingPanel