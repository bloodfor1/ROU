--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
BagTipsMorePanel = {}

--lua model end

--lua functions
---@class BagTipsMorePanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtTipMore MoonClient.MLuaUICom
---@field LayoutBtn MoonClient.MLuaUICom
---@field BtnTipMore MoonClient.MLuaUICom

---@return BagTipsMorePanel
---@param ctrl UIBaseCtrl
function BagTipsMorePanel.Bind(ctrl)
	
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
return UI.BagTipsMorePanel