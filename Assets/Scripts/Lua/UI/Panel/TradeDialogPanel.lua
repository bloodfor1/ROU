--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
TradeDialogPanel = {}

--lua model end

--lua functions
---@class TradeDialogPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtYes MoonClient.MLuaUICom
---@field TxtOK MoonClient.MLuaUICom
---@field TxtNo MoonClient.MLuaUICom
---@field TxtMsg MoonClient.MLuaUICom
---@field Toggle MoonClient.MLuaUICom
---@field roNumLab MoonClient.MLuaUICom
---@field Image MoonClient.MLuaUICom
---@field doubleLab MoonClient.MLuaUICom
---@field dialog3 MoonClient.MLuaUICom
---@field dialog2 MoonClient.MLuaUICom
---@field dialog1 MoonClient.MLuaUICom
---@field BtnYes MoonClient.MLuaUICom
---@field BtnOK MoonClient.MLuaUICom
---@field BtnNo MoonClient.MLuaUICom

---@return TradeDialogPanel
function TradeDialogPanel.Bind(ctrl)
	
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
return UI.TradeDialogPanel