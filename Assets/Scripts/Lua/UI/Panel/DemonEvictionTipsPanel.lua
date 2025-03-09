--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
DemonEvictionTipsPanel = {}

--lua model end

--lua functions
---@class DemonEvictionTipsPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TreasureChest MoonClient.MLuaUICom
---@field ExperienceStrange MoonClient.MLuaUICom
---@field Desc MoonClient.MLuaUICom
---@field Btn_Close MoonClient.MLuaUICom
---@field BelowContent MoonClient.MLuaUICom
---@field AboveContent MoonClient.MLuaUICom
---@field DemonEvictionTipsTemplate MoonClient.MLuaUIGroup

---@return DemonEvictionTipsPanel
---@param ctrl UIBaseCtrl
function DemonEvictionTipsPanel.Bind(ctrl)
	
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
return UI.DemonEvictionTipsPanel