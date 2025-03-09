--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
PvpArenaPanelPanel = {}

--lua model end

--lua functions
---@class PvpArenaPanelPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TextPvpDesc MoonClient.MLuaUICom
---@field PvpPanel MoonClient.MLuaUICom
---@field pvpJoinBtn MoonClient.MLuaUICom
---@field pvpInfoBtn MoonClient.MLuaUICom
---@field pvpCreatBtn MoonClient.MLuaUICom
---@field pvpClose MoonClient.MLuaUICom
---@field InfoContext MoonClient.MLuaUICom
---@field But_Bg MoonClient.MLuaUICom
---@field BgImg MoonClient.MLuaUICom

---@return PvpArenaPanelPanel
function PvpArenaPanelPanel.Bind(ctrl)

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
return UI.PvpArenaPanelPanel