--- 这个类是道具系统的取数据接口集合
require "Data/Model/BagApi"
require "Data/Model/BagModel"

---@module ModuleMgr.BagMgr
module("ModuleMgr.BagMgr", package.seeall)

local gameEventMgr = MgrProxy:GetGameEventMgr()
local itemContType = GameEnum.EBagContainerType
local baseLuaType = GameEnum.ELuaBaseType
local pageIdxType = GameEnum.EBagPageIdxType
local itemType = GameEnum.EItemType

--- 背包页签对应获取道具类型的映射表
local C_PAGE_CONDITION_MAP = {
    [pageIdxType.Default] = itemType.None,
    [pageIdxType.Equip] = itemType.Equip,
    [pageIdxType.Consume] = itemType.Consume,
    [pageIdxType.Mat] = itemType.Mat,
    [pageIdxType.Card] = itemType.Card,
}

C_INVALID_IDX = -1

--- 当出售物品的时候需要从背包复制一份数据出来，操作的过程中是对这个副本当中的数据进行修改
--- 这个数据现在保存在背包系统的管理类当中
--- 这个类型的结构是槽位对应道具数据
---@type table<number, SellData>
_sellBagCacheData = {}

--- 标记脏数据，如果玩家一顿操作，但是没确定，副本当中的数据已经变了，则要重新拉数据
--- 如果道具数据发生了变化，则要重新拉数据
_dirty = false

--- 背包页的脏标记映射
---@type table<number, boolean>
_bagResetMap = {}

--- 商店的脏标记映射
---@type table<number, boolean>
_shopResetMap = {}

--- 仓库变更的缓存数据
---@type table<number, boolean>
_wareHouseResetMap = {}

---@type boolean
_cartDirtyFlag = false

--- 背包页的缓存数据，在数据发生变化的时候页面会发生更新
--- 原因是
---@type table<number, ItemData[]>
_bagPageCache = {}

--- 商店页的数据缓存
---@type table<number, ItemData[]>
_shopPageCache = {}

---@type table<number, ItemData[]>
_wareHousePageCache = {}

---@type ItemData[]
_cartCache = {}

function OnInit()
    gameEventMgr.Register(gameEventMgr.OnBagSync, _onBagSync, nil)
    gameEventMgr.Register(gameEventMgr.OnBagUpdate, _onBagUpdate, nil)
end

function OnLogout()
    _dirty = false
    _sellBagCacheData = {}
    _clearAllResetTags()
    _clearAllCacheData()
end

---@param idx number
---@param itemData ItemData
---@param count number
function SetCopyByIdx(idx, itemData, count)
    if baseLuaType.Number ~= type(idx) then
        logError("[BagMgr] invalid param, set failed")
        return
    end

    _dirty = true
    _shopResetMap = {}
    if nil == itemData then
        table.remove(_sellBagCacheData, idx)
        return
    end

    ---@type ItemData
    local copiedItemData = table.ro_deepCopy(itemData)
    copiedItemData.ItemCount = count
    local newData = {
        propInfo = copiedItemData,
        count = count
    }

    table.insert(_sellBagCacheData, 1, newData)
end

---@return number
function GetIdxByUID(uid)
    if nil == uid then
        return C_INVALID_IDX
    end

    for key, sellData in pairs(_sellBagCacheData) do
        if sellData.propInfo.UID:equals(uid) then
            return key
        end
    end

    return C_INVALID_IDX
end

---@return SellData
function GetCopyByIdx(idx)
    if baseLuaType.Number ~= type(idx) then
        logError("[BagMgr] invalid param, get failed")
        return nil
    end

    return _sellBagCacheData[idx]
end

--- 参数为是否保留缓存数据
---@param reserveCopy boolean
---@return table<number, SellData>
function GetCopies(reserveCopy)
    return _getCopies(reserveCopy)
end

--- 目前是排序在用
function ForceSetDirty()
    _dirty = true
    _clearAllResetTags()
end

--- 这个接口目前是混用的，背包系统显示的数据是从这个接口取的
--- 如果是出售界面就从缓存当中取数据，如果不是缓存数据就从背包中取数据
---@return ItemData[], number[]
function GetFiltrateItemsInBag()
    local currentToggleIdx = Data.BagModel:GetCurrentBagPageIdx()
    if baseLuaType.Number ~= type(currentToggleIdx) then
        logError("[BagMgr] Invalid Param type: " .. type(currentToggleIdx))
        return {}
    end

    local cacheMap = nil
    local resetTagMap = nil
    if Data.BagModel.OpenModel.Sale == Data.BagModel:getOpenModel() then
        cacheMap = _shopPageCache
        resetTagMap = _shopResetMap
    else
        cacheMap = _bagPageCache
        resetTagMap = _bagResetMap
    end

    local pageResetDone = resetTagMap[currentToggleIdx]
    if pageResetDone then
        return cacheMap[currentToggleIdx]
    end

    cacheMap[currentToggleIdx] = _resetAllCacheData(currentToggleIdx)
    resetTagMap[currentToggleIdx] = true
    return cacheMap[currentToggleIdx]
end

function GetCartItemCount()
    return #_cartCache
end

--- 获取手推车和仓库页中的所有道具
---@return ItemData[]
function GetWareHousePageItemList()
    if Data.BagModel:getOpenModel() == Data.BagModel.OpenModel.Car then
        if _cartDirtyFlag then
            _cartCache = _getAllItemsByContType(itemContType.Cart)
        end

        return _cartCache
    end

    --- 获取当前仓库页的编号
    local currentWareHousePage = Data.BagModel:getPotId()
    local targetContType = Data.BagTypeClientSvrMap:GetWareHouseContTypeByIdx(currentWareHousePage)
    if Data.BagTypeClientSvrMap:GetInvalidSvrType() == targetContType then
        return
    end

    local pageDirty = _wareHouseResetMap[targetContType]
    if pageDirty then
        return _wareHousePageCache[targetContType]
    end

    _wareHouseResetMap[targetContType] = true
    _wareHousePageCache[targetContType] = _getAllItemsByContType(targetContType)
    return _wareHousePageCache[targetContType]
end

-- 红点检测
function CheckRedSignMethod()
    local l_onceSystemMgr = MgrMgr:GetMgr("OnceSystemMgr")
    local l_flag = not l_onceSystemMgr.GetOnceState(l_onceSystemMgr.EClientOnceType.PotionSettingItem)
            and Data.BagModel:GetBagItemCountByTid(MgrMgr:GetMgr("PropMgr").PotionSettingItemId) > 0
    return l_flag and 1 or 0
end

--- 参数为是否保留缓存数据
---@param reserveCopy boolean
---@return table<number, SellData>
function _getCopies(reserveCopy)
    if not reserveCopy then
        _shopResetMap = {}
        return _refreshCopies()
    end

    return _sellBagCacheData
end

--- 副本数据，如果标记脏了则要重新获取
---@return table<number, SellData>
function _refreshCopies()
    if not _dirty then
        return _sellBagCacheData
    end

    _resetCopies()
    return _sellBagCacheData
end

--- 重新拉背包当中的全部数据
--- 当前是没有跨格子概念的，所以可以直接这么取，如果有跨格子概念这边就要改
function _resetCopies()
    _sellBagCacheData = {}
    local types = { itemContType.Bag }
    local bagItems = Data.BagApi:GetItemsByTypesAndConds(types, nil)
    for i = 1, #bagItems do
        local slotItem = Data.BagApi:GetItemByTypeSlot(itemContType.Bag, i)
        if nil ~= slotItem then
            _sellBagCacheData[i] = {
                propInfo = table.ro_deepCopy(slotItem),
                count = slotItem.ItemCount
            }
        end
    end

    _dirty = false
end

--- 背包同步的数据，用来标脏
function _onBagSync()
    _dirty = true
    _clearAllResetTags()
end

--- 接消息
---@param msg ItemUpdateData[]
function _onBagUpdate(msg)
    if baseLuaType.Table ~= type(msg) then
        logError("[BagMgr] invalid param")
        return
    end

    local C_VALID_CONT_MAP = {
        [itemContType.Bag] = 1,
        [itemContType.Cart] = 1,
        [itemContType.WareHousePage_1] = 1,
        [itemContType.WareHousePage_2] = 1,
        [itemContType.WareHousePage_3] = 1,
        [itemContType.WareHousePage_4] = 1,
        [itemContType.WareHousePage_5] = 1,
        [itemContType.WareHousePage_6] = 1,
        [itemContType.WareHousePage_7] = 1,
        [itemContType.WareHousePage_8] = 1,
        [itemContType.WareHousePage_9] = 1,
    }

    for i = 1, #msg do
        local oldContType = msg[i].OldContType
        local newContType = msg[i].NewContType
        if nil ~= C_VALID_CONT_MAP[oldContType] or nil ~= C_VALID_CONT_MAP[newContType] then
            _dirty = true
            _clearAllResetTags()
            return
        end
    end
end

--- 因为页面调用的关系，每一帧会根据道具数量来调用数据接口，所以不能总是对页面进行遍历
--- 重置所有的缓存数据
---@return ItemData[]
function _resetAllCacheData(currentToggleIdx)
    local targetItemType = C_PAGE_CONDITION_MAP[currentToggleIdx]
    if nil == targetItemType then
        logError("[BagMgr] invalid page idx: " .. tostring(currentToggleIdx))
        return {}
    end

    local types = { itemContType.Bag }
    local itemFuncUtil = MgrProxy:GetItemDataFuncUtil()
    ---@type FiltrateCond
    local condition = { Cond = itemFuncUtil.ItemMatchesTypes, Param = { targetItemType } }
    local conditions = { condition }
    if itemType.None == targetItemType then
        conditions = nil
    end

    local items = {}
    if Data.BagModel.OpenModel.Sale == Data.BagModel:getOpenModel() then
        local allItems = _getCopies(true)
        local itemFilter = MgrProxy:GetItemFilter()
        local targetItems = _getAllItemsFromCacheData(allItems)
        items = itemFilter.FiltrateItemData(targetItems, conditions)
        return items
    else
        items = Data.BagApi:GetItemsByTypesAndConds(types, conditions)
        return items
    end

    return {}
end

---@param cacheData table<number, SellData>
---@return ItemData[]
function _getAllItemsFromCacheData(cacheData)
    if nil == cacheData then
        logError("[BagMgr] Invalid Param, cache data got nil")
        return {}
    end

    local ret = {}

    --- 为什么要复制，因为itemTips当中会读ItemCount用来显示数量，我们不能修改ItemData，所以要复制一个
    for key, value in pairs(cacheData) do
        ---@type ItemData
        local itemData = (value.propInfo)
        itemData.ItemCount = value.count
        table.insert(ret, itemData)
    end

    return ret
end

--- 清空所有的脏标记
--- 在道具数据变更的时候调用
function _clearAllResetTags()
    _clearRightPageTags()
    _clearLeftPageTags()
end

function _clearLeftPageTags()
    _wareHouseResetMap = {}
    _cartDirtyFlag = true
end

function _clearRightPageTags()
    _bagResetMap = {}
    _shopResetMap = {}
end

--- 推出登陆的时候清空所有的数据
function _clearAllCacheData()
    _clearLeftPageTags()
    _clearRightPageTags()
end

function _clearLeftPageCache()
    _wareHousePageCache = {}
    _cartCache = {}
end

function _clearRightPageCache()
    _bagPageCache = {}
    _shopPageCache = {}
end

--- 获取手推车里的全部道具
---@return ItemData[]
function _getAllItemsByContType(contType)
    local types = { contType }
    local items = Data.BagApi:GetItemsByTypesAndConds(types, nil)
    return items
end

return ModuleMgr.BagMgr