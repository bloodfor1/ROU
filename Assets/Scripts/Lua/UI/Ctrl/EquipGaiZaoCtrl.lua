--this file is gen by script
--you can edit this file in custom part

--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/EquipGaiZaoPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
local equipReformMgr = MgrMgr:GetMgr("EquipReformMgr")
local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
--lua fields end

--lua class define
EquipGaiZaoCtrl = class("EquipGaiZaoCtrl", super)
--lua class define end

--lua functions
function EquipGaiZaoCtrl:ctor()
    super.ctor(self, CtrlNames.EquipGaiZao, UILayer.Function, nil, ActiveType.Exclusive)
end --func end
--next--
function EquipGaiZaoCtrl:Init()
    self.panel = UI.EquipGaiZaoPanel.Bind(self)
    super.Init(self)

    self:_initTemplateConfig()
    self:_initWidgets()
end --func end
--next--
function EquipGaiZaoCtrl:Uninit()
    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function EquipGaiZaoCtrl:OnActive()
    self:_refreshSelectEquipTemplate()
end --func end
--next--
function EquipGaiZaoCtrl:OnDeActive()
    -- do nothing
end --func end
--next--
function EquipGaiZaoCtrl:Update()
    -- do nothing
end --func end
--next--
function EquipGaiZaoCtrl:BindEvents()
    self:BindEvent(gameEventMgr.l_eventDispatcher, gameEventMgr.OnEquipReformComplete, self._refreshSelectEquipTemplate)
    self:BindEvent(gameEventMgr.l_eventDispatcher, gameEventMgr.OnBagUpdate, self._refreshSelectEquipTemplate)
end --func end
--next--
--lua functions end

--lua custom scripts
function EquipGaiZaoCtrl:_initTemplateConfig()
    self._selectedItemConfig = {
        name = "ItemTemplate",
        config = {
            TemplatePath = "UI/Prefabs/ItemPrefab",
            TemplateParent = self.panel.ItemTemplateDummy.Transform,
        },
    }

    self._selectEquipTemplateConfig = {
        name = "SelectEquipTemplate",
        config = {
            TemplatePath = "UI/Prefabs/SelectEquipPrefab",
            TemplateParent = self.panel.SelectEquipDummy.Transform,
        },
    }

    self._consumeItemPoolConfig = {
        TemplateClassName = "ItemTemplate",
        TemplatePath = "UI/Prefabs/ItemPrefab",
        TemplateParent = self.panel.Dummy_ItemConsume.Transform,
    }

    self._attrLabTemplatePoolConfig = {
        TemplateClassName = "AttrDescLab",
        TemplatePath = "UI/Prefabs/AttrDescLab",
        ScrollRect = self.panel.Loop_Attrs.LoopScroll,
    }
end

function EquipGaiZaoCtrl:_initWidgets()
    self._selectEquipTemplate = self:NewTemplate(self._selectEquipTemplateConfig.name, self._selectEquipTemplateConfig.config)
    ---@type ItemTemplate
    self._selectItemTemplate = self:NewTemplate(self._selectedItemConfig.name, self._selectedItemConfig.config)
    self._itemConsumePool = self:NewTemplatePool(self._consumeItemPoolConfig)
    self._attrPool = self:NewTemplatePool(self._attrLabTemplatePoolConfig)

    local onClose = function()
        self:_onClose()
    end

    local onShowMax = function()
        self:_showMaxAttr()
    end

    local onShowCompare = function()
        self:_showAttrCompare()
    end

    local onConfirm = function()
        self:_onConfirm()
    end

    local onConfirmConsole = function()
        local togType = GameEnum.EDialogToggleType.NoHintCurRole
        CommonUI.Dialog.ShowYesNoDlg(
                true,
                nil,
                Common.Utils.Lang("C_EQUIP_REFORM_TIPS"),
                onConfirm,
                nil,
                nil,
                togType,
                "EquipAssistant_DealWithTips")
    end

    self.panel.ButtonClose:AddClick(onClose)
    self.panel.Btn_GaiZao:AddClick(onConfirmConsole)
    self.panel.Bth_DuiBi:AddClick(onShowCompare)
    self.panel.Bth_JiPin:AddClick(onShowMax)
end

--- 打开页面的时候会调用，主要是为了刷新页面数据
function EquipGaiZaoCtrl:_refreshPanel()
    local currentItem = equipReformMgr.GetCurrentItemData()
    if nil == currentItem then
        logError("[EquipReformCtrl] current item got, refresh failed")
        return
    end

    self.panel.Text_EquipName.LabText = currentItem.ItemConfig.ItemName
    self.panel.Txt_Title.LabText = Common.Utils.Lang("C_EQUIP_REFORM_TITLE")

    ---@type ItemTemplateParam
    local itemTemplateParam = {
        PropInfo = currentItem,
        IsShowCount = false,
        IsShowTips = false,
    }

    self._selectItemTemplate:SetData(itemTemplateParam)
    local currentAttrList = equipReformMgr.GetItemDisplayAttrs(currentItem)
    local attrParamWrap = { Datas = currentAttrList }
    self._attrPool:ShowTemplates(attrParamWrap)
    local consumeItems = equipReformMgr.GetItemReformConsume(currentItem)

    ---@type ItemTemplateParam[]
    local params = {}
    for i = 1, #consumeItems do
        ---@type ItemTemplateParam
        local singleParam = {
            ID = consumeItems[i].TID,
            IsShowCount = false,
            IsShowRequire = true,
            RequireCount = consumeItems[i].ItemCount,
        }

        table.insert(params, singleParam)
    end

    local templateData = { Datas = params }
    self._itemConsumePool:ShowTemplates(templateData)
    local cacheItem = equipReformMgr.GetCacheItemData(currentItem)
    local showCompareBtn = nil ~= cacheItem
    self.panel.Bth_DuiBi.gameObject:SetActiveEx(showCompareBtn)
end

--- 设置左边选择装备的数据
function EquipGaiZaoCtrl:_refreshSelectEquipTemplate()
    local currentItem = equipReformMgr.GetCurrentItemData()
    local currentUID = nil
    if nil ~= currentItem then
        currentUID = currentItem.UID
    end

    ---@type SelectEquipTemplateParam
    local selectEquipTemplateParam = {
        SelectEquipMgrName = "EquipReformMgr",
        StartSelectItemUID = currentUID,
        OnItemSelected = self._onEquipSelected,
        OnItemSelectSelf = self,
        NoneEquipTextPosition = self.panel.EmptyWidget.transform.position,
    }

    self._selectEquipTemplate:SetData(selectEquipTemplateParam)
end

--- selectItemTemplate 选中之后触发的回调
---@param itemData ItemData
function EquipGaiZaoCtrl:_onEquipSelected(itemData)
    local hidePanel = nil == itemData
    self.panel.MiddlePanel.gameObject:SetActiveEx(not hidePanel)
    self.panel.RightPanel.gameObject:SetActiveEx(not hidePanel)
    self.panel.RightUpPanel.gameObject:SetActiveEx(not hidePanel)
    self.panel.Topicon.gameObject:SetActiveEx(not hidePanel)
    if hidePanel then
        return
    end

    equipReformMgr.SetCurrentItemData(itemData)
    self:_refreshPanel()
end

--- 如果显示了对比按钮，表示当前是存在数据的，否则不会显示这个按钮
function EquipGaiZaoCtrl:_showAttrCompare()
    local currentItem = equipReformMgr.GetCurrentItemData()
    if nil == currentItem then
        logError("[EquipReform] no current item")
        return
    end

    local cacheItem = equipReformMgr.GetCacheItemData(currentItem)
    if nil == cacheItem then
        logError("[EquipReform] no cache item")
        return
    end

    ---@type AttrCompareListParam
    local currentItemData = {
        attrs = equipReformMgr.GetItemDisplayAttrs(currentItem),
        showType = GameEnum.EAttrCompareType.ShowDouble,
        showName = Common.Utils.Lang("C_EQUIP_CURRENT_ATTR"),
        showStar = currentItem.ShowReformAttrStar,
    }

    ---@type AttrCompareListParam
    local cacheItemData = {
        attrs = equipReformMgr.GetItemDisplayAttrs(cacheItem),
        showType = GameEnum.EAttrCompareType.ShowDouble,
        showName = Common.Utils.Lang("C_EQUIP_OLD_ATTR"),
        showStar = cacheItem.ShowReformAttrStar,
    }

    ---@type AttrCompareListParam[]
    local uiParams = { cacheItemData, currentItemData }
    UIMgr:ActiveUI(UI.CtrlNames.EquipAttrPanelDummy, uiParams)
end

--- 显示极品属性
function EquipGaiZaoCtrl:_showMaxAttr()
    local currentItem = equipReformMgr.GetCurrentItemData()
    if nil == currentItem then
        return
    end

    ---@type AttrCompareListParam
    local singleParam = {
        attrs = equipReformMgr.GetItemMaxAttrDesc(currentItem),
        showType = GameEnum.EAttrCompareType.ShowSingle,
        showName = Common.Utils.Lang("C_EQUIP_MAX_ATTR"),
        showStar = currentItem.ShowReformAttrStar,
    }

    ---@type AttrCompareListParam[]
    local params = { singleParam }
    UIMgr:ActiveUI(UI.CtrlNames.EquipAttrPanelDummy, params)
end

function EquipGaiZaoCtrl:_onClose()
    UIMgr:DeActiveUI(UI.CtrlNames.EquipGaiZao)
end

function EquipGaiZaoCtrl:_onConfirm()
    local currentItem = equipReformMgr.GetCurrentItemData()
    local consumeItems = equipReformMgr.GetItemReformConsume(currentItem)
    for i = 1, #consumeItems do
        local itemData = consumeItems[i]
        local currentItemCount = Data.BagModel:GetCoinOrPropNumById(itemData.TID)
        if currentItemCount < itemData.ItemCount then
            MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplay(itemData, nil, nil, nil, true)
            return
        end
    end

    equipReformMgr.ReqEquipReform()
end

--lua custom scripts end
return EquipGaiZaoCtrl