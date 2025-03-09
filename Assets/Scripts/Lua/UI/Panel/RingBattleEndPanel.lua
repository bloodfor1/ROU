--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
RingBattleEndPanel = {}

--lua model end

--lua functions
---@class RingBattleEndPanel.BtnPlayerTemplate
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtName MoonClient.MLuaUICom
---@field TxtJob MoonClient.MLuaUICom
---@field ScoreNum MoonClient.MLuaUICom
---@field MvpScoreNum MoonClient.MLuaUICom
---@field MVP MoonClient.MLuaUICom
---@field KillNum MoonClient.MLuaUICom
---@field HelpNum MoonClient.MLuaUICom
---@field Head MoonClient.MLuaUICom
---@field DeadNum MoonClient.MLuaUICom
---@field BtnPlayer MoonClient.MLuaUICom
---@field BtnLike MoonClient.MLuaUICom
---@field BtnFriend MoonClient.MLuaUICom

---@class RingBattleEndPanel.BtnOtherTemplate
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtName MoonClient.MLuaUICom
---@field TxtJob MoonClient.MLuaUICom
---@field ScoreNum MoonClient.MLuaUICom
---@field MvpScoreNum MoonClient.MLuaUICom
---@field MVP MoonClient.MLuaUICom
---@field KillNum MoonClient.MLuaUICom
---@field HelpNum MoonClient.MLuaUICom
---@field Head MoonClient.MLuaUICom
---@field DeadNum MoonClient.MLuaUICom
---@field BtnPlayer MoonClient.MLuaUICom
---@field BtnLike MoonClient.MLuaUICom
---@field BtnFriend MoonClient.MLuaUICom

---@class RingBattleEndPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field WinRedCountLab MoonClient.MLuaUICom[]
---@field WinLab MoonClient.MLuaUICom
---@field Win MoonClient.MLuaUICom
---@field SaveBtn MoonClient.MLuaUICom
---@field RawImage MoonClient.MLuaUICom
---@field PlayerContent MoonClient.MLuaUICom
---@field OtherContent MoonClient.MLuaUICom
---@field MobileBtn MoonClient.MLuaUICom
---@field LoseRedCountLab MoonClient.MLuaUICom[]
---@field Lose MoonClient.MLuaUICom
---@field HideBtn MoonClient.MLuaUICom
---@field FailLab MoonClient.MLuaUICom
---@field ConfirmText MoonClient.MLuaUICom
---@field ConfirmBtn MoonClient.MLuaUICom
---@field CloseTip MoonClient.MLuaUICom
---@field BG MoonClient.MLuaUICom
---@field BtnPlayerTemplate RingBattleEndPanel.BtnPlayerTemplate
---@field BtnOtherTemplate RingBattleEndPanel.BtnOtherTemplate

---@return RingBattleEndPanel
function RingBattleEndPanel.Bind(ctrl)

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
return UI.RingBattleEndPanel