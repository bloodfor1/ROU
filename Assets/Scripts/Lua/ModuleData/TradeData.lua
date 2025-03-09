require "TableEx/ItemProOffLineMap"

module("ModuleData.TradeData", package.seeall)

-- 关注/预购分类id
PreBuyClassId = 100000

-- 所有商品数据，可以卖的商品，来自服务器
allTradeInfo = {}
-- 分类数据
classInfo = {}
-- 分类的具体数据
itemClassInfo = {}
-- 排序的物品
commoditSorted = {}
-- 分类的开启状态
openState = {}

_commoditIdHash = {}

--Logout重置动态数据
function Logout(...)
    allTradeInfo = {}
end

-- 初始化
function Init()
    local l_merchantTable = TableUtil.GetMerchantGuildTable().GetTable()
    for _, v in pairs(l_merchantTable) do
        -- 主分类
        if v.ClassInformation[0] == 1 then
            local l_classId = v.ClassificationID
            itemClassInfo[l_classId] = {}
            -- 分类的表数据MerchantGuildTable
            itemClassInfo[l_classId].info = v
            -- 子分类数据
            itemClassInfo[l_classId].sonType = {}
            itemClassInfo[l_classId].sonTypeList = {}
            itemClassInfo[l_classId].items = {}           -- 不存在子分类

            table.insert(classInfo, { id = l_classId, son = {} })
        end
    end
    for _, v in pairs(l_merchantTable) do
        -- 子分类
        if v.ClassInformation[0] == 0 then
            local l_classId = v.ClassificationID
            local l_mainClassId = v.ClassInformation[1]
            for i = 1, #classInfo do
                if classInfo[i].id == l_mainClassId then
                    table.insert(classInfo[i].son, v.ClassificationID)
                    break
                end
            end
            if itemClassInfo[l_mainClassId] and itemClassInfo[l_mainClassId].sonType then
                itemClassInfo[l_mainClassId].sonType[l_classId] = {}
                itemClassInfo[l_mainClassId].sonType[l_classId].info = v   -- MerchantGuildTable
                itemClassInfo[l_mainClassId].sonType[l_classId].items = {}
                table.insert(itemClassInfo[l_mainClassId].sonTypeList, l_classId)
            end
        end
    end
    for _, v in pairs(TableUtil.GetCommoditTable().GetTable()) do
        if v.Enable then
            --- id哈希，为了后续过滤数据用的s
            _commoditIdHash[v.CommoditID] = 1

            -- 分类item
            local l_classId = v.OfClassList  -- 商品分类id
            local l_merchantRow = TableUtil.GetMerchantGuildTable().GetRowByClassificationID(l_classId) -- 分类信息
            if l_merchantRow then
                if l_merchantRow.ClassInformation[0] == 0 then
                    -- 子分类
                    local l_mainClassId = l_merchantRow.ClassInformation[1]
                    local l_classInfo = itemClassInfo[l_mainClassId]
                    if l_classInfo and l_classInfo.sonType then
                        -- 进入子分类
                        if l_classInfo.sonType[l_classId] then
                            table.insert(l_classInfo.sonType[l_classId].items, v)   -- CommoditTable
                        end
                    end
                else
                    -- 主分类
                    local l_classInfo = itemClassInfo[l_classId]
                    if l_classInfo then
                        table.insert(l_classInfo.items, v)   -- CommoditTable
                    end
                end
            else
                logError("[Lua][TradeMgr]not exit MerchantGuildTable's id:" .. tostring(l_classId))
            end
        end
    end
    for _, v in pairs(TableUtil.GetCommoditSortTable().GetTable()) do
        table.insert(commoditSorted, { sortID = v.SortID, name = v.Filter })
    end
    table.sort(commoditSorted, function(x, y)
        return x.sortID < y.sortID
    end)

    -- 预购/关注开启状态
    SetOpenState(PreBuyClassId, { isOpen = true })
end

-- 设置商品信息
-- info为nil时删除数据
function SetTradeInfo(itemId, info)
    if not itemId then
        return
    end

    --local l_row = TableUtil.GetCommoditTable().GetRowByCommoditID(itemId)
    --if not l_row or not l_row.Enable then
    --    return
    --end

    -- 拦截禁止的物品
    if nil == _commoditIdHash[itemId] then
        return
    end

    if not info then
        allTradeInfo[itemId] = nil
    end
    if not allTradeInfo[itemId] then
        allTradeInfo[itemId] = {}
    end
    if info.buyCount then
        allTradeInfo[itemId].buyCount = info.buyCount
    end
    if info.sellCount then
        allTradeInfo[itemId].sellCount = info.sellCount
    end
    if info.curPrice then
        allTradeInfo[itemId].curPrice = info.curPrice
    end
    if info.basePrice then
        allTradeInfo[itemId].basePrice = info.basePrice
    end
    -- 注意bool值的判断和别的不一样
    if info.isNotice ~= nil then
        allTradeInfo[itemId].isNotice = info.isNotice
    end
    if info.isFollow ~= nil then
        allTradeInfo[itemId].isFollow = info.isFollow
    end
    if info.stockNum then
        allTradeInfo[itemId].stockNum = info.stockNum
    end
    if info.preBuyNum then
        allTradeInfo[itemId].preBuyNum = info.preBuyNum
    end

    if info.modifiedFactor then
        allTradeInfo[itemId].modifiedFactor = info.modifiedFactor
    end

    -- local l_itemInfo = TableUtil.GetItemTable().GetRowByItemID(itemId)
    -- if l_itemInfo then
    local l_support = _isProMatch(MPlayerInfo.ProID, itemId)--Common.CommonUIFunc.GetIsContainProfession(MPlayerInfo.ProID, l_itemInfo.Profession)
    allTradeInfo[itemId].professionSupport = l_support and 1 or 0
    -- end
end

--- 判断职业是否能匹配上道具
function _isProMatch(proID, itemID)
    local target = ItemProOffLineMap[itemID]
    if nil == target then
        return true
    end

    return nil ~= target[proID]
end

-- 获取商品信息
function GetTradeInfo(itemId)
    return allTradeInfo[itemId]
end

-- 获取分类信息
function GetClassInfo()
    return classInfo
end

-- 获取某个分类的具体信息
function GetItemClassInfoByClassId(classId)
    return itemClassInfo[classId]
end

-- 获取排序物品
function GetCommoditSorted()
    return commoditSorted
end

-- 获取预购/关注物品列表
function GetPreBuyList()
    local l_preBuyList = {}
    for id, info in pairs(allTradeInfo) do
        if info.isFollow or info.preBuyNum > LongZero then
            local l_commoditRow = TableUtil.GetCommoditTable().GetRowByCommoditID(id)
            table.insert(l_preBuyList, { id = id, table = l_commoditRow })
        end
    end
    return l_preBuyList
end

-- 设置开启状态
function SetOpenState(classId, info)
    if classId == nil or info == nil then
        return
    end
    openState[classId] = openState[classId] or {}
    if info.id ~= nil then
        openState[classId].id = info.id
    end
    if info.isOpen ~= nil then
        openState[classId].isOpen = info.isOpen
    end
    if info.openTime ~= nil then
        openState[classId].openTime = info.openTime
    end
    if info.openSec ~= nil then
        openState[classId].openSec = info.openSec
    end
    if info.openDes ~= nil then
        openState[classId].openDes = info.openDes
    end
end

-- 分类是否开启
function IsClassOpen(classId)
    return openState[classId] and openState[classId].isOpen
end

-- 获取开启状态
function GetOpenState(classId)
    return openState[classId]
end

return ModuleData.TradeData