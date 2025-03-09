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
---@class PollyTypeHeadTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field RedSign MoonClient.MLuaUICom
---@field PollyHeadIcon MoonClient.MLuaUICom
---@field PollyHead MoonClient.MLuaUICom
---@field Choice MoonClient.MLuaUICom

---@class PollyTypeHeadTemplate : BaseUITemplate
---@field Parameter PollyTypeHeadTemplateParameter

PollyTypeHeadTemplate = class("PollyTypeHeadTemplate", super)
--lua class define end

--lua functions
function PollyTypeHeadTemplate:Init()
	
	super.Init(self)
	self.pollyTypeData = nil
	self.isSelected = false
end --func end
--next--
function PollyTypeHeadTemplate:BindEvents()
	self:BindEvent(GlobalEventBus,EventConst.Names.OnModifyPollyTypeAward,
        function(self, typeId)
	        if self.data == nil or typeId == 0 or self.data.typeId ~= typeId or self.isSelected then
	        	return
	        end
	        self:CheckRedSign()
        end)
	
end --func end
--next--
function PollyTypeHeadTemplate:OnDestroy()
	
	
end --func end
--next--
function PollyTypeHeadTemplate:OnDeActive()
	
	
end --func end
--next--
function PollyTypeHeadTemplate:OnSetData(data)
	local l_typeData = TableUtil.GetElfTypeTable().GetRowByID(data.typeId)
	if l_typeData == nil then
		return
	end	
	self.pollyTypeData = data

	self.Parameter.PollyHeadIcon:AddClick(function()
		self.MethodCallback(self.ShowIndex)
	end,false)	
	self.Parameter.Choice:SetActiveEx(false)
	self:CheckRedSign()
	local l_isUnlock = data.unlockCount > 0 
	if l_isUnlock then
		self.Parameter.PollyHeadIcon:SetSprite(l_typeData.Atlas, l_typeData.Icon, true)
		self.Parameter.PollyHeadIcon.Img.color = Color.New(1, 1, 1, 1)
		MLuaCommonHelper.SetLocalScale(self.Parameter.PollyHeadIcon.UObj, 1, 1, 1)
	else
		self.Parameter.PollyHeadIcon:SetSprite(l_typeData.Atlas2, l_typeData.Icon2, true)
		self.Parameter.PollyHeadIcon.Img.color = Color.New(1, 1, 1, 200 / 255)
		MLuaCommonHelper.SetLocalScale(self.Parameter.PollyHeadIcon.UObj, 0.3, 0.3, 1)
	end
	
end --func end
--next--
--lua functions end

--lua custom scripts
function PollyTypeHeadTemplate:OnSelect()
	self.Parameter.Choice:SetActiveEx(true)
	self.Parameter.RedSign:SetActiveEx(false)
	self.isSelected = true
end

function PollyTypeHeadTemplate:OnDeselect()
	self.Parameter.Choice:SetActiveEx(false)
	self.isSelected = false
	if self.pollyTypeData == nil then
		return
	end
	self:CheckRedSign()
end

function PollyTypeHeadTemplate:CheckRedSign()
	local l_hasCanGetAward = false
	for k,v in pairs(self.pollyTypeData.awards) do
		if v.finish and not v.gotAward then
			l_hasCanGetAward = true
			break
		end
	end
	self.Parameter.RedSign:SetActiveEx(l_hasCanGetAward)
end

--lua custom scripts end
return PollyTypeHeadTemplate