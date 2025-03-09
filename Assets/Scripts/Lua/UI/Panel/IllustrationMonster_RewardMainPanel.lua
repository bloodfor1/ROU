--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
IllustrationMonster_RewardMainPanel = {}

--lua model end

--lua functions
---@class IllustrationMonster_RewardMainPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtMsg MoonClient.MLuaUICom
---@field MainLoop MoonClient.MLuaUICom
---@field Lvl MoonClient.MLuaUICom
---@field LoopHor MoonClient.MLuaUICom
---@field Empty MoonClient.MLuaUICom
---@field CloseBtn MoonClient.MLuaUICom
---@field Btn_Right MoonClient.MLuaUICom
---@field Btn_Left MoonClient.MLuaUICom
---@field MonsterBookAttrRewardLineTem MoonClient.MLuaUIGroup
---@field MonsterBookMainRewardTem MoonClient.MLuaUIGroup

---@return IllustrationMonster_RewardMainPanel
---@param ctrl UIBase
function IllustrationMonster_RewardMainPanel.Bind(ctrl)
	
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
return UI.IllustrationMonster_RewardMainPanel