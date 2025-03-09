--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
HowtoplayPanel = {}

--lua model end

--lua functions
---@class HowtoplayPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Tween MoonClient.MLuaUICom
---@field Text MoonClient.MLuaUICom
---@field Right MoonClient.MLuaUICom
---@field Point MoonClient.MLuaUICom
---@field PagesGroup MoonClient.MLuaUICom
---@field Mask MoonClient.MLuaUICom
---@field Left MoonClient.MLuaUICom
---@field Image3 MoonClient.MLuaUICom
---@field Image2 MoonClient.MLuaUICom
---@field Image1 MoonClient.MLuaUICom
---@field CloseBtn MoonClient.MLuaUICom
---@field Checkmark MoonClient.MLuaUICom

---@return HowtoplayPanel
function HowtoplayPanel.Bind(ctrl)

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
return UI.HowtoplayPanel