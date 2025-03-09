--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
HeroChallengePanel = {}

--lua model end

--lua functions
---@class HeroChallengePanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TotalScoreText MoonClient.MLuaUICom
---@field TotalScoreInfoBtn MoonClient.MLuaUICom
---@field StartBtn MoonClient.MLuaUICom
---@field StageName MoonClient.MLuaUICom
---@field ScrollView MoonClient.MLuaUICom
---@field ScoreText MoonClient.MLuaUICom
---@field RightBtn MoonClient.MLuaUICom
---@field RewardReceived MoonClient.MLuaUICom
---@field RewardInfoBtn MoonClient.MLuaUICom
---@field RewardContent MoonClient.MLuaUICom
---@field PassTimeText MoonClient.MLuaUICom
---@field Nanduxuanze MoonClient.MLuaUICom
---@field Nandu3Tog MoonClient.MLuaUICom
---@field Nandu2Tog MoonClient.MLuaUICom
---@field Nandu1Tog MoonClient.MLuaUICom
---@field Loots MoonClient.MLuaUICom
---@field LeftBtn MoonClient.MLuaUICom
---@field Item MoonClient.MLuaUICom
---@field DungeonInfoBtn MoonClient.MLuaUICom
---@field DifficultText MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom
---@field BossImg MoonClient.MLuaUICom
---@field BossBtn MoonClient.MLuaUICom
---@field AlreadyReceived MoonClient.MLuaUICom

---@return HeroChallengePanel
function HeroChallengePanel.Bind(ctrl)

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
return UI.HeroChallengePanel