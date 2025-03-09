module("Data", package.seeall)

--- 创建本地数据的缓存，因为有一些需求是需要创建道具数据的，道具数据体量比较大
--- 所以为了避免重复创建我们这个时候创建一个缓存来处理这个问题
--- 目前这个缓存是第一阶段处理的问题，只对本地数据进行一些处理，如果是本地设置的数据这个时候设置了UID，则会被刷掉
--- 现在这个类只是一个雏形，准备在小范围内投入使用
---@class ItemLocalDataCache
ItemLocalDataCache = class("ItemLocalDataCache")

function ItemLocalDataCache:ctor(cacheCapacity)
    ---@type table<number, ItemData[]>
    self._cacheMap = {}
    self._mostTID = 0
    self._capacity = 100
    self._currentItemCount = 0
    if nil ~= cacheCapacity then
        self._capacity = cacheCapacity
    end
end

---@return ItemData
function ItemLocalDataCache:GetItemData(itemID)
    if nil == itemID then
        logError("[ItemCache] invalid id")
        return nil
    end

    if 0 < self._currentItemCount then
        self._currentItemCount = self._currentItemCount - 1
    end

    local ret = self:_tryGetItem(itemID)
    if nil ~= ret then
        return ret
    end

    ret = self:_tryGetItem(self._mostTID)
    if nil ~= ret then
        ret = Data.BagApi:ResetLocalItemData(ret, itemID)
        return ret
    end

    ret = Data.BagApi:CreateLocalItemData(itemID)
    return ret
end

--- 回收对应的数据
---@param itemData ItemData
function ItemLocalDataCache:RecycleItemData(itemData)
    if nil == itemData then
        return
    end

    if self._currentItemCount >= self._capacity then
        return
    end

    if not itemData:IsFakeItem() then
        return
    end

    local targetList = self._cacheMap[itemData:GetInCacheTid()]
    if nil == targetList then
        self._cacheMap[itemData:GetInCacheTid()] = {}
    end

    table.insert(self._cacheMap[itemData:GetInCacheTid()], itemData)
    self._currentItemCount = self._currentItemCount + 1
    if itemData:GetInCacheTid() == self._mostTID then
        return
    end

    local targetCount = self:_getIDCount(itemData:GetInCacheTid())
    local currentMost = self:_getIDCount(self._mostTID)
    if targetCount > currentMost then
        self._mostTID = itemData:GetInCacheTid()
    end
end

--- log当前缓存当中的数据
function ItemLocalDataCache:LogDetail()
    local countMap = {}
    for key, list in pairs(self._cacheMap) do
        countMap[key] = #list
    end

    local logStr = {
        Most = self._mostTID,
        Capacity = self._capacity,
        CurrentCount = self._currentItemCount,
        CountMap = countMap
    }

    logError(ToString(logStr))
end

---@return ItemData
function ItemLocalDataCache:_tryGetItem(itemID)
    if nil == itemID then
        logError("[ItemCache] invalid param")
        return nil
    end

    targetList = self._cacheMap[itemID]
    if nil == targetList or 0 >= #targetList then
        return nil
    end

    local ret = targetList[#targetList]
    table.remove(self._cacheMap[itemID], #targetList)
    if 0 >= #self._cacheMap[itemID] then
        self._cacheMap[itemID] = nil
    end

    --- 如果这个地方获取的不是最多的队列，那不需要更新最多的ID，因为最多的ID当前没有任何变化
    if itemID == self._mostTID then
        self:_resetMost()
    end

    return ret
end

function ItemLocalDataCache:_resetMost()
    local mostTID, mostNum = self:_getMostTid()
    self._mostTID = mostTID
end

function ItemLocalDataCache:_getIDCount(id)
    local targetList = self._cacheMap[id]
    if nil == targetList then
        return 0
    end

    return #targetList
end

function ItemLocalDataCache:_getMostTid()
    local mostNum = 0
    local mostTID = 0
    for key, list in pairs(self._cacheMap) do
        local count = #list
        if count > mostNum then
            mostNum = count
            mostTID = key
        end
    end

    return mostTID, mostNum
end