require "Data/Model/BagModel"
require "Data/Model/BagDataModel"

--- 接消息需要mgr作为入口，所以包了一层
---@module ModuleMgr.ItemContainerMgr
module("ModuleMgr.ItemContainerMgr", package.seeall)

--- 进入游戏就会完成初始化，切换角色的时候不会销毁
function OnInit()
    Data.BagDataModel:Init()
end

--- 切换角色和推出登陆会触发
function OnLogout()
    Data.BagDataModel:Clear()
end

---@param reconnectData ReconectSync
function OnReconnected(reconnectData)
    local roleData = reconnectData.role_data
    Data.BagDataModel:Sync(roleData)
end

function OnUpdateItemNtf(msg)
    Data.BagDataModel:OnSvrUpdate(msg)
end

--- 这边是尝试将道具放入仓库，会先取服务器空位，如果是-1，表示此时需要服务器找位置，也就是要放到下一页
--- 那么就会拦截，提示仓库已经满了
---@param itemData ItemData
function TryPutItemToWareHouse(itemData, count)
    if nil == itemData then
        logError("[ItemContainerMgr] invalid param")
        return
    end

    local currentPage = Data.BagModel:getPotId()
    local targetContType = Data.BagTypeClientSvrMap:GetWareHouseContTypeByIdx(currentPage)
    local types = { targetContType }
    local itemList = Data.BagApi:GetItemsByTypesAndConds(types, nil)
    local C_WAREHOUSE_PAGE_ITEM_COUNT = MGlobalConfig:GetInt("PotGridNum")
    if C_WAREHOUSE_PAGE_ITEM_COUNT > #itemList then
        Data.BagApi:ReqSwapItem(itemData.UID, targetContType, nil, count)
        return
    end

    local canCollapse = false
    for i = 1, #itemList do
        local singleItemData = itemList[i]
        if itemData:CanCollapse(singleItemData) then
            canCollapse = true
            break
        end
    end

    if not canCollapse then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("C_WAREHOUSE_PAGE_FULL"))
        return
    end

    Data.BagApi:ReqSwapItem(itemData.UID, targetContType, nil, count)
end

--- 只获取一个容器当中的数据
---@return ItemData[]
function GetItemsBySingleTypeCond(bagType, cond)
    return _getItemByConditionType(bagType, cond)
end

---@return ItemData[]
function _getItemByConditionType(bagType, cond)
    local types = { bagType }
    local conditions = { { Cond = cond } }
    return Data.BagApi:GetItemsByTypesAndConds(types, conditions)
end

---@return ItemData[]
function GetBagItemsByTidHashTable(idsHash)
    if not idsHash then
        return {}
    end
    return _getItemByConditionType(GameEnum.EBagContainerType.Bag, function(item)
        return idsHash[item.TID]
    end)
end

---@return ItemData[]
function GetBagItemsByTids(tids)
    if not tids then
        return {}
    end
    return _getItemByConditionType(GameEnum.EBagContainerType.Bag, function(item)
        return table.ro_contains(tids, item.TID)
    end)
end

---@return ItemData[]
function GetEquips()
    local types = { GameEnum.EBagContainerType.Equip }
    return Data.BagApi:GetItemsByTypesAndConds(types, nil)
end

--- 获取道具数量
---@param containerType number
---@param tid number
---@return number
function GetItemCountByContAndID(containerType, tid)
    local luaBaseType = GameEnum.ELuaBaseType
    if luaBaseType.Number ~= type(containerType) or luaBaseType.Number ~= type(tid) then
        logError("[BagApi] invalid param")
        return 0
    end

    local containerList = { containerType }
    local ret = Data.BagApi:GetItemCountByContListAndTid(containerList, tid)
    return ret
end

function ReqSameTIDItemInherit(scrUID, tarUID)
    local l_msgId = Network.Define.Rpc.EquipInherit
    ---@type EquipInheritArg
    local l_sendInfo = GetProtoBufSendTable("EquipInheritArg")
    l_sendInfo.from_item_uid = scrUID
    l_sendInfo.to_item_uid = tarUID
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnEquipInheritConfirm(msg)
    ---@type EquipInheritRes
    local l_info = ParseProtoBufToTable("EquipInheritRes", msg)
    local l_errorCode = l_info.result
    if 0 == l_errorCode then
        local l_eventMgr = MgrMgr:GetMgr("GameEventMgr")
        l_eventMgr.RaiseEvent(l_eventMgr.EquipAttrSwapConfirm)
        return
    end

    local l_str = Common.Functions.GetErrorCodeStr(l_errorCode)
    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_str)
end

return ModuleMgr.ItemContainerMgr