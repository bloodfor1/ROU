--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
ConsultationPanel = {}

--lua model end

--lua functions
---@class ConsultationPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field SearchButton MoonClient.MLuaUICom
---@field QuestionInputFieldImage MoonClient.MLuaUICom
---@field QuestionInputField MoonClient.MLuaUICom
---@field CapraQuestionTipsParent MoonClient.MLuaUICom
---@field CapraFAQScroll MoonClient.MLuaUICom
---@field CapraQuestionPrefab MoonClient.MLuaUIGroup
---@field CapraAnswerPrefab MoonClient.MLuaUIGroup
---@field CapraQuestionTipsPrefab MoonClient.MLuaUIGroup

---@return ConsultationPanel
---@param ctrl UIBase
function ConsultationPanel.Bind(ctrl)
	
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
return UI.ConsultationPanel