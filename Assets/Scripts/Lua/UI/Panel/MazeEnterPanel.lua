--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
MazeEnterPanel = {}

--lua model end

--lua functions
---@class MazeEnterPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field MemberTxt MoonClient.MLuaUICom
---@field LvTxt MoonClient.MLuaUICom
---@field Describe MoonClient.MLuaUICom
---@field CostTxt MoonClient.MLuaUICom
---@field CostIcon MoonClient.MLuaUICom
---@field BtnTeam MoonClient.MLuaUICom
---@field BtnStart MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom
---@field AwardView MoonClient.MLuaUICom
---@field AwardCountTxt MoonClient.MLuaUICom

---@return MazeEnterPanel
function MazeEnterPanel.Bind(ctrl)

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
return UI.MazeEnterPanel