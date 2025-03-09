--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/MallPanel"
require "UI/Template/MallItemPrefab"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
---@class MallCtrl:UIBaseCtrl
MallCtrl = class("MallCtrl", super)
local l_mallMgr = MgrMgr:GetMgr("MallMgr")
--lua class define end

--lua functions
function MallCtrl:ctor()

    super.ctor(self, CtrlNames.Mall, UILayer.Function, UITweenType.UpAlpha, ActiveType.Exclusive)
    self.isFullScreen = true

    --self.IsGroup=true

end --func end
--next--
function MallCtrl:Init()

    self.panel = UI.MallPanel.Bind(self)
    super.Init(self)
    self.mallMgr = MgrMgr:GetMgr("MallMgr")
    self.openMgr = MgrMgr:GetMgr("OpenSystemMgr")
    self.mallMgr.DataLis = {}
    self.redSignProcessorMallFestival = nil

    self.panel.CloseBtn:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.Mall)
    end, true)

    self.panel.MallItemPrefab.LuaUIGroup.gameObject:SetActiveEx(false)

    self.panel.ButtonMail.gameObject:SetActiveEx(true)
    self.panel.ButtonMail:AddClick(function()
        MgrMgr:GetMgr("EmailMgr").OpenEmail()
    end)

    self.redSignProcessor = self:NewRedSign({
        Key = eRedSignKey.MailOfShop,
        ClickButton = self.panel.ButtonMail
    })

    self.panel.ButtonRefresh.gameObject:SetActiveEx(false)
    self.panel.ButtonRefresh:AddClick(function()
        self:OnClickRefreshBtn()
    end)

    self.redSigns = {}

    self.handlerSwitchCount = 0
end --func end
--next--
function MallCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil

    self.mallMgr.FestivalGroupID = nil
    self.mallMgr.SelectTab = nil
    self.mallMgr = nil
    self.openMgr = nil
    self.preSelectMajorId = nil
    self.selectDefaultHandler = nil
    self.hideTabGroup = nil
    self.redSignProcessorMallFestival = nil
end --func end
--next--
function MallCtrl:OnActive()

    for i, v in ipairs(self.redSigns) do
        self:UninitRedSign(v)
    end
    self.redSigns = {}

    self.handlerSwitchCount = 0

    MgrMgr:GetMgr("CurrencyMgr").SetCurrencyDisplay(nil, 0)

    local l_uiPanelConfigData = {}
    l_uiPanelConfigData.InsertPanelName = CtrlNames.Mall

    UIMgr:ActiveUI(UI.CtrlNames.Currency, nil, l_uiPanelConfigData)

    self:InitPreSelect()

    self:RefreshHandler()

    self.panel.TableGroup.gameObject:SetActiveEx(not self.hideTabGroup)

    MgrMgr:GetMgr("TimeLimitPayMgr").ReqeustAwardInfo()
    MgrMgr:GetMgr("GiftPackageMgr").RequestTimeGiftInfo()
end --func end
--next--
function MallCtrl:OnDeActive()
    self:DestroyFx()
end --func end
--next--
function MallCtrl:Update()
    super.Update(self)
end --func end

--next--
function MallCtrl:BindEvents()

    self:BindEvent(self.mallMgr.EventDispatcher, self.mallMgr.Event.ResetData, function(self, mid)
        self:RefreshCountInfo()
    end)

    local l_giftPackageMgr = MgrMgr:GetMgr("GiftPackageMgr")
    self:BindEvent(l_giftPackageMgr.EventDispatcher, l_giftPackageMgr.EventType.TimeGiftInfoRefresh, function()

        local l_eSystemId = self.openMgr.eSystemId
        local l_checkFunc = self.openMgr.IsSystemOpen

        local mallFestivalGroupInfo = MgrMgr:GetMgr("GiftPackageMgr").GetGroupInfos()
        if l_checkFunc(l_eSystemId.GiftPackage) and #mallFestivalGroupInfo > 0 then
            if self:GetHandlerByName(UI.HandlerNames.MallFestival) == nil then
                self:createOneHandler({UI.HandlerNames.MallFestival, mallFestivalGroupInfo[1].activityName})
            end
        else
            self:RefreshHandler(UI.HandlerNames.MallFestival)
        end
    end)

end --func end
--next--
--lua functions end

--lua custom scripts

function MallCtrl:RefreshHandler()
    self:InitCustomHandlers()

    self:InitHandler(self.handlerTable, self.panel.Toggle, self.panel.MainView, self.selectDefaultHandler)

    self:ShowRedSign()

    if self.uiPanelData and self.uiPanelData.selectHandlerName then
        self:SelectOneHandler(self.uiPanelData.selectHandlerName)
    end
end

function MallCtrl:InitPreSelect()

    local l_selectTabId, l_selectMajorId
    if self.uiPanelData then
        self.mallMgr.SelectTab = self.uiPanelData.Tab
        self.preSelectMajorId = self.uiPanelData.MajorID
        self.hideTabGroup = self.uiPanelData.HideTabGroup
        self.mallMgr.FestivalGroupID = self.uiPanelData.FestivalGroupID

        if self.preSelectMajorId then
            self:OnFindItem(self.preSelectMajorId)
        end
    end

end

function MallCtrl:InitCustomHandlers()

    self:EnsureUnloadHandler(UI.HandlerNames.MallGold)
    self:EnsureUnloadHandler(UI.HandlerNames.MallMaster)
    self:EnsureUnloadHandler(UI.HandlerNames.MallMystery)
    self:EnsureUnloadHandler(UI.HandlerNames.MallFeeding)
    self:EnsureUnloadHandler(UI.HandlerNames.MallFestival)

    self.handlerTable = {}
    self.selectDefaultHandler = nil
    local l_eSystemId = self.openMgr.eSystemId
    local l_checkFunc = self.openMgr.IsSystemOpen
    local l_mallTypeTbl = self.mallMgr.MallTable
    if l_checkFunc(l_eSystemId.MallGoldHot) or l_checkFunc(l_eSystemId.MallGoldGift) then
        table.insert(self.handlerTable, { UI.HandlerNames.MallGold, Lang("JINGJIEZHI_GOLD") })
        self.selectDefaultHandler = self.selectDefaultHandler or UI.HandlerNames.MallGold
        self:InitselectDefaultHandler(UI.HandlerNames.MallGold, l_mallTypeTbl.Glod_Hot, l_mallTypeTbl.Glod_Gift)
    end
    if l_checkFunc(l_eSystemId.MallMasterHouseZeny) or l_checkFunc(l_eSystemId.MallMasterHouseCoin) then
        table.insert(self.handlerTable, { UI.HandlerNames.MallMaster, Lang("MALL_MASTER") })
        self.selectDefaultHandler = self.selectDefaultHandler or UI.HandlerNames.MallMaster
        self:InitselectDefaultHandler(UI.HandlerNames.MallMaster, l_mallTypeTbl.House_Zeny, l_mallTypeTbl.House_Copper)
    end
    if l_checkFunc(l_eSystemId.MallMysteryShop) then
        table.insert(self.handlerTable, { UI.HandlerNames.MallMystery, Lang("MALL_MYSTERY") })
        self.selectDefaultHandler = self.selectDefaultHandler or UI.HandlerNames.MallMystery
        self:InitselectDefaultHandler(UI.HandlerNames.MallMystery, l_mallTypeTbl.Mystery)
    end
    if l_checkFunc(l_eSystemId.MallFeeding) then
        table.insert(self.handlerTable, { UI.HandlerNames.MallFeeding, Lang("MALL_FEEDING") })
        self.selectDefaultHandler = self.selectDefaultHandler or UI.HandlerNames.MallFeeding
        self:InitselectDefaultHandler(UI.HandlerNames.MallFeeding, l_mallTypeTbl.Pay)
    end
end

function MallCtrl:InitselectDefaultHandler(hander, tab1, tab2)

    if self.mallMgr.SelectTab ~= nil and (tab1 == self.mallMgr.SelectTab or tab2 == self.mallMgr.SelectTab) then
        self.selectDefaultHandler = hander
    else
        self.selectDefaultHandler = self.selectDefaultHandler or hander
    end
end

--寻找商品
function MallCtrl:OnFindItem(majorID)
    local l_table = TableUtil.GetMallTable().GetTable()
    for i, v in ipairs(l_table) do
        if v.MajorID == majorID then
            self.mallMgr.chooseItem = v
            self.mallMgr.SelectTab = v.Tab
            return
        end
    end
end

function MallCtrl:OnHandlerSwitch(handlerName)

    super.OnHandlerSwitch(self, handlerName)

    self.handlerSwitchCount = self.handlerSwitchCount + 1

    self.panel.ButtonRefresh.gameObject:SetActiveEx(handlerName == UI.HandlerNames.MallMystery)
    self.panel.Ticket.gameObject:SetActiveEx(handlerName == UI.HandlerNames.MallMystery)
    self.panel.TextRefresh.gameObject:SetActiveEx(false)

    if handlerName == UI.HandlerNames.MallGold and self.handlerSwitchCount > 1 then
        local l_handler = self:GetHandlerByName(handlerName)
        if l_handler and l_handler.curMallId == self.mallMgr.MallTable.Glod_Gift then
            MgrMgr:GetMgr("RedSignMgr").InvokeButtonMethod(eRedSignKey.RedSignMallGoldGift)
        end
    end

    self:RefreshCountInfo()
    self:SetResetTimeInfo(handlerName)

    self.panel.RawImage.RawImg.enabled = false
    if handlerName == UI.HandlerNames.MallFeeding then
        local l_limitPayMgr = MgrMgr:GetMgr("TimeLimitPayMgr")
        local l_open = l_limitPayMgr.IsSystemOpen()
        if l_open then
            self:CreateFx()
        end
    else
        self:DestroyFx()
    end
end

function MallCtrl:RefreshCountInfo()

    local l_pos = 0
    if self.curHandler and self.curHandler.name == UI.HandlerNames.MallMystery then
        l_pos = -113
        local l_cost = self.mallMgr.GetRefreshCost(self.mallMgr.MallTable.Mystery)
        if not l_cost then
            self.panel.ButtonRefresh:SetGray(true)
            self.panel.Ticket.gameObject:SetActiveEx(false)
            self.panel.TextRefresh.LabText = Lang("MALL_COUNT_LIMIT")
            self.panel.TextRefresh.gameObject:SetActiveEx(true)
        else
            if l_cost.ItemId == nil then
                self.panel.Ticket.gameObject:SetActiveEx(false)
                self.panel.ButtonRefresh:SetGray(false)
                self.panel.TextRefresh.LabText = Lang("UPDATE_LAKE")
                self.panel.TextRefresh.gameObject:SetActiveEx(true)
            else
                local l_item = TableUtil.GetItemTable().GetRowByItemID(l_cost.ItemId)
                if l_item then
                    self.panel.TicketImage:SetSpriteAsync(l_item.ItemAtlas, l_item.ItemIcon, nil, true)
                end
                local l_currentCount = Data.BagModel:GetCoinOrPropNumById(l_cost.ItemId)
                if l_currentCount >= l_cost.Count then
                    self.panel.TextNum.LabColor = RoColor.Hex2Color(RoColor.WordColor.Blue[1])
                else
                    self.panel.TextNum.LabColor = RoColor.Hex2Color(RoColor.WordColor.Red[1])
                end

                self.panel.TextNum.LabText = l_cost.Count
                self.panel.TextRefresh.gameObject:SetActiveEx(false)
                self.panel.Ticket.gameObject:SetActiveEx(true)
            end
        end
    end
    MLuaCommonHelper.SetRectTransformPosX(self.panel.ResetTime.gameObject, l_pos)
end

function MallCtrl:OnClickRefreshBtn()

    local l_cost = self.mallMgr.GetRefreshCost(self.mallMgr.MallTable.Mystery)
    -- 配置问题
    if not l_cost then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("MallRefreshLimit"))
    else
        -- 免费
        if l_cost.ItemId == nil then
            self.mallMgr.RequestManualRefreshMallItem(self.mallMgr.MallTable.Mystery)
        else
            local l_currentCount = Data.BagModel:GetCoinOrPropNumById(l_cost.ItemId)
            -- 数量不足，弹tips
            if l_currentCount < l_cost.Count then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("MallLuckTicket", Data.BagModel:GetItemNameText(l_cost.ItemId)))
                local locItem = Data.BagModel:CreateItemWithTid(l_cost.ItemId)
                MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplay(locItem, nil, nil, nil, true, { relativePositionY = 28 })
                return
            end

            local l_consume = {}
            local l_data = {
                ID = l_cost.ItemId,
                RequireCount = l_cost.Count,
                IsShowCount = false,
                IsShowRequire = true,
            }
            table.insert(l_consume, l_data)
            -- 弹确认框
            CommonUI.Dialog.ShowConsumeDlg("", Lang("MallRefreshCostTips"), function()
                self.mallMgr.RequestManualRefreshMallItem(self.mallMgr.MallTable.Mystery)
            end, nil, l_consume, 2, "MALL_DONOT_NOTIFY_TODAY")
        end
    end
end

function MallCtrl:SetResetTimeInfo(handlerName)
    local l_handler = self:GetHandlerByName(handlerName)
    local l_mallId = l_handler and l_handler.curMallId
    local l_mallRow = nil
    local l_rows = TableUtil.GetMallInterfaceTable().GetTable()
    for i = 1, #l_rows do
        local l_row = l_rows[i]
        if l_row then
            if l_row.Tab == l_mallId then
                l_mallRow = l_row
                break
            end
        end
    end
    local l_visible = true
    if l_mallId == self.mallMgr.MallTable.Glod_Gift then
        self.panel.ResetTime.LabText = Lang("MALL_LIMIT_BUY")
    elseif l_mallRow and l_mallRow.ShowCountDown then
        self.panel.ResetTime:SetActiveEx(true)
        if l_mallRow.RefreshIntervalType == 101 then
            local l_st = StringEx.Format(Lang("Mall_Refresh_Time_Day"), l_mallRow.RefreshTime) --每日{0}点刷新
            self.panel.ResetTime.LabText = l_st
        elseif l_mallRow.RefreshIntervalType == 102 then
            local l_st = StringEx.Format(Lang("Mall_Refresh_Time_Week"), Lang("Week" .. tostring(l_mallRow.RefreshDate)), l_mallRow.RefreshTime)--每{0}凌晨{1}点刷新
            self.panel.ResetTime.LabText = l_st
        else
            self.panel.ResetTime.LabText = "???"
        end
    else
        l_visible = false
    end

    self.panel.ResetTime:SetActiveEx(l_visible)

    self:ResetTime(l_mallId)
end

--刷新倒计时
function MallCtrl:ResetTime(mallId)
    if self.timer ~= nil then
        self:StopUITimer(self.timer)
        self.timer = nil
    end

    local l_refresh, l_data = self.mallMgr.GetMallData(mallId, false)
    if not l_refresh and l_data.time and l_data.time > 0 then
        self.timer = self:NewUITimer(function()
            log("倒计时结束,刷新道具")
            self.mallMgr.SendGetMallInfo(mallId)
        end, l_data.time - Time.realtimeSinceStartup)
        self.timer:Start()
    end
end

function MallCtrl:CreateFx()
    self:DestroyFx()
    self.panel.RawImage.RawImg.enabled = true
    local l_fxData = {}
    l_fxData.rawImage = self.panel.RawImage.RawImg
    l_fxData.destroyHandler = function()
        self.fxId = 0
    end
    l_fxData.scaleFac = Vector3.New(2, 2, 2)
    self.fxId = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/Fx_UI_MiaoMiaoLaiLe_DiaoLuo_01", l_fxData)
end

function MallCtrl:DestroyFx()
    if self.fxId and self.fxId > 0 then
        self:DestroyUIEffect(self.fxId)
        self.fxId = 0
    end
end

function MallCtrl:ShowRedSign()

    local l_ret
    --- 投食红点特殊处理，框架没有支持
    local handler = self:GetHandlerByName(HandlerNames.MallFeeding)
    if handler then
        l_ret = self:NewRedSign({
            Key = eRedSignKey.Recharge,
            ClickButton = handler.toggle:GetComponent("MLuaUICom"),
        })
        table.insert(self.redSigns, l_ret)
    end
    handler = self:GetHandlerByName(HandlerNames.MallMystery)
    if handler then
        l_ret = self:NewRedSign({
            Key = eRedSignKey.RedSignMallMystery,
            ClickTogEx = handler.toggle,
        })
        table.insert(self.redSigns, l_ret)
    end
    handler = self:GetHandlerByName(HandlerNames.MallGold)
    if handler then
        l_ret = self:NewRedSign({
            Key = eRedSignKey.RedSignMallGold,
            ClickTogEx = handler.toggle,
        })
        table.insert(self.redSigns, l_ret)
    end

    local mallFestivalHandler = self:GetHandlerByName(HandlerNames.MallFestival)
    if self.redSignProcessorMallFestival == nil and mallFestivalHandler ~= nil then
        self.redSignProcessorMallFestival = self:NewRedSign({
            Key = eRedSignKey.GiftPackage,
            ClickTogEx = self:GetHandlerByName(HandlerNames.MallFestival).toggle:GetComponent("MLuaUICom"),
        })
    end

end

--lua custom scripts end
return MallCtrl