--- 这个类当中只包含槽位和UID的映射关系，目前这个槽位机制主要是针对显示上的
--- 这个类当中不保存任何道具道具，只保存容器相关的内容
module("Data", package.seeall)

---@class BagContainerData
BagContainerData = class("BagContainerData")

local bagContainerType = GameEnum.EBagContainerType
local baseType = GameEnum.ELuaBaseType

---@return BagContainerData
function BagContainerData:ctor()
    ---@type table<number, table<number, uint64>>
    self._container = {}
    local contHash = Data.BagTypeClientSvrMap:GetActiveContTable()
    for contType, value in pairs(contHash) do
        self._container[contType] = {}
    end

    self._containerTransMap = Data.BagTypeClientSvrMap:GetMoveRelationMap()
end

--- 清空数据
function BagContainerData:Clear()
    for k, v in pairs(self._container) do
        self._container[k] = {}
    end
end

---@return uint64[]
function BagContainerData:GetItemUidsByTypes(types)
    if baseType.Table ~= type(types) then
        logError("[ItemContainer] invalid types")
        return {}
    end

    local ret = {}
    for i = 1, #types do
        local singleContainerType = types[i]
        if baseType.Number ~= type(singleContainerType) then
            logError("[ItemContainer] Invalid types, plis check")
            return {}
        end

        local container = self._container[singleContainerType]
        if nil == container then
            logError("[ItemContainer] invalid container type : " .. tostring(singleContainerType))
            return {}
        end

        for slotID, uid in pairs(container) do
            table.insert(ret, uid)
        end
    end

    return ret
end

---@param uid uint64
---@return number, number
function BagContainerData:GetUIDContainer(uid, targetContType)
    if nil == uid then
        logError("[ItemContainer] invalid param")
        return bagContainerType.None, -1
    end

    if baseType.Number == type(targetContType) and nil ~= self._containerTransMap[targetContType] then
        for slotID, itemUID in pairs(self._container[targetContType]) do
            if itemUID == uid then
                return targetContType, slotID
            end
        end

        local contTypeList = self._containerTransMap[targetContType]
        for i = 1, #contTypeList do
            local singleContType = contTypeList[i]
            for slotID, itemUID in pairs(self._container[singleContType]) do
                if itemUID == uid then
                    return singleContType, slotID
                end
            end
        end
    end

    for containerType, slotMap in pairs(self._container) do
        for slotID, itemUID in pairs(slotMap) do
            if itemUID == uid then
                return containerType, slotID
            end
        end
    end

    return bagContainerType.None, -1
end

---@return uint64
function BagContainerData:GetItemUIDByIndex(containerType, idx)
    if baseType.Number ~= type(idx) or baseType.Number ~= type(containerType) then
        logError("[ItemContainer] invalid params")
        return nil
    end

    local container = self._container[containerType]
    if nil == container then
        logError("[ItemContainer] invalid container type : " .. tostring(containerType))
        return nil
    end

    return container[idx]
end

---@param uid uint64
function BagContainerData:AddItemUID(containerType, uid, slotIdx)
    if nil == uid or baseType.Number ~= type(slotIdx) or baseType.Number ~= type(containerType) then
        logError("[ItemContainer] invalid param, plis chec")
        return
    end

    local container = self._container[containerType]
    if nil == container then
        logError("[ItemContainer] invalid containerType: " .. tostring(containerType))
        return
    end

    container[slotIdx] = uid
end

---@param uid uint64
function BagContainerData:RemoveUID(containerType, uid, slotID)
    if nil == uid or baseType.Number ~= type(containerType) then
        logError("[ItemContainer] invalid param type")
        return
    end

    local container = self._container[containerType]
    if nil == container then
        logError("[ItemContainer] invalid container type : " .. tostring(containerType))
        return
    end

    if baseType.Number == type(slotID) and container[slotID] == uid then
        container[slotID] = nil
        return
    end

    for slot, ItemUid in pairs(container) do
        if uid == ItemUid then
            container[slot] = nil
            return
        end
    end

    logError("[ItemContainer] invalid uid : " .. tostring(uid))
end

---@return table<number, uint64>
function BagContainerData:GetContainerData(containerType)
    if baseType.Number ~= type(containerType) then
        logError("[ItemContainer] invalid param")
        return nil
    end

    local container = self._container[containerType]
    if nil == container then
        logError("[ItemContainer] invalid container type : " .. tostring(containerType))
        return nil
    end

    return container
end

---@param map table<number, uint64>
function BagContainerData:SetContainerData(containerType, map)
    if baseType.Number ~= type(containerType) or baseType.Table ~= type(map) then
        logError("[ItemContainer] invalid param")
        return
    end

    local container = self._container[containerType]
    if nil == container then
        logError("[ItemContainer] invalid container type : " .. tostring(containerType))
        return nil
    end

    self._container[containerType] = map
end