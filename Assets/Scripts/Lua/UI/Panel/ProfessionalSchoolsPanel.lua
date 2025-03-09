--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
ProfessionalSchoolsPanel = {}

--lua model end

--lua functions
---@class ProfessionalSchoolsPanel.SkillRecomItemTemplate.SkillRecomImageItemTemplate
---@field PanelRef MoonClient.MLuaUIPanel
---@field Text MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom

---@class ProfessionalSchoolsPanel.SkillRecomItemTemplate
---@field PanelRef MoonClient.MLuaUIPanel
---@field StarIcon MoonClient.MLuaUICom[]
---@field Skill MoonClient.MLuaUICom
---@field Select MoonClient.MLuaUICom
---@field SchoolName MoonClient.MLuaUICom
---@field SchoolIcon MoonClient.MLuaUICom
---@field SchoolDesc MoonClient.MLuaUICom
---@field FeatureTxt MoonClient.MLuaUICom[]
---@field FeatureImg MoonClient.MLuaUICom[]
---@field BG MoonClient.MLuaUICom
---@field SkillRecomImageItemTemplate ProfessionalSchoolsPanel.SkillRecomItemTemplate.SkillRecomImageItemTemplate

---@class ProfessionalSchoolsPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field recomBtn MoonClient.MLuaUICom
---@field previewBtn MoonClient.MLuaUICom
---@field PanelName MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom
---@field closeBtn MoonClient.MLuaUICom
---@field addPointBtn MoonClient.MLuaUICom
---@field SkillRecomItemTemplate ProfessionalSchoolsPanel.SkillRecomItemTemplate

---@return ProfessionalSchoolsPanel
function ProfessionalSchoolsPanel.Bind(ctrl)

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
return UI.ProfessionalSchoolsPanel