--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/EquipCarryShopPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
---@class EquipCarryShopCtrl : UIBaseCtrl
EquipCarryShopCtrl = class("EquipCarryShopCtrl", super)
--lua class define end

--lua functions
function EquipCarryShopCtrl:ctor()
    super.ctor(self, CtrlNames.EquipCarryShop, UILayer.Function, nil, ActiveType.Exclusive)
end --func end
--next--
function EquipCarryShopCtrl:Init()
    self.panel = UI.EquipCarryShopPanel.Bind(self)
    super.Init(self)
    self._lvDropOptions = {}
    self._equipDropOptions = {
        Common.Utils.Lang("AllText"),
        Common.Utils.Lang("ILLUSTRATION_DROPDOWN_CARD_WUQI"),
        Common.Utils.Lang("ILLUSTRATION_DROPDOWN_CARD_FUSHOU"),
        Common.Utils.Lang("ILLUSTRATION_DROPDOWN_CARD_KUIJIA"),
        Common.Utils.Lang("ILLUSTRATION_DROPDOWN_CARD_PIFENG"),
        Common.Utils.Lang("ILLUSTRATION_DROPDOWN_CARD_XIEZI"),
        Common.Utils.Lang("ILLUSTRATION_DROPDOWN_CARD_SHIPIN"),
    }

    --- 这个需要标记一下，这个字段表示筛选类型对应的枚举，和上一个表是对应的
    self._equipTypeDropMap = {
        [0] = GameEnum.EEquipSlotType.None,
        [1] = GameEnum.EEquipSlotType.Weapon,
        [2] = GameEnum.EEquipSlotType.BackUpHand,
        [3] = GameEnum.EEquipSlotType.Armor,
        [4] = GameEnum.EEquipSlotType.Cape,
        [5] = GameEnum.EEquipSlotType.Boot,
        [6] = GameEnum.EEquipSlotType.Accessory,
    }

    self._targetData = nil
    self:_initConfig()
    local equipShardMgr = MgrMgr:GetMgr("EquipShardMgr")
    equipShardMgr.MgrObj:InitOnOpen()
    self:_initWidgets()
end --func end
--next--
function EquipCarryShopCtrl:Uninit()
    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function EquipCarryShopCtrl:OnActive()
    self:_refreshPage(nil, nil)
end --func end
--next--
function EquipCarryShopCtrl:OnDeActive()
    -- do nothing
end --func end
--next--
function EquipCarryShopCtrl:Update()
    -- do nothing
end --func end
--next--
function EquipCarryShopCtrl:BindEvents()
    local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
    self:BindEvent(gameEventMgr.l_eventDispatcher, gameEventMgr.OnShardMatCountUpdate, self._refreshSelectZone)
end --func end
--next--
--lua functions end

--lua custom scripts
function EquipCarryShopCtrl:_initConfig()
    self._selectedItemConfig = {
        name = "ItemTemplate",
        config = {
            TemplatePath = "UI/Prefabs/ItemPrefab",
            TemplateParent = self.panel.widget_item_dummy.transform,
        },
    }

    self._targetTemplatePoolConfig = {
        TemplateClassName = "ShardItemTemplate",
        TemplatePrefab = self.panel.ShardItemTemplate.gameObject,
        ScrollRect = self.panel.loopscroll_items.LoopScroll,
    }

    self._matTemplatePoolConfig = {
        TemplateClassName = "ItemTemplate",
        TemplatePath = "UI/Prefabs/ItemPrefab",
        TemplateParent = self.panel.widget_item_container.Transform,
    }
end

function EquipCarryShopCtrl:_initWidgets()
    self._selectItemTemplate = self:NewTemplate(self._selectedItemConfig.name, self._selectedItemConfig.config)
    self._targetTemplatePool = self:NewTemplatePool(self._targetTemplatePoolConfig)
    self._matTemplatePool = self:NewTemplatePool(self._matTemplatePoolConfig)
    self.panel.btn_confirm:AddClickWithLuaSelf(self._onConfirm, self)
    self.panel.btn_hint:AddClickWithLuaSelf(self._showHint, self)
    self.panel.btn_close:AddClickWithLuaSelf(self._onClose, self)
    local onLvChange = function(value)
        self:_onLvDropValueChange(value)
    end

    local onEquipTypeChange = function(value)
        self:_onEquipIDDropDownValueChange(value)
    end

    self.panel.dropdown_lv_root:SetActiveEx(true)
    self.panel.dropdown_type_root:SetActiveEx(true)
    self.panel.dropdown_type:SetActiveEx(true)
    self.panel.dropdown_lv:SetActiveEx(true)
    self:_initLvDropOptions()
    self.panel.dropdown_lv:SetDropdownOptions(self._lvDropOptions)
    local equipShardMgr = MgrMgr:GetMgr("EquipShardMgr")
    local currentLvID = equipShardMgr.MgrObj:GetCurrentRangeID()
    self.panel.dropdown_lv.DropDown.value = currentLvID - 1
    self.panel.dropdown_lv.DropDown.onValueChanged:AddListener(onLvChange)
    self.panel.dropdown_type:SetDropdownOptions(self._equipDropOptions)
    self.panel.dropdown_type.DropDown.value = 0
    self.panel.dropdown_type.DropDown.onValueChanged:AddListener(onEquipTypeChange)
end

function EquipCarryShopCtrl:_initLvDropOptions()
    local equipShardMgr = MgrMgr:GetMgr("EquipShardMgr")
    local lvRangeMap = equipShardMgr.MgrObj:GetRangeLvData()
    self._lvDropOptions = {}
    for i = 1, #lvRangeMap do
        local singleValue = lvRangeMap[i]
        local optionStr = Common.Utils.Lang("C_LV_RANGE", singleValue.LowLv, singleValue.HighLv)
        table.insert(self._lvDropOptions, optionStr)
    end
end

function EquipCarryShopCtrl:_onConfirm()
    local onConfirm = function()
        MgrMgr:GetMgr("EquipShardMgr").MgrObj:ReqExchange(self._targetData.ShopItemID)
    end

    for i = 1, #self._targetData.RequireItems do
        local singleItem = self._targetData.RequireItems[i]
        if singleItem.RequireCount > singleItem.CurrentCount then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("C_EQUIP_SHARD_EXCHANGE_INSUFFICIENT_MAT"))
            MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplay(singleItem.Item, nil, nil, nil, true)
            return
        end
    end

    local confirmStr = Common.Utils.Lang("C_EQUIP_SHARD_EXCHANGE_CONFIRM", self._targetData.MainData:GetName())
    CommonUI.Dialog.ShowYesNoDlg(true, nil, confirmStr, onConfirm, nil, nil, GameEnum.EDialogToggleType.NoHintToday, "")
end

function EquipCarryShopCtrl:_onClose()
    UIMgr:DeActiveUI(self.name)
end

function EquipCarryShopCtrl:_refreshPage(lvRangeID, equipType)
    local equipShardMgr = MgrMgr:GetMgr("EquipShardMgr")
    local currentLvID = lvRangeID
    if nil == lvRangeID then
        currentLvID = equipShardMgr.MgrObj:GetCurrentRangeID()
    end

    local currentEquipType = equipType
    if nil == equipType then
        currentEquipType = equipShardMgr.MgrObj:GetCurrentEquipType()
    end

    local targetList = equipShardMgr.MgrObj:GetPageData(currentLvID, currentEquipType)
    self.panel.widget_no_item:SetActiveEx(0 >= #targetList)
    local paramList = {}
    for i = 1, #targetList do
        local singleTarget = targetList[i]
        ---@type EquipShardDataWrap
        local templateParam = {}
        templateParam.EquipShardData = singleTarget
        templateParam.OnSelected = self._onSelected
        templateParam.OnSelectedSelf = self
        table.insert(paramList, templateParam)
    end

    self._targetTemplatePool:ShowTemplates({ Datas = paramList })
    if 0 >= #targetList then
        self.panel.widget_container:SetActiveEx(false)
        return
    end

    self.panel.widget_container:SetActiveEx(true)
    self:_onSelected(targetList[1], 1)
end

---@param data EquipShardDataPack
function EquipCarryShopCtrl:_onSelected(data, idx)
    if nil == data then
        logError("[EquipShardCtrl] invalid param")
        return
    end

    self._targetTemplatePool:SelectTemplate(idx)
    self._targetData = data
    self:_refreshSelectZone(data)
end

--- 这边如果没有参数则使用当前值作为参数，比如接收消息，这个时候就是使用的当前数据
---@param data EquipShardDataPack
function EquipCarryShopCtrl:_refreshSelectZone(data)
    if nil == data then
        data = self._targetData
    end

    if nil == data then
        return
    end

    ---@type ItemTemplateParam
    local singleParam = {}
    singleParam.PropInfo = data.MainData
    singleParam.IsShowCount = false
    self._selectItemTemplate:SetData(singleParam)
    self.panel.txt_item_name.LabText = data.MainData:GetName()
    local lvStr = tostring(data.MainData:GetEquipTableLv())
    if MPlayerInfo.Lv < data.MainData:GetEquipTableLv() then
        lvStr = GetColorText(lvStr, RoColor.Tag.Red)
    end

    self.panel.txt_item_lv.LabText = Common.Utils.Lang("C_USE_LV", lvStr)
    self.panel.txt_item_desc.LabText = data.MainData.ItemConfig.ItemDescription
    local paramList = {}
    for i = 1, #data.RequireItems do
        local singleItem = data.RequireItems[i]
        ---@type ItemTemplateParam
        local singleParam = {}
        singleParam.PropInfo = singleItem.Item
        singleParam.IsShowRequire = true
        singleParam.Count = singleItem.CurrentCount
        singleParam.IsShowCount = false
        singleParam.RequireCount = singleItem.RequireCount
        table.insert(paramList, singleParam)
    end

    self._matTemplatePool:ShowTemplates({ Datas = paramList })
    self.panel.btn_confirm:SetActiveEx(true)
    self.panel.txt_insuffcient_mat:SetActiveEx(false)
end

function EquipCarryShopCtrl:_onLvDropValueChange(value)
    self:_refreshPage(value + 1, nil)
end

function EquipCarryShopCtrl:_onEquipIDDropDownValueChange(value)
    local equipType = self._equipTypeDropMap[value]
    if nil == equipType then
        logError("[EquipShardCtrl] invalid dropdown value: " .. tostring(value))
        return
    end

    self:_refreshPage(nil, equipType)
end

function EquipCarryShopCtrl:_showHint()
    local l_content = Common.Utils.Lang("C_EQUIP_SHARD_TIPS")
    MgrMgr:GetMgr("TipsMgr").ShowExplainPanelTips({
        content = l_content,
        alignment = UnityEngine.TextAnchor.MiddleCenter,
        pos = {
            x = 425,
            y = 370,
        },
        width = 400,
    })
end

--lua custom scripts end
return EquipCarryShopCtrl