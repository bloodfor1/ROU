--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/PaymentInstructionsPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

-- paymentTable的AwardId,配置1从ItemTable读数据，配2从AwardTable读
local awardType = {
	award = 1,
	item = 2
}

local l_mgr = MgrMgr:GetMgr("MallMgr")
local l_rebateMgr = MgrMgr:GetMgr("RebateMonthCardMgr")

--lua class define
PaymentInstructionsCtrl = class("PaymentInstructionsCtrl", super)
--lua class define end

--lua functions
function PaymentInstructionsCtrl:ctor()
	
	super.ctor(self, CtrlNames.PaymentInstructions, UILayer.Tips, nil, ActiveType.Standalone)

    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor = BlockColor.Dark
	
end --func end
--next--
function PaymentInstructionsCtrl:Init()
	
	self.panel = UI.PaymentInstructionsPanel.Bind(self)
	super.Init(self)

	self.panel.BtnOK:AddClickWithLuaSelf(self._onBtnConfirm,self)
	self.panel.BtnCancel:AddClickWithLuaSelf(self._onBtnCancel,self)
    self.panel.BtnInstruction:AddClickWithLuaSelf(self._onBtnInstruction,self)
	
end --func end
--next--
function PaymentInstructionsCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function PaymentInstructionsCtrl:OnActive()
	self.panel.CurrencyEveryDay_2:SetActiveEx(false)
	self.panel.CurrencyImmediately_2:SetActiveEx(false)
	self.panel.NumEveryday_2:SetActiveEx(false)
	self.panel.NumImmediately_2:SetActiveEx(false)
	if self.uiPanelData  then
		if self.uiPanelData.rechargeTableCfg then
			self.rechargeTableCfg = self.uiPanelData.rechargeTableCfg
		elseif self.uiPanelData.productId then
			self.rechargeTableCfg = self:_getRechargeCfgByProductID(self.uiPanelData.productId)
		else
			logError("没有传rechargeTable数据")
			UIMgr:DeActiveUI(UI.CtrlNames.PaymentInstructions)
			return
		end

		if self.uiPanelData.secondDayNum then
			self.panel.CurrencyEveryDay_2:SetActiveEx(true)
			self.panel.NumEveryday_2:SetActiveEx(true)
			self.panel.NumEveryday_2.LabText = self.uiPanelData.secondDayNum
			local l_itemTableInfo_2 = TableUtil.GetItemTable().GetRowByItemID(self.uiPanelData.secondCoinId)
			self.panel.CurrencyEveryDay_2:SetSprite(l_itemTableInfo_2.ItemAtlas, l_itemTableInfo_2.ItemIcon)

		end

		if not self.rechargeTableCfg then
			UIMgr:DeActiveUI(UI.CtrlNames.PaymentInstructions)
			logError("没有找到rechargeTable配置:没传rechargeTable数据或传了错误的productId:productId:"..tostring(self.uiPanelData.productId))
		end
		self.paymentCfg = TableUtil.GetPaymentTable().GetRowByProductId(self.rechargeTableCfg.PaymentID)

		if self.paymentCfg.ProductType == l_mgr.ProductType_TYPE.Recharge then		-- 普通充值
			self.activeTable = self.uiPanelData.activeTable
			self.confirm = self.uiPanelData.confirm
			self.cancel = self.uiPanelData.cancel
			self:_setRechargeInfo()
		elseif self.paymentCfg.ProductType == l_mgr.ProductType_TYPE.CommonMonthCard
				or self.paymentCfg.ProductType == l_mgr.ProductType_TYPE.SuperMonthCard then		-- 月卡，超级月卡
			self.totalDay = self.uiPanelData.totalDay
			self.everydayNum = self.uiPanelData.everydayNum
			self.immediatiatelyNum = self.uiPanelData.immediatiatelyNum
			self.activeTable = self.uiPanelData.activeTable
			self.confirm = self.uiPanelData.confirm
			self.cancel = self.uiPanelData.cancel
			self:_setMonthCardInfo()
		end
	else
		UIMgr:DeActiveUI(UI.CtrlNames.PaymentInstructions)
	end

end --func end
--next--
function PaymentInstructionsCtrl:OnDeActive()

	self.rechargeTableCfg = nil
	self.activeTable = nil
	self.confirm = nil
	self.cancel = nil
	
end --func end
--next--
function PaymentInstructionsCtrl:Update()
	
	
end --func end
--next--
function PaymentInstructionsCtrl:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function PaymentInstructionsCtrl:_setRechargeInfo()

	self.panel.Recharge:SetActiveEx(true)
	self.panel.MonthCard:SetActiveEx(false)
	self.panel.Blank:SetActiveEx(false)
	self.panel.PaymentTipRoot:SetActiveEx(true)
    self.panel.InstructionContent.LabText = Common.Utils.Lang("Refund_Instructions_Tip")

    self.panel.CommodityName.LabText = self.rechargeTableCfg.Name
    self.panel.CommodityIcon:SetSprite(self.rechargeTableCfg.Atlas,self.rechargeTableCfg.Icon, true)
    self.panel.Money.LabText = game:GetPayMgr():GetPaymentCurrencyFormatByProductId(self.rechargeTableCfg.PaymentID)

	local splitID = MGlobalConfig:GetInt("RechargePayItemIdForText")
	local top = ""
	local bottom = ""
	local award = self.paymentCfg.AwardId
	if award then
		if award[0] == awardType.item then
			local itemCfg = TableUtil.GetItemTable().GetRowByItemID(award[1])
			if award[1] == splitID then
				top = itemCfg.ItemName..'\n'
			else
				bottom = itemCfg.ItemName..'\n'
			end
		elseif award[0] == awardType.award then
			local awardCfg = TableUtil.GetAwardTable().GetRowByAwardId(award[1])
			if awardCfg.PackIds then
				for i=0,awardCfg.PackIds.Count-1 do
					packageID = awardCfg.PackIds[i]
					local groupContent = TableUtil.GetAwardPackTable().GetRowByPackId(packageID).GroupContent
					for j = 0,groupContent.Count-1 do
						local itemPair = groupContent[j]
						local tempItemCfg = TableUtil.GetItemTable().GetRowByItemID(itemPair[0])
						local tempStr = StringEx.Format("- [{0}] * {1}\n",tempItemCfg.ItemName,itemPair[1])
						if itemPair[0] == splitID then
							top = top ..tempStr
						else
							bottom = bottom ..tempStr
						end
					end
				end
			end
		end
		if top ~= "" then
			top = StringEx.Format(Common.Utils.Lang("Payment_Item_Tip"), top)
		end
		if bottom ~= "" then
			bottom = StringEx.Format(Common.Utils.Lang("Payment_Item_Tip02"), bottom)
		end
		top = top..bottom..self.paymentCfg.Text
	end
	self.panel.Commodities.LabText = top
end

function PaymentInstructionsCtrl:_setMonthCardInfo()
	self.panel.Recharge:SetActiveEx(false)
	self.panel.MonthCard:SetActiveEx(true)
	if MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.PaymentTips) then
		self.panel.Blank:SetActiveEx(false)
		self.panel.PaymentTipRoot:SetActiveEx(true)
		self.panel.InstructionContent.LabText = Common.Utils.Lang("Refund_Instructions_Tip")
	else
		self.panel.Blank:SetActiveEx(true)		-- 占位，美化UI
		self.panel.PaymentTipRoot:SetActiveEx(false)
	end

	self.panel.CommodityName.LabText = self.rechargeTableCfg.Name
	self.panel.CommodityIcon:SetSprite(self.rechargeTableCfg.Atlas,self.rechargeTableCfg.Icon, true)
	local l_PayKey = ""
	if self.paymentCfg.ProductType == l_mgr.ProductType_TYPE.CommonMonthCard then
		l_PayKey = "CommonCardPay"
	end
	if self.paymentCfg.ProductType == l_mgr.ProductType_TYPE.SuperMonthCard then
		l_PayKey = "SuperCardPay"
	end
	local l_payMentId = game:GetPayMgr():GetRealProductId(l_PayKey)
	if l_payMentId then
		self.panel.Money.LabText = game:GetPayMgr():GetPaymentCurrencyFormatByProductId(l_payMentId)
	end
	--self.panel.Money.LabText = game:GetPayMgr():GetPaymentCurrencyFormatByProductId(self.rechargeTableCfg.PaymentID)
	self.panel.NumImmediately.LabText = self.immediatiatelyNum
	self.panel.NumEveryday.LabText = self.everydayNum
	self.panel.MonthCardTip.LabText =  Lang("REBATE_CARD_YES_NO_TIPS", self.totalDay)
end

function PaymentInstructionsCtrl:_onBtnConfirm()
	self:OnPayConfirm()
	UIMgr:DeActiveUI(UI.CtrlNames.PaymentInstructions)
end

function PaymentInstructionsCtrl:_onBtnCancel()
	if self.cancel and self.activeTable then
		self.cancel(self.activeTable)
	end
	UIMgr:DeActiveUI(UI.CtrlNames.PaymentInstructions)
end

function PaymentInstructionsCtrl:_onBtnInstruction()
    Application.OpenURL(TableUtil.GetGlobalTable().GetRowByName("RefundInstructionsURL").Value)
end

function PaymentInstructionsCtrl:_getRechargeCfgByProductID(productID)
	local size = TableUtil.GetRechargeTable().GetTableSize()
	for i=1,size do
		if TableUtil.GetRechargeTable().GetRow(i).PaymentID == productID then
			return TableUtil.GetRechargeTable().GetRow(i)
		end
	end
	return nil
end

function PaymentInstructionsCtrl:OnPayConfirm()
	if self.paymentCfg.ProductType == MgrMgr:GetMgr("MallMgr").ProductType_TYPE.Recharge then
		 if self.confirm and self.activeTable then
		 	self.confirm(self.activeTable,self.rechargeTableCfg.PaymentID)
		 end
	elseif self.paymentCfg.ProductType == MgrMgr:GetMgr("MallMgr").ProductType_TYPE.ActiveMonthCard
		or self.paymentCfg.ProductType == MgrMgr:GetMgr("MallMgr").ProductType_TYPE.CommonMonthCard
		or self.paymentCfg.ProductType == MgrMgr:GetMgr("MallMgr").ProductType_TYPE.SuperMonthCard then
		l_rebateMgr.BuyRebateCardByType(self.paymentCfg.ProductType)
	end
end

--lua custom scripts end
return PaymentInstructionsCtrl