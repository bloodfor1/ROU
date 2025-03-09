--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
MainTowerDefensePanel = {}

--lua model end

--lua functions
---@class MainTowerDefensePanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtWaveCount MoonClient.MLuaUICom
---@field TxtTurn MoonClient.MLuaUICom
---@field TxtTime MoonClient.MLuaUICom
---@field TxtNumber MoonClient.MLuaUICom
---@field TxtMana MoonClient.MLuaUICom
---@field TxtHp MoonClient.MLuaUICom
---@field TurnTipsText MoonClient.MLuaUICom
---@field TurnTips MoonClient.MLuaUICom
---@field SliderHpImage MoonClient.MLuaUICom
---@field SliderHp MoonClient.MLuaUICom
---@field ShowAwardRateNumber MoonClient.MLuaUICom
---@field QuickCommand MoonClient.MLuaUICom
---@field NextTipsTextAnimation MoonClient.MLuaUICom
---@field NextTips MoonClient.MLuaUICom
---@field NextButton MoonClient.MLuaUICom
---@field FromPosition MoonClient.MLuaUICom
---@field EndlessStartPanel MoonClient.MLuaUICom
---@field EndlessStartEffectImage MoonClient.MLuaUICom
---@field BtnExit MoonClient.MLuaUICom
---@field AnimationParent MoonClient.MLuaUICom
---@field MainTowerDefenseSkillPrefab MoonClient.MLuaUIGroup
---@field TowerDefenseGetMagicAnimation MoonClient.MLuaUIGroup

---@return MainTowerDefensePanel
---@param ctrl UIBase
function MainTowerDefensePanel.Bind(ctrl)
	
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
return UI.MainTowerDefensePanel