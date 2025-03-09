--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
CapraFAQFeedbackPanel = {}

--lua model end

--lua functions
---@class CapraFAQFeedbackPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtMsg MoonClient.MLuaUICom
---@field Text_Num MoonClient.MLuaUICom
---@field QuestionInputFieldImage MoonClient.MLuaUICom
---@field QuestionInputField MoonClient.MLuaUICom
---@field ConfirmButton MoonClient.MLuaUICom
---@field CancelButton MoonClient.MLuaUICom
---@field ButtonClose MoonClient.MLuaUICom

---@return CapraFAQFeedbackPanel
---@param ctrl UIBase
function CapraFAQFeedbackPanel.Bind(ctrl)
	
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
return UI.CapraFAQFeedbackPanel