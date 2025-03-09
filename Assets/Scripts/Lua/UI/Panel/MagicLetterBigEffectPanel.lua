--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
MagicLetterBigEffectPanel = {}

--lua model end

--lua functions
---@class MagicLetterBigEffectPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Panel_EffectParent MoonClient.MLuaUICom
---@field Effect_Send MoonClient.MLuaUICom
---@field Effect_Receive MoonClient.MLuaUICom

---@return MagicLetterBigEffectPanel
---@param ctrl UIBase
function MagicLetterBigEffectPanel.Bind(ctrl)
	
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
return UI.MagicLetterBigEffectPanel