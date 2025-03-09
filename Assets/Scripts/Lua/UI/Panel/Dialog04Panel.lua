--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
Dialog04Panel = {}

--lua model end

--lua functions
---@class Dialog04Panel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtYes MoonClient.MLuaUICom
---@field TxtMsg MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field Level MoonClient.MLuaUICom
---@field HeadDummy MoonClient.MLuaUICom
---@field BtnYes MoonClient.MLuaUICom
---@field BtnNo MoonClient.MLuaUICom

---@return Dialog04Panel
---@param ctrl UIBase
function Dialog04Panel.Bind(ctrl)
	
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
return UI.Dialog04Panel