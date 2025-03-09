--this file is gen by script
--you can edit this file in custom part

--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/BarberShopPanel"
require "Data/Model/BagModel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
BarberShopCtrl = class("BarberShopCtrl", super)
--lua class define end

local l_UIBarberScroll = nil
local l_barberInfo = {}
local l_barberIdToIdx = {}
local l_curBarber = nil
local l_curBarberTmp = nil
local l_curStyleRow = nil
local l_curStyleRowTmp = nil
local l_curColorTmp = 0
local l_zenyCost = 0
local l_bagEnough = true
local l_moneyEnough = true
local conditionGOTable = {}
local l_itemBag = {GameEnum.EBagContainerType.Bag,GameEnum.EBagContainerType.WareHouse,GameEnum.EBagContainerType.VirtualItem,GameEnum.EBagContainerType.HeadIcon}

local Mgr = MgrMgr:GetMgr("BarberShopMgr")
local LimitMgr = MgrMgr:GetMgr("LimitMgr")

local l_green = Color.New(90 / 255.0, 190 / 255.0, 17 / 255.0)
local l_red = Color.New(235 / 255.0, 76 / 255.0, 68 / 255.0)
local l_tips = nil

local FxID = 121002
local l_fx = nil

local FindObjectInChild = function(...)
    return MoonCommonLib.GameObjectEx.FindObjectInChild(...)
end

function BarberShopCtrl:GarderobeFunc()
    local idx = l_barberIdToIdx[MgrProxy:GetGarderobeMgr().JumpToBarberStyleId]
    local info = l_barberInfo[idx]

    self:OnBarberItemClick(info)
    self:UpdateStyleTmp()
end

--lua functions
function BarberShopCtrl:ctor()

    super.ctor(self, CtrlNames.BarberShop, UILayer.Function, nil, ActiveType.Exclusive)

end --func end
--next--
function BarberShopCtrl:Init()
    self.panel = UI.BarberShopPanel.Bind(self)
    super.Init(self)

    conditionGOTable = {}
    table.insert(conditionGOTable, self.panel.Condition1)
    table.insert(conditionGOTable, self.panel.Condition2)
    table.insert(conditionGOTable, self.panel.Condition3)

    self.notEnoughId = nil
    l_UIBarberScroll = self.panel.Colors:GetComponent("UIBarberScroll")
    l_UIBarberScroll.OnValueChanged = function(idx)
        l_curColorTmp = idx + 1
        self:UpdateStyleTmp()
    end
    self.panel.BtClose:AddClick(function()
        if MEntityMgr.PlayerEntity ~= nil and MEntityMgr.PlayerEntity.AttrComp ~= nil then
            MEntityMgr.PlayerEntity.AttrComp:SetHair(MPlayerInfo.HairStyle)
        end
        self:ShowOrnament(true)
        UIMgr:DeActiveUI(UI.CtrlNames.BarberShop)
    end)
    self.panel.TogHide:OnToggleChanged(function(v)
        self:ShowOrnament(not v)
    end)
    self.panel.BtOp:AddClick(function()
        self:OnOpClick()
    end)

    self.panel.BtOpUnEnable:AddClick(function()
        self:OnOpClick()
    end)
    self.panel.LockCondition.gameObject:SetActiveEx(false)

    l_barberInfo = {}
    l_barberIdToIdx = {}
    l_curBarber = nil
    l_curBarberTmp = nil
    l_curStyleRow = nil
    l_curStyleRowTmp = nil
    l_tips = nil
    l_curColorTmp = 0
    self:BuildAllBarber()
    self:UpdateCurHair()
    l_curColorTmp = l_curStyleRow and l_curStyleRow.Colour or 1
    l_UIBarberScroll.CurrentIndex = l_curColorTmp - 1
    -- 初始选中
    if l_curBarber ~= nil then
        self:OnBarberItemClick(l_curBarber)
    end

    self:InitSilder()

    if MgrProxy:GetGarderobeMgr().GetEnableJumpToBarberShopFlag() then
        MgrProxy:GetGarderobeMgr().EnableJumpToBarberShop(false)
        self:GarderobeFunc()
    end
end --func end
--next--
function BarberShopCtrl:Uninit()
    self:ClearFx()

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function BarberShopCtrl:OnActive()
    MVirtualTab:Clear()
    self.lastPoint = nil
    MgrMgr:GetMgr("BeautyShopMgr").AddDragListener(self.panel.BGbtn.gameObject,
            function(data)
                if self.lastPoint == nil then
                    self.lastPoint = data.position.x
                    return
                end
                local l_dis = self.lastPoint - data.position.x
                self.lastPoint = data.position.x
                MgrMgr:GetMgr("BeautyShopMgr").UpdatePlayerRotation(l_dis)
            end,
            function(data)
                self.lastPoint = nil
            end)
    l_uiPanelConfigData = {}
    l_uiPanelConfigData.InsertPanelName = CtrlNames.BarberShop

    UIMgr:ActiveUI(UI.CtrlNames.Currency, nil, l_uiPanelConfigData)

end --func end
--next--
function BarberShopCtrl:OnDeActive()

    -- 重置相机状态
    MPlayerInfo:FocusToMyPlayer()
    MEntityMgr.HideNpcAndRole = false
end --func end
--next--
function BarberShopCtrl:Update()


end --func end

--next--
function BarberShopCtrl:BindEvents()

    self:BindEvent(Mgr.EventDispatcher, Mgr.ON_INIT_SLIDER_VALUE,
            function()
                self:InitSilder()
            end)

end --func end
--next--
--lua functions end

--lua custom scripts

function BarberShopCtrl:OnShow()

    self:UpdateStyleTmp()
end

function BarberShopCtrl:BuildAllBarber()
    local allHair = TableUtil.GetBarberTable().GetTable()
    local idToStyleRows = {}
    local all = {}
    local idx = 1
    local sex = MPlayerInfo.IsMale and 0 or 1
    for i, row in ipairs(allHair) do
        if row.SexLimit == sex and not row.Hide then
            all[idx] = {
                ["row"] = row,
                ["styleRows"] = {}
            }
            idToStyleRows[row.BarberID] = all[idx].styleRows
            idx = idx + 1
        end
    end
    local allStyle = TableUtil.GetBarberStyleTable().GetTable()
    for i, row in ipairs(allStyle) do
        local rows = idToStyleRows[row.BarberID]
        if rows ~= nil then
            rows[row.Colour] = row
        end
    end
    -- 排序
    local hair_style_id = Mgr.FashionRecord.hair_style_id
    local hair_id = hair_style_id > 0 and TableUtil.GetBarberStyleTable().GetRowByBarberStyleID(hair_style_id).BarberID or 0
    table.sort(all, function(lhs, rhs)
        if lhs.row.BarberID == hair_id then
            return true
        end
        if rhs.row.BarberID == hair_id then
            return false
        end
        return lhs.row.SortID < rhs.row.SortID
    end)
    for i, info in ipairs(all) do
        self:BuildBarberItem(info)
    end
end

function BarberShopCtrl:BuildBarberItem(info)
    local prot = self.panel.BtBarberProt.gameObject
    local uobj
    if #l_barberInfo < 1 then
        uobj = prot
    else
        uobj = self:CloneObj(prot)
        uobj.transform:SetParent(prot.gameObject.transform.parent)
        uobj.transform.localScale = prot.transform.localScale
    end
    local obj = uobj:GetComponent("MLuaUICom")
    info.obj = obj
    info.uobj = uobj
    l_barberInfo[#l_barberInfo + 1] = info
    l_barberIdToIdx[info.row.BarberID] = #l_barberInfo
    obj:AddClick(function()
        self:OnBarberItemClick(info)
    end)
    local uiContent = FindObjectInChild(uobj, "ImgContent"):GetComponent("MLuaUICom")
    uiContent:SetSpriteAsync(info.row.BarberAtlas, info.row.BarberIcon)

    local LockGO = FindObjectInChild(uobj, "NotAward")
    LockGO.gameObject:SetActiveEx(not Mgr.CheckLimit(info.row.BarberID))
end

function BarberShopCtrl:OnBarberItemClick(info)
    if info == nil then
        return
    end
    if l_curBarberTmp == info then
        return
    end
    if l_curBarberTmp ~= nil then
        FindObjectInChild(l_curBarberTmp.uobj, "ImgTrial"):SetActiveEx(false)
    end
    l_curBarberTmp = info
    self.panel.TxName.LabText = l_curBarberTmp.row.BarberName
    FindObjectInChild(info.uobj, "ImgTrial"):SetActiveEx(true)
    self:UpdateStyleTmp()
end

function BarberShopCtrl:OnOpClick()
    if l_curStyleRow and l_curStyleRowTmp.BarberStyleID ~= l_curStyleRow.BarberStyleID then
        if self.notEnoughId ~= nil then
            MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(self.notEnoughId, nil, nil, nil, true)
            return
        end
        if not l_bagEnough then
            --MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("NOT_ENOUGH_ITEM"))
            if l_tips then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(tostring(l_tips) .. Common.Utils.Lang("CLICK_NOT_ENOUGH"))
            end
        --elseif not l_moneyEnough then
            --MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("NOT_ENOUGH_ZENY"))
        else
            Mgr.RequestChangeHair(l_curStyleRowTmp.BarberStyleID,l_zenyCost)
        end
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("OUTWARD_ALREADY_CURRENT"))
    end
end

function BarberShopCtrl:ShowOrnament(show)
    if MEntityMgr.PlayerEntity == nil or MEntityMgr.PlayerEntity.AttrComp == nil then
        return
    end
    if show then
        MEntityMgr.PlayerEntity.AttrComp:SetOrnamentByIntType(1, MPlayerInfo.OrnamentHead)
        MEntityMgr.PlayerEntity.AttrComp:SetOrnamentByIntType(2, MPlayerInfo.OrnamentFace)
        MEntityMgr.PlayerEntity.AttrComp:SetOrnamentByIntType(3, MPlayerInfo.OrnamentMouth)
        MEntityMgr.PlayerEntity.AttrComp:SetOrnamentByIntType(4, MPlayerInfo.OrnamentBack)
        MEntityMgr.PlayerEntity.AttrComp:SetOrnamentByIntType(5, MPlayerInfo.OrnamentTail)
        MEntityMgr.PlayerEntity.AttrComp:SetOrnamentByIntType(1, MPlayerInfo.OrnamentHeadFromBag, true)
        MEntityMgr.PlayerEntity.AttrComp:SetOrnamentByIntType(2, MPlayerInfo.OrnamentFaceFromBag, true)
        MEntityMgr.PlayerEntity.AttrComp:SetOrnamentByIntType(3, MPlayerInfo.OrnamentMouthFromBag, true)
        MEntityMgr.PlayerEntity.AttrComp:SetOrnamentByIntType(4, MPlayerInfo.OrnamentBackFromBag, true)
        MEntityMgr.PlayerEntity.AttrComp:SetOrnamentByIntType(5, MPlayerInfo.OrnamentTailFromBag, true)
    else
        MEntityMgr.PlayerEntity.AttrComp:SetOrnamentByIntType(1, 0)
        MEntityMgr.PlayerEntity.AttrComp:SetOrnamentByIntType(2, 0)
        MEntityMgr.PlayerEntity.AttrComp:SetOrnamentByIntType(3, 0)
        MEntityMgr.PlayerEntity.AttrComp:SetOrnamentByIntType(4, 0)
        MEntityMgr.PlayerEntity.AttrComp:SetOrnamentByIntType(5, 0)
        MEntityMgr.PlayerEntity.AttrComp:SetOrnamentByIntType(1, 0, true)
        MEntityMgr.PlayerEntity.AttrComp:SetOrnamentByIntType(2, 0, true)
        MEntityMgr.PlayerEntity.AttrComp:SetOrnamentByIntType(3, 0, true)
        MEntityMgr.PlayerEntity.AttrComp:SetOrnamentByIntType(4, 0, true)
        MEntityMgr.PlayerEntity.AttrComp:SetOrnamentByIntType(5, 0, true)
    end
end

function BarberShopCtrl:UpdateCurHair()
    -- 发型
    l_curStyleRow = TableUtil.GetBarberStyleTable().GetRowByBarberStyleID(Mgr.FashionRecord.hair_style_id)
    if l_curStyleRow == nil then
        logError("[UpdateCurHair]no hair style config, hair_style_id=" .. tostring(Mgr.FashionRecord.hair_style_id))
        return
    end
    local idx = l_barberIdToIdx[l_curStyleRow.BarberID]
    local info = l_barberInfo[idx]
    if l_curBarber ~= nil then
        FindObjectInChild(l_curBarber.uobj, "ImgSelected"):SetActiveEx(false)
    end
    l_curBarber = info
    FindObjectInChild(l_curBarber.uobj, "ImgSelected"):SetActiveEx(true)
    -- 颜色
    local curUIStyle = l_curStyleRow.Colour - 1
    for i = 0, l_UIBarberScroll.transform.childCount - 1 do
        local uiStyle = l_UIBarberScroll.transform:GetChild(i).gameObject
        FindObjectInChild(uiStyle, "TxSelected"):SetActiveEx(i == curUIStyle and true or false)
    end
end

function BarberShopCtrl:UpdateStyleTmp()
    self.notEnoughId = nil

    if l_curBarberTmp == nil then
        l_curStyleRowTmp = nil
        for i = 1, #self.panel.ImgCostIcon do
            self.panel.ImgCostIcon[i].gameObject:SetActiveEx(false)
        end
        self.panel.TxMoney.LabText = "0"
        -- 模型
        if MEntityMgr.PlayerEntity ~= nil and MEntityMgr.PlayerEntity.AttrComp ~= nil then
            MEntityMgr.PlayerEntity.AttrComp:SetHair(MPlayerInfo.HairStyle)
        end

        self.panel.ItemContent.gameObject:SetActiveEx(false)
    else
        local rows = l_curBarberTmp.styleRows
        for k, row in pairs(rows) do
            if row.Colour == l_curColorTmp then
                l_curStyleRowTmp = row
                break
            end
        end
        -- 消耗
        l_bagEnough = true
        local costs = {}
        if l_curStyleRow and l_curStyleRowTmp.Colour ~= l_curStyleRow.Colour then
            costs = Common.Functions.VectorSequenceToTable(l_curStyleRowTmp.ItemCost)
            l_tips = nil

            for i, v in ipairs(costs) do
                local itemId = v[1]
                local count = v[2]
                local itemRow = TableUtil.GetItemTable().GetRowByItemID(itemId)
                local propInfo = Data.BagModel:CreateItemWithTid(itemId)
                local l_bgAtlas = Data.BagModel:getItemBgAtlas(propInfo)
                local l_bgIcon = Data.BagModel:getItemBg(propInfo)
                self.panel.ImgCostIcon[i]:SetSprite(l_bgAtlas, l_bgIcon, true)
                self.panel.ImgCostIcon[i].gameObject:SetActiveEx(true)
                self.panel.ImgCost[i]:SetSpriteAsync(itemRow.ItemAtlas, itemRow.ItemIcon)
                local l_count = Data.BagApi:GetItemCountByContListAndTid(l_itemBag,itemId)
                self.panel.TxCost[i].LabText = tostring(l_count) .. "/" .. tostring(count)
                if count > l_count then
                    l_bagEnough = false
                    self.panel.TxCost[i].LabColor = l_red
                    if l_tips == nil then
                        l_tips = itemRow.ItemName
                    end
                    if self.notEnoughId == nil then
                        self.notEnoughId = itemId
                    end
                else
                    self.panel.TxCost[i].LabColor = l_green
                end
                self.panel.ImgCostIcon[i].gameObject:GetComponent("MLuaUICom"):AddClick(function()
                    MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(itemId, self.panel.ImgCostIcon[i].transform)
                end)
            end
        end
        for i = #costs + 1, #self.panel.ImgCostIcon do
            self.panel.ImgCostIcon[i].gameObject:SetActiveEx(false)
        end
        -- 钱
        l_moneyEnough = true
        l_zenyCost = 0
        if l_curBarberTmp ~= l_curBarber then
            local barberMoneySeq = Common.Functions.SequenceToTable(l_curBarberTmp.row.BarberPrice)
            l_zenyCost = l_zenyCost + barberMoneySeq[2]
        end
        if l_curStyleRow and l_curStyleRowTmp.Colour ~= l_curStyleRow.Colour then
            local styleMoneySeq = Common.Functions.SequenceToTable(l_curStyleRowTmp.MoneyCost)
            l_zenyCost = l_zenyCost + styleMoneySeq[2]
        end
        if MLuaCommonHelper.Long(l_zenyCost) > MPlayerInfo.Coin101 then
            l_moneyEnough = false
        end
        self.panel.Money.gameObject:SetActiveEx(not (l_zenyCost == 0))
        self.panel.TxMoney.LabText = tostring(l_zenyCost)
        if l_moneyEnough then
            self.panel.TxMoney.LabColor = Color.black
        else
            self.panel.TxMoney.LabColor = Color.red
        end

        self.panel.BtOp.gameObject:SetActiveEx(false)
        self.panel.BtOpGray.gameObject:SetActiveEx(false)
        self.panel.BtOpUnEnable.gameObject:SetActiveEx(false)

        -- if l_curStyleRowTmp.BarberStyleID ~= l_curStyleRow.BarberStyleID then
        -- local gray = (not Mgr.CheckLimit(l_curStyleRowTmp.BarberID) or not l_bagEnough or not l_moneyEnough)
        self.panel.BtOp.gameObject:SetActiveEx(Mgr.CheckLimit(l_curStyleRowTmp.BarberID))

        -- if gray then
        self.panel.BtOpGray.gameObject:SetActiveEx(not Mgr.CheckLimit(l_curStyleRowTmp.BarberID))

        -- end
        -- end

        -- 模型
        if MEntityMgr.PlayerEntity ~= nil and MEntityMgr.PlayerEntity.AttrComp ~= nil then
            MEntityMgr.PlayerEntity.AttrComp:SetHair(l_curStyleRowTmp.BarberStyleID)
        end
        -- l_bagEnough 材料满足条件时之前是不显示ItemContent这个框，现在是不管满不满足都要显示出来@韩艺鸣
        if Mgr.CheckLimit(l_curStyleRowTmp.BarberID) then
            self.panel.ItemContent.gameObject:SetActiveEx(true)
            self.panel.LockCondition.gameObject:SetActiveEx(false)
        else
            self.panel.ItemContent.gameObject:SetActiveEx(false)
            self.panel.LockCondition.gameObject:SetActiveEx(true)
            self.panel.UnlockItem.gameObject:SetActiveEx(false)
            self.panel.Money.gameObject:SetActiveEx(false)
        end
        if not Mgr.CheckLimit(l_curStyleRowTmp.BarberID) then
            local strTable = Mgr.GetLimitStr(l_curStyleRowTmp.BarberID)

            for i = 1, MgrMgr:GetMgr("BarberShopMgr").MaxLimitCondition do
                --logError(type(l_str_tbl[i]))
                if strTable[i] ~= nil and strTable[i].limitType ~= LimitMgr.ELimitType.UESITEM_LIMIT then
                    self:ProcessLimitGO(conditionGOTable[i].gameObject, strTable[i])
                else
                    conditionGOTable[i].gameObject:SetActiveEx(false)
                    if strTable[i] ~= nil and strTable[i].limitType == LimitMgr.ELimitType.UESITEM_LIMIT then
                        self:ProcessUesItemLimitGO(self.panel.UnlockItem.gameObject, strTable[i])
                    end
                end
            end
        end
    end
end
function BarberShopCtrl:ProcessUesItemLimitGO(gameObject, item)
    if item == nil or item.limitType ~= LimitMgr.ELimitType.UESITEM_LIMIT then
        return
    end
    gameObject:SetActiveEx(true)

    local isEnough = true
    local notisEnoughitemRow = nil
    for i = 1, #self.panel.UseCostIcon do
        if #item.UseItemSeq / 2 >= i then
            local itemId = item.UseItemSeq[i*2-1]
            local count = item.UseItemSeq[i*2]
            local itemRow = TableUtil.GetItemTable().GetRowByItemID(itemId)
            local propInfo = Data.BagModel:CreateItemWithTid(itemId)
            local l_bgAtlas = Data.BagModel:getItemBgAtlas(propInfo)
            local l_bgIcon = Data.BagModel:getItemBg(propInfo)
            self.panel.UseCostIcon[i]:SetSprite(l_bgAtlas, l_bgIcon, true)

            self.panel.UseCostIcon[i].gameObject:SetActiveEx(true)
            self.panel.UesImgCost[i]:SetSpriteAsync(itemRow.ItemAtlas, itemRow.ItemIcon)
            local l_count = Data.BagApi:GetItemCountByContListAndTid(l_itemBag
            ,itemId)
            if count > 100 then
                self.panel.UesTxCost[i].LabText = tostring(count)
            else
                self.panel.UesTxCost[i].LabText = tostring(l_count) .. "/" .. tostring(count)
            end
            if count > l_count then
                isEnough = false
                self.panel.UesTxCost[i].LabColor = l_red
                notisEnoughitemRow = itemRow
            else
                self.panel.UesTxCost[i].LabColor = l_green
            end
            self.panel.UseCostIcon[i].gameObject:GetComponent("MLuaUICom"):AddClick(function()
                MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(itemId, self.panel.UseCostIcon[i].transform)
            end)
        else
            self.panel.UseCostIcon[i].gameObject:SetActiveEx(false)
        end
    end
    self.panel.UnlockBt.gameObject:GetComponent("MLuaUICom"):AddClick(function ()
        --logError(tostring(isEnough))
        --logError(tostring(notisEnoughitemRow.ItemName))
        if isEnough == true then
            local itemRow = TableUtil.GetItemTable().GetRowByItemID(item.UseItemSeq[1])
            local txt = StringEx.Format(Common.Utils.Lang("UnLock_Hair_Bag"), item.UseItemSeq[2],itemRow.ItemName)
            CommonUI.Dialog.ShowYesNoDlg(true, nil, txt, function()
                Mgr.RequestUnlockHair(l_curBarberTmp.row.BarberID)
            end, function()
            end)
        else
            if notisEnoughitemRow ~= nil then
                MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(notisEnoughitemRow.ItemID, nil, nil, nil, true)
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(tostring(notisEnoughitemRow.ItemName) .. Common.Utils.Lang("CLICK_NOT_ENOUGH"))
            end
        end
    end)
    self.panel.UnlockBt_text.gameObject:GetComponent("MLuaUICom"):AddClick(function ()
        if isEnough == true then
            local itemRow = TableUtil.GetItemTable().GetRowByItemID(item.UseItemSeq[1])
            local txt = StringEx.Format(Common.Utils.Lang("UnLock_Hair_Bag"), item.UseItemSeq[2],itemRow.ItemName)
            CommonUI.Dialog.ShowYesNoDlg(true, nil, txt, function()
                Mgr.RequestUnlockHair(l_curBarberTmp.row.BarberID)
            end, function()
            end)
        else
            if notisEnoughitemRow ~= nil then
                MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(notisEnoughitemRow.ItemID, nil, nil, nil, true)
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(tostring(notisEnoughitemRow.ItemName) .. Common.Utils.Lang("CLICK_NOT_ENOUGH"))
            end
        end
    end)
end
function BarberShopCtrl:ProcessLimitGO(gameObject, item)
    gameObject:SetActiveEx(true)
    local text = FindObjectInChild(gameObject, "Txt")
    MLuaClientHelper.GetOrCreateMLuaUICom(text.transform).LabText = item.str
    local lockImg = FindObjectInChild(gameObject, "Lock")
    local goBtn = FindObjectInChild(gameObject, "GO")
    local finishImg = FindObjectInChild(gameObject, "Finish")
    goBtn:SetActiveEx(not item.finish)
    lockImg:SetActiveEx(not item.finish)
    finishImg:SetActiveEx(item.finish)

    goBtn:GetComponent("MLuaUICom"):AddClick(function()
        if item.limitType == LimitMgr.ELimitType.LEVEL_LIMIT then
            UIMgr:ActiveUI(UI.CtrlNames.ItemAchieveTipsNew, function()
                local l_ui = UIMgr:GetUI(UI.CtrlNames.ItemAchieveTipsNew)
                if l_ui then
                    l_ui:InitItemAchievePanelByItemId(tonumber(201))
                end
            end)
        elseif item.limitType == LimitMgr.ELimitType.ENTITY_LIMIT then
            -- else if item.limitType == MgrMgr:GetMgr("HeadShopMgr").ELimitType.LEVEL_LIMIT then
        elseif item.limitType == LimitMgr.ELimitType.COLLECTION_LIMIT then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("COLLECTION_LIMITStr"))
        elseif item.limitType == LimitMgr.ELimitType.ACHIEVEMENTPOINT_LIMIT then
            MgrMgr:GetMgr("AchievementMgr").OpenAchievementPanel()
        elseif item.limitType == LimitMgr.ELimitType.ACHIEVEMENT_LIMIT then
            MgrMgr:GetMgr("AchievementMgr").OpenAchievementPanel(item.AchievementId)
        elseif item.limitType == LimitMgr.ELimitType.TASK_LIMIT then
            if item.task ~= nil then
                if item.task.minBaseLevel > 0 then
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Common.Utils.Lang("TASK_LIMITStr"), item.task.minBaseLevel, item.task.typeTitle, item.task.name))
                else
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Common.Utils.Lang("TASK_LIMIT"), item.task.typeTitle, item.task.name))
                end
            end
        elseif item.limitType == LimitMgr.ELimitType.ACHIEVEMENTLEVEL_LIMIT then
            MgrMgr:GetMgr("AchievementMgr").OpenAchievementPanel()
        end
    end)
end
function BarberShopCtrl:OnUnlockHair(d)
    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("UNLOCKED")..l_curBarberTmp.row.BarberName)
    LimitMgr.AddInhairs(l_curBarberTmp.row.BarberID)

    local LockGO = FindObjectInChild(l_barberInfo[l_barberIdToIdx[l_curBarberTmp.row.BarberID]].uobj.gameObject, "NotAward")
    LockGO.gameObject:SetActiveEx(not Mgr.CheckLimit(l_curBarberTmp.row.BarberID))

    self:OnChangeHair(d)
end
function BarberShopCtrl:OnChangeHair(d)
    self:UpdateCurHair()
    self:UpdateStyleTmp()
    self:PlayFx()
end

function BarberShopCtrl:InitSilder()
    local l_slider = self.panel.SliderCameraSize.gameObject:GetComponent("Slider")
    l_slider.enabled = true
    if Mgr.m_sliderValue > 0 then
        l_slider.value = Mgr.m_sliderValue
        self.SliderValue = Mgr.m_sliderValue
    else
        l_slider.value = 1
        self.SliderValue = 1
    end
    self.panel.SliderCameraSize:OnSliderChange(function(v)
        if math.abs(self.SliderValue - v) > 0.05 then
            MPlayerInfo:FocusOffSetValueUpdate(v)
            self.SliderValue = 1 - v
        end
    end)
end

function BarberShopCtrl:PlayFx()
    self:ClearFx()
    local player = MEntityMgr.PlayerEntity
    if player == nil then
        return
    end
    local fxData = MFxMgr:GetDataFromPool()
    fxData.layer = player.Model.Layer
    l_fx = player.Model:CreateFx(FxID, EModelBone.EHelmet, fxData)
    self:SaveEffetcData(l_fx)
    MFxMgr:ReturnDataToPool(fxData)
end

function BarberShopCtrl:ClearFx()
    if l_fx ~= nil then
        self:DestroyUIEffect(l_fx)
        l_fx = nil
    end
end

--lua custom scripts end

return BarberShopCtrl
