module("Data", package.seeall)

--- 这个类的职责是管理装备改造有关的数据，主要是负责管理当前选中的道具数据和缓存的道具数据
EquipReformApi = class("EquipReformApi")

function EquipReformApi:ctor()
    ---@type ItemData
    self._currentItem = nil
    ---@type table<number, ItemData>
    self._cacheItemMap = {}
end

function EquipReformApi:Clear()
    self._currentItem = nil
    self._cacheItemMap = {}
end

--- 获取当前正在被选中的道具数据
---@return ItemData
function EquipReformApi:GetCurrentSelectItem()
    return self._currentItem
end

--- 设置当前被选中的道具数据
---@param itemData ItemData
function EquipReformApi:SetCurrentSelectItem(itemData)
    self._currentItem = itemData
end

--- 更新缓存数据，用来显示对比的
---@param itemData ItemData
function EquipReformApi:UpdateCache(itemData)
    if nil == itemData then
        return
    end

    self._cacheItemMap[itemData.UID] = itemData
end

--- 获取缓存的属性对比数据
---@return ItemData
function EquipReformApi:GetCacheDataByUid(uid)
    return self._cacheItemMap[uid]
end