--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseHandler"
require "UI/Panel/SettingPushNotificationPanel"
require "UI/Template/SettingPushNotificationTemplate"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseHandler
local ALL_SWITCH_STR_LENGTH = TableUtil.GetPushInformationTable().GetTableSize()		-- 推送开关列表长度
local Mgr = MgrMgr:GetMgr("SettingMgr")
--lua fields end

--lua class define
SettingPushNotificationHandler = class("SettingPushNotificationHandler", super)
--lua class define end

--lua functions
function SettingPushNotificationHandler:ctor()
	
	super.ctor(self, HandlerNames.SettingPushNotification, 0)
	
end --func end
--next--
function SettingPushNotificationHandler:Init()
	
	self.panel = UI.SettingPushNotificationPanel.Bind(self)
	super.Init(self)
	self.panel.TogAll.TogEx.onValueChanged:AddListener(function(state)
		-- 点击所有推送
		self:SetTxtTogNameState(self.panel.TxtAllPushName, state)
		self:RefreshAllPushGray()
		self:ReqPushSwitchInfoModify()
	end)
	self.panel.TogActive.TogEx.onValueChanged:AddListener(function(state)
		-- 点击广告推送
		self:SetTxtTogNameState(self.panel.TxtActivePushName, state)
		self:ReqPushSwitchInfoModify()
	end)
	self.panel.TogNight.TogEx.onValueChanged:AddListener(function(state)
		-- 点击深夜推送
		self:SetTxtTogNameState(self.panel.TxtNightPushName, state)
		self:SetTxtTogTimeState(self.panel.TxtNightPushTime, state)
		self:ReqPushSwitchInfoModify()
	end)
	-- 子推送展示
	self.PushTemplatePool = self:NewTemplatePool({
		UITemplateClass = UITemplate.SettingPushNotificationTemplate,
		TemplatePrefab = self.panel.SettingPushNotificationItemPrefab.gameObject,
		ScrollRect = self.panel.ScrollRect.LoopScroll
	})
	self.pushData = {}
	self.currentPushSwitchData = {main_switch = 0, all_switch_on = {}, all_switch_off = {}}	--当前所有推送开关数据
	self.OnPushSwitchInfoSuccess = false -- 当前是否获取到服务器推送数据
	self:InitView()
	
end --func end
--next--
function SettingPushNotificationHandler:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	self.pushData = {}
	self.currentPushSwitchData = {main_switch = 0, all_switch_on = {}, all_switch_off = {}}
	self.OnPushSwitchInfoSuccess = false
	
end --func end
--next--
function SettingPushNotificationHandler:OnActive()
	
	self:SetTxtPushNightTime()
	self:RefreshAllPushGray()
	
end --func end
--next--
function SettingPushNotificationHandler:OnDeActive()
	
	-- 关掉当前ui时 确保服务器同步客户端数据
	self:ReqPushSwitchInfoModify()
	
end --func end
--next--
function SettingPushNotificationHandler:Update()
	
	
end --func end
--next--
function SettingPushNotificationHandler:BindEvents()
	
	self:BindEvent(Mgr.EventDispatcher, Mgr.OnPushSwitchInfo, function(_, data, type)
		self:OnPushSwitchInfo(data, type)
	end)
	
end --func end
--next--
--lua functions end

--lua custom scripts
function SettingPushNotificationHandler:InitView()
	-- 从表中筛选数据
	local l_pushTable = TableUtil.GetPushInformationTable().GetTable()
	for i = 1, #l_pushTable do
		if l_pushTable[i].PlayerManualModification[0] == 1 then
			local l_tmpData = {}
			l_tmpData.Id = l_pushTable[i].Id
			l_tmpData.SystemName = l_pushTable[i].SystemName
			l_tmpData.state = l_pushTable[i].PlayerManualModification[1] == 1 and true or false
			if l_pushTable[i].IndexType[0] == 1 then
				local l_dailyData = TableUtil.GetDailyActivitiesTable().GetRowById(l_pushTable[i].IndexType[1], true)
				if l_dailyData then
					l_tmpData.Date = l_dailyData.TimeCycle
					l_tmpData.ActivityTime = l_dailyData.TimePass
					l_tmpData.ParticipationModel = l_dailyData.ModeTextDisplay
				end
			else
				l_tmpData.Date = l_pushTable[i].Date
				l_tmpData.ActivityTime = l_pushTable[i].ActivityTime
				l_tmpData.ParticipationModel = l_pushTable[i].ParticipationModel
			end
			ALL_SWITCH_STR_LENGTH = math.max(ALL_SWITCH_STR_LENGTH, l_tmpData.Id)
			table.insert(self.pushData, l_tmpData)
		end
	end
	-- 请求开关数据
	self.panel.Panel.gameObject:SetActiveEx(false)
	self.panel.NoData.gameObject:SetActiveEx(true)
	Mgr.ReqPushSwitchInfo()
end

-- 服务器推送更新数据回调
function SettingPushNotificationHandler:OnPushSwitchInfo(data, type)
	log("OnPushSwitchInfo: ", type)
	self.panel.Panel.gameObject:SetActiveEx(true)
	self.panel.NoData.gameObject:SetActiveEx(false)
	if type == "info" then
		self.currentPushSwitchData.main_switch = data.main_switch
		self.currentPushSwitchData.all_switch_on = data.all_switch_on
		self.currentPushSwitchData.all_switch_off = data.all_switch_off
		if Common.Bit32.And(data.main_switch, 1) > 0 and not self.panel.TogAll.TogEx.isOn then
			self.panel.TogAll.TogEx.isOn = true
		elseif Common.Bit32.And(data.main_switch, 1) == 0 and self.panel.TogAll.TogEx.isOn then
			self.panel.TogAll.TogEx.isOn = false
		end
		if Common.Bit32.And(data.main_switch, 2) > 0 and not self.panel.TogActive.TogEx.isOn then
			self.panel.TogActive.TogEx.isOn = true
		elseif Common.Bit32.And(data.main_switch, 2) == 0 and self.panel.TogActive.TogEx.isOn then
			self.panel.TogActive.TogEx.isOn = false
		end
		if Common.Bit32.And(data.main_switch, 4) > 0 and not self.panel.TogNight.TogEx.isOn then
			self.panel.TogNight.TogEx.isOn = true
		elseif Common.Bit32.And(data.main_switch, 4) == 0 and self.panel.TogNight.TogEx.isOn then
			self.panel.TogNight.TogEx.isOn = false
		end

		for _, item in ipairs(self.pushData) do
			local flag = false
			for __, v in ipairs(data.all_switch_on) do
				if item.Id == v then
					flag = true
					break
				end
			end
			item.state = flag
		end
		self:RefreshTemplatePool()
		self.OnPushSwitchInfoSuccess = true
	elseif type == "infomodify" then
		-- 收到服务器修改协议，暂时不需要多做动作
		--if self:IsSyncPushSwitch(self.currentPushSwitchData, data) then
		--end
	end
end

-- 点击总推送开关 控制相关ui状态
function SettingPushNotificationHandler:RefreshAllPushGray()
	self:SetTxtTogNameState(self.panel.TxtActivePushName, self.panel.TogActive.TogEx.isOn)
	self:SetTxtTogNameState(self.panel.TxtNightPushName, self.panel.TogNight.TogEx.isOn)
	self:SetTxtTogTimeState(self.panel.TxtNightPushTime, self.panel.TogNight.TogEx.isOn)
	self:SetImgTogState(self.panel.ImgTogActive.Img, self.panel.TogActive.TogEx.isOn)
	self:SetImgTogState(self.panel.ImgTogNight.Img, self.panel.TogNight.TogEx.isOn)
	self.panel.ImgTogActiveGray:SetActiveEx(not self.panel.TogAll.TogEx.isOn)
	self.panel.ImgTogNightGray:SetActiveEx(not self.panel.TogAll.TogEx.isOn)
	Mgr.CurrentAllPushSwitchState = not self.panel.TogAll.TogEx.isOn
	Mgr.EventDispatcher:Dispatch(Mgr.OnAllPushSwitchStateChange)
end

-- 刷新template pool
function SettingPushNotificationHandler:RefreshTemplatePool()
	self.PushTemplatePool:ShowTemplates({ Datas = self.pushData, Method = function(item)
		for _, v in ipairs(self.pushData) do
			if v.Id == item.data.Id then
				v.state = item.data.state
				break
			end
		end
		self:ReqPushSwitchInfoModify()
	end})
end

-- 修改推送开关
function SettingPushNotificationHandler:ReqPushSwitchInfoModify()
	if not self.OnPushSwitchInfoSuccess then return end

	local arg = {}
	arg.main_switch = 0
	arg.all_switch_on = {}
	arg.all_switch_off = {}
	-- 处理总开关
	arg.main_switch = arg.main_switch + (self.panel.TogAll.TogEx.isOn and 1 or 0)
	arg.main_switch = arg.main_switch + (self.panel.TogActive.TogEx.isOn and 2 or 0)
	arg.main_switch = arg.main_switch + (self.panel.TogNight.TogEx.isOn and 4 or 0)

	-- 处理推送列表开关
	for _, v in ipairs(self.pushData) do
		if v.state then
			table.insert(arg.all_switch_on, v.Id)
		else
			table.insert(arg.all_switch_off, v.Id)
		end
	end
	if self:IsSyncPushSwitch(self.currentPushSwitchData, arg) then
		self.currentPushSwitchData = arg
		Mgr.ReqPushSwitchInfoModify(arg)
	end
end

-- 客户端与服务器是否需要同步数据
function SettingPushNotificationHandler:IsSyncPushSwitch(localData, serverData)
	if localData.main_switch == serverData.main_switch then
		local l_localAllSwitchPushList = {}
		local l_serverAllSwitchPushList = {}
		for i = 1, ALL_SWITCH_STR_LENGTH do
			l_localAllSwitchPushList[i] = "0"
			l_serverAllSwitchPushList[i] = "0"
		end
		for _, item in ipairs(self.pushData) do
			for __, v in ipairs(localData.all_switch_on) do
				if item.Id == v then
					l_localAllSwitchPushList[v] = "1"
				end
			end
			for __, v in ipairs(serverData.all_switch_on) do
				if item.Id == v then
					l_serverAllSwitchPushList[v] = "1"
				end
			end
		end
		local l_localStr = ""
		local l_serverStr = ""
		for i = 1, ALL_SWITCH_STR_LENGTH do
			l_localStr = l_localStr .. l_localAllSwitchPushList[i]
			l_serverStr = l_serverStr .. l_serverAllSwitchPushList[i]
		end
		return l_localStr ~= l_serverStr
	else
		return true
	end
end

-- 设置tog状态 start
function SettingPushNotificationHandler:SetTxtTogNameState(go, state)
	local isGray = not self.panel.TogAll.TogEx.isOn
	if isGray then
		go.LabColor = Color.New(152 / 255, 172 / 255, 213 / 255, 1)
	else
		if state then
			go.LabColor = Color.New(89 / 255, 135 / 255, 229 / 255, 1)
		else
			go.LabColor = Color.New(152 / 255, 172 / 255, 213 / 255, 1)
		end
	end
end

function SettingPushNotificationHandler:SetTxtTogTimeState(go, state)
	local isGray = not self.panel.TogAll.TogEx.isOn
	if isGray then
		go.LabColor = Color.New(152 / 255, 172 / 255, 213 / 255, 1)
	else
		if state then
			go.LabColor = Color.New(94 / 255, 95 / 255, 159 / 255, 1)
		else
			go.LabColor = Color.New(161 / 255, 161 / 255, 185 / 255, 1)
		end
	end
end

function SettingPushNotificationHandler:SetImgTogState(img, state)
	local isGray = not self.panel.TogAll.TogEx.isOn
	img.color = Color.New(117 / 255, 158 / 255, 238 / 255, 1)
	if isGray then
		if state then
			img.color = Color.New(186 / 255, 197 / 255, 219 / 255, 1)
		end
	end
end
-- 设置tog状态 end

-- 夜间时间段读表
function SettingPushNotificationHandler:SetTxtPushNightTime()
	local l_nightTimePushTime = MGlobalConfig:GetSequenceOrVectorString("NightTimePushTime")
	if l_nightTimePushTime then
		local l_time = ""
		if math.floor(l_nightTimePushTime[0] / 1000) > 0 then
			l_time = l_time .. StringEx.SubString(l_nightTimePushTime[0], 0, 2) .. ":" .. StringEx.SubString(l_nightTimePushTime[0], 2, 2) .. "-"
		else
			l_time = l_time .. StringEx.SubString("0" .. l_nightTimePushTime[0], 0, 2) .. ":" .. StringEx.SubString("0" .. l_nightTimePushTime[0], 2, 2) .. "-"
		end
		if math.floor(l_nightTimePushTime[1] / 1000) > 0 then
			l_time = l_time .. StringEx.SubString(l_nightTimePushTime[1], 0, 2) .. ":" .. StringEx.SubString(l_nightTimePushTime[1], 2, 2)
		else
			l_time = l_time .. StringEx.SubString("0" .. l_nightTimePushTime[1], 0, 2) .. ":" .. StringEx.SubString("0" .. l_nightTimePushTime[1], 2, 2)
		end
		self.panel.TxtNightPushTime.LabText = StringEx.Format("（{0}）", l_time)
	end
end
--lua custom scripts end
return SettingPushNotificationHandler