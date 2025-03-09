--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/PictureQualitySettingPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
PictureQualitySettingCtrl = class("PictureQualitySettingCtrl", super)
--lua class define end

--lua functions
function PictureQualitySettingCtrl:ctor()

	super.ctor(self, CtrlNames.PictureQualitySetting, UILayer.Function, nil, ActiveType.Exclusive)

end --func end
--next--
function PictureQualitySettingCtrl:Init()

	self.panel = UI.PictureQualitySettingPanel.Bind(self)
	super.Init(self)

	self.panel.BtnClose:AddClick(function()
		UIMgr:DeActiveUI(UI.CtrlNames.PictureQualitySetting)
	end)
	self.panel.ResetBtn:AddClick(function()
		MQualityGradeSetting.ResetGradeToHardware()
		self:PictureQualitySettingPanelRefresh()
	end)

	--Quality Level
	self.panel.BtnHigh:AddClick(function()
		self:OnClickSetQualityLevel(3)
	end)
	self.panel.BtnMid:AddClick(function()
		self:OnClickSetQualityLevel(2)
	end)
	self.panel.BtnLow:AddClick(function()
		self:OnClickSetQualityLevel(1)
	end)
	self.panel.BtnVeryLow:AddClick(function()
		self:OnClickSetQualityLevel(0)
	end)
	--Quality Level

	--Role Num

	self.panel.Role20Btn:AddClick(function()
		self:SetCustomDisplayLevel(1)
	end)
	self.panel.Role30Btn:AddClick(function()
		self:SetCustomDisplayLevel(2)
	end)
	self.panel.Role40Btn:AddClick(function()
		self:SetCustomDisplayLevel(3)
	end)
	--Role Num

	--后处理RT设置
	local rtSolution = MQualityGradeSetting.RTResolution
	self.panel.DeviceResolution.LabText = StringEx.Format("设备分辨率:{0}*{1} RT分辨率{2}*{3}",
				Screen.width, Screen.height, rtSolution.x, rtSolution.y)
	self.panel.SetRolutionBtn:AddClick(function()
		local height = tonumber(self.panel.InputHeight.Input.text)
		if not height then return end
		
		MQualityGradeSetting.SetRTResolution(height)
		MgrMgr:GetMgr("TipsMgr").ShowNormalTips("设置RT分辨率成功")
	end)
end --func end

function PictureQualitySettingCtrl:OnClickSetQualityLevel(level)

	self:SetQualityLevel(level)
end

function PictureQualitySettingCtrl:SetQualityLevel(level)
	MQualityGradeSetting.SetCustomLevel(level)
	self:PictureQualitySettingPanelRefresh()
end

function PictureQualitySettingCtrl:SetCustomDisplayLevel(displayLevel)
	MQualityGradeSetting.SetCustomDisplayLevel(displayLevel)
	self:PictureQualitySettingPanelRefresh()
end

--next--
function PictureQualitySettingCtrl:Uninit()

	super.Uninit(self)
	self.panel = nil

end --func end
--next--
function PictureQualitySettingCtrl:OnActive()
	self:PictureQualitySettingPanelRefresh()
end --func end
--next--
function PictureQualitySettingCtrl:OnDeActive()

end --func end
--next--
function PictureQualitySettingCtrl:Update()

end --func end


--next--
function PictureQualitySettingCtrl:BindEvents()

	--dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts
function PictureQualitySettingCtrl:PictureQualitySettingPanelRefresh()
	local curQualityLevel = MQualityGradeSetting.GetCurLevel()
	local curDisplayGradeLevel = MQualityGradeSetting.GetCurDisplayGrade()

	self.panel.BtnVeryLow.Btn.interactable = (0 ~= curQualityLevel)
	self.panel.BtnLow.Btn.interactable = (1 ~= curQualityLevel)
	self.panel.BtnMid.Btn.interactable = (2 ~= curQualityLevel)
	self.panel.BtnHigh.Btn.interactable = (3 ~= curQualityLevel)

	self.panel.Role20Btn.Btn.interactable = (1 ~= curDisplayGradeLevel)
	self.panel.Role30Btn.Btn.interactable = (2 ~= curDisplayGradeLevel)
	self.panel.Role40Btn.Btn.interactable = (3 ~= curDisplayGradeLevel)
	--logError("level:" .. tostring(curQualityLevel) .. "|num:" .. tostring(curDisplayGradeLevel))
end
--lua custom scripts end

return PictureQualitySettingCtrl
