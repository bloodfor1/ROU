--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
FishAutoSettingPanel = {}

--lua model end

--lua functions
---@class FishAutoSettingPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TogAutoContuine MoonClient.MLuaUICom
---@field TimeSelect MoonClient.MLuaUICom
---@field TimeRemainTip MoonClient.MLuaUICom
---@field TimeRemainText MoonClient.MLuaUICom
---@field TimeCanFishTip MoonClient.MLuaUICom
---@field CostItem MoonClient.MLuaUICom
---@field BtnTog MoonClient.MLuaUICom
---@field BtnSure MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom

---@return FishAutoSettingPanel
function FishAutoSettingPanel.Bind(ctrl)

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
return UI.FishAutoSettingPanel