--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/DialogDeleteCharPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
DialogDeleteCharCtrl = class("DialogDeleteCharCtrl", super)
--lua class define end

--lua functions
function DialogDeleteCharCtrl:ctor()

    super.ctor(self, CtrlNames.DialogDeleteChar, UILayer.Function, nil, ActiveType.Standalone)

end --func end
--next--
function DialogDeleteCharCtrl:Init()
    self.panel = UI.DialogDeleteCharPanel.Bind(self)
    super.Init(self)
    self.panel.BtnYes:AddClick(function()
        self:OnClickYes()
    end)

    self.panel.BtnNo:AddClick(function()
        self:OnClickNo()
    end)

    self.panel.InputMessage:OnInputFieldChange(function(value)
        value = StringEx.DeleteEmoji(value)
        self.panel.InputMessage.Input.text = value
    end)

    self.head2d = self:NewTemplate("HeadWrapTemplate", {
        TemplateParent = self.panel.Head.transform,
        TemplatePath = "UI/Prefabs/HeadWrapTemplate"
    })
end --func end
--next--
function DialogDeleteCharCtrl:Uninit()
    self.head2d = nil
    self.deleteTxt = nil
    self.uid = nil
    self.onConfirm = nil
    self.onCancel = nil
    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function DialogDeleteCharCtrl:OnActive()
    -- do nothing
end --func end
--next--
function DialogDeleteCharCtrl:OnDeActive()
    -- do nothing
end --func end
--next--
function DialogDeleteCharCtrl:Update()
    -- do nothing
end --func end
--next--
function DialogDeleteCharCtrl:BindEvents()
    -- do nothing
end --func end

--next--
--lua functions end

--lua custom scripts

function DialogDeleteCharCtrl:ShowDialog(roleInfo, description, onConfirm, onCancel, deleteTxt)
    self.uid = roleInfo.uid
    self.deleteTxt = deleteTxt
    self.onConfirm = onConfirm
    self.onCancel = onCancel
    self.panel.Name.LabText = Common.Utils.PlayerName(roleInfo.name)
    self.panel.Level.LabText = StringEx.Format("Lv.{0}", roleInfo.level)
    self.panel.Pro.LabText = DataMgr:GetData("TeamData").GetProfessionNameById(roleInfo.type) or ""
    self.panel.Description.LabText = CommonUI.Color.FormatWord(description)
    local equipData = MgrMgr:GetMgr("PlayerInfoMgr").GetEquipDataByRoleBriefInfo(roleInfo)
    ---@type HeadTemplateParam
    local param = {
        EquipData = equipData,
    }

    self.head2d:SetData(param)

    if deleteTxt then
        self.panel.InputMessage.gameObject:SetActiveEx(true)
        MLuaCommonHelper.SetRectTransformPosY(self.panel.dialog.gameObject, 33.2)
        MLuaCommonHelper.SetRectTransformPosY(self.panel.root.gameObject, 22)
        self.panel.TxtPlaceholder.LabText = deleteTxt
    else
        self.panel.InputMessage.gameObject:SetActiveEx(false)
        MLuaCommonHelper.SetRectTransformPosY(self.panel.dialog.gameObject, 10)
        MLuaCommonHelper.SetRectTransformPosY(self.panel.root.gameObject, 0)
    end
end

function DialogDeleteCharCtrl:OnClickYes()

    if self.deleteTxt then
        local l_finalTxt = StringEx.DeleteEmoji(self.panel.InputMessage.Input.text)
        if l_finalTxt ~= self.deleteTxt then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("DELETE_CHAR_CONDITION", self.deleteTxt))
            return
        end
    end

    local l_onConfirm = self.onConfirm
    local l_uid = self.uid

    UIMgr:DeActiveUI(self.name)

    if l_onConfirm then
        l_onConfirm(l_uid)
    end
end

function DialogDeleteCharCtrl:OnClickNo()

    local l_onCancle = self.onCancel

    UIMgr:DeActiveUI(self.name)

    if l_onCancle then
        l_onCancle()
    end
end


--lua custom scripts end
return DialogDeleteCharCtrl