--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
TeamSetPanel = {}

--lua model end

--lua functions
---@class TeamSetPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtTarget MoonClient.MLuaUICom
---@field TxtName MoonClient.MLuaUICom
---@field Tgl04 MoonClient.MLuaUICom
---@field Tgl03 MoonClient.MLuaUICom
---@field Tgl02 MoonClient.MLuaUICom
---@field Tgl01 MoonClient.MLuaUICom
---@field EquipSelectButton MoonClient.MLuaUICom
---@field ButtonClose MoonClient.MLuaUICom
---@field BtnTarget MoonClient.MLuaUICom
---@field Btnconfirm MoonClient.MLuaUICom

---@return TeamSetPanel
function TeamSetPanel.Bind(ctrl)

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
return UI.TeamSetPanel