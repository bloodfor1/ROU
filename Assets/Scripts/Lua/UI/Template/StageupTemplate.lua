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
---@class StageupTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_Plus MoonClient.MLuaUICom
---@field Txt_AttValue MoonClient.MLuaUICom
---@field Txt_AttName MoonClient.MLuaUICom

---@class StageupTemplate : BaseUITemplate
---@field Parameter StageupTemplateParameter

StageupTemplate = class("StageupTemplate", super)
--lua class define end

--lua functions
function StageupTemplate:Init()
	
	super.Init(self)
	
end --func end
--next--
function StageupTemplate:OnDestroy()
	
	
end --func end
--next--
function StageupTemplate:OnDeActive()
	
	
end --func end
--next--
function StageupTemplate:OnSetData(data)
	
	if data==nil then return end
	local l_vehicleQualityItem=TableUtil.GetVehicleQualityTable().GetRowById(data.Id)
	if MLuaCommonHelper.IsNull(l_vehicleQualityItem) then
		return
	end
	self.Parameter.Txt_AttName.LabText=data.Name
	local l_vehicleStageNum=MgrMgr:GetMgr("VehicleInfoMgr").GetVehicleStage()
	local l_currentValue=0
	local l_nextValue=0
	if l_vehicleStageNum==0 then
		l_currentValue=l_vehicleQualityItem.InitialQuality
		l_nextValue=l_vehicleQualityItem.OnceQuality
	elseif l_vehicleStageNum==1 then
		l_currentValue=l_vehicleQualityItem.OnceQuality
		l_nextValue=l_vehicleQualityItem.OnceQuality
	end
	self.Parameter.Txt_AttValue.LabText=l_currentValue
	self.Parameter.Txt_Plus.LabText=l_nextValue
	
end --func end
--next--
function StageupTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return StageupTemplate