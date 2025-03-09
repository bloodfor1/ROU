--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
IllustrationMonsterPanel = {}

--lua model end

--lua functions
---@class IllustrationMonsterPanel.MonsterLimitImageTemplate
---@field PanelRef MoonClient.MLuaUIPanel
---@field MonsterLimitText MoonClient.MLuaUICom

---@class IllustrationMonsterPanel.IllustrationMonsterListPrefab
---@field PanelRef MoonClient.MLuaUIPanel
---@field MonsterFivePrefab MoonClient.MLuaUICom

---@class IllustrationMonsterPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field ScrollMonster MoonClient.MLuaUICom
---@field QuestionBtn MoonClient.MLuaUICom
---@field MonsterVitText MoonClient.MLuaUICom
---@field MonsterTypeShapeText MoonClient.MLuaUICom
---@field MonsterTypeShape MoonClient.MLuaUICom
---@field MonsterTypeSelectText MoonClient.MLuaUICom
---@field MonsterTypeSelectButton MoonClient.MLuaUICom
---@field MonsterTypeRaceText MoonClient.MLuaUICom
---@field MonsterTypeRace MoonClient.MLuaUICom
---@field MonsterTypeAttrText MoonClient.MLuaUICom
---@field MonsterTypeAttr MoonClient.MLuaUICom
---@field MonsterType MoonClient.MLuaUICom
---@field MonsterTogDetail3 MoonClient.MLuaUICom
---@field MonsterTogDetail2 MoonClient.MLuaUICom
---@field MonsterTogDetail1 MoonClient.MLuaUICom
---@field MonsterStrText MoonClient.MLuaUICom
---@field MonsterSearchInputField MoonClient.MLuaUICom
---@field MonsterNotKillText MoonClient.MLuaUICom
---@field MonsterNotFoundText MoonClient.MLuaUICom
---@field MonsterName MoonClient.MLuaUICom
---@field MonsterMod MoonClient.MLuaUICom
---@field MonsterMDefNumText MoonClient.MLuaUICom
---@field MonsterMAtkNumText MoonClient.MLuaUICom
---@field MonsterLukText MoonClient.MLuaUICom
---@field MonsterLootContent MoonClient.MLuaUICom
---@field MonsterLiubianxing MoonClient.MLuaUICom
---@field MonsterIntText MoonClient.MLuaUICom
---@field MonsterInfoPanel MoonClient.MLuaUICom
---@field MonsterInfoMap MoonClient.MLuaUICom
---@field MonsterHpNumText MoonClient.MLuaUICom
---@field MonsterHitNumText MoonClient.MLuaUICom
---@field MonsterFleeNumText MoonClient.MLuaUICom
---@field MonsterDexText MoonClient.MLuaUICom
---@field MonsterDetailInfor3 MoonClient.MLuaUICom
---@field MonsterDetailInfor2 MoonClient.MLuaUICom
---@field MonsterDetailInfor1 MoonClient.MLuaUICom
---@field MonsterDefNumText MoonClient.MLuaUICom
---@field MonsterCardButton MoonClient.MLuaUICom
---@field MonsterAtkNumText MoonClient.MLuaUICom
---@field MonsterAgiText MoonClient.MLuaUICom
---@field lvNum MoonClient.MLuaUICom
---@field IllustrationMonster MoonClient.MLuaUICom
---@field DropNum MoonClient.MLuaUICom
---@field CloseBtn MoonClient.MLuaUICom
---@field MonsterLimitImageTemplate IllustrationMonsterPanel.MonsterLimitImageTemplate
---@field IllustrationMonsterListPrefab IllustrationMonsterPanel.IllustrationMonsterListPrefab

---@return IllustrationMonsterPanel
function IllustrationMonsterPanel.Bind(ctrl)

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
return UI.IllustrationMonsterPanel