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
---@class QualityInfoTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_Subtract MoonClient.MLuaUICom
---@field Txt_Progress MoonClient.MLuaUICom
---@field Txt_Plus MoonClient.MLuaUICom
---@field Text_Name MoonClient.MLuaUICom
---@field Slider_Progress MoonClient.MLuaUICom
---@field Img_Wave2 MoonClient.MLuaUICom
---@field Img_Wave1 MoonClient.MLuaUICom
---@field Img_Reduce MoonClient.MLuaUICom
---@field Img_NoChange MoonClient.MLuaUICom
---@field Img_Add MoonClient.MLuaUICom
---@field Btn_ShowQualityInfo MoonClient.MLuaUICom

---@class QualityInfoTemplate : BaseUITemplate
---@field Parameter QualityInfoTemplateParameter

QualityInfoTemplate = class("QualityInfoTemplate", super)
--lua class define end

--lua functions
function QualityInfoTemplate:Init()
	
	super.Init(self)
	
end --func end
--next--
function QualityInfoTemplate:OnDestroy()
	self.qualityInfoData = nil
	self:CloseTimer()
	
end --func end
--next--
function QualityInfoTemplate:OnDeActive()
	
	self:CloseTimer()
	
end --func end
--next--
function QualityInfoTemplate:OnSetData(data)
	
	if data==nil then return end
	self.qualityInfoData = data.attrData
	self.Parameter.Text_Name:SetActiveEx(true)
	self.Parameter.Text_Name.LabText=self.qualityInfoData.Name
	local l_progress=self.qualityInfoData.trainValue/self.qualityInfoData.trainValueLimit
	self.Parameter.Slider_Progress.Img.fillAmount=l_progress

	if not self.isPlayingAnim then
		self.wavePos = Vector2.New(0,0)
		self.wavePos.y=self.Parameter.Slider_Progress.RectTransform.rect.size.y*l_progress
	end
	self.Parameter.Btn_ShowQualityInfo:AddClick(function()
		data.clickCallback(data.funcSelf,data.attrData)
	end,true)
	self.Parameter.Img_Wave1.RectTransform.anchoredPosition=self.wavePos
	self.wavePos.x=self.Parameter.Img_Wave1.RectTransform.rect.size.x
	self.Parameter.Img_Wave2.RectTransform.anchoredPosition=self.wavePos
	self.Parameter.Txt_Progress.LabText=string.format("%s/%s",self.qualityInfoData.trainValue,self.qualityInfoData.trainValueLimit)
	if self.qualityInfoData.trainValue>0 then
		self:PlayWaveAnim()
	end
	local l_addValue=self.qualityInfoData.primaryTrain
	local l_vehicleInfoMgr=MgrMgr:GetMgr("VehicleInfoMgr")
	local l_attData=l_vehicleInfoMgr.GetAttrInfoData()
	local l_hasCultureData=l_attData.hasPrimaryCulture
	if self.qualityInfoData.showQualityType~=l_vehicleInfoMgr.cultureType.primary then
		l_addValue=self.qualityInfoData.seniorTrain
		l_hasCultureData=l_attData.hasSeniorCulture
	end
	self.Parameter.Img_NoChange:SetActiveEx(false)
	self.Parameter.Img_Add:SetActiveEx(false)
	self.Parameter.Img_Reduce:SetActiveEx(false)
	if l_hasCultureData then
		if l_addValue>0 then
			self.Parameter.Img_Add:SetActiveEx(true)
			self.Parameter.Img_Add.FxAnim:PlayAll()
			self.Parameter.Txt_Plus.LabText=string.format("+%s",l_addValue)
		elseif l_addValue==0 then
			self.Parameter.Txt_Plus.Transform.parent.gameObject:SetActiveEx(false)
			self.Parameter.Img_NoChange:SetActiveEx(true)
			self.Parameter.Img_NoChange.FxAnim:PlayAll()
		else
			self.Parameter.Txt_Plus.Transform.parent.gameObject:SetActiveEx(false)
			self.Parameter.Txt_Subtract.LabText=l_addValue
			self.Parameter.Img_Reduce:SetActiveEx(true)
			self.Parameter.Img_Reduce.FxAnim:PlayAll()
		end
	end
	--策划说这个颜色写死/不配表
	if self.qualityInfoData.Id == 1 then
		self.Parameter.Img_Wave2.Img.color = RoColor.Hex2Color("C0F0FFFF")
		self.Parameter.Img_Wave1.Img.color = RoColor.Hex2Color("C0F0FFFF")
		self.Parameter.Slider_Progress.Img.color = RoColor.Hex2Color("C0F0FFFF")
	elseif self.qualityInfoData.Id == 2 then
		self.Parameter.Img_Wave2.Img.color = RoColor.Hex2Color("C9FFEFFF")
		self.Parameter.Img_Wave1.Img.color = RoColor.Hex2Color("C9FFEFFF")
		self.Parameter.Slider_Progress.Img.color = RoColor.Hex2Color("C9FFEFFF")
	elseif self.qualityInfoData.Id == 3 then
		self.Parameter.Img_Wave2.Img.color = RoColor.Hex2Color("FBE1FFFF")
		self.Parameter.Img_Wave1.Img.color = RoColor.Hex2Color("FBE1FFFF")
		self.Parameter.Slider_Progress.Img.color = RoColor.Hex2Color("FBE1FFFF")
	elseif self.qualityInfoData.Id == 4 then
		self.Parameter.Img_Wave2.Img.color = RoColor.Hex2Color("FFF9C0FF")
		self.Parameter.Img_Wave1.Img.color = RoColor.Hex2Color("FFF9C0FF")
		self.Parameter.Slider_Progress.Img.color = RoColor.Hex2Color("FFF9C0FF")
	elseif self.qualityInfoData.Id == 5 then
		self.Parameter.Img_Wave2.Img.color = RoColor.Hex2Color("FFDEC9FF")
		self.Parameter.Img_Wave1.Img.color = RoColor.Hex2Color("FFDEC9FF")
		self.Parameter.Slider_Progress.Img.color = RoColor.Hex2Color("FFDEC9FF")
	end
	
end --func end
--next--
function QualityInfoTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function QualityInfoTemplate:CloseTimer()
	if self.waveTimer then
		self:StopUITimer(self.waveTimer)
		self.waveTimer = nil
	end
	self.isPlayingAnim=false
end

function QualityInfoTemplate:PlayWaveAnim()
	if self.isPlayingAnim then
		return
	end
	self:CloseTimer()
	local l_playSpeed=2
	local l_waveWidth=self.Parameter.Img_Wave1.RectTransform.rect.size.x
	self.waveTimer = self:NewUITimer(function()
	if MLuaCommonHelper.IsNull(self.Parameter.Img_Wave1)  then
	return
	end
	self.wavePos=self.Parameter.Img_Wave1.RectTransform.anchoredPosition
	self.wavePos.x=self.wavePos.x-l_playSpeed
	if self.wavePos.x< -l_waveWidth then
	self.wavePos.x=l_waveWidth
	end
	self.Parameter.Img_Wave1.RectTransform.anchoredPosition=self.wavePos
	if self.wavePos.x<0 then
	self.wavePos.x=self.wavePos.x+l_waveWidth
	else
	self.wavePos.x=self.wavePos.x-l_waveWidth
	end
	self.Parameter.Img_Wave2.RectTransform.anchoredPosition=self.wavePos
	end,0.1,-1,true)
	self.isPlayingAnim=true
	self.waveTimer:Start()
	end
--lua custom scripts end
return QualityInfoTemplate