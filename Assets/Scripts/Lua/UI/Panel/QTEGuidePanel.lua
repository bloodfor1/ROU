--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
QTEGuidePanel = {}

--lua model end

--lua functions
---@class QTEGuidePanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field ShowImage MoonClient.MLuaUICom
---@field Root MoonClient.MLuaUICom
---@field IntroductionText MoonClient.MLuaUICom
---@field IntroductionPart MoonClient.MLuaUICom
---@field EventButton MoonClient.MLuaUICom
---@field EffectPart MoonClient.MLuaUICom
---@field Effect MoonClient.MLuaUICom[]
---@field Arrow MoonClient.MLuaUICom[]

---@return QTEGuidePanel
function QTEGuidePanel.Bind(ctrl)

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
return UI.QTEGuidePanel