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
---@class DailyWeekInfoTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_OtherDay MoonClient.MLuaUICom
---@field Txt_CurrentDay MoonClient.MLuaUICom
---@field Panel_OtherDay MoonClient.MLuaUICom
---@field Panel_CurrentDay MoonClient.MLuaUICom

---@class DailyWeekInfoTemplate : BaseUITemplate
---@field Parameter DailyWeekInfoTemplateParameter

DailyWeekInfoTemplate = class("DailyWeekInfoTemplate", super)
--lua class define end

--lua functions
function DailyWeekInfoTemplate:Init()
	
	super.Init(self)
	
end --func end
--next--
function DailyWeekInfoTemplate:BindEvents()
	
	
end --func end
--next--
function DailyWeekInfoTemplate:OnDestroy()
	
	
end --func end
--next--
function DailyWeekInfoTemplate:OnDeActive()
	
	
end --func end
--next--
function DailyWeekInfoTemplate:OnSetData(data)
	
	if data==nil or not data.isWeekDayShow then
		return
	end
	local l_weekDay=Common.TimeMgr.GetNowWeekDay()
	local l_isCurrentDay = l_weekDay == data.weekDay
	self.Parameter.Panel_CurrentDay:SetActiveEx(l_isCurrentDay)
	self.Parameter.Panel_OtherDay:SetActiveEx(not l_isCurrentDay)
	local l_showWeekDayIndex = data.weekDay
	if l_showWeekDayIndex == 0 then
		l_showWeekDayIndex = 7
	end
	local l_weekStr = Lang("Week"..tostring(l_showWeekDayIndex))
	self.Parameter.Txt_CurrentDay.LabText = l_weekStr
	self.Parameter.Txt_OtherDay.LabText = l_weekStr
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return DailyWeekInfoTemplate