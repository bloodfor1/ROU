--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/InnerTestAgreementDialogPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
InnerTestAgreementDialogCtrl = class("InnerTestAgreementDialogCtrl", super)
--lua class define end

--lua functions
function InnerTestAgreementDialogCtrl:ctor()
	
	super.ctor(self, CtrlNames.InnerTestAgreementDialog, UILayer.Normal, nil, ActiveType.Normal)
	
end --func end
--next--
function InnerTestAgreementDialogCtrl:Init()
	
	self.panel = UI.InnerTestAgreementDialogPanel.Bind(self)
	super.Init(self)
	
end --func end
--next--
function InnerTestAgreementDialogCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function InnerTestAgreementDialogCtrl:OnActive()
	
	self.panel.BtnYes:AddClick(function()
		DataMgr:GetData("AuthData").SetInnerTestAgreementProto("agree")
		UIMgr:DeActiveUI(CtrlNames.InnerTestAgreementDialog)
	end)
	self.panel.BtnNo:AddClick(function()
		DataMgr:GetData("AuthData").SetInnerTestAgreementProto("none")
		UIMgr:DeActiveUI(CtrlNames.InnerTestAgreementDialog)
	end)
	
end --func end
--next--
function InnerTestAgreementDialogCtrl:OnDeActive()
	
	
end --func end
--next--
function InnerTestAgreementDialogCtrl:Update()
	
	
end --func end
--next--
function InnerTestAgreementDialogCtrl:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return InnerTestAgreementDialogCtrl