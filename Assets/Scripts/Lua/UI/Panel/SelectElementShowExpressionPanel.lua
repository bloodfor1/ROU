--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
SelectElementShowExpressionPanel = {}

--lua model end

--lua functions
---@class SelectElementShowExpressionPanel.BtnExpressionInstance
---@field PanelRef MoonClient.MLuaUIPanel
---@field ImgHeadExpression MoonClient.MLuaUICom
---@field BtnExpressionInstance MoonClient.MLuaUICom

---@class SelectElementShowExpressionPanel.BtnFaceExpressionInstance
---@field PanelRef MoonClient.MLuaUIPanel
---@field BtnFaceExpressionInstance MoonClient.MLuaUICom

---@class SelectElementShowExpressionPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field SingleActionContent MoonClient.MLuaUICom
---@field Scroll2 MoonClient.MLuaUICom
---@field Scroll1 MoonClient.MLuaUICom
---@field MultActionContent MoonClient.MLuaUICom
---@field BtnExpressionInstance SelectElementShowExpressionPanel.BtnExpressionInstance
---@field BtnFaceExpressionInstance SelectElementShowExpressionPanel.BtnFaceExpressionInstance

---@return SelectElementShowExpressionPanel
function SelectElementShowExpressionPanel.Bind(ctrl)

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
return UI.SelectElementShowExpressionPanel