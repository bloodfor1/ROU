--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/DialogPanel"


--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
DialogCtrl = class("DialogCtrl", super)
--lua class define end

local l_default_alignment_horizontal = UnityEngine.TextAnchor.MiddleCenter

--lua functions
function DialogCtrl:ctor()

    super.ctor(self, CtrlNames.Dialog, UILayer.Tips, UITweenType.UpAlpha, ActiveType.Standalone)
    self.cacheGrade = EUICacheLv.VeryLow
    self.dlgType = CommonUI.Dialog.DialogType.OK
    self.autoHide = true
    self.delayConfirm = -1
    self.title = Lang("TIP")
    self.dlgTxt = ""
    self.dlgTxtConfirm = "Yes"
    self.dlgTxtCancel = "No"
    self.onConfirm = nil
    self.onCancel = nil
    self.activeTime = -1
    --勾选框 类型  0无勾选框  1不再提示(本次登录)  2今日不再提示  3双向不再提示(勾选后无论确定还是取消都会记录操作)
    self.togType = 0
    --不再提示的key值
    self.showHideTogName = nil
    --勾选框的勾选情况
    self.selectNeverShow = false
    self.customUpdateFuncs = {}

    CommonUI.Dialog.DontShowTable = {}

    self.dialogContentQueue = Common.queue.create()

    self.anchor = UnityEngine.TextAnchor.MiddleCenter

    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor = BlockColor.Dark


end --func end
--next--
function DialogCtrl:Init()

    self.panel = UI.DialogPanel.Bind(self)
    super.Init(self)
    --设置遮罩
    --self:SetBlockOpt(BlockColor.Dark)

    self.panel.BtnOK:AddClick(function()
        if self.onConfirm ~= nil then
            self.onConfirm()
        end
        --单按钮对话框 不再提示勾选相关逻辑  只有 1和2、4 类型
        if self.selectNeverShow and self.showHideTogName ~= nil then
            if self.togType == 1 then
                CommonUI.Dialog.DontShowTable[self.showHideTogName] = true
            elseif self.togType == 2 or self.togType == 4 then
                local l_dateStr = tostring(os.date("!%Y%m%d", Common.TimeMgr.GetLocalNowTimestamp()))
                UserDataManager.SetDataFromLua(self.showHideTogName, MPlayerSetting.PLAYER_SETTING_GROUP, l_dateStr)
            end
        end
        if self.autoHide then
            self:TryCloseUI()
        end
    end)

    self.panel.BtnYes:AddClick(function()

        self:onBtnYes()

    end)
    self.panel.BtnNo:AddClick(function()
        local l_togType = self.togType
        local l_selectNeverShow = self.selectNeverShow
        local l_showHideTogName = self.showHideTogName
        local l_onCancel = self.onCancel
        if self.autoHide then
            self:TryCloseUI()
        end

        if l_onCancel ~= nil then
            l_onCancel()
        end
        --双按钮对话框 只有类型3 记录取消操作
        if l_togType == 3 and l_selectNeverShow and l_showHideTogName ~= nil then
            CommonUI.Dialog.DontShowTable[l_showHideTogName] = false
        end
    end)
    self.panel.BtnPraise:AddClick(function()
        if self.onConfirm ~= nil then
            self.onConfirm()
        end
        if self.autoHide then
            self:TryCloseUI()
        end
    end)
    self.panel.TogHide:OnToggleChanged(function(on)
        self.selectNeverShow = on
    end)
end --func end
--next--
function DialogCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function DialogCtrl:OnActive()
    self.panel.TxtMsg.LabRayCastTarget = true -- prefab上点击一键标准化 会使得 Raycast Target 为 false
    self.panel.BtnYes:SetGray(false)
    if self.uiPanelData then
        local data = self.uiPanelData
        self:SetTextAnchor(data.anchor)
        self:SetDlgInfo(data.dlgType, data.autoHide, data.title, data.txt, data.txtConfirm, data.txtCancel, data.onConfirm,
                data.onCancel, data.delayConfirm, data.togType, data.showHideTogName, data.activeCallback, data.allowRepeat, data.extraData, data.inputStr)
    end
    self:UpdateUI()
end --func end
--next--
function DialogCtrl:OnDeActive()
    self:SetOverrideSortLayer() --还原dialog的层级
    self:RemoveData()
    self:ResetArgs()
end --func end
--next--
function DialogCtrl:Update()

    if self.delayConfirm ~= nil and self.delayConfirm > 0 then
        local l_timeLeft = math.ceil(self.delayConfirm + self.activeTime - Time.realtimeSinceStartup)
        if l_timeLeft > 0 then
            if self.dlgType == CommonUI.Dialog.DialogType.YES_NO then
                self.panel.TxtYes.LabText = self.dlgTxtConfirm .. "(" .. tostring(l_timeLeft) .. "s)"
            else
                self.panel.TxtOK.LabText = self.dlgTxtConfirm .. "(" .. tostring(l_timeLeft) .. "s)"
            end
        else
            if self.onConfirm ~= nil then
                self.onConfirm()
            end
            self:TryCloseUI()
        end
    end

    for _, func in ipairs(self.customUpdateFuncs) do
        func(self)
    end
end --func end
--next--
function DialogCtrl:BindEvents()
    self:BindEvent(GlobalEventBus, EventConst.Names.SetYesNoDlgBtnGray, function(_self, btnName, status)
        if btnName and btnName == "confirm" and self.panel.BtnYes.gameObject.activeSelf then
            self.panel.BtnYes:SetGray(status)
        end
    end)
    --如果是点赞界面 添加请求确认是否是好友的事件回调
    self:BindEvent(MgrMgr:GetMgr("TeamMgr").EventDispatcher, DataMgr:GetData("TeamData").ON_GET_PLAYER_TEAM_FRIEND_INFO, function(self, teamFriendInfo, targetId)
        if teamFriendInfo.is_friend then
            UIMgr:DeActiveUI(self.name)
        else
            self.panel.BtnPraise.gameObject:SetActiveEx(false)
            self.panel.BtnYes.gameObject:SetActiveEx(true)
            self.panel.TxtMsg.LabText = Common.Utils.Lang("ADD_FRIEND_OR_NOT")
            self.panel.TxtYes.LabText = Common.Utils.Lang("DLG_BTN_YES")
            self.onConfirm = function()
                MgrMgr:GetMgr("FriendMgr").RequestAddFriend(targetId)
                UIMgr:DeActiveUI(self.name)
            end
        end
    end)
end --func end
--next--
--lua functions end

--lua custom scripts
-- confirm used for YES or OK
-- cancel used for NO

function DialogCtrl:SetDlgInfo(
        dlgType, autoHide, title, txt, txtConfirm, txtCancel, onConfirm, onCancel, delayConfirm, togType, showHideTogName, activeCallback, allowRepeat, extraData, inputStr)
    if allowRepeat == nil then
        allowRepeat = false
    end

    if not allowRepeat then
        --相同内容不允许反复压栈
        if self.dlgTxt == txt then
            return
        end
    end

    local l_newDlgInfo = {
        dlgType = dlgType,
        autoHide = autoHide,
        title = title or Lang("TIP"),
        dlgTxt = txt,
        dlgTxtConfirm = txtConfirm,
        dlgTxtCancel = txtCancel,
        onConfirm = onConfirm,
        onCancel = onCancel,
        delayConfirm = delayConfirm,
        togType = togType or 0,
        showHideTogName = showHideTogName,
        activeCallback = activeCallback,
        allowRepeat = allowRepeat,
        extraData = extraData,
        inputStr = inputStr
    }

    if not allowRepeat then
        local l_queue = self.dialogContentQueue:enumerate()
        --Dialog内容完全一致则返回，防止连续打开的情况
        for _, v in pairs(l_queue) do
            if v.dlgTxt == l_newDlgInfo.dlgTxt then
                return
            end
        end
    end

    self.dialogContentQueue:enqueue(l_newDlgInfo)
end

function DialogCtrl:UpdateUI()
    if self.dialogContentQueue:isEmpty() then
        self:TryCloseUI()
        return
    end

    self:RemoveData()

    --持续出栈，直到找到内容不一样的对话
    local l_currentDlgInfo = self.dialogContentQueue:dequeue()
    if not l_currentDlgInfo.allowRepeat then
        while self.dlgTxt == l_currentDlgInfo.dlgTxt do
            if self.dialogContentQueue:isEmpty() then
                self:TryCloseUI()
                return
            end
            l_currentDlgInfo = self.dialogContentQueue:dequeue()
        end
    end

    self.dlgType = l_currentDlgInfo.dlgType
    self.autoHide = l_currentDlgInfo.autoHide
    self.title = l_currentDlgInfo.title
    self.dlgTxt = l_currentDlgInfo.dlgTxt
    self.dlgTxtConfirm = l_currentDlgInfo.dlgTxtConfirm
    self.dlgTxtCancel = l_currentDlgInfo.dlgTxtCancel
    self.onConfirm = l_currentDlgInfo.onConfirm
    self.onCancel = l_currentDlgInfo.onCancel
    self.delayConfirm = l_currentDlgInfo.delayConfirm
    self.togType = l_currentDlgInfo.togType
    self.showHideTogName = l_currentDlgInfo.showHideTogName
    self.activeCallback = l_currentDlgInfo.activeCallback
    self.inputStr = l_currentDlgInfo.inputStr
    self:handleExtraData(l_currentDlgInfo.extraData)

    self.panel.BtnOK.gameObject:SetActiveEx(self.dlgType == CommonUI.Dialog.DialogType.OK)
    self.panel.BtnYes.gameObject:SetActiveEx(self.dlgType == CommonUI.Dialog.DialogType.YES_NO or self.dlgType == CommonUI.Dialog.DialogType.PaymentConfirm)
    self.panel.BtnNo.gameObject:SetActiveEx(self.dlgType == CommonUI.Dialog.DialogType.YES_NO or self.dlgType == CommonUI.Dialog.DialogType.PRAISE or self.dlgType == CommonUI.Dialog.DialogType.PaymentConfirm) --点赞时也要显示
    self.panel.BtnPraise.gameObject:SetActiveEx(self.dlgType == CommonUI.Dialog.DialogType.PRAISE)
    self.panel.Title.LabText = self.title
    self.panel.TxtMsg.LabText = self.dlgTxt
    self.panel.TxtMsg:GetRichText().alignment = self.anchor
    self.panel.TxtOK.LabText = self.dlgTxtConfirm
    self.panel.TxtYes.LabText = self.dlgTxtConfirm
    self.panel.TxtNo.LabText = self.dlgTxtCancel
    self.panel.InputMessage:SetActiveEx(nil ~= self.inputStr)
    self.panel.TextInputDesc:SetActiveEx(false)
    if nil ~= self.inputStr then
        -- self.panel.TextInputDesc.LabText = Common.Utils.Lang("C_INPUT_BEFORE_CONFIRM", tostring(self.inputStr))
        self.panel.InputMessage.Input.text = ""
        self.panel.TxtPlaceholder.LabText = tostring(self.inputStr)
    end

    --不再显示相关
    self.panel.TogHide.Tog.isOn = false
    if self.togType == 2 then
        self.panel.TogLab.LabText = Lang("TODAY_NOT_SHOW")
    else
        self.panel.TogLab.LabText = Lang("NOT_SHOW")
    end

    self.panel.TogHide.UObj:SetActiveEx(self.togType > 0 and self.showHideTogName ~= nil)
    self.activeTime = Time.realtimeSinceStartup
    if self.activeCallback ~= nil then
        self.activeCallback(self)
    end

    if self.dlgType == CommonUI.Dialog.DialogType.PaymentConfirm and MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.PaymentTips) then
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

end

function DialogCtrl:SetTextAnchor(Anchor)
    --self.panel.TxtMsg:GetRichText().alignment = Anchor
    self.anchor = (Anchor or UnityEngine.TextAnchor.MiddleCenter)
end

function DialogCtrl:RemoveData()
    self.panel.TxtMsg:GetRichText().alignment = l_default_alignment_horizontal
    self.customUpdateFuncs = {}
end

function DialogCtrl:SetAlignmentHorizontal(alignment)

    if not alignment then
        self.panel.TxtMsg:GetRichText().alignment = l_default_alignment_horizontal
    else
        self.panel.TxtMsg:GetRichText().alignment = alignment
    end
end

function DialogCtrl:SetText(text)
    self.panel.TxtMsg.LabText = text
end

function DialogCtrl:AddCustomUpdateFuncs(func)
    if type(func) ~= "function" then
        return
    end

    self.customUpdateFuncs[#self.customUpdateFuncs + 1] = func
end

function DialogCtrl:TryCloseUI()
    if self.dialogContentQueue:isEmpty() then
        UIMgr:DeActiveUI(self.name)
    else
        UIMgr:ActiveUI(self.name)
    end

end

function DialogCtrl:onBtnYes()
    if nil ~= self.inputStr then
        if self.panel.TextInputStr.LabText ~= self.inputStr then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("C_INVALID_INPUT"))
            return
        end
    end

    --在关闭之前先把数据进行缓存，以防关闭时把数据清了
    local l_onConfirm = self.onConfirm
    local l_selectNeverShow = self.selectNeverShow
    local l_showHideTogName = self.showHideTogName
    local l_togType = self.togType

    if self.autoHide then
        self:TryCloseUI()
    end

    if l_onConfirm ~= nil then
        l_onConfirm()
    end
    --双按钮对话框  不再提示勾选相关逻辑  有 1、2、3、4 类型
    if l_selectNeverShow and l_showHideTogName ~= nil then
        if l_togType == 1 or l_togType == 3 then
            CommonUI.Dialog.DontShowTable[l_showHideTogName] = true
        elseif l_togType == 2 or l_togType == 4 then
            local l_dateStr = tostring(os.date("!%Y%m%d", Common.TimeMgr.GetLocalNowTimestamp()))
            UserDataManager.SetDataFromLua(l_showHideTogName, MPlayerSetting.PLAYER_SETTING_GROUP, l_dateStr)
        end
    end
end

function DialogCtrl:ResetArgs()
    self.dlgType = nil
    self.autoHide = nil
    self.title = Lang("TIP")
    self.dlgTxt = ""
    self.dlgTxtConfirm = ""
    self.dlgTxtCancel = ""
    self.onConfirm = nil
    self.onCancel = nil
    self.delayConfirm = -1
    self.togType = 0
    self.showHideTogName = nil
    self.activeCallback = nil
    self.inputStr = nil
end

function DialogCtrl:handleExtraData(data)
    if data == nil then
        return
    end
    if data.imgClickInfos == nil then
        return
    end
    local l_dialogRichText = self:GetDialogRichText()
    if MLuaCommonHelper.IsNull(l_dialogRichText) then
        return
    end
    l_dialogRichText:ClearImgClickInfo()
    for i = 1, #data.imgClickInfos do
        local l_imgClickInfo = data.imgClickInfos[i]
        l_dialogRichText:AddImageClickFuncToDic(l_imgClickInfo.imgName, l_imgClickInfo.clickAction)
    end
end
function DialogCtrl:GetDialogRichText()
    if self.panel == nil then
        return
    end
    return self.panel.TxtMsg:GetRichText()
end
--lua custom scripts end
return DialogCtrl