--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
WatchWarPanel = {}

--lua model end

--lua functions
---@class WatchWarPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field WatchClassifyButtonParent MoonClient.MLuaUICom
---@field SearchInput MoonClient.MLuaUICom
---@field ScrollView MoonClient.MLuaUICom
---@field Empty MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom
---@field BtnSearchCancel MoonClient.MLuaUICom
---@field BtnSearch MoonClient.MLuaUICom
---@field BtnScrollRect MoonClient.MLuaUICom
---@field Btn_N_B02 MoonClient.MLuaUICom
---@field Btn_N_B01 MoonClient.MLuaUICom
---@field WatchClassifyButtonTemplate MoonClient.MLuaUIGroup
---@field WatchDetailsButtonTemplate MoonClient.MLuaUIGroup

---@return WatchWarPanel
---@param ctrl UIBase
function WatchWarPanel.Bind(ctrl)
	
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
return UI.WatchWarPanel