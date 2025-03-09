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
---@class DailyActvityTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_Type MoonClient.MLuaUICom
---@field Txt_Name MoonClient.MLuaUICom
---@field Raw_Effect MoonClient.MLuaUICom
---@field Img_Selection MoonClient.MLuaUICom
---@field Img_Press MoonClient.MLuaUICom
---@field Img_Icon MoonClient.MLuaUICom
---@field Img_Bg MoonClient.MLuaUICom
---@field Btn_Go MoonClient.MLuaUICom

---@class DailyActvityTemplate : BaseUITemplate
---@field Parameter DailyActvityTemplateParameter

DailyActvityTemplate = class("DailyActvityTemplate", super)
--lua class define end

--lua functions
function DailyActvityTemplate:Init()
	
	super.Init(self)
	self.dailyTaskMgr = MgrMgr:GetMgr("DailyTaskMgr")
end --func end
--next--
function DailyActvityTemplate:OnDestroy()
	
	self:CloseTimer()
	self:DestroyLimitFx()
	
end --func end
--next--
function DailyActvityTemplate:OnDeActive()
	
	self:CloseTimer()
	self:DestroyLimitFx()
	self.activityInfo=nil
	
end --func end
--next--
function DailyActvityTemplate:OnSetData(data)
	
	if data==nil or data.activityInfo.isPreShow then return end
	local l_activityId=data.id
	local l_info = data.activityInfo.tableInfo
	if l_info==nil then
		logError("DailyActivitiesTable no exist activity@徐波:"..tostring(l_activityId))
		return
	end
	self.nowActivityData = data
	self.nowActivityInfo = data.activityInfo.tableInfo
	self.isEffectPlaying = false
	---@type DailyActivityInfo
	self.activityInfo=data.activityInfo
	self.dailyListSrollRectObj = data.scrollRectObj

	local l_isUnOpenWeekDay = self.dailyTaskMgr.IsTimeLimitActivity(l_info.ActiveType)
			and data.weekDay ~= Common.TimeMgr.GetNowWeekDay()

	if not self.activityInfo.isOpen  then
		self.Parameter.Img_Bg:SetGray(true)
		self.Parameter.Img_Icon:SetGray(true)
	else
		self.Parameter.Img_Bg:SetGray(false)
		self.Parameter.Img_Icon:SetGray(false)
	end
	self.Parameter.Txt_Name.LabText=l_info.ActivityName
	self.Parameter.Img_Icon:SetSpriteAsync(l_info.AtlasName, l_info.IconName)
	self:RefreshShowTimeText()
	self.Parameter.Btn_Go:SetActiveEx(self.dailyTaskMgr.CanGotoActivity(self.activityInfo))
	self.Parameter.Btn_Go:AddClick(function()
		local l_ui=UIMgr:GetUI(UI.CtrlNames.DailyTask)
		if l_ui~=nil then
			l_ui:GotoActivityScenePos(self.activityInfo.id,l_info.FunctionID)
		end
	end,true)

	self.Parameter.Img_Bg.Listener:SetActionButtonDown(self.onImgBgClickDown,self)
	self.Parameter.Img_Bg.Listener:SetActionButtonUp(self.onImgBgClickUp,self)
	self.Parameter.Img_Bg.Listener:SetActionClick(self.onImgBgClick,self)

	self.Parameter.Img_Bg.Listener:SetActionBeginDrag(self.onImgBgBeginDrag,self)
	self.Parameter.Img_Bg.Listener:SetActionOnDrag(self.onImgBgDrag,self)
	self.Parameter.Img_Bg.Listener:SetActionEndDrag(self.onImgBgEndDrag,self)

	self:UpdateActivityCountDown(self.activityInfo, l_isUnOpenWeekDay)
	
end --func end

function DailyActvityTemplate:RefreshShowTimeText(arg1, arg2, arg3)
	if self.nowActivityData == nil or self.nowActivityInfo == nil then
		return
	end
	if self:isNeedShowTimeText(self.dailyTaskMgr,self.nowActivityInfo,self.nowActivityData.weekDay) then
		self.Parameter.Txt_Type.LabText=self.nowActivityInfo.TimeTextDisplay
	else
		self.Parameter.Txt_Type.LabText,_=self.dailyTaskMgr.GetShowTextByDailyActivityItem(self.nowActivityInfo,false)
	end
end
--next--
function DailyActvityTemplate:BindEvents()
	local l_limitMgr = MgrMgr:GetMgr("LimitBuyMgr")
	self:BindEvent(l_limitMgr.EventDispatcher, l_limitMgr.LIMIT_BUY_COUNT_ALL_UPDATE, function(self, type, id)
        self:RefreshShowTimeText()
    end)
end --func end
--next--
--lua functions end

--lua custom scripts
function DailyActvityTemplate:isNeedShowTimeText(dailyMgr,activityTableInfo,weekDay)
	if self.activityInfo.unOpenTime then
		return true
	end

	if not dailyMgr.IsTimeLimitActivity(activityTableInfo.ActiveType) then
		return false
	end
	--- 公会狩猎不在开放时间就显示TimeText文本
	if activityTableInfo.Id == dailyMgr.g_ActivityType.activity_GuildHunt then
		return true
	end
	return weekDay ~= Common.TimeMgr.GetNowWeekDay()
end
function DailyActvityTemplate:onImgBgBeginDrag(go,eventData)
	MLuaCommonHelper.ExecuteBeginDragEvent(self.dailyListSrollRectObj,eventData)
end
function DailyActvityTemplate:onImgBgDrag(go,eventData)
	MLuaCommonHelper.ExecuteDragEvent(self.dailyListSrollRectObj,eventData)
end
function DailyActvityTemplate:onImgBgEndDrag(go,eventData)
	MLuaCommonHelper.ExecuteEndDragEvent(self.dailyListSrollRectObj,eventData)
end
function DailyActvityTemplate:onImgBgClickDown()
    self.Parameter.Img_Press:SetActiveEx(true)
end
function DailyActvityTemplate:onImgBgClickUp()
	self.Parameter.Img_Press:SetActiveEx(false)
end
function DailyActvityTemplate:onImgBgClick()
	local l_ui=UIMgr:GetUI(UI.CtrlNames.DailyTask)
	if l_ui==nil then
		return
	end
	if not self._isSelect then
		l_ui.ActivityPool:SelectTemplate(self.ShowIndex)
	end
	if self.activityInfo.isOpen then
		if not self.activityInfo.unOpenTime
				or self.activityInfo.id == self.dailyTaskMgr.g_ActivityType.activity_GuildHunt then
			if self.activityInfo.tableInfo then
				l_ui:GoToPos(Vector2.New(self.activityInfo.tableInfo.Position[0],self.activityInfo.tableInfo.Position[1]))
				l_ui:ShowDetailInfoPanel(self.activityInfo.id)
			end
		else
			l_ui:ShowDetailInfoPanel(self.activityInfo.id)
		end
	else
		MgrMgr:GetMgr("TipsMgr").ShowNormalTips(MgrMgr:GetMgr("OpenSystemMgr").GetOpenSystemTipsInfo(self.activityInfo.functionId))
	end
end
function DailyActvityTemplate:OnSelect()
	self.Parameter.Img_Selection:SetActiveEx(true)
end
function DailyActvityTemplate:OnDeselect()
	self.Parameter.Img_Selection:SetActiveEx(false)
end
function DailyActvityTemplate:CloseTimer()
	if self.countDownTimer~=nil then
		self:StopUITimer(self.countDownTimer)
		self.countDownTimer = nil
	end
end
function DailyActvityTemplate:UpdateActivityShowTime()
	if self.activityInfo==nil or self.activityInfo.netInfo==nil  then
		self:CloseTimer()
		return
	end

	if self.activityInfo.startSec > 30 * 60 then
		self.activityInfo.state = self.dailyTaskMgr.g_ActivityState.Waiting
		local l_hour, l_min = self.dailyTaskMgr.GetTimeDes(self.activityInfo.begainSec)
		local l_hour2, l_min2 = self.dailyTaskMgr.GetTimeDes(self.activityInfo.finishSec)

		if l_hour2 == 0 then
			l_hour2 = 24
		end
		self.Parameter.Txt_Type.LabText = StringEx.Format("{0:00}:{1:00}", l_hour, l_min) ..
				"-" .. StringEx.Format("{0:00}:{1:00}", l_hour2, l_min2)
		self.Parameter.Txt_Type:SetActiveEx(true)
	end
	if self.activityInfo.endSec < 0 then
		self.activityInfo.state = self.dailyTaskMgr.g_ActivityState.Finish
		if not self.activityInfo.isNormal then
			self.Parameter.Img_Bg:SetGray(true)
			self.Parameter.Img_Icon:SetGray(true)
		end

		if self.activityInfo.netInfo.state then
			self.Parameter.Txt_Type:SetActiveEx(true)
			self.Parameter.Txt_Type.LabText = Common.Utils.Lang("EDEN_TASK_FINISHED")
		else
			self.Parameter.Txt_Type.LabText = Common.Utils.Lang("ACTIVITY_STATE_FINISH")
		end
		self:DestroyLimitFx()
	end
	if self.activityInfo.startSec < 30 * 60 and self.activityInfo.startSec > 0 then
		self.activityInfo.state = self.dailyTaskMgr.g_ActivityState.CountDown
		local l_timeStr = StringEx.Format("{0:00}:{1:00}", math.modf(self.activityInfo.startSec / 60), self.activityInfo.startSec % 60)
		self.Parameter.Txt_Type.LabText = l_timeStr .. Common.Utils.Lang("ACTIVITY_BOLI_START")
		self.Parameter.Txt_Type:SetActiveEx(true)
		self:CreateLimitFx()
	end
	if self.activityInfo.startSec <= 0 and self.activityInfo.endSec > 0 then
		self.activityInfo.state = self.dailyTaskMgr.g_ActivityState.Runing
		local l_target = self.activityInfo.endSec
		if self.activityInfo.netInfo.battleStartTime > 0 then
			l_target = self.activityInfo.runState == 2 and self.activityInfo.battleStartTime or l_target
			--战场报名;
			if l_battleApply and self.activityInfo.startSec == 0 then
				self.dailyTaskMgr.UpdateDailyTaskInfo()
				l_battleApply = false
			end
			--战场开始;
			if l_battleStart and self.activityInfo.battleStartTime == 0 then
				self.dailyTaskMgr.UpdateDailyTaskInfo()
				l_battleStart = false
			end
		end
		self.activityInfo.state = self.dailyTaskMgr.g_ActivityState.Runing
		local l_minute = math.modf(l_target / 60)
		local l_second = l_target % 60
		local l_timeStr
		if l_minute>60 then
			local l_hour  = math.modf(l_minute / 60)
			l_minute = l_minute%60
			l_timeStr = StringEx.Format("{0:00}:{1:00}:{2:00}",l_hour,l_minute,l_second)
		else
			l_timeStr = StringEx.Format("{0:00}:{1:00}", l_minute, l_second)
		end

		self.Parameter.Txt_Type.LabText = l_timeStr .. self:GetRunStateDes(self.activityInfo.runState)
		self.Parameter.Txt_Type:SetActiveEx(true)
		self:CreateLimitFx()
	end
	self.activityInfo.startSec = self.activityInfo.startSec - 1
	self.activityInfo.endSec = self.activityInfo.endSec - 1

	--战场倒计时;
	self.activityInfo.battleStartTime = self.activityInfo.battleStartTime - 1
end
function DailyActvityTemplate:GetRunStateDes(state)
	if state == 2 then
		-- 报名中
		return Common.Utils.Lang("ACTIVITY_SIGNUP_PHASE")
	end
	return Common.Utils.Lang("ACTIVITY_BOLI_END") -- 后结束
end
---@param data DailyActivityInfo
function DailyActvityTemplate:UpdateActivityCountDown(data,isUnOpenWeekDay)
	self:CloseTimer()
	if data.state== self.dailyTaskMgr.g_ActivityState.Non then
		return
	end
	if isUnOpenWeekDay then
		--- 公会狩猎特殊为在冒险界面的限时活动，不考虑不在开放日情况
		if data.id~=self.dailyTaskMgr.g_ActivityType.activity_GuildHunt then
			return
		end
	end
	if data.id==self.dailyTaskMgr.g_ActivityType.activity_GuildHunt then
		local l_hasGuild=MgrMgr:GetMgr("GuildMgr").IsSelfHasGuild()
		local l_guildHuntMgr=MgrMgr:GetMgr("GuildHuntMgr")
		local l_canGetReward=l_guildHuntMgr.CheckReward()
		if not l_hasGuild or l_canGetReward then
			if l_canGetReward then
				self:CreateLimitFx()
			end
		    return
		end
	end
	self:UpdateActivityShowTime()
	self.countDownTimer=self:NewUITimer(function()
		self:UpdateActivityShowTime()
	end, 1, -1, true)
	self.countDownTimer:Start()
end
function DailyActvityTemplate:RefreshData(data)
	if data.isMonsterExpel and data.info~=nil and data.itemInfo~=nil then
		local l_strFormat,_=MgrMgr:GetMgr("DailyTaskMgr").GetShowTextByDailyActivityItem(data.itemInfo.tableInfo,false,true)
		self.Parameter.Txt_Type.LabText=StringEx.Format(l_strFormat, math.floor(data.info.remain_time/(60 * 1000)))
	end
end

function DailyActvityTemplate:CreateLimitFx(item)
	if self.isEffectPlaying then
		return
	end

	self.isEffectPlaying = true
	self.Parameter.Raw_Effect:PlayDynamicEffect()
end

function DailyActvityTemplate:DestroyLimitFx()
	self.Parameter.Raw_Effect:StopDynamicEffect()
	self.isEffectPlaying = false
end
--lua custom scripts end
return DailyActvityTemplate