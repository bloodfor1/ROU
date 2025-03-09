--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
BattleArenaPanel = {}

--lua model end

--lua functions
---@class BattleArenaPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field WaitPanel MoonClient.MLuaUICom
---@field Tips MoonClient.MLuaUICom
---@field TipBg MoonClient.MLuaUICom
---@field timerLab MoonClient.MLuaUICom
---@field TeamMatchTipOther MoonClient.MLuaUICom
---@field TeamMatchTip MoonClient.MLuaUICom
---@field RuningTips MoonClient.MLuaUICom
---@field redCountLab MoonClient.MLuaUICom
---@field pkObject MoonClient.MLuaUICom
---@field MemberInWaitTipText MoonClient.MLuaUICom
---@field MemberInWaitTip MoonClient.MLuaUICom
---@field MemberCountTipText MoonClient.MLuaUICom
---@field MemberCountTip MoonClient.MLuaUICom
---@field Matching MoonClient.MLuaUICom
---@field JoinTeamTipMore MoonClient.MLuaUICom
---@field JoinTeamTip MoonClient.MLuaUICom
---@field FightPanel MoonClient.MLuaUICom
---@field desText MoonClient.MLuaUICom
---@field CountDown MoonClient.MLuaUICom
---@field BtnExit MoonClient.MLuaUICom
---@field blueCountLab MoonClient.MLuaUICom
---@field BeginTipText MoonClient.MLuaUICom
---@field BeginTip MoonClient.MLuaUICom
---@field Alarm MoonClient.MLuaUICom

---@return BattleArenaPanel
---@param ctrl UIBase
function BattleArenaPanel.Bind(ctrl)
	
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
return UI.BattleArenaPanel