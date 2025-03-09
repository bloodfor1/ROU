--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
ChatRoomMiniPanel = {}

--lua model end

--lua functions
---@class ChatRoomMiniPanel.Prefab
---@field PanelRef MoonClient.MLuaUIPanel
---@field MessageText MoonClient.MLuaUICom

---@class ChatRoomMiniPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TitleIcon MoonClient.MLuaUICom
---@field Parent MoonClient.MLuaUICom
---@field MessageBox MoonClient.MLuaUICom
---@field Main MoonClient.MLuaUICom
---@field BtnEnterChat MoonClient.MLuaUICom
---@field Prefab ChatRoomMiniPanel.Prefab

---@return ChatRoomMiniPanel
---@param ctrl UIBaseCtrl
function ChatRoomMiniPanel.Bind(ctrl)
	
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
return UI.ChatRoomMiniPanel