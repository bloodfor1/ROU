require "UI/UIBaseHandler"

module("UI", package.seeall)

local super = UI.UIBaseHandler
BaseEquipEnchant = class("BaseEquipEnchant", super)

--lua functions
function BaseEquipEnchant:ctor(handlerName, count)
    super.ctor(self, handlerName, count)
end --func end
--next--
function BaseEquipEnchant:Init()
    super.Init(self)
    self.currentEquipEnchantTableInfo = nil
    self._isRequestEquipEnchant = false
    self._isRequestEquipReplaceEnchant = false

    --当前选择的装备
    self.currentEquipData = nil
    self.panel.NoSelectEquip.gameObject:SetActiveEx(false)
    self:OnCancelSelectEquip()

    --当前属性值
    self.CurrentAttrItemPool = self:NewTemplatePool({
        TemplateClassName = "EnchantPropertyTemplate",
        TemplateParent = self.panel.OriginalPropertyParent.transform,
        TemplatePath = "UI/Prefabs/EnchantPropertyPrefab"
    })

    --新属性值
    self.NewAttrItemPool = self:NewTemplatePool({
        TemplateClassName = "EnchantPropertyTemplate",
        TemplateParent = self.panel.NewPropertyParent.transform,
        TemplatePath = "UI/Prefabs/EnchantPropertyPrefab"
    })

    self.itemPool = self:NewTemplatePool({
        TemplateClassName = "ItemTemplate",
        TemplateParent = self.panel.ForgeMaterialParent.transform
    })

    --点击附魔
    self.panel.EnchantEquipButton:AddClick(function()
        self:_onEnchantEquipButton()
    end)

    self.panel.EnchantReplaceButton:AddClick(function()
        self:_onEnchantReplaceButton()
    end)

    --预览装备附魔属性
    self.panel.PreviewButton.Listener:SetActionClick(self._onTipsClick, self)
    self.panel.TipsButton.Listener:SetActionClick(self.PreviewEnChantInfo, self)
    self.equipItem = self:NewTemplate("ItemTemplate", { IsActive = false, TemplateParent = self.panel.CurrentEquipItemParent.transform })
end --func end
--next--
function BaseEquipEnchant:Uninit()
    self.MaterialPropInfoID = nil
    self.currentEquipEnchantTableInfo = nil
    self.CurrentAttrItemPool = nil
    self.NewAttrItemPool = nil
    self.equipItem = nil
    self.itemPool = nil
    self.currentEquipData = nil
    super.Uninit(self)
    self.panel = nil
end --func end

--next--
function BaseEquipEnchant:OnActive()
    self._isRequestEquipEnchant = false
    self._isRequestEquipReplaceEnchant = false
end --func end
--next--
function BaseEquipEnchant:OnDeActive()
end --func end
--next--
function BaseEquipEnchant:Update()
end --func end
--next--

--next--
function BaseEquipEnchant:OnLogout()
end --func end
--next--

--next--
function BaseEquipEnchant:BindEvents()
    --点击装备显示装备附魔信息
    self:BindEvent(MgrMgr:GetMgr("SelectEquipMgr").EventDispatcher, MgrMgr:GetMgr("SelectEquipMgr").SelectEquipCellEvent, function(self, item)
        self:OnEquipItemButton(item)
    end)

    self:BindEvent(MgrMgr:GetMgr("SelectEquipMgr").EventDispatcher, MgrMgr:GetMgr("SelectEquipMgr").SelectEquipShowEquipEvent, function(self, isShow)

    end)

    self:BindEvent(MgrMgr:GetMgr("EnchantMgr").EventDispatcher, MgrMgr:GetMgr("EnchantMgr").EquipEnchantSucceedEvent, function(self)
        self._isRequestEquipEnchant = false
        self:OnEquipItemButton(self.currentEquipData, true)
    end)

    self:BindEvent(MgrMgr:GetMgr("EnchantMgr").EventDispatcher, MgrMgr:GetMgr("EnchantMgr").EquipEnchantReplaceSucceedEvent, function(self)
        self._isRequestEquipReplaceEnchant = false
        self:OnEquipItemButton(self.currentEquipData)
    end)

    --当道具数据变化时更新需要材料信息
    local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
    self:BindEvent(gameEventMgr.l_eventDispatcher, gameEventMgr.OnBagUpdate, self._onItemUpdate)
end --func end
--next--
--lua functions end

--lua custom scripts

function BaseEquipEnchant:_onTipsClick(go, eventData)
    local l_infoText = Lang("EquipEnchant_TipsText")
    local pos = Vector2.New(eventData.position.x, eventData.position.y)
    eventData.position = pos
    local l_anchor = Vector2.New(0.5, 1)
    MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(l_infoText, eventData, l_anchor)
end

function BaseEquipEnchant:_onItemUpdate()
    --初始化消耗品
    if self.currentEquipData then
        self:UpdateConsume(self.currentEquipData)
    end
end

function BaseEquipEnchant:OnReconnected()
    super.OnReconnected(self)
    self._isRequestEquipEnchant = false
    self._isRequestEquipReplaceEnchant = false
    self:OnEquipItemButton(self.currentEquipData)
end

--第一次附魔要替换现有属性时，保存的key
local EquipEnchant_FirstEnchant = "EquipEnchant_FirstEnchant"

--当没选择装备时很多东西会隐藏
function BaseEquipEnchant:OnCancelSelectEquip()
    self.panel.NoEnchant.gameObject:SetActiveEx(false)
    self.panel.EquipShowPanel.gameObject:SetActiveEx(false)
    self.panel.NewAttributePanel.gameObject:SetActiveEx(false)
    if self.equipItem ~= nil then
        self.equipItem:SetGameObjectActive(false)
    end
end

--点击选择装备
---@param itemData ItemData
function BaseEquipEnchant:OnEquipItemButton(itemData, isEquipEnchantSucceed)
    if itemData == nil then
        self.panel.EquipShowPanel.gameObject:SetActiveEx(false)
        self.panel.NoEnchant.gameObject:SetActiveEx(false)
        return
    end

    self.currentEquipData = itemData
    self.panel.EquipShowPanel.gameObject:SetActiveEx(true)

    --设置装备图标
    self.equipItem:SetData({ PropInfo = self.currentEquipData, IsShowCount = false, IsShowTips = true })
    local l_itemTableInfo = TableUtil.GetItemTable().GetRowByItemID(self.currentEquipData.TID)
    self.panel.EquipName.LabText = l_itemTableInfo.ItemName
    self.panel.EquipName.transform.parent.gameObject:SetActiveEx(true)
    --初始化消耗品
    self:UpdateConsume(self.currentEquipData)
    --显示装备属性信息
    self:ShowEquipInfo(self.currentEquipData, isEquipEnchantSucceed)
end

--初始化消耗品
---@param equipData ItemData
function BaseEquipEnchant:UpdateConsume(equipData)
    self.panel.ZenyCoinText.LabText = tostring(MPlayerInfo.Coin101)
    local l_thesaurusId = equipData.EquipConfig.EnchantingId
    self.currentEquipEnchantTableInfo = TableUtil.GetEquipEnchantConsumeTable().GetRowByEnchantId(l_thesaurusId)
    if self.currentEquipEnchantTableInfo == nil then
        logError("此装备在EquipEnchantConsumeTable表中的附魔消耗数据没有取到，装备id：" .. tostring(equipData.TID) .. "附魔消耗表id：" .. tostring(l_thesaurusId))
        return
    end

    local l_s = self:_getEquipEnchantConsume(self.currentEquipEnchantTableInfo)
    local l_enchantConsume = Common.Functions.VectorSequenceToTable(l_s)
    local l_itemDatas = {}
    for i = 1, #l_enchantConsume do
        ---@type ItemTemplateParam
        local l_data = {
            ID = l_enchantConsume[i][1],
            IsShowCount = false,
            IsShowRequire = true,
            RequireCount = l_enchantConsume[i][2],
        }

        table.insert(l_itemDatas, l_data)
    end

    self.itemPool:ShowTemplates({ Datas = l_itemDatas })
end

--显示附魔属性
---@param equipData ItemData
function BaseEquipEnchant:ShowEquipInfo(equipData, isEquipEnchantSucceed)
    self.panel.NoEnchant.gameObject:SetActiveEx(false)
    self.panel.PropertyPanel.gameObject:SetActiveEx(false)
    self.panel.EnchantReplaceButton:SetActiveEx(false)
    local l_entrys = equipData.AttrSet[GameEnum.EItemAttrModuleType.Enchant][1]
    if #l_entrys == 0 then
        self.panel.NoEnchant.gameObject:SetActiveEx(true)
        return
    end

    self.panel.PropertyPanel.gameObject:SetActiveEx(true)
    local l_enchantTimes = equipData.EnchantTimesTotal
    local l_newAttr = self:_getCacheEntrys(self.currentEquipData)
    local l_isHaveNewAttr = self:_isHavePropertyData(l_newAttr)
    local l_oriAttrEffect = (not l_isHaveNewAttr) and isEquipEnchantSucceed
    self.CurrentAttrItemPool:ShowTemplates({ Datas = l_entrys, AdditionalData = { EquipData = equipData, IsShowQuality = false, IsShowEffect = l_oriAttrEffect } })
    if l_isHaveNewAttr then
        self.panel.EnchantReplaceButton:SetActiveEx(true)
        self.panel.NewPropertyParent:SetActiveEx(true)
        self.panel.NoNewEnchantProperty:SetActiveEx(false)
        self.NewAttrItemPool:ShowTemplates({ Datas = l_newAttr, AdditionalData = { EquipData = equipData, IsShowQuality = true, IsShowEffect = isEquipEnchantSucceed } })
    else
        self.panel.NewPropertyParent:SetActiveEx(false)
        self.panel.NoNewEnchantProperty:SetActiveEx(true)
    end

    if not l_isHaveNewAttr and l_enchantTimes == 1 then
        self.panel.NewProperty.gameObject:SetActiveEx(false)
        MLuaCommonHelper.SetLocalPos(self.panel.OriginalProperty.transform, Vector3.New(133, 70, 0))
    else
        self.panel.NewProperty.gameObject:SetActiveEx(true)
        MLuaCommonHelper.SetLocalPos(self.panel.OriginalProperty.transform, Vector3.New(2.5, 70, 0))
    end
end

--判断附魔材料够不够
function BaseEquipEnchant:IsMaterialsEnough()
    if self.currentEquipEnchantTableInfo == nil then
        return false
    end

    local l_consume = self:_getEquipEnchantConsume(self.currentEquipEnchantTableInfo)
    local l_enchantConsume = Common.Functions.VectorSequenceToTable(l_consume)
    local l_requireCount = 0

    for i = 1, #l_enchantConsume do
        local l_currentCount = Data.BagModel:GetCoinOrPropNumById(l_enchantConsume[i][1])
        l_requireCount = l_enchantConsume[i][2]
        --这里不判断铜币和银币的 走货币快捷获取
        if l_currentCount < l_requireCount and l_enchantConsume[i][1] ~= GameEnum.l_virProp.Coin101 then
            self.MaterialPropInfoID = l_enchantConsume[i][1]
            return false
        end
    end
    --返回铜币的消耗
    return true, l_requireCount
end

--预览附魔属性
function BaseEquipEnchant:PreviewEnChantInfo()
    if self.currentEquipData == nil then
        return
    end
    self:_showEnchantPreview(self.currentEquipData.TID)
end

function BaseEquipEnchant:_onEnchantEquipButton()
    local l_isMatEnough, l_totalCost = self:IsMaterialsEnough()
    if l_isMatEnough then

        if self.currentEquipData == nil then
            return
        end

        if self.currentEquipData.EnchantExtracted then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("Enchant_CantEnchantWithExtract"))
            return
        end

        local l_uid = self.currentEquipData.UID
        local l_newAttr = self:_getCacheEntrys(self.currentEquipData)
        if #l_newAttr == 0 then
            self:_startEquipEnchant(l_uid, l_totalCost)
        else
            if self:_isHaveGoodProperty(l_newAttr) then
                CommonUI.Dialog.ShowYesNoDlg(
                        true, nil,
                        Lang("EquipEnchant_HaveGoodPropertyText"),
                        function()
                            self:_startEquipEnchant(l_uid, l_totalCost)
                            UserDataManager.SetDataFromLua(EquipEnchant_FirstEnchant, MPlayerSetting.PLAYER_SETTING_GROUP, EquipEnchant_FirstEnchant)
                        end,
                        nil, nil, 2, "EquipEnchant_HaveGoodProperty"
                )
            else
                local l_dateStrSave = UserDataManager.GetStringDataOrDef(EquipEnchant_FirstEnchant, MPlayerSetting.PLAYER_SETTING_GROUP, "")
                if string.ro_isEmpty(tostring(l_dateStrSave)) then
                    CommonUI.Dialog.ShowYesNoDlg(
                            true, nil,
                            Lang("EquipEnchant_FirstEnchantText"),
                            function()
                                self:_startEquipEnchant(l_uid, l_totalCost)
                                UserDataManager.SetDataFromLua(EquipEnchant_FirstEnchant, MPlayerSetting.PLAYER_SETTING_GROUP, EquipEnchant_FirstEnchant)
                            end
                    )
                else
                    self:_startEquipEnchant(l_uid, l_totalCost)
                end
            end
        end
    else
        if self.MaterialPropInfoID ~= nil then
            local propInfo = Data.BagModel:CreateItemWithTid(self.MaterialPropInfoID)
            MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplay(propInfo, nil, nil, nil, true)
        end
    end
end

-- totalCost,isNotCheck用于货币快捷兑换 功能本身不需要管
function BaseEquipEnchant:_startEquipEnchant(uid, totalCost, isNotCheck)
    if self._isRequestEquipEnchant then
        return
    end

    if totalCost and totalCost > 0 then
        local _, l_needNum = Common.CommonUIFunc.ShowCoinStatusText(GameEnum.l_virProp.Coin101, totalCost)
        if l_needNum > 0 and not isNotCheck then
            MgrMgr:GetMgr("CurrencyMgr").ShowQuickExchangePanel(GameEnum.l_virProp.Coin101, l_needNum, function()
                self:_startEquipEnchant(uid, totalCost, true)
            end)
            return
        end
    end

    self._isRequestEquipEnchant = true
    self:_requestEquipEnchant(uid)
end

function BaseEquipEnchant:_onEnchantReplaceButton()
    if self.currentEquipData == nil then
        return
    end

    local l_entrys = self.currentEquipData.AttrSet[GameEnum.EItemAttrModuleType.Enchant][1]
    local l_uid = self.currentEquipData.UID
    if self:_isHaveGoodProperty(l_entrys) then
        CommonUI.Dialog.ShowYesNoDlg(
                true, nil,
                Lang("EquipEnchant_ReplaceText"),
                function()
                    self:_stratConfirmEquipEnchant(l_uid)
                end
        )
    else
        self:_stratConfirmEquipEnchant(l_uid)
    end
end

function BaseEquipEnchant:_stratConfirmEquipEnchant(uid)
    if self._isRequestEquipReplaceEnchant then
        return
    end

    self._isRequestEquipReplaceEnchant = true
    self:_requestConfirmEquipEnchant(uid)
end

---@param entrys ItemAttrData[]
function BaseEquipEnchant:_isHaveGoodProperty(entrys)
    if nil == entrys then
        return false
    end

    local attrMgr = MgrMgr:GetMgr("AttrUtilMgr")
    for i = 1, #entrys do
        local singleAttr = entrys[i]
        if attrMgr.EnchantAttrRare(singleAttr.TableID) then
            return true
        end
    end

    return false
end

function BaseEquipEnchant:_isHavePropertyData(enchantEntryBlocks)
    return #enchantEntryBlocks > 0
end

function BaseEquipEnchant:ShowSelectEquip()
    local l_equipBG = UIMgr:GetUI(UI.CtrlNames.EquipBG)
    if l_equipBG then
        local l_template = l_equipBG:GetSelectEquipTemplate()
        if l_template then
            l_template:AddLoadCallback(function(tmp)
                tmp:ShowSelectEquipWithData({
                    IsShowCurrentSelectData = true,
                    NoneEquipText = MgrMgr:GetMgr("EnchantMgr").GetNoneEquipText(),
                    NoneEquipTextPosition = self.panel.NoneEquipTextParent.transform.position
                })
            end)
        end
    end
end

--子类实现
function BaseEquipEnchant:_getCacheEntrys(itemData)
    return {}
end
function BaseEquipEnchant:_requestEquipEnchant(uid)
end
function BaseEquipEnchant:_requestConfirmEquipEnchant(uid)
end
function BaseEquipEnchant:_showEnchantPreview(propId)
end
function BaseEquipEnchant:_getEquipEnchantConsume(tableInfo)
end

return BaseEquipEnchant

--lua custom scripts end