--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/ArenaOfferPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
ArenaOfferCtrl = class("ArenaOfferCtrl", super)
local showTime = MGlobalConfig:GetInt("EventPushInfoDisplayTime")
--lua class define end

--lua functions
function ArenaOfferCtrl:ctor()
    super.ctor(self, CtrlNames.ArenaOffer, UILayer.Tips, nil, ActiveType.Standalone)
    self.leftTime = showTime
    self.leftTimer = nil
    self.countDownTime = 0
    self.id = 0
    self.isSave = false
end --func end
--next--
function ArenaOfferCtrl:Init()
    self.panel = UI.ArenaOfferPanel.Bind(self)
    super.Init(self)
    self.leftTime = showTime
end --func end
--next--
function ArenaOfferCtrl:Uninit()
    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function ArenaOfferCtrl:OnActive()
    self.panel.ButtonJoinTxt.LabText = Lang("GO_NOW")
    self.panel.ButtonJoin:AddClick(function()
        if self.callBack then
            self.callBack()
            UIMgr:DeActiveUI(UI.CtrlNames.ArenaOffer)
            return
        end
        if MPlayerDungeonsInfo.InDungeon then
            self:MinClose()
        else
            ---特判:公会匹配赛观战;
            if self.id == MgrMgr:GetMgr("DailyTaskMgr").g_ActivityType.activity_GuildMatchWatch then
                local l_dungeonId = MGlobalConfig:GetInt("G_MatchBattleDungeonId")
                local l_info = TableUtil.GetDungeonsTable().GetRowByDungeonsID(l_dungeonId)
                MgrMgr:GetMgr("WatchWarMgr").SetSelectClassifyTypeID(l_info.SpectatorType)
                UIMgr:ActiveUI(UI.CtrlNames.WatchWarBG)
                self:MinClose()
                return
            end

            local sdata = TableUtil.GetDailyActivitiesTable().GetRowById(self.id)
            if not sdata then
                logError("invalid activity id: ", self.id)
                return
            end
            local l_dailyMgr = MgrMgr:GetMgr("DailyTaskMgr")
            ---特判:公会宴会跨动态场景寻路;
            if self.id == l_dailyMgr.g_ActivityType.activity_GuildCook or self.id == l_dailyMgr.g_ActivityType.activity_GuildCookWeek  then
                MgrMgr:GetMgr("GuildMgr").GuildFindPath_ActivitiesId(self.id)
                self:MinClose()
                return
            end
            ---特判:公会匹配赛跨动态场景寻路;
            if self.id == MgrMgr:GetMgr("DailyTaskMgr").g_ActivityType.activity_GuildMatch then
                MgrMgr:GetMgr("GuildMgr").GuildFindPath_ActivitiesId(self.id)
                self:MinClose()
                return
            end
            ---特判:公会狩猎 跨动态场景寻路;
            if self.id == l_dailyMgr.g_ActivityType.activity_GuildHunt then
                MgrMgr:GetMgr("GuildHuntMgr").GoToAttendGuildHunt()
                self:MinClose()
                return
            end
            ---特判:主题派对寻路到指定Npc并打开对话
            if self.id == l_dailyMgr.g_ActivityType.activity_WeekParty then
                Common.CommonUIFunc.InvokeFunctionByFuncId(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.ThemeParty,nil,true)
                return
            end
            l_dailyMgr.GotoDailyTask(self.id, function()
                self:MinClose()
            end)
        end
    end)
    self.panel.ButtonClose:AddClick(function()
        if self.isSave == false then
            UIMgr:DeActiveUI(UI.CtrlNames.ArenaOffer)
        else
            self:MinClose()
        end
    end)
end --func end
--next--
function ArenaOfferCtrl:OnDeActive()
    self:ClearTimer()
    self.callBack = nil
end --func end
--next--
function ArenaOfferCtrl:Update()
    if not self.panel then return end
    self.leftTime = math.max(0, self.leftTime - Time.deltaTime)
    self.panel.Slider.Slider.value = self.leftTime / showTime
    if self.leftTime == 0 then
        self:MinClose()
    end
end --func end

--next--
function ArenaOfferCtrl:OnLogout()
    self:MinClose()
end --func end

--next--
function ArenaOfferCtrl:BindEvents()

    local l_logoutMgr = MgrMgr:GetMgr("LogoutMgr")
    self:BindEvent(l_logoutMgr.EventDispatcher,l_logoutMgr.OnLogoutEvent, self.OnLogout)

    self:BindEvent(GlobalEventBus,EventConst.Names.ARENA_CLOSE_OFFER, function(self, id)
        if id == self.id then
            UIMgr:DeActiveUI(UI.CtrlNames.ArenaOffer)
        end
    end)

end --func end
--next--
--lua functions end

--lua custom scripts
function ArenaOfferCtrl:OnCountDown(countDown)
    if self.panel and self.content then
        local min, sec = math.floor(countDown/60), math.floor(countDown%60)
        local time = StringEx.Format("{0:00}:{1:00}", min, sec)
        self.panel.Content.LabText = StringEx.Format(self.content, time)
    end
end

function ArenaOfferCtrl:ClearTimer()
    if self.leftTimer then
        self:StopUITimer(self.leftTimer)
        self.countDownTime = 0
        self.leftTimer = nil
    end
end

--默认有活动推送
function ArenaOfferCtrl:StartLeftTimer(time, content, id, btnText)
    self:ClearTimer()
    self.leftTimer = self:NewUITimer(handler(self, self.OnLeftTimer), 1, -1)
    self.leftTimer:Start()
    self.countDownTime = time
    self.content = content
    self.id = id
    self.isSave = true
    self:OnCountDown(self.countDownTime)
    if btnText ~= nil then
        self.panel.ButtonJoinTxt.LabText = btnText
    end
end

function ArenaOfferCtrl:OnLeftTimer()
    self.countDownTime = math.max(0, self.countDownTime - 1)
    self:OnCountDown(self.countDownTime)
    if self.countDownTime <= 0 then
        self:ClearTimer()
    end
end


--不需要剩余时间倒计时的接口
function ArenaOfferCtrl:ShowContentWithoutCountdown(content, id, needSave, btnText)
    self:ClearTimer()
    self.content = content
    self.panel.Content.LabText = self.content
    self.id = id
    self.isSave = needSave
    if btnText ~= nil then
        self.panel.ButtonJoinTxt.LabText = btnText
    end
end

--不需要剩余时间倒计时的接口，默认不会有活动推送
function ArenaOfferCtrl:ShowContentCallBackWithoutCountdown(content, callBack)
    self:ClearTimer()
    self.content = content
    self.panel.Content.LabText = self.content
    self.callBack = callBack
    self.isSave = false
end

function ArenaOfferCtrl:MinClose()
    UIMgr:DeActiveUI(UI.CtrlNames.ArenaOffer)
    GlobalEventBus:Dispatch(EventConst.Names.ARENA_MIN_OFFER, self.id)
end
--lua custom scripts end
return ArenaOfferCtrl