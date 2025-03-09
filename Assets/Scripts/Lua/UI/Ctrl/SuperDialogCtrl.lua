--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/SuperDialogPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
SuperDialogCtrl = class("SuperDialogCtrl", super)
--lua class define end

--lua functions
function SuperDialogCtrl:ctor()

	super.ctor(self, CtrlNames.SuperDialog, UILayer.Tips, UITweenType.UpAlpha, ActiveType.Standalone)

end --func end
--next--
function SuperDialogCtrl:Init()

	self.panel = UI.SuperDialogPanel.Bind(self)
	super.Init(self)

end --func end
--next--
function SuperDialogCtrl:Uninit()

	self.onConfirm = nil
	self.onCancel = nil

	super.Uninit(self)
	self.panel = nil
end --func end
--next--
function SuperDialogCtrl:OnActive()


end --func end
--next--
function SuperDialogCtrl:OnDeActive()


end --func end
--next--
function SuperDialogCtrl:Update()


end --func end



--next--
function SuperDialogCtrl:BindEvents()

	--dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts

function SuperDialogCtrl:InitClick()
	self.panel.BtnOK:AddClick(function()
		if self.onConfirm ~= nil then
			self.onConfirm()
			self.onConfirm = nil
		end
		UIMgr:DeActiveUI(self.name)
	end)
	self.panel.BtnYes:AddClick(function()
		if self.onConfirm ~= nil then
			self.onConfirm()
			self.onConfirm = nil
		end
		UIMgr:DeActiveUI(self.name)
	end)
	self.panel.BtnNo:AddClick(function()
		if self.onCancel ~= nil then
			self.onCancel()
			self.onCancel = nil
		end
		UIMgr:DeActiveUI(self.name)
	end)
end

function SuperDialogCtrl:ShowOK(onConfirm,text)
	self.onConfirm = onConfirm
	self.onCancel = nil
	self:InitClick()
	self.panel.TxtMsg.LabText = text
	self.panel.BtnYes.gameObject:SetActiveEx(false)
	self.panel.BtnNo.gameObject:SetActiveEx(false)
	self.panel.BtnOK.gameObject:SetActiveEx(true)
end

function SuperDialogCtrl:ShowYesNo(onConfirm,onCancel,text)
	self.onConfirm = onConfirm
	self.onCancel = onCancel
	self:InitClick()
	self.panel.TxtMsg.LabText = text
	self.panel.BtnYes.gameObject:SetActiveEx(true)
	self.panel.BtnNo.gameObject:SetActiveEx(true)
	self.panel.BtnOK.gameObject:SetActiveEx(false)
end

--StringEx.Format(Common.Utils.Lang("RICH_IMAGE"),tostring(l_itemInfo.ItemIcon),tostring(l_itemInfo.ItemAtlas),20,1))


--lua custom scripts end
