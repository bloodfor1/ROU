---@module ModuleMgr.ShortCutItemAutoSetMgr
module("ModuleMgr.ShortCutItemAutoSetMgr", package.seeall)

---@type table<number, number> @哪些物品已经获得完成了首次获得
local itemHash = {}
---@type table<number, number> @哪些物品需要设置首次获得
local itemGotoShortCutHash = {}

function OnInit()
    local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
    gameEventMgr.Register(gameEventMgr.OnBagUpdate, _onItemUpdate)
    gameEventMgr.Register(gameEventMgr.OnOnceDataUpdate, _onOnceSystemUpdate)
    _initHash()
end

function OnLogout()
    itemHash = {}
end

function _initHash()
    local quickItemConfig = MGlobalConfig:GetSequenceOrVectorInt("QuickItem")
    for i = 0, quickItemConfig.Length - 1 do
        local itemID = quickItemConfig[i]
        itemGotoShortCutHash[itemID] = 1
    end
end

function _onOnceSystemUpdate()
    local quickItemConfig = MGlobalConfig:GetSequenceOrVectorInt("QuickItem")
    itemHash = {}
    for i = 0, quickItemConfig.Length - 1 do
        local itemID = quickItemConfig[i]
        local onceSystem = MgrMgr:GetMgr("OnceSystemMgr")
        local value = onceSystem.GetOnceState(onceSystem.EClientOnceType.ItemAcquire, itemID)
        --- 这里返回的是布尔值
        if value then
            itemHash[itemID] = 1
        end
    end
end

---@param itemUpdateDataList ItemUpdateData[]
function _onItemUpdate(itemUpdateDataList)
    if nil == itemUpdateDataList then
        logError("[ShortCutAutoSet] invalid param")
        return
    end

    local uidList = {}
    for i = 1, #itemUpdateDataList do
        local singleData = itemUpdateDataList[i]
        --- 表示这个道具是新获得的道具，此时有两种可能，一种是从来没获得过这种道具
        --- 一种是获得过这种道具，但是用了了，重新获得的这种道具
        local compareData = singleData:GetItemCompareData()
        if nil == singleData.OldItem and nil ~= singleData.NewItem
                and GameEnum.EBagContainerType.Bag == singleData.NewContType then
            --- 是首次获得，而且是需要设置的
            local tid = compareData.id
            local uid = singleData:GetNewOrOldItem().UID
            if nil == itemHash[tid] and nil ~= itemGotoShortCutHash[tid] then
                local onceSystem = MgrMgr:GetMgr("OnceSystemMgr")
                onceSystem.SetOnceState(onceSystem.EClientOnceType.ItemAcquire, tid, 1)
                table.insert(uidList, uid)
            end
        end
    end

    _setShortCutItem(uidList)
end

--- 这里可能有一个隐藏的问题，如果玩家一次需要自动设置多个，但是多个这个时候超出了范围，实际上回出现覆盖操作
function _setShortCutItem(uidList)
    local slots = MgrMgr:GetMgr("ShortCutItemMgr").GetEmptySlots()
    for i = 1, #uidList do
        local singleUID = uidList[i]
        if i < #slots then
            local idx = slots[i]
            Data.BagApi:ReqSwapItem(singleUID, GameEnum.EBagContainerType.ShortCut, idx, -1)
        end
    end
end

return ModuleMgr.ShortCutItemAutoSetMgr