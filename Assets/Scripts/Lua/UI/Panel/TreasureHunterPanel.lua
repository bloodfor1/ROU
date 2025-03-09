--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
TreasureHunterPanel = {}

--lua model end

--lua functions
---@class TreasureHunterPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field umberUp MoonClient.MLuaUICom
---@field umberdown MoonClient.MLuaUICom
---@field Texttips MoonClient.MLuaUICom
---@field Textsecond MoonClient.MLuaUICom
---@field Textminute MoonClient.MLuaUICom
---@field Texthour MoonClient.MLuaUICom
---@field starPoint MoonClient.MLuaUICom
---@field Object_Trove MoonClient.MLuaUICom
---@field Object_Deep MoonClient.MLuaUICom
---@field Mask_Bit MoonClient.MLuaUICom
---@field LoopScroll MoonClient.MLuaUICom
---@field endPoint MoonClient.MLuaUICom
---@field Btn_Wenhao MoonClient.MLuaUICom
---@field Btn_Invite MoonClient.MLuaUICom
---@field Btn_Help MoonClient.MLuaUICom
---@field Btn_Guild MoonClient.MLuaUICom

---@return TreasureHunterPanel
---@param ctrl UIBase
function TreasureHunterPanel.Bind(ctrl)
	
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
return UI.TreasureHunterPanel