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
---@class TDBlessTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field SkillName MoonClient.MLuaUICom
---@field SkillIcon MoonClient.MLuaUICom
---@field SkillDescription MoonClient.MLuaUICom
---@field SelectButton MoonClient.MLuaUICom
---@field Select MoonClient.MLuaUICom
---@field DontUse MoonClient.MLuaUICom
---@field DongUseText MoonClient.MLuaUICom
---@field Divide MoonClient.MLuaUICom
---@field CurrentUse MoonClient.MLuaUICom

---@class TDBlessTemplate : BaseUITemplate
---@field Parameter TDBlessTemplateParameter

TDBlessTemplate = class("TDBlessTemplate", super)
--lua class define end

--lua functions
function TDBlessTemplate:Init()
	
	super.Init(self)
	self.Parameter.SelectButton:AddClick(function()
		self.MethodCallback(self.ShowIndex)
	end)
	
end --func end
--next--
function TDBlessTemplate:BindEvents()
	
	
end --func end
--next--
function TDBlessTemplate:OnDestroy()
	
	
end --func end
--next--
function TDBlessTemplate:OnDeActive()
	
	
end --func end
--next--
function TDBlessTemplate:OnSetData(data,currentSkillId)
	
	self.Parameter.CurrentUse:SetActiveEx(false)
	self.Parameter.SkillIcon:SetActiveEx(false)
	self.Parameter.SkillName:SetActiveEx(false)
	self.Parameter.SkillDescription:SetActiveEx(false)
	self.Parameter.DontUse:SetActiveEx(false)
	self.Parameter.Divide:SetActiveEx(false)
	if data.ID == 0 then
		self.Parameter.DontUse:SetActiveEx(true)
		if currentSkillId == 0 then
			self.Parameter.CurrentUse:SetActiveEx(true)
		end
	else
		self.Parameter.Divide:SetActiveEx(true)
		self.Parameter.SkillIcon:SetActiveEx(true)
		self.Parameter.SkillIcon:SetSpriteAsync(data.IconAtlas, data.IconName)
		self.Parameter.SkillName:SetActiveEx(true)
		self.Parameter.SkillDescription:SetActiveEx(true)
		self.Parameter.SkillName.LabText = data.Name
		self.Parameter.SkillDescription.LabText = data.Desc
		if data.ID == currentSkillId then
			self.Parameter.CurrentUse:SetActiveEx(true)
		end
	end
	
end --func end
--next--
--lua functions end

--lua custom scripts
function TDBlessTemplate:OnSelect()
	self.Parameter.Select:SetActiveEx(true)
end

function TDBlessTemplate:OnDeselect()
	self.Parameter.Select:SetActiveEx(false)
end
--lua custom scripts end
return TDBlessTemplate