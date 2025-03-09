--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/BaseUITemplate"
require "UI/Template/SkillRecomImageItemTemplate"
--lua requires end

--lua model
module("UITemplate", package.seeall)

--lua model end

--lua fields
local super = UITemplate.BaseUITemplate
--lua fields end

--lua class define
---@class SkillRecomItemTemplateParameter.SkillRecomImageItemTemplate
---@field PanelRef MoonClient.MLuaUIPanel
---@field Text MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom

---@class SkillRecomItemTemplateParameter
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
---@field SkillRecomImageItemTemplate SkillRecomItemTemplateParameter.SkillRecomImageItemTemplate

---@class SkillRecomItemTemplate : BaseUITemplate
---@field Parameter SkillRecomItemTemplateParameter

SkillRecomItemTemplate = class("SkillRecomItemTemplate", super)
--lua class define end

--lua functions
function SkillRecomItemTemplate:Init()
	
	super.Init(self)
	self.data = DataMgr:GetData("SkillData")
	self.skillPool = self:NewTemplatePool({
		UITemplateClass = UITemplate.SkillRecomImageItemTemplate,
		TemplateParent = self.Parameter.Skill.transform,
		TemplatePrefab = self.Parameter.SkillRecomImageItemTemplate.LuaUIGroup.gameObject
	})
	self.featureInfos = {
		{ atlas = "Role1", sprite = "UI_Role_Panel_Small_leixing_02.png", text = Lang("SKILL_RECOMMOND_2")},
		{ atlas = "Role1", sprite = "UI_Role_Panel_Small_leixing_01.png", text = Lang("SKILL_RECOMMOND_1")},
		{ atlas = "Role1", sprite = "UI_Role_Panel_Small_leixing_03.png", text = Lang("SKILL_RECOMMOND_3")}
	}
	
end --func end
--next--
function SkillRecomItemTemplate:OnDestroy()
	
	    self.data = nil
	
end --func end
--next--
function SkillRecomItemTemplate:OnDeActive()
	
	
end --func end
--next--
function SkillRecomItemTemplate:OnSetData(data)
	
	self:Select(false)
	local autoAddDetailSdata = self.data.GetDataFromTable("AutoAddSkilPointDetailTable", data.schoolId)
	self.Parameter.SchoolIcon:SetSpriteAsync(autoAddDetailSdata.ClassIconAtlas, autoAddDetailSdata.ClassIconSprite)
	self.Parameter.SchoolName.LabText = autoAddDetailSdata.ClassName
	self.Parameter.SchoolDesc.LabText = autoAddDetailSdata.Desc
	for i = 1, math.floor(autoAddDetailSdata.Difficulty) do
		self.Parameter.StarIcon[i].Img.fillAmount = 1
	end
	local floorIdx = math.ceil(autoAddDetailSdata.Difficulty)
	if floorIdx <= 3 and floorIdx ~= autoAddDetailSdata.Difficulty then
		self.Parameter.StarIcon[floorIdx].Img.fillAmount = autoAddDetailSdata.Difficulty - math.floor(autoAddDetailSdata.Difficulty)
	end
	for i = floorIdx + 1, 3 do
		self.Parameter.StarIcon[i].Img.fillAmount = 0
	end
	local features = Common.Functions.VectorToTable(autoAddDetailSdata.FeatureText)
	for i, v in ipairs(features) do
		local featureInfo = self.featureInfos[v]
		self.Parameter.FeatureImg[i]:SetSpriteAsync(featureInfo.atlas, featureInfo.sprite)
		self.Parameter.FeatureTxt[i].LabText = featureInfo.text
	end
	local skillIds, datas = {}, {}
	local recommandId = autoAddDetailSdata.ClassRecommandId
	local l_recommandData = self.data.GetDataFromTable("SkillClassRecommandTable", recommandId)
	if l_recommandData then
		skillIds = Common.Functions.VectorToTable(l_recommandData.SkillIds)
	end
	for i, v in ipairs(skillIds) do
		table.insert(datas, {skillId = v})
	end
	self.skillPool:ShowTemplates({Datas = datas})
	self.Parameter.BG:AddClick(function()
		local ui = UIMgr:GetUI(UI.CtrlNames.ProfessionalSchools)
		if ui then
			ui:SelectSchool(data)
			self:Select(true)
		end
	end)
	
end --func end
--next--
function SkillRecomItemTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function SkillRecomItemTemplate:Select(flag)
    self.Parameter.Select:SetActiveEx(flag)
end
--lua custom scripts end
return SkillRecomItemTemplate