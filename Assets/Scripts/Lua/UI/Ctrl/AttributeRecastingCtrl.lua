--this file is gen by script
--you can edit this file in custom part

--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/AttributeRecastingPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--- 如果是有缓存属性，属性显示会设置在左边
--- 如果没有对比属性，当前属性就会显示在中间
local C_PROPERTY_POS_HAS_ATTR = { -143.27, 82.32, 0 }
local C_PROPERTY_POS_NO_ATTR = { -143.27, 82.32, 0 }--{ 50, 82.32, 0 }
local EquipMakeHoleRecast_FirstMakeHoleRecast = "EquipMakeHoleRecast_FirstMakeHoleRecast"
local attrUtil = MgrMgr:GetMgr("AttrDescUtil")
--lua fields end

--lua class define
AttributeRecastingCtrl = class("AttributeRecastingCtrl", super)
--lua class define end

--lua functions
function AttributeRecastingCtrl:ctor()
    super.ctor(self, CtrlNames.AttributeRecasting, UILayer.Function, nil, ActiveType.Standalone)
end --func end
--next--
function AttributeRecastingCtrl:Init()
    self.panel = UI.AttributeRecastingPanel.Bind(self)
    super.Init(self)

    self:_initMember()
    self:_initTemplateConfig()
    self:_initWidgets()
end --func end
--next--
function AttributeRecastingCtrl:Uninit()
    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function AttributeRecastingCtrl:OnActive()
    ---@type CardRecastUIParam
    local inputParam = self.uiPanelData
    self._selectedItem = inputParam.itemData
    self._currentHoleIdx = inputParam.targetIdx
    self:_showPageState(self._selectedItem)
end --func end
--next--
function AttributeRecastingCtrl:OnDeActive()
    -- do nothing
end --func end
--next--
function AttributeRecastingCtrl:Update()
    -- do nothing
end --func end
--next--
function AttributeRecastingCtrl:BindEvents()
    -- 当道具数据变化时更新需要材料信息
    local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
    self:BindEvent(gameEventMgr.l_eventDispatcher, gameEventMgr.OnBagUpdate, self._resetPage)
end --func end
--next--
--lua functions end

--lua custom scripts
--- 初始化成员变量
function AttributeRecastingCtrl:_initMember()
    ---@type ItemData
    self._selectedItem = 0
    --- 开启的是哪个洞的编号
    self._currentHoleIdx = 0
end

--- 初始化模板类的配置数据
function AttributeRecastingCtrl:_initTemplateConfig()
    --- 当前属性配置
    self._currentAttrTemplatePoolConfig = {
        TemplateClassName = "EquipHoleAttrTemplate",
        TemplatePath = "UI/Prefabs/EquipHoleAttr",
        TemplateParent = self.panel.OriginalPropertyParent.Transform,
    }

    --- 缓存属性配置
    self._cacheAttrTemplatePoolConfig = {
        TemplateClassName = "EquipHoleAttrTemplate",
        TemplatePath = "UI/Prefabs/EquipHoleAttr",
        TemplateParent = self.panel.NewPropertyParent.Transform,
    }

    --- 需要消耗材料配置
    self._matPoolConfig = {
        TemplateClassName = "ItemTemplate",
        TemplatePath = "UI/Prefabs/ItemPrefab",
        TemplateParent = self.panel.ForgeMaterialParent.Transform,
    }
end

--- 初始化控件
function AttributeRecastingCtrl:_initWidgets()
    self._matItemPool = self:NewTemplatePool(self._matPoolConfig)
    self._currentAttrPool = self:NewTemplatePool(self._currentAttrTemplatePoolConfig)
    self._cacheAttrPool = self:NewTemplatePool(self._cacheAttrTemplatePoolConfig)
    local onClose = function()
        self:_onClose()
    end

    local onRecast = function()
        self:_onRecastConfirm()
    end

    local onReplace = function()
        self:_onReplaceConfirm()
    end

    local onClickPreview = function()
        self:_showPreview()
    end

    self.panel.ButtonClose:AddClick(onClose)
    self.panel.Btn_Recast:AddClick(onRecast)
    self.panel.Btn_replace:AddClick(onReplace)
    self.panel.PreviewButton:AddClick(onClickPreview)
end

--- 显示属性预览
function AttributeRecastingCtrl:_showPreview()
    if nil == self._selectedItem then
        return
    end

    local equipConfig = self._selectedItem.EquipConfig
    local holeTable = TableUtil.GetEquipHoleTable().GetTable()
    ---@type EquipHoleTable[]
    local previewData = {}
    for i = 1, #holeTable do
        local singleHoleConfig = holeTable[i]
        if singleHoleConfig.ThesaurusId == equipConfig.HoleId then
            table.insert(previewData, singleHoleConfig)
        end
    end

    local sortFunc = function(a, b)
        return a.Quality > b.Quality
    end

    table.sort(previewData, sortFunc)
    UIMgr:ActiveUI(UI.CtrlNames.PropertyPreviewPanel, previewData)
end

--- 确认替换属性，替换原有的属性
function AttributeRecastingCtrl:_onReplaceConfirm()
    local itemAttrType = GameEnum.EItemAttrModuleType
    local currentHoleIdx = self._currentHoleIdx
    local currentAttrList = self._selectedItem.AttrSet[itemAttrType.Hole][currentHoleIdx]
    local hasRareAttr = self:_containsRareAttr(currentAttrList)
    if not hasRareAttr then
        self:_reqReplace()
        return
    end

    CommonUI.Dialog.ShowYesNoDlg(
            true, nil,
            Lang("MakeHole_ReplaceText"),
            function()
                self:_reqReplace()
            end
    )
end

--- 确认打洞重铸，这里是对缓存属性进行替换
function AttributeRecastingCtrl:_onRecastConfirm()
    local itemAttrType = GameEnum.EItemAttrModuleType
    local currentHoleIdx = self._currentHoleIdx
    local cacheAttrList = self._selectedItem.AttrSet[itemAttrType.HoleCache][currentHoleIdx]
    local hasRareAttr = self:_containsRareAttr(cacheAttrList)
    if not hasRareAttr then
        self:_reqRecast()
        return
    end

    local l_dateStrSave = UserDataManager.GetStringDataOrDef(EquipMakeHoleRecast_FirstMakeHoleRecast, MPlayerSetting.PLAYER_SETTING_GROUP, "")
    if string.ro_isEmpty(tostring(l_dateStrSave)) then
        CommonUI.Dialog.ShowYesNoDlg(
                true, nil,
                Lang("EquipMakeHoleRecast_FirstMakeHoleRecastText"),
                function()
                    self:_reqRecast()
                    UserDataManager.SetDataFromLua(EquipMakeHoleRecast_FirstMakeHoleRecast, MPlayerSetting.PLAYER_SETTING_GROUP, EquipMakeHoleRecast_FirstMakeHoleRecast)
                end
        )

        return
    end

    CommonUI.Dialog.ShowYesNoDlg(
            true, nil,
            Lang("MakeHole_RecastText"),
            function()
                self:_reqRecast()
                UserDataManager.SetDataFromLua(EquipMakeHoleRecast_FirstMakeHoleRecast, MPlayerSetting.PLAYER_SETTING_GROUP, EquipMakeHoleRecast_FirstMakeHoleRecast)
            end
    )
end

function AttributeRecastingCtrl:_reqReplace()
    MgrMgr:GetMgr("EquipMakeHoleMgr").RequestEquipSaveHoleReforge(self._selectedItem.UID, self._currentHoleIdx)
end

function AttributeRecastingCtrl:_reqRecast()
    MgrMgr:GetMgr("EquipMakeHoleMgr").RequestEquipHoleRefoge(self._selectedItem.UID, self._currentHoleIdx)
end

--- 关闭当前界面
function AttributeRecastingCtrl:_onClose()
    UIMgr:DeActiveUI(UI.CtrlNames.AttributeRecasting)
end

--- 重置界面状态
---@param itemUpdateDataList ItemUpdateData[]
function AttributeRecastingCtrl:_resetPage(itemUpdateDataList)
    if nil == itemUpdateDataList then
        logError("[AttrRecast] invalid param")
        return
    end

    for i = 1, #itemUpdateDataList do
        local singleUpdateData = itemUpdateDataList[i]
        local newItem = singleUpdateData.NewItem
        if nil ~= newItem and newItem.UID == self._selectedItem.UID then
            self:_showPageState(newItem)
            return
        end
    end
end

--- 返回是否存在稀有属性
---@param itemAttrDataList ItemAttrData[]
function AttributeRecastingCtrl:_containsRareAttr(itemAttrDataList)
    if nil == itemAttrDataList then
        return false
    end

    local holeAttrColor = GameEnum.EEquipHoleAttrQuality
    for i = 1, #itemAttrDataList do
        local singleData = itemAttrDataList[i]
        local tableID = singleData.TableID
        local targetConfig = TableUtil.GetEquipHoleTable().GetRowById(tableID)
        if nil == targetConfig and holeAttrColor.Purple == targetConfig.Quality then
            return true
        end
    end

    return false
end

--- 根据数据生成页面状态
---@param itemData ItemData
function AttributeRecastingCtrl:_showPageState(itemData)
    if nil == itemData then
        return
    end

    local itemAttrType = GameEnum.EItemAttrModuleType
    local currentHoleIdx = self._currentHoleIdx
    local currentAttrList = itemData.AttrSet[itemAttrType.Hole][currentHoleIdx]
    local cacheAttrList = itemData.AttrSet[itemAttrType.HoleCache][currentHoleIdx]
    self:_showPageAttrs(currentAttrList, cacheAttrList)
    self:_showMats()
end

--- 显示消耗属性材料
function AttributeRecastingCtrl:_showMats()
    local itemDataList = self:_getMats()
    local itemTemplateParam = { Datas = itemDataList }
    self._matItemPool:ShowTemplates(itemTemplateParam)
end

--- 计算材料量
---@return ItemTemplateParam[]
function AttributeRecastingCtrl:_getMats()
    local itemData = self._selectedItem
    local currentSelectIdx = self._currentHoleIdx
    if nil == itemData then
        logError("[AttrRecast] item data is nil")
        return {}
    end

    if 0 >= self._currentHoleIdx then
        logError("[AttrRecast] invalid hole idx: " .. tostring(currentSelectIdx))
        return {}
    end

    local equipType = itemData.ItemConfig.TypeTab
    local itemLv = itemData:GetEquipTableLv()
    local targetID = self:_genEquipConsumeTableID(equipType, itemLv)
    local equipConsumeConfig = TableUtil.GetEquipConsumeTable().GetRowByID(targetID)
    if nil == equipConsumeConfig then
        logError("[AttrRecast] invalid param")
        return {}
    end

    local weaponMap = {
        [1] = equipConsumeConfig.WeaponReforgeCon1,
        [2] = equipConsumeConfig.WeaponReforgeCon2,
        [3] = equipConsumeConfig.WeaponReforgeCon3,
    }

    local armorMap = {
        [1] = equipConsumeConfig.ArmorReforgeCon1,
        [2] = equipConsumeConfig.ArmorReforgeCon2
    }

    local equipType = GameEnum.EEquipSlotType
    local equipConsumeMap = {
        [equipType.Weapon] = weaponMap,
        --- 武器和饰品统一走武器消耗配置
        [equipType.Accessory] = weaponMap,
        [equipType.Armor] = armorMap,
        [equipType.Cape] = armorMap,
        [equipType.Boot] = armorMap,
        [equipType.BackUpHand] = armorMap,
        --- 头饰走防具
        [equipType.HeadWear] = armorMap,
    }

    local currentEquipID = itemData.EquipConfig.EquipId
    local targetMap = equipConsumeMap[currentEquipID]
    if nil == targetMap then
        logError("[AttrRecast] invalid equipID, equipID: " .. tostring(itemData.TID) .. " equipID: " .. tostring(currentEquipID))
        return {}
    end

    local targetList = targetMap[currentSelectIdx]
    if nil == targetList then
        logError("[AttrRecast] invalid hole idx: " .. tostring(currentSelectIdx))
        return {}
    end

    ---@type ItemTemplateParam[]
    local ret = {}
    for i = 0, targetList.Length - 1 do
        local singleConfig = targetList[i]
        local matID = singleConfig[0]
        local matCount = singleConfig[1]
        ---@type ItemTemplateParam
        local singleItemParam = {
            ID = matID,
            IsShowCount = false,
            IsShowRequire = true,
            RequireCount = matCount
        }

        table.insert(ret, singleItemParam)
    end

    return ret
end

--- 生成消耗表ID
function AttributeRecastingCtrl:_genEquipConsumeTableID(equipType, equipLv)
    local C_MZ_EQUIP_CONSUME = 10000
    local C_MZ_EQUIP_LV_TEN = 10
    if nil == equipType or nil == equipLv then
        logError("[AttrRecast] invalid param")
        return
    end

    local intLv = equipLv / C_MZ_EQUIP_LV_TEN
    local intPart = math.modf(intLv)
    local ret = C_MZ_EQUIP_CONSUME * equipType + C_MZ_EQUIP_LV_TEN * intPart
    return ret
end

---@param currentAttrList ItemAttrData[]
---@param cacheAttrList ItemAttrData[]
function AttributeRecastingCtrl:_showPageAttrs(currentAttrList, cacheAttrList)
    if nil == currentAttrList then
        logError("[AttrRecast] invalid attr, current attr got nil")
        currentAttrList = {}
    end

    if nil == cacheAttrList then
        cacheAttrList = {}
    end

    local cacheAttrCount = #cacheAttrList
    self:_showBoardState(cacheAttrCount)
    self:_showAttrStrings(currentAttrList, cacheAttrList)
end

--- 控制面板的显示和隐藏情况
function AttributeRecastingCtrl:_showBoardState(cacheAttrCount)
    if nil == cacheAttrCount then
        logError("[AttrRecasting] invalid param")
        return
    end

    local C_NO_ATTR = 0
    local showNewAttr = C_NO_ATTR ~= cacheAttrCount
    self.panel.NewProperty.gameObject:SetActiveEx(showNewAttr)
    local C_POS_MAP = {
        [true] = C_PROPERTY_POS_HAS_ATTR,
        [false] = C_PROPERTY_POS_NO_ATTR
    }

    local targetPos = C_POS_MAP[showNewAttr]
    self.panel.OriginalProperty.transform:SetLocalPos(targetPos[1], targetPos[2], targetPos[3])
end

--- 显示属性字符串
---@param currentAttrList ItemAttrData[]
---@param cacheAttrList ItemAttrData[]
function AttributeRecastingCtrl:_showAttrStrings(currentAttrList, cacheAttrList)
    if nil == currentAttrList or nil == cacheAttrList then
        logError("[AttrRecast] invalid param")
        return
    end

    local currentAttrDataList = { Datas = self:_getAttrStrArray(currentAttrList) }
    local cacheAttrDataList = { Datas = self:_getAttrStrArray(cacheAttrList) }
    self._currentAttrPool:ShowTemplates(currentAttrDataList)
    self._cacheAttrPool:ShowTemplates(cacheAttrDataList)
end

---@param itemAttrDataList ItemAttrData[]
---@return string[]
function AttributeRecastingCtrl:_getAttrStrArray(itemAttrDataList)
    if nil == itemAttrDataList then
        return "[MakeHoleTemp] attrs got nil"
    end

    local ret = {}
    for i = 1, #itemAttrDataList do
        local singleAttr = itemAttrDataList[i]
        local colorTag = nil
        if nil == singleAttr.TableID then
            local attrStr = attrUtil.GetAttrStr(singleAttr, colorTag).FullValue
            table.insert(ret, attrStr)
        else
            local l_holeTableInfo = TableUtil.GetEquipHoleTable().GetRowById(singleAttr.TableID)
            colorTag = RoQuality.GetColorTag(l_holeTableInfo.Quality)
            local singleAttrStr = attrUtil.GetAttrStr(singleAttr, colorTag).FullValue
            table.insert(ret, singleAttrStr)
        end
    end

    return ret
end

--lua custom scripts end
return AttributeRecastingCtrl