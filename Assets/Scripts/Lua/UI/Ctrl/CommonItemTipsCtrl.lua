--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/CommonItemTipsPanel"
require "Data/Model/BagModel"
require "TableEx/ItemSwitchTable"
require "TableEx/ItemForgeTable"
require "TableEx/ItemCardTable"
require "TableEx/ItemEnchantTable"
require "TableEx/ItemRefineTable"
require "TableEx/ItemMaterialsTable"
require "TableEx/NpcDataTable"
require "TableEx/ItemProOffLineMap"
require "TableEx/ItemBeiluzResetTable"
require "TableEx/EnchantRebornConsumeOffLine"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--eventsystem
local l_pointEventData
local l_eventSystem
local l_pointRes
--eventsystem end

--lua class define
local super = UI.UIBaseCtrl
CommonItemTipsCtrl = class("CommonItemTipsCtrl", super)

--- 用于处理目标槽位的装备的
local EEquipTipsStatus = Data.BagModel.WeaponStatus
--lua class define end

--lua functions
function CommonItemTipsCtrl:ctor()
    super.ctor(self, CtrlNames.CommonItemTips, UILayer.Tips, nil, ActiveType.Standalone)
end --func end

--next--
function CommonItemTipsCtrl:Init()
    --todo 层级
    self.panel = UI.CommonItemTipsPanel.Bind(self)
    super.Init(self)

    self.OnWearEquipMethod = nil    --存储一个装备武器的Function
    self.isMoreBtnClick = 0         --以下两个参数用于创建更多按钮
    self.btnParentOffestY = 0
    self.mainItemUid = 0            --这个参数可以删除 暂时先放着 用于存储当前Item的Id

    --以下赋值事件系统
    l_eventSystem = EventSystem.current
    l_pointEventData = PointerEventData.New(l_eventSystem)
    l_pointRes = RaycastResultList.New()

    --初始化3个Tips的Obj
    self.TipsInfo = { { data = {} }, { data = {} }, { data = {} } }

    --关闭按钮方法赋值
    self.panel.CloseButton:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.CommonItemTips)
    end)
end

--next--
function CommonItemTipsCtrl:Uninit()
    super.Uninit(self)
    self.panel = nil

    if self.delayAdaptTipsTimer ~= nil then
        self:StopUITimer(self.delayAdaptTipsTimer)
        self.delayAdaptTipsTimer = nil
    end

    self.isMoreBtnClick = 0
end --func end

--next--
function CommonItemTipsCtrl:OnActive()
    MgrMgr:GetMgr("ItemTipsMgr").SortItemUsefulAndPathCommonTips()
end --func end
--next--
function CommonItemTipsCtrl:OnDeActive()
    self:UnloadAllUI()
end --func end

function CommonItemTipsCtrl:UpdateInput(touchItem)
    if self.panel == nil then
        return
    end

    if l_pointEventData == nil or l_eventSystem == nil then
        return
    end

    if UIMgr:IsActiveUI(UI.CtrlNames.CommonItemTips) ~= true then
        return
    end

    if tostring(touchItem.Phase) ~= "Began" then
        return
    end

    l_pointRes:Clear()
    l_pointEventData.position = touchItem.Position
    l_eventSystem:RaycastAll(l_pointEventData, l_pointRes)

    local l_isTips = false --用于保存是否会打开Tips
    local l_isAchieveTips = false --用于保存点到的界面是不是获取途径界面

    for i = 0, l_pointRes.Count - 1 do
        local l_go = l_pointRes[i].gameObject
        local l_com = l_go:GetComponent("MLuaUICom")
        l_isTips = self:CheckIsCanOpenTips(l_go, l_com)

        if not l_isAchieveTips then
            --如果点击到获取途径不再赋值
            l_isAchieveTips = self:CheckIsAchieveTips(l_go)
        end

        if l_isTips == true then
            self:DoIsTips(l_isTips, l_isAchieveTips)
            break
        end
    end

    if l_isTips == false then
        self:DoIsTips(l_isTips, l_isAchieveTips)
    end
end --func end

--检测点击到的物体会不会打开Tips 需要维护
function CommonItemTipsCtrl:CheckIsCanOpenTips(go, com)
    local l_go = go
    local l_com = com

    local C_COMP_VALID_NAMES = {
        ["CommonItemTipsBaseObj"] = "CommonItemTipsBaseObj",
        ["ImgTipBg"] = "ImgTipBg",
        ["ImgPropBg"] = "ImgPropBg",
        ["ImgPotBg"] = "ImgPotBg",
        ["BtnFstUse"] = "BtnFstUse",
        ["BtnToPot"] = "BtnToPot",
        ["BtnToProp"] = "BtnToProp",
        ["ItemButton"] = "ItemButton",
    }

    local C_GO_VALID_NAMES = {
        ["KeyboardNumber"] = "KeyboardNumber",
        ["CloseKeyboardButton"] = "CloseKeyboardButton",
    }

    if l_com ~= nil and nil ~= C_COMP_VALID_NAMES[l_com.Name] then
        return true
    end

    if l_go ~= nil and nil ~= C_GO_VALID_NAMES[l_go.name] then
        return true
    end

    return false
end

function CommonItemTipsCtrl:CheckIsAchieveTips(go)
    local l_go = go
    local C_VALID_NAMES = {
        ["ItemAchievePanel"] = "ItemAchievePanel",
        ["TargetPanel"] = "TargetPanel",
        ["ItemAchieveTpl"] = "ItemAchieveTpl",
        ["ItemAchieveTargetTpl"] = "ItemAchieveTargetTpl",
    }

    local ret = nil ~= l_go and nil ~= C_VALID_NAMES[l_go.name]
    return ret
end

function CommonItemTipsCtrl:DoIsTips(isShowTips, isAchieveTips)
    if not isShowTips then
        --如果点击的不可打开Tips 则关闭两个Tips界面
        if isAchieveTips then
            --如果打开的是AchieveTips 不做操作
            return
        end

        local l_ui_CommonItemTips = UIMgr:GetUI(UI.CtrlNames.CommonItemTips)
        local l_ui_ItemAchieveTips = UIMgr:GetUI(UI.CtrlNames.ItemAchieveTipsNew)
        local l_ui_SkillAttr = UIMgr:GetUI(UI.CtrlNames.SkillAttr)
        if l_ui_CommonItemTips then
            UIMgr:DeActiveUI(UI.CtrlNames.CommonItemTips)
        end
        if l_ui_ItemAchieveTips then
            UIMgr:DeActiveUI(UI.CtrlNames.ItemAchieveTipsNew)
        end
        if l_ui_SkillAttr then
            UIMgr:DeActiveUI(UI.CtrlNames.SkillAttr)
        end
    else
        if not isAchieveTips then
            local l_ui_ItemAchieveTips = UIMgr:GetUI(UI.CtrlNames.ItemAchieveTipsNew)
            if l_ui_ItemAchieveTips then
                UIMgr:DeActiveUI(UI.CtrlNames.ItemAchieveTipsNew)
            end
        end
    end
end

--next--
function CommonItemTipsCtrl:Update()
    -- do nothing
end --func end

function CommonItemTipsCtrl:BindEvents()
    local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
    self:BindEvent(gameEventMgr.l_eventDispatcher, gameEventMgr.EquipAttrSwapConfirm, self._onAttrSwap)
end

function CommonItemTipsCtrl:_onAttrSwap()
    local tipsMgr = MgrMgr:GetMgr("TipsMgr")
    tipsMgr.ShowNormalTips(Common.Utils.Lang("C_EQUIP_ATTR_SWAP"))
    self:HideTips()
end

---@param itemData ItemData
function CommonItemTipsCtrl:ShowDisplay(itemData, relativeTransform, propStatus, extraData, ButtonStatus)
    if itemData == nil then
        return
    end
    if itemData.TID == MgrMgr:GetMgr("PropMgr").PotionSettingItemId then
        local l_beginnerGuideChecks = { "GetAutoDevOpenTip" }
        MgrMgr:GetMgr("BeginnerGuideMgr").CheckShowBeginnerGuide(l_beginnerGuideChecks, self:GetPanelName())
    end
    if propStatus == Data.BagModel.WeaponStatus.Gift or
            propStatus == Data.BagModel.WeaponStatus.TO_POT or
            propStatus == Data.BagModel.WeaponStatus.TO_PROP then
        ButtonStatus = Data.BagModel.ButtonStatus.NoShow
    end

    --如果没有设置Tips的显示类型 默认为普通道具类型
    if propStatus == nil then
        propStatus = Data.BagModel.WeaponStatus.NORMAL_PROP
    end

    --以下为配置表数据
    local equipTableInfo = itemData.EquipConfig
    local itemTableInfo = itemData.ItemConfig
    local itemFunctionInfo = itemData.ItemFunctionConfig

    --设置当前显示的Tips的数据
    self:ClearTipsData()
    self.TipsInfo[1].data = {
        baseData = itemData,
        equipTableData = equipTableInfo,
        itemTableData = itemTableInfo,
        itemFunctionData = itemFunctionInfo,
        equipStatus = propStatus,
        buttonStatus = ButtonStatus,
    }

    --设置关闭
    self.panel.CloseButton.gameObject:SetActiveEx(false)
    self:RefreshTipsUI()

    --策划要求 背包内的Tips基础显示固定位置 @韩艺鸣
    if propStatus == Data.BagModel.WeaponStatus.TO_USE
            or propStatus == Data.BagModel.WeaponStatus.TO_POT
            or propStatus == Data.BagModel.WeaponStatus.EXTRACT_CARD
            or propStatus == Data.BagModel.WeaponStatus.Gift then
        self.TipsInfo[1].ui.transform.anchoredPosition = Vector2.New(-190, 0)
    elseif propStatus == Data.BagModel.WeaponStatus.TO_PROP
            or propStatus == Data.BagModel.WeaponStatus.RECOVE_CARD then
        self.TipsInfo[1].ui.transform.anchoredPosition = Vector2.New(190, 0)
    elseif propStatus == Data.BagModel.WeaponStatus.CHOOSE_GIFT then
        self.TipsInfo[1].ui.transform.anchoredPosition = Vector2.New(-385, 0)
    else
        local dataTb = {}
        dataTb.TipsTransform = self.TipsInfo[1].ui.transform
        dataTb.RelativeTransform = relativeTransform
        dataTb.OffsetLeft = 221
        dataTb.OffsetRight = 222
        dataTb.extraData = extraData
        MgrMgr:GetMgr("ItemTipsMgr").SelfAdaptionTips(dataTb)
    end
end

function CommonItemTipsCtrl:RefreshTipsUI(showNum, additionalData)
    self.panel.TipsPanel.gameObject:SetActiveEx(true)
    if additionalData ~= nil then
        self:SetShowCloseButton(additionalData.IsShowCloseButton)
        self:SetWearEquipMethod(additionalData.WearEquipMethod)
    end

    local createNum = 1
    local propStatus = self.TipsInfo[1].data and self.TipsInfo[1].data.equipStatus
    if not propStatus then
        logError("未找到propStatus 初始化itemtip数据错误")
        return
    end

    if propStatus == Data.BagModel.WeaponStatus.JUST_COMPARE
            or propStatus == Data.BagModel.WeaponStatus.JUST_COMPARE_ORNAMENT1
            or propStatus == Data.BagModel.WeaponStatus.JUST_COMPARE_ORNAMENT2
            or propStatus == Data.BagModel.WeaponStatus.JUST_COMPARE_Dagger1
            or propStatus == Data.BagModel.WeaponStatus.JUST_COMPARE_Dagger2 then
        createNum = 3
    end

    for i = 1, createNum do
        local originData = self.TipsInfo[i].data
        self.TipsInfo[i] = self.TipsInfo[i].template or self:NewTemplate("CommonItemTipsBaseTemplent", { TemplateParent = self.panel.TipsPanel.transform })
        self.TipsInfo[i].template = self.TipsInfo[i]
        self.TipsInfo[i].ui = self.TipsInfo[i]:gameObject()
        self.TipsInfo[i].ui.transform:SetLocalScaleOne()
        self.TipsInfo[i].ui.transform.anchoredPosition = Vector3.New(-300, 0, 0)
        self.TipsInfo[i].ui.gameObject.name = "TipsTpl" .. "_" .. tostring(i)
        self.TipsInfo[i].data = originData
        self.TipsInfo[i].template:SetData(self.TipsInfo[i])
    end

    local l_startPos = -190
    local l_gap = 380
    if showNum == 1 then
        if propStatus == Data.BagModel.WeaponStatus.ON_BODY then
            self.TipsInfo[1].data.buttonStatus = Data.BagModel.ButtonStatus.Show
            l_startPos = 225
        end
    elseif showNum == 2 then
        l_startPos = -190
        l_gap = 380
    elseif showNum == 3 then
        l_startPos = -360
        l_gap = 360
    end

    for i = 1, #self.TipsInfo do
        if self.TipsInfo[i].ui and nil ~= self.TipsInfo[i].data.baseData then
            self.TipsInfo[i].ui:SetActiveEx(i <= createNum)
            self.TipsInfo[i].template:FillOneItemInfo(self.TipsInfo[i])

            --- 原本是调用的eComp，判断非常模糊，一般额道具也可能有eComp
            if 0 ~= self.TipsInfo[i].data.baseData.UID
                    or self.TipsInfo[i].data.additionalData ~= nil
                    or self.TipsInfo[i].data.equipStatus == Data.BagModel.WeaponStatus.FISH_PROP
            then
                self:SetPurchasePrice(self.TipsInfo[i])
                self.buttonstatus = self:FillItemButton(self.TipsInfo[i])
                local buttonTem = self:CreateSetButtonTemplent(self.TipsInfo[i], "buttonTem")
                buttonTem:CreatePanelBtnByButtonDates(buttonTem, self.buttonstatus, self.TipsInfo[i].data.baseData)
            end

            self.TipsInfo[i].ui.transform.anchoredPosition = Vector3.New(l_startPos + (i - 1) * l_gap, 0, 0)
            --对比不显示获取 不现实超链接
            if showNum and showNum > 1 then
                self.TipsInfo[i].btnHuoqu.gameObject:SetActiveEx(false)
                self.TipsInfo[i].TxtHref.gameObject:SetActiveEx(false)
            end
        else
            if self.TipsInfo[i].ui then
                self.TipsInfo[i].ui:SetActiveEx(false)
            end
        end
    end
end

--设置按钮信息
function CommonItemTipsCtrl:FillItemButton(oneItem)
    local buttonDatas = {}
    --主要操作按钮
    if oneItem.data.equipStatus == Data.BagModel.WeaponStatus.IN_BAG then
        --设置鉴定
        --设置装备按钮相关
        self:CreateEquipBtn(oneItem, buttonDatas)

        --头饰分解按钮
        self:CreateHeadRecoveBtn(oneItem, buttonDatas)
        --装备分解按钮
        self:CreateEquipRecoveBtn(oneItem, buttonDatas)
    elseif oneItem.data.equipStatus == Data.BagModel.WeaponStatus.NORMAL_PROP then
        --不显示按钮界面
        return
    elseif oneItem.data.equipStatus == Data.BagModel.WeaponStatus.ON_BODY then
        --身上卸下按钮
        self:CreateEquipUnLoadBtn(oneItem, buttonDatas)
    elseif oneItem.data.equipStatus == Data.BagModel.WeaponStatus.JUST_COMPARE then
        --已装备小Tips
        oneItem.imageEquipFlag:SetActiveEx(true)
        self:_createAttrSwapBtn(oneItem, buttonDatas)
    elseif oneItem.data.equipStatus == Data.BagModel.WeaponStatus.JUST_COMPARE_ORNAMENT1
            or oneItem.data.equipStatus == Data.BagModel.WeaponStatus.JUST_COMPARE_ORNAMENT2 then
        --已装备小Tips
        oneItem.imageEquipFlag:SetActiveEx(true)
        --创建装备替换按钮
        self:CreateEquipReplaceBtn(oneItem, buttonDatas)
        self:_createAttrSwapBtn(oneItem, buttonDatas)
    elseif oneItem.data.equipStatus == Data.BagModel.WeaponStatus.JUST_COMPARE_Dagger1
            or oneItem.data.equipStatus == Data.BagModel.WeaponStatus.JUST_COMPARE_Dagger2 then
        --已装备小Tips
        oneItem.imageEquipFlag:SetActiveEx(true)
        --创建装备替换按钮
        self:CreateEquipReplaceBtnTem(oneItem, buttonDatas)
        self:_createAttrSwapBtn(oneItem, buttonDatas)
    elseif oneItem.data.equipStatus == Data.BagModel.WeaponStatus.TO_POT then
        --创建存入手推车和存入仓库的按钮
        self:CreateInToBarrowOrIntoWarehouseBtn(oneItem, buttonDatas)
    elseif oneItem.data.equipStatus == Data.BagModel.WeaponStatus.TO_PROP then
        --创建取出到背包的按钮
        self:CreateInToBackPackBtn(oneItem, buttonDatas)
    elseif oneItem.data.equipStatus == Data.BagModel.WeaponStatus.TO_USE then
        self:CreateEquipItemResolveBtn(oneItem, buttonDatas)
        --锻造
        self:CreateForgeBtn(oneItem, buttonDatas)
        --兑换按钮
        self:CreateSwitchBtn(oneItem, buttonDatas)
        self:CreateCardExchangeBtn(oneItem, buttonDatas)
        --打洞材料
        self:CreateMakeHoleBtn(oneItem, buttonDatas)
        ----重铸材料
        --self:CreateReforgeBtn(oneItem, buttonDatas)
        ----装备改造
        --self:CreateReformBtn(oneItem, buttonDatas)
        --附魔
        self:CreateEnchantBtn(oneItem, buttonDatas)
        --精炼
        self:CreateRefineBtn(oneItem, buttonDatas)
        -- 附魔继承耗材
        self:CreateEnchantInheritConsumeBtn(oneItem, buttonDatas)
        -- 提炼耗材
        self:CreateEnchantExtractBtn(oneItem, buttonDatas)
        --精炼转移
        self:CreateRefineTransferBtn(oneItem, buttonDatas)
        --精炼解封
        self:CreateRefineUnsealBtn(oneItem, buttonDatas)

        --交付
        self:CreateGiveToGuildBtn(oneItem, buttonDatas)
        --卡片相关按钮
        self:CreateCardRelateBtn(oneItem, buttonDatas)
        --使用按钮创建
        self:CreateOnUseBtn(oneItem, buttonDatas)
        --卡片抽取按钮
        self:CreateExtractCardBtn(oneItem, buttonDatas)
        --头饰抽取按钮
        self:CreateExtractHeadBtn(oneItem, buttonDatas)
        --装备抽取按钮
        self:CreateExtractEquipBtn(oneItem, buttonDatas)
        --合成
        self:CreateCompoundBtn(oneItem, buttonDatas)
        --找npc
        self:CreateUseFindnpcBtn(oneItem, buttonDatas)
    elseif oneItem.data.equipStatus == Data.BagModel.WeaponStatus.FISH_PROP then
        --钓鱼使用按钮
        self:CreateOnFishUseBtn(oneItem, buttonDatas)
    elseif oneItem.data.equipStatus == Data.BagModel.WeaponStatus.TO_SHOP then
        --商店Tips屏蔽获取按钮
        buttonDatas = self:CreateShopBtn(oneItem)
        --获取按钮屏蔽
        oneItem.btnHuoqu.gameObject:SetActiveEx(false)
    elseif oneItem.data.equipStatus == Data.BagModel.WeaponStatus.TO_MERCHANT then
        buttonDatas = self:CreateMerchantBtn(oneItem)
        --获取按钮屏蔽
        oneItem.btnHuoqu.gameObject:SetActiveEx(false)

        do
            return buttonDatas
        end
    elseif oneItem.data.equipStatus == Data.BagModel.WeaponStatus.TO_MERCHANT_SELL then
        buttonDatas = self:CreateMerchantToSellBtn(oneItem)
        --获取按钮屏蔽
        oneItem.btnHuoqu.gameObject:SetActiveEx(false)
    end

    --以下处理副按钮
    if oneItem.data.buttonStatus == Data.BagModel.ButtonStatus.Show then
        --摆摊按钮
        self:CreateShopStallBtn(oneItem, buttonDatas)
        --商会按钮
        self:CreateShopTradeBtn(oneItem, buttonDatas)
        -- 黑市按钮
        self:CreateBlackShopBtn(oneItem, buttonDatas)
        --装备插卡
        self:CreateEquipCardBtn(oneItem, buttonDatas)
        --装备附魔
        self:CreateEquipEnchantBtn(oneItem, buttonDatas)
        --装备精炼
        self:CreateEquipRefineBtn(oneItem, buttonDatas)
        --道具回收
        self:CreateItemSellBtn(oneItem, buttonDatas)
        --装备置换
        self:CreateReplaceItemPropertyBtn(oneItem, buttonDatas)
        -- 装备附魔继承
        self:CreateEnchantEquipInheritBtn(oneItem, buttonDatas)
        -- 解封按钮
        self:CreateUnsealCardBtn(oneItem, buttonDatas)
        --装备改造
        self:CreateReformBtn(oneItem, buttonDatas)
        -- 贝鲁兹合成、重置按钮
        self:CreateBeiluzBtn(oneItem, buttonDatas)
        -- 装备碎片兑换
        self:CreateEquipShardExchangeBtn(oneItem, buttonDatas)
    end

    return buttonDatas
end

function CommonItemTipsCtrl:CreateEquipItemResolveBtn(oneItem, buttonDatas)
    ---@type ItemData
    local itemData = oneItem.data.baseData
    --- 这里做个标记，这个按钮仅限于装备图纸才会出现，装备图纸的subclaxx
    if GameEnum.EItemType.BluePrint ~= itemData.ItemConfig.TypeTab then
        return
    end

    local config = TableUtil.GetItemResolveTable().GetRowByID(itemData.TID, true)
    if nil == config then
        return
    end

    self:AddButtonData(buttonDatas, Common.Utils.Lang("C_RESOLVE_ITEM"), function()
        game:ShowMainPanel()
        MgrMgr:GetMgr("ItemResolveMgr").MgrObj:TryResolveItem(itemData)
    end)
end

--创建装备按钮
function CommonItemTipsCtrl:CreateEquipBtn(oneItem, buttonDatas)
    --判断是否在身上
    local l_isBody = MgrMgr:GetMgr("EquipMgr").CheckEquipIsBody(oneItem.data.baseData.UID)
    --背包中的道具 以下设置装备按钮
    if not l_isBody then
        self:AddButtonData(buttonDatas, Common.Utils.Lang("ATTR_EQUIP_NAME"), function()
            local l_eId = oneItem.data.equipTableData.EquipId
            local l_pos = Data.BagModel.WeapTableType[l_eId]
            if l_pos == EquipPos.SECONDARY_WEAPON then
                CommonUI.Dialog.ShowYesNoDlg(true, nil, Common.Utils.Lang("CommonTips_EquipSecondaryWeaponText"), function()
                    self:EquipItem(oneItem.data.baseData)
                end, function()
                end, nil, 2, "CommonTips_EquipSecondaryWeapon")
            else
                self:EquipItem(oneItem.data.baseData)
            end
        end)
    end
end

---@param propInfo ItemData
function CommonItemTipsCtrl:EquipItem(propInfo)
    if nil == propInfo then
        return
    end

    if self.OnWearEquipMethod ~= nil then
        self.OnWearEquipMethod()
    end

    local l_row = propInfo.EquipConfig
    local l_eId = l_row.EquipId
    local l_weaponId = l_row.WeaponId
    local l_pos = Data.BagModel:getWeapAdornPos(l_eId, l_weaponId)
    Data.BagApi:ReqSwapItem(propInfo.UID, GameEnum.EBagContainerType.Equip, l_pos, 1)
    self:HideTips()
end

--创建卸下装备按钮
function CommonItemTipsCtrl:CreateEquipUnLoadBtn(oneItem, buttonDatas)
    oneItem.imageEquipFlag:SetActiveEx(true)
    --手推车 战斗载具 战斗宠物 特殊处理 不显示卸下 只显示打开手推车和前往Npc
    local state1 = self:CreateBarrowBtn(oneItem, buttonDatas)
    local state2 = self:CreateBattleVehicleBtn(oneItem, buttonDatas)
    local state3 = self:CreateBattleBirdBtn(oneItem, buttonDatas)
    if state1 or state2 or state3 then
        return
    end

    self:AddButtonData(buttonDatas, Common.Utils.Lang("EQUIP_UNLOAD"), function()
        local l_info = oneItem.data.baseData
        if l_info == nil then
            self:HideTips()
            return
        end

        Data.BagApi:ReqSwapItem(l_info.UID, GameEnum.EBagContainerType.Bag, nil, nil)
        self:HideTips()
    end)
end

--- 创建一键替换按钮
--- 这个是反向取的，按钮出现在装备位的tips上，因为可能会出现两个一样的饰品或者副手武器
function CommonItemTipsCtrl:_createAttrSwapBtn(oneItem, buttonDatas)
    if nil == oneItem or nil == buttonDatas then
        logError("[ItemTips] invalid param")
        return
    end

    --- 如果功能没开，直接屏蔽
    local openSysMgr = MgrMgr:GetMgr("OpenSystemMgr")
    if not openSysMgr.IsSystemOpen(openSysMgr.eSystemId.EquipSwapAttr) then
        return
    end

    ---@type ItemData
    local targetItem = nil
    for i = 1, #self.TipsInfo do
        local singleItemData = self.TipsInfo[i].data.baseData
        local status = self.TipsInfo[i].data.equipStatus
        if nil ~= singleItemData and EEquipTipsStatus.IN_BAG == status then
            targetItem = singleItemData
            break
        end
    end

    if nil == targetItem then
        return
    end

    ---@type ItemData
    local currentItem = oneItem.data.baseData
    if targetItem.TID ~= currentItem.TID then
        return
    end

    --- 如果当前装备被强化过，而且目标装备没有被强化过的情况下，会显示按钮
    if targetItem:EquipEnhanced() or not currentItem:EquipEnhanced() then
        return
    end

    local onClick = function()
        local itemContMgr = MgrMgr:GetMgr("ItemContainerMgr")
        itemContMgr.ReqSameTIDItemInherit(currentItem.UID, targetItem.UID)
    end

    local onConfirm = function()
        local togType = GameEnum.EDialogToggleType.NoHintBothWay
        CommonUI.Dialog.ShowYesNoDlg(true, nil, Common.Utils.Lang("C_QUICK_SWAP_ATTR_CONFIRM"), onClick, nil, nil, togType, "EquipAssistant_DealWithTips")
    end

    self:AddButtonData(buttonDatas, Common.Utils.Lang("C_QUICK_SWAP_ATTR"), onConfirm)
end

--创建装备替换按钮
function CommonItemTipsCtrl:CreateEquipReplaceBtn(oneItem, buttonDatas)
    self:AddButtonData(buttonDatas, Common.Utils.Lang("EQUIP_REPLACE"), function()
        local l_pos = EquipPos.ORNAMENT2
        if oneItem.data.equipStatus == Data.BagModel.WeaponStatus.JUST_COMPARE_ORNAMENT1 then
            l_pos = EquipPos.ORNAMENT1
        end

        if self.mainItemUid ~= nil and self.mainItemUid ~= 0 then
            Data.BagApi:ReqSwapItem(self.mainItemUid, GameEnum.EBagContainerType.Equip, l_pos, 1)
        end

        self:HideTips()
    end)
end

function CommonItemTipsCtrl:CreateEquipReplaceBtnTem(oneItem, buttonDatas)
    self:AddButtonData(buttonDatas, Common.Utils.Lang("EQUIP_REPLACE"), function()
        local l_pos = EquipPos.SECONDARY_WEAPON
        if oneItem.data.equipStatus == Data.BagModel.WeaponStatus.JUST_COMPARE_Dagger1 then
            l_pos = EquipPos.MAIN_WEAPON
        elseif oneItem.data.equipStatus == Data.BagModel.WeaponStatus.JUST_COMPARE_Dagger2 then
            l_pos = EquipPos.SECONDARY_WEAPON
        end

        if self.mainItemUid ~= nil and self.mainItemUid ~= 0 then
            Data.BagApi:ReqSwapItem(self.mainItemUid, GameEnum.EBagContainerType.Equip, l_pos, 1)
        end

        self:HideTips()
    end)
end

---@return ItemData
function CommonItemTipsCtrl:_getItemByUID(uid)
    if nil == uid then
        logError("[ItemMgr] uid got nil")
        return nil
    end

    local types = { GameEnum.EBagContainerType.Bag }
    local itemFuncUtil = MgrProxy:GetItemDataFuncUtil()
    ---@type FiltrateCond
    local condition = { Cond = itemFuncUtil.IsItemUID, Param = uid }
    local conditions = { condition }
    local ret = Data.BagApi:GetItemsByTypesAndConds(types, conditions)
    return ret[1]
end

--创建存入手推车和存入仓库的按钮
function CommonItemTipsCtrl:CreateInToBarrowOrIntoWarehouseBtn(oneItem, buttonDatas)
    local l_openModel = Data.BagModel:getOpenModel()
    local ButtonTxt = l_openModel == Data.BagModel.OpenModel.Car and Common.Utils.Lang("INTO_BARROW") or Common.Utils.Lang("INTO_WAREHOUSE")
    local l_info = oneItem.data.baseData
    if l_info == nil then
        return
    end

    local setNumTemplent = self:CreateSetNumTemplent(oneItem, "GetItemFormBarrow")
    setNumTemplent:SetInfo(Common.Utils.Lang("TOTAL_NUM"), l_info.ItemCount, 1, l_info.ItemCount)
    self:AddButtonData(buttonDatas, ButtonTxt, function()
        local l_isTalentEquip, l_name, l_c = MgrProxy:GetMultiTalentEquipMgr().IsInMultiTalentEquip(l_info)
        if l_openModel == Data.BagModel.OpenModel.Car then
            if l_isTalentEquip then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Common.Utils.Lang("MultiTalent_EquipCantChangeWithCar"), l_name))
            else
                local moveCount = MLuaCommonHelper.Long2Int(setNumTemplent:GetNumComponentValue())
                Data.BagApi:ReqSwapItem(l_info.UID, GameEnum.EBagContainerType.Cart, nil, moveCount)
            end
        else
            if l_isTalentEquip then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Common.Utils.Lang("MultiTalent_EquipCantChangeWithWareHouse"), l_name))
            else
                local moveCount = MLuaCommonHelper.Long2Int(setNumTemplent:GetNumComponentValue())
                MgrMgr:GetMgr("ItemContainerMgr").TryPutItemToWareHouse(l_info, moveCount)
            end
        end

        self:HideTips()
    end)
end

--创建取出到背包的按钮
function CommonItemTipsCtrl:CreateInToBackPackBtn(oneItem, buttonDatas)
    ---@type ItemData
    local l_info = oneItem.data.baseData
    local setNumTemplent = self:CreateSetNumTemplent(oneItem, "GetItemFormBag")
    setNumTemplent:SetInfo(Common.Utils.Lang("TOTAL_NUM"), l_info.ItemCount, 1, l_info.ItemCount)
    self:AddButtonData(buttonDatas, Common.Utils.Lang("INTO_BACKPACK"), function()
        local moveCount = MLuaCommonHelper.Long2Int(setNumTemplent:GetNumComponentValue())
        Data.BagApi:ReqSwapItem(l_info.UID, GameEnum.EBagContainerType.Bag, nil, moveCount)
        self:HideTips()
    end)
end

--创建手推车按钮
function CommonItemTipsCtrl:CreateBarrowBtn(oneItem, buttonDatas)
    --手推车判断
    ---@type ItemData
    local l_info = oneItem.data.baseData
    local l_row = l_info.EquipConfig
    if l_row and l_row.EquipId == EquipPos.TROLLEY then
        --切换外观
        self:AddButtonData(buttonDatas, Common.Utils.Lang("BARROW_CHANGE_APPEARANCE"), function()
            --寻路成功才关闭对应界面
            local l_result = Common.CommonUIFunc.InvokeFunctionByFuncId(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.TrolleyFuncId, nil, true)
            if l_result then
                self:HideTips()
                self:HideBag()
            end
        end)
        --打开手推车
        self:AddButtonData(buttonDatas, Common.Utils.Lang("OPEN_BARROW"), function()
            local l_ui = UIMgr:GetUI(UI.CtrlNames.Bag)
            if l_ui then
                l_ui:SetToBarrowCar()
            end
            self:HideTips()
        end)
        return true
    else
        return false
    end

    return false
end

--创建战斗坐骑按钮
function CommonItemTipsCtrl:CreateBattleVehicleBtn(oneItem, buttonDatas)
    ---@type ItemData
    local l_info = oneItem.data.baseData
    local l_row = l_info.EquipConfig
    if l_row and l_row.EquipId == EquipPos.BATTLE_HORSE then
        --上下战斗坐骑
        local str = MEntityMgr.PlayerEntity.IsRideBattleVehicle and Lang("PUT_OFF_VEHICLE") or Lang("PUT_ON_VEHICLE")
        self:AddButtonData(buttonDatas, str, function()
            MgrMgr:GetMgr("VehicleMgr").RequestTakeVehicle(not MEntityMgr.PlayerEntity.IsRideBattleVehicle, true)
            self:HideTips()
        end)
        --切换外观
        self:AddButtonData(buttonDatas, Common.Utils.Lang("BARROW_CHANGE_APPEARANCE"), function()
            --寻路成功才关闭对应界面
            local l_result = Common.CommonUIFunc.InvokeFunctionByFuncId(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.BattleVehicleFuncId, nil, true)
            if l_result then
                self:HideTips()
                self:HideBag()
            end
        end)
        return true
    else
        return false
    end

    return false
end

--创建猎鹰按钮
function CommonItemTipsCtrl:CreateBattleBirdBtn(oneItem, buttonDatas)
    ---@type ItemData
    local l_info = oneItem.data.baseData
    local l_row = l_info.EquipConfig
    if l_row and l_row.EquipId == EquipPos.BATTLE_BIRD then
        --切换外观
        self:AddButtonData(buttonDatas, Common.Utils.Lang("BARROW_CHANGE_APPEARANCE"), function()
            --寻路成功才关闭对应界面
            local l_result = Common.CommonUIFunc.InvokeFunctionByFuncId(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.BattleBirdFuncId, nil, true)
            if l_result then
                self:HideTips()
                self:HideBag()
            end
        end)
        return true
    else
        return false
    end

    return false
end

--创建兑换按钮
function CommonItemTipsCtrl:CreateSwitchBtn(oneItem, buttonDatas)
    if oneItem.data.equipTableData ~= nil then
        --如果道具id在EquipTable表【Id】列能查询到 且 【EquipId】列的值为7/8/9/10，则不显示【兑换】按钮；
        local l_equipId = oneItem.data.equipTableData.EquipId
        if l_equipId == 7 or l_equipId == 8 or l_equipId == 9 or l_equipId == 10 then
            return
        end
    end
    if ItemSwitchTable and ItemSwitchTable[oneItem.data.baseData.TID] then
        local l_switchData = TableUtil.GetOrnamentBarterTable().GetRowByOrnamentID(ItemSwitchTable[oneItem.data.baseData.TID], true)
        if l_switchData ~= nil then
            self:AddButtonData(buttonDatas, Common.Utils.Lang("HEAD_SWITCH"), function()
                game:ShowMainPanel()
                local sceneIdTb, posTb = Common.CommonUIFunc.GetNpcSceneIdAndPos(l_switchData.NpcID)
                if sceneIdTb[1] ~= nil then
                    MTransferMgr:GotoNpc(sceneIdTb[1], l_switchData.NpcID, function()
                        UIMgr:DeActiveUI(UI.CtrlNames.TalkDlg2)
                        UIMgr:ActiveUI(UI.CtrlNames.HeadShop, { npcId = l_switchData.NpcID, ornamentId = l_switchData.OrnamentID })
                    end)
                end
            end)
        end
    end
end

function CommonItemTipsCtrl:CreateCardExchangeBtn(oneItem, buttonDatas)
    if oneItem.data.baseData.TID ~= MGlobalConfig:GetInt("ExchangeCost") then
        return
    end

    if not MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.CardExchangeShop) then
        return
    end

    self:AddButtonData(buttonDatas, Common.Utils.Lang("HEAD_SWITCH"), function()
        --寻路成功才关闭对应界面
        local l_result = Common.CommonUIFunc.InvokeFunctionByFuncId(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.CardExchangeShop)
        if l_result then
            game:ShowMainPanel()
        end
    end)
end

--创建材料锻造按钮
function CommonItemTipsCtrl:CreateForgeBtn(oneItem, buttonDatas)
    --- 只有在两个锻造都被关掉的情况下锻造入口才会被关掉s
    if not MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.forgeWeapon)
            and not MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.forgeArmor) then
        return
    end

    if oneItem.data.itemTableData ~= nil then
        --如果道具id在EquipTable表【Id】列能查询到 且 【EquipId】列的值为7，则不显示【锻造】按钮；
        local l_equipId = oneItem.data.itemTableData.TypeTab
        if l_equipId == 7 then
            return
        end
    end

    --- 离线表读出来的ID
    local l_forgeDataWeapon = nil
    local offLineWeaponTable = ItemForgeTableWeapon[oneItem.data.baseData.TID]
    if ItemForgeTableWeapon and nil ~= offLineWeaponTable then
        l_forgeDataWeapon = offLineWeaponTable[1]
    end

    local l_forgeDataArmor = nil
    local offLineArmorTable = ItemForgeTableArmor[oneItem.data.baseData.TID]
    if ItemForgeTableArmor and nil ~= offLineArmorTable then
        l_forgeDataArmor = offLineArmorTable[1]
    end

    --- 策划说这里不需要选中
    --- 有个坑，因为选中装备需要对玩家职业进行过滤，目前没做这个过滤，所以从材料点过去是不选中的
    if l_forgeDataWeapon ~= nil or l_forgeDataArmor ~= nil then
        self:AddButtonData(buttonDatas, Common.Utils.Lang("MADE_EQUIP"), function()
            --寻路成功才关闭对应界面
            local l_result = false
            if l_forgeDataWeapon then
                l_result = Common.CommonUIFunc.InvokeFunctionByFuncId(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.forgeWeapon, l_forgeDataWeapon)
            elseif l_forgeDataArmor then
                l_result = Common.CommonUIFunc.InvokeFunctionByFuncId(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.forgeArmor, l_forgeDataArmor)
            end
            if l_result then
                game:ShowMainPanel()
            end
        end)
    end
end

--创建材料打洞按钮
function CommonItemTipsCtrl:CreateMakeHoleBtn(oneItem, buttonDatas)
    if not MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.MakeHole) then
        return
    end

    if ItemCardTable then
        local l_cardData = ItemCardTable[oneItem.data.baseData.TID]
        if l_cardData ~= nil then
            self:AddButtonData(buttonDatas, Common.Utils.Lang("EQUIP_MAKE_HOLE"), function()
                game:ShowMainPanel()
                self:_openMakeHolePage()
            end)
        end
    end
end

--- 创建装备的改造按钮
function CommonItemTipsCtrl:CreateReformBtn(oneItem, buttonDatas)
    if not MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.EquipReform) then
        return
    end

    ---@type ItemData
    local itemData = oneItem.data.baseData
    if nil == itemData then
        return
    end

    local equipReformMgr = MgrMgr:GetMgr("EquipReformMgr")
    if not equipReformMgr.ValidateSingleItem(itemData) then
        return
    end

    local showUIFunc = function()
        game:ShowMainPanel()
        equipReformMgr.SetCurrentItemData(itemData)
        UIMgr:ActiveUI(UI.CtrlNames.EquipGaiZao)
    end

    self:AddButtonData(buttonDatas, Common.Utils.Lang("EQUIP_REFORM"), showUIFunc)
end

--创建材料附魔按钮
function CommonItemTipsCtrl:CreateEnchantBtn(oneItem, buttonDatas)
    if not MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Enchant) then
        return
    end

    if oneItem.data.itemTableData ~= nil then
        local l_equipId = oneItem.data.itemTableData.TypeTab
        if l_equipId == 7 then
            return
        end
    end

    if ItemEnchantTable then
        local l_cardData = ItemEnchantTable[oneItem.data.baseData.TID]
        if l_cardData ~= nil then
            self:AddButtonData(buttonDatas, Common.Utils.Lang("EQUIP_ENCHANT"), function()
                --寻路成功才关闭对应界面
                local l_result = Common.CommonUIFunc.InvokeFunctionByFuncId(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Enchant)
                if l_result then
                    game:ShowMainPanel()
                end
            end)
        end
    end
end

--创建材料精炼按钮
function CommonItemTipsCtrl:CreateRefineBtn(oneItem, buttonDatas)
    if not MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Refine) then
        return
    end

    if oneItem.data.itemTableData ~= nil then
        --如果道具id在ItemTable表【Id】列能查询到 且 【TypeTab】列的值为7，则不显示【精炼】按钮；
        local l_equipId = oneItem.data.itemTableData.TypeTab
        if l_equipId == 7 then
            return
        end
    end

    if ItemRefineTable then
        local l_cardData = ItemRefineTable[oneItem.data.baseData.TID]
        if l_cardData ~= nil then
            self:AddButtonData(buttonDatas, Common.Utils.Lang("EQUIP_REFINING"), function()
                --寻路成功才关闭对应界面
                local l_result = Common.CommonUIFunc.InvokeFunctionByFuncId(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Refine)
                if l_result then
                    game:ShowMainPanel()
                end
            end)
        end
    end
end

-- 附魔继承耗材
function CommonItemTipsCtrl:CreateEnchantInheritConsumeBtn(oneItem, buttonDatas)
    if nil == EnchantRebornConsumeOffLine then
        logError("[EnchantRebornConsumeOffLine] offline table is nil")
        return
    end

    local l_openSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
    if not l_openSystemMgr.IsSystemOpen(l_openSystemMgr.eSystemId.EnchantInherit) then
        return
    end

    local l_itemID = oneItem.data.baseData.TID
    local l_data = EnchantRebornConsumeOffLine[l_itemID]
    if nil == l_data then
        return
    end

    local l_cb = function()
        local l_param = {
            handlerName = GameEnum.EEquipAssistType.EnchantAssistOnInherit }
        --寻路成功才关闭对应界面
        local l_result = Common.CommonUIFunc.InvokeFunctionByFuncId(l_openSystemMgr.eSystemId.EnchantmentAssist, l_param)
        if l_result then
            game:ShowMainPanel()
        end
    end

    self:AddButtonData(buttonDatas, Common.Utils.Lang("EquipAssistantBG_EnchantInheritHandlerName"), l_cb)
end

-- 完美提炼耗材
function CommonItemTipsCtrl:CreateEnchantExtractBtn(oneItem, buttonDatas)
    if nil == EnchantExtractConsuemOffLine then
        logError("[EnchantExtractConsuemOffLine] offline table is nil")
        return
    end

    local l_openSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
    local l_itemID = oneItem.data.baseData.TID
    local l_data = EnchantExtractConsuemOffLine[l_itemID]
    if nil == l_data then
        return
    end

    if false == l_openSystemMgr.IsSystemOpen(l_openSystemMgr.eSystemId.EnchantExtract) then
        return
    end

    local l_cb = function()
        local l_param = {
            handlerName = GameEnum.EEquipAssistType.EnchantAssistOnPerfect,
            EquipPropInfo = nil,
            switchPerfect = true }
        --寻路成功才关闭对应界面
        local l_result = Common.CommonUIFunc.InvokeFunctionByFuncId(l_openSystemMgr.eSystemId.EnchantmentAssist, l_param)
        if l_result then
            game:ShowMainPanel()
        end
    end

    self:AddButtonData(buttonDatas, Common.Utils.Lang("ENCHANT_EXTRACT_BTN_NAME"), l_cb)
end

-- 附魔继承装备按钮
function CommonItemTipsCtrl:CreateEnchantEquipInheritBtn(oneItem, buttonDatas)
    local l_openSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
    local l_enchantInheritMgr = MgrMgr:GetMgr("EnchantInheritMgr")
    if false == l_openSystemMgr.IsSystemOpen(l_openSystemMgr.eSystemId.EnchantInherit) then
        return
    end

    local l_propInfo = oneItem.data.baseData
    if nil == l_propInfo then
        logError("[ItemTipsBtn] propInfo is nil")
        return
    end

    if not l_enchantInheritMgr.IsEquipShopType(l_propInfo) then
        return
    end

    if l_enchantInheritMgr.IsEquipEnchanted(l_propInfo) then
        return
    end

    if not l_enchantInheritMgr.IsEquipAbleToEnchant(l_propInfo) then
        return
    end

    local l_cb = function()
        local l_param = {
            handlerName = GameEnum.EEquipAssistType.EnchantAssistOnInherit,
            EquipPropInfo = l_propInfo }
        --寻路成功才关闭对应界面
        local l_result = Common.CommonUIFunc.InvokeFunctionByFuncId(l_openSystemMgr.eSystemId.EnchantmentAssist, l_param)
        if l_result then
            game:ShowMainPanel()
        end
    end

    self:AddButtonData(buttonDatas, Common.Utils.Lang("EquipAssistantBG_EnchantInheritHandlerName"), l_cb)
end

--创建材料精炼转移按钮
function CommonItemTipsCtrl:CreateRefineTransferBtn(oneItem, buttonDatas)
    if not MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.RefineTransfer) then
        return
    end
    if oneItem.data.itemTableData ~= nil then
        --如果道具id在ItemTable表【Id】列能查询到 且 【TypeTab】列的值为7，则不显示【精炼】按钮；
        local l_equipId = oneItem.data.itemTableData.TypeTab
        if l_equipId == 7 then
            return
        end
    end
    if ItemMaterialsRefineTransferDatas then
        local l_materialsData = ItemMaterialsRefineTransferDatas[oneItem.data.baseData.TID]
        if l_materialsData ~= nil then
            self:AddButtonData(buttonDatas, Common.Utils.Lang("Use"), function()
                --寻路成功才关闭对应界面
                local l_result = Common.CommonUIFunc.InvokeFunctionByFuncId(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.RefineTransfer)
                if l_result then
                    game:ShowMainPanel()
                end
            end)
        end
    end
end

--创建材料精炼解封按钮
function CommonItemTipsCtrl:CreateRefineUnsealBtn(oneItem, buttonDatas)
    if not MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.RefineSeal) then
        return
    end
    if oneItem.data.itemTableData ~= nil then
        --如果道具id在ItemTable表【Id】列能查询到 且 【TypeTab】列的值为7，则不显示【精炼】按钮；
        local l_equipId = oneItem.data.itemTableData.TypeTab
        if l_equipId == 7 then
            return
        end
    end
    if ItemMaterialsRefineUnsealDatas then
        local l_materialsData = ItemMaterialsRefineUnsealDatas[oneItem.data.baseData.TID]
        if l_materialsData ~= nil then
            self:AddButtonData(buttonDatas, Common.Utils.Lang("Use"), function()
                --寻路成功才关闭对应界面
                local l_result = Common.CommonUIFunc.InvokeFunctionByFuncId(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.RefineSeal)
                if l_result then
                    game:ShowMainPanel()
                end
            end)
        end
    end
end

--创建合成按钮
function CommonItemTipsCtrl:CreateCompoundBtn(oneItem, buttonDatas)
    if not MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Compound) then
        return
    end
    if oneItem.data.itemTableData ~= nil then
        local l_row = TableUtil.GetComposeTable().GetRowByConsumableID(oneItem.data.itemTableData.ItemID, true)
        if l_row == nil then
            return
        end
    end

    self:AddButtonData(buttonDatas, Lang("Compound"), function()
        UIMgr:DeActiveUI(UI.CtrlNames.CommonItemTips)
        UIMgr:ActiveUI(UI.CtrlNames.EquipElevate, function(ctrl)
            ctrl:SelectOneHandler(UI.HandlerNames.Compound, function(hander)
                hander:SelectTargetMaterials(oneItem.data.itemTableData.ItemID)
            end)
        end)
    end)
end

--创建使用按钮  用于寻找美发美瞳npc
function CommonItemTipsCtrl:CreateUseFindnpcBtn(oneItem, buttonDatas)
    --logError("CreateUseFindnpcBtn0 "..#buttonDatas)
    if oneItem.data.itemTableData ~= nil then
        local eyeFuncId = MgrMgr:GetMgr("OpenSystemMgr").eSystemId.EyeShopId
        local hairFuncId = MgrMgr:GetMgr("OpenSystemMgr").eSystemId.HairShopcId
        local txt = nil
        local FuncId = nil
        local MgrName = nil
        --logError("CreateUseFindnpcBtn1 "..tostring(oneItem.data.itemTableData.ItemID))
        local l_row = TableUtil.GetBarberTable().GetRowByUseItemID(oneItem.data.itemTableData.ItemID, true)
        if l_row ~= nil then
            --logError("no")
            FuncId = hairFuncId
            txt = "GOTO_HAIRSHOP"
            MgrName = "BarberShopMgr"
        end
        if l_row == nil then
            l_row = TableUtil.GetEyeTable().GetRowByUseItemID(oneItem.data.itemTableData.ItemID, true)
            if l_row ~= nil then
                --logError("no1")
                FuncId = eyeFuncId
                txt = "GOTO_EYESHOP"
                MgrName = "BeautyShopMgr"
            end
        end
        if l_row == nil or FuncId == nil then
            return
        end
        self:AddButtonData(buttonDatas, Lang("Use"), function()
            UIMgr:DeActiveUI(UI.CtrlNames.CommonItemTips)
            local cNpcTb = Common.CommonUIFunc.GetNpcIdTbByFuncId(FuncId)
            if table.maxn(cNpcTb) > 0 then
                for x = 1, table.maxn(cNpcTb) do
                    local sceneIdTb, posTb = Common.CommonUIFunc.GetNpcSceneIdAndPos(cNpcTb[x])
                    UIMgr:DeActiveUI(UI.CtrlNames.Bag)
                    local method = MgrMgr:GetMgr("SystemFunctionEventMgr").GetSystemFunctionEvent(FuncId)
                    MTransferMgr:GotoPosition(sceneIdTb[1], posTb[1], function()
                        if txt == "GOTO_HAIRSHOP" then
                            MgrMgr:GetMgr("GarderobeMgr").EnableJumpToBarberShop(true)
                            MgrMgr:GetMgr("GarderobeMgr").JumpToBarberStyleId = l_row.BarberID
                        else
                            MgrMgr:GetMgr("GarderobeMgr").EnableJumpToEyeShop(true)
                            MgrMgr:GetMgr("GarderobeMgr").JumpToEyeId = l_row.EyeID

                        end
                        method()
                    end)
                    return
                end
            else
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("NONE_NPCHERE"))
            end
        end)
    end
end

function CommonItemTipsCtrl:CreateEquipShardExchangeBtn(oneItem, buttonDatas)
    local sysMgr = MgrMgr:GetMgr("OpenSystemMgr")
    if not sysMgr.IsSystemOpen(sysMgr.eSystemId.EquipShardExchange) then
        return
    end

    if nil == EquipShardMatOffLineMap then
        logError("[CommonItemTips] equip shard offline table is nil")
        return
    end

    local tid = oneItem.data.baseData.TID
    if nil == EquipShardMatOffLineMap[tid] then
        return
    end

    self:AddButtonData(buttonDatas, Common.Utils.Lang("C_EQUIP_SHARD_EXCHANGE"), function()
        --寻路成功才关闭对应界面
        local l_result = Common.CommonUIFunc.InvokeFunctionByFuncId(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.EquipShardExchange)
        if l_result then
            game:ShowMainPanel()
        end
    end)
end

function CommonItemTipsCtrl:CreateBeiluzBtn(oneItem, buttonDatas)
    local OpenSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
    local beilzMgr = MgrMgr:GetMgr("BeiluzCoreMgr")
    if OpenSystemMgr.IsSystemOpen(OpenSystemMgr.eSystemId.BeiluzReset) and ItemBeiluzResetTable then
        local l_materialsData = ItemBeiluzResetTable[oneItem.data.baseData.TID]
        if l_materialsData ~= nil then
            self:AddButtonData(buttonDatas, Common.Utils.Lang("MEDAL_TIP_RESET"), function()
                UIMgr:DeActiveUI(UI.CtrlNames.CommonItemTips)
                MgrMgr:GetMgr("BeiluzCoreMgr").OpenOperationPanelByType(MgrMgr:GetMgr("BeiluzCoreMgr").EOperationType.Reset)
            end)
        end
    end

    if oneItem.data.itemTableData.TypeTab == Data.BagModel.PropType.Beiluz then        
        if OpenSystemMgr.IsSystemOpen(OpenSystemMgr.eSystemId.Beiluz) then
            self:AddButtonData(buttonDatas, Common.Utils.Lang("WHEEL_EQUIP"), function()
                UIMgr:DeActiveUI(UI.CtrlNames.CommonItemTips)
                local data = {}
                data.Type = beilzMgr.BEILUZCORE_OPEN_FUNC.Equip
                data.UID = oneItem.data.baseData.UID
                UIMgr:ActiveUI(UI.CtrlNames.BeiluzCore, data)
            end)

            if OpenSystemMgr.IsSystemOpen(OpenSystemMgr.eSystemId.BeiluzMaintain) then
                self:AddButtonData(buttonDatas, Common.Utils.Lang("WHEEL_MAINTAIN"), function()
                    UIMgr:DeActiveUI(UI.CtrlNames.CommonItemTips)
                    local data = {}
                    data.Type = beilzMgr.BEILUZCORE_OPEN_FUNC.Maintain
                    data.UID = oneItem.data.baseData.UID
                    UIMgr:ActiveUI(UI.CtrlNames.BeiluzCore, data)
                end)
            end
        end

        if OpenSystemMgr.IsSystemOpen(OpenSystemMgr.eSystemId.BeiluzCombine) then
            self:AddButtonData(buttonDatas, Common.Utils.Lang("BAG_TIP_COMPOUND"), function()
                UIMgr:DeActiveUI(UI.CtrlNames.CommonItemTips)
                beilzMgr.Cache_CORE_UIDSTR = tostring(oneItem.data.baseData.UID)
                beilzMgr.OpenOperationPanelByType(beilzMgr.EOperationType.Combine)
            end)
        end

        if OpenSystemMgr.IsSystemOpen(OpenSystemMgr.eSystemId.BeiluzReset) then
            self:AddButtonData(buttonDatas, Common.Utils.Lang("MEDAL_TIP_RESET"), function()
                UIMgr:DeActiveUI(UI.CtrlNames.CommonItemTips)
                beilzMgr.Cache_CORE_UIDSTR = tostring(oneItem.data.baseData.UID)
                beilzMgr.OpenOperationPanelByType(beilzMgr.EOperationType.Reset)
            end)
        end
    end
end

--创建卡片抽卡按钮
function CommonItemTipsCtrl:CreateCardBtn(oneItem, buttonDatas)
    --显示插卡按钮
    if MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.EquipCard) then
        self:AddButtonData(buttonDatas, Common.Utils.Lang("EQUIP_INSERT_CARD"), function()
            game:ShowMainPanel()
            self:_openInsertCardPage(oneItem.data.baseData.TID)
        end)
    end
end

--创建卡片解封按钮
function CommonItemTipsCtrl:CreateUnsealCardBtn(oneItem, buttonDatas)
    -- 解封按钮
    if not MgrMgr:GetMgr("SealCardMgr").IsSealCard(oneItem.data.baseData.TID)
            and not MgrMgr:GetMgr("SealCardMgr").IsSealCardCostItem(oneItem.data.baseData.TID) then
        return
    end


    --显示解封按钮
    if MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.UnsealCard) then
        self:AddButtonData(buttonDatas, Common.Utils.Lang("EQUIP_UNSEAL_CARD"), function()
            --寻路成功才关闭对应界面
            local l_result = Common.CommonUIFunc.InvokeFunctionByFuncId(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.UnsealCard, oneItem.data.baseData.TID)
            if l_result then
                game:ShowMainPanel()
            end
        end)
    end
end

--创建卡片分解按钮
function CommonItemTipsCtrl:CreateRecoveBtn(oneItem, buttonDatas)
    -- @ 廖萧萧需求 背包中卡片不显示分解按钮
    if true then
        return
    end
    if MgrMgr:GetMgr("MagicRecoveMachineMgr").IsOutsideCanRecoveItem(MgrMgr:GetMgr("MagicRecoveMachineMgr").EMagicRecoveMachineType.Card, oneItem.data.baseData) then
        self:AddButtonData(buttonDatas, Lang("BAG_TIP_SPLIT"), function()
            if not MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.RecoveCard) then
                local tableData = TableUtil.GetOpenSystemTable().GetRowById(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.RecoveCard)
                if tableData then
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Lang("EXTRACT_MACHINE_OPEN"), tableData.BaseLevel))
                end
                return
            end
            --寻路成功才关闭对应界面
            local l_result = Common.CommonUIFunc.InvokeFunctionByFuncId(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.RecoveCard)
            if l_result then
                game:ShowMainPanel()
            end
        end)
    end
end

--创建头饰分解按钮
function CommonItemTipsCtrl:CreateHeadRecoveBtn(oneItem, buttonDatas)
    if not MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.RecoveHead) then
        return
    end

    if MgrMgr:GetMgr("MagicRecoveMachineMgr").IsOutsideCanRecoveItem(MgrMgr:GetMgr("MagicRecoveMachineMgr").EMagicRecoveMachineType.HeadWear, oneItem.data.baseData) then
        self:AddButtonData(buttonDatas, Lang("BAG_TIP_SPLIT"), function()
            --寻路成功才关闭对应界面
            local l_result = Common.CommonUIFunc.InvokeFunctionByFuncId(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.RecoveHead)
            if l_result then
                game:ShowMainPanel()
            end
        end)
    end
end

--创建装备分解按钮
function CommonItemTipsCtrl:CreateEquipRecoveBtn(oneItem, buttonDatas)
    if not MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.RecoveEquip) then
        return
    end

    if MgrMgr:GetMgr("MagicRecoveMachineMgr").IsOutsideCanRecoveItem(MgrMgr:GetMgr("MagicRecoveMachineMgr").EMagicRecoveMachineType.Equip, oneItem.data.baseData) then
        self:AddButtonData(buttonDatas, Lang("BAG_TIP_SPLIT"), function()
            --寻路成功才关闭对应界面
            local l_result = Common.CommonUIFunc.InvokeFunctionByFuncId(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.RecoveEquip)
            if l_result then
                game:ShowMainPanel()
            end
        end)
    end
end

--插卡按钮 选择的是装备
function CommonItemTipsCtrl:CreateEquipCardBtn(oneItem, buttonDatas)
    if oneItem.data.equipTableData == nil then
        return
    end

    if not MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.EquipCard) then
        return
    end

    if 0 >= oneItem.data.equipTableData.HoleNum then
        return
    end

    local l_str = Common.Utils.Lang("EQUIP_INSERT_CARD")
    if oneItem.data.baseData.EquipConfig and #MgrMgr:GetMgr("EquipMakeHoleMgr").GetCardIds(oneItem.data.baseData) > 0 then
        l_str = Common.Utils.Lang("EQUIP_INSERT_REMOVE_CARD")
    end

    self:AddButtonData(buttonDatas, l_str, function()
        local gotoCardData = oneItem.data.baseData
        MgrMgr:GetMgr("EquipCardForgeHandlerMgr").SetCurrentSelectedCard({ EquipUid = gotoCardData.UID, IsRemoveCard = false })
        MgrMgr:GetMgr("SelectEquipMgr").SetNeedSelectUid(gotoCardData.UID)
        game:ShowMainPanel()
        self:_openInsertCardPage(nil)
    end)
end

--- 开启打洞界面
function CommonItemTipsCtrl:_openMakeHolePage()
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    MgrMgr:GetMgr("ShowEquipPanleMgr").OpenMakeHolePanle()
end

--- 开启插卡界面
function CommonItemTipsCtrl:_openInsertCardPage(cardId)
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    MgrMgr:GetMgr("ShowEquipPanleMgr").OpenCardForgePanle(cardId)
end

--附魔按钮
function CommonItemTipsCtrl:CreateEquipEnchantBtn(oneItem, buttonDatas)
    if oneItem.data.equipTableData == nil then
        return
    end

    ---@type ItemData
    local item = oneItem.data.baseData
    if item.EnchantExtracted then
        return
    end

    if MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Enchant) then
        if oneItem.data.equipTableData.EnchantingId > 0 then
            local l_isShowRed = self:isCanEnchant(oneItem)
            self:AddButtonData(buttonDatas, Common.Utils.Lang("EQUIP_ENCHANT"), function()
                MgrMgr:GetMgr("SelectEquipMgr").g_currentSelectUID = oneItem.data.baseData.UID
                --寻路成功才关闭对应界面
                local l_result = Common.CommonUIFunc.InvokeFunctionByFuncId(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Enchant)
                if l_result then
                    game:ShowMainPanel()
                end
            end, false)
        end
    end
end

--摆摊按钮
function CommonItemTipsCtrl:CreateShopStallBtn(oneItem, buttonDatas)
    local l_stallDetailData = nil
    local l_stallDetailTable = TableUtil.GetStallDetailTable().GetTable()
    for i = 1, #l_stallDetailTable do
        if l_stallDetailTable[i].ItemID == oneItem.data.baseData.TID then
            l_stallDetailData = l_stallDetailTable[i]
            break
        end
    end
    if not l_stallDetailData or not l_stallDetailData.Enable then
        return
    end

    local l_isBody = MgrMgr:GetMgr("EquipMgr").CheckEquipIsBody(oneItem.data.baseData.UID)
    if l_stallDetailData ~= nil and not l_isBody and oneItem.data.baseData.IsBind ~= nil and oneItem.data.baseData.IsBind == false then
        if MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Stall) then
            self:AddButtonData(buttonDatas, Common.Utils.Lang("Shop_Sell"), function()

                local l_isTalentEquip, l_name, l_c = MgrProxy:GetMultiTalentEquipMgr().IsInMultiTalentEquip(oneItem.data.baseData)
                if l_isTalentEquip then
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Common.Utils.Lang("MultiTalent_EquipCantChangeWithStallSell"), l_name))
                else
                    local l_uid = oneItem.data.baseData.UID
                    local l_itemId = oneItem.data.baseData.TID
                    local l_target = MgrMgr:GetMgr("StallMgr").g_tableItemInfo[l_itemId]
                    if not l_target then
                        logError("item not find@李韬,id:" .. tostring(l_itemId))
                        return
                    end
                    local l_serverLevel = l_target.info.ServerLevelLimit
                    if MPlayerInfo.ServerLevel < l_serverLevel then
                        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Common.Utils.Lang("STALL_SERVER_LIMIT_SELL"), l_serverLevel))
                        return
                    end
                    MgrMgr:GetMgr("SweaterMgr").OpenSellSweater(MgrMgr:GetMgr("SweaterMgr").ESweaterType.Stall, l_uid)
                end

                self:HideTips()
            end, nil, true)
        end
    end
end

--商会按钮
function CommonItemTipsCtrl:CreateShopTradeBtn(oneItem, buttonDatas)
    local l_TradeData = nil
    l_TradeData = TableUtil.GetCommoditTable().GetRowByCommoditID(oneItem.data.baseData.TID, true)

    if not l_TradeData or not l_TradeData.Enable then
        return
    end

    local l_isBody = MgrMgr:GetMgr("EquipMgr").CheckEquipIsBody(oneItem.data.baseData.UID)
    if l_TradeData ~= nil and not l_isBody and oneItem.data.baseData.IsBind ~= nil and oneItem.data.baseData.IsBind == false then
        if MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Trade) then
            self:AddButtonData(buttonDatas, Common.Utils.Lang("Shop_Sell"), function()
                local l_uid = oneItem.data.baseData.UID
                local l_itemId = oneItem.data.baseData.TID
                MgrMgr:GetMgr("SweaterMgr").OpenSellSweater(MgrMgr:GetMgr("SweaterMgr").ESweaterType.Trade, l_uid)
                self:HideTips()
            end, nil, nil, true)
        end
    end
end

-- 黑市按钮
function CommonItemTipsCtrl:CreateBlackShopBtn(oneItem, buttonDatas)
    if not MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.BlackShop) then
        return
    end

    if not MgrMgr:GetMgr("AuctionMgr").CanBlackShopSell(oneItem.data.baseData.TID) then
        return
    end

    self:AddButtonData(buttonDatas, Common.Utils.Lang("BLACK_SHOP"), function()
        local l_uid = oneItem.data.baseData.UID
        local l_itemId = oneItem.data.baseData.TID
        --寻路成功才关闭对应界面
        local l_result = Common.CommonUIFunc.InvokeFunctionByFuncId(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.BlackShop)
        if l_result then
            game:ShowMainPanel()
            self:HideTips()
        end
    end, nil, nil, nil, nil, true)
end

--精炼按钮
function CommonItemTipsCtrl:CreateEquipRefineBtn(oneItem, buttonDatas)
    if oneItem.data.equipTableData == nil then
        return
    end
    if MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Refine) then
        --可精炼
        if MgrMgr:GetMgr("RefineMgr").IsCanRefine(oneItem.data.equipTableData) then
            local l_isShowRed = self:isCanRefine(oneItem)
            self:AddButtonData(buttonDatas, Common.Utils.Lang("EQUIP_REFINING"), function()
                MgrMgr:GetMgr("SelectEquipMgr").g_currentSelectUID = oneItem.data.baseData.UID
                --寻路成功才关闭对应界面
                local l_result = Common.CommonUIFunc.InvokeFunctionByFuncId(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Refine)
                if l_result then
                    game:ShowMainPanel()
                end
            end, false)
        end
    end
end

--如果道具ID在ItemTable表中，列【RecycleValue】有配置，并且【ShowRecycleButton】值为1，则在道具tips上显示【回收】按钮
function CommonItemTipsCtrl:CreateItemSellBtn(oneItem, buttonDatas)
    if oneItem.data.itemTableData.RecycleValue:get_Item(0) > 0 and oneItem.data.itemTableData.ShowRecycleButton > 0 then
        --回收按钮
        self:AddButtonData(buttonDatas, Common.Utils.Lang("CARD_SELL"), function()
            --寻路成功才关闭对应界面
            local l_result = Common.CommonUIFunc.InvokeFunctionByFuncId(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.ItemSell)
            if l_result then
                game:ShowMainPanel()
            end
        end)
    end
end

--创建置换属性按钮
function CommonItemTipsCtrl:CreateReplaceItemPropertyBtn(oneItem, buttonDatas)
    if oneItem.data.equipTableData == nil then
        return
    end

    if MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.UseDisplace) then
        if oneItem.data.itemTableData and oneItem.data.equipTableData then
            if Common.CommonUIFunc.IsInContainDeviceTable(oneItem.data.equipTableData.WeaponId) then
                if oneItem.data.itemTableData.TypeTab == 1 and oneItem.data.equipTableData.EquipId == 1 then
                    self:AddButtonData(buttonDatas, Common.Utils.Lang("REPLACE_ITEM_PROPERTY"), function()
                        Common.CommonUIFunc.InvokeFunctionByFuncId(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.UseDisplace)
                        self:HideTips()
                        --打开属性置换界面
                    end)
                end
            end
        end
    end
end

function CommonItemTipsCtrl:CreateShopBtn(oneItem)
    local buttonDatas = {}
    if MgrMgr:GetMgr("ShopMgr").IsBuy then
        local buyTable = oneItem.data.buyTableData
        local price = Common.Functions.VectorSequenceToTable(buyTable.ItemPerPrice)
        if price == nil then
            return buttonDatas
        end

        self:AddButtonData(buttonDatas, Common.Utils.Lang("Buy"), function()
            if price == nil then
                return
            end

            -- if Data.BagModel:GetCoinOrPropNumById(price[1][1]) < self:GetTemplentByName(oneItem, "shopSetInfo"):GetInfoComponentValue() then
            --     local l_coinName = TableUtil.GetItemTable().GetRowByItemID(price[1][1]).ItemName
            --     MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_coinName .. Common.Utils.Lang("CLICK_NOT_ENOUGH"))
            --     local propInfo = Data.BagModel:CreateItemWithTid(price[1][1])
            --     MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplay(propInfo, nil, nil, nil, true)
            --     return
            -- end

            MgrMgr:GetMgr("ShopMgr").BuyItemData = oneItem.data
            MgrMgr:GetMgr("ShopMgr").RequestBuyShopItem(oneItem.data.BuyShopItemData.table_id, oneItem.data.currentCount)
            self:HideTips()
        end)
    else
        self:AddButtonData(buttonDatas, Common.Utils.Lang("Shop_Sell"), function()
            MgrMgr:GetMgr("ShopMgr").AddSellCommodity(oneItem.data.baseData, oneItem.data.currentCount)
            self:HideTips()
        end)
    end

    self:AddButtonData(buttonDatas, Common.Utils.Lang("DLG_BTN_NO"), function()
        self:HideTips()
    end)
    return buttonDatas
end

--交付公会道具按钮
function CommonItemTipsCtrl:CreateGiveToGuildBtn(oneItem, buttonDatas)
    if oneItem.data.itemTableData ~= nil then
        local l_id = oneItem.data.itemTableData.ItemID
        local l_gMgr = MgrMgr:GetMgr("GuildMgr")
        if l_gMgr.IsGuildItem(l_id) then
            self:AddButtonData(buttonDatas, Common.Utils.Lang("GIVE"), function()
                local l_uid = oneItem.data.baseData.UID
                local l_num = oneItem.data.baseData.ItemCount
                l_gMgr.ContributeGuildItem(l_uid, l_id, l_num)
                self:HideTips()
            end)
        end
    end
end

--卡片相关按钮
function CommonItemTipsCtrl:CreateCardRelateBtn(oneItem, buttonDatas)
    if oneItem.data.itemTableData.TypeTab == Data.BagModel.PropType.Card then
        --卡片抽卡出售按钮
        self:CreateCardBtn(oneItem, buttonDatas)
        --分解按钮
        self:CreateRecoveBtn(oneItem, buttonDatas)
    end
end

function CommonItemTipsCtrl:RequestUseItem(l_info)
    local propNum = l_info.ItemCount
    MgrMgr:GetMgr("PropMgr").RequestUseItem(l_info.UID, 1, l_info.TID)
    local l_cd = MgrMgr:GetMgr("ItemCdMgr").GetCd(l_info.TID)
    if l_cd <= 0 and 1 >= propNum then
        self:HideTips()
    end
end

--使用按钮创建
function CommonItemTipsCtrl:CreateOnUseBtn(oneItem, buttonDatas)

    --有一些特殊判定的道具 不需要显示使用按钮
    local UnUseIdTb = MGlobalConfig:GetSequenceOrVectorInt("ItemsWithoutUseButton")
    for i = 1, UnUseIdTb.Length do
        if UnUseIdTb[i - 1] == oneItem.data.itemTableData.ItemID then
            return
        end
    end

    -- 使用付费道具时，是否需要确认
    local needUseTip = (oneItem.data.itemFunctionData ~= nil and oneItem.data.itemFunctionData.Payment == 1 and MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.PaymentTips))
    if needUseTip then
        local usageTime = tonumber(MServerTimeMgr.UtcSeconds) - tonumber(oneItem.data.baseData.CreateTime)
        if usageTime > MgrMgr:GetMgr("MallMgr").RefundExpirationTime then
            -- 在退款期内
            needUseTip = false
        end
    end

    if oneItem.data.itemFunctionData ~= nil
            and oneItem.data.itemTableData.TypeTab ~= 9
            and oneItem.data.itemTableData.TypeTab ~= 12
            and oneItem.data.itemTableData.TypeTab ~= 15
    then
        --箭矢类型的特殊处理
        if oneItem.data.itemFunctionData.ItemFunction == 8 then
            self:AddButtonData(buttonDatas, Common.Utils.Lang("BTN_ARROW_SETUP"), function()
                self:HideTips()
                UIMgr:DeActiveUI(UI.CtrlNames.Bag)
                MgrMgr:GetMgr("ArrowMgr").OpenArrowSetup()
            end)

            return
        end

        local UseItemFunc = function()
            local l_info = oneItem.data.baseData
            if l_info == nil then
                self:HideTips()
            end

            if nil ~= MEntityMgr.PlayerEntity then
                local forbidUseItem = MEntityMgr.PlayerEntity:GetAttr(AttrType.ATTR_SPECIAL_NO_USE_ITEM)
                if 0 < forbidUseItem then
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("NOT_USE_ITEM"))
                    return
                end
            end

            MgrMgr:GetMgr("PropMgr").CheckUseItem(l_info.UID, l_info.TID, function()
                if needUseTip then
                    CommonUI.Dialog.ShowYesNoDlg(true, nil, Common.Utils.Lang("Refund_Instructions_Payment_Items"), function()
                        self:RequestUseItem(l_info)
                    end)
                else
                    self:RequestUseItem(l_info)
                end
            end)
        end

        --大世界道具的特殊处理
        if oneItem.data.itemFunctionData.ItemFunction == 10 then
            self:AddButtonData(buttonDatas, Common.Utils.Lang("GO_EXCHANGE"), UseItemFunc, nil, nil, nil, nil)
            return
        end

        --消耗类物品使用Cd
        local useCd = oneItem.data.itemTableData.TypeTab == GameEnum.EItemType.Consume
        self:AddButtonData(buttonDatas, Common.Utils.Lang("Use"), UseItemFunc, nil, nil, nil, useCd, nil, self._checkCanUseItem, self)
    end

    --置换器卷轴类型 打开置换器界面
    if MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.UseDisplace) then
        if oneItem.data.itemTableData.TypeTab == 12 then
            self:AddButtonData(buttonDatas, Common.Utils.Lang("Use"), function()
                Common.CommonUIFunc.InvokeFunctionByFuncId(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.UseDisplace)
                self:HideTips()
            end)
        end
    end

    --属性点按钮
    local isInConsume, IsProperty, IsSkill = Common.CommonUIFunc.GetItemIdIsInConsumeIdTb(oneItem.data.itemTableData.ItemID)
    if isInConsume then
        local useCd = oneItem.data.itemTableData.TypeTab == 2
        self:AddButtonData(buttonDatas, Common.Utils.Lang("Use"), function()
            if IsProperty then
                Common.CommonUIFunc.OpenRoleInfoCtrlAndConsume()
            end

            if IsSkill then
                Common.CommonUIFunc.OpenSkillCtrlAndConsume()
            end
            self:HideTips()
        end, nil, nil, nil, useCd)
    end

    --消耗卷按钮
    local isBagAddedConsume = Common.CommonUIFunc.GetItemIdIsBagWeightAddedId(oneItem.data.itemTableData.ItemID)
    if isBagAddedConsume then
        local useCd = oneItem.data.itemTableData.TypeTab == 2
        self:AddButtonData(buttonDatas, Common.Utils.Lang("Use"), function()
            Common.CommonUIFunc.OpenBagConsume()
            self:HideTips()
        end, nil, nil, nil, useCd)
    end

    --载具经验道具
    if oneItem.data.itemTableData.TypeTab == 15 then
        self:AddButtonData(buttonDatas, Common.Utils.Lang("Use"), function()
            MgrMgr:GetMgr("VehicleInfoMgr").SendUpgradeVehicleMsg(oneItem.data.itemTableData.ItemID, 1)
            self:HideTips()
        end)
    end
end

function CommonItemTipsCtrl:_checkCanUseItem()
    if nil ~= MEntityMgr.PlayerEntity then
        local forbidUseItem = MEntityMgr.PlayerEntity:GetAttr(AttrType.ATTR_SPECIAL_NO_USE_ITEM)
        return 0 >= forbidUseItem
    end

    return true
end

--卡片抽取按钮
function CommonItemTipsCtrl:CreateExtractCardBtn(oneItem, buttonDatas)
    if oneItem.data.baseData.TID == tonumber(MgrMgr:GetMgr("MagicExtractMachineMgr").ExpendAAmount[0][0]) or
            oneItem.data.baseData.TID == tonumber(MgrMgr:GetMgr("MagicExtractMachineMgr").ExpendBCAmount[0][0]) then
        self:AddButtonData(buttonDatas, Common.Utils.Lang("Use"), function()
            MgrMgr:GetMgr("MagicExtractMachineMgr").CurrentMachineType = MgrMgr:GetMgr("MagicExtractMachineMgr").EMagicExtractMachineType.Card
            MgrMgr:GetMgr("MagicExtractMachineMgr").SetExtractMagicPreViewData({ expendamountid = oneItem.data.baseData.TID })
            --寻路成功才关闭对应界面
            local l_result = Common.CommonUIFunc.InvokeFunctionByFuncId(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.ExtractCard)
            if l_result then
                game:ShowMainPanel()
            end
        end)
    end
end

--头饰抽取按钮
function CommonItemTipsCtrl:CreateExtractHeadBtn(oneItem, buttonDatas)
    if oneItem.data.baseData.TID == tonumber(MgrMgr:GetMgr("MagicExtractMachineMgr").OrnamentExpendBCAmount[0][0]) then
        self:AddButtonData(buttonDatas, Common.Utils.Lang("Use"), function()
            --寻路成功才关闭对应界面
            local l_result = Common.CommonUIFunc.InvokeFunctionByFuncId(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.ExtractHead)
            if l_result then
                game:ShowMainPanel()
            end
        end)
    end
end

--装备抽取按钮
function CommonItemTipsCtrl:CreateExtractEquipBtn(oneItem, buttonDatas)
    --【【成长线复盘专项】装备稀有抽取屏蔽】 https://www.tapd.cn/20332331/prong/stories/view/1120332331001057897
    --if oneItem.data.baseData.TID == tonumber(MgrMgr:GetMgr("MagicExtractMachineMgr").EquipExpendAAmount[0][0]) or
    if oneItem.data.baseData.TID == tonumber(MgrMgr:GetMgr("MagicExtractMachineMgr").EquipExpendBCAmount[0][0]) then
        self:AddButtonData(buttonDatas, Common.Utils.Lang("Use"), function()
            MgrMgr:GetMgr("MagicExtractMachineMgr").CurrentMachineType = MgrMgr:GetMgr("MagicExtractMachineMgr").EMagicExtractMachineType.Equip
            MgrMgr:GetMgr("MagicExtractMachineMgr").SetExtractMagicPreViewData({ expendamountid = oneItem.data.baseData.TID })
            --寻路成功才关闭对应界面
            local l_result = Common.CommonUIFunc.InvokeFunctionByFuncId(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.ExtractEquip)
            if l_result then
                game:ShowMainPanel()
            end
        end)
    end
end

--钓鱼按钮
function CommonItemTipsCtrl:CreateOnFishUseBtn(oneItem, buttonDatas)
    self:AddButtonData(buttonDatas, Common.Utils.Lang("Use"), function()
        ---@type ItemData
        local locItem = oneItem.data.baseData
        local C_SVR_TYPE_MAP = {
            [1003] = LifeEquipType.LIFE_EQUIP_TYPE_FOD,
            [1004] = LifeEquipType.LIFE_EQUIP_TYPE_SEAT,
        }

        local svrType = C_SVR_TYPE_MAP[locItem.ItemConfig.Subclass]
        if nil == svrType then
            logError("[CommonItemTipsBaseTemplate] invalid sub class, id: " .. locItem.TID)
            return
        end

        MgrMgr:GetMgr("FishMgr").ReqUseFishItem(svrType, locItem.TID)
        self:HideTips()
    end)
end

function CommonItemTipsCtrl:CreateMerchantBtn(oneItem)
    local buttonDatas = {}
    if not MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Merchant) then
        return buttonDatas
    end

    local l_merchantMgr = MgrMgr:GetMgr("MerchantMgr")
    local l_data = DataMgr:GetData("MerchantData")
    if l_data.MerchantShopType == l_data.EMerchantShopType.Buy then
        self:AddButtonData(buttonDatas, Common.Utils.Lang("Buy"), function()
            local l_componentNum = self:GetTemplentByName(oneItem, "shopSetNum"):GetNumComponentValue()
            l_merchantMgr.RequestMerchantShopBuy(oneItem.data.baseData.TID, MLuaCommonHelper.Int(l_componentNum))
            self:HideTips()
        end)
        self:AddButtonData(buttonDatas, Common.Utils.Lang("DLG_BTN_NO"), function()
            self:HideTips()
        end)
    else
        self:AddButtonData(buttonDatas, Common.Utils.Lang("Shop_Sell"), function()
            l_merchantMgr.AddMerchantSellItem(oneItem.data.baseData.UID, 1)
            self:HideTips()
        end)
        self:AddButtonData(buttonDatas, Common.Utils.Lang("ONE_KEY_SELL"), function()
            l_merchantMgr.SellAllGoodsById(oneItem.data.baseData.TID)
            self:HideTips()
        end)
    end

    return buttonDatas
end

function CommonItemTipsCtrl:CreateMerchantToSellBtn(oneItem)
    local buttonDatas = {}
    if not MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Merchant) then
        return buttonDatas
    end

    local l_merchantMgr = MgrMgr:GetMgr("MerchantMgr")
    self:AddButtonData(buttonDatas, Common.Utils.Lang("Shop_Sell"), function()
        local l_tmp = oneItem.data.additionalData
        l_merchantMgr.ChangeToSellPanel(l_tmp)
        l_merchantMgr.AddMerchantSellItem(oneItem.data.baseData.UID, 1)
        self:HideTips()
    end)

    self:AddButtonData(buttonDatas, Common.Utils.Lang("ONE_KEY_SELL"), function()
        local l_tmp = oneItem.data.additionalData
        l_merchantMgr.ChangeToSellPanel(l_tmp)
        l_merchantMgr.SellAllGoodsById(oneItem.data.baseData.TID)
        self:HideTips()
    end)

    return buttonDatas
end

function CommonItemTipsCtrl:HideTips()
    UIMgr:DeActiveUI(UI.CtrlNames.CommonItemTips)
end

function CommonItemTipsCtrl:HideBag()
    UIMgr:DeActiveUI(UI.CtrlNames.Bag)
end

function CommonItemTipsCtrl:AddButtonData(buttonDatas, name, method, isShowRed, isStall, isTrade, isUseCd, isBlackShop, checkShowCdMethod, checkShowCdMethodSelf)
    local buttonData = {}
    buttonData.name = name
    buttonData.method = method
    buttonData.isShowRed = isShowRed
    buttonData.isStall = isStall
    buttonData.isTrade = isTrade
    buttonData.isUseCd = isUseCd
    buttonData.isBlackShop = isBlackShop
    buttonData.checkShowCdMethod = checkShowCdMethod
    buttonData.checkShowCdMethodSelf = checkShowCdMethodSelf
    table.insert(buttonDatas, buttonData)
end

function CommonItemTipsCtrl:SetShowCloseButton(isShow)
    if isShow == nil then
        isShow = false
    end

    self.panel.CloseButton.gameObject:SetActiveEx(isShow)
end

function CommonItemTipsCtrl:SetWearEquipMethod(method)
    self.OnWearEquipMethod = method
end

function CommonItemTipsCtrl:RefreshAppraiseInfo(uid)
    if uid == self.AppraiseId then
        local l_info = self:_getItemByUID(uid)
        self:ShowCompareWeaponTip(l_info)
    end
end
----------------------------------------------商店的购买Tips-------------------------------------------------------
function CommonItemTipsCtrl:ShowShopTip(propInfo, status, additionalData)
    --isBag,BuyShopItem,count

    if additionalData == nil then
        return
    end

    local equipTableInfo = TableUtil.GetEquipTable().GetRowById(propInfo.TID, true)
    local itemTableInfo = TableUtil.GetItemTable().GetRowByItemID(propInfo.TID)

    self:ClearTipsData()
    self.TipsInfo[1].data = {
        baseData = propInfo,
        equipTableData = equipTableInfo,
        itemTableData = itemTableInfo,
        equipStatus = status,
        additionalData = additionalData,
    }

    if additionalData.count == nil then
        self.TipsInfo[1].data.currentCount = 1
    else
        self.TipsInfo[1].data.currentCount = additionalData.count
    end

    if additionalData.buyShopItem ~= nil then
        self.TipsInfo[1].data.buyTableData = TableUtil.GetShopCommoditTable().GetRowById(additionalData.buyShopItem.table_id)
        self.TipsInfo[1].data.BuyShopItemData = additionalData.buyShopItem
    end

    self:RefreshTipsUI()
    self:FillShopItem(self.TipsInfo[1], additionalData.isBag)
end

--商店处理
function CommonItemTipsCtrl:FillShopItem(oneItem, isBag)
    local buyTable = oneItem.data.buyTableData
    --点击背包物体
    if isBag then
        if MgrMgr:GetMgr("ShopMgr").IsBuy then
            oneItem.btnPanel:SetActiveEx(false)
            --以下逻辑处理点击背包物体出售
        else
            --创建两个Templent
            local setNumTemplent = self:CreateSetNumTemplent(oneItem, "shopSetNum")
            local setInfoTemplent = self:CreateSetInfoTemplent(oneItem, "shopSetInfo")
            --设置出售价格相关
            local tbPrice = oneItem.data.itemTableData.RecycleValue:get_Item(1)
            local finNum = tostring(tbPrice)
            local finColor = Color.New(0, 0, 0)
            if not MgrMgr:GetMgr("ShopMgr").ShopSellToggleState and MgrMgr:GetMgr("ShopMgr").GetItemIsHaveMerchantAddition(oneItem.data.itemTableData.ItemID) then
                finNum = tostring(MgrMgr:GetMgr("ShopMgr").GetShopShowPrice(tbPrice * MgrMgr:GetMgr("ShopMgr").BussinessmanSellDisCountNum))
                finColor = Color.New(94 / 255, 177 / 255, 33 / 255)
            end
            local l_item
            -- 黑市
            local l_isBlackShop = MgrMgr:GetMgr("AuctionMgr").CanBlackShopSell(oneItem.data.baseData.TID)
            if l_isBlackShop then
                l_item = TableUtil.GetItemTable().GetRowByItemID(102)
            else
                l_item = TableUtil.GetItemTable().GetRowByItemID(oneItem.data.itemTableData.RecycleValue:get_Item(0))
            end
            local CoinData = nil
            if l_item then
                CoinData = {}
                CoinData.ItemAtlas = l_item.ItemAtlas
                CoinData.ItemIcon = l_item.ItemIcon
            else
                logError("找不到出售道具id:" .. tostring(l_item))
                CoinData = nil
            end
            setInfoTemplent:SetInfo(Common.Utils.Lang("Shop_SellCoin"), finNum, finColor, nil, CoinData)

            --以下设置购买数量相关
            local setNumTxt = Common.Utils.Lang("Shop_SellCount")
            local initValue = oneItem.data.baseData.ItemCount
            local minValue = 1
            local maxValue = oneItem.data.baseData.ItemCount
            local changeInterval = 1
            self:SetShopInputListener(oneItem)
            setNumTemplent:SetInfo(setNumTxt, initValue, minValue, maxValue, changeInterval)
        end
        oneItem.ui.transform.anchoredPosition = Vector2.New(-174, -11)
        --点击商店物体购买
    else
        --创建两个Templent
        local setNumTemplent = self:CreateSetNumTemplent(oneItem, "shopSetNum")
        local setInfoTemplent = self:CreateSetInfoTemplent(oneItem, "shopSetInfo")

        local ItemPerMount = buyTable.ItemPerMount
        local price = Common.Functions.VectorSequenceToTable(buyTable.ItemPerPrice)
        local maxValue
        local l_limitType, l_limitCount = MgrMgr:GetMgr("ShopMgr").GetBuyLimitType(buyTable)
        if l_limitType == MgrMgr:GetMgr("ShopMgr").eBuyLimitType.None then
            maxValue = math.floor(999 / ItemPerMount) * ItemPerMount
        else
            maxValue = oneItem.data.BuyShopItemData.left_time * ItemPerMount
        end
        oneItem.data.currentCount = math.ceil(oneItem.data.currentCount / ItemPerMount)

        --以下设置购买数量相关
        local setNumTxt = Common.Utils.Lang("Shop_BuyCount")
        local initValue = ItemPerMount * oneItem.data.currentCount
        local minValue = ItemPerMount
        local changeInterval = ItemPerMount
        local Discount = 1
        if buyTable.Discount == 0 then
        else
            Discount = buyTable.Discount / 10000
        end
        setNumTemplent:SetInfo(setNumTxt, initValue, minValue, maxValue, changeInterval)

        --以下设置购买所需的金币数量显示
        local finNum = ""
        local finColor = nil
        finNum = tostring(oneItem.data.currentCount * math.floor(price[1][2] * Discount))
        finColor = Color.New(52 / 255, 52 / 255, 52 / 255)
        --设置商人价格
        if MgrMgr:GetMgr("ShopMgr").GetItemIsHaveMerchantDiscount(buyTable.Id) and not MgrMgr:GetMgr("ShopMgr").ShopBuyToggleState then
            finNum = tostring(oneItem.data.currentCount * MgrMgr:GetMgr("ShopMgr").GetShopShowPrice(price[1][2] * Discount * MgrMgr:GetMgr("ShopMgr").BussinessmanBuyDisCountNum))
            finColor = Color.New(94 / 255, 177 / 255, 33 / 255)
        end

        local CoinTable = TableUtil.GetItemTable().GetRowByItemID(price[1][1])
        local CoinData = nil
        if CoinTable then
            CoinData = {}
            CoinData.ItemAtlas = CoinTable.ItemAtlas
            CoinData.ItemIcon = CoinTable.ItemIcon
            CoinData.ItemID = CoinTable.ItemID
        else
            logError("找不到出售道具id:" .. tostring(price[1][1]))
            CoinData = nil
        end

        setInfoTemplent:SetInfo(Common.Utils.Lang("Shop_BuyCoin"), finNum, finColor, nil, CoinData)
        self:SetShopInputListener(oneItem)
        oneItem.ui.transform.anchoredPosition = Vector2.New(173, -11)
    end
    self:GetTemplentByName(oneItem, "buttonTem"):SetAsLastSibling()
end

function CommonItemTipsCtrl:SetShopInputListener(oneItem)
    local InputNumListener = nil
    if MgrMgr:GetMgr("ShopMgr").IsBuy then
        InputNumListener = function(value)
            local buyTable = oneItem.data.buyTableData
            local Discount = 1
            if buyTable.Discount == 0 then
            else
                Discount = buyTable.Discount / 10000
            end
            local price = Common.Functions.VectorSequenceToTable(buyTable.ItemPerPrice)
            local ItemPerMount = buyTable.ItemPerMount
            local l_value = 0
            l_value = Common.Utils.Long2Num((value / ItemPerMount) * math.floor(price[1][2] * Discount))
            --设置商人价格
            if not MgrMgr:GetMgr("ShopMgr").ShopBuyToggleState and MgrMgr:GetMgr("ShopMgr").GetItemIsHaveMerchantDiscount(oneItem.data.buyTableData.Id) then
                l_value = tostring(MgrMgr:GetMgr("ShopMgr").GetShopShowPrice(l_value * MgrMgr:GetMgr("ShopMgr").BussinessmanBuyDisCountNum))
            end

            self:GetTemplentByName(oneItem, "shopSetInfo"):SetCountText(tostring(l_value))
            oneItem.data.currentCount = MLuaCommonHelper.Long2Int(value / ItemPerMount)
        end
        self:GetTemplentByName(oneItem, "shopSetNum"):SetInputNumListener(InputNumListener)
    else
        InputNumListener = function(value)
            local l_price = 0
            -- 黑市
            local l_isBlackShop = MgrMgr:GetMgr("AuctionMgr").CanBlackShopSell(oneItem.data.baseData.TID)
            if l_isBlackShop then
                l_price = MgrMgr:GetMgr("AuctionMgr").GetBlackShopSellPrice(oneItem.data.baseData, function(price)
                    l_price = price
                    if self:IsInited() then
                        self:GetTemplentByName(oneItem, "shopSetInfo"):SetCountText(tostring(value * l_price))
                        oneItem.data.currentCount = MLuaCommonHelper.Long2Int(value)
                    end
                end)
            else
                if oneItem.data.itemTableData.RecycleValue and oneItem.data.itemTableData.RecycleValue.Count >= 2 then
                    l_price = oneItem.data.itemTableData.RecycleValue:get_Item(1)
                end

                if not MgrMgr:GetMgr("ShopMgr").ShopSellToggleState and MgrMgr:GetMgr("ShopMgr").GetItemIsHaveMerchantAddition(oneItem.data.itemTableData.ItemID) then
                    l_price = tostring(MgrMgr:GetMgr("ShopMgr").GetShopShowPrice(l_price * MgrMgr:GetMgr("ShopMgr").BussinessmanSellDisCountNum))
                end
            end
            self:GetTemplentByName(oneItem, "shopSetInfo"):SetCountText(tostring(value * l_price))
            oneItem.data.currentCount = MLuaCommonHelper.Long2Int(value)
        end
        self:GetTemplentByName(oneItem, "shopSetNum"):SetInputNumListener(InputNumListener)
    end
end

-----------------------------------------------商城界面的特例商品------------------------------------------
---@param itemData ItemData
function CommonItemTipsCtrl:ShowMallTip(itemData, status, additionalData)
    if not additionalData then
        return
    end

    self:ClearTipsData()
    self.TipsInfo[1].data = {
        baseData = itemData,
        equipTableData = itemData.EquipConfig,
        itemTableData = itemData.ItemConfig,
        equipStatus = status,
        additionalData = additionalData,
    }
    self:RefreshTipsUI()

    --折扣标签
    --折扣和道具倒计时有一个不为空 就显示
    if additionalData.discounts or additionalData.discountsTime then
        local discountsTem = self:CreateDiscountsTem(self.TipsInfo[1], "dis")
        discountsTem:SetData(additionalData)
    end

    local setNumTemplent = self:CreateSetNumTemplent(self.TipsInfo[1], "shopSetNum")
    local setInfoTemplent = self:CreateSetInfoTemplent(self.TipsInfo[1], "shopSetInfo")

    --刷新费用显示
    local l_coinData = TableUtil.GetItemTable().GetRowByItemID(additionalData.priceID)
    if not l_coinData then
        logError("找不到出售道具id:" .. tostring(additionalData.priceID))
    end
    local l_resetInfo = function()
        local l_num = setNumTemplent:GetNumComponentValue() * (additionalData.priceNum or 0)
        local l_curCount = Data.BagModel:GetCoinOrPropNumById(additionalData.priceID)
        local l_color = l_curCount < l_num and Color.New(1, 0, 0) or Color.New(60 / 255, 60 / 255, 60 / 255, 1)
        setInfoTemplent:SetInfo(Lang("Shop_BUY_CONSUM"), tostring(l_num), nil, l_color, l_coinData)--花费
    end

    --数量输入
    local maxValue = math.max(additionalData.maxValue or 0, 0)
    local minValue = maxValue > 0 and 1 or 0
    setNumTemplent:SetInfo(Lang("Shop_BuyCount"), minValue, minValue, maxValue, 1)
    setNumTemplent:SetInputNumListener(function()
        l_resetInfo()
    end)

    --费用显示
    l_resetInfo()

    -- 退款说明(目前只有韩国用)
    if Data.BagModel:IsDiamond(additionalData.priceID) and MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.PaymentTips) then
        local paymentInstruction = self:CreatePaymentInstructionsTemplate(self.TipsInfo[1])
        paymentInstruction:SetData({})
    end

    --购买按钮
    self.buttonstatus = {}
    self:AddButtonData(self.buttonstatus, Lang("Buy"), function()
        --防止界面隐藏数据被干掉
        local l_num = setNumTemplent:GetNumComponentValue()
        local l_call = additionalData.buyFunc
        self:HideTips()
        if l_call then
            l_call(l_num)
        end
    end)
    local buttonTem = self:CreateSetButtonTemplent(self.TipsInfo[1], "buyBtn")
    buttonTem:CreatePanelBtnByButtonDates(buttonTem, self.buttonstatus, self.TipsInfo[1].data.baseData, additionalData)
    buttonTem:SetAsLastSibling()
end

------------------------------------------------------------------------------------------------------------------

---------------------------------------------显示多个Tips进行装备对比 按钮显示更换 -------------------------------
---@param itemData ItemData
function CommonItemTipsCtrl:ShowCompareWeaponTip(itemData, additionalData)
    --首先要检查是什么部位的，看要不要对比
    local equipTableInfo = itemData.EquipConfig
    local itemTableInfo = itemData.ItemConfig
    local l_eId = equipTableInfo.EquipId
    local l_pos = Data.BagModel.WeapTableType[l_eId]
    local l_index = 1
    self:ClearTipsData()
    self.mainItemUid = itemData.UID
    --对应的装备孔位要对比
    if Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.Equip, l_pos + 1) then
        local comPropInfo = Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.Equip, l_pos + 1)
        local comEquipTableInfo = comPropInfo.EquipConfig
        local comItemTableInfo = comPropInfo.ItemConfig
        self.TipsInfo[l_index].data = {
            baseData = comPropInfo,
            equipTableData = comEquipTableInfo,
            itemTableData = comItemTableInfo,
            equipStatus = Data.BagModel.WeaponStatus.JUST_COMPARE,
        }
        if l_pos == EquipPos.ORNAMENT1 then
            self.TipsInfo[l_index].data.equipStatus = Data.BagModel.WeaponStatus.JUST_COMPARE_ORNAMENT1
        end

        if l_pos == EquipPos.MAIN_WEAPON then
            if MPlayerInfo:GetCurrentSkillInfo(Data.BagModel.AssassinDoubleHandSkillID).lv > 0 then
                self.TipsInfo[l_index].data.equipStatus = Data.BagModel.WeaponStatus.JUST_COMPARE_Dagger1
            end
        end

        if itemData.UID ~= comPropInfo.UID then
            l_index = l_index + 1
        end
    end

    --饰品的话，看看要不要对比第二个孔位
    if l_pos == EquipPos.ORNAMENT1 then
        local targetItem = Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.Equip, EquipPos.ORNAMENT2 + 1)
        if targetItem ~= nil then
            local comPropInfo = targetItem
            local comEquipTableInfo = TableUtil.GetEquipTable().GetRowById(comPropInfo.TID)
            local comItemTableInfo = TableUtil.GetItemTable().GetRowByItemID(comPropInfo.TID)
            self.TipsInfo[l_index].data = {
                baseData = comPropInfo,
                equipTableData = comEquipTableInfo,
                itemTableData = comItemTableInfo,
                equipStatus = Data.BagModel.WeaponStatus.JUST_COMPARE_ORNAMENT2,
            }
            if itemData.UID ~= comPropInfo.UID then
                l_index = l_index + 1
            end
        end
    end

    if l_pos == EquipPos.MAIN_WEAPON then
        if MPlayerInfo:GetCurrentSkillInfo(Data.BagModel.AssassinDoubleHandSkillID).lv > 0 then
            local targetItem = Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.Equip, EquipPos.SECONDARY_WEAPON + 1)
            if targetItem ~= nil then
                local comPropInfo = targetItem
                local comEquipTableInfo = TableUtil.GetEquipTable().GetRowById(comPropInfo.TID)
                local comItemTableInfo = TableUtil.GetItemTable().GetRowByItemID(comPropInfo.TID)
                self.TipsInfo[l_index].data = {
                    baseData = comPropInfo,
                    equipTableData = comEquipTableInfo,
                    itemTableData = comItemTableInfo,
                    equipStatus = Data.BagModel.WeaponStatus.JUST_COMPARE_Dagger2,
                }
                if itemData.UID ~= comPropInfo.UID then
                    l_index = l_index + 1
                end
            end
        end

    end

    --自身的属性
    self.TipsInfo[l_index].data = {
        baseData = itemData,
        equipTableData = equipTableInfo,
        itemTableData = itemTableInfo,
        equipStatus = Data.BagModel.WeaponStatus.IN_BAG,
        buttonStatus = Data.BagModel.ButtonStatus.Show,
    }
    self:RefreshTipsUI(l_index, additionalData)
end
----------------------------------------------------------------------------------------------------------------------

---------------------------------------------查看玩家身上的装备 按钮显示卸下 不现实对比 ------------------------------
function CommonItemTipsCtrl:ShowWeaponPropTip(propInfo)
    local equipTableInfo = TableUtil.GetEquipTable().GetRowById(propInfo.TID)
    local itemTableInfo = TableUtil.GetItemTable().GetRowByItemID(propInfo.TID)

    self:ClearTipsData()
    self.TipsInfo[1].data = {
        baseData = propInfo,
        equipTableData = equipTableInfo,
        itemTableData = itemTableInfo,
        equipStatus = Data.BagModel.WeaponStatus.ON_BODY,
        buttonStatus = Data.BagModel.ButtonStatus.Show,
    }
    self:RefreshTipsUI()
end
----------------------------------------------------------------------------------------------------------------------

-------------------------------------------------显示摆摊的Tips 独立处理 @胡胜----------------------------------------
---@param propInfo ItemData
function CommonItemTipsCtrl:ShowStallTip(propInfo, status, additionalData)
    local equipTableInfo = propInfo.EquipConfig
    local itemTableInfo = propInfo.ItemConfig
    local itemFunctionInfo = propInfo.ItemFunctionConfig
    self:ClearTipsData()

    --摆摊不显示属性 所以屏蔽属性
    --local l_propInfo = Data.BagModel:CreateItemWithTid(propInfo.TID)
    self.TipsInfo[1].data = {
        baseData = propInfo,
        equipTableData = equipTableInfo,
        itemTableData = itemTableInfo,
        itemFunctionData = itemFunctionInfo,
        equipStatus = status,
        additionalData = additionalData,
    }

    --用于处理摆摊物品倒计时信息
    local l_stallUid = additionalData and additionalData.stallUid or 0
    local leftTime = MgrMgr:GetMgr("StallMgr").GetSellItemLeftTimeByUid(l_stallUid)
    if leftTime > 0 then
        leftTime = math.floor(leftTime / 3600)
        if leftTime >= 1 then
            self.TipsInfo[1].data.stallOverTimeStr = Lang("STALL_PUTON_LEFT_TIME", leftTime)
        else
            self.TipsInfo[1].data.stallOverTimeStr = Lang("STALL_PUTON_LESS_THAN_ONE_HOUR")
        end
    end

    self:RefreshTipsUI(2)
end

------->>以下为摆摊购买逻辑处理---------
function CommonItemTipsCtrl:ShowStallBuyPanel(itemId, price, maxNum, callback, buyCount)

    --创建所需要的Templent
    local temSetBuyNum = self:CreateSetNumTemplent(self:GetTipsInfo(), "StallBuyNum")
    local temOnePrice = self:CreateSetInfoTemplent(self:GetTipsInfo(), "StallOnePrice")
    local temTotalPrice = self:CreateSetInfoTemplent(self:GetTipsInfo(), "StallTotalPrice")
    local temButtoninfo = self:CreateSetButtonTemplent(self:GetTipsInfo(), "StallSellButtoninfo")

    local l_max = maxNum
    local l_canGetMaxNum = maxNum
    local l_state, l_num = Data.BagModel:getMaxItemNum(itemId)
    if l_num < 1 then
        l_num = 1
    end
    if l_state then
        l_canGetMaxNum = l_num
    end

    buyCount = math.min(buyCount, l_max)
    temSetBuyNum:SetInfo(Common.Utils.Lang("Shop_BuyCount"), buyCount, 1, l_max, 1)
    temSetBuyNum.Parameter.SetNumCount.InputNumber.OnValueChange = (function(value)
        temTotalPrice:SetCountText(tostring(value * price))
    end)

    local l_showTips = false
    temSetBuyNum.Parameter.SetNumCount.InputNumber.OnAddButtonClick = function()
        local l_num = temSetBuyNum:GetNumComponentValue()
        local l_state = MLuaCommonHelper.Long2Int(l_num) >= l_canGetMaxNum
        if not l_showTips and l_state then
            l_showTips = true
            return
        end
        if l_showTips then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("BAG_LIMIT_BUY"))
        end
    end

    temSetBuyNum.Parameter.SetNumCount.InputNumber.OnSubtractButtonClick = function()
        local l_num = temSetBuyNum:GetNumComponentValue()
        local l_state = MLuaCommonHelper.Long2Int(l_num) >= l_canGetMaxNum
        if l_showTips and not l_state then
            l_showTips = false
            return
        end
    end

    temOnePrice:SetInfo(Common.Utils.Lang("ONE_ITEM_PRICE"), price, nil, nil, { ItemAtlas = "Icon_ItemConsumables01", ItemIcon = "UI_icon_item_Zeng.png" })
    temTotalPrice:SetInfo(Common.Utils.Lang("TOTAL_ITEM_PRICE"), tostring(price * buyCount), nil, nil, { ItemID = GameEnum.l_virProp.Coin101, ItemAtlas = "Icon_ItemConsumables01", ItemIcon = "UI_icon_item_Zeng.png" })
    --数量还没有设置
    local l_tipsInfo = self:GetTipsInfo()
    self.buttonstatus = self:CreateStallBuyBtn(l_tipsInfo, {}, callback, itemId)
    temButtoninfo:CreatePanelBtnByButtonDates(temButtoninfo, self.buttonstatus, l_tipsInfo.data.baseData)
    temButtoninfo:SetAsLastSibling()
end

function CommonItemTipsCtrl:CreateStallBuyBtn(oneItem, buttonDatas, callback, itemId)
    self:AddButtonData(buttonDatas, Common.Utils.Lang("Buy"), function()
        local l_setNumTem = self:GetTemplentByName(oneItem, "StallBuyNum")
        if l_setNumTem then
            local l_num = l_setNumTem:GetNumComponentValue()
            callback(itemId, l_num)
        end
        self:HideTips()
    end)
    self:AddButtonData(buttonDatas, Common.Utils.Lang("DLG_BTN_NO"), function()
        self:HideTips()
    end)
    return buttonDatas
end
------->>以下为摆摊购买逻辑处理---------

---------------->>以下为摆摊下架----------------
function CommonItemTipsCtrl:ShowStallSellPanel(itemId, price, callback)
    local temOthers = self:CreateOthersTemplent(self:GetTipsInfo(), "StallSellOthers")
    local temSetinfo = self:CreateSetInfoTemplent(self:GetTipsInfo(), "StallSellSetinfo")
    local temButtoninfo = self:CreateSetButtonTemplent(self:GetTipsInfo(), "StallSellButtoninfo")
    local finNum = price
    local CoinData = {}
    CoinData.ItemAtlas = "Icon_ItemConsumables01"
    CoinData.ItemIcon = "UI_icon_item_Zeng.png"
    --CoinData.ItemID = GameEnum.l_virProp.Coin101
    temOthers:SetInfo(nil, true)
    temSetinfo:SetInfo(Common.Utils.Lang("STALL_SPECIAL_PRICE") .. "：", finNum, nil, nil, CoinData)
    local l_tipsInfo = self:GetTipsInfo()
    self.buttonstatus = self:CreateStallSellBtn(l_tipsInfo, {}, callback, itemId)
    temButtoninfo:CreatePanelBtnByButtonDates(temButtoninfo, self.buttonstatus, l_tipsInfo.data.baseData)
    temButtoninfo:SetAsLastSibling()
end

function CommonItemTipsCtrl:CreateStallSellBtn(oneItem, buttonDatas, callback, itemId)
    self:AddButtonData(buttonDatas, Common.Utils.Lang("STELL_OUT_STALL"), function()
        callback(itemId)
        self:HideTips()
    end)
    self:AddButtonData(buttonDatas, Common.Utils.Lang("DLG_BTN_NO"), function()
        self:HideTips()
    end)
    return buttonDatas
end
--------------->>以上为摆摊下架----------------

--------------->>>以下为重复上架的逻辑-------------
function CommonItemTipsCtrl:ShowStallRepeatSellPanel(itemId, curPrice, basePrice, num, callback)

    local temOthers = self:CreateOthersTemplent(self:GetTipsInfo(), "StallSellOthers")
    local temSetNum = self:CreateSetInfoTemplent(self:GetTipsInfo(), "StallPutOnNum")
    local temSetprice = self:CreateSetNumPassiveTemplent(self:GetTipsInfo(), "StallPutOnPrice")
    local temAllPrice = self:CreateSetInfoTemplent(self:GetTipsInfo(), "StallPutOnAllPrice")
    local temPutOnStallPrice = self:CreateSetInfoTemplent(self:GetTipsInfo(), "StallPutOnStallPrice")
    local temButtoninfo = self:CreateSetButtonTemplent(self:GetTipsInfo(), "StallSellButtoninfo")

    local l_rateDes = MGlobalConfig:GetFloat("StallRate") / 100
    local l_minValue = MGlobalConfig:GetFloat("StallRateMinValue")
    local l_maxValue = MGlobalConfig:GetFloat("StallRateMaxValue")

    local l_mgr = MgrMgr:GetMgr("StallMgr")
    local l_rate = MGlobalConfig:GetFloat("StallRate") / 10000
    local l_stallMax = MGlobalConfig:GetFloat("StallRateMaxValue")
    local l_stallMin = MGlobalConfig:GetFloat("StallRateMinValue")
    local l_curPrice, l_minPrice, l_maxPrice, l_priceInterval, l_priceLimit = l_mgr.GetPriceRange(itemId, MLuaCommonHelper.Long2Int(curPrice))
    self.curRepeatPrice = l_curPrice
    local l_tempPrice = math.modf(self.curRepeatPrice)
    self.curRepeatNum = 0
    self.curRepeatPriceMax = false
    self.curRepeatPriceMin = false
    self.curRepeatIndex = 0
    self.curRepeatValue = l_tempPrice * num

    local l_tableInfo = l_mgr.g_tableItemInfo[itemId]
    local l_min = l_tableInfo.info.PriceLimit:get_Item(0)
    local l_max = l_tableInfo.info.PriceLimit:get_Item(1)

    local methodAdd = function()
        if l_priceLimit then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("STALL_PRICE_LIMIT"))
            return
        end
        if self.curRepeatPrice + l_priceInterval >= l_maxPrice then
            if not self.curRepeatPriceMax then
                self.curRepeatIndex = self.curRepeatIndex + 1
            end
            self.curRepeatPriceMax = true
            self.curRepeatPrice = l_maxPrice
        else
            self.curRepeatPriceMax = false
            self.curRepeatIndex = self.curRepeatIndex + 1
            self.curRepeatPrice = l_curPrice + l_priceInterval * self.curRepeatIndex
        end
        local l_tempPrice = math.modf(self.curRepeatPrice)
        self.curRepeatValue = tonumber(l_tempPrice * num)
        self.curRepeatStallPrice = l_rate * l_tempPrice * num
        self.curRepeatStallPrice = math.max(self.curRepeatStallPrice, l_stallMin)
        self.curRepeatStallPrice = math.min(self.curRepeatStallPrice, l_stallMax)
        temSetprice.Parameter.CoinCount.LabText = tostring(l_tempPrice)
        temAllPrice:SetCountText(self.curRepeatValue)
        temPutOnStallPrice:SetCountText(math.modf(self.curRepeatStallPrice))
        self:SetStallPriceInterval(temOthers.Parameter.OtherTipsInfo, l_tempPrice, basePrice)

        if self.curRepeatPriceMax then
            if self.curRepeatPrice == l_max then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("STALL_PRICE_UPPER_LIMIT"))
            else
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("STALL_FLOAT_UPPER_LIMIT"))
            end
        end
    end

    local methodDec = function()
        if l_priceLimit then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("STALL_PRICE_LIMIT"))
            return
        end
        if self.curRepeatPrice - l_priceInterval <= l_minPrice then
            if not self.curRepeatPriceMin then
                self.curRepeatIndex = self.curRepeatIndex - 1
            end
            self.curRepeatPriceMin = true
            self.curRepeatPrice = l_minPrice
        else
            self.curRepeatPriceMin = false
            self.curRepeatIndex = self.curRepeatIndex - 1
            self.curRepeatPrice = l_curPrice + l_priceInterval * self.curRepeatIndex
        end
        local l_tempPrice = math.modf(self.curRepeatPrice)
        self.curRepeatValue = l_tempPrice * num
        self.curRepeatStallPrice = l_rate * tonumber(self.curRepeatValue)
        self.curRepeatStallPrice = math.max(self.curRepeatStallPrice, l_stallMin)
        self.curRepeatStallPrice = math.min(self.curRepeatStallPrice, l_stallMax)
        temSetprice.Parameter.CoinCount.LabText = tostring(l_tempPrice)
        temAllPrice:SetCountText(self.curRepeatValue)
        temPutOnStallPrice:SetCountText(math.modf(self.curRepeatStallPrice))
        self:SetStallPriceInterval(temOthers.Parameter.OtherTipsInfo, l_tempPrice, basePrice)

        if self.curRepeatPriceMin then
            if self.curRepeatPrice == l_min then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("STALL_PRICE_LOWER_LIMIT"))
            else
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("STALL_FLOAT_LOWER_LIMIT"))
            end
        end
    end
    self.curRepeatStallPrice = l_rate * tonumber(self.curRepeatValue)
    self.curRepeatStallPrice = math.max(self.curRepeatStallPrice, l_stallMin)
    self.curRepeatStallPrice = math.min(self.curRepeatStallPrice, l_stallMax)
    temSetprice.Parameter.CoinCount.LabText = tostring(l_tempPrice)
    temAllPrice:SetCountText(self.curRepeatValue)
    temPutOnStallPrice:SetCountText(math.modf(self.curRepeatStallPrice))
    self:SetStallPriceInterval(temOthers.Parameter.OtherTipsInfo, l_tempPrice, basePrice)

    self:SetStallPriceInterval(temOthers.Parameter.OtherTipsInfo, l_tempPrice, basePrice)
    temOthers:SetInfo("", false)
    temSetNum:SetInfo(Common.Utils.Lang("TOTAL_NUM"), num, nil, nil, nil, nil, nil)
    temSetprice:SetInfo(Common.Utils.Lang("ONE_ITEM_PRICE"), l_tempPrice, methodAdd, methodDec, nil, nil, { ItemID = GameEnum.l_virProp.Coin101, ItemAtlas = "Icon_ItemConsumables01", ItemIcon = "UI_icon_item_Zeng.png" })
    temAllPrice:SetInfo(Common.Utils.Lang("TOTAL_ITEM_PRICE"), self.curRepeatValue, nil, nil, { ItemID = GameEnum.l_virProp.Coin101, ItemAtlas = "Icon_ItemConsumables01", ItemIcon = "UI_icon_item_Zeng.png" }, nil)
    local tipsData = { text = StringEx.Format(Common.Utils.Lang("STALL_HELPINFO"), tostring(l_rateDes) .. "%", l_minValue, l_maxValue) }
    temPutOnStallPrice:SetInfo(Common.Utils.Lang("STALL_PRICE"), math.modf(self.curRepeatStallPrice), nil, nil, { ItemID = GameEnum.l_virProp.Coin101, ItemAtlas = "Icon_ItemConsumables01", ItemIcon = "UI_icon_item_Zeng.png" }, tipsData)
    local l_tipsInfo = self:GetTipsInfo()
    self.buttonstatus = self:CreateStallRepeatSellBtn(l_tipsInfo, {}, callback, itemId, num)
    temButtoninfo:CreatePanelBtnByButtonDates(temButtoninfo, self.buttonstatus, l_tipsInfo.data.baseData)
    temButtoninfo:SetAsLastSibling()
end

function CommonItemTipsCtrl:CreateStallRepeatSellBtn(oneItem, buttonDatas, callback, itemId, num)
    self:AddButtonData(buttonDatas, Common.Utils.Lang("STELL_ON_STALL_NOW"), function()
        local l_tempPrice = math.modf(self.curRepeatPrice)
        local l_tempStallPrice = math.modf(self.curRepeatStallPrice)
        callback(itemId, num, l_tempPrice, true, l_tempStallPrice)
        self:HideTips()
    end)
    self:AddButtonData(buttonDatas, Common.Utils.Lang("STELL_OUT_STALL_NOW"), function()
        local l_tempStallPrice = math.modf(self.curRepeatStallPrice)
        callback(itemId, nil, nil, false, l_tempStallPrice)
        self:HideTips()
    end)
    return buttonDatas
end
--------------->>>以上为重复上架的逻辑-------------

--------------->>>以下摆摊上架逻辑-----------------
function CommonItemTipsCtrl:ShowStallPutOnPanel(itemId, uid, basePrice, maxNum, callback)

    local temOthers = self:CreateOthersTemplent(self:GetTipsInfo(), "StallSellOthers")
    local temSetprice = self:CreateSetNumPassiveTemplent(self:GetTipsInfo(), "StallPutOnPrice")
    local temSetNum = self:CreateSetNumTemplent(self:GetTipsInfo(), "StallPutOnNum")
    local temAllPrice = self:CreateSetInfoTemplent(self:GetTipsInfo(), "StallPutOnAllPrice")
    local temPutOnStallPrice = self:CreateSetInfoTemplent(self:GetTipsInfo(), "StallPutOnStallPrice")
    local temButtoninfo = self:CreateSetButtonTemplent(self:GetTipsInfo(), "StallSellButtoninfo")

    maxNum = maxNum or 0
    temOthers:SetInfo("", false)
    temSetNum:SetInfo(Common.Utils.Lang("TOTAL_NUM"), maxNum, 1, maxNum, 1, nil, nil, nil, nil)

    local l_rateDes = MGlobalConfig:GetInt("StallRate") / 100
    local l_minValue = MGlobalConfig:GetInt("StallRateMinValue")
    local l_maxValue = MGlobalConfig:GetInt("StallRateMaxValue")

    local l_mgr = MgrMgr:GetMgr("StallMgr")
    local l_rateValue = MGlobalConfig:GetFloat("StallRate")
    local l_rate = l_rateValue / 10000
    local l_stallMax = MGlobalConfig:GetFloat("StallRateMaxValue")
    local l_stallMin = MGlobalConfig:GetFloat("StallRateMinValue")
    self.curPutOnPrice = MLuaCommonHelper.Long2Int(basePrice)
    local l_curPrice, l_minPrice, l_maxPrice, l_priceInterval, l_priceLimit = l_mgr.GetPriceRange(itemId, self.curPutOnPrice)
    self.curPutOnNum = 0
    self.curPutOnPrice = l_curPrice
    self.curPutOnPriceMax = false
    self.curPutOnPriceMin = false
    self.curPutOnIndex = 0
    self.curPutOnNum = maxNum
    local l_tempPrice = math.modf(self.curPutOnPrice)
    self.curPutOnValue = l_tempPrice * self.curPutOnNum

    local l_tableInfo = l_mgr.g_tableItemInfo[itemId]
    local l_min = l_tableInfo.info.PriceLimit:get_Item(0)
    local l_max = l_tableInfo.info.PriceLimit:get_Item(1)

    local InputNumListener = function(value)
        self.curPutOnNum = MLuaCommonHelper.Long2Int(value)
        local l_tempPrice = math.modf(self.curPutOnPrice)
        self.curPutOnValue = l_tempPrice * self.curPutOnNum
        self.curPutOnStallPrice = l_rate * tonumber(self.curPutOnValue)

        if l_stallMin >= self.curPutOnStallPrice then
            self.curPutOnStallPrice = l_stallMin
        end

        if l_stallMax <= self.curPutOnStallPrice then
            self.curPutOnStallPrice = l_stallMax
        end
        temSetprice.Parameter.CoinCount.LabText = tostring(l_tempPrice)
        temAllPrice:SetCountText(self.curPutOnValue)
        temPutOnStallPrice:SetCountText(math.modf(self.curPutOnStallPrice))
    end

    temSetNum:SetInputNumListener(InputNumListener)

    local methodAdd = function()
        if l_priceLimit then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("STALL_PRICE_LIMIT"))
            return
        end
        if self.curPutOnPrice + l_priceInterval >= l_maxPrice then
            if not self.curPutOnPriceMax then
                self.curPutOnIndex = self.curPutOnIndex + 1
            end
            self.curPutOnPriceMax = true
            self.curPutOnPrice = l_maxPrice
        else
            self.curPutOnPriceMax = false
            self.curPutOnIndex = self.curPutOnIndex + 1
            self.curPutOnPrice = l_curPrice + l_priceInterval * self.curPutOnIndex
        end
        local l_tempPrice = math.modf(self.curPutOnPrice)
        self.curPutOnValue = l_tempPrice * self.curPutOnNum
        self.curPutOnStallPrice = l_rate * tonumber(self.curPutOnValue)

        if l_stallMin >= self.curPutOnStallPrice then
            self.curPutOnStallPrice = l_stallMin
        end

        if l_stallMax <= self.curPutOnStallPrice then
            self.curPutOnStallPrice = l_stallMax
        end

        temSetprice.Parameter.CoinCount.LabText = tostring(l_tempPrice)
        temAllPrice:SetCountText(self.curPutOnValue)
        temPutOnStallPrice:SetCountText(math.modf(self.curPutOnStallPrice))
        self:SetStallPriceInterval(temOthers.Parameter.OtherTipsInfo, l_tempPrice, basePrice)

        if self.curPutOnPriceMax then
            if self.curPutOnPrice == l_max then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("STALL_PRICE_UPPER_LIMIT"))
            else
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("STALL_FLOAT_UPPER_LIMIT"))
            end
        end
    end

    local methodDec = function()
        if l_priceLimit then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("STALL_PRICE_LIMIT"))
            return
        end
        if self.curPutOnPrice - l_priceInterval <= l_minPrice then
            if not self.curPutOnPriceMin then
                self.curPutOnIndex = self.curPutOnIndex - 1
            end
            self.curPutOnPriceMin = true
            self.curPutOnPrice = l_minPrice
        else
            self.curPutOnPriceMin = false
            self.curPutOnIndex = self.curPutOnIndex - 1
            self.curPutOnPrice = l_curPrice + l_priceInterval * self.curPutOnIndex
        end
        local l_tempPrice = math.modf(self.curPutOnPrice)
        self.curPutOnValue = l_tempPrice * self.curPutOnNum
        self.curPutOnStallPrice = l_rate * tonumber(self.curPutOnValue)
        if l_stallMin >= self.curPutOnStallPrice then
            self.curPutOnStallPrice = l_stallMin
        end

        if l_stallMax <= self.curPutOnStallPrice then
            self.curPutOnStallPrice = l_stallMax
        end

        temSetprice.Parameter.CoinCount.LabText = tostring(l_tempPrice)
        temAllPrice:SetCountText(self.curPutOnValue)
        temPutOnStallPrice:SetCountText(math.modf(self.curPutOnStallPrice))
        self:SetStallPriceInterval(temOthers.Parameter.OtherTipsInfo, l_tempPrice, basePrice)

        if self.curPutOnPriceMin then
            if self.curPutOnPrice == l_min then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("STALL_PRICE_LOWER_LIMIT"))
            else
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("STALL_FLOAT_LOWER_LIMIT"))
            end
        end
    end

    self.curPutOnStallPrice = l_rate * tonumber(self.curPutOnValue)
    if l_stallMin >= self.curPutOnStallPrice then
        self.curPutOnStallPrice = l_stallMin
    end

    if l_stallMax <= self.curPutOnStallPrice then
        self.curPutOnStallPrice = l_stallMax
    end

    self:SetStallPriceInterval(temOthers.Parameter.OtherTipsInfo, l_tempPrice, basePrice)
    temSetprice:SetInfo(Common.Utils.Lang("ONE_ITEM_PRICE"), l_tempPrice, methodAdd, methodDec, nil, nil, { ItemAtlas = "Icon_ItemConsumables01", ItemIcon = "UI_icon_item_Zeng.png" })
    temAllPrice:SetInfo(Common.Utils.Lang("TOTAL_ITEM_PRICE"), self.curPutOnValue, nil, nil, { ItemAtlas = "Icon_ItemConsumables01", ItemIcon = "UI_icon_item_Zeng.png" }, nil)

    local maxValueText = MNumberFormat.GetNumberFormat(l_maxValue)
    local tipsData = { text = StringEx.Format(Common.Utils.Lang("STALL_HELPINFO"), tostring(l_rateDes) .. "%", l_minValue, maxValueText) }
    temPutOnStallPrice:SetInfo(Common.Utils.Lang("STALL_PRICE"), math.modf(self.curPutOnStallPrice), nil, nil, { ItemID = GameEnum.l_virProp.Coin101, ItemAtlas = "Icon_ItemConsumables01", ItemIcon = "UI_icon_item_Zeng.png" }, tipsData)
    local l_tipsInfo = self:GetTipsInfo()
    self.buttonstatus = self:CreateStallPutOnBtn(l_tipsInfo, {}, callback, itemId, uid)
    temButtoninfo:CreatePanelBtnByButtonDates(temButtoninfo, self.buttonstatus, l_tipsInfo.data.baseData)
    temButtoninfo:SetAsLastSibling()
end

function CommonItemTipsCtrl:CreateStallPutOnBtn(oneItem, buttonDatas, callback, itemId, uid)
    self:AddButtonData(buttonDatas, Common.Utils.Lang("STELL_ON_STALL"), function()
        local l_tempPrice = math.modf(self.curPutOnPrice)
        local l_tempStallPrice = math.modf(self.curPutOnStallPrice)
        callback(itemId, uid, self.curPutOnNum, l_tempPrice, l_tempStallPrice)
        self:HideTips()
    end)
    self:AddButtonData(buttonDatas, Common.Utils.Lang("DLG_BTN_NO"), function()
        self:HideTips()
    end)
    return buttonDatas
end
------------------>>以上摆摊上架逻辑-----------------------------------

function CommonItemTipsCtrl:SetStallPriceInterval(lab, curPrice, basePrice)
    lab.LabText, lab.LabColor = MgrMgr:GetMgr("StallMgr").GetRecommendedPriceTextAndColor(curPrice, basePrice)
end
-------------------------------------------------摆摊业务逻辑 @胡胜-------------------------------------------------

-------------------------------------------------以下为接口函数-----------------------------------------------------
--设置独立一个Tips出现的时候的位置
function CommonItemTipsCtrl:SetSelfPos(pos)
    local activeNum = 0
    for i = 1, 3 do
        if self.TipsInfo and self.TipsInfo[i] and self.TipsInfo[i].ui ~= nil and self.TipsInfo[i].ui.gameObject.activeSelf then
            activeNum = activeNum + 1
        end
    end

    if pos then
        if activeNum == 1 then
            self.TipsInfo[1].ui.transform.anchoredPosition = pos;
        end
    end
end

--返回只有一个Tips显示的时候的x和y坐标 宽度和高度用于道具获取途径位置设置
function CommonItemTipsCtrl:GetSelfTipsPosInfo()
    local activeNum = 0
    for i = 1, 3 do
        if self.TipsInfo and self.TipsInfo[i] and self.TipsInfo[i].ui ~= nil and self.TipsInfo[i].ui.gameObject.activeSelf then
            activeNum = activeNum + 1
        end
    end

    if activeNum == 1 then
        local trans = self.TipsInfo[1].ui.transform
        local rtTrans = self.TipsInfo[1].ui.transform:GetComponent("RectTransform")
        LayoutRebuilder.ForceRebuildLayoutImmediate(rtTrans)
        return trans.anchoredPosition.x, trans.anchoredPosition.y, trans.sizeDelta.x, trans.sizeDelta.y
    end

    return 0, 0, 0, 0
end

function CommonItemTipsCtrl:GetTipsInfo()
    if self.TipsInfo[1] then
        return self.TipsInfo[1]
    end
    return nil
end

--创建左右有加减号的Templent
function CommonItemTipsCtrl:CreateSetNumTemplent(oneItem, temName)
    if oneItem.setNumTemplentTb == nil then
        oneItem.setNumTemplentTb = {}
    end

    local l_setNumTem = self:NewTemplate("CommonItemTipsSetNumTemplent", { TemplateParent = oneItem.LuaUIGroup.transform })
    l_setNumTem.localName = "SetNum" .. temName
    table.insert(oneItem.setNumTemplentTb, l_setNumTem)
    return l_setNumTem
end

--创建优惠组件
function CommonItemTipsCtrl:CreateDiscountsTem(oneItem, temName)
    oneItem.discountsTemTb = oneItem.discountsTemTb or {}

    local l_tem = self:NewTemplate("CommonItemTipsDiscounts", { TemplateParent = oneItem.LuaUIGroup.transform })
    l_tem.localName = "Discounts" .. temName
    table.insert(oneItem.discountsTemTb, l_tem)
    return l_tem
end

--创建一个只显示文本的Templent
function CommonItemTipsCtrl:CreateSetInfoTemplent(oneItem, temName)
    if oneItem.setInfoTemplentTb == nil then
        oneItem.setInfoTemplentTb = {}
    end
    local l_setInfoTem = self:NewTemplate("CommonItemTipsSetInfoTemplent", { TemplateParent = oneItem.LuaUIGroup.transform })
    l_setInfoTem.localName = "SetInfo" .. temName
    table.insert(oneItem.setInfoTemplentTb, l_setInfoTem)
    return l_setInfoTem
end

--创建一个按钮的的Templent
function CommonItemTipsCtrl:CreateSetButtonTemplent(oneItem, temName)
    if oneItem.setButtonTemplentTb == nil then
        oneItem.setButtonTemplentTb = {}
    end

    --按钮组件唯一
    if #oneItem.setButtonTemplentTb > 0 then
        return oneItem.setButtonTemplentTb[1]
    end

    local l_setButtonTem = self:NewTemplate("CommonItemTipsButtonsTemplent", { TemplateParent = oneItem.LuaUIGroup.transform })
    l_setButtonTem.localName = "SetButton" .. temName
    table.insert(oneItem.setButtonTemplentTb, l_setButtonTem)
    return l_setButtonTem
end

--创建一个有各种Object显示的的Templent
function CommonItemTipsCtrl:CreateOthersTemplent(oneItem, temName)
    if oneItem.othersTemplentTb == nil then
        oneItem.othersTemplentTb = {}
    end

    local l_otherTem = self:NewTemplate("CommonItemTipsOtherTemplent", { TemplateParent = oneItem.LuaUIGroup.transform })
    l_otherTem.localName = "SetOthers" .. temName
    table.insert(oneItem.othersTemplentTb, l_otherTem)
    return l_otherTem
end

--创建一个有自己设置Num显示的的Templent
function CommonItemTipsCtrl:CreateSetNumPassiveTemplent(oneItem, temName)
    if oneItem.setNumPassiveTemplentTb == nil then
        oneItem.setNumPassiveTemplentTb = {}
    end

    local l_otherTem = self:NewTemplate("CommonItemTipsSetNumPassiveComponent", { TemplateParent = oneItem.LuaUIGroup.transform })
    l_otherTem.localName = "SetNumPassive" .. temName
    table.insert(oneItem.setNumPassiveTemplentTb, l_otherTem)
    return l_otherTem
end

function CommonItemTipsCtrl:CreatePaymentInstructionsTemplate(oneItem)
    local l_otherTem = self:NewTemplate("PaymentInstructionsTemplate",
            {
                TemplatePath = "UI/Prefabs/CommonItemTips/CommonItemTipsPaymentInstructions",
                TemplateParent = oneItem.LuaUIGroup.transform,
                LoadCallback = function()
                    -- 显示顺序竟然依赖加载顺序，这里加载好后再把位置调整到购买按钮前。囧
                    if #oneItem.setButtonTemplentTb > 0 then
                        oneItem.setButtonTemplentTb[1]:SetAsLastSibling()
                    end
                end
            }
    )
    return l_otherTem
end

function CommonItemTipsCtrl:GetTemplentByName(oneItem, targetName)
    if oneItem.setNumTemplentTb then
        for i = 1, #oneItem.setNumTemplentTb do
            if oneItem.setNumTemplentTb[i].localName == "SetNum" .. targetName then
                return oneItem.setNumTemplentTb[i]
            end
        end
    end
    if oneItem.discountsTemTb then
        for i = 1, #oneItem.discountsTemTb do
            if oneItem.discountsTemTb[i].localName == "Discounts" .. targetName then
                return oneItem.discountsTemTb[i]
            end
        end
    end
    if oneItem.setInfoTemplentTb then
        for i = 1, #oneItem.setInfoTemplentTb do
            if oneItem.setInfoTemplentTb[i].localName == "SetInfo" .. targetName then
                return oneItem.setInfoTemplentTb[i]
            end
        end
    end
    if oneItem.setButtonTemplentTb then
        for i = 1, #oneItem.setButtonTemplentTb do
            if oneItem.setButtonTemplentTb[i].localName == "SetButton" .. targetName then
                return oneItem.setButtonTemplentTb[i]
            end
        end
    end
    if oneItem.othersTemplentTb then
        for i = 1, #oneItem.othersTemplentTb do
            if oneItem.othersTemplentTb[i].localName == "SetOthers" .. targetName then
                return oneItem.othersTemplentTb[i]
            end
        end
    end
    if oneItem.setNumPassiveTemplentTb then
        for i = 1, #oneItem.setNumPassiveTemplentTb do
            if oneItem.setNumPassiveTemplentTb[i].localName == "SetNumPassive" .. targetName then
                return oneItem.setNumPassiveTemplentTb[i]
            end
        end
    end
end

--清楚Tips本地缓存的数据
function CommonItemTipsCtrl:ClearTipsData()
    for i = 1, #self.TipsInfo do
        if self.TipsInfo[i] then
            self.TipsInfo[i].data = {}
        end
    end
end

--回池重置的操作
function CommonItemTipsCtrl:UnloadAllUI()
    for i, v in ipairs(self.TipsInfo) do
        if v.ui then
            self:ClearCommonTemplent(self.TipsInfo[i].template)
            self.TipsInfo[i].template:ResetSetComponent()
            self:UninitTemplate(self.TipsInfo[i].template)
        end
    end
    self.TipsInfo = {}
end

function CommonItemTipsCtrl:ClearCommonTemplent(oneItem)

    if oneItem.setNumTemplentTb then
        for i = 1, #oneItem.setNumTemplentTb do
            if oneItem.setNumTemplentTb[i] then
                oneItem.setNumTemplentTb[i]:ResetSetComponent()
                self:UninitTemplate(oneItem.setNumTemplentTb[i])
                oneItem.setNumTemplentTb[i] = nil
            end
        end
        oneItem.setNumTemplentTb = nil
    end

    if oneItem.discountsTemTb then
        for i = 1, #oneItem.discountsTemTb do
            if oneItem.discountsTemTb[i] then
                oneItem.discountsTemTb[i]:ResetSetComponent()
                self:UninitTemplate(oneItem.discountsTemTb[i])
                oneItem.discountsTemTb[i] = nil
            end
        end
        oneItem.discountsTemTb = nil
    end

    if oneItem.setInfoTemplentTb then
        for i = 1, #oneItem.setInfoTemplentTb do
            if oneItem.setInfoTemplentTb[i] then
                oneItem.setInfoTemplentTb[i]:ResetSetComponent()
                self:UninitTemplate(oneItem.setInfoTemplentTb[i])
                oneItem.setInfoTemplentTb[i] = nil
            end
        end
        oneItem.setInfoTemplentTb = nil
    end

    if oneItem.setButtonTemplentTb then
        for i = 1, #oneItem.setButtonTemplentTb do
            if oneItem.setButtonTemplentTb[i] then
                oneItem.setButtonTemplentTb[i]:ResetSetComponent()
                self:UninitTemplate(oneItem.setButtonTemplentTb[i])
                oneItem.setButtonTemplentTb[i] = nil
            end
        end
        oneItem.setButtonTemplentTb = nil
    end

    if oneItem.othersTemplentTb then
        for i = 1, #oneItem.othersTemplentTb do
            if oneItem.othersTemplentTb[i] then
                oneItem.othersTemplentTb[i]:ResetSetComponent()
                self:UninitTemplate(oneItem.othersTemplentTb[i])
                oneItem.othersTemplentTb[i] = nil
            end
        end
        oneItem.othersTemplentTb = nil
    end

    if oneItem.setNumPassiveTemplentTb then
        for i = 1, #oneItem.setNumPassiveTemplentTb do
            if oneItem.setNumPassiveTemplentTb[i] then
                oneItem.setNumPassiveTemplentTb[i]:ResetSetComponent()
                self:UninitTemplate(oneItem.setNumPassiveTemplentTb[i])
                oneItem.setNumPassiveTemplentTb[i] = nil
            end
        end
        oneItem.setNumPassiveTemplentTb = nil
    end
end
---------------------------------------------------------------------------------------------------------------------

--显示购买价格
function CommonItemTipsCtrl:SetPurchasePrice(oneItem)
    if oneItem.data.baseData.IsAuction or oneItem.data.baseData.IsBusiness then
        if oneItem.data.equipStatus == Data.BagModel.WeaponStatus.TO_USE or
                oneItem.data.equipStatus == Data.BagModel.WeaponStatus.TO_MERCHANT then
            local setPurchaseTemplent = self:CreateSetInfoTemplent(oneItem, "SetPurchase")
            local color1 = Color.New(60 / 255, 60 / 255.0, 60 / 255)
            local color2 = Color.New(84 / 255, 145 / 255.0, 220 / 255)

            local l_coinData
            if oneItem.data.additionalData and oneItem.data.additionalData.recyleItem then
                local l_item = TableUtil.GetItemTable().GetRowByItemID(oneItem.data.additionalData.recyleItem)
                if l_item then
                    l_coinData = {}
                    l_coinData.ItemAtlas = l_item.ItemAtlas
                    l_coinData.ItemIcon = l_item.ItemIcon
                    l_coinData.ItemID = l_item.ItemID
                else
                    logError("找不到出售道具id:" .. tostring(oneItem.data.additionalData.recyleItem))
                    l_coinData = nil
                end
            else
                l_coinData = { ItemId = GameEnum.l_virProp.Coin102, ItemAtlas = "Icon_ItemConsumables01", ItemIcon = "UI_icon_item_huobi02.png" }
            end

            local l_priceLabel = ""
            if oneItem.data.baseData.IsAuction then
                l_priceLabel = Lang("AUCTION_PRICE_LABEL")
            end
            if oneItem.data.baseData.IsBusiness then
                l_priceLabel = Lang("BUY_IN_NUM")
            end
            setPurchaseTemplent:SetInfo(l_priceLabel, tostring(oneItem.data.baseData.Price), color1, color2, l_coinData)
        end
    end
end

---------------------------------------------------------------------------------------------------------------------

-----------------------------------红点判定--------------------------------------------------------------------------
--可否精炼
function CommonItemTipsCtrl:isCanRefine(oneItem)
    if oneItem.data.equipStatus ~= Data.BagModel.WeaponStatus.ON_BODY then
        return false
    end

    --不可精炼
    if not MgrMgr:GetMgr("RefineMgr").IsCanRefine(oneItem.data.equipTableData) then
        return false
    end

    ---@type ItemData
    local itemData = oneItem.data.baseData
    local currentRefineLevel = itemData.RefineLv
    local l_currentEquipRefineTableInfo = MgrMgr:GetMgr("RefineMgr").GetEquipRefineTable(oneItem.data.equipTableData.RefineBaseAttributes, currentRefineLevel)
    if l_currentEquipRefineTableInfo == nil then
        logGreen("装备配的可精炼，但是EquipRefineTable没有配相应的精炼数据，策划看一下配置是否有问题，装备id：" .. tostring(oneItem.data.equipTableData.EquipId))
        return false
    end

    local l_maxRefineLevel = MgrMgr:GetMgr("RefineMgr").GetRefineMaxLevel(oneItem.data.baseData)
    if currentRefineLevel >= l_maxRefineLevel then
        return false
    end

    local successRate = l_currentEquipRefineTableInfo.SuccessRate / 100
    if successRate < 100 then
        return false
    end

    local s = l_currentEquipRefineTableInfo.RefineConsume
    local l_refineConsume = Common.Functions.VectorSequenceToTable(s)
    for i = 1, #l_refineConsume do
        local l_id = l_refineConsume[i][1]
        local l_currentCount = Data.BagModel:GetCoinOrPropNumById(l_id)
        local l_requireCount = l_refineConsume[i][2]
        if l_currentCount < l_requireCount then
            return false
        end
    end

    return true
end

--红点判定 可否附魔
function CommonItemTipsCtrl:isCanEnchant(oneItem)
    if oneItem.data.equipStatus ~= Data.BagModel.WeaponStatus.ON_BODY then
        return false
    end

    ---@type ItemData
    local itemData = oneItem.data.baseData
    local l_thesaurusId = itemData.EquipConfig.EnchantingId
    if l_thesaurusId == 0 then
        return false
    end
    local l_currentEquipEnchantTableInfo = TableUtil.GetEquipEnchantConsumeTable().GetRowByEnchantId(l_thesaurusId)
    if l_currentEquipEnchantTableInfo == nil then
        return false
    end
    local l_consume = l_currentEquipEnchantTableInfo.EnchantConsume
    for i = 0, l_consume.Length - 1 do
        local l_currentCount = Data.BagModel:GetCoinOrPropNumById(l_consume[i][0])
        local l_requireCount = 0
        l_requireCount = l_consume[i][1]
        if l_currentCount < l_requireCount then
            return false
        end
    end

    return true
end

----------------------------------------------跑商的购买Tips-------------------------------------------------------
function CommonItemTipsCtrl:ShowMerchantTip(propInfo, status, additionalData)
    if additionalData == nil then
        return
    end

    local equipTableInfo = TableUtil.GetEquipTable().GetRowById(propInfo.TID, true)
    local itemTableInfo = TableUtil.GetItemTable().GetRowByItemID(propInfo.TID)

    self:ClearTipsData()
    self.TipsInfo[1].data = {
        baseData = propInfo,
        equipTableData = equipTableInfo,
        itemTableData = itemTableInfo,
        equipStatus = status,
        additionalData = additionalData,
    }

    if additionalData.count == nil then
        self.TipsInfo[1].data.currentCount = 1
    else
        self.TipsInfo[1].data.currentCount = additionalData.count
    end

    self:RefreshTipsUI()
    self:FillMerChantItem(self.TipsInfo[1], additionalData)
end

--商店处理
function CommonItemTipsCtrl:FillMerChantItem(oneItem, additionalData)
    local l_merchantMgr = MgrMgr:GetMgr("MerchantMgr")
    local l_data = DataMgr:GetData("MerchantData")
    local finNum = tostring(additionalData.price)

    local l_item = TableUtil.GetItemTable().GetRowByItemID(additionalData.recyleItem)
    local l_coinData = nil
    if l_item then
        l_coinData = {}
        l_coinData.ItemAtlas = l_item.ItemAtlas
        l_coinData.ItemIcon = l_item.ItemIcon
        l_coinData.ItemID = l_item.ItemID
    else
        logError("找不到出售道具id:" .. tostring(l_item))
        l_coinData = nil
    end

    local l_avgPrice = oneItem.data.baseData.Price or 0
    local l_buyPriceTemplent = self:CreateSetInfoTemplent(oneItem, "shopBuyPrice")
    l_buyPriceTemplent:SetInfo(Lang("BUY_IN_NUM"), tostring(l_avgPrice), nil, RoColor.GetFontColor(RoColorTag.Blue), l_coinData)

    -- 出售时，增加显示出售价格
    if oneItem.data.baseData.Price then
        local l_sellPriceTemplent = self:CreateSetInfoTemplent(oneItem, "shopSellPrice")
        local l_color = oneItem.data.baseData.Price >= additionalData.price and RoColor.GetFontColor(RoColorTag.Red) or RoColor.GetFontColor(RoColorTag.Green)
        l_sellPriceTemplent:SetInfo(Lang("SELL_PRICE"), tostring(additionalData.price), nil, l_color, l_coinData)
    end

    self:GetTemplentByName(oneItem, "buttonTem"):SetAsLastSibling()
    --@张博蓉的跑商需求 屏蔽掉下面两个组件
    if l_data.MerchantShopType == l_data.EMerchantShopType.Sell then
        return
    end
    -- 创建购买数量
    local l_setNumTemplent = self:CreateSetNumTemplent(oneItem, "shopSetNum")
    --以下设置购买数量相关
    local setNumTxt = (l_data.MerchantShopType == l_data.EMerchantShopType.Sell) and Common.Utils.Lang("Shop_SellCount") or Common.Utils.Lang("Shop_BuyCount")
    local initValue = 1
    local minValue = 1
    local maxValue = additionalData.maxValue or 1
    local changeInterval = 1

    local InputNumListener = function(value)
        local l_value = value * additionalData.price
        self:GetTemplentByName(oneItem, "shopSetInfo"):SetCountText(tostring(l_value))
        oneItem.data.currentCount = value
    end
    self:GetTemplentByName(oneItem, "shopSetNum"):SetInputNumListener(InputNumListener)

    l_setNumTemplent:SetInfo(setNumTxt, initValue, minValue, maxValue, changeInterval)
    l_setNumTemplent:SetMaxButtonDisplay(true)

    oneItem.ui.transform.anchoredPosition = Vector2.New(-174, -11)

    --设置出售价格相关
    local l_setInfoTemplent = self:CreateSetInfoTemplent(oneItem, "shopSetInfo")

    l_setInfoTemplent:SetInfo(Common.Utils.Lang("Shop_SellCoin"), finNum, nil, nil, l_coinData)

    self:GetTemplentByName(oneItem, "buttonTem"):SetAsLastSibling()
end

function CommonItemTipsCtrl:FillMerchantToSellTip(oneItem, additionalData)
    local l_item = TableUtil.GetItemTable().GetRowByItemID(additionalData.recyleItem)
    local l_coinData = nil
    if l_item then
        l_coinData = {}
        l_coinData.ItemAtlas = l_item.ItemAtlas
        l_coinData.ItemIcon = l_item.ItemIcon
        l_coinData.ItemID = l_item.ItemID
    else
        logError("找不到出售道具id:" .. tostring(l_item))
        l_coinData = nil
    end

    local l_avgPrice = oneItem.data.baseData.Price or 0
    local l_buyPriceTemplent = self:CreateSetInfoTemplent(oneItem, "shopBuyPrice")
    l_buyPriceTemplent:SetInfo(Lang("BUY_IN_NUM"), tostring(l_avgPrice), nil, RoColor.GetFontColor(RoColorTag.Blue), l_coinData)
    local l_sellPriceTemplent = self:CreateSetInfoTemplent(oneItem, "shopSellPrice")
    local l_color = l_avgPrice >= additionalData.price and RoColor.GetFontColor(RoColorTag.Red) or RoColor.GetFontColor(RoColorTag.Green)
    l_sellPriceTemplent:SetInfo(Lang("SELL_PRICE"), tostring(additionalData.price), nil, l_color, l_coinData)

    oneItem.ui.transform.anchoredPosition = Vector2.New(-174, -11)

    self:GetTemplentByName(oneItem, "buttonTem"):SetAsLastSibling()
end

function CommonItemTipsCtrl:ShowMerchantToSellTip(propInfo, status, additionalData)

    local equipTableInfo = TableUtil.GetEquipTable().GetRowById(propInfo.TID, true)
    local itemTableInfo = TableUtil.GetItemTable().GetRowByItemID(propInfo.TID)

    self:ClearTipsData()
    self.TipsInfo[1].data = {
        baseData = propInfo,
        equipTableData = equipTableInfo,
        itemTableData = itemTableInfo,
        equipStatus = status,
        additionalData = additionalData,
    }

    if additionalData.count == nil then
        self.TipsInfo[1].data.currentCount = 1
    else
        self.TipsInfo[1].data.currentCount = additionalData.count
    end

    self:RefreshTipsUI()

    self:FillMerchantToSellTip(self.TipsInfo[1], additionalData)
end

--设置到中心位置
function CommonItemTipsCtrl:SetPositionCenter()
    if self.TipsInfo[1].ui then
        self.TipsInfo[1].ui.transform.anchoredPosition = Vector3.New(0, 0, 0)
    end
end

--返回第一个Tips对象
function CommonItemTipsCtrl:GetFirstShowTips()
    if self.TipsInfo[1] then
        return self.TipsInfo[1]
    end
    return {}
end

return CommonItemTipsCtrl