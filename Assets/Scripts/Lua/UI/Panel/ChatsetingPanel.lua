--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
ChatsetingPanel = {}

--lua model end

--lua functions
---@class ChatsetingPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field QuickWatch MoonClient.MLuaUICom
---@field QuickTeam MoonClient.MLuaUICom
---@field QuickGuild MoonClient.MLuaUICom
---@field QuickChat MoonClient.MLuaUICom
---@field MainTogle5 MoonClient.MLuaUICom
---@field MainTogle4 MoonClient.MLuaUICom
---@field MainTogle3 MoonClient.MLuaUICom
---@field MainTogle2 MoonClient.MLuaUICom
---@field MainTogle1 MoonClient.MLuaUICom
---@field MainTogle MoonClient.MLuaUICom
---@field MainPlate MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom

---@return ChatsetingPanel
---@param ctrl UIBaseCtrl
function ChatsetingPanel.Bind(ctrl)
	
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
return UI.ChatsetingPanel