--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
InfinityTowerResultPanel = {}

--lua model end

--lua functions
---@class InfinityTowerResultPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field StageStart MoonClient.MLuaUICom
---@field StageJumpTo MoonClient.MLuaUICom
---@field StageFinish MoonClient.MLuaUICom
---@field StageFailed MoonClient.MLuaUICom
---@field JumpToTxt MoonClient.MLuaUICom

---@return InfinityTowerResultPanel
---@param ctrl UIBase
function InfinityTowerResultPanel.Bind(ctrl)
	
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
return UI.InfinityTowerResultPanel