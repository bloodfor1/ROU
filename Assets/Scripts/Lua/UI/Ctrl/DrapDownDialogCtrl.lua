--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/DrapDownDialogPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
DrapDownDialogCtrl = class("DrapDownDialogCtrl", super)
--lua class define end

--lua functions
function DrapDownDialogCtrl:ctor()

    super.ctor(self, CtrlNames.DrapDownDialog, UILayer.Tips, UITweenType.UpAlpha, ActiveType.Standalone)
    self.cacheGrade = EUICacheLv.VeryLow
    self.dlgType = CommonUI.Dialog.DialogType.OK
    self.title = ""
    self.optionTable = {}
    self.autoHide = true
    self.dlgTxtConfirm = "Yes"
    self.dlgTxtCancel = "No"
    self.onConfirm = nil
    self.onCancel = nil

end --func end
--next--
function DrapDownDialogCtrl:Init()

    self.panel = UI.DrapDownDialogPanel.Bind(self)
    super.Init(self)
    self.panel.BtnYesCenter:AddClick(function()
        if self.onConfirm ~= nil then
            self.onConfirm(self:_getCurrentDropDownText())
        end
        if self.autoHide then
            UIMgr:DeActiveUI(self.name)
        end
    end)
    self.panel.BtnYes:AddClick(function()
        if self.onConfirm ~= nil then
            self.onConfirm(self:_getCurrentDropDownText())
        end
        if self.autoHide then
            UIMgr:DeActiveUI(self.name)
        end
    end)
    self.panel.BtnNo:AddClick(function()
        if self.onCancel ~= nil then
            self.onCancel(self:_getCurrentDropDownText())
        end
        if self.autoHide then
            UIMgr:DeActiveUI(self.name)
        end
    end)

end --func end
--next--
function DrapDownDialogCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function DrapDownDialogCtrl:OnActive()

    self.panel.BtnYesCenter.gameObject:SetActiveEx(self.dlgType == CommonUI.Dialog.DialogType.OK)
    self.panel.BtnYes.gameObject:SetActiveEx(self.dlgType == CommonUI.Dialog.DialogType.YES_NO)
    self.panel.BtnNo.gameObject:SetActiveEx(self.dlgType == CommonUI.Dialog.DialogType.YES_NO)
    self.panel.Title.LabText = self.title
    self.panel.Dropdown.DropDown.options:Clear()
    self.panel.Dropdown:SetDropdownOptions(self.optionTable)
    self.panel.TxtYesCenter.LabText = self.dlgTxtConfirm
    self.panel.TxtYes.LabText = self.dlgTxtConfirm
    self.panel.TxtNo.LabText = self.dlgTxtCancel
    
end --func end
--next--
function DrapDownDialogCtrl:OnDeActive()


end --func end
--next--
function DrapDownDialogCtrl:Update()


end --func end


--next--
function DrapDownDialogCtrl:BindEvents()

    --dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts
function DrapDownDialogCtrl:_getCurrentDropDownText()
    local text=""
    local currentIndex=self.panel.Dropdown.DropDown.value
    if currentIndex == nil or currentIndex<0 then
        return text
    end
    local dropDownOptionsCount=self.panel.Dropdown.DropDown.options.Count
    if dropDownOptionsCount<=0 then
        return text
    end
    if dropDownOptionsCount <= currentIndex then
        return text
    end
    local currentOptions=self.panel.Dropdown.DropDown.options[currentIndex]
    return currentOptions.text
end

function DrapDownDialogCtrl:SetDlgInfo(dlgType, autoHide, title, optionTable, txtConfirm, txtCancel, onConfirm, onCancel)
    self.dlgType = dlgType
    self.autoHide = autoHide
    self.title = title or ""
    self.optionTable = optionTable
    self.dlgTxtConfirm = txtConfirm
    self.dlgTxtCancel = txtCancel
    self.onConfirm = onConfirm
    self.onCancel = onCancel
end
--lua custom scripts end
