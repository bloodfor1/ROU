--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
BlessedExperiencePanel = {}

--lua model end

--lua functions
---@class BlessedExperiencePanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Tip_txt MoonClient.MLuaUICom
---@field Panel MoonClient.MLuaUICom
---@field Job_txt MoonClient.MLuaUICom
---@field Info_txt MoonClient.MLuaUICom
---@field Confirm_btn MoonClient.MLuaUICom
---@field Btn_BlessInfo MoonClient.MLuaUICom
---@field Base_txt MoonClient.MLuaUICom

---@return BlessedExperiencePanel
---@param ctrl UIBase
function BlessedExperiencePanel.Bind(ctrl)
	
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
return UI.BlessedExperiencePanel