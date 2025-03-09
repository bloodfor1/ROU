--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/BaseUITemplate"
--lua requires end

--lua model
module("UITemplate", package.seeall)

--lua model end

--lua fields
local super = UITemplate.BaseUITemplate
--lua fields end

--lua class define
---@class ProfessionSkillClassTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field SkillName MoonClient.MLuaUICom[]
---@field SkillLv MoonClient.MLuaUICom[]
---@field SkillIcon MoonClient.MLuaUICom[]
---@field Skill MoonClient.MLuaUICom[]
---@field SchoolName MoonClient.MLuaUICom[]
---@field School MoonClient.MLuaUICom[]
---@field Prefab MoonClient.MLuaUICom
---@field BtnPlaySkill MoonClient.MLuaUICom[]

---@class ProfessionSkillClassTemplate : BaseUITemplate
---@field Parameter ProfessionSkillClassTemplateParameter

ProfessionSkillClassTemplate = class("ProfessionSkillClassTemplate", super)
--lua class define end

--lua functions
function ProfessionSkillClassTemplate:Init()
	
	super.Init(self)
	self.data = DataMgr:GetData("SkillData")
	
end --func end
--next--
function ProfessionSkillClassTemplate:OnDestroy()
	
	self.data = nil
	
end --func end
--next--
function ProfessionSkillClassTemplate:OnDeActive()
	
	
end --func end
--next--
function ProfessionSkillClassTemplate:OnSetData(data)
	
	local l_skillClassName = data.skillClassName
	local l_skillClassSkillIds = data.skillClassSkillIds
	local l_schoolColor = self.Parameter.School
	l_schoolColor.gameObject:SetActiveEx(true)
	self.Parameter.SchoolName.LabText = l_skillClassName
	for i = 1, 2 do
		local l_skillId = l_skillClassSkillIds[i]
		if l_skillId ~= 0 then
			self.Parameter.Skill[i].gameObject:SetActiveEx(true)
			local l_skillData = self.data.GetDataFromTable("SkillTable", l_skillId)
			if l_skillData == nil then
				logError("skillId "..l_skillId.." not exist!")
			end
			self.Parameter.SkillName[i].LabText = l_skillData.Name
			self.Parameter.SkillIcon[i]:SetSprite(l_skillData.Atlas, l_skillData.Icon)
			self.Parameter.BtnPlaySkill[i]:AddClick(function()
				--MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("NotOpened"))
				local l_skillData =
				{
					openType = DataMgr:GetData("SkillData").OpenType.SetSkillPreviewInfo,
					Id = l_skillId
				}
				UIMgr:ActiveUI(UI.CtrlNames.SkillPreview, l_skillData)
			end)
			self.Parameter.BtnPlaySkill[i].UObj:SetActiveEx(l_skillData.TargetType ~= -1)
			self.Parameter.SkillLv[i].LabText = StringEx.Format("Max Lv{0}", l_skillData.EffectIDs.Length)
			local hrectTrans = self.Parameter.SkillName[i].transform.parent:GetComponent("RectTransform")
			LayoutRebuilder.ForceRebuildLayoutImmediate(hrectTrans)
		else
			self.Parameter.Skill[i].gameObject:SetActiveEx(false)
		end
	end
	
end --func end
--next--
function ProfessionSkillClassTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return ProfessionSkillClassTemplate