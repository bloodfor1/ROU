--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
ChoicePlayerPanel = {}

--lua model end

--lua functions
---@class ChoicePlayerPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Panel_NonePlayer MoonClient.MLuaUICom
---@field Loop_Players MoonClient.MLuaUICom
---@field Btn_Determine MoonClient.MLuaUICom
---@field Btn_Cancel MoonClient.MLuaUICom
---@field Bg MoonClient.MLuaUICom
---@field Template_playerInfo MoonClient.MLuaUIGroup

---@return ChoicePlayerPanel
---@param ctrl UIBase
function ChoicePlayerPanel.Bind(ctrl)
	
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
return UI.ChoicePlayerPanel