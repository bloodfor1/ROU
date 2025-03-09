--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/ConsumeChooseDialogPanel"
require "UI/Template/ItemTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
ConsumeChooseDialogCtrl = class("ConsumeChooseDialogCtrl", super)
--lua class define end

--lua functions
function ConsumeChooseDialogCtrl:ctor()

    super.ctor(self, CtrlNames.ConsumeChooseDialog, UILayer.Tips, nil, ActiveType.Standalone)

end --func end
--next--
function ConsumeChooseDialogCtrl:Init()

    self.panel = UI.ConsumeChooseDialogPanel.Bind(self)
    super.Init(self)

    self.notEnoughId = 0
    --消耗品
    self.itemPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.ItemTemplate,
    })
    self.panel.BtnYes:AddClick(function()
        if self.onConfirm ~= nil then
            if not self.materialIsEnough then
                MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(self.notEnoughId, nil, nil, {
                    IsShowCloseButton = true
                })
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("ITEM_NOT_ENOUGH"))
                return
            end
            self.onConfirm()
        end
        UIMgr:DeActiveUI(UI.CtrlNames.ConsumeChooseDialog)
    end)
    self.panel.BtnNo:AddClick(function()
        if self.onCancel ~= nil then
            self.onCancel()
        end
        UIMgr:DeActiveUI(UI.CtrlNames.ConsumeChooseDialog)
    end)

end --func end
--next--
function ConsumeChooseDialogCtrl:Uninit()

    self.itemPool = nil
    self.onConfirm = nil
    self.onCancel = nil
    --确认二次弹窗
    self.delayConfirmEx = nil

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function ConsumeChooseDialogCtrl:OnActive()


end --func end
--next--
function ConsumeChooseDialogCtrl:OnDeActive()


end --func end
--next--
function ConsumeChooseDialogCtrl:Update()


end --func end





--next--
function ConsumeChooseDialogCtrl:BindEvents()

    --dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts
function ConsumeChooseDialogCtrl:SetDlgInfo(titleOne, titleTwo, onCancel, onConfirmOne, onConfirmTwo, consumeOne, consumeTwo, toggleOneText, toggleTwoText, titleText)
    self.panel.TxtMsg.LabText = titleOne
    self.onConfirm = onConfirmOne
    self.onCancel = onCancel
    self.panel.TxtTitle:SetActiveEx(titleText ~= nil)
    self.panel.TxtTitle.LabText = titleText
    if toggleOneText and toggleTwoText then
        self.panel.TogOneLab.LabText = toggleOneText
        self.panel.TogTwoLab.LabText = toggleTwoText
    else
        self.panel.TogPanel:SetActiveEx(false)
    end
    self.panel.ToggleOne:OnToggleChanged(function(value)
        if value then
            self.panel.TxtMsg.LabText = titleOne
            self.materialIsEnough = true
            for i = 1, #consumeOne do
                self:MaterialIsEnough(consumeOne[i])
            end
            self.itemPool:ShowTemplates({ Datas = consumeOne, Parent = self.panel.ItemParent.transform })
            self.onConfirm = onConfirmOne
        end
    end)
    self.panel.ToggleTwo:OnToggleChanged(function(value)
        if value then
            if titleTwo then
                self.panel.TxtMsg.LabText = titleTwo
            end
            self.materialIsEnough = true
            for i = 1, #consumeTwo do
                self:MaterialIsEnough(consumeTwo[i])
            end
            self.itemPool:ShowTemplates({ Datas = consumeTwo, Parent = self.panel.ItemParent.transform })
            self.onConfirm = onConfirmTwo
        end
    end)
    self.panel.ToggleOne.Tog.isOn = true
end

--判断材料是否足够
function ConsumeChooseDialogCtrl:MaterialIsEnough(data)
    local l_currentCount = 0
    local l_requireCount = 0
    if self.materialIsEnough then
        l_currentCount = Data.BagModel:GetCoinOrPropNumById(data.ID)
        l_requireCount = data.RequireCount
        if l_currentCount < l_requireCount then
            self.materialIsEnough = false
            self.notEnoughId = data.ID
        end
    end
end

--lua custom scripts end
