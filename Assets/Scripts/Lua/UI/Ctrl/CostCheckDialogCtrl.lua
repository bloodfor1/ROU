--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/CostCheckDialogPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
CostCheckDialogCtrl = class("CostCheckDialogCtrl", super)
--lua class define end

--lua functions
function CostCheckDialogCtrl:ctor()

    super.ctor(self, CtrlNames.CostCheckDialog, UILayer.Tips, nil, ActiveType.Standalone)

    self:InitParameter()

end --func end
--next--
function CostCheckDialogCtrl:Init()

    self.panel = UI.CostCheckDialogPanel.Bind(self)
    super.Init(self)

    self.panel.BtnYes:AddClick(function()
        if self.onConfirm ~= nil then
            self.onConfirm()
        end

        if self.autoHide then
            UIMgr:DeActiveUI(self.name)
        end
    end)
    self.panel.BtnNo:AddClick(function()
        if self.onCancel ~= nil then
            self.onCancel()
        end

        if self.autoHide then
            UIMgr:DeActiveUI(self.name)
        end
    end)

end --func end
--next--
function CostCheckDialogCtrl:Uninit()

    self:InitParameter()

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function CostCheckDialogCtrl:OnActive()

    self.panel.Title.LabText = self.title
    self.panel.CostDetail.LabText = self.costTxt
    self.panel.HaveDetail.LabText = self.haveTxt
    self.panel.TxtYes.LabText = self.dlgTxtConfirm
    self.panel.TxtNo.LabText = self.dlgTxtCancel
    self.activeTime = Time.realtimeSinceStartup
    if self.needPayConfirm and MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.PaymentTips) then
        local paymentTips = self:NewTemplate("PaymentInstructionsTemplate",
                {
                    TemplateInstanceGo = self.panel.PaymentInstructions.gameObject,
                    TemplateParent = self.panel.PaymentInstructions.transform.parent
                }
        )
        paymentTips:SetData({})
        self.panel.PaymentInstructions.gameObject:SetActiveEx(true)
    else
        self.panel.PaymentInstructions.gameObject:SetActiveEx(false)
    end

end --func end
--next--
function CostCheckDialogCtrl:OnDeActive()


end --func end
--next--
function CostCheckDialogCtrl:Update()

    if self.delayConfirm ~= nil and self.delayConfirm > 0 then
        local l_timeLeft = math.ceil(self.delayConfirm + self.activeTime - Time.realtimeSinceStartup)
        if l_timeLeft > 0 then
            if self.dlgType == CommonUI.Dialog.DialogType.YES_NO then
                self.panel.TxtYes.LabText = self.dlgTxtConfirm.."("..tostring(l_timeLeft).."s)"
            else
                self.panel.TxtOK.LabText = self.dlgTxtConfirm.."("..tostring(l_timeLeft).."s)"
            end
        else
            if self.onConfirm ~= nil then
                self.onConfirm()
            end
            UIMgr:DeActiveUI(self.name)
        end
    end

end --func end





--next--
function CostCheckDialogCtrl:BindEvents()


end --func end

--next--
--lua functions end

--lua custom scripts
--初始化参数
function CostCheckDialogCtrl:InitParameter()
    self.autoHide = true
    self.delayConfirm = -1
    self.title = ""
    self.costTxt = ""
    self.haveTxt = ""
    self.dlgTxtConfirm = Lang("DLG_BTN_YES")
    self.dlgTxtCancel = Lang("DLG_BTN_NO")
    self.onConfirm = nil
    self.onCancel = nil
    self.activeTime = -1
    self.needPayConfirm = nil
end

--设置对话框参数
function CostCheckDialogCtrl:SetDlgInfo(autoHide, title, costTxt, haveTxt, onConfirm, onCancel, delayConfirm,needPayConfirm)
    self.autoHide = autoHide
    self.title = title or ""
    self.costTxt = costTxt
    self.haveTxt = haveTxt
    self.onConfirm = onConfirm
    self.onCancel = onCancel
    self.delayConfirm = delayConfirm
    self.needPayConfirm = needPayConfirm
end
--lua custom scripts end
