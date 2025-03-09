--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
RunningBusinessSettlementPanel = {}

--lua model end

--lua functions
---@class RunningBusinessSettlementPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtTime MoonClient.MLuaUICom
---@field TxtMoney MoonClient.MLuaUICom
---@field Title MoonClient.MLuaUICom
---@field TextSubmit MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom
---@field Context MoonClient.MLuaUICom
---@field CloseButton MoonClient.MLuaUICom
---@field BtnSubmit MoonClient.MLuaUICom

---@return RunningBusinessSettlementPanel
function RunningBusinessSettlementPanel.Bind(ctrl)

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
return UI.RunningBusinessSettlementPanel