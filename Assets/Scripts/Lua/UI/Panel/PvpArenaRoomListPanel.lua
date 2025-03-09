--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
PvpArenaRoomListPanel = {}

--lua model end

--lua functions
---@class PvpArenaRoomListPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field uiWrapContent MoonClient.MLuaUICom
---@field scrollView MoonClient.MLuaUICom
---@field roomItem MoonClient.MLuaUICom
---@field noObject MoonClient.MLuaUICom
---@field closeBtn MoonClient.MLuaUICom

---@return PvpArenaRoomListPanel
function PvpArenaRoomListPanel.Bind(ctrl)

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
return UI.PvpArenaRoomListPanel