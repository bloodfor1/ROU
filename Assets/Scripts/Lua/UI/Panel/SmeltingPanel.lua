--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
SmeltingPanel = {}

--lua model end

--lua functions
---@class SmeltingPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field WeaponRawImage MoonClient.MLuaUICom
---@field TieZhenRawImage MoonClient.MLuaUICom
---@field TieHuaEffect MoonClient.MLuaUICom
---@field StarTrailEffect2 MoonClient.MLuaUICom
---@field StarTrailEffect1 MoonClient.MLuaUICom
---@field StarTrailEffect MoonClient.MLuaUICom
---@field StartAnim MoonClient.MLuaUICom
---@field StarFlowEffect2 MoonClient.MLuaUICom
---@field StarFlowEffect1 MoonClient.MLuaUICom
---@field StarFlowEffect MoonClient.MLuaUICom
---@field StarDropEffect2 MoonClient.MLuaUICom
---@field StarDropEffect1 MoonClient.MLuaUICom
---@field StarDropEffect MoonClient.MLuaUICom
---@field Star03 MoonClient.MLuaUICom
---@field Star02 MoonClient.MLuaUICom
---@field Star01 MoonClient.MLuaUICom
---@field SmeltSuc MoonClient.MLuaUICom
---@field SliderHp MoonClient.MLuaUICom
---@field progressFullEffect MoonClient.MLuaUICom
---@field PerfectScore MoonClient.MLuaUICom
---@field outerCircle MoonClient.MLuaUICom
---@field OperateTip MoonClient.MLuaUICom
---@field MissScore MoonClient.MLuaUICom
---@field innerCircle MoonClient.MLuaUICom
---@field HammerRawImage MoonClient.MLuaUICom
---@field GoodScore MoonClient.MLuaUICom
---@field CritTimeEffect MoonClient.MLuaUICom
---@field Crit MoonClient.MLuaUICom
---@field CountdownEffect MoonClient.MLuaUICom
---@field ContinueTip MoonClient.MLuaUICom
---@field ContinueClick MoonClient.MLuaUICom
---@field ClickEffect MoonClient.MLuaUICom
---@field BtnFullScreen MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom
---@field Bg2 MoonClient.MLuaUICom
---@field Bg1 MoonClient.MLuaUICom
---@field Bg MoonClient.MLuaUICom

---@return SmeltingPanel
function SmeltingPanel.Bind(ctrl)

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
return UI.SmeltingPanel