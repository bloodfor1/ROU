--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
NumberCodeInputPanel = {}

--lua model end

--lua functions
---@class NumberCodeInputPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Main MoonClient.MLuaUICom
---@field KeyOk MoonClient.MLuaUICom
---@field KeyDel MoonClient.MLuaUICom
---@field Key9 MoonClient.MLuaUICom
---@field Key8 MoonClient.MLuaUICom
---@field Key7 MoonClient.MLuaUICom
---@field Key6 MoonClient.MLuaUICom
---@field Key5 MoonClient.MLuaUICom
---@field Key4 MoonClient.MLuaUICom
---@field Key3 MoonClient.MLuaUICom
---@field Key2 MoonClient.MLuaUICom
---@field Key1 MoonClient.MLuaUICom
---@field Key0 MoonClient.MLuaUICom
---@field Floor MoonClient.MLuaUICom

---@return NumberCodeInputPanel
function NumberCodeInputPanel.Bind(ctrl)

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
return UI.NumberCodeInputPanel