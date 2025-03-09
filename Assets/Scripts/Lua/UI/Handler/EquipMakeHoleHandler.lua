--this file is gen by script
--you can edit this file in custom part

--lua requires
require "UI/UIBaseHandler"
require "UI/Panel/EquipMakeHolePanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseHandler
--next--
--lua fields end

--lua class define
EquipMakeHoleHandler = class("EquipMakeHoleHandler", super)
--lua class define end

--lua functions
function EquipMakeHoleHandler:ctor()
    super.ctor(self, HandlerNames.EquipMakeHole, 0)
end --func end
--next--
function EquipMakeHoleHandler:Init()
    self.panel = UI.EquipMakeHolePanel.Bind(self)
    super.Init(self)

    self._currentEquipData = nil
    self._currentMaterials = nil
    self._currentHoleIndex = 0
    self._holeTemplatePool = self:NewTemplatePool(
            {
                TemplateClassName = "MakeHoleTemplate",
                TemplatePath = "UI/Prefabs/MakeHolePropertyPrefab",
                TemplateParent = self.panel.HoleParent.Transform,
                Method = function(index)
                    self:_showEquipMakeHoleRecastPanel(index)
                end
            })

    self._equipItem = self:NewTemplate("ItemTemplate", { IsActive = false, TemplateParent = self.panel.CurrentEquipItemParent.transform })
    self._makeHoleMaterialTemplatePool = self:NewTemplatePool({
        TemplateClassName = "ItemTemplate",
        TemplateParent = self.panel.MaterialsParent.transform
    })

    self.panel.MakeHoleButton:AddClick(function()
        if self._currentEquipData == nil then
            return
        end
        if self._currentMaterials == nil then
            return
        end
        local totalCost = 0
        for i = 1, #self._currentMaterials do
            local id = self._currentMaterials[i].ID
            local needCount = self._currentMaterials[i].RequireCount
            local currentCount
            if self._currentMaterials[i].RequireMaxCount then
                currentCount = self._currentMaterials[i].RequireMaxCount
            else
                currentCount = Data.BagModel:GetCoinOrPropNumById(id)
            end

            totalCost = id == GameEnum.l_virProp.Coin101 and needCount or 0
            if currentCount < needCount and id ~= GameEnum.l_virProp.Coin101 then
                MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(id, nil, nil, nil, true)
                return
            end
        end

        MgrMgr:GetMgr("EquipMakeHoleMgr").RequestEquipMakeHole(self._currentEquipData.UID,totalCost)
    end)
end --func end
--next--
function EquipMakeHoleHandler:Uninit()
    super.Uninit(self)
    self.panel = nil
    self._equipItem = nil
    self._holeTemplatePool = nil
    self._makeHoleMaterialTemplatePool = nil
    self._currentMaterials = nil
end --func end
--next--
function EquipMakeHoleHandler:OnActive()
    self.panel.CurrentEquipItemParent:SetActiveEx(false)
    self.panel.MaterialsPanel:SetActiveEx(false)
    self.panel.AllOpenText:SetActiveEx(false)
    self:_setSelectEquipData()
end --func end
--next--
function EquipMakeHoleHandler:OnDeActive()
    self._currentEquipData = nil
end --func end
--next--
function EquipMakeHoleHandler:Update()
    -- do nothing
end --func end
--next--
function EquipMakeHoleHandler:OnShow()
    self:_setSelectEquipData()
end --func end

--next--
function EquipMakeHoleHandler:BindEvents()
    self:BindEvent(MgrMgr:GetMgr("SelectEquipMgr").EventDispatcher, MgrMgr:GetMgr("SelectEquipMgr").SelectEquipCellEvent, function(self, data)
        if self:IsShowing() then
            self:_onEquipItemButton(data)
        end
    end)

    self:BindEvent(MgrMgr:GetMgr("EquipMakeHoleMgr").EventDispatcher, MgrMgr:GetMgr("EquipMakeHoleMgr").ReceiveEquipMakeHoleEvent, function(self)
        self:_dealWithFirstMakeHoleRedSign()
        self:_refreshSelectEquip()
        self:_onEquipItemButton(self._currentEquipData, true)
    end)

    self:BindEvent(MgrMgr:GetMgr("SelectEquipMgr").EventDispatcher, MgrMgr:GetMgr("SelectEquipMgr").SelectEquipShowEquipEvent, function(self, isShow)
        self.panel.MainPanel.gameObject:SetActiveEx(isShow)
    end)

    self:BindEvent(MgrMgr:GetMgr("EquipMakeHoleMgr").EventDispatcher, MgrMgr:GetMgr("EquipMakeHoleMgr").ReceiveEquipSaveHoleReforgeEvent, self._refreshEquipItem)
    self:BindEvent(MgrMgr:GetMgr("EquipCardForgeHandlerMgr").EventDispatcher, MgrMgr:GetMgr("EquipCardForgeHandlerMgr").ReceiveEquipCardRemoveEvent, self._refreshEquipItem)

    --当道具数据变化时更新需要材料信息
    local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
    self:BindEvent(gameEventMgr.l_eventDispatcher, gameEventMgr.OnBagUpdate, self._showMaterials)
end --func end
--next--
--lua functions end

--lua custom scripts
function EquipMakeHoleHandler:OnReconnected()
    if self._currentEquipData == nil then
        return
    end

    super.OnReconnected(self)
    self:_onEquipItemButton(self._currentEquipData)
end

function EquipMakeHoleHandler:_refreshEquipItem()
    self:_onEquipItemButton(self._currentEquipData)
end

---@param data ItemData
function EquipMakeHoleHandler:_onEquipItemButton(data, isMakeHole)
    if data == nil then
        self.panel.CurrentEquipItemParent:SetActiveEx(false)
        self.panel.HoleParent:SetActiveEx(false)
        self.panel.MaterialsPanel:SetActiveEx(false)
        self.panel.AllOpenText:SetActiveEx(false)
        return
    end

    self.panel.HoleParent:SetActiveEx(true)
    self.panel.CurrentEquipItemParent:SetActiveEx(true)
    self._currentEquipData = data
    self._equipItem:SetData({ PropInfo = self._currentEquipData, IsShowCount = false })
    local l_equipTable = TableUtil.GetEquipTable().GetRowById(self._currentEquipData.TID)
    if l_equipTable == nil then
        logError("EquipTable not have ID" .. tostring(self._currentEquipData.TID))
        return
    end

    local l_itemTableInfo = self._currentEquipData.ItemConfig
    self.panel.EquipName.LabText = l_itemTableInfo.ItemName
    local l_holePropertyDatas = {}
    for i = 1, l_equipTable.HoleNum do
        table.insert(l_holePropertyDatas, data)
    end

    self._holeTemplatePool:ShowTemplates({
        Datas = l_holePropertyDatas,
        AdditionalData = isMakeHole,
    })

    local l_openHoleCount = self._currentEquipData:GetOpenHoleCount()

    local l_currentSelectHole = l_openHoleCount + 1
    if l_currentSelectHole <= l_equipTable.HoleNum then
        self._holeTemplatePool:SelectTemplate(l_currentSelectHole)
        self:_onHoleCell(l_currentSelectHole)
        self.panel.MaterialsPanel:SetActiveEx(true)
        self.panel.AllOpenText:SetActiveEx(false)
    else
        self._holeTemplatePool:SelectTemplate(0)
        self.panel.MaterialsPanel:SetActiveEx(false)
        self.panel.AllOpenText:SetActiveEx(true)
    end
end
function EquipMakeHoleHandler:_onHoleCell(index)
    self._currentHoleIndex = index
    self:_showMaterials()
end

function EquipMakeHoleHandler:_getBagItemsByTid(tid)
    if GameEnum.ELuaBaseType.Number ~= type(tid) then
        logError("[MagicRecoverMachine] invalid param")
        return {}
    end

    local types = { GameEnum.EBagContainerType.Bag }
    local itemFuncUtil = MgrProxy:GetItemDataFuncUtil()
    ---@type FiltrateCond
    local condition = { Cond = itemFuncUtil.ItemMatchesTid, Param = tid }
    local conditions = { condition }
    local ret = Data.BagApi:GetItemsByTypesAndConds(types, conditions)
    return ret
end

function EquipMakeHoleHandler:_showMaterials()
    if self._currentEquipData == nil then
        return
    end

    if self._currentEquipData == 0 then
        return
    end

    local l_equipMgr = MgrMgr:GetMgr("EquipMgr")
    local l_currentEquipConsumeTable = l_equipMgr.GetEquipConsumeTableId(self._currentEquipData.ItemConfig.TypeTab, l_equipMgr.GetEquipLimitLevel(self._currentEquipData.TID))

    local l_materials = nil
    if l_equipMgr.IsWeapon(self._currentEquipData.TID) then
        if self._currentHoleIndex == 1 then
            l_materials = l_currentEquipConsumeTable.WeaponHoleCon1
        elseif self._currentHoleIndex == 2 then
            l_materials = l_currentEquipConsumeTable.WeaponHoleCon2
        else
            l_materials = l_currentEquipConsumeTable.WeaponHoleCon3
        end
    else
        if self._currentHoleIndex == 1 then
            l_materials = l_currentEquipConsumeTable.ArmorHoleCon1
        else
            l_materials = l_currentEquipConsumeTable.ArmorHoleCon2
        end
    end

    if l_materials == nil then
        logError("打洞材料是空的，洞的index：" .. tostring(self._currentHoleIndex) .. "装备id：" .. tostring(self._currentEquipData.TID))
        return
    end

    local l_materialDatas = {}
    for i = 1, l_materials.Length do
        local data = {}
        local l_id = l_materials[i - 1][0]
        if l_id == 0 then
            l_id = self._currentEquipData.TID
            local l_equips = self:_getBagItemsByTid(l_id)
            local l_maxCount = 0
            for i = 1, #l_equips do
                if l_equips[i].uid ~= self._currentEquipData.UID then
                    if self:_isEquipCanBeMaterial(l_equips[i]) then
                        l_maxCount = l_maxCount + 1
                    end
                end
            end

            data.RequireMaxCount = l_maxCount
        end

        data.ID = l_id
        data.IsShowCount = false
        data.IsShowRequire = true
        data.RequireCount = l_materials[i - 1][1]
        table.insert(l_materialDatas, data)
    end
    
    self._currentMaterials = l_materialDatas
    self._makeHoleMaterialTemplatePool:ShowTemplates({ Datas = l_materialDatas })
end

function EquipMakeHoleHandler:_isEquipCanBeMaterial(equipInfo)
    local l_refineLevel = MgrMgr:GetMgr("RefineMgr").GetRefineLevel(equipInfo)
    if l_refineLevel > 0 then
        return false
    end

    if MgrMgr:GetMgr("EnchantMgr").IsEnchanted(equipInfo) then
        return false
    end

    if #MgrMgr:GetMgr("EquipMakeHoleMgr").GetCardIds(equipInfo) > 0 then
        return false
    end

    if MgrMgr:GetMgr("RefineMgr").IsDisrepair(equipInfo) then
        return false
    end

    return true
end

function EquipMakeHoleHandler:_showEquipMakeHoleRecastPanel(index)
    if self._currentEquipData == nil then
        return
    end

    ---@type CardRecastUIParam
    local uiParam = {
        itemData = self._currentEquipData,
        targetIdx = index
    }

    UIMgr:ActiveUI(UI.CtrlNames.AttributeRecasting, uiParam)
end

function EquipMakeHoleHandler:_getSelectEquipTemplate()
    local l_equipBG = UIMgr:GetUI(UI.CtrlNames.EquipBG)
    if l_equipBG == nil then
        return nil
    end

    return l_equipBG:GetSelectEquipTemplate()
end

function EquipMakeHoleHandler:_setSelectEquipData()
    local l_template = self:_getSelectEquipTemplate()
    if l_template then
        l_template:SetData({
            SelectEquipMgrName = "EquipMakeHoleMgr",
            IsSelectSameEquip = true,
            NoneEquipTextPosition = self.panel.NoneEquipTextParent.transform.position
        })
    end
end

function EquipMakeHoleHandler:_refreshSelectEquip()
    local l_template = self:_getSelectEquipTemplate()
    l_template:RefreshSelectEquip()
end

function EquipMakeHoleHandler:_dealWithFirstMakeHoleRedSign()
    if self._currentEquipData == nil then
        return
    end

    local l_key = MgrMgr:GetMgr("EquipMakeHoleMgr").FirstMakeHoleRedSignStorageKey
    local l_localStorageData = UserDataManager.GetStringDataOrDef(l_key, MPlayerSetting.PLAYER_SETTING_GROUP, "")

    --没有存储过
    if string.ro_isEmpty(l_localStorageData) then
        --存储此标记
        UserDataManager.SetDataFromLua(l_key, MPlayerSetting.PLAYER_SETTING_GROUP, l_key)
        local l_uidKey = l_key .. tostring(self._currentEquipData.UID)
        --存储带uid的标记，显示时会根据uid来显示
        UserDataManager.SetDataFromLua(l_uidKey, MPlayerSetting.PLAYER_SETTING_GROUP, l_uidKey)
    end
end
return EquipMakeHoleHandler
--lua custom scripts end
