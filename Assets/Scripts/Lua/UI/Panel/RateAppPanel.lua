--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
RateAppPanel = {}

--lua model end

--lua functions
---@class RateAppPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Title MoonClient.MLuaUICom
---@field TextRateNow MoonClient.MLuaUICom
---@field TextNoRate MoonClient.MLuaUICom
---@field PanelRate MoonClient.MLuaUICom
---@field Message MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom
---@field BtnRateNow MoonClient.MLuaUICom
---@field BtnNoRate MoonClient.MLuaUICom

---@return RateAppPanel
---@param ctrl UIBase
function RateAppPanel.Bind(ctrl)
	
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
return UI.RateAppPanel