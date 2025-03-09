--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
SkillLevelUpgradingPanel = {}

--lua model end

--lua functions
---@class SkillLevelUpgradingPanel.SkillUpgradeItemTemplate
---@field PanelRef MoonClient.MLuaUIPanel
---@field skillUpTip MoonClient.MLuaUICom
---@field skillUpLv MoonClient.MLuaUICom
---@field skillTip MoonClient.MLuaUICom
---@field skillName MoonClient.MLuaUICom
---@field skillLv MoonClient.MLuaUICom
---@field Image MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom

---@class SkillLevelUpgradingPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field scrollTip MoonClient.MLuaUICom
---@field scrollPart MoonClient.MLuaUICom
---@field normalPart MoonClient.MLuaUICom
---@field imageUp MoonClient.MLuaUICom
---@field imageDown MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom
---@field SkillUpgradeItemTemplate SkillLevelUpgradingPanel.SkillUpgradeItemTemplate

---@return SkillLevelUpgradingPanel
function SkillLevelUpgradingPanel.Bind(ctrl)

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
return UI.SkillLevelUpgradingPanel