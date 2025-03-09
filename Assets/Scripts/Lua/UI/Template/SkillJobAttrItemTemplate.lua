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
---@class SkillJobAttrItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Text MoonClient.MLuaUICom
---@field SkillName MoonClient.MLuaUICom
---@field AttrIcon MoonClient.MLuaUICom

---@class SkillJobAttrItemTemplate : BaseUITemplate
---@field Parameter SkillJobAttrItemTemplateParameter

SkillJobAttrItemTemplate = class("SkillJobAttrItemTemplate", super)
--lua class define end

--lua functions
function SkillJobAttrItemTemplate:Init()
	
	super.Init(self)
	self.data = DataMgr:GetData("SkillData")
	
end --func end
--next--
function SkillJobAttrItemTemplate:OnDestroy()
	
	self.data = nil
	
end --func end
--next--
function SkillJobAttrItemTemplate:OnDeActive()
	
	
end --func end
--next--
function SkillJobAttrItemTemplate:OnSetData(data)

	local l_roleInfoData = DataMgr:GetData("RoleInfoData")
	local attrInfo = TableUtil.GetAttrInfoTable().GetRowById(data.id)
	if attrInfo then
		local l_iconData = l_roleInfoData.Attr_Icon_Table[data.id]
		self.Parameter.AttrIcon:SetSprite(l_iconData.AttrAtlas, l_iconData.AttrIcon, true)
		self.Parameter.SkillName.LabText = attrInfo.AttrName
		self.Parameter.Text.LabText = data.val
	end
	
end --func end
--next--
function SkillJobAttrItemTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return SkillJobAttrItemTemplate