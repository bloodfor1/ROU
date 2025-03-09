--- 用于保存一些过滤道具数据的条件方法

---@module ModuleMgr.ItemDataFuncUtil
module("ModuleMgr.ItemDataFuncUtil", package.seeall)

On_Test = "sdfsdf"
C_ITEM_FUNC_UTIL_EQUIP_ID_MAP = {
    [GameEnum.EEquipSlotType.Weapon] = 1,
    [GameEnum.EEquipSlotType.BackUpHand] = 1,
    [GameEnum.EEquipSlotType.Armor] = 1,
    [GameEnum.EEquipSlotType.Cape] = 1,
    [GameEnum.EEquipSlotType.Boot] = 1,
    [GameEnum.EEquipSlotType.Accessory] = 1,
    [GameEnum.EEquipSlotType.HeadWear] = 1,
    [GameEnum.EEquipSlotType.FaceGear] = 1,
    [GameEnum.EEquipSlotType.MouthGear] = 1,
    [GameEnum.EEquipSlotType.BackGear] = 1,
    [GameEnum.EEquipSlotType.Vehicle] = 1,
}

---@param item ItemData
---@param param boolean
function ItemHasModel(item, param)
    if nil == item or nil == param then
        return false
    end

    if nil == item.EquipConfig then
        return false
    end

    local hasModel = item.EquipConfig.Model ~= nil
    return hasModel == param
end

---@param item ItemData
---@param param number
---@return boolean
function IsItemUID(item, param)
    if nil == item or nil == param then
        return false
    end

    return item.UID:equals(param)
end

---@param item ItemData
---@param param number
---@return boolean
function ItemMatchesTid(item, param)
    if nil == item or nil == param then
        return false
    end

    return item.TID == param
end

---@param item ItemData
---@param typeList number[]
---@return boolean
function ItemMatchesTypes(item, typeList)
    if nil == item or nil == typeList then
        return false
    end

    for i = 1, #typeList do
        local singleType = typeList[i]
        if singleType == item.ItemConfig.TypeTab then
            return true
        end
    end

    return false
end

---@param item ItemData
function ItemMatchesSlot(item, slot)
    if GameEnum.ELuaBaseType.Table ~= type(item) or GameEnum.ELuaBaseType.Number ~= type(slot) then
        return false
    end

    local equipConfig = item.EquipConfig
    if nil == equipConfig then
        return false
    end

    return equipConfig.EquipId == slot
end

---@param item ItemData
function ItemMatchesEquipID(item, equipID)
    if GameEnum.ELuaBaseType.Number ~= type(equipID) then
        logError("[ItemFuncUtil] invalid param")
        return false
    end

    if nil == item then
        return false
    end

    if nil == item.EquipConfig then
        return false
    end

    return item.EquipConfig.EquipId == equipID
end

---@param item ItemData
---@param startEndPair RangePair
function ItemWithinSvrSlotRange(item, startEndPair)
    if nil == startEndPair then
        logError("[ItemFuncUtil] invalid param")
        return false
    end

    local ret = item.SvrSlot >= startEndPair.startPos and item.SvrSlot <= startEndPair.endPos
    return ret
end

---@param itemData ItemData
function ItemLvAbove(itemData, lv)
    if nil == itemData or nil == lv then
        return false
    end

    local locLv = itemData:GetEquipTableLv()
    return locLv >= lv
end

---@Description:匹配有使用次数限制的道具
---@param itemData ItemData
function ItemMatchesUseCountType(itemData, useCountTypes)
    if itemData == nil or useCountTypes == nil or not itemData:ItemMatchesType(GameEnum.EItemType.CountLimit) then
        return false
    end

    local l_itemUseCountItem = TableUtil.GetItemUseCountTable().GetRowByItemID(itemData.ItemConfig.ItemID)
    if MLuaCommonHelper.IsNull(l_itemUseCountItem) then
        return false
    end

    return table.ro_contains(useCountTypes, l_itemUseCountItem.Subclass)
end

---@param item ItemData
---@param param number[]
---@return boolean
function ItemMatchesMultiTid(item, param)
    if nil == item or nil == param then
        return false
    end
    for i = 1, #param do
        if item.TID == param[i] then
            return true
        end
    end
    return false
end

---@Description:道具是否能够用来合成
---@param itemData ItemData
function IsItemCanCompound(itemData)
    local l_canCompound = false
    if itemData == nil then
        return l_canCompound
    end

    if itemData:ItemMatchesType(GameEnum.EItemType.CountLimit) then
        l_canCompound = itemData.CardTotalUseCount == 0
    else
        l_canCompound = true
    end

    return l_canCompound
end

---@param itemData ItemData
function ItemNotUID(itemData, uid)
    if nil == itemData then
        return false
    end

    return not uint64.equals(itemData.UID, uid)
end

---@param itemData ItemData
function ItemWithinEquipIDMap(itemData)
    if nil == itemData then
        return false
    end

    if nil == itemData.EquipConfig then
        return false
    end

    return nil ~= C_ITEM_FUNC_UTIL_EQUIP_ID_MAP[itemData.EquipConfig.EquipId]
end

return ModuleMgr.ItemDataFuncUtil