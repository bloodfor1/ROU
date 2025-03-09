--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
ProfessionPanel = {}

--lua model end

--lua functions
---@class ProfessionPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field ScrollView MoonClient.MLuaUICom
---@field ButtonTpl MoonClient.MLuaUICom
---@field ButtonOk MoonClient.MLuaUICom

---@return ProfessionPanel
function ProfessionPanel.Bind(ctrl)

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
return UI.ProfessionPanel