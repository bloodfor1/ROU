--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
MvpRankPanel = {}

--lua model end

--lua functions
---@class MvpRankPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field timeObj MoonClient.MLuaUICom
---@field timeLab MoonClient.MLuaUICom
---@field teamItem MoonClient.MLuaUICom
---@field sceneLab MoonClient.MLuaUICom
---@field nameLabel MoonClient.MLuaUICom
---@field myTeam MoonClient.MLuaUICom
---@field lvLab MoonClient.MLuaUICom
---@field headIcon MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom
---@field closeBtn MoonClient.MLuaUICom

---@return MvpRankPanel
function MvpRankPanel.Bind(ctrl)

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
return UI.MvpRankPanel