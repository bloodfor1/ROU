--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/TimelimitpayPanel"
require "UI/Template/TimelimitpayTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
TimelimitpayCtrl = class("TimelimitpayCtrl", super)
--lua class define end
local l_timeMgr
local l_data
--lua functions
function TimelimitpayCtrl:ctor()
    
    super.ctor(self, CtrlNames.Timelimitpay, UILayer.Function, nil, ActiveType.Exclusive)
    
    l_timeMgr = Common.TimeMgr
    l_data = DataMgr:GetData("TimeLimitPayData")
end --func end
--next--
function TimelimitpayCtrl:Init()
    
    self.panel = UI.TimelimitpayPanel.Bind(self)
    super.Init(self)
    
    self.panel.Button:AddClick(function()
        if l_data.ActivityState ~= LimitedOfferStatusType.LIMITED_OFFER_START then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ACTIVITY_IS_ALREADY_OVER"))
            return
        end

        UIMgr:ActiveUI(UI.CtrlNames.Mall, {
            Tab = MgrMgr:GetMgr("MallMgr").MallTable.Pay,
            HideTabGroup = true,
        })
    end)

    self.panel.BtnClose:AddClick(function()
        UIMgr:DeActiveUI(self.name)
    end)

    self.payItemTemplate = self:NewTemplatePool({
        UITemplateClass = UITemplate.TimelimitpayTemplate,
        TemplateParent = self.panel.Content.transform,
        TemplatePrefab = self.panel.TimelimitpayTemplate.gameObject
    })

    self.updateFrameCtrl = 5

    self.isShowDefaultTime = false

    game:GetPayMgr():FireEvent(game:GetPayMgr().EVENT_GET_REWARD_INFO, "PayGame")

    self.roundSpineTimer = nil
end --func end
--next--
function TimelimitpayCtrl:Uninit()
    
    self.payItemTemplate = nil
    self.isShowDefaultTime = nil

    if self.roundSpineTimer then
        self:StopUITimer(self.roundSpineTimer)
        self.roundSpineTimer = nil
    end

    super.Uninit(self)
    self.panel = nil
    
end --func end
--next--
function TimelimitpayCtrl:OnActive()
    
    self.isShowDefaultTime = false

    local l_ratio = l_data.GetRatio()
    self.panel.PreviewProIntroduce.LabText = Lang("TIMELIMIT_ACTIVITY_INTRO", math.floor(l_ratio / 100))
    self:UpdateRemainningTime()
    self:SetupSpineTimer()
    self:TimelimitpayPanelRefresh()
    
end --func end
--next--
function TimelimitpayCtrl:OnDeActive()
    
    
end --func end
--next--
function TimelimitpayCtrl:Update()
    
    self:CustomUpdate()
end --func end




--next--
function TimelimitpayCtrl:BindEvents()
    
end --func end

--next--
--lua functions end

--lua custom scripts
function TimelimitpayCtrl:TimelimitpayPanelRefresh()
    local l_ratio = l_data.GetRatio()
    local l_datas = {}
    for i, v in ipairs(l_data.TimeLimitChargeLevel) do
        local l_data = {
            level = v.level,
            id = v.id,
            money = v.money,
            itemId = v.itemId,
            itemCount = v.itemCount,
            giftCount = math.floor(v.itemCount * l_ratio / 10000)
        }

        table.insert(l_datas, l_data)
    end
    self.payItemTemplate:ShowTemplates({Datas = l_datas})
end

function TimelimitpayCtrl:CustomUpdate()

    self.updateFrameCtrl = self.updateFrameCtrl - 1
    if self.updateFrameCtrl > 0 then
        return
    end
    self.updateFrameCtrl = 5

    self:UpdateRemainningTime()
end

function TimelimitpayCtrl:ShowDefaultTime()
    if self.isShowDefaultTime then
        return
    end

    self.isShowDefaultTime = true

    self.panel.HourText.LabText = "00"
    self.panel.MinText.LabText = "00"
    self.panel.SecText.LabText = "00"
end

function TimelimitpayCtrl:UpdateRemainningTime()

    if l_data.ActivityState == LimitedOfferStatusType.LIMITED_OFFER_START then
        if l_data.CurIdleState == RoleActivityStatusType.ROLE_ACTIVITY_STATUS_ACTIVE then
            local l_remainningTime = l_data.FinishTime - Time.realtimeSinceStartup
            l_remainningTime = (l_remainningTime > 0) and l_remainningTime or 0
            local l_timeRet = l_timeMgr.GetDayTimeTable(l_remainningTime)
            self.panel.HourText.LabText = StringEx.Format("{0:00}", l_timeRet.hour)
            self.panel.MinText.LabText = StringEx.Format("{0:00}", l_timeRet.min)
            self.panel.SecText.LabText = StringEx.Format("{0:00}", l_timeRet.sec)
            if self.isShowDefaultTime then
                self.isShowDefaultTime = false
            end
        elseif l_data.CurIdleState == RoleActivityStatusType.ROLE_ACTIVITY_STATUS_STANDBY then
            if self.isShowDefaultTime then
                self.isShowDefaultTime = false
            end
        else
            self:ShowDefaultTime()
        end
    else
        self:ShowDefaultTime()
    end
end

function TimelimitpayCtrl:SetupSpineTimer()

    if self.roundSpineTimer then
        self:StopUITimer(self.roundSpineTimer)
        self.roundSpineTimer = nil
    end

    local l_spine = self.panel.SkeletonGraphic.transform:GetComponent("SkeletonGraphic")

    local l_curIsIdle = true
    l_spine.startingAnimation = "IDLE"
    local l_startTime = Time.realtimeSinceStartup
    self.roundSpineTimer = self:NewUITimer(function()
        local l_flag = false
        if l_curIsIdle then
            l_flag = (Time.realtimeSinceStartup - l_startTime) >= 30
        else
            l_flag = (Time.realtimeSinceStartup - l_startTime) >= 2.667
        end
        if l_flag then
            l_startTime = Time.realtimeSinceStartup
            l_curIsIdle = not l_curIsIdle
            if l_curIsIdle then
                l_spine.startingAnimation = "IDLE"
            else
                l_spine.startingAnimation = "IDLE2"
            end
            l_spine:Initialize(true)
        end
    end, 0.033, -1, true)
    self.roundSpineTimer:Start()
end

--lua custom scripts end
return TimelimitpayCtrl