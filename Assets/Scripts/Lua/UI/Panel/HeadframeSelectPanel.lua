--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
HeadframeSelectPanel = {}

--lua model end

--lua functions
---@class HeadframeSelectPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field widget_empty MoonClient.MLuaUICom
---@field txt_title MoonClient.MLuaUICom
---@field txt_time MoonClient.MLuaUICom
---@field txt_detail_desc MoonClient.MLuaUICom
---@field TitleCondition MoonClient.MLuaUICom
---@field SearchInput MoonClient.MLuaUICom
---@field scroll_view_item MoonClient.MLuaUICom
---@field obj_unavailible MoonClient.MLuaUICom
---@field obj_in_use MoonClient.MLuaUICom
---@field dummy_icon MoonClient.MLuaUICom
---@field btn_use MoonClient.MLuaUICom
---@field btn_clear_input MoonClient.MLuaUICom
---@field HeadframeSelectItem MoonClient.MLuaUIGroup

---@return HeadframeSelectPanel
---@param ctrl UIBase
function HeadframeSelectPanel.Bind(ctrl)
	
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
return UI.HeadframeSelectPanel