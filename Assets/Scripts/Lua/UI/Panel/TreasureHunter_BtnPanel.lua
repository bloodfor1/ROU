--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
TreasureHunter_BtnPanel = {}

--lua model end

--lua functions
---@class TreasureHunter_BtnPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TreasureHunter_btn MoonClient.MLuaUICom
---@field TextCd MoonClient.MLuaUICom
---@field maskCd MoonClient.MLuaUICom

---@return TreasureHunter_BtnPanel
---@param ctrl UIBase
function TreasureHunter_BtnPanel.Bind(ctrl)
	
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
return UI.TreasureHunter_BtnPanel