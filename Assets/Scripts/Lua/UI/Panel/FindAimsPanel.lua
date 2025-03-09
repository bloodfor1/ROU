--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
FindAimsPanel = {}

--lua model end

--lua functions
---@class FindAimsPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtMeshTip1 MoonClient.MLuaUICom
---@field TxtMeshTip MoonClient.MLuaUICom
---@field PanelKpl MoonClient.MLuaUICom
---@field FxShow1 MoonClient.MLuaUICom
---@field FxShow MoonClient.MLuaUICom

---@return FindAimsPanel
function FindAimsPanel.Bind(ctrl)

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
return UI.FindAimsPanel