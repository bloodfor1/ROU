--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
ChatboxSelectPanel = {}

--lua model end

--lua functions
---@class ChatboxSelectPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field widget_empty MoonClient.MLuaUICom
---@field txt_time MoonClient.MLuaUICom
---@field txt_in_use MoonClient.MLuaUICom
---@field txt_in_active MoonClient.MLuaUICom
---@field txt_detail MoonClient.MLuaUICom
---@field txt_chat MoonClient.MLuaUICom
---@field txt_bubble_name MoonClient.MLuaUICom
---@field TitleCondition MoonClient.MLuaUICom
---@field loop_scroll MoonClient.MLuaUICom
---@field input_search MoonClient.MLuaUICom
---@field img_bubble MoonClient.MLuaUICom
---@field btn_save MoonClient.MLuaUICom
---@field btn_clear_input MoonClient.MLuaUICom
---@field ChatBubbleItem MoonClient.MLuaUIGroup

---@return ChatboxSelectPanel
---@param ctrl UIBase
function ChatboxSelectPanel.Bind(ctrl)
	
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
return UI.ChatboxSelectPanel