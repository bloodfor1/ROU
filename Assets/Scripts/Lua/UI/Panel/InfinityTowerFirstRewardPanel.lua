--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
InfinityTowerFirstRewardPanel = {}

--lua model end

--lua functions
---@class InfinityTowerFirstRewardPanel.TowerFirstRewardTemplate
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtLevel MoonClient.MLuaUICom
---@field TxtGetReward MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom
---@field BtnGetReward MoonClient.MLuaUICom

---@class InfinityTowerFirstRewardPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field InfinityTowerFirstRewardContent MoonClient.MLuaUICom
---@field BtnCloseRight MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom
---@field TowerFirstRewardTemplate InfinityTowerFirstRewardPanel.TowerFirstRewardTemplate

---@return InfinityTowerFirstRewardPanel
---@param ctrl UIBase
function InfinityTowerFirstRewardPanel.Bind(ctrl)
	
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
return UI.InfinityTowerFirstRewardPanel