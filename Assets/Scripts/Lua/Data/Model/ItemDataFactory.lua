require "Data/Model/ItemDataItemPBFactory"
require "Data/Model/ItemDataRoItemFactory"
require "Data/Model/ItemDataLocalFactory"
require "Data/Model/ItemEquipAttrFactory"
require "Data/Model/ItemData"
module("Data", package.seeall)

ItemDataFactory = class("ItemDataFactory")

function ItemDataFactory:ctor()
    local itemCreateType = GameEnum.EItemCreateType
    Data.ItemEquipAttrFactory:Init()
    self._localFactory = Data.ItemDataLocalFactory.new()
    self._itemFactory = Data.ItemDataItemPBFactory.new()
    self._roItemFactory = Data.ItemDataRoItemFactory.new()
    self._createFuncMap = {
        [itemCreateType.Tid] = self._createByTid,
        [itemCreateType.Item] = self._createByItem,
        [itemCreateType.RoItem] = self._createByRoItem,
    }
end

---@param itemData ItemData
---@param createType number
---@return ItemData
function ItemDataFactory:ResetItemByType(itemData, createType, param)
    local func = self._createFuncMap[createType]
    if nil == func then
        logError("[ItemDataFactory] invalid create type: " .. tostring(createType))
    end

    if nil == itemData then
        logError("[ItemFactory] itemData got nil")
        return nil
    end

    itemData:Reset()
    local ret = func(self, param, itemData)
    return ret
end

---@param createType number
---@return ItemData
function ItemDataFactory:CreateItemByTypeParam(createType, param)
    local func = self._createFuncMap[createType]
    if nil == func then
        logError("[ItemDataFactory] invalid create type: " .. tostring(createType))
    end

    local newItem = Data.ItemData.new()
    local ret = func(self, param, newItem)
    return ret
end

--- 根据TID创建道具
---@param tid number
---@param itemData ItemData
---@return ItemData
function ItemDataFactory:_createByTid(tid, itemData)
    return self._localFactory:InitWithTid(tid, itemData)
end

--- 根据PB数据创建道具
---@param itemPb Item
---@param itemData ItemData
---@return ItemData
function ItemDataFactory:_createByItem(itemPb, itemData)
    return self._itemFactory:Init(itemPb, itemData)
end

--- 根据RO_Item PB数据创建道具
---@param roItemPb Ro_Item
---@param itemData ItemData
---@return ItemData
function ItemDataFactory:_createByRoItem(roItemPb, itemData)
    return self._roItemFactory:InitWithROItemData(roItemPb, itemData)
end

return Data.ItemDataFactory