--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
Theme_InformationPanel = {}

--lua model end

--lua functions
---@class Theme_InformationPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TitleName MoonClient.MLuaUICom
---@field InformationText MoonClient.MLuaUICom
---@field InformationScroll MoonClient.MLuaUICom
---@field Effect MoonClient.MLuaUICom
---@field DownArrow MoonClient.MLuaUICom
---@field Bg MoonClient.MLuaUICom
---@field BackBtn MoonClient.MLuaUICom

---@return Theme_InformationPanel
---@param ctrl UIBase
function Theme_InformationPanel.Bind(ctrl)
	
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
return UI.Theme_InformationPanel