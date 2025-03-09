--- 这个类主要负责解读服务器消息
--- 这个类不再对程序内部提供任何接口，只负责接受服务器协议来更新客户端数据，以及发消息
module("Data", package.seeall)
BagDataModel = class("BagDataModel")
local gameEventMgr = MgrProxy:GetGameEventMgr()
local luaTypes = GameEnum.ELuaBaseType
local containerTypes = GameEnum.EBagContainerType

function BagDataModel:Init()
    Data.BagApi:Init()
    self._bagApi = Data.BagApi

    --- 需要做偏移量的容器类型
    --- 有的容器类型拿到之后需要保留槽位，但是客户端内部使用的槽位是lua编号，从1开始
    --- 发消息发的是服务器编号，所以这里要进行判断哪些类型需要进行便宜
    -- todo 快速使用槽位是需要偏移的，现在计算上有一些隐含的问题，需要需求结束之后解一下
    self.C_NEED_OFFSET_CONT_MAP = {
        [containerTypes.Equip] = 1,
        [containerTypes.BeiluzCore] = 1,
        [containerTypes.PlayerCustom] = 1,
    }
end

function BagDataModel:Clear()
    self._bagApi:Clear()
end

--- 目前角色同步和断线重连走的是这个
---@param roleData RoleAllInfo
function BagDataModel:Sync(roleData)
    if luaTypes.Table ~= type(roleData) then
        logError("[BagDataModel] Sync Failed")
        return
    end

    local updateDataList = {}
    local updateList_1 = self:_syncItemDataList(roleData.itemdata_0.item_data_list.item_data_list)
    local updateList_2 = self:_syncItemDataList(roleData.itemdata_1.item_data_list.item_data_list)
    local updateList_3 = self:_syncItemDataList(roleData.itemdata_2.item_data_list.item_data_list)
    local updateList_4 = self:_syncItemDataList(roleData.itemdata_3.item_data_list.item_data_list)
    local updateList_5 = self:_syncItemDataList(roleData.itemdata_4.item_data_list.item_data_list)
    table.ro_insertRange(updateDataList, updateList_1)
    table.ro_insertRange(updateDataList, updateList_2)
    table.ro_insertRange(updateDataList, updateList_3)
    table.ro_insertRange(updateDataList, updateList_4)
    table.ro_insertRange(updateDataList, updateList_5)

    local containerHash = self:_createContainerHash(updateDataList)
    self:_updateAllCount(containerHash)

    gameEventMgr.RaiseEvent(gameEventMgr.OnBagSync, nil)
end

--- 重构之后的背包道具更新和同步协议s
function BagDataModel:OnSvrUpdate(msg)
    ---@type UpdateItem
    local updateItemPb = ParseProtoBufToTable("UpdateItem", msg)
    local itemUpdateList = {}

    --logError("update: " .. ToString(updateItemPb.item_list))
    --logError("remove: " .. ToString(updateItemPb.delete_list))

    local roItemList = {}
    local updateReasonList = {}
    local extraList = {}

    -- todo 用来创建服务器数据的测试代码
    -----@type Ro_Item
    --local test_ro_item_data = GetProtoBufSendTable("Ro_Item")
    --test_ro_item_data.uid = ToUInt64(1)
    --test_ro_item_data.item_id = 0
    --table.insert(roItemList, test_ro_item_data)

    for i = 1, #updateItemPb.item_list do
        table.insert(roItemList, updateItemPb.item_list[i].item)
        table.insert(updateReasonList, updateItemPb.item_list[i].reason)
        table.insert(extraList, updateItemPb.item_list[i].extra_param)
    end

    local updateDataList = self:_syncItemDataList(roItemList, updateReasonList, extraList)
    table.ro_insertRange(itemUpdateList, updateDataList)
    for i = 1, #updateItemPb.delete_list do
        --remove道具时无视extra_param
        local singleUID = updateItemPb.delete_list[i].key
        local removeReason = updateItemPb.delete_list[i].value
        local itemUpdateData = self._bagApi:RemoveItem(singleUID, removeReason)
        if nil ~= itemUpdateData then
            table.insert(itemUpdateList, itemUpdateData)
        end
    end

    --self:_showLog(itemUpdateList)
    --logError(ToString(itemUpdateList))

    --- 根据更新的道具数量，获取有多少容器需要更新
    --- 然后刷新一次容器数量映射
    local containerHash = self:_createContainerHash(itemUpdateList)
    self:_updateAllCount(containerHash)

    gameEventMgr.RaiseEvent(gameEventMgr.OnBagEarlyUpdate, nil)
    gameEventMgr.RaiseEvent(gameEventMgr.OnBagUpdate, itemUpdateList)
end

---@param svrItemList Ro_Item[]
---@param changeReasonList number[]
---@return ItemUpdateData[]
function BagDataModel:_syncItemDataList(svrItemList, changeReasonList, extraList)
    ---@type ItemUpdateData[]
    local itemUpdateList = {}

    for i = 1, #svrItemList do
        local singleItemPBData = svrItemList[i]
        local updateReason = ItemChangeReason.ITEM_REASON_NONE
        local updateExtraData = -1
        if nil ~= changeReasonList and nil ~= changeReasonList[i] then
            updateReason = changeReasonList[i]
        end
        if nil ~= extraList and nil ~= extraList[i] then
            updateExtraData = extraList[i]
        end

        local targetContainerType, slotID = self._bagApi:GetContTypeAndSlotID(singleItemPBData.item_pos)
        if nil == targetContainerType then
            logError("[BagDataModel] tid: " .. tostring(singleItemPBData.item_id) .. " matches no valid container type")
        end

        if nil ~= self.C_NEED_OFFSET_CONT_MAP[targetContainerType] then
            slotID = slotID + 1
        end

        local itemUpdateData = self._bagApi:UpdateSingleItem(singleItemPBData, targetContainerType, slotID, updateReason, updateExtraData)
        if nil ~= ItemUpdateData then
            table.insert(itemUpdateList, itemUpdateData)
        else
            logError("[BagDataModel] tid: " .. tostring(singleItemPBData.item_id) .. " update failed for unknown reason")
        end
    end

    return itemUpdateList
end

---@param itemUpdateList ItemUpdateData[]
function BagDataModel:_createContainerHash(itemUpdateList)
    if nil == itemUpdateList then
        return {}
    end

    local ret = {}
    for i = 1, #itemUpdateList do
        local singleUpdateData = itemUpdateList[i]
        local oldContainerType = singleUpdateData.OldContType
        local newContainerType = singleUpdateData.NewContType
        if nil ~= oldContainerType and containerTypes.None ~= oldContainerType then
            ret[oldContainerType] = 1
        end

        if nil ~= newContainerType and containerTypes.None ~= newContainerType then
            ret[newContainerType] = 1
        end
    end

    return ret
end

function BagDataModel:_updateAllCount(containerHash)
    for containerType, value in pairs(containerHash) do
        self._bagApi:UpdateItemCountMap(containerType)
    end
end

--- 验证函数
---@param updateDataList ItemUpdateData[]
function BagDataModel:_showLog(updateDataList)
    local ret = {}
    for i = 1, #updateDataList do
        local singleData = updateDataList[i]
        local oldUID = 0
        local newUID = 0
        if nil ~= singleData.OldItem then
            oldUID = singleData.OldItem.UID
        else
            oldUID = "nil"
        end

        if nil ~= singleData.NewItem then
            newUID = singleData.NewItem.UID
        else
            newUID = "nil"
        end

        local data = {
            oldContainer = singleData.OldContType,
            newContainer = singleData.NewContType,
            oldUID = oldUID,
            newUID = newUID,
            reason = singleData.Reason,
            tid = singleData:GetItemCompareData().id,
            count = singleData:GetItemCompareData().count
        }

        table.insert(ret, data)
    end

    logError(ToString(ret))
end

return Data.BagDataModel