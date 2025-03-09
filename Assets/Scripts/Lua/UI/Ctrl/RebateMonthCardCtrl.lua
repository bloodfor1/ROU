--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/RebateMonthCardPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
RebateMonthCardCtrl = class("RebateMonthCardCtrl", super)
--lua class define end

--lua functions
function RebateMonthCardCtrl:ctor()

    super.ctor(self, CtrlNames.RebateMonthCard, UILayer.Function, nil, ActiveType.Exclusive)

end --func end
--next--
function RebateMonthCardCtrl:Init()

    self.panel = UI.RebateMonthCardPanel.Bind(self)
    super.Init(self)
    self.mgr = MgrMgr:GetMgr("RebateMonthCardMgr")
    self.data = DataMgr:GetData("RebateMonthCardData")
    self.panel.Btn_Back:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.RebateMonthCard)
    end)
    self.panel.Btn_Wenhao.Listener.onClick = function(go, eventData)
        local l_infoText = Common.Utils.Lang("QUESTION_REBATE_MONTH_CARD")
        local l_anchor = Vector2.New(0.5, 1)
        MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(l_infoText, eventData, l_anchor)
    end
end --func end
--next--
function RebateMonthCardCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function RebateMonthCardCtrl:OnActive()
    self:RefreshAll()
end --func end
--next--
function RebateMonthCardCtrl:OnDeActive()
    local normal = MgrMgr:GetMgr("CommonDataMgr").GetClientCommonData(CommondataClientUseId.kCDT_NormalCard_Time)
    local super = MgrMgr:GetMgr("CommonDataMgr").GetClientCommonData(CommondataClientUseId.kCDT_SuperCard_Time)
    if normal == 0 and super == 0 then
        UIMgr:DeActiveUI(UI.CtrlNames.MonthCard_TipsPanel)
    end
end --func end
--next--
function RebateMonthCardCtrl:Update()


end --func end
--next--
function RebateMonthCardCtrl:BindEvents()
    self:BindEvent(self.mgr.EventDispatcher, self.data.REBATE_CARD_TYPE, self.RefreshAll)

end --func end
--next--
--lua functions end

--lua custom scripts
---刷新面板
---@param Index number
---@param panelData RebateMonthCardInfo
function RebateMonthCardCtrl:SetPanel(Index, panelData)
    self.panel.Btn_Buy[Index]:SetGray(panelData.endTimeStamp ~= 0)
    self.panel.StatusActive[Index]:SetActiveEx(panelData.endTimeStamp ~= 0)
    self.panel.StatusNotActive[Index]:SetActiveEx(panelData.endTimeStamp == 0)
    self.panel.RemainTime[Index].LabText = Lang("TIME_DAY", panelData.leftTimes)
    self.panel.Day[Index]:SetActiveEx(panelData.endTimeStamp == 0)
    local leftDay = panelData.tableInfo.TermOfValidity
    if panelData.buyCount>0 then
        leftDay = panelData.buyCount * leftDay
    end
    self.panel.Num_LeftDay[Index].LabText = Lang("TIME_DAY_RI", leftDay)
    local payment = TableUtil.GetPaymentTable().GetRowByProductId(panelData.tableInfo.ProductId)

    
    local ImmediatiatelyItemId,ImmediatiatelyAwardNum,ImmediatiatelyisExit = self:FindAwrd(payment.AwardId[1])
    if ImmediatiatelyisExit then
        self.panel.Num_BuyNow[Index].LabText = ImmediatiatelyAwardNum
    end

    -------以下显示每日和累计第一货币--------------------
    local itemId_1,dayAwardNum,isExit = self:FindAwrd(panelData.tableInfo.DayAwardId)
    if isExit then
        local l_itemTableInfo = TableUtil.GetItemTable().GetRowByItemID(itemId_1)
        self.panel.Num_EveryDay[Index].LabText = dayAwardNum
        if panelData.endTimeStamp ~= 0 then
            self.panel.Num_Left[Index].LabText = dayAwardNum * panelData.leftTimes
        else
            self.panel.Num_Left[Index].LabText = dayAwardNum * panelData.tableInfo.TermOfValidity
        end
        self.panel.Currency_EveryDay[Index]:SetSprite(l_itemTableInfo.ItemAtlas, l_itemTableInfo.ItemIcon)
        self.panel.Currency_Left[Index]:SetSprite(l_itemTableInfo.ItemAtlas, l_itemTableInfo.ItemIcon)
    else
        self.panel.Num_Left[Index].gameObject:SetActiveEx(false)
        self.panel.Num_Left[Index].gameObject:SetActiveEx(false)
        self.panel.Currency_Left[Index].gameObject:SetActiveEx(false)
        self.panel.Currency_EveryDay[Index].gameObject:SetActiveEx(false)
    end
    ---------------------------------------------

    --------以下显示每日和累计第二货币---------------
    local itemId_2,dayAwardNum_2,isExit_2 = self:SecondAward(panelData.tableInfo.DayAwardId)
    if isExit_2 then
        local l_itemTableInfo_2 = TableUtil.GetItemTable().GetRowByItemID(itemId_2)
        self.panel.Num_EveryDay_2[Index].LabText = dayAwardNum_2
        if panelData.endTimeStamp ~= 0 then
            self.panel.Num_Left_2[Index].LabText = dayAwardNum_2 * panelData.leftTimes
        else
            self.panel.Num_Left_2[Index].LabText = dayAwardNum_2 * panelData.tableInfo.TermOfValidity
        end
        self.panel.Currency_Left_2[Index]:SetSprite(l_itemTableInfo_2.ItemAtlas, l_itemTableInfo_2.ItemIcon)
        self.panel.Currency_EveryDay_2[Index]:SetSprite(l_itemTableInfo_2.ItemAtlas, l_itemTableInfo_2.ItemIcon)
    else
        self.panel.Num_EveryDay_2[Index].gameObject:SetActiveEx(false)
        self.panel.Num_Left_2[Index].gameObject:SetActiveEx(false)
        self.panel.Currency_Left_2[Index].gameObject:SetActiveEx(false)
        self.panel.Currency_EveryDay_2[Index].gameObject:SetActiveEx(false)
    end
    ---------------------------------------

    --self.panel.Text_Price[Index].LabText = Common.Utils.Lang(payment.Cueerncy) .. payment.Price .. Common.Utils.Lang("ACTIVATION")
    --if self.openSystem.IsSystemOpen(self.data.SystemID.buyNow[Index]) and panelData.endTimeStamp ~= 0 then
    --    self.panel.Btn_QuickAccess[Index]:SetActiveEx(true)
    --    self.panel.Btn_Buy[Index]:SetActiveEx(false)
    --else
    ---根据结束时间戳是否为零判断是否已购，区别显示
    if panelData.endTimeStamp ~= 0 then
        self.panel.Text_Price[Index].LabText = Common.Utils.Lang("STICKER_ACTIVE_TXT")
    else
        self.panel.Text_Price[Index].LabText = game:GetPayMgr():GetPaymentCurrencyFormatByProductId(panelData.tableInfo.ProductId)
    end
    self.panel.Btn_QuickAccess[Index]:SetActiveEx(false)
    --end
    if panelData.endTimeStamp ~= 0 and panelData.leftTimes <= panelData.tableInfo.TimeAgain then
        self.panel.Btn_QuickAccess[Index]:SetActiveEx(false)
        self.panel.Btn_Buy[Index]:SetActiveEx(true)
        self.panel.Btn_Buy[Index]:SetGray(false)
        self.panel.Text_Price[Index].LabText = game:GetPayMgr():GetPaymentCurrencyFormatByProductId(panelData.tableInfo.ProductId)
    end

    self.panel.Btn_Buy[Index]:AddClick(function()
        if panelData.endTimeStamp == 0 or panelData.leftTimes <= panelData.tableInfo.TimeAgain then
            local l_data = {
                productId = panelData.tableInfo.ProductId,
                totalDay = panelData.tableInfo.TermOfValidity,
                everydayNum = dayAwardNum,
                immediatiatelyNum = ImmediatiatelyAwardNum,
                activeTable = self,
                confirm = self.OnBtnConfirm,
                secondDayNum = dayAwardNum_2,
                secondCoinId = itemId_2
            }
            UIMgr:ActiveUI(UI.CtrlNames.PaymentInstructions,l_data)
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("REBATE_MONTHCARD_CANT_PICK"))
        end
    end)
    ---留有接口用于快速获得剩余全部金币
    --self.panel.Btn_QuickAccess[Index]:AddClick(function()
    --    self.mgr.BuyRebateCard(Index, self.data.BUY_TYPE.BuyAll)
    --end)
end
---查找奖励表中的奖励，后续改双货币的时候要在这里修改下读表逻辑
function RebateMonthCardCtrl:FindAwrd(Id)
    local awardTable = TableUtil.GetAwardTable().GetRowByAwardId(Id)
    local awardPack = TableUtil.GetAwardPackTable().GetRowByPackId(awardTable.PackIds[0])
    local l_isDataExist = false
    if awardPack.GroupContent.Length >= 1 then
        if awardPack.GroupContent[0].Length >= 2 then
            l_isDataExist = true
        end
    end
    if l_isDataExist then
        return awardPack.GroupContent[0][0],awardPack.GroupContent[0][1],l_isDataExist
    end
    return nil,nil,false
end

--获取双货币的第二个奖励 逻辑比较临时 @曾祥硕 后续自己去修改
function RebateMonthCardCtrl:SecondAward(Id)
    local awardTable = TableUtil.GetAwardTable().GetRowByAwardId(Id)
    local awardPack = TableUtil.GetAwardPackTable().GetRowByPackId(awardTable.PackIds[0])
    local l_isDataExist = false
    if awardPack.GroupContent.Length > 1 then
        if awardPack.GroupContent[0].Length >= 2 then
            l_isDataExist = true
        end
    end
    if l_isDataExist then
        return awardPack.GroupContent[1][0],awardPack.GroupContent[1][1],l_isDataExist
    end
    return nil,nil,false
end

---刷新全部
function RebateMonthCardCtrl:RefreshAll()
    self.openSystem = MgrMgr:GetMgr("OpenSystemMgr")
    local normalOpen = self.openSystem.IsSystemOpen(self.openSystem.eSystemId.RebateMonthCardNormal)
    local superOpen = self.openSystem.IsSystemOpen(self.openSystem.eSystemId.RebateMonthCardSuper)
    self.panel.item[self.data.REBATE_CARD_TYPE.Normal]:SetActiveEx(normalOpen)
    self.panel.item[self.data.REBATE_CARD_TYPE.Super]:SetActiveEx(superOpen)
    if normalOpen then
        self:SetPanel(self.data.REBATE_CARD_TYPE.Normal, self.data.GetNormalInfo())
    end
    if superOpen then
        self:SetPanel(self.data.REBATE_CARD_TYPE.Super, self.data.GetSuperInfo())
    end
end

function RebateMonthCardCtrl:OnBtnConfirm(paymentID)
    self.mgr.BuyRebateCard(paymentID)
end

--lua custom scripts end
return RebateMonthCardCtrl