--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
InfinityTowerStageInfoPanel = {}

--lua model end

--lua functions
---@class InfinityTowerStageInfoPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtRecommandChallengeLevel MoonClient.MLuaUICom
---@field TmpStageInfoTitle MoonClient.MLuaUICom
---@field StageInfoRewardContent MoonClient.MLuaUICom
---@field MVPImage MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom
---@field BtnChallengeLevel MoonClient.MLuaUICom

---@return InfinityTowerStageInfoPanel
function InfinityTowerStageInfoPanel.Bind(ctrl)

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
return UI.InfinityTowerStageInfoPanel