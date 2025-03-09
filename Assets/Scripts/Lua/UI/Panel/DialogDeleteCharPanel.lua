--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
DialogDeleteCharPanel = {}

--lua model end

--lua functions
---@class DialogDeleteCharPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtYes MoonClient.MLuaUICom
---@field TxtPlaceholder MoonClient.MLuaUICom
---@field TxtNo MoonClient.MLuaUICom
---@field TxtMsg MoonClient.MLuaUICom
---@field root MoonClient.MLuaUICom
---@field Pro MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field Level MoonClient.MLuaUICom
---@field InputMessage MoonClient.MLuaUICom
---@field IconBg MoonClient.MLuaUICom
---@field Head MoonClient.MLuaUICom
---@field dialog MoonClient.MLuaUICom
---@field Description MoonClient.MLuaUICom
---@field BtnYes MoonClient.MLuaUICom
---@field BtnNo MoonClient.MLuaUICom

---@return DialogDeleteCharPanel
---@param ctrl UIBase
function DialogDeleteCharPanel.Bind(ctrl)
	
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
return UI.DialogDeleteCharPanel