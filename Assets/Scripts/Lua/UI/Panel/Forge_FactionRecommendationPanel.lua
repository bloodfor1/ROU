--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
Forge_FactionRecommendationPanel = {}

--lua model end

--lua functions
---@class Forge_FactionRecommendationPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtMsg MoonClient.MLuaUICom
---@field LoopVertical MoonClient.MLuaUICom
---@field ButtonClose MoonClient.MLuaUICom
---@field Btn_Restore MoonClient.MLuaUICom
---@field Btn_OK MoonClient.MLuaUICom

---@return Forge_FactionRecommendationPanel
---@param ctrl UIBase
function Forge_FactionRecommendationPanel.Bind(ctrl)
	
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
return UI.Forge_FactionRecommendationPanel