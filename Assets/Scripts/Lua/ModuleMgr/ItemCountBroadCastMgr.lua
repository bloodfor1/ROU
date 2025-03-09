require "Data/Model/ItemUpdateCountData"
require "Data/Model/ItemUpdateCountProcessor"

---@module ModuleMgr.ItemCountBroadCastMgr
module("ModuleMgr.ItemCountBroadCastMgr", package.seeall)

function OnInit()
    local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
    gameEventMgr.Register(gameEventMgr.OnBagUpdate, _onItemUpdateMsg)
end

---@param itemUpdateDataList ItemUpdateData[]
function _onItemUpdateMsg(itemUpdateDataList)
    if nil == itemUpdateDataList then
        logError("[itemCountUpdate] invalid param")
        return
    end

    local paraDataList = {}
    for i = 1, #itemUpdateDataList do
        local singleUpdateData = itemUpdateDataList[i]
        local tid = singleUpdateData:GetItemCompareData().id
        local oldCount = 0
        local newCount = 0
        if nil ~= singleUpdateData.OldItem then
            oldCount = singleUpdateData.OldItem.ItemCount
        end

        if nil ~= singleUpdateData.NewItem then
            newCount = singleUpdateData.NewItem.ItemCount
        end

        local singleItemCountData = Data.ItemUpdateCountData.new(tid, oldCount, newCount)
        table.insert(paraDataList, singleItemCountData)
    end

    local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
    gameEventMgr.RaiseEvent(gameEventMgr.OnItemCountUpdate, paraDataList)
end

return ModuleMgr.ItemCountBroadCastMgr