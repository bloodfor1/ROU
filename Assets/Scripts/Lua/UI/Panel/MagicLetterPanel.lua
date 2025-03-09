--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
MagicLetterPanel = {}

--lua model end

--lua functions
---@class MagicLetterPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_WisePlayer MoonClient.MLuaUICom
---@field Txt_SenderName MoonClient.MLuaUICom
---@field Txt_ReceiveName MoonClient.MLuaUICom
---@field Txt_ExplainCollect MoonClient.MLuaUICom
---@field Txt_EffectName MoonClient.MLuaUICom
---@field Txt_blessingCoinNum MoonClient.MLuaUICom
---@field Text_Blessing MoonClient.MLuaUICom
---@field Spawn_OpenLetter MoonClient.MLuaUICom
---@field Raw_Effect MoonClient.MLuaUICom
---@field Panel_SendOut MoonClient.MLuaUICom
---@field Panel_Collect MoonClient.MLuaUICom
---@field Panel_Award MoonClient.MLuaUICom
---@field Input_Blessing MoonClient.MLuaUICom
---@field Effect_OpenLetter MoonClient.MLuaUICom
---@field Btn_Thanks MoonClient.MLuaUICom
---@field Btn_Send MoonClient.MLuaUICom
---@field Btn_Face MoonClient.MLuaUICom
---@field Btn_Close MoonClient.MLuaUICom
---@field Btn_ChooseRole MoonClient.MLuaUICom
---@field Btn_ChooseEffect MoonClient.MLuaUICom

---@return MagicLetterPanel
---@param ctrl UIBase
function MagicLetterPanel.Bind(ctrl)
	
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
return UI.MagicLetterPanel