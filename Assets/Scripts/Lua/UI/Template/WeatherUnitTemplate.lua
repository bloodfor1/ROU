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
---@class WeatherUnitTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_WeatherUnit MoonClient.MLuaUICom
---@field Img_WeatherUnit MoonClient.MLuaUICom

---@class WeatherUnitTemplate : BaseUITemplate
---@field Parameter WeatherUnitTemplateParameter

WeatherUnitTemplate = class("WeatherUnitTemplate", super)
--lua class define end

--lua functions
function WeatherUnitTemplate:Init()
	
	super.Init(self)
	
end --func end
--next--
function WeatherUnitTemplate:OnDestroy()
	
	
end --func end
--next--
function WeatherUnitTemplate:OnDeActive()
	
	
end --func end
--next--
function WeatherUnitTemplate:OnSetData(data)
	
	if data==nil then
		return
	end
	self.Parameter.Img_WeatherUnit:SetSprite("main", data.spriteName)
	if data.isNow then
		self.Parameter.Txt_WeatherUnit.LabText=Lang("WEATHER_NOW")
	else
		if data.hours<12 then
			self.Parameter.Txt_WeatherUnit.LabText= StringEx.Format("{0}{1}",data.hours,Lang("WEATHER_AM"))
		elseif data.hours==12 then
			self.Parameter.Txt_WeatherUnit.LabText= StringEx.Format("{0}{1}",data.hours,Lang("WEATHER_PM"))
		else
			self.Parameter.Txt_WeatherUnit.LabText= StringEx.Format("{0}{1}",data.hours-12,Lang("WEATHER_PM"))
		end
	end
	if data.clickEvent~=nil then
		self.Parameter.Img_WeatherUnit.Listener.onClick=data.clickEvent
	end
	
end --func end
--next--
function WeatherUnitTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return WeatherUnitTemplate