--- 用RO_Item来创建数据的工厂
require "Data/Model/ItemData"
require "Data/Model/ItemAttrData"
require "TableEx/ProOfflineMap"

module("Data", package.seeall)

ItemDataRoItemFactory = class("ItemDataRoItemFactory")
local itemAttrModuleType = GameEnum.EItemAttrModuleType
local contType = GameEnum.EBagContainerType
local C_BIT_16 = 65536
local C_NUMBER_PERCENTAGE_VALUE = 0.01

local C_SVR_HOLE_ATTR_IDX_MAP = {
    [1] = EItemAttrModuleSvrType.Attr_Hole_1,
    [2] = EItemAttrModuleSvrType.Attr_Hole_2,
    [3] = EItemAttrModuleSvrType.Attr_Hole_3,
}

local C_SVR_HOLE_CACHE_ATTR_IDX_MAP = {
    [1] = EItemAttrModuleSvrType.Attr_HoleCache_1,
    [2] = EItemAttrModuleSvrType.Attr_HoleCache_2,
    [3] = EItemAttrModuleSvrType.Attr_HoleCache_3,
}

function ItemDataRoItemFactory:ctor()
    --- 这是一个道具额外数据类型对客户端数据映射
    --- 因为self的key本身就是string，所以直接映射过来
    self.C_SVR_ITEM_EXTRA_DATA_MAP = {
        [EItemExtraDataKey.None] = "ExpLv",
        [EItemExtraDataKey.IEDK_EnchantTimesTotal] = "EnchantTimesTotal",
        [EItemExtraDataKey.IEDK_DeviceDuration] = "DeviceItemDuration",
        [EItemExtraDataKey.IEDK_RefineUnlockExp] = "RefineUnlockExp",
        [EItemExtraDataKey.IEDK_GuildRedPacketValue] = "GuildRedPacketValue",
        [EItemExtraDataKey.IEDK_WheelWeight] = "Weight",
        [EItemExtraDataKey.IEDK_DAY_COUNT] = "CardDayUseCount",
        [EItemExtraDataKey.IEDK_TOTAL_COUNT] = "CardTotalUseCount",
        [EItemExtraDataKey.IEDK_WheelAttrTableId] = "WheelAttrTID"
    }

    --- PB协议当中有一些布尔值是用bit位存的
    self.C_SVR_BOOL_MAP = {
        [EItemDataBitType.IsBind] = "IsBind",
        [EItemDataBitType.IsDamaged] = "Damaged",
        [EItemDataBitType.EnchantExtracted] = "EnchantExtracted",
        [EItemDataBitType.ItemFormStall] = "IsBusiness",
        [EItemDataBitType.ItemFromAuction] = "IsAuction",
        [EItemDataBitType.ItemActive] = "IsUsing",
    }

    ---@type table<number, number>
    self._gearConfigMap = {}
    self.C_INT_REFINE_OFFSET_VALUE = 1000
    ---@type table<number, EquipRefineTable>
    self._refineConfigMap = {}
    ---@type table<number, string>
    self._equipIntStrMap = {}
    self:_initGearConfig()
    self:_initRefineConfig()
    self:_initEquipStringMapConfig()
end

function ItemDataRoItemFactory:_initGearConfig()
    local gearSkillTableList = TableUtil.GetWheelSkillTable().GetTable()
    for i = 1, #gearSkillTableList do
        local singleConfig = gearSkillTableList[i]
        if nil == self._gearConfigMap[singleConfig.BuffId] then
            self._gearConfigMap[singleConfig.BuffId] = singleConfig.Id
        end
    end
end

--- 初始化精炼表，构建精炼索引
function ItemDataRoItemFactory:_initRefineConfig()
    local refineTable = TableUtil.GetEquipRefineTable().GetTable()
    for i = 1, #refineTable do
        local singleConfig = refineTable[i]
        local key = self:_getRefineConfigRef(singleConfig.Position, singleConfig.RefineLevel)
        self._refineConfigMap[key] = singleConfig
    end
end

function ItemDataRoItemFactory:_initEquipStringMapConfig()
    local fullEquipIntStrMap = TableUtil.GetEquipMapStringInt().GetTable()
    for i = 1, #fullEquipIntStrMap do
        local singleData = fullEquipIntStrMap[i]
        self._equipIntStrMap[singleData.Value] = singleData.ParamName
    end
end

function ItemDataRoItemFactory:_getRefineConfigRef(pos, refineLv)
    local ret = pos * self.C_INT_REFINE_OFFSET_VALUE + refineLv
    return ret
end

--- 重构后的道具协议
---@param roItemData Ro_Item
---@param itemData ItemData
---@return ItemData
function ItemDataRoItemFactory:InitWithROItemData(roItemData, itemData)
    if nil == roItemData then
        logError("[ItemData] pb data param got nil, init failed")
        return nil
    end

    self:_parseSvrDataMap(roItemData, itemData)
    if nil == itemData.ItemConfig then
        logError("[itemLocalFactory] fatal error, real item create failed, tid: " .. tostring(itemData.TID) .. ", return nil")
        return nil
    end

    self:_parseSvrAttrData(roItemData, itemData)
    return itemData
end

---@param roItemData Ro_Item
---@param itemData ItemData
function ItemDataRoItemFactory:_parseSvrDataMap(roItemData, itemData)
    if nil == roItemData or nil == roItemData.extra_data_map then
        logError("[ItemData] pb data param got nil, init failed")
        return
    end

    local containerType, svrSlot = self:_getContTypeAndSlotID(roItemData.item_pos)
    if nil == containerType then
        logError("[ItemData] invalid container type: " .. ToString(roItemData.item_pos))
    end

    itemData.UID = roItemData.uid
    itemData.TID = roItemData.item_id
    itemData.CreateTime = tonumber(roItemData.create_time)
    itemData.ItemCount = ToInt64(roItemData.item_count)
    itemData.ContainerType = containerType or contType.None
    itemData.SvrSlot = svrSlot or -1
    itemData.EffectiveTime = tonumber(roItemData.effective_time)

    --- 有一个坑，如果是类型不匹配去计算，会出现除零报错的异常
    if 0 < itemData.ItemCount then
        local price = ToInt64(roItemData.total_price) / itemData.ItemCount
        itemData.Price = ToInt64(price)
    end

    self:_initConfigData(itemData)
    for i = 1, #roItemData.extra_data_map do
        local svrData = roItemData.extra_data_map[i]
        local key = svrData.key
        local value = svrData.value
        local selfKey = self.C_SVR_ITEM_EXTRA_DATA_MAP[key]
        if nil ~= selfKey then
            itemData[selfKey] = value
        else
            -- todo 服务器会在这个地方保存一些服务器用到的数据，这些数据不需要客户端进行解析
            -- logError("[ItemRoFactory] invalid key: " .. tostring(key))
        end

        --- 单独设置真实道具的附属ID
        if EItemExtraDataKey.IEDK_Child_ItemID == key then
            itemData.ParentItemConfig = TableUtil.GetItemTable().GetRowByItemID(value, false)
        end
    end

    itemData.ItemCollapseBitMap = roItemData.state_sign
    for key, value in pairs(self.C_SVR_BOOL_MAP) do
        local boolValue = self:_getBitValue(key, roItemData.state_sign)
        itemData[value] = boolValue
    end
end

---@param itemData ItemData
function ItemDataRoItemFactory:_initConfigData(itemData)
    itemData.ItemConfig = TableUtil.GetItemTable().GetRowByItemID(itemData.TID, false)
    itemData.ItemFunctionConfig = TableUtil.GetItemFunctionTable().GetRowByItemId(itemData.TID, true)
    itemData.EquipConfig = TableUtil.GetEquipTable().GetRowById(itemData.TID, true)
    if nil ~= itemData.ItemConfig then
        itemData.ItemConfigLv = itemData.ItemConfig.LevelLimit[0]
    end

    local itemTopConfig = TableUtil.GetItemTopTable().GetRowByItemID(itemData.TID, true)
    if nil ~= itemTopConfig then
        itemData.ItemTopId = itemTopConfig.SortID
    end
end

---@param itemPos number @int16 高4位是容器类型，低12位是位置
---@return number, number
function ItemDataRoItemFactory:_getContTypeAndSlotID(itemPos)
    if GameEnum.ELuaBaseType.Number ~= type(itemPos) then
        logError("[ItemData] init failed")
        return GameEnum.EBagContainerType.None, 0
    end

    local slotID = math.fmod(itemPos, C_BIT_16)
    local type = math.floor(itemPos / C_BIT_16)
    local clientType = Data.BagTypeClientSvrMap:GetClientContType(type)
    return clientType, slotID
end

--- 通过取一个值来获取哪个东西
---@return boolean
function ItemDataRoItemFactory:_getBitValue(key, value)
    if GameEnum.ELuaBaseType.Number ~= type(key) or GameEnum.ELuaBaseType.Number ~= type(value) then
        logError("[itemData] number expected")
        return false
    end

    local ret = ExtensionByQX.MathHelper.IsLogicContainBitWithIndex(value, key)
    return ret
end

--- 为当前道具数据添加属性
---@param itemData ItemData
function ItemDataRoItemFactory:_parseSvrAttrData(roItemData, itemData)
    if nil == roItemData then
        logError("[ItemData] attr parse failed")
        return
    end

    if nil == itemData.EquipConfig then
        self:_parseFromRoItemItemData(roItemData, itemData)
    else
        self:_parseFromRoItemEquipData(roItemData, itemData)
    end
end

---@param roItemData Ro_Item
---@param itemData ItemData
function ItemDataRoItemFactory:_parseFromRoItemItemData(roItemData, itemData)
    if nil == roItemData then
        logError("[ItemData] attr parse failed")
        return
    end

    local deviceAttrs = self:_parseClientAttrData(roItemData, EItemAttrModuleSvrType.Attr_Device)
    local enchantAttrs = self:_parseClientAttrData(roItemData, EItemAttrModuleSvrType.Attr_Enchant)
    local cardAttrs = self:_parseCardItemAttr(roItemData.item_id)
    local gearAttrs = self:_parseClientAttrData(roItemData, EItemAttrModuleSvrType.Attr_Base)
    self:_setGearTableID(gearAttrs)

    local gearCacheAttrs = self:_parseClientAttrData(roItemData, EItemAttrModuleSvrType.Attr_Belluz_Cache)
    self:_setGearTableID(gearCacheAttrs)

    local attrSet = {}
    if GameEnum.EItemType.BelluzGear == itemData.ItemConfig.TypeTab then
        attrSet = {
            [itemAttrModuleType.Enchant] = { [1] = enchantAttrs },
            [itemAttrModuleType.Device] = { [1] = deviceAttrs },
            [itemAttrModuleType.BelluzGear] = { [1] = gearAttrs },
            [itemAttrModuleType.BelluzGearCache] = { [1] = gearCacheAttrs },
        }
    else
        attrSet = {
            [itemAttrModuleType.Enchant] = { [1] = enchantAttrs },
            [itemAttrModuleType.Device] = { [1] = deviceAttrs },
            [itemAttrModuleType.Base] = { [1] = cardAttrs },
        }
    end

    itemData.AttrSet = attrSet
end

---@param roItemData Ro_Item
---@param itemData ItemData
function ItemDataRoItemFactory:_parseFromRoItemEquipData(roItemData, itemData)
    if nil == roItemData then
        logError("[ItemData] attr parse failed")
        return
    end

    local E_REFINE_SVR_TYPE = GameEnum.ERefineSvrID
    itemData.RefineLv = self:_parseRefineLvInfo(roItemData, EItemAttrModuleSvrType.Attr_Refine, E_REFINE_SVR_TYPE.RefineLv)
    itemData.RefineSealLv = self:_parseRefineLvInfo(roItemData, EItemAttrModuleSvrType.Attr_Refine, E_REFINE_SVR_TYPE.RefineSealLv)
    itemData.RefineAdditionalRate = self:_parseRefineLvInfo(roItemData, EItemAttrModuleSvrType.Attr_Refine, E_REFINE_SVR_TYPE.AdditionalRate) * C_NUMBER_PERCENTAGE_VALUE
    itemData.RefineUnlockExp = self:_parseRefineLvInfo(roItemData, EItemAttrModuleSvrType.Attr_Refine, E_REFINE_SVR_TYPE.UnlockExp)
    local deviceAttrs = self:_parseClientAttrData(roItemData, EItemAttrModuleSvrType.Attr_Device)
    local enchantAttrs = self:_parseClientAttrData(roItemData, EItemAttrModuleSvrType.Attr_Enchant)
    local enchantCacheAttrs = self:_parseClientAttrData(roItemData, EItemAttrModuleSvrType.Attr_EnchantCache)
    local enchantCacheHighAttrs = self:_parseClientAttrData(roItemData, EItemAttrModuleSvrType.Attr_EnchantCacheHigh)
    local baseAttrs = self:_parseClientAttrData(roItemData, EItemAttrModuleSvrType.Attr_Base)
    local schoolAttrs = self:_parseClientAttrData(roItemData, EItemAttrModuleSvrType.Attr_School)
    local battleTempAttr = self:_parseBattleTempAttr(roItemData, itemData.EquipConfig)
    --- 策划说精炼的position匹配这个RefineBaseAttributes
    local refineAttrs = self:_parseRefineInfo(itemData.RefineLv, itemData.EquipConfig.RefineBaseAttributes)
    local holeAttrDataSet = {}
    if 0 < itemData.EquipConfig.HoleNum then
        holeAttrDataSet = self:_parseCardAttrs(roItemData, itemData.EquipConfig)
    end

    local maxBaseAttrSet = Data.ItemEquipAttrFactory:GetAttr(GameEnum.EItemAttrModuleType.Base, GameEnum.EAttrValueState.Max, itemData.EquipConfig, itemData:GetEquipTableLv())
    local maxStyleSet = Data.ItemEquipAttrFactory:GetAttr(GameEnum.EItemAttrModuleType.School, GameEnum.EAttrValueState.Max, itemData.EquipConfig, itemData:GetEquipTableLv())
    local sortedBase = self:_reSortAttrList(baseAttrs, maxBaseAttrSet, false, itemData.EquipConfig)
    local sortedStyles = self:_reSortAttrList(schoolAttrs, maxStyleSet, true, itemData.EquipConfig)
    table.ro_insertRange(sortedStyles, battleTempAttr)
    if nil ~= itemData.EquipConfig and 0 < itemData.EquipConfig.AttrType then
        local compareBaseList = Data.ItemEquipAttrFactory:GetAttr(GameEnum.EItemAttrModuleType.Base, GameEnum.EAttrValueState.Rare, itemData.EquipConfig, itemData:GetEquipTableLv())
        local compareStyleList = Data.ItemEquipAttrFactory:GetAttr(GameEnum.EItemAttrModuleType.School, GameEnum.EAttrValueState.Rare, itemData.EquipConfig, itemData:GetEquipTableLv())
        self:_setAttrRare(sortedBase, compareBaseList, itemData.TID)
        self:_setAttrRare(sortedStyles, compareStyleList, itemData.TID)
    end

    local attrSet = {
        [itemAttrModuleType.Base] = { [1] = sortedBase },
        [itemAttrModuleType.School] = { [1] = sortedStyles },
        [itemAttrModuleType.Enchant] = { [1] = enchantAttrs },
        [itemAttrModuleType.EnchantCache] = { [1] = enchantCacheAttrs },
        [itemAttrModuleType.EnchantCacheHigh] = { [1] = enchantCacheHighAttrs },
        [itemAttrModuleType.Device] = { [1] = deviceAttrs },
        [itemAttrModuleType.Refine] = { [1] = refineAttrs },
        --[itemAttrModuleType.RareBase] = { [1] = compareBaseList },
        --[itemAttrModuleType.RareStyle] = { [1] = compareStyleList },
        [itemAttrModuleType.MaxBase] = { [1] = maxBaseAttrSet },
        [itemAttrModuleType.MaxStyle] = { [1] = maxStyleSet },
        [itemAttrModuleType.Card] = {},
        [itemAttrModuleType.CardAttr] = {},
        [itemAttrModuleType.Hole] = {},
        [itemAttrModuleType.HoleCache] = {},
    }

    for i = 1, #holeAttrDataSet do
        attrSet[itemAttrModuleType.Card][i] = holeAttrDataSet[i].Card
        attrSet[itemAttrModuleType.CardAttr][i] = holeAttrDataSet[i].CardAttr
        attrSet[itemAttrModuleType.Hole][i] = holeAttrDataSet[i].HoleAttr
        attrSet[itemAttrModuleType.HoleCache][i] = holeAttrDataSet[i].HoleCacheAttr
    end

    itemData.AttrSet = attrSet
    if 0 < #enchantAttrs then
        itemData.EnchantGrade = self:_getEnchantGradeLV(roItemData)
    end
end

--- 为属性设置稀有状态
---@param attrList ItemAttrData[]
---@param compareAttrList ItemAttrData[]
function ItemDataRoItemFactory:_setAttrRare(attrList, compareAttrList, id)
    if nil == attrList or nil == compareAttrList then
        return
    end

    if #attrList ~= #compareAttrList then
        logError("[RoItemFactory] invalid attr count, item id: " .. tostring(id))
        return
    end

    for i = 1, #attrList do
        local singleAttr = attrList[i]
        local compareAttr = compareAttrList[i]
        if GameEnum.EItemAttrType.Attr ~= singleAttr.AttrType then
            -- todo 这里可能有特定的buff不算做稀有
            singleAttr.RareAttr = true
        else
            singleAttr.RareAttr = singleAttr.AttrValue >= compareAttr.AttrValue
        end
    end
end

function ItemDataRoItemFactory:_genOffsetRate(rate, offset)
    return offset + rate
end

--- 为贝鲁兹核心的属性设置TableID，为了取颜色
---@param itemAttrDataList ItemAttrData[]
function ItemDataRoItemFactory:_setGearTableID(itemAttrDataList)
    if nil == itemAttrDataList then
        return
    end

    for i = 1, #itemAttrDataList do
        local singleAttr = itemAttrDataList[i]
        local singleID = singleAttr.AttrID
        singleAttr.TableID = self:_getWheelSkillID(singleID)
    end
end

--- 获取贝鲁兹核心每一条buff对应的表ID，用来获取颜色
function ItemDataRoItemFactory:_getWheelSkillID(buffID)
    local ret = self._gearConfigMap[buffID]
    if nil == ret then
        logError("[ItemFactory] invalid buff: " .. tostring(buffID))
        return 0
    end

    return ret
end

--- 服务器下发的是封魔石来自哪个装备的TID
function ItemDataRoItemFactory:_parseEnchantStoneEquipPos(itemTID)
    local targetConfig = TableUtil.GetEquipTable().GetRowById(itemTID, true)
    if nil == targetConfig then
        return GameEnum.EEquipSlotType.None
    end

    return targetConfig.EquipId
end

--- 获取附魔等级
function ItemDataRoItemFactory:_parseEnchantItemLv(tid)
    if nil == tid then
        return 0
    end

    local targetConfig = TableUtil.GetItemTable().GetRowByItemID(tid)
    if nil == targetConfig then
        return 0
    end

    local ret = targetConfig.LevelLimit[0]
    return ret
end

---@param roItem Ro_Item
function ItemDataRoItemFactory:_parseEnchantValue(roItem, enchantValueType)
    if nil == roItem then
        logError("[ItemData] attr parse failed")
        return 0
    end

    local filtratedAttrList = self:_getAttrListBySvrType(roItem.attr_list, EItemAttrModuleSvrType.Attr_Enchantstone)
    local filtratedBuffList = self:_getAttrListBySvrType(roItem.buff_list, EItemAttrModuleSvrType.Attr_Enchantstone)
    if nil == filtratedAttrList and nil == filtratedBuffList then
        return 0
    end

    --- 为什么返回空集合而不是nil，因为如果通过GM指令加进来一个封魔石或者置换器
    --- 这个时候是没有属性的，所以默认不反悔空
    if 0 >= #filtratedAttrList + #filtratedBuffList then
        return 0
    end

    local svrList = {}
    table.ro_insertRange(svrList, filtratedAttrList)
    table.ro_insertRange(svrList, filtratedBuffList)
    local value = self:_parseEnchantDetailedValue(svrList, enchantValueType)
    return value
end

--- 遍历属性取值
---@param list Ro_Item_Attr_List[]
function ItemDataRoItemFactory:_parseEnchantDetailedValue(list, valueType)
    for i = 1, #list do
        local singleAttrList = list[i]
        for j = 1, #singleAttrList.attr_or_buff_list do
            local singleAttr = singleAttrList.attr_or_buff_list[j]
            if singleAttr.attr_id == valueType then
                return singleAttr.attr_val
            end
        end
    end

    return 0
end

---@param attrList ItemAttrData[]
---@param targetAttrList ItemAttrData[]
---@param equipConfig EquipTable
---@return ItemAttrData[]
function ItemDataRoItemFactory:_reSortAttrList(attrList, targetAttrList, isStyle, equipConfig)
    if nil == attrList then
        return nil
    end

    if nil == targetAttrList then
        return attrList
    end

    --- 关于流派词条有一个读表顺序
    ---@type ItemAttrData[]
    local ret = {}
    for i = 1, #targetAttrList do
        local singleAttr = targetAttrList[i]
        for j = 1, #attrList do
            local sortAttr = attrList[j]
            if sortAttr.AttrID == singleAttr.AttrID then
                table.remove(attrList, j)
                if isStyle then
                    sortAttr.EquipTextID = equipConfig.EquipText
                    sortAttr.OverrideType = GameEnum.EAttrDescType.EquipTextOne
                    sortAttr.AttrIdx = i
                end

                table.insert(ret, sortAttr)
                break
            end
        end
    end

    return ret
end

---@param roItemData Ro_Item
function ItemDataRoItemFactory:_parseRefineLvInfo(roItemData, attrType, refineLvIdx)
    if nil == roItemData then
        return 0
    end

    local attrList = self:_getAttrListBySvrType(roItemData.attr_list, attrType)
    for i = 1, #attrList do
        for j = 1, #attrList[i].attr_or_buff_list do
            local singleData = attrList[i].attr_or_buff_list[j]
            if refineLvIdx == singleData.attr_id then
                return singleData.attr_val
            end
        end
    end

    return 0
end

---@param roItemData Ro_Item
---@param attrSvrIdx number
---@return ItemAttrData[]
function ItemDataRoItemFactory:_parseClientAttrData(roItemData, attrSvrIdx)
    if nil == roItemData then
        logError("[ItemData] attr parse failed")
        return {}
    end

    local filtratedAttrList = self:_getAttrListBySvrType(roItemData.attr_list, attrSvrIdx)
    local filtratedBuffList = self:_getAttrListBySvrType(roItemData.buff_list, attrSvrIdx)
    if nil == filtratedAttrList and nil == filtratedBuffList then
        return {}
    end

    --- 为什么返回空集合而不是nil，因为如果通过GM指令加进来一个封魔石或者置换器
    --- 这个时候是没有属性的，所以默认不反悔空
    if 0 >= #filtratedAttrList + #filtratedBuffList then
        return {}
    end

    local ret = {}
    local C_ENCHANT_FUNC_HASH = {
        [EItemAttrModuleSvrType.Attr_Enchant] = 1,
        [EItemAttrModuleSvrType.Attr_EnchantCache] = 1,
        [EItemAttrModuleSvrType.Attr_EnchantCacheHigh] = 1,
    }

    local attrList = nil
    local buffList = nil
    if nil ~= C_ENCHANT_FUNC_HASH[attrSvrIdx] then
        attrList = self:_parseEnchantAttrOrBuffData(filtratedAttrList, GameEnum.EItemAttrType.Attr)
        buffList = self:_parseEnchantAttrOrBuffData(filtratedBuffList, GameEnum.EItemAttrType.Buff)
    else
        attrList = self:_parseSvrAttrOrBuffData(filtratedAttrList, GameEnum.EItemAttrType.Attr)
        buffList = self:_parseSvrAttrOrBuffData(filtratedBuffList, GameEnum.EItemAttrType.Buff)
    end

    table.ro_insertRange(ret, buffList)
    table.ro_insertRange(ret, attrList)
    return ret
end

---@param roItem Ro_Item
---@param equipConfig EquipTable
---@return ItemAttrData[]
function ItemDataRoItemFactory:_parseBattleTempAttr(roItem, equipConfig)
    if nil == roItem then
        logError("[RoItemFactory] invalid param")
        return {}
    end

    if nil == equipConfig then
        return {}
    end

    local battleAttrList = roItem.fight_attr_list
    ---@type Ro_Item_Attr_List
    local targetList = nil
    for i = 1, #battleAttrList do
        if EItemAttrModuleSvrType.Attr_School_2 == battleAttrList[i].attrmodletype then
            targetList = battleAttrList[i]
            break
        end
    end

    if nil == targetList then
        return {}
    end

    local ret = {}
    local tableID = targetList.table_id
    for i = 1, #targetList.attr_or_buff_list do
        local singleAttr = targetList.attr_or_buff_list[i]
        ---@type ItemAttrData
        local data = Data.ItemAttrData.new(GameEnum.EItemAttrType.TempAttr, singleAttr.attr_id, singleAttr.attr_val, tableID, nil)
        data.AttrIdx = i
        data.OverrideType = GameEnum.EAttrDescType.EquipTextTwo
        data.EquipTextID = equipConfig.EquipText
        table.insert(ret, data)
    end

    return ret
end

---@param list Ro_Item_Attr_List[]
---@return Ro_Item_Attr_List[]
function ItemDataRoItemFactory:_getAttrListBySvrType(list, svrType)
    if nil == list or nil == svrType then
        logError("[ItemDataROFactory] invalid param")
        return {}
    end

    local ret = {}
    for i = 1, #list do
        if list[i].attrmodletype == svrType then
            table.insert(ret, list[i])
        end
    end

    return ret
end

---@param attrList Ro_Item_Attr_List[]
---@return ItemAttrData[]
function ItemDataRoItemFactory:_parseEnchantAttrOrBuffData(attrList, attrType)
    if nil == attrList then
        return {}
    end

    local attrPairList = {}
    for i = 1, #attrList do
        for j = 1, #attrList[i].attr_or_buff_list do
            local singleData = attrList[i].attr_or_buff_list[j]
            if 0 ~= singleData.attr_id and 0 < #singleData.ro_item_extra_param then
                local tableID = singleData.attr_id
                local attrID = singleData.ro_item_extra_param[1].value
                local attrValue = singleData.attr_val
                local pos = singleData.ro_item_extra_param[1].key
                local itemAttr = Data.ItemAttrData.new(attrType, attrID, attrValue, tableID, nil)

                ---@type EnchantAttrPair
                local singlePair = {
                    pos = pos,
                    attr = itemAttr,
                }

                table.insert(attrPairList, singlePair)
            end
        end
    end

    local ret = self:_sortEnchantAttr(attrPairList)
    return ret
end

---@param a EnchantAttrPair
---@param b EnchantAttrPair
function ItemDataRoItemFactory._sortFunc(a, b)
    return a.pos > b.pos
end

---@param attrWrapList EnchantAttrPair[]
---@return ItemAttrData[]
function ItemDataRoItemFactory:_sortEnchantAttr(attrWrapList)
    if nil == attrWrapList then
        logError("[ItemROFactory] invalid param")
    end

    local ret = {}
    table.sort(attrWrapList, self._sortFunc)
    for i = 1, #attrWrapList do
        local singlePair = attrWrapList[i].attr
        table.insert(ret, singlePair)
    end

    return ret
end

---@param attrList Ro_Item_Attr_List[]
---@return ItemAttrData[]
function ItemDataRoItemFactory:_parseSvrAttrOrBuffData(attrList, attrType)
    if nil == attrList then
        return {}
    end

    local ret = {}
    for i = 1, #attrList do
        for j = 1, #attrList[i].attr_or_buff_list do
            local singleData = attrList[i].attr_or_buff_list[j]

            --- 取洞属性的时候服务器会默认发一个ID为0的表示状态，这个会单独取；
            --- 还有一个ID为1的是服务器自己用的状态，客户端不处理
            if 0 ~= singleData.attr_id and 1 ~= singleData.attr_id then
                local tableID = 0
                if 0 < #singleData.ro_item_extra_param then
                    tableID = singleData.ro_item_extra_param[1].value
                end

                local extraParam = {}
                for k, v in pairs(singleData.ro_item_extra_param) do
                    local singleInputParam = v
                    local singleParam = self:_createExtraParam(singleInputParam.key, singleInputParam.value)
                    table.insert(extraParam, singleParam)
                end

                local itemAttr = Data.ItemAttrData.new(attrType, singleData.attr_id, singleData.attr_val, tableID, extraParam)
                table.insert(ret, itemAttr)
            end
        end
    end

    return ret
end

---@return ItemAttrExtraParam
function ItemDataRoItemFactory:_createExtraParam(key, value)
    local name = self._equipIntStrMap[key]
    if nil == name then
        name = ""
        logError("[RoItemFactory] invalid key: " .. tostring(key))
    end

    local data = Data.ItemAttrExtraParam.new(key, value, GameEnum.EStyleAttrRandType.Static, name)
    return data
end

--- 解析精炼的数据
--- 精炼服务器是不传递参数的，精炼的属性完全是靠读表获取的
---@param refineLv number
---@param equipPos number
---@return ItemAttrData[]
function ItemDataRoItemFactory:_parseRefineInfo(refineLv, equipPos)
    if nil == refineLv or nil == equipPos then
        return {}
    end

    if 0 >= refineLv then
        return {}
    end

    local refineKey = self:_getRefineConfigRef(equipPos, refineLv)
    local tableData = self._refineConfigMap[refineKey]
    if nil == tableData then
        logError("[ItemROFactory] try get refine ref failed, pos: " .. tostring(equipPos) .. " lv: " .. tostring(refineLv))
        return {}
    end

    local ret = {}
    local refineAttrData = tableData.RefineAttr
    for j = 0, refineAttrData.Length - 1 do
        local value = refineAttrData[j][2]
        if 0 < value then
            local attrData = Data.ItemAttrData.new(refineAttrData[j][0], refineAttrData[j][1], value, 0, nil)
            table.insert(ret, attrData)
        end
    end

    return ret
end

---@param roItemData Ro_Item
---@param equipConfig EquipTable
---@return HoleDataSet[]
function ItemDataRoItemFactory:_parseCardAttrs(roItemData, equipConfig)
    --- 这个判断常规情况是不会进来的
    if nil == roItemData then
        local emptyData = {
            HoleAttr = {},
            HoleCacheAttr = {},
            Card = {},
            CardAttr = {},
        }

        local ret = {}
        for i = 1, equipConfig.HoleNum do
            table.insert(ret, emptyData)
        end

        return ret
    end

    local ret = {}
    for i = 1, equipConfig.HoleNum do
        local holeEnum = C_SVR_HOLE_ATTR_IDX_MAP[i]
        local holeCacheEnum = C_SVR_HOLE_CACHE_ATTR_IDX_MAP[i]
        local data = {
            HoleAttr = {},
            HoleCacheAttr = {},
            Card = {},
            CardAttr = {}
        }

        if nil == holeEnum or nil == holeCacheEnum then
            logError("[ItemData] Hole count out of range, count: " .. tostring(equipConfig.HoleNum))
            table.insert(ret, data)
        else
            local holeAttrs = self:_parseClientAttrData(roItemData, holeEnum)
            local holeCacheAttrs = self:_parseClientAttrData(roItemData, holeCacheEnum)
            local cards = {}
            local cardAttrs = {}
            local cardID, expireTime = self:_parseCardIdFromHoleAttr(roItemData, holeEnum)
            local cardConfig = TableUtil.GetEquipCardTable().GetRowByID(cardID, true)
            if nil ~= cardConfig then
                local singleCard = Data.ItemAttrData.new(GameEnum.EItemAttrType.Card, cardID, 0, 0)
                singleCard.ExpireTime = expireTime
                table.insert(cards, singleCard)
                cardAttrs = self:_parseCardItemAttr(cardID)
            end

            data.Card = cards
            data.CardAttr = cardAttrs
            data.HoleAttr = holeAttrs
            data.HoleCacheAttr = holeCacheAttrs
            table.insert(ret, data)
        end
    end

    return ret
end

--- 卡洞属性当中会有一个状态属性标记是不是插卡了
---@param roItemData Ro_Item
---@return number
function ItemDataRoItemFactory:_parseCardIdFromHoleAttr(roItemData, svrIdx)
    local C_HOLE_STATE_ID = 0
    local attrList = self:_getAttrListBySvrType(roItemData.attr_list, svrIdx)
    for i = 1, #attrList do
        for j = 1, #attrList[i].attr_or_buff_list do
            local singleData = attrList[i].attr_or_buff_list[j]
            if C_HOLE_STATE_ID == singleData.attr_id then

                return singleData.attr_val, self:_parseAttrExpireTime(singleData.ro_item_extra_param[5], singleData.ro_item_extra_param[4])
            end
        end
    end
    return 0, 0
end

function ItemDataRoItemFactory:_parseAttrExpireTime(high24Bit, lowBit)
    if high24Bit == nil then
        return 0
    end
    if lowBit == nil then
        return 0
    end
    local high24BitValue = high24Bit.value
    local lowBitValue = lowBit.value
    return high24BitValue * (2 ^ 24) + lowBitValue
end

--- 获取卡片作为道具需要显示的属性
---@param tid number
---@return ItemAttrData[]
function ItemDataRoItemFactory:_parseCardItemAttr(tid)
    if nil == tid then
        return {}
    end

    local cardTableInfo = TableUtil.GetEquipCardTable().GetRowByID(tid, true)
    if nil == cardTableInfo then
        return {}
    end

    local ret = {}
    for i = 0, cardTableInfo.CardAttributes.Length - 1 do
        local attr = Data.ItemAttrData.new(cardTableInfo.CardAttributes[i][0], cardTableInfo.CardAttributes[i][1], cardTableInfo.CardAttributes[i][2])
        table.insert(ret, attr)
    end

    return ret
end

---@param roItem Ro_Item
function ItemDataRoItemFactory:_getEnchantGradeLV(roItem)
    if nil == roItem then
        return 0
    end

    --- 服务器标记附魔档次的ID是3
    local C_INT_ENCHANT_GRADE_ID = 3
    local svrAttrList = roItem.attr_list
    for i = 1, #svrAttrList do
        local singleData = svrAttrList[i]
        if EItemAttrModuleSvrType.Attr_EnchantParam == singleData.attrmodletype then
            for j = 1, #singleData.attr_or_buff_list do
                local singleAttr = singleData.attr_or_buff_list[j]
                if C_INT_ENCHANT_GRADE_ID == singleAttr.attr_id then
                    return singleAttr.attr_val
                end
            end
        end
    end

    return 0
end

return Data.ItemDataRoItemFactory