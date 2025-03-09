require "Data/Model/ItemContainerData"
require "Data/Model/ItemObjMgr"
require "Data/Model/ItemUpdateData"
require "Data/Model/ItemDataFactory"
require "Data/Model/ItemValidator"
require "Data/Model/ItemTidCountMap"
require "Data/Model/BagTypeClientSvrMap"
require "Data/Model/ItemLocalDataCache"

module("Data", package.seeall)
BagApi = class("BagApi")

local luaBaseType = GameEnum.ELuaBaseType
---@type ModuleMgr.ItemFilter
local itemFilter = MgrMgr:GetMgr("ItemFilter")
--- 计算道具槽位用的是bit位进行运算的
local C_BIT_16 = 65536
local contType = GameEnum.EBagContainerType
local C_INVALID_UID = 0
--- 缓存位
local C_CACHE_EQUIP_SLOT_IDX = 1000

--- 服务器使用的默认值
local C_DEFAULT_SVR_VALUE = -1

function BagApi:Init()
    self._itemPool = Data.ItemObjMgr.new()
    self._itemContainer = Data.BagContainerData.new()
    self._itemFactory = Data.ItemDataFactory.new()
    self._itemValidator = Data.ItemValidator.new()
    self._itemTidCountMap = Data.ItemTidCountMap.new()

    --- 这个是一个有关自动排序的枚举
    --- 因为装备页是不需要自动排序指定格子数的
    --- 但是背包等等的容器时需要自动排序的
    --- 仓库是需要单个页上进行自动排序
    self.C_CONTAINER_UPDATE_FUNC = {
        [contType.Bag] = self._autoFillWithFixedSlot,
        [contType.Equip] = self._reserveCurrent,
        [contType.ShortCut] = self._reserveCurrent,
        [contType.Wardrobe] = self._autoFill,
        [contType.Merchant] = self._autoFill,
        [contType.Cart] = self._autoFill,
        [contType.VirtualItem] = self._autoFill,
        [contType.HeadIcon] = self._autoFill,
        [contType.LifeProfession] = self._autoFill,
        [contType.Title] = self._autoFill,
        [contType.TitleUsing] = self._autoFill,
        [contType.WareHousePage_1] = self._autoFill,
        [contType.WareHousePage_2] = self._autoFill,
        [contType.WareHousePage_3] = self._autoFill,
        [contType.WareHousePage_4] = self._autoFill,
        [contType.WareHousePage_5] = self._autoFill,
        [contType.WareHousePage_6] = self._autoFill,
        [contType.WareHousePage_7] = self._autoFill,
        [contType.WareHousePage_8] = self._autoFill,
        [contType.WareHousePage_9] = self._autoFill,
        [contType.BeiluzCore] = self._reserveCurrent,
        [contType.PlayerCustom] = self._reserveCurrent,
    }

    --- 配置表的逻辑是，如果没有包含在这个表当中说明不需要整理
    --- 所以即便调用函数也不会进行排序
    --- 如果包含，怎会触发排序算法
    self.C_CONTAINER_SORT_FUNC = {
        [contType.Bag] = self._bagSort,
        [contType.Merchant] = self._directSort,
        [contType.Cart] = self._directSort,
        [contType.WareHousePage_1] = self._directSort,
        [contType.WareHousePage_2] = self._directSort,
        [contType.WareHousePage_3] = self._directSort,
        [contType.WareHousePage_4] = self._directSort,
        [contType.WareHousePage_5] = self._directSort,
        [contType.WareHousePage_6] = self._directSort,
        [contType.WareHousePage_7] = self._directSort,
        [contType.WareHousePage_8] = self._directSort,
        [contType.WareHousePage_9] = self._directSort,
    }
end

function BagApi:Clear()
    self._itemContainer:Clear()
    self._itemPool:Clear()
    self._itemTidCountMap:Clear()
end

--- 请求交换道具位置
--- todo 现在快速使用的编号其实是有问题的，应该整体减一
---@param uid number
---@param targetClientType number @这个地方参数是客户端类型，不允许传服务器类型
---@param slotIdx number @指定槽位，如果不传会默认置为-1，服务器会自动对齐位置
---@param itemCount number @需要发送的数量，如果是-1认为全量发送，如果是空会默认置为-1
function BagApi:ReqSwapItem(uid, targetClientType, slotIdx, itemCount)
    if nil == uid or luaBaseType.Number ~= type(targetClientType) then
        logError("[BagApi] invalid param")
        return
    end

    if nil == slotIdx then
        slotIdx = C_DEFAULT_SVR_VALUE
    end

    if nil == itemCount then
        itemCount = C_DEFAULT_SVR_VALUE
    end

    --- 向服务器发送请求之前客户端会做自己的拦截和验证
    local itemData = self._itemPool:GetItemData(uid)
    -- todo 这个东西应该是放在上一层，因为验证器当中会调用bagApi当中的方法
    local clientErrorCode = self._itemValidator:ValidateItem(itemData, targetClientType, slotIdx, itemCount)
    if GameEnum.EClientErrorCode.Success ~= clientErrorCode then
        return
    end

    local msgId = Network.Define.Ptc.SwapItem
    ---@type SwapItemPos
    local sendInfo = GetProtoBufSendTable("SwapItemPos")
    sendInfo.itemuid = tostring(uid)
    sendInfo.pos_type = Data.BagTypeClientSvrMap:GetSvrContType(targetClientType)
    if Data.BagTypeClientSvrMap:GetInvalidSvrType() == sendInfo.pos_type then
        logError("[BagApi] invalid client target type: " .. tostring(targetClientType) .. " send ptc failed")
        return
    end

    sendInfo.pos_index = slotIdx
    sendInfo.item_count = tostring(itemCount)
    Network.Handler.SendPtc(msgId, sendInfo)
end

---@param uid uint64
function BagApi:GetItemByUID(uid)
    if nil == uid then
        logError("[BagApi] invalid param")
        return nil
    end

    local ret = self._itemPool:GetItemData(uid)
    return ret
end

--- 根据容器类型列表和条件来对指定的道具进行过滤
---@param containerTypes number[]
---@param conditions FiltrateCond[]
---@return ItemData[]
function BagApi:GetItemsByTypesAndConds(containerTypes, conditions)
    if luaBaseType.Table ~= type(containerTypes) then
        logError("[BagApi] invalid container types")
        return {}
    end

    local paramList = {}
    for i = 1, #containerTypes do
        local singleType = containerTypes[i]
        local subTypeList = Data.BagTypeClientSvrMap:GetSubContTypeList(singleType)
        if nil == subTypeList then
            table.insert(paramList, singleType)
        else
            for j = 1, #subTypeList do
                local singleSubId = subTypeList[j]
                table.insert(paramList, singleSubId)
            end
        end
    end

    return self:_getItemsByTypesAndConds(paramList, conditions)
end

--- 根据容器类型和格子来获取指定道具的数据
---@param containerType number
---@param slotIdx number
---@return ItemData
function BagApi:GetItemByTypeSlot(containerType, slotIdx)
    if luaBaseType.Number ~= type(containerType) or luaBaseType.Number ~= type(slotIdx) then
        logError("[BagApi] invalid param")
        return nil
    end

    local singleUID = self._itemContainer:GetItemUIDByIndex(containerType, slotIdx)
    local item = self._itemPool:GetItemData(singleUID)
    return item
end

--- 获取单个tid的道具数量
---@param containerList number[]
---@param tid number
---@return int64
function BagApi:GetItemCountByContListAndTid(containerList, tid)
    local ret = ToInt64(0)
    local paramList = {}
    for i = 1, #containerList do
        local singleType = containerList[i]
        local subTypeList = Data.BagTypeClientSvrMap:GetSubContTypeList(singleType)
        if nil == subTypeList then
            table.insert(paramList, singleType)
        else
            for j = 1, #subTypeList do
                local singleSubId = subTypeList[j]
                table.insert(paramList, singleSubId)
            end
        end
    end

    for i = 1, #paramList do
        local singleContainerType = paramList[i]
        local itemCount = self._itemTidCountMap:GetItemCountByContTid(singleContainerType, tid)
        ret = ret + itemCount
    end

    return ret
end

--- 排序，排序主要是对位置的映射表进行更新
---@param containerType number
---@return void
function BagApi:Sort(containerType)
    if luaBaseType.Number ~= type(containerType) then
        logError("[BagApi] invalid param")
        return
    end

    local sortFunc = self.C_CONTAINER_SORT_FUNC[containerType]
    if nil == sortFunc then
        logError("[BagApi] container type matches no sort func, container type: " .. tostring(containerType))
        return
    end

    local targetMap = self:_createSlotItemMap(containerType)
    local slotUidMap = sortFunc(self, targetMap)
    local newSlotMap = {}
    for slot, itemDataUID in pairs(slotUidMap) do
        newSlotMap[slot] = itemDataUID
    end

    self._itemContainer:SetContainerData(containerType, newSlotMap)
end

---@return number, number
function BagApi:GetItemContSlot(uid, targetContainer)
    return self._itemContainer:GetUIDContainer(uid, targetContainer)
end

---@param roItem Ro_Item
---@return ItemData
function BagApi:CreateFromRoItemData(roItem)
    if nil == roItem then
        logError("[BagModel] item PB Data got nil")
        return nil
    end

    local newItem = self._itemFactory:CreateItemByTypeParam(GameEnum.EItemCreateType.RoItem, roItem)
    return newItem
end

--- 外部方法，创建本地道具数据
---@param itemPBData Item
---@return ItemData
function BagApi:CreateSvrItemData(itemPBData)
    if nil == itemPBData then
        logError("[BagModel] item PB Data got nil")
        return nil
    end

    local newItem = self._itemFactory:CreateItemByTypeParam(GameEnum.EItemCreateType.Item, itemPBData)
    return newItem
end

---@param tid number
---@return ItemData
function BagApi:CreateLocalItemData(tid)
    if luaBaseType.Number ~= type(tid) then
        logError("[BagApi] invalid item tid type: " .. type(tid))
        return nil
    end

    local newItem = self._itemFactory:CreateItemByTypeParam(GameEnum.EItemCreateType.Tid, tid)
    return newItem
end

--- 重置道具数据，这个方法使用需要非常注意
---@param itemData ItemData
---@return ItemData
function BagApi:ResetLocalItemData(itemData, tid)
    if nil == tid then
        return nil
    end

    if nil == itemData then
        local newItem = self._itemFactory:CreateItemByTypeParam(GameEnum.EItemCreateType.Tid, tid)
        return newItem
    end

    itemData:Reset()
    local ret = self._itemFactory:ResetItemByType(itemData, GameEnum.EItemCreateType.Tid, tid)
    return ret
end

--- 对单个数据进行更新，这数据可能是更新也可能是添加，具体情况需要具体判定
---@param itemPb Ro_Item
---@return ItemUpdateData
function BagApi:UpdateSingleItem(itemPb, targetContainerType, slotID, reason, updateExtraData)
    if luaBaseType.Table ~= type(itemPb)
            or luaBaseType.Number ~= type(targetContainerType)
            or luaBaseType.Number ~= type(slotID) then
        logError("[BagApi] invalid param")
        return nil, nil
    end

    local containerTypeValid = Data.BagTypeClientSvrMap:IsContActive(targetContainerType)
    if not containerTypeValid then
        logError("[BagApi] invalid container type: " .. tostring(containerTypeValid))
        return nil
    end

    local ret = self:_updateSingleItemByOriNetData(itemPb, targetContainerType, slotID, reason, updateExtraData)
    return ret
end

---@param itemPb Ro_Item
---@param containerType number
---@param slotIdx number
---@return ItemUpdateData
function BagApi:_updateSingleItemByOriNetData(itemPb, containerType, slotIdx, reason, extraData)
    if luaBaseType.Table ~= type(itemPb)
            or nil == containerType
    then
        logError("[BagApi] invalid param")
        return nil, nil
    end

    local itemUpdateData = Data.ItemUpdateData.new()
    itemUpdateData.OldItem = nil
    itemUpdateData.NewItem = nil
    itemUpdateData.OldContType = contType.None
    itemUpdateData.NewContType = contType.None
    itemUpdateData.Reason = reason
    itemUpdateData.ExtraData = extraData

    ---@type ItemData
    local oldItem = nil
    ---@type ItemData
    local newItem = nil

    --- UID PB3 的问题，直接作为string处理s
    local uid = itemPb.uid
    local targetContainerType = containerType
    local slotID = slotIdx
    local oldItemData = self._itemPool:GetItemData(uid)

    if tostring(uid) == tostring(C_INVALID_UID) then
        logError("container type: " .. tostring(containerType) .. " slot id: " .. tostring(slotIdx))
        return nil
    end

    if nil == oldItemData then
        local itemData = self._itemFactory:CreateItemByTypeParam(GameEnum.EItemCreateType.RoItem, itemPb)
        if nil == itemData then
            logError("[BagApi] error occurred during creating item data, plis check")
            return nil
        end

        itemData.ContainerType = targetContainerType
        newItem = itemData
        self._itemPool:UpdateItem(itemData)
        self:_updateContainerData(uid, targetContainerType, slotID)
        itemUpdateData.NewItem = newItem
        itemUpdateData.NewContType = targetContainerType
        return itemUpdateData
    end

    oldItem = oldItemData:CreateCopy()
    newItem = self._itemFactory:ResetItemByType(oldItemData, GameEnum.EItemCreateType.RoItem, itemPb)
    if nil == newItem then
        logError("[BagApi] error occurred during creating item data, item existed, tid changed, plis check")
        return nil
    end

    self._itemPool:UpdateItem(newItem)

    --- 如果是对装备强化，容器不会发生变化；数量变化也不会变动容器位置，这种时候是不会有移除操作的
    --- 如果是从仓库里取一部分道具到背包，仓库本身位置也不会发生变化，背包中会添加一个新道具，所以也不会移除
    if oldItem.ContainerType ~= newItem.ContainerType then
        local removeResult = self:_removeContainerData(uid, targetContainerType)
        if not removeResult then
            return nil
        end
    end

    local updateResult = self:_updateContainerData(uid, targetContainerType, slotID)
    if not updateResult then
        return nil
    end

    itemUpdateData.OldItem = oldItem
    itemUpdateData.NewItem = newItem
    if nil ~= oldItem then
        itemUpdateData.OldContType = oldItem.ContainerType
    end

    itemUpdateData.NewContType = targetContainerType
    return itemUpdateData
end

--- 移除对应的道具，这个地方只有UID，所以需要对道具容器进行遍历，将对应的UID进行处理
---@param uid string
---@return ItemUpdateData
function BagApi:RemoveItem(uid, reason)
    if nil == uid then
        logError("[BagApi] invalid param, type: " .. type(uid))
        return nil
    end

    local ret = self._itemPool:GetItemData(uid)
    local removeResult, containerType = self:_removeContainerData(uid, nil)
    if not removeResult then
        return nil
    end

    self._itemPool:Remove(uid)

    ---@type ItemUpdateData
    local itemUpdateData = Data.ItemUpdateData.new()
    itemUpdateData.OldItem = ret
    itemUpdateData.NewItem = nil
    itemUpdateData.OldContType = containerType
    itemUpdateData.NewContType = contType.None
    itemUpdateData.Reason = reason
    itemUpdateData.ExtraData = -1
    return itemUpdateData
end

function BagApi:UpdateItemCountMap(container)
    self:_updateSingleContainerMap(container)
end

--- 更新容器当中的数据
---@return boolean
function BagApi:_updateContainerData(uid, targetContainerType, slotID)
    local updateFunc = self.C_CONTAINER_UPDATE_FUNC[targetContainerType]
    if nil == updateFunc then
        logError("[BagApi] invalid targetType: " .. tostring(targetContainerType))
        return false
    end

    local targetMap = self._itemContainer:GetContainerData(targetContainerType)
    local addMap = updateFunc(self, targetMap, uid, slotID, true)
    self._itemContainer:SetContainerData(targetContainerType, addMap)
    return true
end

--- 从容器当中移除数据
---@return boolean, number
function BagApi:_removeContainerData(uid, targetContainerType)
    local currentContType, currentSlot = self._itemContainer:GetUIDContainer(uid, targetContainerType)
    local removeFunc = self.C_CONTAINER_UPDATE_FUNC[currentContType]
    if nil == removeFunc then
        --- 为了确保删除道具的时候道具确实在有保存过
        local targetItem = self._itemPool:GetItemData(uid)
        if nil == targetItem then
            logError("[BagApi] remove item never acquired, uid: " .. tostring(uid))
        else

            logError("[BagApi] invalid targetType: " .. tostring(targetContainerType) .. " uid: " .. tostring(uid) .. " currentContainerType: " .. tostring(targetItem.ContainerType))
        end

        return false, currentContType
    end

    local currentMap = self._itemContainer:GetContainerData(currentContType)
    local removeMap = removeFunc(self, currentMap, uid, currentSlot, false)
    self._itemContainer:SetContainerData(currentContType, removeMap)
    return true, currentContType
end

--- 背包数据发生更新的时候刷新指定容器当中的数量映射
function BagApi:_updateSingleContainerMap(containerType)
    if nil == containerType then
        logError("[BagApi] invalid container type: " .. containerType)
        return
    end

    local typeList = { containerType }
    local items = self:_getItemsByTypesAndConds(typeList, nil)
    self._itemTidCountMap:ClearTargetContainer(containerType)
    for i = 1, #items do
        local singleItem = items[i]
        local currentCount = self._itemTidCountMap:GetItemCountByContTid(containerType, singleItem.TID)
        local targetCount = singleItem.ItemCount + currentCount
        self._itemTidCountMap:SetCountByContTid(containerType, singleItem.TID, targetCount)
    end
end

--- 内部方法，只允许内部调用
---@param containerTypes number[]
---@param conditions FiltrateCond[]
---@return ItemData[]
function BagApi:_getItemsByTypesAndConds(containerTypes, conditions)
    if luaBaseType.Table ~= type(containerTypes) then
        logError("[BagApi] invalid container types")
        return {}
    end

    local items = {}
    local itemUIDs = self._itemContainer:GetItemUidsByTypes(containerTypes)
    for i = 1, #itemUIDs do
        local singleItemUID = itemUIDs[i]
        local singleItem = self._itemPool:GetItemData(singleItemUID)
        table.insert(items, singleItem)
    end

    local ret = itemFilter.FiltrateItemData(items, conditions)
    return ret
end

---@param itemPos number @int16 高4位是容器类型，低12位是位置
---@return number, number
function BagApi:GetContTypeAndSlotID(itemPos)
    if luaBaseType.Number ~= type(itemPos) then
        return GameEnum.EBagContainerType.None, 0
    end

    local slotID = math.fmod(itemPos, C_BIT_16)
    local type = math.floor(itemPos / C_BIT_16)
    local clientType = Data.BagTypeClientSvrMap:GetClientContType(type)
    if nil == clientType then
        logError("[BagApi] invalid type: " .. tostring(type))
    end

    return clientType, slotID
end

--- 如果这个道具本身置顶道具
---@param slotItemMap table<number, ItemData>
---@return table<number, uint64>
function BagApi:_bagSort(slotItemMap)
    local highMap = {}
    local normalMap = {}
    local ret = {}
    for i = #slotItemMap, 1, -1 do
        local singleItem = slotItemMap[i]
        if 0 < singleItem.ItemTopId then
            table.insert(highMap, slotItemMap[i])
        else
            table.insert(normalMap, slotItemMap[i])
        end
    end

    table.sort(highMap, self._highSortFunc)
    table.sort(normalMap, self._sortFunc)
    for i = 1, #highMap do
        table.insert(ret, highMap[i].UID)
    end

    for i = 1, #normalMap do
        table.insert(ret, normalMap[i].UID)
    end

    return ret
end

---@param slotItemMap table<number, ItemData>
---@return table<number, uint64>
function BagApi:_directSort(slotItemMap)
    table.sort(slotItemMap, self._sortFunc)
    local ret = {}
    for i = 1, #slotItemMap do
        table.insert(ret, slotItemMap[i].UID)
    end

    return ret
end

---@param containerType number
---@return table<number, ItemData>
function BagApi:_createSlotItemMap(containerType)
    if luaBaseType.Number ~= type(containerType) then
        logError("[BagApi] invalid container map")
        return {}
    end

    local slotUidMap = self._itemContainer:GetContainerData(containerType)
    if nil == slotUidMap then
        logError("[BagApi] Slot UID map got nil, container type: " .. tostring(containerType))
        return {}
    end

    local ret = {}
    for slot, uid in pairs(slotUidMap) do
        ret[slot] = self._itemPool:GetItemData(uid)
    end

    return ret
end

---@param map table<number, int64>
---@param uid int64
---@param slot number
---@return table<number, string>
function BagApi:_autoFillWithFixedSlot(map, uid, slot, isAdd)
    if nil == uid
            or luaBaseType.Table ~= type(map)
            or luaBaseType.Boolean ~= type(isAdd) then
        logError("[BagApi] invalid param, return input map")
        return map
    end

    local ret = self:_autoFill(map, uid, slot, isAdd)
    ---@type table<number, ItemData>
    local itemMap = {}
    for slotIdx, itemUID in pairs(ret) do
        local localItemData = self._itemPool:GetItemData(itemUID)
        table.insert(itemMap, localItemData)
    end

    ---@type table<number, ItemData>
    local topItems = {}
    ---@type table<number, ItemData>
    local normalItems = {}
    for i = 1, #itemMap do
        local singleItem = itemMap[i]
        if 0 < singleItem.ItemTopId then
            table.insert(topItems, singleItem)
        else
            table.insert(normalItems, singleItem)
        end
    end

    local retMap = {}
    table.sort(topItems, self._highSortFunc)
    for i = 1, #topItems do
        local uid = topItems[i].UID
        table.insert(retMap, uid)
    end

    for i = 1, #normalItems do
        local uid = normalItems[i].UID
        table.insert(retMap, uid)
    end

    return retMap
end

---@param map table<number, int64>
---@param uid int64
---@param slot number
---@return table<number, string>
function BagApi:_autoFill(map, uid, slot, isAdd)
    if nil == uid
            or luaBaseType.Table ~= type(map)
            or luaBaseType.Boolean ~= type(isAdd) then
        logError("[BagApi] invalid param, return input map")
        return map
    end

    if isAdd then
        for slotIdx, itemUID in pairs(map) do
            if itemUID:equals(uid) then
                return map
            end
        end
    end

    local ret = {}
    if true == isAdd then
        table.insert(ret, uid)
        for slotIdx, itemUID in pairs(map) do
            table.insert(ret, itemUID)
        end
    else
        for slotIdx, itemUID in pairs(map) do
            if uid ~= itemUID then
                table.insert(ret, itemUID)
            end
        end
    end

    return ret
end

--- 只是将数据添加到指定位置，其他什么都不做
---@param map table<number, string>
---@param uid number
---@param slot number
---@return table<number, string>
function BagApi:_reserveCurrent(map, uid, slot, isAdd)
    if nil == uid
            or luaBaseType.Number ~= type(slot)
            or luaBaseType.Table ~= type(map)
            or luaBaseType.Boolean ~= type(isAdd) then
        logError("[BagApi] invalid param, return input map")
        return map
    end

    if isAdd then
        for slotIdx, itemUID in pairs(map) do
            if itemUID:equals(uid) then
                return map
            end
        end
    end

    --- 容器映射在更新的时候会出现一个UID无处存放的问题，所以做一个间隔的槽位
    --- 专门用于缓存无处存放的UID，保证在更新的时候UID总能找到对应的容器
    if true == isAdd then
        local cacheUID = map[slot]
        map[C_CACHE_EQUIP_SLOT_IDX + slot] = cacheUID
        map[slot] = uid
    else
        map[slot] = nil
    end

    return map
end

---@param a ItemData
---@param b ItemData
function BagApi._highSortFunc(a, b)
    if a.ItemTopId ~= b.ItemTopId then
        return a.ItemTopId < b.ItemTopId
    end

    return a.ItemCount < b.ItemCount
end

--- 常规排序算法
---@param a ItemData
---@param b ItemData
function _normalItemSortFunc(a, b)
    if a.ItemConfig.SortID == b.ItemConfig.SortID then
        if not int64.equals(a.ItemCount, b.ItemCount) then
            return a.ItemCount > b.ItemCount
        end

        return a.UID > b.UID
    end

    return a.ItemConfig.SortID > b.ItemConfig.SortID
end

--- 获取齿轮的状态
---@param gearItem ItemData
function _getGearState(gearItem)
    if nil == gearItem then
        logError("[BagApi] invalid data")
        return GameEnum.EGearState.None
    end

    if 0 >= gearItem.EffectiveTime then
        return GameEnum.EGearState.Unused
    end

    if 0 < gearItem:GetRemainingTime() then
        return GameEnum.EGearState.InUse
    else
        return GameEnum.EGearState.NoLife
    end
end

--- 贝鲁仔齿轮排序算法
--- 排序规则：寿命（可用>寿命耗尽>未用过）> 品质
---@param a ItemData
---@param b ItemData
function _gearSortFunc(a, b)
    local aState = _getGearState(a)
    local bState = _getGearState(b)
    if aState ~= bState then
        return aState > bState
    end

    if a.ItemConfig.ItemQuality ~= b.ItemConfig.ItemQuality then
        return a.ItemConfig.ItemQuality > b.ItemConfig.ItemQuality
    end

    if a.ItemConfig.SortID == b.ItemConfig.SortID then
        return a.UID > b.UID
    end

    return a.ItemConfig.SortID > b.ItemConfig.SortID
end

--- 排序算法分为两种，当两个都是齿轮得时候走齿轮排序规则，否则走常规排序规则
---@param a ItemData
---@param b ItemData
function BagApi._sortFunc(a, b)
    if a:ItemMatchesType(GameEnum.EItemType.BelluzGear) and b:ItemMatchesType(GameEnum.EItemType.BelluzGear) then
        return _gearSortFunc(a, b)
    end

    return _normalItemSortFunc(a, b)
end

return Data.BagApi