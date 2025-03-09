--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
PotionSettingPanel = {}

--lua model end

--lua functions
---@class PotionSettingPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TogMpUse MoonClient.MLuaUICom
---@field TogHpUse MoonClient.MLuaUICom
---@field SliderMpUse MoonClient.MLuaUICom
---@field SliderHpUse MoonClient.MLuaUICom
---@field SelectItemContent MoonClient.MLuaUICom
---@field SelectDragItemScrollView MoonClient.MLuaUICom
---@field SelectBoard MoonClient.MLuaUICom
---@field SaveBtn MoonClient.MLuaUICom
---@field potionCloseBtn MoonClient.MLuaUICom
---@field MpUseSub MoonClient.MLuaUICom
---@field MpUseAdd MoonClient.MLuaUICom
---@field LabMpPercent MoonClient.MLuaUICom
---@field LabHpPercent MoonClient.MLuaUICom
---@field HpUseSub MoonClient.MLuaUICom
---@field HpUseAdd MoonClient.MLuaUICom
---@field FightAutoSelectItemPanel MoonClient.MLuaUICom
---@field FightAutoMpItems MoonClient.MLuaUICom
---@field FightAutoHpItems MoonClient.MLuaUICom
---@field CloseBtn MoonClient.MLuaUICom
---@field BackBtn MoonClient.MLuaUICom
---@field AutoBattleDargItemTemplate MoonClient.MLuaUIGroup
---@field ItemSelectTemplate MoonClient.MLuaUIGroup

---@return PotionSettingPanel
---@param ctrl UIBase
function PotionSettingPanel.Bind(ctrl)
	
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
return UI.PotionSettingPanel