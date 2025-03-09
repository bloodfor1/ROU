--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/GuildDinnerFightInfoPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl

local l_guildData = nil
local l_guildDinnerMgr = nil 
local l_endTime = 0  --计时器结束时间
local l_isGuildFightProcessing = false  --是否进行中
local l_dinnerNotifyTimer = nil --计时器
--next--
--lua fields end

--lua class define
GuildDinnerFightInfoCtrl = class("GuildDinnerFightInfoCtrl", super)
--lua class define end

--lua functions
function GuildDinnerFightInfoCtrl:ctor()
    
    super.ctor(self, CtrlNames.GuildDinnerFightInfo, UILayer.Function, nil, ActiveType.Normal)
    
end --func end
--next--
function GuildDinnerFightInfoCtrl:Init()
    
    self.panel = UI.GuildDinnerFightInfoPanel.Bind(self)
    super.Init(self)

    l_guildData = DataMgr:GetData("GuildData")
    l_guildDinnerMgr = MgrMgr:GetMgr("GuildDinnerMgr")

    --活动信息图标点击
    self.panel.BtnActivityInfo:AddClick(function()
        if not l_isGuildFightProcessing then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GUILD_DINNER_FIGHT_WILL_BEGIN", l_guildData.dinnerFightTotalNum))
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GUILD_DINNER_FIGHT_PROCESSING", l_guildData.dinnerFightCurNum))
        end
    end)
    self.panel.Btn_CookRankInfo:AddClick(function()
        UIMgr:ActiveUI(CtrlNames.GuildDinner)
    end,true)
    self.panel.Btn_RandomEvent:AddClick(function()
        self:updateRandomEventInfo(true)
    end,true)
    self.showStateBlackboard={}
end --func end
--next--
function GuildDinnerFightInfoCtrl:Uninit()
    self:clearTimer()
    self:showCookCompetitionEffect(false)
    self.showStateBlackboard={}
    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function GuildDinnerFightInfoCtrl:OnActive()
    self.panel.MemberNum.LabText = tostring(l_guildData.dinnerFightCurNum).."/"..tostring(l_guildData.dinnerFightTotalNum)

    if not l_guildData.dinnerFightInfoShowTime then
        l_guildDinnerMgr.GetDinnerFightTime()
    end

    if self.uiPanelData~=nil then
        if self.uiPanelData.isGuildCookStart~=nil then
            self:setCookCompetitionShowState(self.uiPanelData.isGuildCookStart)
        end
        if self.uiPanelData.isGuildDinnerFightStart~=nil then
            if Common.TimeMgr.GetNowTimestamp() < l_guildData.dinnerFightStartTime then
                l_isGuildFightProcessing = false
                l_endTime = l_guildData.dinnerFightStartTime
            else
                l_isGuildFightProcessing = true
                l_endTime = l_guildData.dinnerFightEndTime
            end
            self:setGuildDinnerFightShowState(self.uiPanelData.isGuildDinnerFightStart)
        end
        if self.uiPanelData.isShowRandomEvent~=nil then
            self:setRandomEventShowState(self.uiPanelData.isShowRandomEvent)
        end
    end
    self:startCountDownTimer()
end --func end
--next--
function GuildDinnerFightInfoCtrl:OnDeActive()

end --func end
--next--
function GuildDinnerFightInfoCtrl:Update()
    
    
end --func end

--next--
function GuildDinnerFightInfoCtrl:BindEvents()
    --成员踢出后事件
    self:BindEvent(l_guildDinnerMgr.EventDispatcher,l_guildDinnerMgr.UPDATE_GUILD_DINNER_FIGHT_MEMBER_NUM,function(self)
        self.panel.MemberNum.LabText = tostring(l_guildData.dinnerFightCurNum).."/"..tostring(l_guildData.dinnerFightTotalNum)
    end)
    self:BindEvent(l_guildDinnerMgr.EventDispatcher,l_guildDinnerMgr.UPDATE_GUILD_DINNER_FIGHT_SHOW_STATE,function(self,isShow)
        self:setGuildDinnerFightShowState(isShow)
    end)
    self:BindEvent(l_guildDinnerMgr.EventDispatcher,l_guildDinnerMgr.UPDATE_GUILD_COOK_COMPETITION_STATE,function(self,isGuildCookStart)
        self:setCookCompetitionShowState(isGuildCookStart)
    end)
    self:BindEvent(l_guildDinnerMgr.EventDispatcher,l_guildDinnerMgr.UPDATE_GUILD_SCORE_INFO,function(self)
        self:updateCookCompetitionInfo()
    end)
    self:BindEvent(l_guildDinnerMgr.EventDispatcher,l_guildDinnerMgr.UPDATE_RANDOM_EVENT_TIME,function(self)
        self:setRandomEventShowState(true)
    end)

end --func end
--next--
--lua functions end

--lua custom scripts
function GuildDinnerFightInfoCtrl:startCountDownTimer()
    self:clearTimer()

    self.guildScoreInfoSynCircle = 5 --同步周期
    self.lastSynPersonScoreTime = 0
    self:refreshGuildDinnerInfo()
    l_guildDinnerMgr.ReqGuildCookingScoreInfo()
    l_dinnerNotifyTimer = self:NewUITimer(function()
        self:refreshGuildDinnerInfo()
    end, 1, -1, true)

    l_dinnerNotifyTimer:Start()
end
function GuildDinnerFightInfoCtrl:refreshGuildDinnerInfo()
    self:updateDinnerFightInfo()
    self:updateRandomEventInfo(false)
    if not self.isActive then
        return
    end
    if l_guildDinnerMgr~=nil  then
        local l_currentTime = Common.TimeMgr.GetNowTimestamp() --定时刷新公会烹饪比赛积分信息
        if l_currentTime-self.lastSynPersonScoreTime >=self.guildScoreInfoSynCircle then
            self.lastSynPersonScoreTime = l_currentTime
            l_guildDinnerMgr.ReqGuildCookingScoreInfo()
            local l_nowTime = Common.TimeMgr.GetTimeTable(self.lastSynPersonScoreTime)
            local l_cookCompetitionEndHour,l_cookCompetitionEndMinute=l_guildData.GetCookEndTime()
            if  l_nowTime.hour > l_cookCompetitionEndHour then
                self:showCookCompetitionEffect(false)
            elseif l_nowTime.hour == l_cookCompetitionEndHour and l_nowTime.min >=l_cookCompetitionEndMinute then
                self:showCookCompetitionEffect(false)
            else
                self:showCookCompetitionEffect(true)
            end
        end
    end
end
--@Description:面板显示状态黑板，当无任何需显示的图标时，关闭面板
function GuildDinnerFightInfoCtrl:onUpdateShowStateBlackboard()
    if self.showStateBlackboard.cookCompetition then
        return
    end
    if self.showStateBlackboard.dinnerFight then
        return
    end
    if self.showStateBlackboard.randomEvent then
        return
    end
    UIMgr:DeActiveUI(CtrlNames.GuildDinnerFightInfo)
end
function GuildDinnerFightInfoCtrl:setCookCompetitionShowState(isShow)
    self.panel.Img_GuildCookScore:SetActiveEx(isShow)
    self:updateCookCompetitionInfo()
    self.showStateBlackboard.cookCompetition = isShow
    self:onUpdateShowStateBlackboard()
end
function GuildDinnerFightInfoCtrl:showCookCompetitionEffect(isShow)
    if isShow then
        if self.cookCompetitionEffectId==0 or self.cookCompetitionEffectId==nil then
            local l_fxData = {}
            l_fxData.rawImage = self.panel.Raw_cookCompetition.RawImg
            l_fxData.destroyHandler = function ()
                self.cookCompetitionEffectId = 0
            end
            l_fxData.loadedCallback = function(go)
                go.transform:SetLocalScale(1.3,1.3,1.3)
            end
            self.cookCompetitionEffectId = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/Fx_Ui_PaiHangBang_01",l_fxData)
            
        end
    else
        if self.cookCompetitionEffectId~=nil and self.cookCompetitionEffectId~=0 then
            self:DestroyUIEffect(self.cookCompetitionEffectId)
            self.cookCompetitionEffectId = 0
        end
    end

end
function GuildDinnerFightInfoCtrl:setGuildDinnerFightShowState(isShow)
    self.panel.BtnActivityInfo:SetActiveEx(isShow)
    self.showStateBlackboard.dinnerFight = isShow
    self:onUpdateShowStateBlackboard()
    self:updateDinnerFightInfo()
end
function GuildDinnerFightInfoCtrl:setRandomEventShowState(isShow)
    self.showStateBlackboard.randomEvent = isShow
    self.panel.Btn_RandomEvent:SetActiveEx(isShow)
    if not isShow then
        self.hasOpenRandomEventAnim = false
    end
    self:onUpdateShowStateBlackboard()
    self:updateRandomEventInfo(false)
end
function GuildDinnerFightInfoCtrl:updateDinnerFightInfo()
    if not self.showStateBlackboard.dinnerFight then
        return
    end
    local l_remianTime = l_endTime - Common.TimeMgr.GetNowTimestamp()
    local _, _, l_minuite, l_second = Common.Functions.SecondsToDayTime(l_remianTime)
    if not l_isGuildFightProcessing then
        self.panel.TimeCount.LabText = Lang("GUILD_DINNER_FIGHT_ACTIVITY_START", l_minuite, l_second)
        if l_remianTime <= 5 then
            if l_remianTime <= 0 then
                self.panel.StartTimeCount.LabText = Lang("START")
                l_isGuildFightProcessing = true
                l_endTime = l_guildData.dinnerFightEndTime
            else
                self.panel.StartTimeCount.LabText = tostring(l_remianTime)
            end
            self.panel.StartTimeCountPart.UObj:SetActiveEx(true)
            MLuaClientHelper.PlayFxHelper(self.panel.StartTimeCountBox.UObj)
        else
            self.panel.StartTimeCountPart.UObj:SetActiveEx(false)
        end
    else
        self.panel.StartTimeCountPart.UObj:SetActiveEx(false)
        self.panel.TimeCount.LabText = Lang("GUILD_DINNER_FIGHT_ACTIVITY_END", tostring(l_minuite), tostring(l_second))
        if l_remianTime <= 0 then
            self:setGuildDinnerFightShowState(false)
        end
    end
end

function GuildDinnerFightInfoCtrl:updateCookCompetitionInfo()
    if not self.showStateBlackboard.cookCompetition then
        return
    end
    local l_scoreInfo = l_guildData.GetMyGuildCookScoreInfo()
    if l_scoreInfo~=nil then
        self.panel.Txt_GuildCookRank.LabText =Lang("RANK_INFO_STR",l_scoreInfo.rank)
        self.panel.Txt_GuildCookScore.LabText =Lang("SCORE_INFO_STR",l_scoreInfo.guildScore)
    end
end
function GuildDinnerFightInfoCtrl:updateRandomEventInfo(showTips)
    if not self.showStateBlackboard.randomEvent then
        return
    end
    local l_eventStartTime = l_guildData.GetRandomEventStartTime()
    local l_nowTime = Common.TimeMgr.GetNowTimestamp()
    local l_randomEventHasTouched,l_randomEventTouchTime = l_guildData.IsRandomEventTouched()
    if l_randomEventHasTouched then
        --随机事件被触发
        MLuaClientHelper.StopFxHelper(self.panel.Img_RandomEvent.UObj)
        self.panel.Txt_RandomEvent.LabText = Lang("EVENT_HAS_BE_TOUCHED")
        self.panel.Btn_RandomEvent:SetGray(true)
        local l_disapearTime=10
        if l_nowTime - l_randomEventTouchTime >= l_disapearTime then --等待10s消失
            self:setRandomEventShowState(false)
        end
        if showTips then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("RANDOM_EVENT_HAS_TOUCHED_TIPS"))
        end
        return
    end
    self.panel.Btn_RandomEvent:SetGray(false)
    local l_remainTime = l_eventStartTime - l_nowTime
    local l_autoDisappearTime=l_guildData.GetRandomEventLastTime()
    if l_remainTime<=0 then
        if not self.hasOpenRandomEventAnim then
            self.hasOpenRandomEventAnim = true
            MLuaClientHelper.PlayFxHelper(self.panel.Img_RandomEvent.UObj)
        end
        self.panel.Txt_RandomEvent.LabText = Lang("HAVE_UPDATE")
        --距离刷新事件时间超过事件持续时间
        if l_remainTime<=-l_autoDisappearTime then
            self:setRandomEventShowState(false)
        end
        if showTips then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("RANDOM_EVENT_HAS_REFRESHED_TIPS"))
        end
    else
        local l_remainMinute =  math.modf( l_remainTime / 60 )
        local l_remainSecond = math.fmod( l_remainTime, 60 )
        if showTips then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("RANDOM_EVENT_WILL_REFRESHED_TIPS"))
        end
        self.panel.Txt_RandomEvent.LabText = Lang("RONDOM_EVENT_REFRESH_TIME",tostring(l_remainMinute),tostring(l_remainSecond))
    end
end

function GuildDinnerFightInfoCtrl:clearTimer()
    if l_dinnerNotifyTimer~=nil then
        self:StopUITimer(l_dinnerNotifyTimer)
        l_dinnerNotifyTimer = nil
    end
end
--lua custom scripts end
return GuildDinnerFightInfoCtrl