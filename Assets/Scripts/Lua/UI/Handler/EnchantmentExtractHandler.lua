--this file is gen by script
--you can edit this file in custom part

--lua requires
require "UI/UIBaseHandler"
require "UI/Panel/EnchantmentExtractPanel"
require "UI/Template/EquipElevateEffectTemplate"
require "UI/Template/ItemTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseHandler
local l_enchantExtractMgr = MgrMgr:GetMgr("EnchantmentExtractMgr")
local l_selectEquipMgr = MgrMgr:GetMgr("SelectEquipMgr")
local l_itemTipMgr = MgrMgr:GetMgr("ItemTipsMgr")
local l_gameEventMgr = MgrProxy:GetGameEventMgr()
--next--
--lua fields end

--lua class define
EnchantmentExtractHandler = class("EnchantmentExtractHandler", super)
--lua class define end

--lua functions
function EnchantmentExtractHandler:ctor()
    super.ctor(self, HandlerNames.EnchantmentExtract, 0)
end --func end
--next--

function EnchantmentExtractHandler:Init()
    self.panel = UI.EnchantmentExtractPanel.Bind(self)
    super.Init(self)
    self:_initTemplateConfig()
    self.currentEquipData = nil
    self.panel.PreviewPanel.gameObject:SetActiveEx(false)
    self.equipItem = self:NewTemplate(self.equipTemplateConfig.name, self.equipTemplateConfig.config)
    self.targetItem = self:NewTemplate(self.targetTemplateConfig.name, self.targetTemplateConfig.config)
    self.matItemPool = self:NewTemplatePool(self.matTemplatePoolConfig)
    self.previewItemTemplatePool = self:NewTemplatePool(self.previewItemTemplatePoolConfig)

    self.panel.ShowPreviewButton:AddClickWithLuaSelf(self._onPreviewClick, self)
    self.panel.PreviewCloseBtn:AddClickWithLuaSelf(self._onPreviewCloseClick, self)
    self.panel.ExtractButton:AddClickWithLuaSelf(self._onExtractClick, self)

    self.panel.ShowDetailsButton.Listener.onDown = function()
        self:_showDetails()
    end
end --func end
--next--

function EnchantmentExtractHandler:Uninit()
    self.currentEquipData = nil
    self.equipItem = nil
    self.materialItem = nil
    self.previewItemTemplatePool = nil
    super.Uninit(self)
    self.panel = nil
end --func end
--next--

function EnchantmentExtractHandler:OnActive()
    -- do nothing
end --func end
--next--

function EnchantmentExtractHandler:OnShow()
    self.panel.PreviewPanel.gameObject:SetActiveEx(false)
    local config = { refresh = true, IsSelectSameEquip = false, IsDefaultNotSelectedEquip = true }
    self:_resetEquipItemList(config)
    self:_changePage()
    self:_refreshItemName()
end --func end
--next--

function EnchantmentExtractHandler:OnDeActive()
    self.currentEquipData = nil
end --func end
--next--

function EnchantmentExtractHandler:Update()
    -- do nothing
end --func end
--next--

function EnchantmentExtractHandler:OnLogout()
    -- do nothing
end --func end
--next--

function EnchantmentExtractHandler:OnHide()
    -- do nothing
end --func end
--next--

function EnchantmentExtractHandler:BindEvents()
    self:BindEvent(l_selectEquipMgr.EventDispatcher, l_selectEquipMgr.SelectEquipCellEvent, self._onSelectEquipCell)
    self:BindEvent(l_selectEquipMgr.EventDispatcher, l_selectEquipMgr.SelectEquipShowEquipEvent, self._onSelectEquipShow)
    self:BindEvent(l_enchantExtractMgr.EventDispatcher, l_enchantExtractMgr.OnReceiveExtractDataEvent, self._onRecvExtractPreviewData)
    self:BindEvent(l_enchantExtractMgr.EventDispatcher, l_enchantExtractMgr.ExtractSucceedEvent, self._onExtractDone)
    self:BindEvent(l_gameEventMgr.l_eventDispatcher, l_gameEventMgr.OnBagUpdate, self._onItemChange)
end --func end
--next--
--lua functions end

--lua custom scripts

-- 初始化模板配置
function EnchantmentExtractHandler:_initTemplateConfig()
    self.equipTemplateConfig = {
        name = "ItemTemplate",
        config = { TemplateParent = self.panel.EquipParent.Transform, IsActive = false }
    }
    self.targetTemplateConfig = {
        name = "ItemTemplate",
        config = { TemplateParent = self.panel.TargetParent.Transform, IsActive = false }
    }
    self.matTemplatePoolConfig = {
        UITemplateClass = UITemplate.ItemTemplate,
        TemplateParent = self.panel.MaterialParent.Transform,
    }
    self.previewItemTemplatePoolConfig = {
        UITemplateClass = UITemplate.ItemTemplate,
        TemplateParent = self.panel.PreviewItemParent.transform,
    }
end

--点击选择装备后的显示
function EnchantmentExtractHandler:_onEquipItemButton(data)
    -- 如果是已经有的数据，就直接返回
    if self.currentEquipData == data then
        return
    end

    -- 设置目标装备数据
    self.currentEquipData = data
    self:_setPageData()
    self:_refreshItemName()
end

-- 设置界面内容分为四个部分设置
function EnchantmentExtractHandler:_setPageData()
    self:_setEquipItemData()
    self:_setResultItemData()
    self:_setMatData()
end

function EnchantmentExtractHandler:_setEquipItemData()
    if nil == self.currentEquipData then
        self.equipItem:SetGameObjectActive(false)
        return
    end

    self.equipItem:SetData({ PropInfo = self.currentEquipData, IsShowCount = false })
    self.equipItem:SetGameObjectActive(true)
end

function EnchantmentExtractHandler:_setResultItemData()
    local l_resultProp = self:_createResultPropData()
    if nil == l_resultProp then
        return
        self.targetItem:SetGameObjectActive(false)
    end

    self.targetItem:SetData({ PropInfo = l_resultProp, IsShowCount = false })
    self.targetItem:SetGameObjectActive(true)
end

function EnchantmentExtractHandler:_setMatData()
    -- 设置材料数据
    local l_expend = l_enchantExtractMgr.GetExpends(self.currentEquipData)
    if l_expend then
        self.matItemPool:ShowTemplates({ Datas = l_expend })
    else
        logError("此装备的附魔提炼的材料没有取到，查看一下是否表有问题@周阳")
    end
end

-- 更新屏幕上的item名
function EnchantmentExtractHandler:_refreshItemName()
    if nil == self.currentEquipData then
        self.panel.ItemName.gameObject:SetActiveEx(false)
        return
    end

    self.panel.ItemName.gameObject:SetActiveEx(true)
    self.panel.ItemName.LabText = self.currentEquipData.ItemConfig.ItemName
end

function EnchantmentExtractHandler:_setHintLabelData(showBtn)
    self.panel.ShowPreviewButton.gameObject:SetActiveEx(showBtn)
    if not showBtn then
        return
    end
end

-- 获取结果装备，用于显示
function EnchantmentExtractHandler:_createResultPropData()
    if nil == self.currentEquipData then
        return
    end

    return l_enchantExtractMgr.CreateResultPropData()
end

function EnchantmentExtractHandler:_setSelectEquipData()
    local l_equipBG = UIMgr:GetUI(UI.CtrlNames.EquipAssistantBG)
    if l_equipBG then
        local l_template = l_equipBG:GetSelectEquipTemplate()
        if l_template then
            l_template:SetData({
                SelectEquipMgrName = "EnchantmentExtractMgr",
                IsDefaultNotSelectedEquip = true,
                NoneEquipTextPosition = self.panel.NoneEquipTextParent.transform.position
            })
        end
    end
end

function EnchantmentExtractHandler:_onCancelSelectEquip()
    self.currentEquipData = nil
    self:_setSelectEquipData()
    self.targetItem:SetGameObjectActive(false)
    self.equipItem:SetGameObjectActive(false)
    self.matItemPool:ShowTemplates({ Datas = {} })
    self:_refreshItemName()
end

-- 点击预览回调
function EnchantmentExtractHandler:_onPreviewClick()
    if nil == self.currentEquipData then
        local l_str = Lang("ENCHANT_EXTRACT_NEED_EQUIP")
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_str)
        return
    end

    l_enchantExtractMgr.RequestEquipEnchantRebornPreview(self.currentEquipData.UID)
end

-- 点击预览关闭回调
function EnchantmentExtractHandler:_onPreviewCloseClick()
    self.panel.PreviewPanel.gameObject:SetActiveEx(false)
end

-- 点击提炼回调
function EnchantmentExtractHandler:_onExtractClick()
    if self.currentEquipData == nil then
        local l_str = Lang("ENCHANT_EXTRACT_NEED_EQUIP")
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_str)
        return
    end

    if self.currentEquipData.EquipConfig == nil then
        return
    end

    local l_expend = l_enchantExtractMgr.GetExpends(self.currentEquipData)
    if nil == l_expend then
        logError("[EnchantExtract] expands got nil")
        return
    end

    if not self:_validateMatCount(l_expend) then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("ENCHANT_EXTRACT_ITEM_INSUFFICIENT"))
        return
    end

    local l_onConfirmCb = function()
        self:_onConfirmExtract()
    end

    CommonUI.Dialog.ShowYesNoDlg(
            true,
            nil,
            Lang("EnchantmentExtract_DetermineText"),
            l_onConfirmCb,
            nil,
            nil,
            0,
            "ENCHANTMENTEXTRACT_TODAY_NO_SHOW",
            nil,
            nil,
            nil,
            nil,
            nil,
            "YES")
end

-- 验证材料数量是否足够
function EnchantmentExtractHandler:_validateMatCount(expands)
    if nil == expands then
        logError("[EnchantExtract] expands got nil")
        return false
    end

    local l_isSufficient = true
    for i = 1, #expands do
        local l_expandsConfig = expands[i]
        local l_id = l_expandsConfig.ID
        local l_expandsCount = l_expandsConfig.RequireCount
        local l_currentCount = Data.BagModel:GetBagItemCountByTid(l_id)
        if l_currentCount < l_expandsCount then
            l_isSufficient = false
            local itemData = Data.BagModel:CreateItemWithTid(l_id)
            l_itemTipMgr.ShowTipsDisplay(itemData, nil, nil, nil, true)
        end
    end

    return l_isSufficient
end

function EnchantmentExtractHandler:_onConfirmExtract()
    if nil == self.currentEquipData then
        return
    end

    l_enchantExtractMgr.RequestEquipEnchantReborn(self.currentEquipData.UID)
end

function EnchantmentExtractHandler:_onRecvExtractPreviewData(datas)
    self.panel.PreviewPanel.gameObject:SetActiveEx(true)
    local itemDatas = {}
    for i = 1, #datas do
        ---@type ItemTemplateParam
        local data = {
            ID = datas[i].key,
            Count = datas[i].value,
            IsShowCount = true
        }
        table.insert(itemDatas, data)
    end

    self.previewItemTemplatePool:ShowTemplates({ Datas = itemDatas })
end

function EnchantmentExtractHandler:_onItemChange()
    if self.currentEquipData == nil then
        return
    end

    local l_expend = l_enchantExtractMgr.GetExpends(self.currentEquipData)
    if l_expend then
        self.matItemPool:ShowTemplates({ Datas = l_expend })
    end
end

function EnchantmentExtractHandler:_onExtractDone(data)
    self:_onCancelSelectEquip()
end

function EnchantmentExtractHandler:SetSelectEquipDataOnHandlerSwitch()
    local currentEquip = l_enchantExtractMgr.GetCacheData()
    if nil ~= currentEquip then
        self:_onSelectEquipCell(currentEquip)
        l_enchantExtractMgr.SetCacheData(nil)
        return
    end
end

function EnchantmentExtractHandler:_onSelectEquipShow(data)
    self.panel.Main.gameObject:SetActiveEx(data)
    self:_setHintLabelData(data)
end

function EnchantmentExtractHandler:_onSelectEquipCell(data)
    if self:IsShowing() then
        self:_onEquipItemButton(data)
    end
end

function EnchantmentExtractHandler:_changePage()
    -- 切换按钮状态
    self:_changePageBtnState()

    -- 创建新的目标，更新材料
    -- 新目标的item是可以点击并且弹出tips
    self:_setPageData()
end

-- 切换按钮状态
function EnchantmentExtractHandler:_changePageBtnState()
    if not self.panel then
        logError("[EnchantmentExtract] panel data is nil")
        return
    end

    self.panel.Btn_Group_Switch:SetActiveEx(false)
end

-- 刷新装备列表
-- 这个config有个结构 {refresh = false, IsSelectSameEquip = true, IsDefaultNotSelectedEquip == false}
function EnchantmentExtractHandler:_resetEquipItemList(config)
    if nil == self:_getEquipBgCtrl() then
        logError("[EnchantInherit] EquipBgCtrl is nil, plis check")
        return
    end

    local l_equipTemplate = self:_getEquipBgCtrl():GetSelectEquipTemplate()
    if nil == l_equipTemplate then
        logError("[EnchantInherit] EquipTemplate is nil, plis check")
        return
    end

    if nil == config then
        return
    end

    if not config.refresh then
        return
    end

    local l_equipTemplateConfig = {
        SelectEquipMgrName = "EnchantmentExtractMgr",
        IsSelectSameEquip = config.IsSelectSameEquip,
        IsDefaultNotSelectedEquip = config.IsDefaultNotSelectedEquip,
        NoneEquipTextPosition = self.panel.NoneEquipTextParent.transform.position
    }

    l_equipTemplate:SetData(l_equipTemplateConfig)
end

---@return EquipBgCtrl
function EnchantmentExtractHandler:_getEquipBgCtrl()
    if nil == self._equipBgCtrl then
        self._equipBgCtrl = UIMgr:GetUI(UI.CtrlNames.EquipAssistantBG)
    end

    return self._equipBgCtrl
end

function EnchantmentExtractHandler:_showDetails()
    MgrMgr:GetMgr("TipsMgr").ShowTipsInfo({
        content = Common.Utils.Lang("EnchantmentExtract_Details"),
        relativeTransform = self.panel.ShowDetailsButton.transform,
        relativeOffsetX = 0,
        relativeOffsetY = -320,
    })
end

--lua custom scripts end
return EnchantmentExtractHandler