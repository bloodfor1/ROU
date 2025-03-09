--this file is gen by script
--you can edit this file in custom part

--lua requires
require "UI/UIBaseHandler"
require "UI/Panel/EnchantInheritPanel"
require "UI/Template/EquipElevateEffectTemplate"
require "UI/Template/ItemTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseHandler
local l_enchantInheritMgr = MgrMgr:GetMgr("EnchantInheritMgr")
local l_gameEventMgr = MgrProxy:GetGameEventMgr()
--next--
--lua fields end

--lua class define
EnchantInheritHandler = class("EnchantInheritHandler", super)
--lua class define end

--lua functions
function EnchantInheritHandler:ctor()
    super.ctor(self, HandlerNames.EnchantInherit, 0)
    ---@type EquipBgCtrl
    self._equipBgCtrl = nil
end --func end

---@return EquipBgCtrl
function EnchantInheritHandler:_getEquipBgCtrl()
    if nil == self._equipBgCtrl then
        self._equipBgCtrl = UIMgr:GetUI(UI.CtrlNames.EquipAssistantBG)
    end

    return self._equipBgCtrl
end

--next--
function EnchantInheritHandler:Init()
    self.panel = UI.EnchantInheritPanel.Bind(self)
    super.Init(self)

    self:_initData()
    self:_initWidgets()
end --func end
--next--
function EnchantInheritHandler:Uninit()
    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function EnchantInheritHandler:OnActive()
    -- do nothing
end --func end
--next--
function EnchantInheritHandler:OnDeActive()
    l_enchantInheritMgr.SetNewEquip(nil)
    l_enchantInheritMgr.SetOldEquip(nil)
end --func end
--next--
function EnchantInheritHandler:Update()
    -- do nothing
end --func end

function EnchantInheritHandler:OnShow()
    UIMgr:DeActiveUI(UI.CtrlNames.ExplainPanelTips)
    local config = { refresh = true, IsSelectSameEquip = false, IsDefaultNotSelectedEquip = true }
    self:_refreshPage(config)
end

function EnchantInheritHandler:OnHide()
    -- do nothing
end

--next--
function EnchantInheritHandler:BindEvents()
    self:BindEvent(l_gameEventMgr.l_eventDispatcher, l_gameEventMgr.OnBagUpdate, self._refreshMat)
    self:BindEvent(l_gameEventMgr.l_eventDispatcher, l_gameEventMgr.OnEnchantInheritConfirmed, self._onInheritConfirmed)
    self:BindEvent(l_gameEventMgr.l_eventDispatcher, l_gameEventMgr.OnEquipCellSelected, self._onEquipSelected)

    local l_selectEquipMgr = MgrMgr:GetMgr("SelectEquipMgr")
    self:BindEvent(l_selectEquipMgr.EventDispatcher, l_selectEquipMgr.SelectEquipShowEquipEvent, self._onSelectEquipShow)
end --func end

--lua functions end

--lua custom scripts

-- 初始化数据
function EnchantInheritHandler:_initData()
    self.equipUID = nil
    self.stoneUID = nil
    self.equipTemplateConfig = {
        name = "ItemTemplate",
        config = { TemplateParent = self.panel.LeftEquipItemParent.Transform, IsActive = false }
    }
    self.stoneTemplateConfig = {
        name = "ItemTemplate",
        config = { TemplateParent = self.panel.RightEquipItemParent.Transform, IsActive = false }
    }
    self.matTemplatePoolConfig = {
        TemplateClassName = "ItemTemplate",
        TemplateParent = self.panel.RefineTransferItemParent.Transform,
    }
    self.attrTemplatePoolConfig = {
        TemplateClassName = "EnchantPropertyTemplate",
        TemplateParent = self.panel.EnchantParent.transform,
        TemplatePath = "UI/Prefabs/EnchantPropertyPrefab"
    }
end

-- 初始化控件
function EnchantInheritHandler:_initWidgets()
    self.panel.LeftRemoveEquipButton:AddClickWithLuaSelf(self._onRemoveEquipClick, self)
    self.panel.IconButtonLeft:AddClickWithLuaSelf(self._onAddEquipClick, self)
    self.panel.RightRemoveEquipButton:AddClickWithLuaSelf(self._onRemoveStoneClick, self)
    self.panel.IconButtonRight:AddClickWithLuaSelf(self._onAddStoneClick, self)
    self.panel.Button_Confirm:AddClickWithLuaSelf(self._onConfirmClick, self)
    self.panel.NoEnchantTag:AddClickWithLuaSelf(self._onHintClick, self)

    self.templateEquip = self:NewTemplate(self.equipTemplateConfig.name, self.equipTemplateConfig.config)
    self.templateStone = self:NewTemplate(self.stoneTemplateConfig.name, self.stoneTemplateConfig.config)
    self._attrItemPool = self:NewTemplatePool(self.attrTemplatePoolConfig)
    self.matItemPool = self:NewTemplatePool(self.matTemplatePoolConfig)

    self.panel.LeftRemoveEquipButton.gameObject:SetActiveEx(false)
    self.panel.RightRemoveEquipButton.gameObject:SetActiveEx(false)
end

function EnchantInheritHandler:_onAddEquipClick()
    local l_str = Lang("ENCHANT_INHERIT_NEED_STONE")
    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_str)
end

-- 点击移除旧装备
function EnchantInheritHandler:_onRemoveEquipClick()
    l_enchantInheritMgr.SetOldEquip(nil)
    self.templateEquip:SetGameObjectActive(false)
    self.panel.LeftRemoveEquipButton.gameObject:SetActiveEx(false)
    local config = { refresh = true, IsSelectSameEquip = false, IsDefaultNotSelectedEquip = true }
    self:_refreshPage(config)
end

-- 点击添加封魔石
function EnchantInheritHandler:_onAddStoneClick()
    local oldEquip = l_enchantInheritMgr.GetOldEquip()
    if nil == oldEquip then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("C_PLIS_SELECT_OLD_EQUIP"))
        return
    end

    self:_showStonePanel()
end

-- 点击移除新装备
function EnchantInheritHandler:_onRemoveStoneClick()
    self.templateStone:SetGameObjectActive(false)
    self.panel.RightRemoveEquipButton.gameObject:SetActiveEx(false)
    l_enchantInheritMgr.SetNewEquip(nil)
    local config = { refresh = true, IsSelectSameEquip = false, IsDefaultNotSelectedEquip = true }
    self:_refreshPage(config)
end

-- 切页的时候设置数据，上层的调用的接口
function EnchantInheritHandler:SetSelectEquipDataOnHandlerSwitch()
    local oldEquip = l_enchantInheritMgr.GetOldEquip()
    local newEquip = l_enchantInheritMgr.GetNewEquip()
    if nil ~= oldEquip and nil ~= newEquip then
        self:_onStoneSelected(newEquip)
        self:_onEquipSelected(oldEquip)
        return
    end

    -- 这个函数当中会刷新页面
    self:_onRemoveStoneClick()
    self:_onRemoveEquipClick()
end

-- 装备被放置
---@param data ItemData
function EnchantInheritHandler:_onEquipSelected(data)
    local l_showEquipIcon = nil ~= data
    self.templateEquip:SetGameObjectActive(l_showEquipIcon)
    self.panel.LeftRemoveEquipButton.gameObject:SetActiveEx(l_showEquipIcon)
    if l_showEquipIcon then
        local l_itemTplConfig = {
            PropInfo = data,
            IsShowCount = false
        }

        l_enchantInheritMgr.SetOldEquip(data)
        self.templateEquip:SetData(l_itemTplConfig)
    else
        l_enchantInheritMgr.SetOldEquip(nil)
    end

    local config = { refresh = false, IsSelectSameEquip = false, IsDefaultNotSelectedEquip = true }
    self:_refreshPage(config)
end

function EnchantInheritHandler:_setEquipNames()
    local oldEquip = l_enchantInheritMgr.GetOldEquip()
    local newEquip = l_enchantInheritMgr.GetNewEquip()
    if nil == oldEquip then
        self.panel.TextLeftEquipName.LabText = ""
    else
        self.panel.TextLeftEquipName.LabText = oldEquip:GetName()
    end

    if nil == newEquip then
        self.panel.TextRightEquipName.LabText = ""
    else
        self.panel.TextRightEquipName.LabText = newEquip:GetName()
    end

    self.panel.TextLeftHint:SetActiveEx(nil == oldEquip and nil == newEquip)
    self.panel.TextRightHint:SetActiveEx(nil ~= oldEquip and nil == newEquip)
end

-- 有封魔石被选中
function EnchantInheritHandler:_onStoneSelected(data)
    if nil == data then
        return
    end

    self.templateStone:SetGameObjectActive(true)
    local l_itemTplConfig = {
        PropInfo = data,
        IsShowCount = false
    }
    self.templateStone:SetData(l_itemTplConfig)
    self.panel.RightRemoveEquipButton.gameObject:SetActiveEx(true)
    l_enchantInheritMgr.SetNewEquip(data)

    local config = { refresh = true, IsSelectSameEquip = true, IsDefaultNotSelectedEquip = true }
    self:_refreshPage(config)
end

-- 点击问号获取提示
function EnchantInheritHandler:_onHintClick()
    local l_text = l_enchantInheritMgr.GetHintTableText()
    MgrMgr:GetMgr("TipsMgr").ShowExplainPanelTips({
        content = l_text,
        alignment = UnityEngine.TextAnchor.UpperLeft,
        pivot = Vector2.New(0.7, 1),
        anchoreMin = Vector2.New(0.5, 0.5),
        anchoreMax = Vector2.New(0.5, 0.5),
        downwardAdapt = true,
        overideSort = UI.UILayerSort.Tips + 1,
        relativeLeftPos = {
            canOffset = false,
            screenPos = MUIManager.UICamera:WorldToScreenPoint(self.panel.NoEnchantTag.Transform.position)
        },
        width = 400,
    })
end

-- 收到了服务器确定的回报消息
function EnchantInheritHandler:_onInheritConfirmed()
    self:_showInheritDoneTip()
    self:_resetPageOnSvrMsg()
end

-- 这个节点示例数据还没有被清空，所以能取到，用来提示，提示后会清空
function EnchantInheritHandler:_showInheritDoneTip()
    local l_str = Lang("ENCHANT_INHERIT_DONE")
    ---@type ItemData
    local l_itemInstance = l_enchantInheritMgr.GetNewEquip()
    if nil == l_itemInstance then
        logError("[EnchantInherit] no new data")
        return
    end

    local l_weaponName = l_itemInstance:GetName()
    local oldWeapon = l_enchantInheritMgr.GetOldEquip()
    if nil == oldWeapon then
        logError("[EnchantInherit] no old data")
        return
    end

    local oldWeaponName = oldWeapon:GetName()
    local l_text = StringEx.Format(l_str, l_weaponName, oldWeaponName)
    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_text)
end

function EnchantInheritHandler:_resetPageOnSvrMsg()
    l_enchantInheritMgr.SetOldEquip(nil)
    self.templateEquip:SetGameObjectActive(false)
    self.panel.LeftRemoveEquipButton.gameObject:SetActiveEx(false)
    l_enchantInheritMgr.SetNewEquip(nil)
    self.templateStone:SetGameObjectActive(false)
    self.panel.RightRemoveEquipButton.gameObject:SetActiveEx(false)
    local config = { refresh = true, IsSelectSameEquip = false, IsDefaultNotSelectedEquip = true }
    self:_refreshPage(config)
end

-- 点击继承按钮出现的回调
function EnchantInheritHandler:_onConfirmClick()
    local l_mats, l_showMats = l_enchantInheritMgr.GetMat()
    for i = 1, #l_mats do
        local itemData = Data.BagApi:CreateLocalItemData(l_mats[i].ID)
        itemData.ItemCount = l_mats[i].RequireCount
        local currentItemCount = 0
        if itemData:IsVirtualItem() then
            currentItemCount = MgrMgr:GetMgr("ItemContainerMgr").GetItemCountByContAndID(GameEnum.EBagContainerType.VirtualItem, itemData.TID)
        else
            currentItemCount = MgrMgr:GetMgr("ItemContainerMgr").GetItemCountByContAndID(GameEnum.EBagContainerType.Bag, itemData.TID)
        end

        if currentItemCount < itemData.ItemCount then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("C_INSUFFICIENT_ENCHANT_INHERIT_MAT"))
            MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplay(itemData, nil, nil, nil, true)
            return
        end
    end

    l_enchantInheritMgr.ReqInherit()
end

-- 弹出选择封魂石界面
-- 如果没有封魔石，就直接弹出提示，不弹出界面
function EnchantInheritHandler:_showStonePanel()
    local l_stoneData = l_enchantInheritMgr.GetNewEquipTable()
    if 0 == #l_stoneData then
        local l_str = Lang("ENCHANT_INHERIT_NO_STONE")
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_str)
        return
    end

    ---@type EnchantInheritNewEquipPanelData
    local panelData = {
        ItemList = l_stoneData,
        OnCloseSelf = self,
        OnClose = self._onStoneSelected,
    }

    UIMgr:ActiveUI(CtrlNames.ItemAchieve, panelData)
end

function EnchantInheritHandler:_refreshPage(config)
    self:_ctrlAttrPanel()
    self:_refreshHint()
    self:_refreshMat()
    self:_resetEquipItemList(config)
    self:_setEquipNames()
end

function EnchantInheritHandler:_refreshHint()
    self.panel.NoEnchantTag.gameObject:SetActiveEx(true)
    self.panel.NoEnchant.gameObject:SetActiveEx(false)
end

function EnchantInheritHandler:_refreshMat()
    local l_mats, l_showMats = l_enchantInheritMgr.GetMat()
    self.panel.RefineTransferItemParent.gameObject:SetActiveEx(l_showMats)
    self.panel.Container_Mat.gameObject:SetActiveEx(l_showMats)
    local l_param = { Datas = l_mats }
    self.matItemPool:ShowTemplates(l_param)
end

-- 刷新装备列表
-- 这个config有个结构 {refresh = false, IsSelectSameEquip = true, IsDefaultNotSelectedEquip == false}
function EnchantInheritHandler:_resetEquipItemList(config)
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
        SelectEquipMgrName = "EnchantInheritMgr",
        IsSelectSameEquip = config.IsSelectSameEquip,
        IsDefaultNotSelectedEquip = config.IsDefaultNotSelectedEquip,
        NoneEquipTextPosition = self.panel.Dummy_NoEquip.transform.position,
    }

    l_equipTemplate:SetData(l_equipTemplateConfig)
end

-- 控制属性数据的显示
function EnchantInheritHandler:_ctrlAttrPanel()
    local l_isAttrNeed = l_enchantInheritMgr.IsAttrNeeded()
    self.panel.Text_Enchant_Inherit.gameObject:SetActiveEx(l_isAttrNeed)
    self.panel.EnchantParent.gameObject:SetActiveEx(l_isAttrNeed)
    if not l_isAttrNeed then
        return
    end

    local l_stoneEntries = l_enchantInheritMgr.GetOldEquipAttrs()
    if nil == l_stoneEntries then
        return
    end

    local l_param = {
        Datas = l_stoneEntries,
        AdditionalData = { IsShowEffect = true }
    }

    self._attrItemPool:ShowTemplates(l_param)
end

function EnchantInheritHandler:_onSelectEquipShow(show)
    self.panel.TransferPanel:SetActiveEx(show)
    if not show then
        self.panel.Text_Enchant_Inherit:SetActiveEx(false)
    end
end

--lua custom scripts end
return EnchantInheritHandler