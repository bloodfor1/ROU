--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
BoliFindPanel = {}

--lua model end

--lua functions
---@class BoliFindPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field FindText MoonClient.MLuaUICom
---@field BtnIllustration MoonClient.MLuaUICom
---@field BoliShowView MoonClient.MLuaUICom
---@field BoliName MoonClient.MLuaUICom
---@field BoliBg MoonClient.MLuaUICom

---@return BoliFindPanel
---@param ctrl UIBaseCtrl
function BoliFindPanel.Bind(ctrl)
	
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
return UI.BoliFindPanel