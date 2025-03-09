--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
ViewtitlePanel = {}

--lua model end

--lua functions
---@class ViewtitlePanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TitleName MoonClient.MLuaUICom
---@field TargetIcon MoonClient.MLuaUICom
---@field Bg MoonClient.MLuaUICom

---@return ViewtitlePanel
function ViewtitlePanel.Bind(ctrl)
	
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
return UI.ViewtitlePanel