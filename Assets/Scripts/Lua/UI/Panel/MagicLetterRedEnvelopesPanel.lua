--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
MagicLetterRedEnvelopesPanel = {}

--lua model end

--lua functions
---@class MagicLetterRedEnvelopesPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_RedEnvelopeType MoonClient.MLuaUICom
---@field Txt_Num MoonClient.MLuaUICom
---@field Raw_Effect MoonClient.MLuaUICom
---@field Panel_OpenRedEnvelopeSuc MoonClient.MLuaUICom
---@field Panel_OpenRedEnvelopeFail MoonClient.MLuaUICom
---@field Panel_OpenRedEnvelope MoonClient.MLuaUICom
---@field Obj_Item MoonClient.MLuaUICom
---@field Btn_Open MoonClient.MLuaUICom
---@field Btn_BG MoonClient.MLuaUICom

---@return MagicLetterRedEnvelopesPanel
---@param ctrl UIBase
function MagicLetterRedEnvelopesPanel.Bind(ctrl)
	
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
return UI.MagicLetterRedEnvelopesPanel