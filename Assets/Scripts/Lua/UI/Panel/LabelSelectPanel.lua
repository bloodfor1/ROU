--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
LabelSelectPanel = {}

--lua model end

--lua functions
---@class LabelSelectPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field widget_inuse MoonClient.MLuaUICom
---@field widget_head_icon MoonClient.MLuaUICom
---@field widget_empty MoonClient.MLuaUICom
---@field txt_title MoonClient.MLuaUICom
---@field txt_tag_lv MoonClient.MLuaUICom
---@field txt_player_name MoonClient.MLuaUICom
---@field txt_inactive MoonClient.MLuaUICom
---@field txt_detail MoonClient.MLuaUICom
---@field txt_chat_content MoonClient.MLuaUICom
---@field TitleLine MoonClient.MLuaUICom
---@field TitleCondition MoonClient.MLuaUICom
---@field search_input MoonClient.MLuaUICom
---@field scroll_view MoonClient.MLuaUICom
---@field img_tag_bg MoonClient.MLuaUICom
---@field img_label_icon MoonClient.MLuaUICom
---@field img_chat_bg MoonClient.MLuaUICom
---@field btn_save MoonClient.MLuaUICom
---@field btn_clear_input MoonClient.MLuaUICom
---@field btn_check_other_lv MoonClient.MLuaUICom
---@field btn_check_lv MoonClient.MLuaUICom
---@field ChatTagSelectItem MoonClient.MLuaUIGroup

---@return LabelSelectPanel
---@param ctrl UIBase
function LabelSelectPanel.Bind(ctrl)
	
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
return UI.LabelSelectPanel