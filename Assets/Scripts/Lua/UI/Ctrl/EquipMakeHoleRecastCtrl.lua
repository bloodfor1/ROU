--this file is gen by script
--you can edit this file in custom part

--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/EquipMakeHoleRecastPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
EquipMakeHoleRecastCtrl = class("EquipMakeHoleRecastCtrl", super)

local EquipMakeHoleRecast_FirstMakeHoleRecast = "EquipMakeHoleRecast_FirstMakeHoleRecast"
--lua class define end

--lua functions
function EquipMakeHoleRecastCtrl:ctor()
    super.ctor(self, CtrlNames.EquipMakeHoleRecast, UILayer.Function, nil, ActiveType.Standalone)
    self.InsertPanelName = UI.CtrlNames.EquipBG
    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor = BlockColor.Dark
end --func end

--next--
function EquipMakeHoleRecastCtrl:Init()
    self.panel = UI.EquipMakeHoleRecastPanel.Bind(self)
    super.Init(self)
    self._isRequestRecast = false
    self._isRequestReplace = false
    self._currentEquipData = nil
    self._currentMaterials = nil
    self._currentHoleIndex = 0
    self.panel.PropertyPreviewPanel:SetActiveEx(false)
    self.panel.MakeHolePropertyPreviewPrefab.gameObject:SetActiveEx(false)
    self.panel.EquipMakeHoleRecastPrefab.gameObject:SetActiveEx(false)

    --原属性
    self._recastTemplate1 = self:NewTemplate("EquipMakeHoleRecastTemplate", {
        TemplatePrefab = self.panel.EquipMakeHoleRecastPrefab.gameObject,
        TemplateParent = self.panel.RecastPropertyParent1.transform
    })
    --新属性
    self._recastTemplate2 = self:NewTemplate("EquipMakeHoleRecastTemplate", {
        TemplatePrefab = self.panel.EquipMakeHoleRecastPrefab.gameObject,
        TemplateParent = self.panel.RecastPropertyParent2.transform
    })
    --原属性下面的
    self._recastTemplate3 = self:NewTemplate("EquipMakeHoleRecastTemplate", {
        TemplatePrefab = self.panel.EquipMakeHoleRecastPrefab.gameObject,
        TemplateParent = self.panel.RecastPropertyParent3.transform
    })

    self._propertyPreviewTemplatePool = self:NewTemplatePool(
            {
                TemplateClassName = "MakeHolePropertyPreviewTemplate",
                TemplatePrefab = self.panel.MakeHolePropertyPreviewPrefab.gameObject,
                TemplateParent = self.panel.PropertyPreviewParent.Transform,
            })

    self.panel.RecastButton:AddClick(function()
        self:_onRecastButton()
    end)
    self.panel.ReplaceButton:AddClick(function()
        self:_onReplaceButton()
    end)

    self.panel.CloseButton:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.EquipMakeHoleRecast)
    end)

    self.panel.PropertyPreviewButton:AddClick(function()
        if self._currentEquipData == nil then
            return
        end

        local l_equipTable = TableUtil.GetEquipTable().GetRowById(self._currentEquipData.TID)
        local l_holeTableInfo = TableUtil.GetEquipHoleTable().GetTable()
        local l_propertyPreviewDatas = {}
        for i = 1, #l_holeTableInfo do
            if l_holeTableInfo[i].ThesaurusId == l_equipTable.HoleId then
                table.insert(l_propertyPreviewDatas, l_holeTableInfo[i])
            end
        end

        table.sort(l_propertyPreviewDatas, function(a, b)
            return a.Quality > b.Quality
        end)

        self.panel.PropertyPreviewPanel:SetActiveEx(true)
        self._propertyPreviewTemplatePool:ShowTemplates({
            Datas = l_propertyPreviewDatas,
        })
    end)

    self.panel.ClosePropertyPreviewPanelButton:AddClick(function()
        self.panel.PropertyPreviewPanel:SetActiveEx(false)
    end)

end --func end
--next--
function EquipMakeHoleRecastCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil

    self._propertyPreviewTemplatePool = nil
    self._recastTemplate1 = nil
    self._recastTemplate2 = nil
    self._recastTemplate3 = nil

end --func end
--next--
function EquipMakeHoleRecastCtrl:OnActive()
    self._isRequestRecast = false
    self._isRequestReplace = false

end --func end
--next--
function EquipMakeHoleRecastCtrl:OnDeActive()
    self._currentEquipData = nil
    self._currentMaterials = nil

end --func end
--next--
function EquipMakeHoleRecastCtrl:Update()
    -- do nothing
end --func end

--next--
function EquipMakeHoleRecastCtrl:OnReconnected()
    super.OnReconnected(self)
    self._isRequestRecast = false
    self._isRequestReplace = false
    if self._currentEquipData ~= nil then
        local l_uid = self._currentEquipData.UID
        local l_target = _getItemByUid(l_uid)
        self._currentEquipData = l_target
    end
end --func end

---@return ItemData
function _getItemByUid(uid)
    local types = {
        GameEnum.EBagContainerType.Equip,
        GameEnum.EBagContainerType.Bag,
    }

    local itemFuncUtil = MgrProxy:GetItemDataFuncUtil()
    ---@type FiltrateCond
    local condition = { Cond = itemFuncUtil.IsItemUID, Param = uid }
    local conditions = { condition }
    local ret = Data.BagApi:GetItemsByTypesAndConds(types, conditions)
    return ret[1]
end

--next--
function EquipMakeHoleRecastCtrl:BindEvents()
    self:BindEvent(MgrMgr:GetMgr("EquipMakeHoleMgr").EventDispatcher, MgrMgr:GetMgr("EquipMakeHoleMgr").ReceiveEquipHoleRefogeEvent, function(self)
        self._isRequestRecast = false
        self:ShowEquipMakeHoleRecast(self._currentEquipData, self._currentHoleIndex, true)
    end)

    self:BindEvent(MgrMgr:GetMgr("EquipMakeHoleMgr").EventDispatcher, MgrMgr:GetMgr("EquipMakeHoleMgr").ReceiveEquipSaveHoleReforgeEvent, function(self)
        self._isRequestReplace = false
        self:ShowEquipMakeHoleRecast(self._currentEquipData, self._currentHoleIndex)
    end)

    self:BindEvent(MgrMgr:GetMgr("EquipCardForgeHandlerMgr").EventDispatcher, MgrMgr:GetMgr("EquipCardForgeHandlerMgr").ReceiveEquipCardRemoveEvent, function(self)
        self:ShowEquipMakeHoleRecast(self._currentEquipData, self._currentHoleIndex)
    end)

    -- 当道具数据变化时更新需要材料信息
    local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
    self:BindEvent(gameEventMgr.l_eventDispatcher, gameEventMgr.OnBagUpdate, self._showMaterials)
end --func end
--next--
--lua functions end

--lua custom scripts
--- 这个方法主要是显示打洞重铸的一些面板，如果有卡牌就显示3个，如果没有就显示两个
---@param equipData ItemData
function EquipMakeHoleRecastCtrl:ShowEquipMakeHoleRecast(equipData, propertyIndex, isEquipHoleReforge)
    self._currentEquipData = equipData
    self._currentHoleIndex = propertyIndex
    local l_openHoleCount = equipData:GetOpenHoleCount()

    -- 做一层防御，如果开洞的数量小于当前的编号，这个时候说明传入的参数有问题
    if propertyIndex > l_openHoleCount then
        logError("[EquipMakeHoleRecastCtrl] fault param, plis check")
        return
    end

    local holeAttrs = equipData.AttrSet[GameEnum.EItemAttrModuleType.Hole][propertyIndex]
    local holeCacheAttrs = {}
    if 0 < #equipData.AttrSet[GameEnum.EItemAttrModuleType.HoleCache] then
        holeCacheAttrs = equipData.AttrSet[GameEnum.EItemAttrModuleType.HoleCache][propertyIndex]
    end

    local cards = equipData.AttrSet[GameEnum.EItemAttrModuleType.Card][propertyIndex]
    local l_propertyData = {}
    l_propertyData.Entry = holeAttrs
    l_propertyData.TableId = 0

    if 0 < #holeAttrs then
        l_propertyData.TableId = holeAttrs[1].TableID
    end

    local l_cachePropertyData = {}
    l_cachePropertyData.Entry = holeCacheAttrs
    l_cachePropertyData.TableId = 0
    if 0 < #holeCacheAttrs then
        l_cachePropertyData.TableId = holeCacheAttrs[1].TableID
    end

    self._recastTemplate2:SetData(l_cachePropertyData, isEquipHoleReforge)
    self.panel.RecastProperty3:SetActiveEx(#cards ~= 0)
    self.panel.ReplaceButton:SetActiveEx(#holeCacheAttrs ~= 0)

    if #cards == 0 then
        self._recastTemplate1:SetData(l_propertyData)
    else
        local l_cardData = {}
        l_cardData.CardId = cards[1].AttrID
        self._recastTemplate1:SetData(l_cardData)
        self._recastTemplate3:SetData(l_propertyData)
    end

    self:_showMaterials()
end

function EquipMakeHoleRecastCtrl:_showMaterials()
    if self._currentEquipData == nil then
        return
    end

    if self._currentHoleIndex == 0 then
        return
    end

    self._currentMaterials = nil
    local l_equipMgr = MgrMgr:GetMgr("EquipMgr")
    local l_currentEquipConsumeTable = l_equipMgr.GetEquipConsumeTableId(self._currentEquipData.ItemConfig.TypeTab, self._currentEquipData:GetEquipTableLv())
    local l_materials = nil
    if l_equipMgr.IsWeapon(self._currentEquipData.TID) then
        if self._currentHoleIndex == 1 then
            l_materials = l_currentEquipConsumeTable.WeaponReforgeCon1
        elseif self._currentHoleIndex == 2 then
            l_materials = l_currentEquipConsumeTable.WeaponReforgeCon2
        else
            l_materials = l_currentEquipConsumeTable.WeaponReforgeCon3
        end
    else
        if self._currentHoleIndex == 1 then
            l_materials = l_currentEquipConsumeTable.ArmorReforgeCon1
        else
            l_materials = l_currentEquipConsumeTable.ArmorReforgeCon2
        end
    end

    if l_materials == nil then
        logError("EquipConsumeTable打洞材料填的不对，洞的index：" .. tostring(self._currentHoleIndex) .. "装备id：" .. tostring(self._currentEquipData.TID))
        return
    end

    self._currentMaterials = l_materials
    local l_itemTableInfo1 = TableUtil.GetItemTable().GetRowByItemID(l_materials[0][0])
    self.panel.ItemIcon1:SetSpriteAsync(l_itemTableInfo1.ItemAtlas, l_itemTableInfo1.ItemIcon)
    self.panel.ItemName1.LabText = l_itemTableInfo1.ItemName
    local l_currentCount = Data.BagModel:GetCoinOrPropNumById(l_materials[0][0])
    local l_requireCount = l_materials[0][1]
    self.panel.ItemCount1.LabText = MgrMgr:GetMgr("ItemPropertiesMgr").GetRequireCountColorText(l_currentCount, l_requireCount) .. "/" .. tostring(l_requireCount)
    self.panel.consume2.gameObject:SetActiveEx(l_materials.Length == 2)
    if l_materials.Length == 2 then
        local l_itemTableInfo2 = TableUtil.GetItemTable().GetRowByItemID(l_materials[1][0])
        self.panel.ItemIcon2:SetSpriteAsync(l_itemTableInfo2.ItemAtlas, l_itemTableInfo2.ItemIcon)
        self.panel.ItemName2.LabText = l_itemTableInfo2.ItemName
        local l_currentCount = Data.BagModel:GetCoinOrPropNumById(l_materials[1][0])
        local l_requireCount = l_materials[1][1]
        self.panel.ItemCount2.LabText = MgrMgr:GetMgr("ItemPropertiesMgr").GetRequireCountColorText(l_currentCount, l_requireCount) .. "/" .. tostring(l_requireCount)
    end
end

--点击重铸按钮
function EquipMakeHoleRecastCtrl:_onRecastButton()
    if self._currentEquipData == nil then
        return
    end
    if self._currentMaterials == nil then
        return
    end

    if self:_getCardId() ~= 0 then
        self:_showRemoveCardBox("MakeHole_RemoveCardRecastText")
        return
    end

    for i = 1, self._currentMaterials.Length do
        local l_material = self._currentMaterials[i - 1]
        local id = l_material[0]
        local needCount = l_material[1]
        local currentCount = Data.BagModel:GetCoinOrPropNumById(id)
        if currentCount < needCount then
            MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(id, nil, nil, nil, true)
            return
        end
    end

    if self._currentHoleIndex > #self._currentEquipData.AttrSet[GameEnum.EItemAttrModuleType.Hole] then
        return
    end

    if 0 == #self._currentEquipData.AttrSet[GameEnum.EItemAttrModuleType.Hole][self._currentHoleIndex] then
        return
    end

    local cacheAttrs = self._currentEquipData.AttrSet[GameEnum.EItemAttrModuleType.HoleCache][self._currentHoleIndex]
    local l_tableId = 0
    if 0 ~= #cacheAttrs then
        l_tableId = cacheAttrs[1].TableID
    end

    if l_tableId == 0 then
        self:_startRequestEquipHoleRefoge()
        return
    end

    local l_holeTableInfo = TableUtil.GetEquipHoleTable().GetRowById(l_tableId)
    if l_holeTableInfo == nil then
        logError("EquipHoleTable表里没有配，id" .. tostring(l_tableId))
        return nil
    end

    if l_holeTableInfo.Quality == 3 then
        CommonUI.Dialog.ShowYesNoDlg(
                true, nil,
                Lang("MakeHole_RecastText"),
                function()
                    self:_startRequestEquipHoleRefoge()
                    UserDataManager.SetDataFromLua(EquipMakeHoleRecast_FirstMakeHoleRecast, MPlayerSetting.PLAYER_SETTING_GROUP, EquipMakeHoleRecast_FirstMakeHoleRecast)
                end
        )
    else
        local l_dateStrSave = UserDataManager.GetStringDataOrDef(EquipMakeHoleRecast_FirstMakeHoleRecast, MPlayerSetting.PLAYER_SETTING_GROUP, "")
        if string.ro_isEmpty(tostring(l_dateStrSave)) then
            CommonUI.Dialog.ShowYesNoDlg(
                    true, nil,
                    Lang("EquipMakeHoleRecast_FirstMakeHoleRecastText"),
                    function()
                        self:_startRequestEquipHoleRefoge()
                        UserDataManager.SetDataFromLua(EquipMakeHoleRecast_FirstMakeHoleRecast, MPlayerSetting.PLAYER_SETTING_GROUP, EquipMakeHoleRecast_FirstMakeHoleRecast)
                    end
            )
        else
            self:_startRequestEquipHoleRefoge()
        end
    end
end

function EquipMakeHoleRecastCtrl:_startRequestEquipHoleRefoge()
    if self._currentEquipData == nil then
        return
    end
    if self._currentHoleIndex == nil then
        return
    end

    if self._isRequestRecast then
        return
    end

    self._isRequestRecast = true
    MgrMgr:GetMgr("EquipMakeHoleMgr").RequestEquipHoleRefoge(self._currentEquipData.UID, self._currentHoleIndex)
end

function EquipMakeHoleRecastCtrl:_onReplaceButton()
    if self._currentEquipData == nil then
        return
    end

    local holeAttrs = self._currentEquipData.AttrSet[GameEnum.EItemAttrModuleType.Hole]
    if self._currentHoleIndex > #holeAttrs then
        return
    end

    if self:_getCardId() ~= 0 then
        self:_showRemoveCardBox("MakeHole_RemoveCardReplaceText")
        return
    end

    local l_tableId = 0
    if 0 < #holeAttrs[self._currentHoleIndex] then
        l_tableId = holeAttrs[self._currentHoleIndex][1].TableID
    end

    if l_tableId == 0 then
        self:_startRequestEquipSaveHoleReforge()
        return
    end

    local l_holeTableInfo = TableUtil.GetEquipHoleTable().GetRowById(l_tableId)
    if l_holeTableInfo == nil then
        logError("EquipHoleTable表里没有配，id" .. tostring(l_tableId))
        return nil
    end

    if l_holeTableInfo.Quality == 3 then
        CommonUI.Dialog.ShowYesNoDlg(
                true, nil,
                Lang("MakeHole_ReplaceText"),
                function()
                    self:_startRequestEquipSaveHoleReforge()
                end
        )
    else
        self:_startRequestEquipSaveHoleReforge()
    end
end

function EquipMakeHoleRecastCtrl:_startRequestEquipSaveHoleReforge()
    if self._currentEquipData == nil then
        return
    end

    if self._currentHoleIndex == nil then
        return
    end

    if self._isRequestReplace then
        return
    end

    self._isRequestReplace = true
    MgrMgr:GetMgr("EquipMakeHoleMgr").RequestEquipSaveHoleReforge(self._currentEquipData.UID, self._currentHoleIndex)
end

function EquipMakeHoleRecastCtrl:_showRemoveCardBox(tipsText)
    if self._currentEquipData == nil then
        return
    end

    local l_equipMgr = MgrMgr:GetMgr("EquipMgr")
    local l_currentEquipConsumeTable = l_equipMgr.GetEquipConsumeTableId(self._currentEquipData.ItemConfig.TypeTab, l_equipMgr.GetEquipLimitLevel(self._currentEquipData.TID))
    local l_consume = l_currentEquipConsumeTable.DismantleCardConsume

    local l_consumeDatas = {}
    for i = 0, l_consume.Length - 1 do
        local l_data = {}
        l_data.ID = tonumber(l_consume[i][0])
        l_data.IsShowCount = false
        l_data.IsShowRequire = true
        l_data.RequireCount = tonumber(l_consume[i][1])
        table.insert(l_consumeDatas, l_data)
    end

    CommonUI.Dialog.ShowConsumeDlg("", Common.Utils.Lang(tipsText),
            function()
                MgrMgr:GetMgr("EquipCardForgeHandlerMgr").RequestEquipCardRemove(self._currentEquipData.UID, self._currentHoleIndex,l_consumeDatas)
            end, nil, l_consumeDatas)
end

function EquipMakeHoleRecastCtrl:_getCardId()
    if self._currentEquipData == nil then
        return 0
    end

    if self._currentHoleIndex == 0 then
        return 0
    end

    local cardData = self._currentEquipData.AttrSet[GameEnum.EItemAttrModuleType.Card][self._currentHoleIndex]
    if nil == cardData or 0 == #cardData then
        return 0
    end

    return cardData[1].AttrID
end
--lua custom scripts end
