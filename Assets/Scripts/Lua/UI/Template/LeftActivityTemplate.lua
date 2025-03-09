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
---@class LeftActivityTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field SmallName MoonClient.MLuaUICom
---@field SmallIcon MoonClient.MLuaUICom
---@field Select MoonClient.MLuaUICom
---@field OpenEffect MoonClient.MLuaUICom
---@field Item MoonClient.MLuaUICom

---@class LeftActivityTemplate : BaseUITemplate
---@field Parameter LeftActivityTemplateParameter

LeftActivityTemplate = class("LeftActivityTemplate", super)
--lua class define end

--lua functions
function LeftActivityTemplate:Init()
	
	super.Init(self)
	self.mgr = MgrMgr:GetMgr("FestivalMgr")
	self.fData = DataMgr:GetData("FestivalData")
	
end --func end
--next--
function LeftActivityTemplate:BindEvents()
	
	
end --func end
--next--
function LeftActivityTemplate:OnDestroy()
	
	
end --func end
--next--
function LeftActivityTemplate:OnDeActive()
	
	
end --func end
--next--
function LeftActivityTemplate:OnSetData(data)
	
	self.data = data
	self.Parameter.SmallName.LabText = data.act_name
	self.Parameter.OpenEffect:SetActiveEx(self.mgr.CheckActivityOpen(data.actual_time.first, data.actual_time.second, data.day_times))
	self.Parameter.Select:SetActiveEx(data.sort == self.fData.nowChoose)
	if data.sort == self.fData.nowChoose then
		self:NotiyPoolSelect()
	end
	self.Parameter.SmallIcon:SetSpriteAsync(data.atlas_name, data.icon_name_1)
	self.Parameter.SmallIcon:AddClick(function()
		self.MethodCallback(data.id)
		self:NotiyPoolSelect()
	end)
	if self.RedSignProcessor ~= nil then
		self:UninitRedSign(self.RedSignProcessor)
		self.RedSignProcessor = nil
	end
	if self.RedSignProcessor == nil and self.fData.ActivityRedSign[data.system_id] then
		self.RedSignProcessor = self:NewRedSign({
			Key = self.fData.ActivityRedSign[data.system_id][1],
			RedSignParent = self.Parameter.Item.Transform
		})
	end
	
end --func end
--next--
--lua functions end

--lua custom scripts
function LeftActivityTemplate:OnSelect()
	self.fData.nowChoose = self.data.sort
	self.Parameter.Select:SetActiveEx(true)
end

function LeftActivityTemplate:OnDeselect()
	self.fData.nowChoose = self.data.sort
	self.Parameter.Select:SetActiveEx(false)
end
--lua custom scripts end
return LeftActivityTemplate