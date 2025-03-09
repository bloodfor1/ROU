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
---@class QualityExtraAttrTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_ExtraAddAttr MoonClient.MLuaUICom
---@field Template_QualityExtraAttr MoonClient.MLuaUICom

---@class QualityExtraAttrTemplate : BaseUITemplate
---@field Parameter QualityExtraAttrTemplateParameter

QualityExtraAttrTemplate = class("QualityExtraAttrTemplate", super)
--lua class define end

--lua functions
function QualityExtraAttrTemplate:Init()
	
	super.Init(self)
	
end --func end
--next--
function QualityExtraAttrTemplate:BindEvents()
	
	
end --func end
--next--
function QualityExtraAttrTemplate:OnDestroy()
	
	
end --func end
--next--
function QualityExtraAttrTemplate:OnDeActive()
	
	
end --func end
--next--
function QualityExtraAttrTemplate:OnSetData(data)
	if data == nil then
		return
	end
	local l_vehicleQualityItem = TableUtil.GetVehicleQualityTable().GetRowById(data.Id)
	if MLuaCommonHelper.IsNull(l_vehicleQualityItem) then
		return
	end
	local l_qualityLevel = data.trainValue
	-- 载具品质等级没有0级，所以如果为0，则读1级的数据
	if l_qualityLevel==0 then
		l_qualityLevel = 1
	end
	local l_attrInfo = MgrMgr:GetMgr("VehicleInfoMgr").GetVehicleQualityAddAttrInfo(data.Id,l_qualityLevel)
	if l_attrInfo == nil then
		return
	end
	local l_attId = l_attrInfo[1]
	local l_addAttr = l_attrInfo[2]
	if data.trainValue== 0 then
		l_addAttr = 0
	end
	local l_attrDecItem =TableUtil.GetAttrDecision().GetRowById(l_attId)
	if MLuaCommonHelper.IsNull(l_attrDecItem) then
		return
	end

	self.Parameter.Template_QualityExtraAttr.LabText = l_vehicleQualityItem.Name.."："
	if l_attrDecItem.TipParaEnum==1 then
		self.Parameter.Txt_ExtraAddAttr.LabText = StringEx.Format(l_attrDecItem.TipTemplate,"+".. (l_addAttr/100).."%")
	else
		self.Parameter.Txt_ExtraAddAttr.LabText = StringEx.Format(l_attrDecItem.TipTemplate,"+".. l_addAttr)
	end
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return QualityExtraAttrTemplate