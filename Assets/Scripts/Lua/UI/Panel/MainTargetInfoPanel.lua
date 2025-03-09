--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
MainTargetInfoPanel = {}

--lua model end

--lua functions
---@class MainTargetInfoPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TipsHeadIcon MoonClient.MLuaUICom
---@field TipsDes MoonClient.MLuaUICom
---@field TargetName MoonClient.MLuaUICom
---@field TargetIconBG MoonClient.MLuaUICom
---@field RoleTarget MoonClient.MLuaUICom
---@field RoleSlider MoonClient.MLuaUICom
---@field RoleNameLab MoonClient.MLuaUICom
---@field RoleInfoCloseBtn MoonClient.MLuaUICom
---@field RoleHeadIcon MoonClient.MLuaUICom
---@field reduceBuff MoonClient.MLuaUICom
---@field RayCastMonster MoonClient.MLuaUICom
---@field RayCastBoss MoonClient.MLuaUICom
---@field NpcTarget MoonClient.MLuaUICom
---@field NpcNameLab MoonClient.MLuaUICom
---@field NpcHeadInfo MoonClient.MLuaUICom
---@field NpcCloseBtn MoonClient.MLuaUICom
---@field mvpFlag MoonClient.MLuaUICom
---@field MonsterTypeShapeLab MoonClient.MLuaUICom
---@field MonsterTypeRaceLab MoonClient.MLuaUICom
---@field MonsterTypeAttrLab MoonClient.MLuaUICom
---@field MonsterTips MoonClient.MLuaUICom
---@field MonsterTarget MoonClient.MLuaUICom
---@field MonsterSlider MoonClient.MLuaUICom
---@field MonsterNameLab MoonClient.MLuaUICom
---@field MonsterLvLab MoonClient.MLuaUICom
---@field MonsterHeadInfo MoonClient.MLuaUICom
---@field MonsterCloseBtn MoonClient.MLuaUICom
---@field miniFlag MoonClient.MLuaUICom
---@field LevelImage MoonClient.MLuaUICom
---@field icon2 MoonClient.MLuaUICom
---@field icon MoonClient.MLuaUICom
---@field HeadBG MoonClient.MLuaUICom
---@field GMMonsterInfo MoonClient.MLuaUICom
---@field Fill MoonClient.MLuaUICom
---@field EnemyTarget MoonClient.MLuaUICom
---@field EnemySpSlider MoonClient.MLuaUICom
---@field EnemyNameLab MoonClient.MLuaUICom
---@field EnemyHpSlider MoonClient.MLuaUICom
---@field EnemyHeadIcon MoonClient.MLuaUICom
---@field EnemyCloseBtn MoonClient.MLuaUICom
---@field Effect222 MoonClient.MLuaUICom
---@field Effect MoonClient.MLuaUICom
---@field CombNumLab MoonClient.MLuaUICom
---@field buffList MoonClient.MLuaUICom
---@field BtnLake MoonClient.MLuaUICom
---@field BtnKillWithoutMercy MoonClient.MLuaUICom
---@field BossTargetPro MoonClient.MLuaUICom
---@field BossTargetName MoonClient.MLuaUICom
---@field BossTarget MoonClient.MLuaUICom
---@field BossSpSlider MoonClient.MLuaUICom
---@field BossNameLab2 MoonClient.MLuaUICom
---@field BossNameLab MoonClient.MLuaUICom
---@field BossLvlImage MoonClient.MLuaUICom
---@field BossLvLab MoonClient.MLuaUICom
---@field BossLine MoonClient.MLuaUICom
---@field BossHpSlider MoonClient.MLuaUICom
---@field BossHeadIcon MoonClient.MLuaUICom
---@field BossCloseBtn MoonClient.MLuaUICom
---@field BossBG MoonClient.MLuaUICom
---@field Blin MoonClient.MLuaUICom
---@field addBuff MoonClient.MLuaUICom

---@return MainTargetInfoPanel
---@param ctrl UIBase
function MainTargetInfoPanel.Bind(ctrl)
	
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
return UI.MainTargetInfoPanel