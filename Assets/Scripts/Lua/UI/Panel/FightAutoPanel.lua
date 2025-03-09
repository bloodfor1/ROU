--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
FightAutoPanel = {}

--lua model end

--lua functions
---@class FightAutoPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TogSelectInstance MoonClient.MLuaUICom
---@field TogSelectAll MoonClient.MLuaUICom
---@field TogAutoBattleInTask MoonClient.MLuaUICom
---@field ShowMoreArrow MoonClient.MLuaUICom
---@field RangeText MoonClient.MLuaUICom
---@field MonsterItemViewPort MoonClient.MLuaUICom
---@field MonsterItemScrollView MoonClient.MLuaUICom
---@field MonsterIcon MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom
---@field ClosePanel MoonClient.MLuaUICom
---@field BtnSetting MoonClient.MLuaUICom
---@field BtnDrinkMedicine MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom
---@field AutoText MoonClient.MLuaUICom

---@return FightAutoPanel
---@param ctrl UIBase
function FightAutoPanel.Bind(ctrl)
	
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
return UI.FightAutoPanel