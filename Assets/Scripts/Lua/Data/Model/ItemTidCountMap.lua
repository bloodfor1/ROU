--- 维护每个容器当中道具TID和数量的映射，只按照容器和tid去区分数量，不区分细节堆叠状态
module("Data", package.seeall)

---@class ItemTidCountMap
ItemTidCountMap = class("ItemTidCountMap")

function ItemTidCountMap:ctor()
    ---@type table<number, table<number, int64>>
    self._container = {}
    local contHash = Data.BagTypeClientSvrMap:GetActiveContTable()
    for contType, value in pairs(contHash) do
        self._container[contType] = {}
    end
end

function ItemTidCountMap:Clear()
    for k, v in pairs(self._container) do
        self._container[k] = {}
    end
end

function ItemTidCountMap:ClearTargetContainer(container)
    if nil == container then
        logError("[BagItemTidCountMap] invalid param")
        return
    end

    local targetMap = self._container[container]
    if nil == targetMap then
        logError("[BagApi] invalid container type: " .. container)
        return
    end

    self._container[container] = {}
end

---@return int64
function ItemTidCountMap:GetItemCountByContTid(containerType, tid)
    if nil == containerType or nil == tid then
        logError("[BagItemTidCountMap] invalid param")
        return 0
    end

    local targetMap = self._container[containerType]
    if nil == targetMap then
        logError("[BagApi] invalid container type: " .. containerType)
        return 0
    end

    local targetCount = targetMap[tid]
    if nil == targetMap[tid] then
        return 0
    end

    return targetCount
end

---@param count int64
function ItemTidCountMap:SetCountByContTid(containerType, tid, count)
    if nil == containerType or nil == tid or nil == count then
        logError("[BagItemTidCountMap] invalid param")
        return
    end

    local targetMap = self._container[containerType]
    if nil == targetMap then
        logError("[BagApi] invalid container type: " .. containerType)
        return
    end

    if 0 >= count then
        targetMap[tid] = nil
    else
        targetMap[tid] = count
    end
end