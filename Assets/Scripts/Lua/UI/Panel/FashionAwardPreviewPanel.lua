--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
FashionAwardPreviewPanel = {}

--lua model end

--lua functions
---@class FashionAwardPreviewPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Title MoonClient.MLuaUICom
---@field ScrollRectZ MoonClient.MLuaUICom
---@field ScrollRectRank MoonClient.MLuaUICom
---@field RewardClosePanel MoonClient.MLuaUICom
---@field RewardCloseButton MoonClient.MLuaUICom
---@field ContentZ MoonClient.MLuaUICom
---@field ContentRank MoonClient.MLuaUICom
---@field BackGround MoonClient.MLuaUICom
---@field RankRewardAll MoonClient.MLuaUIGroup

---@return FashionAwardPreviewPanel
function FashionAwardPreviewPanel.Bind(ctrl)

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
return UI.FashionAwardPreviewPanel