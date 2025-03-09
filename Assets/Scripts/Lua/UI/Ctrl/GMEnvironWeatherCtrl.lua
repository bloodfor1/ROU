--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/GMEnvironWeatherPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
GMEnvironWeatherCtrl = class("GMEnvironWeatherCtrl", super)
--lua class define end

--lua functions
function GMEnvironWeatherCtrl:ctor()

	super.ctor(self, CtrlNames.GMEnvironWeather, UILayer.Function, nil, ActiveType.Exclusive)

end --func end
--next--
function GMEnvironWeatherCtrl:Init()

	self.panel = UI.GMEnvironWeatherPanel.Bind(self)
	super.Init(self)

	self.periodName = ""
	self.weatherName = ""
	self:UpdatePeriod(MoonClient.MSceneEnvoriment.MPeriodType.None)
	self:UpdatePeriodName(self.panel.ConfigPeriod)
	self:UpdateWeather(MoonClient.MSceneEnvoriment.MWeatherType.None)
	self:UpdateWeatherName(self.panel.ConfigWeather)

	self.panel.BtnClose:AddClick(function()
		UIMgr:DeActiveUI(UI.CtrlNames.GMEnvironWeather)
	end)
	--Period
	self.panel.ConfigPeriod:AddClick(function()
		self:UpdatePeriod(MoonClient.MSceneEnvoriment.MPeriodType.None)
		self:UpdatePeriodName(self.panel.ConfigPeriod)
	end)
	self.panel.Morning:AddClick(function()
		self:UpdatePeriod(MoonClient.MSceneEnvoriment.MPeriodType.Morning)
		self:UpdatePeriodName(self.panel.Morning)
	end)
	self.panel.Afternoon:AddClick(function()
		self:UpdatePeriod(MoonClient.MSceneEnvoriment.MPeriodType.Afternoon)
		self:UpdatePeriodName(self.panel.Afternoon)
	end)
	self.panel.Evening:AddClick(function()
		self:UpdatePeriod(MoonClient.MSceneEnvoriment.MPeriodType.Evening)
		self:UpdatePeriodName(self.panel.Evening)
	end)
	self.panel.LateNight:AddClick(function()
		self:UpdatePeriod(MoonClient.MSceneEnvoriment.MPeriodType.LateNight)
		self:UpdatePeriodName(self.panel.LateNight)
	end)
	--Weather
	self.panel.ConfigWeather:AddClick(function()
		self:UpdateWeather(MoonClient.MSceneEnvoriment.MWeatherType.None)
		self:UpdateWeatherName(self.panel.ConfigWeather)
	end)
	self.panel.Sunny:AddClick(function()
		self:UpdateWeather(MoonClient.MSceneEnvoriment.MWeatherType.Sunny)
		self:UpdateWeatherName(self.panel.Sunny)
	end)
	self.panel.Cloudy:AddClick(function()
		self:UpdateWeather(MoonClient.MSceneEnvoriment.MWeatherType.Cloudy)
		self:UpdateWeatherName(self.panel.Cloudy)
	end)
	self.panel.Fog:AddClick(function()
		self:UpdateWeather(MoonClient.MSceneEnvoriment.MWeatherType.Fog)
		self:UpdateWeatherName(self.panel.Fog)
	end)
	self.panel.LightRain:AddClick(function()
		self:UpdateWeather(MoonClient.MSceneEnvoriment.MWeatherType.LightRain)
		self:UpdateWeatherName(self.panel.LightRain)
	end)
	self.panel.HeavyRain:AddClick(function()
		self:UpdateWeather(MoonClient.MSceneEnvoriment.MWeatherType.HeavyRain)
		self:UpdateWeatherName(self.panel.HeavyRain)
	end)
	self.panel.ThunderRain:AddClick(function()
		self:UpdateWeather(MoonClient.MSceneEnvoriment.MWeatherType.ThunderRain)
		self:UpdateWeatherName(self.panel.ThunderRain)
	end)
	self.panel.LightSnow:AddClick(function()
		self:UpdateWeather(MoonClient.MSceneEnvoriment.MWeatherType.LightSnow)
		self:UpdateWeatherName(self.panel.LightSnow)
	end)
	self.panel.HeavySnow:AddClick(function()
		self:UpdateWeather(MoonClient.MSceneEnvoriment.MWeatherType.HeavySnow)
		self:UpdateWeatherName(self.panel.HeavySnow)
	end)
	self.panel.Sandstorm:AddClick(function()
		self:UpdateWeather(MoonClient.MSceneEnvoriment.MWeatherType.Sandstorm)
		self:UpdateWeatherName(self.panel.Sandstorm)
	end)
	self.panel.AfterRain:AddClick(function()
		self:UpdateWeather(MoonClient.MSceneEnvoriment.MWeatherType.AfterRain)
		self:UpdateWeatherName(self.panel.AfterRain)
	end)
	self.panel.AfterSnow:AddClick(function()
		self:UpdateWeather(MoonClient.MSceneEnvoriment.MWeatherType.AfterSnow)
		self:UpdateWeatherName(self.panel.AfterSnow)
	end)

	self.panel.ApplyBtn:AddClick(function()
		self:ApplyType()
	end)
	self.panel.ResetBtn:AddClick(function()
		self:UpdateWeather(MoonClient.MSceneEnvoriment.MWeatherType.None)
		self:UpdatePeriod(MoonClient.MSceneEnvoriment.MPeriodType.None)
		self:UpdateWeatherName(self.panel.ConfigWeather)
		self:UpdatePeriodName(self.panel.ConfigPeriod)
		MEnvironWeatherGM.ClearClientDataByID(0)
	end)
end --func end

function GMEnvironWeatherCtrl:ApplyType()
	local result = MEnvironWeatherGM.SetClientDataByType(0, self.periodType, self.weatherType)
	if (not result) then
		MgrMgr:GetMgr("TipsMgr").ShowNormalTips("时间段：" .. self.periodName .. ", 天气：" .. self.weatherName .. ", 组合当前地图不存在！！！")
	else
		MgrMgr:GetMgr("TipsMgr").ShowNormalTips("时间段：" .. self.periodName .. ", 天气：" .. self.weatherName .. ", 显示成功")
	end
end
function GMEnvironWeatherCtrl:UpdatePeriod(typeValue)
	self.periodType = typeValue
end
function GMEnvironWeatherCtrl:UpdateWeather(typeValue)
	self.weatherType = typeValue
end
function GMEnvironWeatherCtrl:UpdatePeriodName(btn)
    self.periodName = btn.transform:Find("Text"):GetComponent("Text").text
    self:UpdateDescInfo();
end
function GMEnvironWeatherCtrl:UpdateWeatherName(btn)
    self.weatherName = btn.transform:Find("Text"):GetComponent("Text").text
    self:UpdateDescInfo();
end
function GMEnvironWeatherCtrl:UpdateDescInfo()
    logGreen("时间段：" .. self.periodName)
    logGreen("天气：" .. self.weatherName)
    self.panel.DescInfo.transform:GetComponent("Text").text = "时间段：" .. self.periodName .. ", 天气：" .. self.weatherName
end --func end
--next--
function GMEnvironWeatherCtrl:Uninit()

	super.Uninit(self)
	self.panel = nil

end --func end
--next--
function GMEnvironWeatherCtrl:OnActive()


end --func end
--next--
function GMEnvironWeatherCtrl:OnDeActive()


end --func end
--next--
function GMEnvironWeatherCtrl:Update()


end --func end



--next--
function GMEnvironWeatherCtrl:BindEvents()

	--dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
