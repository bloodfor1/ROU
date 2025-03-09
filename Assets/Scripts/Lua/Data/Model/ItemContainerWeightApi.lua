--- 管理玩家每个容器对应的重量
module("Data", package.seeall)

---@class ItemContainerWeightApi
ItemContainerWeightApi = class("ItemContainerWeightApi")

--- 客户端道具数据类型
local E_CONT_TYPE = GameEnum.EBagContainerType

function ItemContainerWeightApi:ctor()
    ---@type table<number, ContainerWeightPair>
    self._contWeightMap = {
        [E_CONT_TYPE.Bag] = { currentWeight = 0, maxWeight = 0 },
        [E_CONT_TYPE.Cart] = { currentWeight = 0, maxWeight = 0 },
    }
end

--- 退出登陆的时候会调用这个方法
function ItemContainerWeightApi:Clear()
    self._contWeightMap = {
        [E_CONT_TYPE.Bag] = { currentWeight = 0, maxWeight = 0 },
        [E_CONT_TYPE.Cart] = { currentWeight = 0, maxWeight = 0 },
    }
end

function ItemContainerWeightApi:SetMaxWeight(containerType, value)
    if nil == containerType or nil == value then
        logError("[ItemW8] invalid param")
        return
    end

    local targetPair = self._contWeightMap[containerType]
    if nil == targetPair then
        logError("[ItemW8] invalid type: " .. tostring(containerType))
        return
    end

    targetPair.maxWeight = value
end

function ItemContainerWeightApi:SetCurrentWeight(containerType, value)
    if nil == containerType or nil == value then
        logError("[ItemW8] invalid param")
        return
    end

    local targetPair = self._contWeightMap[containerType]
    if nil == targetPair then
        logError("[ItemW8] invalid type: " .. tostring(containerType))
        return
    end

    targetPair.currentWeight = value
end

function ItemContainerWeightApi:GetMaxWeight(containerType)
    if nil == containerType then
        logError("[ItemW8] invalid param")
        return 0
    end

    local targetPair = self._contWeightMap[containerType]
    if nil == targetPair then
        logError("[ItemW8] invalid type: " .. tostring(containerType))
        return 0
    end

    return targetPair.maxWeight
end

function ItemContainerWeightApi:GetCurrentWeight(containerType)
    if nil == containerType then
        logError("[ItemW8] invalid param")
        return 0
    end

    local targetPair = self._contWeightMap[containerType]
    if nil == targetPair then
        logError("[ItemW8] invalid type: " .. tostring(containerType))
        return 0
    end

    return targetPair.currentWeight
end

return ItemContainerWeightApi