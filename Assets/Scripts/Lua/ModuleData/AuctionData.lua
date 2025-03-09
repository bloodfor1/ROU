---@module ModuleData.AuctionData
module("ModuleData.AuctionData", package.seeall)

-- 缓存上一次的选中分类
lastSelectIndex = nil

-- 以item id为key，便于查询
auctionItemsForBlackShop = {}

-- 分类
auctionParentIndexList = {}
auctionIndexDict = {}
-- 我的竞拍
myBilledIndex = -1
-- 推荐
recommendIndex = -2

-- 出价cd
bidCd = 10
lastBidTimestamp = 0

-- 是否选中自动出价
isAutoBidSelected = false

-- 通过分类管理物品
auctionItemsByIndex = {}

-- 关注的物品
auctionFollowItems = {}

-- 拍卖的物品
auctionItems = {}

-- 已拍卖的物品
billedAuctionItems = {}

-- 用于关注操作的数据
auctionItemsListForFollow = {}

function Init()
    local l_auctionItemsDictForFollow = {}
    for _, row in pairs(TableUtil.GetAuctionTable().GetTable()) do
        if row.Enable then
            if row.AuctionType == 1 then
                auctionItemsForBlackShop[row.ItemID] = {
                    tableInfo = row,
                    -- MoneyType为2时，价格从服务器拿
                    serverSellPrice = 0,
                    lastRefreshTime = 0
                }
            end
            if not l_auctionItemsDictForFollow[row.ItemID] then
                l_auctionItemsDictForFollow[row.ItemID] = {itemId = row.ItemID, sortId = row.SortID, index = row.ShowIndex, auctionTableInfo = row}
            end
        end
    end

    for _, v in pairs(l_auctionItemsDictForFollow) do
        table.insert(auctionItemsListForFollow, v)
    end
    table.sort(auctionItemsListForFollow, function(a, b)
        if a.sortId ~= b.sortId then
            return a.sortId < b.sortId
        else
            return a.itemId < b.itemId
        end
    end)


    -- 我的竞拍，推荐
    auctionIndexDict[myBilledIndex] = {index = myBilledIndex, name = Lang("MY_BILLED"), parentIndex = 0, childIndexList = {}}
    auctionIndexDict[recommendIndex] = {index = recommendIndex, name = Lang("RECOMMEND_WORD"), parentIndex = 0, childIndexList = {}}
    table.insert(auctionParentIndexList, auctionIndexDict[myBilledIndex])
    table.insert(auctionParentIndexList, auctionIndexDict[recommendIndex])
    for _, row in pairs(TableUtil.GetAuctionIndexTable().GetTable()) do
        auctionIndexDict[row.IndexID] = {index = row.IndexID, name = row.IndexName, parentIndex = row.IndexType, childIndexList = {}}
        if row.IndexType == 0 then
            table.insert(auctionParentIndexList, auctionIndexDict[row.IndexID])
        end
    end


    -- 处理子分类
    for _, row in pairs(TableUtil.GetAuctionIndexTable().GetTable()) do
        if row.IndexType ~= 0 and auctionIndexDict[row.IndexType] then
            table.insert(auctionIndexDict[row.IndexType].childIndexList, auctionIndexDict[row.IndexID])
        end
    end
end

function OnLogout()
    auctionItems = {}
    auctionFollowItems = {}
    isAutoBidSelected = false

    lastSelectIndex = nil
end

function GetTableRowByItemId(itemId, auctionType)
    auctionType = auctionType or 1
    return auctionItemsForBlackShop[itemId]
end

-- 获取价格
---@param itemData ItemData
function GetBlackShopSellPrice(itemData)
    local l_price = 0
    local l_needRequest = false
    if itemData.IsAuction then
        l_price = itemData.Price
    else
        local l_itemInfo = auctionItemsForBlackShop[itemData.TID]
        if l_itemInfo then
            if l_itemInfo.tableInfo.MoneyType == 1 then
                l_price = l_itemInfo.tableInfo.SellPrice[1]
            elseif l_itemInfo.tableInfo.MoneyType == 2 then
                l_price = l_itemInfo.serverSellPrice
                l_needRequest = true
            end
        end
    end
    return l_price, l_needRequest
end

function SetServerSellPrice(itemId, price)
    local l_itemInfo = auctionItemsForBlackShop[itemId]
    if l_itemInfo then
        l_itemInfo.serverSellPrice = price
        l_itemInfo.lastRefreshTime = Common.TimeMgr.GetNowTimestamp()
    end
end

-- 黑市是否可出售，可用于判断是否时黑市商品
function CanBlackShopSell(itemId)
    local l_item  = auctionItemsForBlackShop[itemId]
    if not l_item then return false end
    return l_item ~= nil
end

-- 是否关注
function IsFollow(itemId)
    return auctionFollowItems[itemId]
end

function ClearAuctionItem()
    auctionItems = {}
end


function GetAuctionItemByUid(uid)
    return auctionItems[uid]
end


function UpdateAuctionItem(itemInfo, isRemove)
    if not itemInfo or not itemInfo.uid then return end
    if isRemove then
        auctionItems[itemInfo.uid] = nil
        return
    end
    if not auctionItems[itemInfo.uid] then
        ---@class AuctionItemData
        auctionItems[itemInfo.uid] = {
            uid = itemInfo.uid,
            sortId = 0,                 -- 排序id
            moneyId = 102,              -- 货币id
            auctionId = 0,
            itemId = 0,
            auctionTableInfo = nil,
            itemTableInfo = nil,
            count = 0,
            isInAuction = false,        -- 是否在拍卖中
            isInit = true,              -- 是否初始状态，未被出价
            curBidPrice = 0,            -- 当前出价
            myBidPrice = 0,             -- 我的出价
            endTimeStamp = 0,           -- 出价结束时间戳，0表示未开始
            billState = nil,            -- 订单状态
        }
    end
    if itemInfo.auctionId then
        auctionItems[itemInfo.uid].auctionTableInfo = TableUtil.GetAuctionTable().GetRowByAuctionID(itemInfo.auctionId)
        if auctionItems[itemInfo.uid].auctionTableInfo then
            if auctionItems[itemInfo.uid].auctionTableInfo.MoneyType == 1 then
                auctionItems[itemInfo.uid].moneyId = 103
            elseif auctionItems[itemInfo.uid].auctionTableInfo.MoneyType == 2 then
                auctionItems[itemInfo.uid].moneyId = 102
            end
            local l_itemId = auctionItems[itemInfo.uid].auctionTableInfo.ItemID
            auctionItems[itemInfo.uid].itemId = l_itemId
            auctionItems[itemInfo.uid].itemTableInfo = TableUtil.GetItemTable().GetRowByItemID(l_itemId)
            auctionItems[itemInfo.uid].sortId = auctionItems[itemInfo.uid].auctionTableInfo.SortID
        end
    end
    if itemInfo.count then auctionItems[itemInfo.uid].count = itemInfo.count end
    if itemInfo.curBidPrice then auctionItems[itemInfo.uid].curBidPrice = itemInfo.curBidPrice end
    if itemInfo.isInAuction ~= nil then auctionItems[itemInfo.uid].isInAuction = itemInfo.isInAuction end
    if itemInfo.isInit ~= nil then auctionItems[itemInfo.uid].isInit = itemInfo.isInit end
    if itemInfo.myBidPrice then auctionItems[itemInfo.uid].myBidPrice = itemInfo.myBidPrice end
    if itemInfo.endTimeStamp then auctionItems[itemInfo.uid].endTimeStamp = itemInfo.endTimeStamp end
    if itemInfo.billState then auctionItems[itemInfo.uid].billState = itemInfo.billState end
end


function IsAuctionItemsEmpty()
    return next(auctionItems) == nil
end

-- 分类是否为空
function GetIndexNotEmptyState()
    local l_notEmptyState = {}
    for _, v in pairs(auctionItems) do
        if v.auctionTableInfo then
            -- 我的竞拍
            if not l_notEmptyState[myBilledIndex] and IsBidedState(v.billState)then
                l_notEmptyState[myBilledIndex] = true
            end
            -- 推荐
            if not l_notEmptyState[recommendIndex] and v.auctionTableInfo.Recommend == 1 then
                l_notEmptyState[recommendIndex] = true
            end
            if not l_notEmptyState[v.auctionTableInfo.ShowIndex] then
                l_notEmptyState[v.auctionTableInfo.ShowIndex] = true
                if auctionIndexDict[v.auctionTableInfo.ShowIndex] and auctionIndexDict[v.auctionTableInfo.ShowIndex].parentIndex ~= 0 then
                    l_notEmptyState[auctionIndexDict[v.auctionTableInfo.ShowIndex].parentIndex] = true
                end
            end
        end
    end
    return l_notEmptyState
end

function UpdateBilledAuctionItem(itemInfo, isRemove)
    if not itemInfo or not itemInfo.uid then return end
    if isRemove then
        billedAuctionItems[itemInfo.uid] = nil
        return
    end
end

function UpdateFollow(itemId, isFollow)
    auctionFollowItems[itemId] = isFollow
end

-- 是否是出过价的状态
function IsBidedState(state)
    return state == AuctionBillState.kAuctionBillStateAutoBib
            or state == AuctionBillState.kAuctionBillStateManualBib
            or state == AuctionBillState.kAuctionBillStateCancelBib
            or state == AuctionBillState.kAuctionBillStateBibBeOvertaken
end

-- bI开始序号，eI结束序号
function GetAuctionItemsSorted(index, conFunc)
    local l_items = {}
    if index == myBilledIndex then
        for _, v in pairs(auctionItems) do
            --logError(v.myBidPrice)
            if IsBidedState(v.billState) then
                table.insert(l_items, v)
            end
        end
    elseif index == recommendIndex then
        for _, v in pairs(auctionItems) do
            if v.auctionTableInfo and v.auctionTableInfo.Recommend == 1 then
                table.insert(l_items, v)
            end
        end
    else
        for _, v in pairs(auctionItems) do
            if v.auctionTableInfo and v.auctionTableInfo.ShowIndex == index then
                table.insert(l_items, v)
            end
        end
    end

    table.sort(l_items, function(item1, item2)
        if item1.itemId ~= item2.itemId then
            return item1.sortId < item2.sortId
        else
            return item1.uid < item2.uid
        end
    end)
    local l_itemsByCon = {}
    if conFunc then
        for _, v in ipairs(l_items) do
            if conFunc(v) then
                table.insert(l_itemsByCon, v)
            end
        end
    else
        l_itemsByCon = l_items
    end
    return l_itemsByCon
end

-- bI开始序号，eI结束序号
function GetAuctionItemsSortedForFollow(index, isFollow)
    local l_itemIds = {}
    for _, v in pairs(auctionItemsListForFollow) do
        if v.index == index and (not isFollow or IsFollow(v.itemId)) then
            table.insert(l_itemIds, v.itemId)
        end
    end
    return l_itemIds
end

-- 关注分类是否为空
function GetIndexNotEmptyStateForFollow()
    local l_notEmptyState = {}
    for _, v in pairs(auctionItemsListForFollow) do
        if v.auctionTableInfo then
            l_notEmptyState[v.index] = true
            if auctionIndexDict[v.index] and auctionIndexDict[v.index].parentIndex ~= 0 then
                l_notEmptyState[auctionIndexDict[v.index].parentIndex] = true
            end
        end
    end
    return l_notEmptyState
end

function IsParentIndex(index)
    if auctionIndexDict[index] and auctionIndexDict[index].parentIndex == 0 then
        return true
    end
    return false
end


function GetAuctionDataByUid(uid)
    if not uid then return nil end
    return auctionItems[uid]
end

return ModuleData.AuctionData