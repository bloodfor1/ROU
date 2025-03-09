--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
BgmHousePanel = {}

--lua model end

--lua functions
---@class BgmHousePanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtTitle MoonClient.MLuaUICom
---@field TxtComment MoonClient.MLuaUICom
---@field ScrollView MoonClient.MLuaUICom
---@field ImageCD MoonClient.MLuaUICom
---@field BtnStop MoonClient.MLuaUICom
---@field BtnPlay MoonClient.MLuaUICom
---@field BtnNext MoonClient.MLuaUICom
---@field BtnLast MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom
---@field BGMCover MoonClient.MLuaUICom

---@return BgmHousePanel
---@param ctrl UIBaseCtrl
function BgmHousePanel.Bind(ctrl)
	
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
return UI.BgmHousePanel