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
---@class SettingPushNotificationTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtTime MoonClient.MLuaUICom
---@field TxtNumber MoonClient.MLuaUICom
---@field TxtName MoonClient.MLuaUICom
---@field TxtDate MoonClient.MLuaUICom
---@field Tog MoonClient.MLuaUICom
---@field SettingPushNotificationItemPrefab MoonClient.MLuaUICom
---@field ImgGray MoonClient.MLuaUICom

---@class SettingPushNotificationTemplate : BaseUITemplate
---@field Parameter SettingPushNotificationTemplateParameter

SettingPushNotificationTemplate = class("SettingPushNotificationTemplate", super)
--lua class define end

--lua functions
function SettingPushNotificationTemplate:Init()
	
	super.Init(self)
	
end --func end
--next--
function SettingPushNotificationTemplate:BindEvents()
	self:BindEvent(MgrMgr:GetMgr("SettingMgr").EventDispatcher, MgrMgr:GetMgr("SettingMgr").OnAllPushSwitchStateChange, self.OnAllPushSwitchStateChange, self)
	
end --func end
--next--
function SettingPushNotificationTemplate:OnDestroy()
	
	
end --func end
--next--
function SettingPushNotificationTemplate:OnDeActive()
	
	
end --func end
--next--

local l_weekData = {
	Week1 = Common.Utils.Lang("Week1"),
	Week2 = Common.Utils.Lang("Week2"),
	Week3 = Common.Utils.Lang("Week3"),
	Week4 = Common.Utils.Lang("Week4"),
	Week5 = Common.Utils.Lang("Week5"),
	Week6 = Common.Utils.Lang("Week6"),
	Week7 = Common.Utils.Lang("Week7")
}
function SettingPushNotificationTemplate:OnSetData(data)
	self.data = data
	self.Parameter.TxtName.LabText = data.SystemName
	local l_date = ""
	if data.Date.Length == 1 then
		l_date = l_weekData["Week" .. data.Date[0]]
	elseif data.Date.Length == 2 then
		l_date = l_date .. Common.Utils.Lang("Push_Notification_Date_Num2", l_weekData["Week"..data.Date[0]], l_weekData["Week"..data.Date[1]])
	elseif data.Date.Length == 3 then
		l_date = l_date .. Common.Utils.Lang("Push_Notification_Date_Num3", l_weekData["Week"..data.Date[0]], l_weekData["Week"..data.Date[1]], l_weekData["Week"..data.Date[2]])
	elseif data.Date.Length == 7 then
		l_date = Common.Utils.Lang("EVERYDAY")
	else
		for i = 0, data.Date.Length - 1 do
			if data.Date[i] >= 1 and data.Date[i] <=7 then
				if i == 0 then
					l_date = l_date .. Common.Utils.Lang("TIME_WEEK")
				else
					l_date = l_date .. "、"
				end
				l_date = l_date  .. Common.Utils.Lang(tostring(data.Date[i]))
			end
		end
	end
	self.Parameter.TxtDate.LabText = l_date

	local l_time = ""
	if data.ActivityTime and data.ActivityTime.Length > 0 then
		if data.ActivityTime[0][0] == 0 and data.ActivityTime[0][1] == 0 then
			l_time = Common.Utils.Lang("ALLDAY")
		else
			if math.floor(data.ActivityTime[0][0] / 1000) > 0 then
				l_time = l_time .. StringEx.SubString(data.ActivityTime[0][0], 0, 2) .. ":" .. StringEx.SubString(data.ActivityTime[0][0], 2, 2) .. "-"
			else
				l_time = l_time .. StringEx.SubString("0" .. data.ActivityTime[0][0], 0, 2) .. ":" .. StringEx.SubString("0" .. data.ActivityTime[0][0], 1, 2) .. "-"
			end
			if math.floor(data.ActivityTime[0][1]) / 1000 > 0 then
				l_time = l_time .. StringEx.SubString(data.ActivityTime[0][1], 0, 2) .. ":" .. StringEx.SubString(data.ActivityTime[0][1], 2, 2)
			else
				l_time = l_time .. StringEx.SubString("0" .. data.ActivityTime[0][1], 0, 2) .. ":" .. StringEx.SubString("0" .. data.ActivityTime[0][1], 2, 2)
			end
		end
	end
	self.Parameter.TxtTime.LabText = l_time
	self.Parameter.TxtNumber.LabText = data.ParticipationModel
	self.Parameter.Tog.TogEx.onValueChanged:AddListener(function(state)
		self.data.state = state
		self:MethodCallback(self)
	end)
	if self.Parameter.Tog.TogEx.isOn ~= data.state then
		self.Parameter.Tog.TogEx.isOn = data.state
	end
	self.Parameter.ImgGray.gameObject:SetActiveEx(MgrMgr:GetMgr("SettingMgr").CurrentAllPushSwitchState)
	
end --func end
--next--
--lua functions end

--lua custom scripts
function SettingPushNotificationTemplate:OnAllPushSwitchStateChange()
	self.Parameter.ImgGray.gameObject:SetActiveEx(MgrMgr:GetMgr("SettingMgr").CurrentAllPushSwitchState)
end
--lua custom scripts end
return SettingPushNotificationTemplate