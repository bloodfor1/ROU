--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
MallMysteryPanel = {}

--lua model end

--lua functions
---@class MallMysteryPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field MysteryTag MoonClient.MLuaUICom
---@field ItemGroup MoonClient.MLuaUICom

---@return MallMysteryPanel
---@param ctrl UIBase
function MallMysteryPanel.Bind(ctrl)
	
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
return UI.MallMysteryPanel