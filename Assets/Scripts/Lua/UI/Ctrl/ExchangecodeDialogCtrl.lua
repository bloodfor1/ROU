--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/ExchangecodeDialogPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
ExchangecodeDialogCtrl = class("ExchangecodeDialogCtrl", super)
local mgr = MgrMgr:GetMgr("ExchangecodeDialogMgr")
--lua class define end

--lua functions
function ExchangecodeDialogCtrl:ctor()
	
	super.ctor(self, CtrlNames.ExchangecodeDialog, UILayer.Function, nil, ActiveType.Standalone)
	
end --func end
--next--
function ExchangecodeDialogCtrl:Init()
	
	self.panel = UI.ExchangecodeDialogPanel.Bind(self)
	super.Init(self)

	self.panel.InputMessage:OnInputFieldChange(function(value)
		self:onInputFiledChange(value)
	end,true)

	self.panel.BtnYes:AddClick(function()
		self:onBtnConfirm()
	end)

	self.panel.BtnNo:AddClick(function ()
		UIMgr:DeActiveUI(UI.CtrlNames.ExchangecodeDialog)
	end)
	
end --func end
--next--
function ExchangecodeDialogCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function ExchangecodeDialogCtrl:OnActive()
	
	
end --func end
--next--
function ExchangecodeDialogCtrl:OnDeActive()
	
	
end --func end
--next--
function ExchangecodeDialogCtrl:Update()
	
	
end --func end
--next--
function ExchangecodeDialogCtrl:BindEvents()

	self:BindEvent(mgr.EventDispatcher, mgr.CDKEY_EXCHANGE_SUCCESS, self.onExchangeSuccess, self)

end --func end
--next--
--lua functions end

--lua custom scripts

function ExchangecodeDialogCtrl:onInputFiledChange(value)
	local tStr = string.gsub(value, "\r\n", "")
	tStr = string.gsub(tStr, "\n", "")
	tStr = string.gsub(tStr, " ", "")
	self.panel.InputMessage.Input.text =  string.upper(tStr)
end

function ExchangecodeDialogCtrl:onBtnConfirm()
	local codeLength = #self.panel.InputMessage.Input.text
	if codeLength == 0 then
		MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("PLEASE_ENTER_CDKEY"))
	else
		self:requireExchange(string.upper(self.panel.InputMessage.Input.text))
	end
end

function ExchangecodeDialogCtrl:requireExchange(code)
	local l_msgId = Network.Define.Rpc.CDKeyExchange
	---@type ExchangeCDKeyArg
	local l_sendInfo = GetProtoBufSendTable("ExchangeCDKeyArg")
	l_sendInfo.cdk_value  = code
	Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function ExchangecodeDialogCtrl:onExchangeSuccess()
	MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("CDKEY_EXCHANGE_SUCCESS"))
end

--lua custom scripts end
return ExchangecodeDialogCtrl