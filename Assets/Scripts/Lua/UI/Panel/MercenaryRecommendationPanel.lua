--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
MercenaryRecommendationPanel = {}

--lua model end

--lua functions
---@class MercenaryRecommendationPanel.MercenarySelectCell
---@field PanelRef MoonClient.MLuaUIPanel
---@field Selection MoonClient.MLuaUICom
---@field Recommend MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field Location MoonClient.MLuaUICom
---@field JobImg MoonClient.MLuaUICom
---@field HeadImg MoonClient.MLuaUICom
---@field Explain MoonClient.MLuaUICom

---@class MercenaryRecommendationPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Title MoonClient.MLuaUICom
---@field RewardCloseButton MoonClient.MLuaUICom
---@field MercenaryScroll MoonClient.MLuaUICom
---@field DesText MoonClient.MLuaUICom
---@field MercenarySelectCell MercenaryRecommendationPanel.MercenarySelectCell

---@return MercenaryRecommendationPanel
function MercenaryRecommendationPanel.Bind(ctrl)

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
return UI.MercenaryRecommendationPanel