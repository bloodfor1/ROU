--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
MarkTipsPanel = {}

--lua model end

--lua functions
---@class MarkTipsPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TittleTxt MoonClient.MLuaUICom
---@field Parent MoonClient.MLuaUICom
---@field MarkTips MoonClient.MLuaUICom
---@field InfoText MoonClient.MLuaUICom
---@field CloseBtn MoonClient.MLuaUICom

---@return MarkTipsPanel
function MarkTipsPanel.Bind(ctrl)

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
return UI.MarkTipsPanel