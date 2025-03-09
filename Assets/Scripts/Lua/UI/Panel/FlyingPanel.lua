--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
FlyingPanel = {}

--lua model end

--lua functions
---@class FlyingPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TextNpc MoonClient.MLuaUICom
---@field TextName MoonClient.MLuaUICom
---@field TextContent MoonClient.MLuaUICom
---@field MaskButton MoonClient.MLuaUICom
---@field Flying_xin MoonClient.MLuaUICom
---@field Flying_ka MoonClient.MLuaUICom
---@field CardImg MoonClient.MLuaUICom
---@field BtnMailAccept MoonClient.MLuaUICom
---@field BtnCardAccept MoonClient.MLuaUICom
---@field BgMaskButton MoonClient.MLuaUICom

---@return FlyingPanel
function FlyingPanel.Bind(ctrl)

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
return UI.FlyingPanel