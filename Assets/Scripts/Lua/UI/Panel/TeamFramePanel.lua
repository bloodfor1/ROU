--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
TeamFramePanel = {}

--lua model end

--lua functions
---@class TeamFramePanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field scrollView MoonClient.MLuaUICom
---@field member MoonClient.MLuaUICom
---@field ImgJob MoonClient.MLuaUICom
---@field content MoonClient.MLuaUICom

---@return TeamFramePanel
function TeamFramePanel.Bind(ctrl)

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
return UI.TeamFramePanel