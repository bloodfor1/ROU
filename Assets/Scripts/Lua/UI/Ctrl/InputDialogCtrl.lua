--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/InputDialogPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
InputDialogCtrl = class("InputDialogCtrl", super)
--lua class define end

--lua functions
function InputDialogCtrl:ctor()

    super.ctor(self, CtrlNames.InputDialog, UILayer.Tips, UITweenType.Up, ActiveType.Standalone)
    self.cacheGrade = EUICacheLv.VeryLow
    self.dlgType = CommonUI.Dialog.DialogType.OK
    self.title = ""
    self.autoHide = true
    self.dlgTxtConfirm = "Yes"
    self.dlgTxtCancel = "No"
    self.dlgPlaceHolder = ""
    self.onConfirm = nil
    self.onCancel = nil

end --func end
--next--
function InputDialogCtrl:Init()

    self.panel = UI.InputDialogPanel.Bind(self)
    super.Init(self)
    self.panel.BtnYesCenter:AddClick(function()
        if self.onConfirm ~= nil then
            self.onConfirm(self.panel.InputMessage.Input.text)
        end
        if self.autoHide then
            UIMgr:DeActiveUI(self.name)
        end
    end)
    self.panel.BtnYes:AddClick(function()
        if self.onConfirm ~= nil then
            self.onConfirm(self.panel.InputMessage.Input.text)
        end
        if self.autoHide then
            UIMgr:DeActiveUI(self.name)
        end
    end)
    self.panel.BtnNo:AddClick(function()
        if self.onCancel ~= nil then
            self.onCancel(self.panel.InputMessage.Input.text)
        end
        if self.autoHide then
            UIMgr:DeActiveUI(self.name)
        end
    end)
    self.panel.InputMessage:OnInputFieldChange(function(text)
        text = StringEx.DeleteEmoji(text)
        if text ~= self.panel.InputMessage.Input.text then
            self.panel.InputMessage.Input.text=text
        end
    end)

end --func end
--next--
function InputDialogCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function InputDialogCtrl:OnActive()

    self.panel.InputMessage.Input.text=""

    self.panel.BtnYesCenter.gameObject:SetActiveEx(self.dlgType == CommonUI.Dialog.DialogType.OK)
    self.panel.BtnYes.gameObject:SetActiveEx(self.dlgType == CommonUI.Dialog.DialogType.YES_NO)
    self.panel.BtnNo.gameObject:SetActiveEx(self.dlgType == CommonUI.Dialog.DialogType.YES_NO)
    self.panel.Title.LabText = self.title
    self.panel.TxtPlaceholder.LabText = self.dlgPlaceHolder or ""
    self.panel.TxtYesCenter.LabText = self.dlgTxtConfirm
    self.panel.TxtYes.LabText = self.dlgTxtConfirm
    self.panel.TxtNo.LabText = self.dlgTxtCancel

end --func end
--next--
function InputDialogCtrl:OnDeActive()


end --func end
--next--
function InputDialogCtrl:Update()


end --func end


--next--
function InputDialogCtrl:BindEvents()

    --dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts
function InputDialogCtrl:SetDlgInfo(dlgType, autoHide, title, txtPlaceHolder, txtConfirm, txtCancel, onConfirm, onCancel)
    self.dlgType = dlgType
    self.autoHide = autoHide
    self.dlgPlaceHolder = txtPlaceHolder
    self.title = title or ""
    self.dlgTxtConfirm = txtConfirm
    self.dlgTxtCancel = txtCancel
    self.onConfirm = onConfirm
    self.onCancel = onCancel
end
--lua custom scripts end
