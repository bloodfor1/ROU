--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
CookingDoublePanel = {}

--lua model end

--lua functions
---@class CookingDoublePanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtTimeLeft MoonClient.MLuaUICom
---@field TxtMenuFinished MoonClient.MLuaUICom
---@field Txt_MenuScore MoonClient.MLuaUICom
---@field TimeOver MoonClient.MLuaUICom
---@field Start MoonClient.MLuaUICom
---@field MenuOffset MoonClient.MLuaUICom
---@field MenuDest MoonClient.MLuaUICom
---@field CookingUrgentMenuIcon MoonClient.MLuaUICom
---@field CookingMenuIcon MoonClient.MLuaUICom
---@field CookingDoubleUrgentMenu MoonClient.MLuaUICom
---@field CookingDoubleMenu MoonClient.MLuaUICom
---@field BtnOperation MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom

---@return CookingDoublePanel
---@param ctrl UIBaseCtrl
function CookingDoublePanel.Bind(ctrl)
	
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
return UI.CookingDoublePanel