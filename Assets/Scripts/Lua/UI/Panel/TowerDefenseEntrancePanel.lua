--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
TowerDefenseEntrancePanel = {}

--lua model end

--lua functions
---@class TowerDefenseEntrancePanel.ItemPrefab
---@field PanelRef MoonClient.MLuaUIPanel
---@field ItemName MoonClient.MLuaUICom
---@field ItemIcon MoonClient.MLuaUICom
---@field ItemCount MoonClient.MLuaUICom
---@field ItemButton MoonClient.MLuaUICom

---@class TowerDefenseEntrancePanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtTipsUp MoonClient.MLuaUICom
---@field TxtTipsMid MoonClient.MLuaUICom
---@field TxtTipsDown MoonClient.MLuaUICom
---@field TxtTimes MoonClient.MLuaUICom
---@field TxtTeam MoonClient.MLuaUICom
---@field TxtSingleOnLevel MoonClient.MLuaUICom
---@field TxtSingleOffLevel MoonClient.MLuaUICom
---@field TxtScore MoonClient.MLuaUICom
---@field TxtLevelLimit MoonClient.MLuaUICom
---@field TxtInfo MoonClient.MLuaUICom
---@field TxtGrayLevel MoonClient.MLuaUICom
---@field TxtExplain MoonClient.MLuaUICom
---@field TxtDoubleOnLevel MoonClient.MLuaUICom
---@field TxtDoubleOffLevel MoonClient.MLuaUICom
---@field TogSingle MoonClient.MLuaUICom
---@field TogDouble MoonClient.MLuaUICom
---@field TDAwardButton MoonClient.MLuaUICom
---@field ScrollViewAwardPreview MoonClient.MLuaUICom
---@field RedSignPrompt MoonClient.MLuaUICom
---@field PanelTips MoonClient.MLuaUICom
---@field PanelExplain MoonClient.MLuaUICom
---@field NoDefenseBless MoonClient.MLuaUICom
---@field NoAttackBless MoonClient.MLuaUICom
---@field ImgMap MoonClient.MLuaUICom
---@field ImgEffect MoonClient.MLuaUICom
---@field DefenseBlessButton MoonClient.MLuaUICom
---@field DefenseBless MoonClient.MLuaUICom
---@field ButtonClose MoonClient.MLuaUICom
---@field BtnTeam MoonClient.MLuaUICom
---@field BtnScoreTips MoonClient.MLuaUICom
---@field BtnGroup MoonClient.MLuaUICom
---@field BtnDoubleGray MoonClient.MLuaUICom
---@field BtnDefense MoonClient.MLuaUICom
---@field BtnCloseExplain MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom
---@field AttackBlessButton MoonClient.MLuaUICom
---@field AttackBless MoonClient.MLuaUICom
---@field ItemPrefab TowerDefenseEntrancePanel.ItemPrefab

---@return TowerDefenseEntrancePanel
---@param ctrl UIBase
function TowerDefenseEntrancePanel.Bind(ctrl)
	
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
return UI.TowerDefenseEntrancePanel