--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
PollyRewardPanel = {}

--lua model end

--lua functions
---@class PollyRewardPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Content MoonClient.MLuaUICom
---@field CloseButton MoonClient.MLuaUICom
---@field PollyRegionReward MoonClient.MLuaUIGroup

---@return PollyRewardPanel
function PollyRewardPanel.Bind(ctrl)

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
return UI.PollyRewardPanel