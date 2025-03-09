--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
RollbackSpinePanel = {}

--lua model end

--lua functions
---@class RollbackSpinePanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TweenScale MoonClient.MLuaUICom
---@field TweenMove MoonClient.MLuaUICom
---@field SkeletonGraphic MoonClient.MLuaUICom

---@return RollbackSpinePanel
---@param ctrl UIBase
function RollbackSpinePanel.Bind(ctrl)
	
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
return UI.RollbackSpinePanel