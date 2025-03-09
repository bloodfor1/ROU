--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
BuildPlanPanel = {}

--lua model end

--lua functions
---@class BuildPlanPanel.MultiSkillTitleLineTemplate
---@field PanelRef MoonClient.MLuaUIPanel
---@field Text MoonClient.MLuaUICom
---@field Line MoonClient.MLuaUICom

---@class BuildPlanPanel.MultiSkillEmptyLineTemplate
---@field PanelRef MoonClient.MLuaUIPanel
---@field EmptyLine MoonClient.MLuaUICom

---@class BuildPlanPanel.MultiSkillLineTemplate.SlotHurtTemplate
---@field PanelRef MoonClient.MLuaUIPanel
---@field Text5 MoonClient.MLuaUICom
---@field Text3 MoonClient.MLuaUICom
---@field SKILLICON MoonClient.MLuaUICom
---@field LvText MoonClient.MLuaUICom
---@field Btn_skill MoonClient.MLuaUICom
---@field Bg_zikuang5 MoonClient.MLuaUICom
---@field Bg_zikuang3 MoonClient.MLuaUICom

---@class BuildPlanPanel.MultiSkillLineTemplate
---@field PanelRef MoonClient.MLuaUIPanel
---@field SkillLine MoonClient.MLuaUICom
---@field SlotHurtTemplate BuildPlanPanel.MultiSkillLineTemplate.SlotHurtTemplate

---@class BuildPlanPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field SkillScroll MoonClient.MLuaUICom
---@field SkillPlanName MoonClient.MLuaUICom
---@field Skill MoonClient.MLuaUICom
---@field LeftPoints MoonClient.MLuaUICom
---@field JobName MoonClient.MLuaUICom
---@field JobLevel MoonClient.MLuaUICom
---@field Job MoonClient.MLuaUICom
---@field AttrTpl MoonClient.MLuaUICom
---@field AttrName MoonClient.MLuaUICom
---@field AttrIcon MoonClient.MLuaUICom
---@field Attr MoonClient.MLuaUICom
---@field AddPoints MoonClient.MLuaUICom
---@field MultiSkillTitleLineTemplate BuildPlanPanel.MultiSkillTitleLineTemplate
---@field MultiSkillEmptyLineTemplate BuildPlanPanel.MultiSkillEmptyLineTemplate
---@field MultiSkillLineTemplate BuildPlanPanel.MultiSkillLineTemplate

---@return BuildPlanPanel
---@param ctrl UIBaseCtrl
function BuildPlanPanel.Bind(ctrl)
	
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
return UI.BuildPlanPanel