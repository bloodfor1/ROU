--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
CordFirePanel = {}

--lua model end

--lua functions
---@class CordFirePanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field cdEffRoot MoonClient.MLuaUICom
---@field CDEffImg MoonClient.MLuaUICom

---@return CordFirePanel
---@param ctrl UIBase
function CordFirePanel.Bind(ctrl)
	
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
return UI.CordFirePanel