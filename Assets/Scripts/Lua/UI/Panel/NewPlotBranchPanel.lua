--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
NewPlotBranchPanel = {}

--lua model end

--lua functions
---@class NewPlotBranchPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field SelectParent MoonClient.MLuaUICom
---@field SelectContent_04 MoonClient.MLuaUICom
---@field SelectContent_03 MoonClient.MLuaUICom
---@field SelectContent_02 MoonClient.MLuaUICom
---@field SelectContent_01 MoonClient.MLuaUICom
---@field Select_04 MoonClient.MLuaUICom
---@field Select_03 MoonClient.MLuaUICom
---@field Select_02 MoonClient.MLuaUICom
---@field Select_01 MoonClient.MLuaUICom
---@field Emoji_04 MoonClient.MLuaUICom
---@field Emoji_03 MoonClient.MLuaUICom
---@field Emoji_02 MoonClient.MLuaUICom
---@field Emoji_01 MoonClient.MLuaUICom

---@return NewPlotBranchPanel
---@param ctrl UIBase
function NewPlotBranchPanel.Bind(ctrl)
	
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
return UI.NewPlotBranchPanel