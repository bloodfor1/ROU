--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
BartendingPanel = {}

--lua model end

--lua functions
---@class BartendingPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field WinLightEffect MoonClient.MLuaUICom
---@field StartAnim MoonClient.MLuaUICom
---@field SliderHp MoonClient.MLuaUICom
---@field ShakeGlass MoonClient.MLuaUICom
---@field ShakeBottle MoonClient.MLuaUICom
---@field Shake MoonClient.MLuaUICom
---@field LiqueurPourWine MoonClient.MLuaUICom
---@field LiqueurOpenCap MoonClient.MLuaUICom
---@field Liqueur MoonClient.MLuaUICom
---@field GuideArrow4 MoonClient.MLuaUICom
---@field GuideArrow3 MoonClient.MLuaUICom
---@field GuideArrow2 MoonClient.MLuaUICom
---@field GuideArrow MoonClient.MLuaUICom
---@field Complete MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom
---@field BluePourWine MoonClient.MLuaUICom
---@field BlueOpenCap MoonClient.MLuaUICom
---@field BlueberryJuice MoonClient.MLuaUICom
---@field Bar MoonClient.MLuaUICom

---@return BartendingPanel
---@param ctrl UIBaseCtrl
function BartendingPanel.Bind(ctrl)
	
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
return UI.BartendingPanel