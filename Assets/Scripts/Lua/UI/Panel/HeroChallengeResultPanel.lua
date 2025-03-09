--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
HeroChallengeResultPanel = {}

--lua model end

--lua functions
---@class HeroChallengeResultPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field WinSkeletonAnimation MoonClient.MLuaUICom
---@field TitleDescription5 MoonClient.MLuaUICom
---@field TitleDescription4 MoonClient.MLuaUICom
---@field TitleDescription3 MoonClient.MLuaUICom
---@field TitleDescription1 MoonClient.MLuaUICom
---@field Title4 MoonClient.MLuaUICom
---@field Title3 MoonClient.MLuaUICom
---@field Title1 MoonClient.MLuaUICom
---@field StampDescription MoonClient.MLuaUICom
---@field Stamp MoonClient.MLuaUICom
---@field StageVictory MoonClient.MLuaUICom
---@field StageFailed MoonClient.MLuaUICom
---@field passTimeText2 MoonClient.MLuaUICom
---@field passTimeText MoonClient.MLuaUICom
---@field newScore MoonClient.MLuaUICom
---@field info MoonClient.MLuaUICom
---@field gotoText MoonClient.MLuaUICom
---@field gotoBtn MoonClient.MLuaUICom
---@field fx2 MoonClient.MLuaUICom
---@field Effect3 MoonClient.MLuaUICom
---@field Effect2 MoonClient.MLuaUICom
---@field Effect MoonClient.MLuaUICom
---@field degreeStarPanel MoonClient.MLuaUICom
---@field degreeStar MoonClient.MLuaUICom
---@field bg MoonClient.MLuaUICom
---@field AwardContent MoonClient.MLuaUICom
---@field Assist MoonClient.MLuaUICom

---@return HeroChallengeResultPanel
function HeroChallengeResultPanel.Bind(ctrl)

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
return UI.HeroChallengeResultPanel