--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
InfinityTowerPanel = {}

--lua model end

--lua functions
---@class InfinityTowerPanel.InfinityTowerBtn
---@field PanelRef MoonClient.MLuaUIPanel
---@field TmpClear MoonClient.MLuaUICom
---@field Text MoonClient.MLuaUICom
---@field StageBtn MoonClient.MLuaUICom
---@field MVP MoonClient.MLuaUICom
---@field Image1 MoonClient.MLuaUICom
---@field Image MoonClient.MLuaUICom

---@class InfinityTowerPanel.InfinityTowerPrefab
---@field PanelRef MoonClient.MLuaUIPanel

---@class InfinityTowerPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtGetFirstRewardWhite MoonClient.MLuaUICom
---@field RawImage1 MoonClient.MLuaUICom
---@field RawImage MoonClient.MLuaUICom
---@field ImgGetFirstReward MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom
---@field BtnReward MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom
---@field InfinityTowerBtn InfinityTowerPanel.InfinityTowerBtn
---@field InfinityTowerPrefab InfinityTowerPanel.InfinityTowerPrefab

---@return InfinityTowerPanel
---@param ctrl UIBase
function InfinityTowerPanel.Bind(ctrl)
	
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
return UI.InfinityTowerPanel