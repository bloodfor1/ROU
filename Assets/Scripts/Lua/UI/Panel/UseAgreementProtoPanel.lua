--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
UseAgreementProtoPanel = {}

--lua model end

--lua functions
---@class UseAgreementProtoPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TogProtoUser MoonClient.MLuaUICom
---@field TogProtoGame MoonClient.MLuaUICom
---@field TogNightPush MoonClient.MLuaUICom
---@field TogAllPush MoonClient.MLuaUICom
---@field BtnUser MoonClient.MLuaUICom
---@field BtnSure MoonClient.MLuaUICom
---@field BtnGame MoonClient.MLuaUICom
---@field BtnAgree MoonClient.MLuaUICom

---@return UseAgreementProtoPanel
---@param ctrl UIBase
function UseAgreementProtoPanel.Bind(ctrl)
	
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
return UI.UseAgreementProtoPanel