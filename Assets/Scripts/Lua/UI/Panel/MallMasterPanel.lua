--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
MallMasterPanel = {}

--lua model end

--lua functions
---@class MallMasterPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field MasterHouseZenyTag MoonClient.MLuaUICom
---@field MasterHouseTags MoonClient.MLuaUICom
---@field MasterHouseCopperTag MoonClient.MLuaUICom
---@field ItemGroup MoonClient.MLuaUICom

---@return MallMasterPanel
---@param ctrl UIBase
function MallMasterPanel.Bind(ctrl)
	
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
return UI.MallMasterPanel