-- 一个静态模块，用于过滤继承功能需要的装备和道具数据
---@module ModuleMgr.PlayerItemFilter
module("ModuleMgr.PlayerItemFilter", package.seeall)

-- 按照条件来获取玩家背包中的装备
-- 这个参数是一个两个键值对，否则解析会出错误
-- 结构 { cond = function, param = dataWrap}
function GetItemsByCond(condMap)
    local allItems = _getItemsInBag()
    if nil == allItems then
        logError("[ItemFilter] player items got nil. plis check")
        return {}
    end

    -- 返回的道具列表
    return _filtrateItemData(allItems, condMap)
end

--- 获取背包中的道具
---@return ItemData[]
function _getItemsInBag()
    local types = { GameEnum.EBagContainerType.Bag }
    local items = Data.BagApi:GetItemsByTypesAndConds(types, nil)
    return items
end

-- 对给定的列表进行过滤
function FiltrateItemData(itemTable, condMap)
    return _filtrateItemData(itemTable, condMap)
end

function _filtrateItemData(itemTable, condMap)
    if not itemTable then
        return {}
    end

    -- 遍历条件列表
    local ret = {}
    for i = 1, #itemTable do
        local singleItem = itemTable[i]
        local cond = _isCondSatisfied(condMap, singleItem)
        if cond then
            table.insert(ret, singleItem)
        end
    end
    return ret
end

-- 道具是否满足条件，利用lua本身的特性来完成表驱动道具过滤
function _isCondSatisfied(condMap, itemData)
    if nil == itemData then
        logError("[ItemFilter] item must not be nil")
        return false
    end

    if nil == condMap then
        return true;
    end

    -- 这里判断是一个短路逻辑，如果有一个条件没有满足，就说明这个条件不满足
    for i = 1, #condMap do
        local l_singleCond = condMap[i]
        if l_singleCond then
            local l_condFunc = l_singleCond.cond
            local l_param = l_singleCond.param
            local result = l_condFunc(itemData, l_param)
            if not result then
                return false
            end
        end
    end

    return true
end

-- 条件：物品UID是否满足
---@param itemData ItemData
function IsItemUID(itemData, param)
    if nil == itemData or nil == param then
        return false
    end
    return itemData.UID == param
end

-- 条件：物品ID是否满足
---@param itemData ItemData
function IsItemTID(itemData, param)
    if nil == itemData or nil == param then
        return false
    end

    return itemData.TID == param
end

-- 条件：是否是指定部位的装备
-- 这里有一个问题，服务器保存的枚举是装备具体的槽位，配置当中的类型是装备类型
-- 比如有左右饰品槽位的概念，但是左右饰品配置上类型是相同的
---@param itemData ItemData
function IsEquipInCertainSlot(itemData, param)
    if nil == itemData or nil == param then
        return false
    end

    local l_rowEquipTable = itemData.EquipConfig
    if nil == l_rowEquipTable then
        logError("[EquipFilter] equip id:" .. tostring(itemData.TID) .. " not found")
        return false
    end

    return l_rowEquipTable.EquipId == param
end

--- 是否已经损坏了，参数判断的是已经损坏了
---@param itemData ItemData
---@param damaged boolean
---@return boolean
function EquipDamaged(itemData, damaged)
    if nil == itemData or nil == damaged then
        return false
    end

    return itemData.Damaged == damaged
end

--- 是否能被附魔，参数判断的是能被附魔
------@param itemData ItemData
-----@param param boolean
-----@return boolean
function EquipCanBeEnchanted(itemData, param)
    if nil == itemData or nil == param then
        return false
    end

    if nil == itemData.EquipConfig then
        return false
    end

    local canBeEnchanted = itemData.EquipConfig.EnchantingId > 0
    return canBeEnchanted == param
end

---@param itemData ItemData
function EquipEnchantExtracted(itemData, param)
    if nil == itemData then

    end

    return itemData.EnchantExtracted == param
end

return ModuleMgr.PlayerItemFilter