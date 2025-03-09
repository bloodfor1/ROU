--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
ChoiceFragrancePanel = {}

--lua model end

--lua functions
---@class ChoiceFragrancePanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Loop_ChooseEffect MoonClient.MLuaUICom
---@field Btn_Determine MoonClient.MLuaUICom
---@field Btn_Bg MoonClient.MLuaUICom
---@field Template_Fragrance MoonClient.MLuaUIGroup

---@return ChoiceFragrancePanel
---@param ctrl UIBase
function ChoiceFragrancePanel.Bind(ctrl)
	
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
return UI.ChoiceFragrancePanel