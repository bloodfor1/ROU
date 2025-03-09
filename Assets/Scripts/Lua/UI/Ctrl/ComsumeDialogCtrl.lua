--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/ComsumeDialogPanel"
require "UI/Template/ItemTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
ComsumeDialogCtrl = class("ComsumeDialogCtrl", super)
--lua class define end

--lua functions
function ComsumeDialogCtrl:ctor()

    super.ctor(self, CtrlNames.ComsumeDialog, UILayer.Tips, nil, ActiveType.Standalone)

    --勾选框 类型  0无勾选框  1不再提示(本次登录)  2今日不再提示  3双向不再提示(勾选后无论确定还是取消都会记录操作)
    self.togType = 0
    --不再提示的key值
    self.showHideTogName = nil
    --勾选框的勾选情况
    self.selectNeverShow = false

end --func end
--next--
function ComsumeDialogCtrl:Init()

    self.panel = UI.ComsumeDialogPanel.Bind(self)
    super.Init(self)

    self.notEnoughId = 0
    --消耗品
    self.itemPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.ItemTemplate,
    })
    self.panel.BtnYes:AddClick(function()
        if self.onConfirm ~= nil then
            if not self.materialIsEnough then
                MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(self.notEnoughId, nil, nil, nil, true)
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("ITEM_NOT_ENOUGH"))
                return
            end
            if self.delayConfirmEx ~= nil then
                self.delayConfirmEx(self.togType, self.showHideTogName, self.selectNeverShow)
                return
            end
            self.onConfirm()
        end
        --不再显示相关
        if self.selectNeverShow and self.showHideTogName ~= nil then
            if self.togType == 1 or self.togType == 3 then
                CommonUI.Dialog.l_dontShowTable[self.showHideTogName] = true
            elseif self.togType == 2 then
                local l_dateStr = tostring(os.date("!%Y%m%d",Common.TimeMgr.GetLocalNowTimestamp()))
                UserDataManager.SetDataFromLua(self.showHideTogName, MPlayerSetting.PLAYER_SETTING_GROUP, l_dateStr)
            end
        end
        UIMgr:DeActiveUI(UI.CtrlNames.ComsumeDialog)
    end)
    self.panel.BtnNo:AddClick(function()
        if self.onCancel ~= nil then
            self.onCancel()
        end
        --不再显示相关
        if self.togType == 3 and self.selectNeverShow and self.showHideTogName ~= nil then
            CommonUI.Dialog.l_dontShowTable[self.showHideTogName] = false
        end

        UIMgr:DeActiveUI(UI.CtrlNames.ComsumeDialog)
    end)
    self.panel.TogHide:OnToggleChanged(function(on)
        self.selectNeverShow = on
    end)
    self.panel.Btn_Close:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.ComsumeDialog)
    end)
end --func end
--next--
function ComsumeDialogCtrl:Uninit()
    self.itemPool = nil
    self.onConfirm = nil
    self.onCancel = nil
    --确认二次弹窗
    self.delayConfirmEx = nil

    --勾选框 类型  0无勾选框  1不再提示(本次登录)  2今日不再提示  3双向不再提示(勾选后无论确定还是取消都会记录操作)
    self.togType = 0
    --不再提示的key值
    self.showHideTogName = nil
    --勾选框的勾选情况
    self.selectNeverShow = false

    self.consume = nil

    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function ComsumeDialogCtrl:OnActive()

    --不再显示相关
    self.panel.TogHide.Tog.isOn = false
    if self.togType == 2 then
        self.panel.TogLab.LabText = Lang("TODAY_NOT_SHOW")
    else
        self.panel.TogLab.LabText = Lang("NOT_SHOW")
    end
    self.panel.TogPanel.UObj:SetActiveEx(self.togType > 0 and self.showHideTogName ~= nil)

end --func end
--next--
function ComsumeDialogCtrl:OnDeActive()


end --func end
--next--
function ComsumeDialogCtrl:Update()


end --func end



--next--
function ComsumeDialogCtrl:BindEvents()

end --func end

--next--
--lua functions end

--lua custom scripts
---@param consume ItemTemplateParam[]
function ComsumeDialogCtrl:SetDlgInfo(title, content, onConfirm, onCancel, consume, togType, showHideTogName,delayConfirmEx,hrefFunc)
    self.onConfirm = onConfirm
    self.onCancel = onCancel
    self.togType = togType or 0
    self.showHideTogName = showHideTogName
    self.consume = consume
    self.delayConfirmEx = delayConfirmEx

    if consume ~= nil then
        self.panel.TxtMsg.LabText = title
        self.materialIsEnough = true
        self.panel.TxtMsg.gameObject:SetActiveEx(true)
        self.panel.ItemParent.gameObject:SetActiveEx(true)
        if content and content ~= "" then
            self.panel.Content.LabText = content
            self.panel.Content.gameObject:SetActiveEx(true)
            self.panel.Content:GetRichText().onHrefClick:RemoveAllListeners()
            if hrefFunc then
                self.panel.Content:GetRichText().onHrefClick:AddListener(hrefFunc)
            end
        else
            self.panel.Content.gameObject:SetActiveEx(false)
        end
        self:RefreshConsume()
    else
        self.materialIsEnough = true
        local l_iconTxt = StringEx.Format(Common.Utils.Lang("RICH_IMAGE"), "UI_icon_item_Zeng.png", "Icon_ItemConsumables01", self.panel.Content:GetRichText().fontSize, 1.8)
        if content and content ~= "" then
            self.panel.Content.LabText = content .. l_iconTxt

            self.panel.TxtMsg.LabText = title
            self.panel.TxtMsg.gameObject:SetActiveEx(true)
        else
            self.panel.Content.LabText = title .. l_iconTxt
            self.panel.TxtMsg.gameObject:SetActiveEx(false)
        end
        self.panel.Content.gameObject:SetActiveEx(true)
        self.panel.ItemParent.gameObject:SetActiveEx(false)
    end
end

--判断材料是否足够
---@param data ItemTemplateParam
function ComsumeDialogCtrl:MaterialIsEnough(data)
    local l_currentCount = 0
    local l_requireCount = 0
    if self.materialIsEnough then
        local l_itemId = data.ID or data.PropInfo.TID
        if l_itemId == nil then
            return
        end
        l_currentCount = Data.BagModel:GetCoinOrPropNumById(tonumber(l_itemId))
        l_requireCount = data.RequireCount or 0
        --货币不判 走快捷兑换
        if l_currentCount < l_requireCount and data.ID ~= GameEnum.l_virProp.Coin101  then
            self.materialIsEnough = false
            self.notEnoughId = data.ID
        end
    end
end

function ComsumeDialogCtrl:RefreshConsume()
    for i = 1, #self.consume do
        --在初始化消耗品的同时判断材料是否足够
        self:MaterialIsEnough(self.consume[i])
    end
    self.itemPool:ShowTemplates({ Datas = self.consume, Parent = self.panel.ItemParent.transform })
end

--lua custom scripts end
return ComsumeDialogCtrl