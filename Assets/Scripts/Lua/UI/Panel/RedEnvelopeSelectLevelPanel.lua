--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
RedEnvelopeSelectLevelPanel = {}

--lua model end

--lua functions
---@class RedEnvelopeSelectLevelPanel.RedEnvelopeLevelItemPrefab
---@field PanelRef MoonClient.MLuaUIPanel
---@field TotalText MoonClient.MLuaUICom
---@field SelectIcon MoonClient.MLuaUICom
---@field SelectCellButton MoonClient.MLuaUICom
---@field CostText MoonClient.MLuaUICom

---@class RedEnvelopeSelectLevelPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TitleText MoonClient.MLuaUICom
---@field RedEnvelopeLevelItemParent MoonClient.MLuaUICom
---@field BtnSure MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom
---@field BtnCancel MoonClient.MLuaUICom
---@field RedEnvelopeLevelItemPrefab RedEnvelopeSelectLevelPanel.RedEnvelopeLevelItemPrefab

---@return RedEnvelopeSelectLevelPanel
function RedEnvelopeSelectLevelPanel.Bind(ctrl)

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
return UI.RedEnvelopeSelectLevelPanel