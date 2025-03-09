--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
GarderobeFashionupgradeTipsPanel = {}

--lua model end

--lua functions
---@class GarderobeFashionupgradeTipsPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field titleName MoonClient.MLuaUICom
---@field Tips MoonClient.MLuaUICom
---@field LV MoonClient.MLuaUICom
---@field Bonus MoonClient.MLuaUICom
---@field BG MoonClient.MLuaUICom
---@field bg MoonClient.MLuaUICom

---@return GarderobeFashionupgradeTipsPanel
---@param ctrl UIBase
function GarderobeFashionupgradeTipsPanel.Bind(ctrl)
	
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
return UI.GarderobeFashionupgradeTipsPanel