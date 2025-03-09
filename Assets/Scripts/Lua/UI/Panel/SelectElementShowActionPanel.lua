--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
SelectElementShowActionPanel = {}

--lua model end

--lua functions
---@class SelectElementShowActionPanel.SelectElementShowAction
---@field PanelRef MoonClient.MLuaUIPanel
---@field TextIntimacy MoonClient.MLuaUICom
---@field Text MoonClient.MLuaUICom
---@field Image1 MoonClient.MLuaUICom
---@field Image MoonClient.MLuaUICom
---@field BtnSingleInstance MoonClient.MLuaUICom

---@class SelectElementShowActionPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field SingleActionContent MoonClient.MLuaUICom
---@field Scroll2 MoonClient.MLuaUICom
---@field Scroll1 MoonClient.MLuaUICom
---@field MultActionContent MoonClient.MLuaUICom
---@field SelectElementShowAction SelectElementShowActionPanel.SelectElementShowAction

---@return SelectElementShowActionPanel
function SelectElementShowActionPanel.Bind(ctrl)

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
return UI.SelectElementShowActionPanel