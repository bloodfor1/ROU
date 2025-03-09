--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseHandler"
require "UI/Panel/ReBackLoginPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseHandler
--lua fields end

--lua class define
ReBackLoginHandler = class("ReBackLoginHandler", super)
--lua class define end

--lua functions
function ReBackLoginHandler:ctor()

    super.ctor(self, HandlerNames.ReBackLogin, 0)

end --func end
--next--
function ReBackLoginHandler:Init()

    self.panel = UI.ReBackLoginPanel.Bind(self)
    super.Init(self)

    self.reBackLoginMgr = MgrMgr:GetMgr("ReBackLoginMgr")
    self.currentTableInfo = nil
    self.dayAwardList=nil
    self.sumDayAwardList=nil

    self.dailyAwardTemplatePool = self:NewTemplatePool({
        TemplateClassName = "ReBackLoginDailyAwardTemplate",
        TemplatePrefab = self.panel.ReBackLoginDailyAwardPrefab.gameObject,
        ScrollRect = self.panel.ReBackLoginDailyAwardScroll.LoopScroll,
    })

    self.sumAwardTemplatePool = self:NewTemplatePool({
        TemplateClassName = "ReBackLoginSumAwardTemplate",
        TemplatePrefab = self.panel.ReBackLoginSumAwardPrefab.gameObject,
        ScrollRect = self.panel.ReBackLoginSumAwardScroll.LoopScroll,
    })


end --func end
--next--
function ReBackLoginHandler:Uninit()

    super.Uninit(self)
    self.panel = nil

    self.reBackLoginMgr = nil
    self.currentTableInfo = nil

end --func end
--next--
function ReBackLoginHandler:OnActive()
    local tableInfo = self.reBackLoginMgr.GetReturnLoginRewardTableInfo()
    self.currentTableInfo = tableInfo

    self:_getAward()

end --func end
--next--
function ReBackLoginHandler:OnDeActive()


end --func end
--next--
function ReBackLoginHandler:OnShow()
    self:InitLeftTime()
end --func end
--next--
function ReBackLoginHandler:OnHide()
    if self.leftTimer then
        self:StopUITimer(self.leftTimer)
        self.leftTimer = nil
    end
end --func end
--next--
function ReBackLoginHandler:Update()


end --func end
--next--
function ReBackLoginHandler:BindEvents()
    local awardPreviewMgr = MgrMgr:GetMgr("AwardPreviewMgr")
    self:BindEvent(awardPreviewMgr.EventDispatcher, self.reBackLoginMgr.GetDayAwardEvent, self._showDayAward)
    self:BindEvent(awardPreviewMgr.EventDispatcher, self.reBackLoginMgr.GetSumDayAwardEvent, self._showSumDayAward)
    self:BindEvent(self.reBackLoginMgr.EventDispatcher, self.reBackLoginMgr.ReceiveReturnPrizeLoginAwardUpdateEvent, self._showAward)
    self:BindEvent(self.reBackLoginMgr.EventDispatcher, self.reBackLoginMgr.OnReconnectedEvent, self._getAward)
end --func end
--next--
--lua functions end

--lua custom scripts

function ReBackLoginHandler:_getAward()
    if self.currentTableInfo == nil then
        return
    end
    local awardPreviewMgr = MgrMgr:GetMgr("AwardPreviewMgr")
    local dayAward = Common.Functions.VectorToTable(self.currentTableInfo.DayAward)
    awardPreviewMgr.GetBatchPreviewRewards(dayAward, self.reBackLoginMgr.GetDayAwardEvent)

    local sumDayAward = Common.Functions.VectorToTable(self.currentTableInfo.SumDayAward)
    awardPreviewMgr.GetBatchPreviewRewards(sumDayAward, self.reBackLoginMgr.GetSumDayAwardEvent)

end

function ReBackLoginHandler:_showAward()
    self:_showDayAward(self.dayAwardList)
    self:_showSumDayAward(self.sumDayAwardList)
end

function ReBackLoginHandler:_showDayAward(awardList)
    if awardList == nil then
        return
    end
    self.dayAwardList=awardList
    local dataTable = self:_getTemplateData(awardList, self.currentTableInfo.DayAward)
    self.dailyAwardTemplatePool:ShowTemplates({ Datas = dataTable })

end
function ReBackLoginHandler:_showSumDayAward(awardList)
    if awardList == nil then
        return
    end
    self.sumDayAwardList=awardList
    local dataTable = self:_getTemplateData(awardList, self.currentTableInfo.SumDayAward)
    local sumDay = self.currentTableInfo.SumDay
    for i = 1, sumDay.Length do
        if i <= #dataTable then
            dataTable[i].Day = sumDay[i - 1]
        end
    end
    self.sumAwardTemplatePool:ShowTemplates({ Datas = dataTable })

end

function ReBackLoginHandler:_getTemplateData(awardList, tableAward)
    local awardCache = {}
    local award
    for i = 1, #awardList do
        award = awardList[i]
        awardCache[award.award_id] = award.award_list
    end

    local templateDataTable = {}
    for i = 1, tableAward.Length do
        local award = awardCache[tableAward[i - 1]]
        if award then
            local templateData = {}
            templateData.AwardList = award
            table.insert(templateDataTable, templateData)
        end
    end
    return templateDataTable
end

function ReBackLoginHandler:InitLeftTime()
    local reBackMgr = MgrMgr:GetMgr("ReBackMgr")
    local leftTime = reBackMgr.GetLeftTime()
    if leftTime <= 0 then
        self.panel.LeftTimeRoot:SetActiveEx(false)
    else
        self.panel.LeftTimeRoot:SetActiveEx(true)
        self.panel.LeftTime.LabText = reBackMgr.GetFormatTime(leftTime)
        if self.leftTimer then
            self:StopUITimer(self.leftTimer)
            self.leftTimer = nil
        end
        self.leftTimer = self:NewUITimer(function()
            self.panel.LeftTime.LabText = reBackMgr.GetFormatTime(leftTime)
            leftTime = leftTime - 1
            if leftTime <= 0 then
                self.panel.LeftTimeRoot:SetActiveEx(false)
                self:StopUITimer(self.leftTimer)
            end
        end, 1, -1, true)
        self.leftTimer:Start()
    end
end

--lua custom scripts end
return ReBackLoginHandler