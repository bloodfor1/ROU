--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/TradeDialogPanel"


--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
TradeDialogCtrl = class("TradeDialogCtrl", super)
--lua class define end

--lua functions
function TradeDialogCtrl:ctor()

	super.ctor(self, CtrlNames.TradeDialog, UILayer.Function, nil, ActiveType.Standalone)
	--self:SetParent(UI.CtrlNames.Sweater)

	self.InsertPanelName=UI.CtrlNames.Sweater

end --func end
--next--
function TradeDialogCtrl:Init()

	self.panel = UI.TradeDialogPanel.Bind(self)
	super.Init(self)

end --func end
--next--
function TradeDialogCtrl:Uninit()

	super.Uninit(self)
	self.panel = nil

end --func end
--next--
function TradeDialogCtrl:OnActive()


end --func end
--next--
function TradeDialogCtrl:OnDeActive()


end --func end
--next--
function TradeDialogCtrl:Update()


end --func end



--next--
function TradeDialogCtrl:BindEvents()

	--dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts
function TradeDialogCtrl:Reset()
	self.panel.dialog1.gameObject:SetActiveEx(false)
	self.panel.dialog2.gameObject:SetActiveEx(false)
	self.panel.dialog3.gameObject:SetActiveEx(false)
	self.panel.BtnOK.gameObject:SetActiveEx(false)
	self.panel.BtnYes.gameObject:SetActiveEx(false)
	self.panel.BtnNo.gameObject:SetActiveEx(false)
end

function TradeDialogCtrl:ShowNoMoneyTradeDialog(count,sureFunc,cancelFunc)
	self:Reset()

	self.panel.dialog1.gameObject:SetActiveEx(true)
	local l_lab = MLuaClientHelper.GetOrCreateMLuaUICom(self.panel.dialog1.gameObject.transform:Find("tpl/Text (1)").gameObject)
	l_lab.LabText = tostring(count)
	self.panel.BtnYes.gameObject:SetActiveEx(true)
	self.panel.BtnNo.gameObject:SetActiveEx(true)
	self.panel.BtnYes:AddClick(function ()
		if sureFunc then
			sureFunc()
		end
	end)
	self.panel.BtnNo:AddClick(function ()
		if cancelFunc then
			cancelFunc()
		end
	end)
end

function TradeDialogCtrl:ShowDoubleTradeDialog(des,number,sureFunc,cancelFunc)
	self:Reset()

	self.panel.dialog2.gameObject:SetActiveEx(true)
		self.panel.BtnYes.gameObject:SetActiveEx(true)
		self.panel.BtnNo.gameObject:SetActiveEx(true)
		self.panel.doubleLab.LabText =des
		self.panel.roNumLab.LabText =number
		self.panel.BtnYes:AddClick(function ()
			if sureFunc then
				sureFunc()
			end
		end)
		self.panel.BtnNo:AddClick(function ()
			if cancelFunc then
				cancelFunc()
			end
		end)
end

function TradeDialogCtrl:ShowDropStopTradeDialog(des,sureFunc,cancelFunc)
	self:Reset()

	self.panel.dialog3.gameObject:SetActiveEx(true)
		self.panel.BtnYes.gameObject:SetActiveEx(true)
		self.panel.BtnNo.gameObject:SetActiveEx(true)
		self.panel.TxtMsg.LabText = des
		self.panel.Toggle.Tog.isOn = true
		self.panel.BtnYes:AddClick(function ()
			if self.panel.Toggle.Tog.isOn then
				MgrMgr:GetMgr("TradeMgr").g_noticeDisable = true
			end
			if sureFunc then
				sureFunc()
			end
		end)
		self.panel.BtnNo:AddClick(function ()
			if cancelFunc then
				cancelFunc()
			end
		end)
end
--lua custom scripts end
