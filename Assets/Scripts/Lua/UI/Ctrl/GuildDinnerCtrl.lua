--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/GuildDinnerPanel"
require "UI/Template/GuildRankTemplate"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
GuildDinnerCtrl = class("GuildDinnerCtrl", super)
--lua class define end

--lua functions
function GuildDinnerCtrl:ctor()
	
	super.ctor(self, CtrlNames.GuildDinner, UILayer.Function, nil, ActiveType.Exclusive)

end --func end
--next--
function GuildDinnerCtrl:Init()
	
	self.panel = UI.GuildDinnerPanel.Bind(self)
	super.Init(self)
	self.mgr = MgrMgr:GetMgr("GuildDinnerMgr")
	self.dataMgr = DataMgr:GetData("GuildData")

	self:InitBaseInfo()
	self:InitUICom()
end --func end
--next--
function GuildDinnerCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	self.guildScoreInfoTemplates={}
end --func end
--next--
function GuildDinnerCtrl:OnActive()
	self:startDinnerTimer()
end --func end
--next--
function GuildDinnerCtrl:OnDeActive()
	self:clearDinnerTimer()
	self.cookCompetitionEndTimeStamp=0
	self.isGuildInfoDirty = true
	self.isPersonalInfoDirty = true
end --func end
--next--
function GuildDinnerCtrl:Update()
	
	
end --func end
--next--
function GuildDinnerCtrl:Show(withTween)
	
	if not super.Show(self, withTween) then return end
	
end --func end
--next--
function GuildDinnerCtrl:Hide(withTween)
	
	if not super.Hide(self, withTween) then return end
	
end --func end
--next--
function GuildDinnerCtrl:BindEvents()
	self:BindEvent(self.mgr.EventDispatcher,self.mgr.UPDATE_GUILD_SCORE_INFO,function(self)
		self.isGuildInfoDirty = true
		self:refreshGuildInfo()
	end)
	self:BindEvent(self.mgr.EventDispatcher,self.mgr.UPDATE_COOK_PERSONAL_RANK,function(self,isAll)
		self.isPersonalInfoDirty = true
		if isAll == self.isShowAllGuildRoleRankInfo then
			self:refreshPersonalInfo()
		end
	end)

end --func end
--next--

--lua functions end

--lua custom scripts
function GuildDinnerCtrl:InitUICom()
	self.panel.RewardCloseButton:AddClick(function()
		UIMgr:DeActiveUI(CtrlNames.GuildDinner)
	end,true)
	self.panel.Tog_All:OnToggleExChanged(function(on)
		self.panel.Panel_Guild:SetActiveEx(on)
		if on then
			self:refreshGuildInfo()
		end
	end,true)
	self.panel.Tog_MyGuild:OnToggleExChanged(function(on)
		self.panel.Panel_Personal:SetActiveEx(on)
		if on then
			self.mgr.ReqPersonalCookingScoreInfo(not self.isShowAllGuildRoleRankInfo)
			self:refreshPersonalInfo()
		end
	end,true)
	self.panel.Btn_RankInfoHelp.Listener.onClick = function(go, eventData)
		local pos = Vector2.New(eventData.position.x,eventData.position.y)
		eventData.position = pos
		local l_anchor=Vector2.New(0, 0)
		MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(Lang("GUILD_COOK_HELP_DESC"), eventData, l_anchor)
	end
	self.panel.Tog_OnlyShowMyGuildInfo:OnToggleChanged(function(isOn)
		self.isShowAllGuildRoleRankInfo = not isOn
		self.isPersonalInfoDirty = true
		self:refreshPersonalInfo()
		self.mgr.ReqPersonalCookingScoreInfo(not self.isShowAllGuildRoleRankInfo)
	end, true)
	self.panel.Tog_All.TogEx.isOn = true
	self.panel.Tog_OnlyShowMyGuildInfo.Tog.isOn = self.isShowAllGuildRoleRankInfo
	self.panel.Tog_OnlyShowMyGuildInfo.Tog.isOn = false
	self.panel.GuildInfoTemplate.gameObject:SetActiveEx(false)
end
function GuildDinnerCtrl:InitBaseInfo()
    self.isGuildInfoDirty = true
	self.isPersonalInfoDirty = true
	self.isShowAllGuildRoleRankInfo = true
	self.guildScoreInfoTemplates = {}
	self.cookCompetitionEndTimeStamp = 0
	self.scoreRankInfoPool = self:NewTemplatePool({
		UITemplateClass = UITemplate.GuildRankTemplate,
		TemplatePrefab = self.panel.GuildRankTemplate.gameObject,
		ScrollRect = self.panel.LoopScroll_RankInfo.LoopScroll,
	})
end
function GuildDinnerCtrl:refreshPersonalInfo()
	if not self.isPersonalInfoDirty then
		return
	end
	self.isPersonalInfoDirty = false
	local l_data = self.dataMgr.GetGuildCookScorePersionalRank(self.isShowAllGuildRoleRankInfo)
	self.scoreRankInfoPool:ShowTemplates({Datas = l_data})
end
function GuildDinnerCtrl:refreshGuildInfo()
	if not self.isGuildInfoDirty then
		return
	end
	self.isPersonalInfoDirty = false
	local l_guildScoreData = self.dataMgr.GetGuildCookScoreInfo()
	if l_guildScoreData==nil then
		return
	end
	local l_guildInfoTemCount = #self.guildScoreInfoTemplates
	for i = 1, l_guildScoreData.guildNum do
		if i<= l_guildInfoTemCount then
			local l_guildInfoTem = self.guildScoreInfoTemplates[i]
			l_guildInfoTem:SetData(l_guildScoreData[i])
		else
			local l_guildInfoTem = self:NewTemplate("GuildInfoTemplate",{
				TemplatePrefab = self.panel.GuildInfoTemplate.gameObject,
				TemplateParent = self.panel.Panel_GuildRankInfo.Transform,
				Data = l_guildScoreData[i],
			})
			table.insert(self.guildScoreInfoTemplates,l_guildInfoTem)
		end
	end
end
--@Description:数据量大，需要控制同步次数
function GuildDinnerCtrl:startDinnerTimer()
	self:clearDinnerTimer()
	local l_personScoreSynCircle = 10
	local l_timerCount=0
	self.mgr.ReqPersonalCookingScoreInfo(true)
	self.mgr.ReqPersonalCookingScoreInfo(false)
	self:refreshCookAccountTime()
	self.guildDinnerTimer = self:NewUITimer(function()
		l_timerCount=l_timerCount+1
		if l_timerCount>=l_personScoreSynCircle then
			self.mgr.ReqPersonalCookingScoreInfo(not self.isShowAllGuildRoleRankInfo)
			l_timerCount=0
		end
		self:refreshCookAccountTime()
	end, 1, -1, true)
	self.guildDinnerTimer:Start()
end
---@Description:更新烹饪比赛计算时间
function GuildDinnerCtrl:refreshCookAccountTime()
	if self.panel==nil then
		return
	end
	local l_cookCompetitionEndTime = self:getCookCompetitionEndTimeStamp()
	local l_nowTime  = Common.TimeMgr.GetNowTimestamp()
	local l_remainTime= l_cookCompetitionEndTime-l_nowTime
	if l_remainTime>0 then
		local l_countDownTable = Common.TimeMgr.GetCountDownDayTimeTable(l_remainTime)
		self.panel.Txt_CookAccountTime.LabText = Lang("REMAIN_SETTLEMENT_COUNTDOWN",l_countDownTable.min,l_countDownTable.sec)
	else
		self.panel.Txt_CookAccountTime.LabText = Lang("COOK_COMPETITION_END_TIPS")
	end
end
function GuildDinnerCtrl:getCookCompetitionEndTimeStamp()
	local l_cookCompetitionEndHour,l_cookCompetitionEndMinute=self.dataMgr.GetCookEndTime()
	if self.cookCompetitionEndTimeStamp==0 then
		self.cookCompetitionEndTimeStamp=Common.TimeMgr.GetDayTimestamp(nil, {
			hour = l_cookCompetitionEndHour,
			min = l_cookCompetitionEndMinute,
			sec = 0
		})
	end
	return self.cookCompetitionEndTimeStamp
end
function GuildDinnerCtrl:clearDinnerTimer()
	if MLuaCommonHelper.IsNull(self.guildDinnerTimer) then
		return
	end
	self:StopUITimer(self.guildDinnerTimer)
	self.guildDinnerTimer=nil
end
--lua custom scripts end
return GuildDinnerCtrl