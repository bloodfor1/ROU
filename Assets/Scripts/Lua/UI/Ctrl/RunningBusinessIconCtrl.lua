--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/RunningBusinessIconPanel"
require "Common/TimeMgr"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
RunningBusinessIconCtrl = class("RunningBusinessIconCtrl", super)
--lua class define end
local l_mgr = MgrMgr:GetMgr("MerchantMgr") 
local l_timeMgr = Common.TimeMgr
local l_data = DataMgr:GetData("MerchantData")
--lua functions
function RunningBusinessIconCtrl:ctor()
	
	super.ctor(self, CtrlNames.RunningBusinessIcon, UILayer.Normal, nil, ActiveType.Normal)
	
end --func end
--next--
function RunningBusinessIconCtrl:Init()
	
	self.panel = UI.RunningBusinessIconPanel.Bind(self)
	super.Init(self)
	-- 点击背包按钮进入跑商背包
    self.panel.Button:AddClick(function()
        l_data.MerchantShowBagType = l_data.EMerchantBagType.Default
        l_data.MerchantShopType = l_data.EMerchantShopType.Buy
		UIMgr:ActiveUI(CtrlNames.RunningBusiness)
	end)
    
    self.curMerchantState = nil
    -- 控制更新频率 
    self.updateFrameCtrl = 0

    self.refreshTimer = nil

    l_mgr.RequestGetEvent(nil, true)
end --func end
--next--
function RunningBusinessIconCtrl:Uninit()
	
    self.curMerchantState = nil
    self.updateFrameCtrl = nil

    if self.refreshTimer then
        self:StopUITimer(self.refreshTimer)
        self.refreshTimer = nil
	end

	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function RunningBusinessIconCtrl:OnActive()
	-- 刚开的时候刷新一次
    self:RefreshFewFrame()
    self:RunningBusinessPanelRefresh()
end --func end
--next--
function RunningBusinessIconCtrl:OnDeActive()
	
	
end --func end
--next--
function RunningBusinessIconCtrl:Update()
    -- 降低更新频率
    if self.updateFrameCtrl > 0 then
        self.updateFrameCtrl = self.updateFrameCtrl - 1
        return
    end

    self.updateFrameCtrl = 5

	self:RefreshFewFrame()
end --func end


--next--
function RunningBusinessIconCtrl:OnShow()
	
	
    
    self:RefreshFewFrame()
end --func end

--next--
function RunningBusinessIconCtrl:BindEvents()
    self:BindEvent(l_mgr.EventDispatcher,l_mgr.MERCHANT_STATE_UPADTE, function()
        -- logError("MERCHANT_STATE_UPADTE")
    end)
end --func end
--next--
--lua functions end

--lua custom scripts
function RunningBusinessIconCtrl:RunningBusinessPanelRefresh()
	if self.refreshTimer then
		self:StopUITimer(self.refreshTimer)
	end
	if l_data.MerchantEventRefreshTime then
		local l_curTime = l_timeMgr.GetNowTimestamp()
		local l_leftTime = l_data.MerchantEventRefreshTime - l_curTime
		self.refreshTimer = self:NewUITimer(function()
			l_mgr.RequestGetEvent()
		end, l_leftTime)
		self.refreshTimer:Start()
	end
end

function RunningBusinessIconCtrl:CloseUI()
	UIMgr:DeActiveUI(self.name)
end

function RunningBusinessIconCtrl:RefreshFewFrame()

    local l_curState = l_data.CurMerchantState
    local l_stateEnum = l_data.EMerchantState
    -- 当前正在跑商
    if l_curState == l_stateEnum.Running then
        -- 非跑商倒计时状态，处理其他界面,切换state
        if self.curMerchantState ~= l_curState then
            self.curMerchantState = l_curState
        end
        -- 更新跑商时间
        self:UpdateLeftTime()
    else
        -- 非跑商状态
        self:CloseUI()
    end
end

-- 更新跑商剩余时间
function RunningBusinessIconCtrl:UpdateLeftTime()

    local l_curTime = l_timeMgr.GetNowTimestamp()
    local l_leftTime = l_data.MerchantStartTime + l_data.MerchantDuringTime - l_curTime
    if l_leftTime <= 0 then
        self.panel.Text.LabText = "0:00"
    else
        local l_leftTimeRet = l_timeMgr.GetCountDownDayTimeTable(l_leftTime)
        self.panel.Text.LabText = StringEx.Format("{0:00}:{1:00}", l_leftTimeRet.min, l_leftTimeRet.sec)
    end
end


--lua custom scripts end
return RunningBusinessIconCtrl