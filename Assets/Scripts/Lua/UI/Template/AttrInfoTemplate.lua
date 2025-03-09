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
---@class AttrInfoTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_AttrValue MoonClient.MLuaUICom
---@field Btn_Att MoonClient.MLuaUICom
---@field AttrName MoonClient.MLuaUICom

---@class AttrInfoTemplate : BaseUITemplate
---@field Parameter AttrInfoTemplateParameter

AttrInfoTemplate = class("AttrInfoTemplate", super)
--lua class define end

--lua functions
function AttrInfoTemplate:Init()
	
	super.Init(self)
	
end --func end
--next--
function AttrInfoTemplate:OnDestroy()
	
	
end --func end
--next--
function AttrInfoTemplate:OnDeActive()
	
	
end --func end
--next--
function AttrInfoTemplate:OnSetData(data)
	
	if data==nil then return end
	local l_vehicleQualityTable = TableUtil.GetVehicleQualityTable().GetRowById(data.Id)
	if MLuaCommonHelper.IsNull(l_vehicleQualityTable) then return end
	local l_attId=l_vehicleQualityTable.Attr[1]
	local l_attrInfo =TableUtil.GetAttrDecision().GetRowById(l_attId)
	if MLuaCommonHelper.IsNull(l_attrInfo) then
		return
	end
	local l_vehicleInfoMgr = MgrMgr:GetMgr("VehicleInfoMgr")
	local l_vehicleLevel = l_vehicleInfoMgr.GetVehicleLevelAndExp()
	local l_addAttrInfo = l_vehicleInfoMgr.GetVehicleLevelAddAttrInfo(data.Id,l_vehicleLevel)
	local l_addAttrValue = 0
	if l_addAttrInfo~=nil then
		l_addAttrValue = l_addAttrInfo[2]
	end
	self.Parameter.AttrName.LabText= StringEx.Format(l_attrInfo.TipTemplate, "")
	if l_attrInfo.TipParaEnum==1 then
		self.Parameter.Txt_AttrValue.LabText=(l_addAttrValue/100).."%"
	else
		self.Parameter.Txt_AttrValue.LabText=l_addAttrValue
	end
	self.Parameter.Btn_Att:AddClick(function()
		local l_vehicleInfoMgr = MgrMgr:GetMgr("VehicleInfoMgr")
		l_vehicleInfoMgr.EventDispatcher:Dispatch(l_vehicleInfoMgr.EventType.ShowVehicleAbilityAttrInfo,data.Id)
	end ,true)
	
end --func end
--next--
function AttrInfoTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return AttrInfoTemplate