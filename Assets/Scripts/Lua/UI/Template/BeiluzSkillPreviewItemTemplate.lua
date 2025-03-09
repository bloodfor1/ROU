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
---@class BeiluzSkillPreviewItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Name MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom

---@class BeiluzSkillPreviewItemTemplate : BaseUITemplate
---@field Parameter BeiluzSkillPreviewItemTemplateParameter

BeiluzSkillPreviewItemTemplate = class("BeiluzSkillPreviewItemTemplate", super)
--lua class define end

--lua functions
function BeiluzSkillPreviewItemTemplate:Init()

	super.Init(self)

	self.Parameter.Icon:AddClick(function()
		self:OnBtnIcon()
	end)

end --func end
--next--
function BeiluzSkillPreviewItemTemplate:BindEvents()
	
	
end --func end
--next--
function BeiluzSkillPreviewItemTemplate:OnDestroy()
	
	
end --func end
--next--
function BeiluzSkillPreviewItemTemplate:OnDeActive()
	
	
end --func end
--next--
function BeiluzSkillPreviewItemTemplate:OnSetData(data)
	self.data = data
	if self.data then
		self.Parameter.Name.LabText = data.Name
		self.Parameter.Recommend:SetActiveEx(false)
	end
end --func end
--next--
--lua functions end
--lua custom scripts
BeiluzSkillPreviewItemTemplate.TemplatePath = "UI/Prefabs/BeiluzSkillPreviewItem"

function BeiluzSkillPreviewItemTemplate:OnBtnIcon()
	if self.data then
		local l_position = self.Parameter.Icon.transform.position
		local skillData = {}
		skillData.type = 3
		skillData.id = self.data.AttrID
		local l_skillData = {
			openType = DataMgr:GetData("SkillData").OpenType.ShowSkillInfo,
			position = l_position,
			data = skillData
		}
		UIMgr:ActiveUI(UI.CtrlNames.SkillAttr, l_skillData)
	end
end

--lua custom scripts end
return BeiluzSkillPreviewItemTemplate