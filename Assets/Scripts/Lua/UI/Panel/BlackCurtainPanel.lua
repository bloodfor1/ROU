--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
BlackCurtainPanel = {}

--lua model end

--lua functions
---@class BlackCurtainPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TipStart MoonClient.MLuaUICom
---@field Tip MoonClient.MLuaUICom
---@field LineText MoonClient.MLuaUICom
---@field DefaultBG MoonClient.MLuaUICom
---@field Contents MoonClient.MLuaUICom
---@field ContentBG MoonClient.MLuaUICom
---@field BG MoonClient.MLuaUICom

---@return BlackCurtainPanel
---@param ctrl UIBaseCtrl
function BlackCurtainPanel.Bind(ctrl)
	
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
return UI.BlackCurtainPanel