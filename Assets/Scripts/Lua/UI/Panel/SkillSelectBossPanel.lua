--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
SkillSelectBossPanel = {}

--lua model end

--lua functions
---@class SkillSelectBossPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field SelectMVPHP MoonClient.MLuaUICom[]
---@field SelectMVPHead MoonClient.MLuaUICom[]
---@field SelectMVPAnimHelper MoonClient.MLuaUICom[]
---@field SelectMVP MoonClient.MLuaUICom[]
---@field SelectMiniHP MoonClient.MLuaUICom[]
---@field SelectMiniHead MoonClient.MLuaUICom[]
---@field SelectMiniAnimHelper MoonClient.MLuaUICom[]
---@field SelectMini MoonClient.MLuaUICom[]
---@field SelectBossHP MoonClient.MLuaUICom[]
---@field SelectBossHead MoonClient.MLuaUICom[]
---@field SelectBossAnimHelper MoonClient.MLuaUICom[]
---@field SelectBoss MoonClient.MLuaUICom[]
---@field RangeRect MoonClient.MLuaUICom
---@field AimPanel MoonClient.MLuaUICom
---@field AimContent MoonClient.MLuaUICom
---@field TargetGroup MoonClient.MLuaUIGroup

---@return SkillSelectBossPanel
---@param ctrl UIBase
function SkillSelectBossPanel.Bind(ctrl)
	
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
return UI.SkillSelectBossPanel