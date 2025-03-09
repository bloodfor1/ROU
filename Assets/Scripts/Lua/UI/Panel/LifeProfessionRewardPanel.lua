--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
LifeProfessionRewardPanel = {}

--lua model end

--lua functions
---@class LifeProfessionRewardPanel.Prefab
---@field PanelRef MoonClient.MLuaUIPanel
---@field Icon MoonClient.MLuaUICom
---@field Count MoonClient.MLuaUICom
---@field Btn MoonClient.MLuaUICom

---@class LifeProfessionRewardPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtTitle_2 MoonClient.MLuaUICom
---@field TxtTitle_1 MoonClient.MLuaUICom
---@field Title_2 MoonClient.MLuaUICom
---@field Title_1 MoonClient.MLuaUICom
---@field TextInfo MoonClient.MLuaUICom
---@field RewardList MoonClient.MLuaUICom
---@field Parent MoonClient.MLuaUICom
---@field Mod1 MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom
---@field Prefab LifeProfessionRewardPanel.Prefab

---@return LifeProfessionRewardPanel
function LifeProfessionRewardPanel.Bind(ctrl)

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
return UI.LifeProfessionRewardPanel