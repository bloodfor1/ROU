require "Data/Model/ItemContainerWeightApi"

--- 这个文件是用来处理背包和手推车重量有关的数据的
--- 界面上的重量是通过发消息来触发的，重量更新有一个单独的消息
---@module ModuleMgr.ItemWeightMgr
module("ModuleMgr.ItemWeightMgr", package.seeall)

local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
local _weightApi = Data.ItemContainerWeightApi.new()
local C_FLOAT_W8_TEN = 0.1

--- 目前只有背包和手推车有重量
local C_VALID_CONT_MAP = {
    [GameEnum.EBagContainerType.Bag] = 1,
    [GameEnum.EBagContainerType.Cart] = 1,
}

function OnInit()
    gameEventMgr.Register(gameEventMgr.OnBagSync, _onItemDataSync)
    gameEventMgr.Register(gameEventMgr.OnBagUpdate, _onItemUpdate)
    gameEventMgr.Register(gameEventMgr.OnPlayerDataSync, _setFromRoleData)
end

function OnLogout()
    _weightApi:Clear()
end

---@param reconnectData ReconectSync
function OnReconnected(reconnectData)
    local roleData = reconnectData.role_data
    _setFromRoleData(roleData)
    _updateAllItemWeight()
end

---@param roleData RoleAllInfo
function _setFromRoleData(roleData)
    local l_bagTable = roleData.bag
    local l_bagMaxLoad = l_bagTable.bag_max_load
    local l_cartMaxLoad = l_bagTable.cart_max_load
    _setContainerMaxWeight(GameEnum.EBagContainerType.Bag, l_bagMaxLoad)
    _setContainerMaxWeight(GameEnum.EBagContainerType.Cart, l_cartMaxLoad)
end

--- 两个接口的差别，这个接口是用来表示道具移动拦截的
function IsWeightExceeded(containerType)
    local currentWeight = _weightApi:GetCurrentWeight(containerType)
    local maxWeight = _weightApi:GetMaxWeight(containerType)
    return currentWeight >= maxWeight
end

--- 这个接口表示重量超过90会加一个buff
--- 目前这个接口只有角色背包上有
function IsWeightRed(containerType)
    local currentWeight = _weightApi:GetCurrentWeight(containerType)
    local maxWeight = _weightApi:GetMaxWeight(containerType)
    local bagLoadDeBuffArr = MGlobalConfig:GetVectorSequence("BagLoadDebuffArr")
    local rate = tonumber(bagLoadDeBuffArr[0][0])
    return currentWeight * 100 >= rate * maxWeight
end

function GetCurrentWeightByType(containerType)
    return _weightApi:GetCurrentWeight(containerType)
end

function GetMaxWeightByType(containerType)
    return _weightApi:GetMaxWeight(containerType)
end

--- 历史遗留问题，这个地方只有propMgr当中会调用，应为propMgr当中接了itemChangeNtf
function SetMaxWeightByType(containerType, value)
    _setContainerMaxWeight(containerType, value)
end

--- 服务器下发的是一个*10的结果
function _setContainerMaxWeight(containerType, value)
    if nil == containerType or nil == value then
        logError("[itemW8] invalid param")
        return
    end

    local clientValue = value * C_FLOAT_W8_TEN
    _weightApi:SetMaxWeight(containerType, clientValue)
    gameEventMgr.RaiseEvent(gameEventMgr.OnW8ChangeConfirm, nil)
end

---@param itemUpdateDataList ItemUpdateData[]
function _onItemUpdate(itemUpdateDataList)
    if nil == itemUpdateDataList then
        logError("[itemW8] invalid param")
        return
    end

    local refresh = false
    for i = 1, #itemUpdateDataList do
        local singleUpdateData = itemUpdateDataList[i]
        if nil ~= C_VALID_CONT_MAP[singleUpdateData.OldContType]
                or nil ~= C_VALID_CONT_MAP[singleUpdateData.NewContType] then
            refresh = true
            break
        end
    end

    if not refresh then
        return
    end

    _updateAllItemWeight()
end

--- 收到sync的时候会重新计算规负重
--- 原因是服務器可能会根据背包里有没有道具来决定是不是登陆的时候对容器重新update
--- 所以可能角色登陆之后，由于一个容器当中没有装备，导致不会受到指定容器的update，这种时候就需要在同步数据阶段计算好重量
function _onItemDataSync()
    _updateAllItemWeight()
end

function _updateAllItemWeight()
    local newBagWeight = _getItemsFullWeightByCont(GameEnum.EBagContainerType.Bag)
    local newTrolleyWeight = _getItemsFullWeightByCont(GameEnum.EBagContainerType.Cart)
    _weightApi:SetCurrentWeight(GameEnum.EBagContainerType.Bag, newBagWeight)
    _weightApi:SetCurrentWeight(GameEnum.EBagContainerType.Cart, newTrolleyWeight)
    gameEventMgr.RaiseEvent(gameEventMgr.OnW8ChangeConfirm, nil)
end

---@return number
function _getItemsFullWeightByCont(containerType)
    local types = { containerType }
    local targetItems = Data.BagApi:GetItemsByTypesAndConds(types, nil)
    local ret = 0
    for i = 1, #targetItems do
        local singleItem = targetItems[i]
        local groupWeight = singleItem:GetWeight() * singleItem.ItemCount
        ret = ret + groupWeight
    end

    return ret
end

return ModuleMgr.ItemWeightMgr