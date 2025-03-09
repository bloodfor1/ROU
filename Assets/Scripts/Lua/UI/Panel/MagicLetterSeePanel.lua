--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
MagicLetterSeePanel = {}

--lua model end

--lua functions
---@class MagicLetterSeePanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_giftValue MoonClient.MLuaUICom
---@field Txt_blessing MoonClient.MLuaUICom
---@field Spawn_Anim MoonClient.MLuaUICom
---@field Panel_DetailInfo MoonClient.MLuaUICom
---@field LoopScroll_GetRewardPlayers MoonClient.MLuaUICom
---@field Head_Sender MoonClient.MLuaUICom
---@field Head_Receiver MoonClient.MLuaUICom
---@field Effect_Qiang MoonClient.MLuaUICom
---@field Effect_HuaBan MoonClient.MLuaUICom
---@field Btn_OpenRedPacket MoonClient.MLuaUICom
---@field Btn_Close MoonClient.MLuaUICom
---@field Template_MagicLetterRewardGeter MoonClient.MLuaUIGroup

---@return MagicLetterSeePanel
---@param ctrl UIBase
function MagicLetterSeePanel.Bind(ctrl)
	
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
return UI.MagicLetterSeePanel