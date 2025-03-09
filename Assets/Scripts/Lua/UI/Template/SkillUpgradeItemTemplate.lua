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
---@class SkillUpgradeItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field skillUpTip MoonClient.MLuaUICom
---@field skillUpLv MoonClient.MLuaUICom
---@field skillTip MoonClient.MLuaUICom
---@field skillName MoonClient.MLuaUICom
---@field skillLv MoonClient.MLuaUICom
---@field Image MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom

---@class SkillUpgradeItemTemplate : BaseUITemplate
---@field Parameter SkillUpgradeItemTemplateParameter

SkillUpgradeItemTemplate = class("SkillUpgradeItemTemplate", super)
--lua class define end

--lua functions
function SkillUpgradeItemTemplate:Init()
	
	super.Init(self)
	self.data = DataMgr:GetData("SkillData")
	
end --func end
--next--
function SkillUpgradeItemTemplate:OnDestroy()
	
	
end --func end
--next--
function SkillUpgradeItemTemplate:OnDeActive()
	
	
end --func end
--next--
function SkillUpgradeItemTemplate:OnSetData(data)
	
	local skillSdata = self.data.GetDataFromTable("SkillTable", data.skillId)
	if not skillSdata then return end
	self.Parameter.Icon:SetSpriteAsync(skillSdata.Atlas, skillSdata.Icon)
	self.Parameter.skillName.LabText = skillSdata.Name
	if data.lv == 0 then
		self.Parameter.skillLv.LabText = Lang("SKILL_UPGRADE_NOT_OPEN")
	else
		self.Parameter.skillLv.LabText = StringEx.Format("Lv.{0}", data.lv)
	end
	self.Parameter.skillUpLv.LabText = StringEx.Format("Lv.{0}", data.afterLv)
	self.Parameter.skillTip.LabText = self.data.GetSkillIntroduce(data.skillId, data.lv)
	self.Parameter.skillUpTip.LabText = self.data.GetSkillIntroduce(data.skillId, data.afterLv)
	
end --func end
--next--
function SkillUpgradeItemTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return SkillUpgradeItemTemplate