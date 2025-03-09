--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
BeiluzOperationContainerPanel = {}

--lua model end

--lua functions
---@class BeiluzOperationContainerPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtTitle MoonClient.MLuaUICom
---@field Tog MoonClient.MLuaUICom
---@field PanelRoot MoonClient.MLuaUICom
---@field ButtonClose MoonClient.MLuaUICom

---@return BeiluzOperationContainerPanel
---@param ctrl UIBase
function BeiluzOperationContainerPanel.Bind(ctrl)
	
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
return UI.BeiluzOperationContainerPanel