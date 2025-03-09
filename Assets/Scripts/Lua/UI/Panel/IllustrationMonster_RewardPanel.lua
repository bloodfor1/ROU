--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
IllustrationMonster_RewardPanel = {}

--lua model end

--lua functions
---@class IllustrationMonster_RewardPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtMsg MoonClient.MLuaUICom
---@field Scroll MoonClient.MLuaUICom
---@field ButtonClose MoonClient.MLuaUICom
---@field IllustrationMonster_Reward_RowTem MoonClient.MLuaUIGroup

---@return IllustrationMonster_RewardPanel
---@param ctrl UIBase
function IllustrationMonster_RewardPanel.Bind(ctrl)
	
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
return UI.IllustrationMonster_RewardPanel