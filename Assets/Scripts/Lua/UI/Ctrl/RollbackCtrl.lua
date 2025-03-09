--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/RollbackPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
---@class RollbackCtrl : UIBaseCtrl
RollbackCtrl = class("RollbackCtrl", super)
--lua class define end

local l_timeMgr
local l_data
local l_limitPayMgr
--lua functions
function RollbackCtrl:ctor()
	
	super.ctor(self, CtrlNames.Rollback, UILayer.Function, nil, ActiveType.Exclusive)
	
	l_timeMgr = Common.TimeMgr
    l_data = DataMgr:GetData("TimeLimitPayData")
    l_limitPayMgr = MgrMgr:GetMgr("TimeLimitPayMgr")
end --func end
--next--
function RollbackCtrl:Init()
	
	self.panel = UI.RollbackPanel.Bind(self)
	super.Init(self)
	
	self.panel.Btn_Back:AddClick(function()
		UIMgr:DeActiveUI(self.name)
	end)

	self.panel.Btn:AddClick(function()
		if l_data.ActivityState ~= LimitedOfferStatusType.LIMITED_OFFER_START then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ACTIVITY_IS_ALREADY_OVER"))
            return
        end

        UIMgr:ActiveUI(UI.CtrlNames.Mall, {
            Tab = MgrMgr:GetMgr("MallMgr").MallTable.Pay,
        })
	end)

	self.updateFrameCtrl = 5

    self.isShowDefaultTime = false

    self.panel.TitleOff.LabText = string.format("%d%%", l_data.GetRatio() / 100)

    MgrMgr:GetMgr("RedSignMgr").SetIgnoreState(eRedSignKey.WelfareTimeLimitPay, 0, 1)
end --func end
--next--
function RollbackCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function RollbackCtrl:OnActive()
	
	self.isShowDefaultTime = false

    local l_ratio = l_data.GetRatio()
    self.panel.TextDesc.LabText = Lang("TIMELIMIT_ACTIVITY_INTRO", math.floor(l_ratio / 100))

    self.awardIds = {}

    l_limitPayMgr.ReqeustAwardInfo()

    self:UpdateRemainningTime()
    self:TimelimitpayPanelRefresh()

    self:CreateFx()
end --func end
--next--
function RollbackCtrl:OnDeActive()
	
	if self.fxId and self.fxId > 0 then
        self:DestroyUIEffect(self.fxId)
        self.fxId = 0
    end
end --func end
--next--
function RollbackCtrl:Update()
	
	self:CustomUpdate()
end --func end
--next--
function RollbackCtrl:BindEvents()
	
	self:BindEvent(l_limitPayMgr.EventDispatcher, l_limitPayMgr.ON_AWARD_INFO_NOTIFY, self.OnBatchAwardPreview)

    self:BindEvent(l_limitPayMgr.EventDispatcher, l_limitPayMgr.ON_ACTIVITY_CHANGE, self.OnActivityChange)
end --func end
--next--
--lua functions end

--lua custom scripts

function RollbackCtrl:TimelimitpayPanelRefresh()

    self:OnBatchAwardPreview()

end

function RollbackCtrl:OnBatchAwardPreview()

    local l_ratio = l_data.GetRatio()
    local l_info = l_data.AwardInfo
    
    if not l_info then
        return
    end

	for i, v in ipairs(l_info) do
		local l_value = v
		self.panel["Text" .. i].LabText = l_value
		self.panel["Addtion" .. i].LabText = math.ceil(l_value * l_ratio / 10000)
	end
end

function RollbackCtrl:CustomUpdate()

    self.updateFrameCtrl = self.updateFrameCtrl - 1
    if self.updateFrameCtrl > 0 then
        return
    end
    self.updateFrameCtrl = 5

    self:UpdateRemainningTime()
end

function RollbackCtrl:ShowDefaultTime()
    if self.isShowDefaultTime then
        return
    end

    self.isShowDefaultTime = true

    self.panel.Hour.LabText = "00"
    self.panel.Min.LabText = "00"
    self.panel.Sec.LabText = "00"
end

function RollbackCtrl:UpdateRemainningTime()

    if l_data.ActivityState == LimitedOfferStatusType.LIMITED_OFFER_START then
        if l_data.CurIdleState == RoleActivityStatusType.ROLE_ACTIVITY_STATUS_ACTIVE then
            local l_remainningTime = l_data.FinishTime - Time.realtimeSinceStartup
            l_remainningTime = (l_remainningTime > 0) and l_remainningTime or 0
            local l_timeRet = l_timeMgr.GetDayTimeTable(l_remainningTime)
            self.panel.Hour.LabText = StringEx.Format("{0:00}", l_timeRet.hour)
            self.panel.Min.LabText = StringEx.Format("{0:00}", l_timeRet.min)
            self.panel.Sec.LabText = StringEx.Format("{0:00}", l_timeRet.sec)
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

function RollbackCtrl:CreateFx()

    if self.fxId and self.fxId > 0 then
        self:DestroyUIEffect(self.fxId)
        self.fxId = 0
    end
    local l_fxData = {}
    l_fxData.rawImage = self.panel.RawImage.RawImg
    l_fxData.destroyHandler = function()
        self.fxId = 0
    end
    self.fxId = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/Fx_UI_MiaoMiaoLaiLe_TouShi_01", l_fxData)
end

function RollbackCtrl:OnActivityChange()

    if l_data.ActivityState ~= LimitedOfferStatusType.LIMITED_OFFER_START then
        UIMgr:DeActiveUI(self.name)
    end
end

--lua custom scripts end
return RollbackCtrl