--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/RunningBusinessSettlementPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
RunningBusinessSettlementCtrl = class("RunningBusinessSettlementCtrl", super)
--lua class define end

--lua functions
function RunningBusinessSettlementCtrl:ctor()
	
	super.ctor(self, CtrlNames.RunningBusinessSettlement, UILayer.Function, nil, ActiveType.Normal)
	
end --func end
--next--
function RunningBusinessSettlementCtrl:Init()
	
	self.panel = UI.RunningBusinessSettlementPanel.Bind(self)
	super.Init(self)
	
	self.panel.CloseButton:AddClick(function()
		self:CloseUI()
	end)

    self.panel.BtnSubmit:AddClick(function()
        -- 成功则寻路去找商人交互任务
        if self.winFlag then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("MERCHANT_FINISH_MOVE"))
			MgrMgr:GetMgr("MerchantMgr").GotoMerchantTaskNpc()
		end
		self:CloseUI()
	end)

	local l_item = TableUtil.GetItemTable().GetRowByItemID(GameEnum.l_virProp.MerchantCoin)
    if l_item then
		self.panel.Icon:SetSprite(l_item.ItemAtlas, l_item.ItemIcon)
	end

	self.winFlag = false
end --func end
--next--
function RunningBusinessSettlementCtrl:Uninit()
	
	self.winFlag = nil

	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function RunningBusinessSettlementCtrl:OnActive()
	if self.uiPanelData then
		self:SetResultInfo(self.uiPanelData.state, self.uiPanelData.startTime, self.uiPanelData.moneyCount)	
	end
end --func end
--next--
function RunningBusinessSettlementCtrl:OnDeActive()
	
	
end --func end
--next--
function RunningBusinessSettlementCtrl:Update()
	
	
end --func end





--next--
function RunningBusinessSettlementCtrl:BindEvents()
	
	
end --func end

--next--
--lua functions end

--lua custom scripts

function RunningBusinessSettlementCtrl:CloseUI()

	UIMgr:DeActiveUI(self.name)
end

function RunningBusinessSettlementCtrl:SetResultInfo(state, startTime, moneyCount)
    
	local l_merchantMgr = MgrMgr:GetMgr("MerchantMgr")
	local l_data = DataMgr:GetData("MerchantData")
	local EMerchantState = l_data.EMerchantState
	self.winFlag = state == EMerchantState.Success
	local l_shutdown = false
	switch(state)
	{
		[EMerchantState.Success] = function()
			self.panel.Context.LabText = Lang("MERCHANT_SUCCESS_DESC")
			self.panel.Title.LabText = Lang("MERCHANT_SUCCESS")
			self.panel.TextSubmit.LabText = Lang("MERCHANT_SUBMIT")
		end,
		[EMerchantState.Failure] = function()
			self.panel.Context.LabText = Lang("MERCHANT_FAILED_DESC")
			self.panel.Title.LabText = Lang("MERCHANT_FAILURE")
			self.panel.TextSubmit.LabText = Lang("DLG_BTN_OK")
		end,
		default = function()
			l_shutdown = true
			self:CloseUI()
		end,
	}

	if l_shutdown then
		return
	end
	local l_maxTime = DataMgr:GetData("MerchantData").MerchantDuringTime
    local l_costTime = Common.TimeMgr.GetNowTimestamp() - startTime
	l_costTime = (l_costTime <= l_maxTime) and l_costTime or l_maxTime
	local l_time = Common.TimeMgr.GetCountDownDayTimeTable(l_costTime)
	self.panel.TxtTime.LabText = StringEx.Format("{0:00}:{1:00}", l_time.min, l_time.sec)

	self.panel.TxtMoney.LabText = tostring(moneyCount)
	
end


--lua custom scripts end
return RunningBusinessSettlementCtrl