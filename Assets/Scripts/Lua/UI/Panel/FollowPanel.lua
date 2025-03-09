--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
FollowPanel = {}

--lua model end

--lua functions
---@class FollowPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Text MoonClient.MLuaUICom

---@return FollowPanel
function FollowPanel.Bind(ctrl)

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
return UI.FollowPanel