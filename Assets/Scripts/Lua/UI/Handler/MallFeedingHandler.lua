--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/Handler/MallBaseHandler"
require "UI/Panel/MallFeedingPanel"
require "UI/Template/MallFeedingPrefab"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.MallBaseHandler
--lua fields end

--lua class define
---@class MallFeedingHandler : MallBaseHandler
MallFeedingHandler = class("MallFeedingHandler", super)
--lua class define end

local l_data = DataMgr:GetData("TimeLimitPayData")
local l_timeMgr = Common.TimeMgr
--lua functions
function MallFeedingHandler:ctor()
	
	super.ctor(self, HandlerNames.MallFeeding, 0)
	
end --func end
--next--
function MallFeedingHandler:Init()
	
	self.panel = UI.MallFeedingPanel.Bind(self)
	super.Init(self)
	
	self.panel.HelpBtn:AddClick(function()
		Application.OpenURL(MgrMgr:GetMgr("UseAgreementProtoMgr").MallFeedingURL)
	end)

	self.panel.TotalRechargeAwardBtn:SetActiveEx(MgrMgr:GetMgr("TotalRechargeAwardMgr").IsSystemOpen())

	self:NewRedSign({
		Key = eRedSignKey.TotalRechargeAwardPoint,
		ClickButton = self.panel.TotalRechargeAwardBtn,
	})

	self.panel.TotalRechargeAwardBtn:AddClick(function ()
		MgrMgr:GetMgr("SystemFunctionEventMgr").OpenTotalRechargeAwardUI()
	end)

	self.isShowDefaultTime = false
	
	self:RefreshLimitState()

	self.panel.LimitBtn:SetActiveEx(self.limitPayActive)
	self.panel.LimitBtn:AddClick(function()
		UIMgr:ActiveUI(UI.CtrlNames.Rollback)
	end)
end --func end
--next--
function MallFeedingHandler:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function MallFeedingHandler:OnActive()
	
	super.OnActive(self)

	self:SetType({type = self.mallMgr.MallTable.Pay})

	self:SetupLimitTimer()
end --func end
--next--
function MallFeedingHandler:OnDeActive()
	
	self:ClearTimer()
end --func end
--next--
function MallFeedingHandler:Update()
	
end --func end
--next--
function MallFeedingHandler:BindEvents()
	

    self:BindEvent(MgrMgr:GetMgr("TimeLimitPayMgr").EventDispatcher, MgrMgr:GetMgr("TimeLimitPayMgr").ON_ACTIVITY_CHANGE, self.RefreshLimitState)

end --func end
--next--
--lua functions end

--lua custom scripts
function MallFeedingHandler:InitTemplate()

	self.ItemPool = self:NewTemplatePool({
		UITemplateClass = UITemplate.MallFeedingPrefab,
		ScrollRect = self.panel.ItemGroup.LoopScroll,
		TemplatePrefab = self.panel.MallFeedingPrefab.LuaUIGroup.gameObject,
		Method = handler(self, self.OnSelectItem)
	})
end

function MallFeedingHandler:OnSelectItem(template)
	if not self.PayData then
		return
	end

	self.ItemPool:SelectTemplate(template.ShowIndex)

	log("充值入口 => {0}", template.data.PaymentID)

	if template.data.OpenSystemID > 0 then

		Common.CommonUIFunc.InvokeFunctionByFuncId(template.data.OpenSystemID)
		return
	end

	if MgrMgr:GetMgr("TimeLimitPayMgr").IsSystemOpen() then
		CommonUI.Dialog.ShowYesNoDlg(true, Lang("TIP"), Lang("TIMELIMIT_PAY_TIPS"), function()
			self:OnPurchaseConfirm(template.data)
		end)
	else
		self:OnPurchaseConfirm(template.data)
	end
end


function MallFeedingHandler:GetItemsByArea()

	local l_curArea = MLuaCommonHelper.Enum2Int(MGameContext.CurrentChannel)

	local l_datas = {}
	local l_rows = TableUtil.GetRechargeTable().GetTable()
	for i = 1, #l_rows do
		local l_row = l_rows[i]
		if l_row.Type == self.PayData.type then
			if game:GetPayMgr():IsPaymentIDMatched(l_row.PaymentID) then
				table.insert(l_datas, l_row)
			end
		end
	end

	table.sort(l_datas, function(m, n)
		return m.SortID < n.SortID
	end)

	return l_datas
end

function MallFeedingHandler:SetType(payData)
	if not payData then
		return
	end
	self.PayData = payData

	local l_datas = self:GetItemsByArea()
	self.ItemPool:ShowTemplates({Datas = l_datas})
	self.ItemPool:SelectTemplate(0)
	
end

function MallFeedingHandler:SetTable(...)

end

function MallFeedingHandler:OnPurchaseConfirm(rechargeTableCfg)
	if MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.PaymentTips) then
		UIMgr:ActiveUI(UI.CtrlNames.PaymentInstructions,{
			rechargeTableCfg = rechargeTableCfg,
			activeTable = self,
			confirm = self.Purchase,
			cancel = self.OnCancelPurchase
		})
	else
		self:Purchase(rechargeTableCfg.PaymentID)
	end
end

function MallFeedingHandler:Purchase(PaymentID)
	game:GetPayMgr():Purchase(PaymentID)
end

function MallFeedingHandler:OnCancelPurchase()
	MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("Refund_Instructions_CancelBuy"))
end


function MallFeedingHandler:RefreshLimitState()

	self.limitPayActive = MgrMgr:GetMgr("TimeLimitPayMgr").IsSystemOpen()

	self.panel.LimitBtn:SetActiveEx(self.limitPayActive)
end

function MallFeedingHandler:UpdateRemainningTime()
    if l_data.ActivityState == LimitedOfferStatusType.LIMITED_OFFER_START then
        if l_data.CurIdleState == RoleActivityStatusType.ROLE_ACTIVITY_STATUS_ACTIVE then
            local l_remainningTime = l_data.FinishTime - Time.realtimeSinceStartup
            l_remainningTime = (l_remainningTime > 0) and l_remainningTime or 0
            local l_timeRet = l_timeMgr.GetDayTimeTable(l_remainningTime)
            self.panel.TextTime.LabText = string.format("%s:%s:%s", StringEx.Format("{0:00}", l_timeRet.hour), StringEx.Format("{0:00}", l_timeRet.min), StringEx.Format("{0:00}", l_timeRet.sec))
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

function MallFeedingHandler:ShowDefaultTime()
    if self.isShowDefaultTime then
        return
    end

    self.isShowDefaultTime = true

    self.panel.TextTime.LabText = ""
end

function MallFeedingHandler:SetupLimitTimer()

	self:ClearTimer()

	if self.limitPayActive then
		self.timer = self:NewUITimer(function()
			self:UpdateRemainningTime()
		end, 1, -1, true)
		self.timer:Start()	
	end
end

function MallFeedingHandler:ClearTimer()

	if self.timer then
		self.timer:Stop()
		self.timer = nil
	end
end

--lua custom scripts end
return MallFeedingHandler