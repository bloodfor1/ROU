---
--- Created by chauncyhu.
--- DateTime: 2018/7/3 11:46
---
---@module ModuleMgr.StallMgr
module("ModuleMgr.StallMgr", package.seeall)

--===================================filed==============================================================================

--------------------------------事件相关------------------------------------------------
EventDispatcher = EventDispatcher.new()
ON_STALL_GET_MARK_INFO_RSP = "ON_STALL_GET_MARK_INFO_RSP"
ON_STALL_GET_ITEM_INFO_RSP = "ON_STALL_GET_ITEM_INFO_RSP"
ON_CLICK_STALL_BUY_BTN = "ON_CLICK_STALL_BUY_BTN"
ON_CLICK_STALL_PARENT_BTN = "ON_CLICK_STALL_PARENT_BTN"
ON_STALL_ITEM_BUY_RSP = "ON_STALL_ITEM_BUY_RSP"
ON_STALL_REFRESH_RSP = "ON_STALL_REFRESH_RSP"
ON_STALL_SELL_ITEM_RSP = "ON_STALL_SELL_ITEM_RSP"
ON_STALL_SELL_ITEM_CANCEL_RSP = "ON_STALL_SELL_ITEM_CANCEL_RSP"
ON_STALL_DRAWMONEY_RSP = "ON_STALL_DRAWMONEY_RSP"
ON_STALL_BUY_STALL_COUNT_RSP = "ON_STALL_BUY_STALL_COUNT_RSP"
ON_STALL_GET_SELL_INFO_RSP = "ON_STALL_GET_SELL_INFO_RSP"
ON_STALL_GET_PRE_SELL_ITEM_INFO_RSP = "ON_STALL_GET_PRE_SELL_ITEM_INFO_RSP"
ON_STALL_GET_PRE_SELL_ITEM_INFO_RSP_FASTMOUNTING = "ON_STALL_GET_PRE_SELL_ITEM_INFO_RSP_FASTMOUNTING"   --来自快速上架界面
ON_STALL_ITEM_SOLD_NOTIFY = "ON_STALL_ITEM_SOLD_NOTIFY"
ON_CLICK_REPEAT_BTN = "ON_CLICK_REPEAT_BTN"
ON_CLICK_SELL_ITEM = "ON_CLICK_SELL_ITEM"
ON_CLICK_SELL_SELECT_ITEM = "ON_CLICK_SELL_SELECT_ITEM"       --售卖物品选择item点击事件
ON_FAST_SELL_ITEM_CLICKED = "ON_FAST_SELL_ITEM_CLICKED"    --快速售卖物品选择item点击事件
--------------------------------事件相关------------------------------------------------

g_init = false

local l_tableInit = false
local g_curWaitMessage = nil
g_tableInfo = {}
g_tableItemInfo = {}
g_secIndex2ItemId = {} ---便于查找itemid
g_curTypeIndex = 1
g_curSecTypeIndex = nil
g_curTargetIndex = nil
g_nextRefreshTime = nil
g_allMarkInfo = {}
g_allItemInfo = {}
g_sellItemInfo = {}
g_basePriceInfo = {}
g_nextStallPrice = nil
g_noticeState = false
G_FIXED_REFRESH_INTERVAL = 5
g_lastTime = 0
g_cansell = false
g_searchStallItemId = nil
g_isBuyPanel = true
g_targetSellItemId = nil
g_curSelectFilter = nil
g_tab = {}

function OnLogout()
    g_init = false
    l_tableInit = false
    g_tableInfo = {}
    g_tableItemInfo = {}
    g_secIndex2ItemId = {}
    g_curTypeIndex = 1
    g_curSecTypeIndex = nil
    g_curTargetIndex = nil
    g_nextRefreshTime = nil
    g_allMarkInfo = {}
    g_allItemInfo = {}
    g_sellItemInfo = {}
    g_basePriceInfo = {}
    g_nextStallPrice = nil
    g_noticeState = false
    g_lastTime = 0
    g_cansell = false
    g_searchStallItemId = nil
    g_isBuyPanel = true
    g_targetSellItemId = nil
    g_curWaitMessage = nil
end

function OnReconnected()
    g_curWaitMessage = nil
end

function OnLogout()
    g_curWaitMessage = nil
end
--===================================table info==============================================================================

function InitTable()
    if not l_tableInit then
        l_tableInit = true
        g_tableInfo = {}
        g_secIndex2ItemId = {}
        g_tab = {}
        local l_indexTable = TableUtil.GetStallIndexTable().GetTable()
        for i = 1, #l_indexTable do
            local l_id = l_indexTable[i].ID
            if l_indexTable[i].Tab == nil or l_indexTable[i].Tab == 0 then
                local l_index = #g_tab + 1
                g_tab[l_index] = {}
                g_tab[l_index].id = l_id
                g_tab[l_index].son = {}
            else
                local l_parent = l_indexTable[i].Tab
                local l_targetIndex = nil
                for i = 1, #g_tab do
                    if g_tab[i].id == l_parent then
                        l_targetIndex = i
                        break
                    end
                end
                if not l_targetIndex then
                    l_targetIndex = #g_tab + 1
                    g_tab[l_targetIndex] = {}
                    g_tab[l_targetIndex].id = l_parent
                    g_tab[l_targetIndex].son = {}
                end
                local l_index = #(g_tab[l_targetIndex].son) + 1
                g_tab[l_targetIndex].son[l_index] = l_id
            end
            local l_indexList = GetAllIndex(l_id)

            g_tableInfo[l_id] = {}
            g_tableInfo[l_id].id = l_id ---index 表里面的id
            ---一级目录;
            g_tableInfo[l_id].indexList = l_indexList---index 表里面的所有二级目录id集合
            g_tableInfo[l_id].secList = {}
            if #l_indexList > 0 then
                for i = 1, #l_indexList do
                    ---二级目录;
                    local l_secIndex = l_indexList[i]
                    local l_result = GetDetailIndexList(l_secIndex)
                    local l_limit = GetLimitIndexList(l_result)
                    local l_target
                    local l_targetIndex
                    if l_limit == nil then
                        l_target = nil
                        l_targetIndex = 0
                    else
                        l_target, l_targetIndex = GetLimitTargetIndex(l_result)
                    end

                    g_tableInfo[l_id].secList[l_secIndex] = {} ---一个二级目录的信息

                    ---一个二级目录的所有子id:区别为是否有等级搜索
                    g_tableInfo[l_id].secList[l_secIndex].detailIndexList = l_result
                    --TODO:不存在等级索引的，#g_tableInfo[l_id].secList[l_secIndex].detailIndexList = 1
                    ---一个二级目录的所有子id对应的搜索集合(只是id)
                    g_tableInfo[l_id].secList[l_secIndex].limitIndexList = l_limit
                    ---一个二级目录的所有子id对应的搜索集合中间的适合目前等级的目标
                    g_tableInfo[l_id].secList[l_secIndex].target = l_target
                    ---上面这个目标在所有目标中的顺序
                    g_tableInfo[l_id].secList[l_secIndex].targetIndex = l_targetIndex
                    if #g_tableInfo[l_id].secList[l_secIndex].detailIndexList == 1 then
                        g_tableInfo[l_id].secList[l_secIndex].limitIndexList = nil
                        g_tableInfo[l_id].secList[l_secIndex].target = l_result[1]
                        g_tableInfo[l_id].secList[l_secIndex].targetIndex = nil
                    end
                    --local l_max = 0
                    --for i, v in pairs(g_tableInfo[l_id].secList[l_secIndex].detailIndexList) do
                    --    l_max = v.ChooseNumber + l_max
                    --end
                    --g_tableInfo[l_id].secList[l_secIndex].ChooseNumber = l_max

                    if l_result[i] then
                        g_secIndex2ItemId[l_secIndex] = {}
                        g_secIndex2ItemId[l_secIndex].itemId = l_result[1].ItemID
                    end
                end
            end
        end
        --背包
        g_tableItemInfo = {}
        local l_table = TableUtil.GetStallDetailTable().GetTable()
        for i, v in pairs(l_table) do
            if v.Enable then
                local l_itemId = v.ItemID
                local l_index1 = v.Index1
                local l_index2 = v.Index2
                g_tableItemInfo[l_itemId] = {}
                g_tableItemInfo[l_itemId].info = v
            end
        end
    end
end

function GetParentIdBySonId(id)
    for i = 1, #g_tab do
        if #(g_tab[i].son) > 0 then
            for j = 1, #(g_tab[i].son) do
                if id == g_tab[i].son[j] then
                    return g_tab[i].id
                end
            end
        end
    end
    return id
end

function GetAllIndex(id)
    --id:index table id
    local l_data = TableUtil.GetStallIndexTable().GetRowByID(id)
    local result = {}
    local i, sum = 1, 1
    while i <= l_data.IndexList.Length do
        if #GetDetailIndexList(l_data.IndexList[i - 1]) > 0 then
            result[sum] = l_data.IndexList[i - 1]
            sum = sum + 1
        end
        i = i + 1
    end
    return result
end

function GetDetailIndexList(index)
    --index:index
    local l_result = {}
    local l_table = TableUtil.GetStallDetailTable().GetTable()
    for i, v in pairs(l_table) do
        if v.Enable and tostring(v.Index1) == tostring(index) then
            local l_index = #l_result + 1
            l_result[l_index] = v
        end
    end
    return l_result
end

function GetLimitIndexList(list)
    ---list:DetailIndexList
    local l_result = {}
    for i = 1, #list do
        local l_index = #l_result + 1
        if list[i].Index2 == nil then
            return nil
        end
        l_result[l_index] = list[i].Index2
    end
    return l_result
end

function GetLimitTargetIndex(list)
    ---list:DetailIndexList
    local l_target = nil
    local l_index = 0
    local l_v = MPlayerInfo.Lv
    for i = 1, #list do
        local l_min = list[i].LevelIndex:get_Item(0)
        local l_max = list[i].LevelIndex:get_Item(1)
        if l_v >= l_min and l_v <= l_max then
            l_target = list[i]
            l_index = i
            break
        end
    end
    if l_target == nil then
        l_target = list[1]
        l_index = 0
    end
    return l_target, l_index
end

--获取摆摊物品的剩余时间
function GetSellItemLeftTimeByUid(uid)
    for _, v in pairs(g_sellItemInfo) do
        if v.uid == uid then
            return v.leftTime
        end
    end
    return 0
end


function GetSuperLimitTargetIndex(secType, list)
    ---list:DetailIndexList
    local l_target = nil
    local l_index = 0
    local l_v = MPlayerInfo.Lv
    local l_secNum = g_allMarkInfo[secType].secNum
    for i = 1, #list do
        local l_min = list[i].LevelIndex:get_Item(0)
        local l_max = list[i].LevelIndex:get_Item(1)
        local l_index2 = list[i].Index2
        if l_v >= l_min and l_v <= l_max and l_secNum and l_secNum[l_index2] and l_secNum[l_index2] > 0 then
            l_target = list[i]
            l_index = i
            break
        end
    end
    return l_target, l_index
end

function GetTypeInfoByIndex(index)
    local l_data = TableUtil.GetStallIndexDescTable().GetRowByID(index)
    local l_name = ""
    local l_atlas = ""
    local l_icon = ""
    if l_data then
        l_name = l_data.Name
        l_atlas = l_data.Atlas
        l_icon = l_data.Icon
        if l_atlas ~= "" then
            return l_name, l_atlas, l_icon
        end
    end
    local l_target = g_secIndex2ItemId[index]
    if l_target then
        l_data = TableUtil.GetItemTable().GetRowByItemID(l_target.itemId)
        l_name = l_data.ItemName
        l_atlas = l_data.ItemAtlas
        l_icon = l_data.ItemIcon
    end
    return l_name, l_atlas, l_icon
end

-- 获取摆摊上架的物品
function GetStallItems()
    local l_resultItems = {}
    local l_items = MgrMgr:GetMgr("ItemContainerMgr").GetBagItemsByTidHashTable(g_tableItemInfo)
    for _, item in ipairs(l_items) do
        table.insert(l_resultItems, {itemData = item})
    end
    return l_resultItems
end


--===================================net info==============================================================================

---获取二级页签信息
function SendStallGetMarkInfoReq(id)
    local l_msgId = Network.Define.Rpc.StallGetMarkInfo
    ---@type StallGetMarkInfoArg
    local l_sendInfo = GetProtoBufSendTable("StallGetMarkInfoArg")
    l_sendInfo.id = id
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnStallGetMarkInfoRsp(msg, arg)
    ---@type StallGetMarkInfoRes
    local l_info = ParseProtoBufToTable("StallGetMarkInfoRes", msg)
    if l_info.error_code ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
    else
        g_lastTime = 0
        local l_rspId = arg.id
        g_nextRefreshTime = tonumber(l_info.next_refresh_time)
        local l_count = #l_info.mark_list
        if l_count > 0 then
            for i = 1, l_count do
                local l_target = l_info.mark_list[i]
                local l_id = l_target.id
                local l_num = l_target.count
                g_allMarkInfo[l_id] = {}
                g_allMarkInfo[l_id].num = l_num
                g_allMarkInfo[l_id].secNum = nil
                local l_secNum = #l_target.second_mark_list
                if l_secNum > 0 then
                    g_allMarkInfo[l_id].secNum = {}
                    for i = 1, l_secNum do
                        local l_secTarget = l_target.second_mark_list[i]
                        local l_secId = l_secTarget.id
                        local l_secNum = l_secTarget.count
                        g_allMarkInfo[l_id].secNum[l_secId] = l_secNum
                    end
                end
            end
        end

        EventDispatcher:Dispatch(ON_STALL_GET_MARK_INFO_RSP, l_rspId)
    end
    --Common.Functions.DumpTable(g_allMarkInfo, "<var>", 6)
end

---获取物品信息
function SendStallGetItemInfoReq(id)
    local l_msgId = Network.Define.Rpc.StallGetItemInfo
    ---@type StallGetItemInfoArg
    local l_sendInfo = GetProtoBufSendTable("StallGetItemInfoArg")
    l_sendInfo.item_id = id
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnStallGetItemInfoRsp(msg, arg)
    ---@type StallGetItemInfoRes
    local l_info = ParseProtoBufToTable("StallGetItemInfoRes", msg)

    if l_info.error_code ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
    else
        g_lastTime = 0
        local l_rspId = arg.item_id
        g_allItemInfo[l_rspId] = {}
        g_nextRefreshTime = tonumber(l_info.next_refresh_time)
        for i = 1, #l_info.item_list do
            local l_stallItemPb = l_info.item_list[i]
            ---@type ItemData
            local l_itemInfo = Data.BagApi:CreateFromRoItemData(l_stallItemPb.item_info)
            local l_id = l_itemInfo.TID
            local l_index = #g_allItemInfo[l_id] + 1
            g_allItemInfo[l_id][l_index] = {}
            g_allItemInfo[l_id][l_index].itemInfo = l_itemInfo
            g_allItemInfo[l_id][l_index].uid = l_stallItemPb.item_uuid
            g_allItemInfo[l_id][l_index].id = l_id
            g_allItemInfo[l_id][l_index].count = l_itemInfo.ItemCount
            g_allItemInfo[l_id][l_index].price = l_stallItemPb.item_price
            g_allItemInfo[l_id][l_index].leftTime = l_stallItemPb.left_time
        end


        EventDispatcher:Dispatch(ON_STALL_GET_ITEM_INFO_RSP, l_rspId)
    end
end

---购买
-- totalCost isNotCheck 是否进行快捷兑换的检测
function SendStallItemBuyReq(id, count, totalCost ,isNotCheck)

    if totalCost and totalCost > 0 then
        local l_curCoinId = GameEnum.l_virProp.Coin101
        local _,l_needNum = Common.CommonUIFunc.ShowCoinStatusText(l_curCoinId,totalCost)
        if l_needNum > 0 and not isNotCheck then
            MgrMgr:GetMgr("CurrencyMgr").ShowQuickExchangePanel(l_curCoinId,l_needNum,function ()
                SendStallItemBuyReq(id, count, totalCost, true)
            end)
            return
        end
    end

    local l_msgId = Network.Define.Rpc.StallItemBuy
    ---@type StallItemBuyArg
    local l_sendInfo = GetProtoBufSendTable("StallItemBuyArg")
    l_sendInfo.item_uuid = id
    l_sendInfo.item_count = tostring(count)
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnStallItemBuyRsp(msg, arg)
    ---@type StallItemBuyRes
    local l_info = ParseProtoBufToTable("StallItemBuyRes", msg)
    local l_errorNo = l_info.error.errorno
    local l_id = arg.item_uuid
    if l_errorNo ~= ErrorCode.ERR_SUCCESS then
        MgrMgr:GetMgr("ComErrorCodeMgr").ShowMarkedWords(l_info.error)
        if l_errorNo == 1102 or l_errorNo == 1103 then
            EventDispatcher:Dispatch(ON_STALL_ITEM_BUY_RSP, l_id)
        end
    else
        EventDispatcher:Dispatch(ON_STALL_ITEM_BUY_RSP, l_id)
        MgrMgr:GetMgr("AdjustTrackerMgr").TrackEvent(GameEnum.AdjustTrackerEvent.StallPurchaseComplete)
    end
end

---刷新 price=消耗 isNotCheck = false  不进行货币检测 默认为false
function SendStallRefreshReq(id,price,isNotCheck)

    local l_curCoinId = GameEnum.l_virProp.Coin102
    local _,l_needNum = Common.CommonUIFunc.ShowCoinStatusText(l_curCoinId,price)
    if l_needNum > 0 and not isNotCheck then
        MgrMgr:GetMgr("CurrencyMgr").ShowQuickExchangePanel(l_curCoinId,l_needNum,function ()
            SendStallRefreshReq(id,price,true)
        end)
        return
    end

    local l_msgId = Network.Define.Rpc.StallRefresh
    ---@type StallRefreshArg
    local l_sendInfo = GetProtoBufSendTable("StallRefreshArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnStallRefreshRsp(msg)
    ---@type StallRefreshRes
    local l_info = ParseProtoBufToTable("StallRefreshRes", msg)
    if l_info.error_code ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
    else
        EventDispatcher:Dispatch(ON_STALL_REFRESH_RSP)
    end
end

------获取出售信息
function SendStallGetSellInfoReq()
    local l_msgId = Network.Define.Rpc.StallGetSellInfo
    ---@type StallGetSellInfoArg
    local l_sendInfo = GetProtoBufSendTable("StallGetSellInfoArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnStallGetSellInfoRsp(msg)
    ---@type StallGetSellInfoRes
    local l_info = ParseProtoBufToTable("StallGetSellInfoRes", msg)
    if l_info.error_code ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
    else
        g_sellItemInfo = {}
        local l_count = #l_info.item_list
        if l_count > 0 then
            local l_normalTab = {}
            local l_specialTab = {}
            for i = 1, l_count do
                local l_stallItemPb = l_info.item_list[i]
                ---@type ItemData
                local l_itemInfo = Data.BagApi:CreateFromRoItemData(l_stallItemPb.item_info)
                local l_index = l_count - i + 1
                g_sellItemInfo[l_index] = {}
                g_sellItemInfo[l_index].itemInfo = l_itemInfo
                g_sellItemInfo[l_index].uid = l_stallItemPb.item_uuid
                g_sellItemInfo[l_index].id = l_itemInfo.TID
                g_sellItemInfo[l_index].count = l_itemInfo.ItemCount
                g_sellItemInfo[l_index].price = l_stallItemPb.item_price
                g_sellItemInfo[l_index].money = l_stallItemPb.money
                g_sellItemInfo[l_index].leftTime = l_stallItemPb.left_time ---超时剩余时间
            end
            for i = 1, #g_sellItemInfo do
                if g_sellItemInfo[i].leftTime <= 0 then
                    local l_index = #l_specialTab + 1
                    l_specialTab[l_index] = g_sellItemInfo[i]
                else
                    local l_index = #l_normalTab + 1
                    l_normalTab[l_index] = g_sellItemInfo[i]
                end
            end
            g_sellItemInfo = l_normalTab
            for i = 1, #l_specialTab do
                local l_index = #g_sellItemInfo + 1
                g_sellItemInfo[l_index] = l_specialTab[i]
            end
        end
        EventDispatcher:Dispatch(ON_STALL_GET_SELL_INFO_RSP)
    end
end

--获取上架物品信息
function SendStallGetPreSellItemInfoReq(id, fastMountingInfo)
    if g_curWaitMessage ~= nil then
        return
    end
    g_curWaitMessage = Network.Define.Rpc.StallGetPreSellItemInfo
    local l_msgId = Network.Define.Rpc.StallGetPreSellItemInfo
    ---@type StallGetPreSellItemInfoArg
    local l_sendInfo = GetProtoBufSendTable("StallGetPreSellItemInfoArg")
    l_sendInfo.item_id = id
    Network.Handler.SendRpc(l_msgId, l_sendInfo, fastMountingInfo)
end

function OnStallGetPreSellItemInfoRsp(msg, arg, fastMountingInfo)
    g_curWaitMessage = nil
    ---@type StallGetPreSellItemInfoRes
    local l_info = ParseProtoBufToTable("StallGetPreSellItemInfoRes", msg)
    if l_info.error_code ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
    else
        local l_id = arg.item_id
        g_basePriceInfo[l_id] = l_info.base_price

        if fastMountingInfo then
            EventDispatcher:Dispatch(ON_STALL_GET_PRE_SELL_ITEM_INFO_RSP_FASTMOUNTING, fastMountingInfo.uid)
        else
            EventDispatcher:Dispatch(ON_STALL_GET_PRE_SELL_ITEM_INFO_RSP, l_id)
        end
    end
end

---上架
function SendStallSellItemReq(itemList,totalCost,isNotCheck)
    if not itemList or #itemList == 0 then return end
    
    local l_msgId = Network.Define.Rpc.StallSellItem
    ---@type StallSellItemArg
    local l_sendInfo = GetProtoBufSendTable("StallSellItemArg")
    --DumpTable(l_sendInfo, "111", 6)
    local totalPrice = ""
    for _, itemInfo in ipairs(itemList) do
        local l_item = l_sendInfo.item_list:add()
        l_item.item_info.uid = itemInfo.uid
        l_item.item_info.item_id = itemInfo.id
        l_item.item_info.item_count = tostring(itemInfo.count)
        l_item.item_price = tostring(itemInfo.price)
    end

    if totalCost and totalCost > 0 then
        local l_curCoinId = GameEnum.l_virProp.Coin101
        local _,l_needNum = Common.CommonUIFunc.ShowCoinStatusText(l_curCoinId,totalCost)
        if l_needNum > 0 and not isNotCheck then
            MgrMgr:GetMgr("CurrencyMgr").ShowQuickExchangePanel(l_curCoinId,l_needNum,function ()
                SendStallSellItemReq(itemList,totalCost,true)
            end)
            return
        end
    end

    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnStallSellItemRsp(msg, arg)
    ---@type StallSellItemRes
    local l_info = ParseProtoBufToTable("StallSellItemRes", msg)
    if l_info.error_code ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
    else
        local l_itemList = {}
        for _, item in ipairs(arg.item_list) do
            table.insert(l_itemList, {
                uid = item.item_info.uid,
                id = item.item_info.item_id,
                count = item.item_info.item_count,
                price = item.item_price
            })
        end
        EventDispatcher:Dispatch(ON_STALL_SELL_ITEM_RSP, l_itemList)
    end
end

local l_reItemId = nil
local l_reCount = nil

---重新上架
function SendStallReSellItemReq(itemId, uuid, price, count)
    local l_msgId = Network.Define.Rpc.StallReSellItem
    ---@type StallReSellItemArg
    local l_sendInfo = GetProtoBufSendTable("StallReSellItemArg")
    l_reItemId = itemId
    l_reCount = count
    l_sendInfo.item_uuid = uuid
    --l_sendInfo.item_count = MLuaCommonHelper.Long2Int(count)
    l_sendInfo.price = price
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnStallReSellItemRsp(msg, arg)
    ---@type StallSellItemRes
    local l_info = ParseProtoBufToTable("StallSellItemRes", msg)
    if l_info.error_code ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
    else
        local l_uid = arg.item_uuid
        local l_price = arg.price
        --TODO：这里=。=
        EventDispatcher:Dispatch(ON_STALL_SELL_ITEM_RSP, {{uid = l_uid, id = l_reItemId, count = l_reCount, price = l_price}})
    end
end

---下架
function SendStallSellItemCancelReq(uidList)
    if not uidList or #uidList == 0 then return end

    local l_msgId = Network.Define.Rpc.StallSellItemCancel
    ---@type StallSellItemCancelArg
    local l_sendInfo = GetProtoBufSendTable("StallSellItemCancelArg")
    for _, uid in ipairs(uidList) do
        local l_pbint64 = l_sendInfo.item_list:add()
        l_pbint64.value = uid
    end
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnStallSellItemCancelRsp(msg, arg)
    ---@type StallSellItemCancelRes
    local l_info = ParseProtoBufToTable("StallSellItemCancelRes", msg)
    local l_errorNo = l_info.error.errorno or ErrorCode.ERR_SUCCESS
    if l_errorNo ~= ErrorCode.ERR_SUCCESS then
        MgrMgr:GetMgr("ComErrorCodeMgr").ShowMarkedWords(l_info.error)
    else
        local l_uidList = {}
        for _, pbint64 in ipairs(arg.item_list) do
            table.insert(l_uidList, tonumber(pbint64.value))
        end
        EventDispatcher:Dispatch(ON_STALL_SELL_ITEM_CANCEL_RSP, l_uidList)
    end
end

---提现
function SendStallDrawMoneyReq(id)
    local l_msgId = Network.Define.Rpc.StallDrawMoney
    ---@type StallDrawMoneyArg
    local l_sendInfo = GetProtoBufSendTable("StallDrawMoneyArg")
    l_sendInfo.item_uuid = id
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnStallDrawMoneyRsp(msg, arg)
    ---@type StallDrawMoneyRes
    local l_info = ParseProtoBufToTable("StallDrawMoneyRes", msg)
    if l_info.error_code ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
    else
        local l_id = arg.item_uuid
        EventDispatcher:Dispatch(ON_STALL_DRAWMONEY_RSP, l_id)
    end
end

---摊位购买
function SendStallBuyStallCountReq()
    local l_msgId = Network.Define.Rpc.StallBuyStallCount
    ---@type StallBuyStallCountArg
    local l_sendInfo = GetProtoBufSendTable("StallBuyStallCountArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnStallBuyStallCountRsp(msg)
    ---@type StallBuyStallCountRes
    local l_info = ParseProtoBufToTable("StallBuyStallCountRes", msg)
    if l_info.error_code == ErrorCode.ERR_IN_PAYING then
        game:GetPayMgr():RegisterPayResultCallback(Network.Define.Rpc.StallBuyStallCount, OnStallBuySuccess)
        g_nextStallPrice = l_info.next_stall_unlock_price
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
    end
end

function OnStallBuySuccess()
    EventDispatcher:Dispatch(ON_STALL_BUY_STALL_COUNT_RSP)
end

function OnStallItemSoldNotify(msg)
    g_noticeState = true
    --TODO:红点显示
    EventDispatcher:Dispatch(ON_STALL_ITEM_SOLD_NOTIFY)
end

--===================================buy info==============================================================================

function OnSelectRoleNtf(info)

    OnLogin()
end

function OnLogin()
    InitTable()
end

function OnInit()
    InitTable()
end

local l_fucn = nil

MgrMgr:GetMgr("RoleInfoMgr").EventDispatcher:Add(MgrMgr:GetMgr("RoleInfoMgr").ON_SERVER_LEVEL_UPDATE,
function()
    if l_fucn then
        l_fucn()
        l_fucn = nil
    end
end, MgrMgr:GetMgr("RoleInfoMgr"))

function RegisterUpdateServerLevelEvent(callback)
    l_fucn = callback
    MgrMgr:GetMgr("RoleInfoMgr").GetServerLevelBonusInfo()
end

function RequestStallInfo()
    RegisterUpdateServerLevelEvent(function()
        SendStallGetSellInfoReq()
        SyncSearchIndexState()
        ---open stall
        if g_curTypeIndex then
            if g_curSecTypeIndex then
                local l_itemid = g_tableInfo[g_curTypeIndex].secList[g_curSecTypeIndex].target.ItemID
                l_itemid = g_searchStallItemId == nil and l_itemid or g_searchStallItemId
                g_searchStallItemId = nil
                SendStallGetItemInfoReq(l_itemid)
            end
        else
            --TODO:显示第一个二级目录
            g_curSecTypeIndex = nil
            g_curTargetIndex = nil
            g_curTypeIndex = 1
        end
        SendStallGetMarkInfoReq(g_curTypeIndex)
    end)
end

function SyncSearchIndexState()
    if g_searchStallItemId then
        local l_y, l_e, l_s = GetAllIndexByItemId(g_searchStallItemId)
        if not l_y then
            g_searchStallItemId = nil
            return
        end
        g_curTypeIndex = l_y
        g_curSecTypeIndex = l_e
        if not g_curSecTypeIndex then
            g_searchStallItemId = nil
        end
        g_curTargetIndex = l_s
    end
end

function GetTargetIndexByItemId(curTypeIndex, curSecTypeIndex, itemId)
    --logGreen("itemId:"..tostring(itemId))
    local l_result = g_tableInfo[curTypeIndex].secList[curSecTypeIndex]
    --Common.Functions.DumpTable(l_result, "<var>", 6)
    local l_limit = l_result.limitIndexList
    --Common.Functions.DumpTable(l_limit, "<var>", 6)
    ---有等级选项的情况
    local l_secIndex = nil
    for k, v in pairs(l_result.detailIndexList) do
        if itemId == v.ItemID then
            l_secIndex = v.Index2
            break
        end
    end
    if l_secIndex == nil then
        return nil
    end
    local l_target = nil
    for i = 1, #l_limit do
        if l_secIndex == l_limit[i] then
            l_target = i
            break
        end
    end
    return l_target
end

function GetTargetByItemId(curTypeIndex, curSecTypeIndex, itemId)
    --logGreen("itemId:"..tostring(itemId))
    local l_result = g_tableInfo[curTypeIndex].secList[curSecTypeIndex]
    --Common.Functions.DumpTable(l_result, "<var>", 6)
    local l_limit = l_result.limitIndexList
    --Common.Functions.DumpTable(l_limit, "<var>", 6)
    ---有等级选项的情况
    local l_secIndex = nil
    for k, v in pairs(l_result.detailIndexList) do
        if itemId == v.ItemID then
            l_secIndex = v.Index2
            break
        end
    end
    if l_secIndex == nil then
        return nil
    end
    local l_target = nil
    for i = 1, #l_limit do
        if l_secIndex == l_limit[i] then
            l_target = i
            break
        end
    end
    return l_target
end

function GetItemIdByTargetIndex(curTypeIndex, curSecTypeIndex, targetIndex)
    local l_result = g_tableInfo[curTypeIndex].secList[curSecTypeIndex]
    if not l_result then
        return nil
    end
    local l_limit = l_result.limitIndexList
    if l_limit == nil then
        return l_result.target.ItemID
    end
    local l_secIndex = l_limit[targetIndex]
    if l_secIndex == nil then
        return nil
    end

    for k, v in pairs(l_result.detailIndexList) do
        if l_secIndex == v.Index2 then
            return v.ItemID
        end
    end

    return nil
end

function GetAllIndexByItemId(itemId)
    --Common.Functions.DumpTable(g_tableItemInfo, "<var>", 6)
    local l_date = g_tableItemInfo[itemId]
    if not l_date then
        return nil
    end
    local l_mainIndex = nil
    local l_secIndex = l_date.info.Index1
    local l_targetIndex = nil
    for i, v in pairs(g_tableInfo) do
        if table.ro_contains(v.indexList, l_date.info.Index1) then
            l_mainIndex = v.id
            break
        end
    end
    if not l_mainIndex then
        return nil
    end
    local l_result = g_tableInfo[l_mainIndex].secList[l_secIndex]
    ---没等级选项的情况
    local l_limit = l_result.limitIndexList
    if l_limit == nil then
        if l_result.target.ItemID == itemId then
            return l_mainIndex, l_secIndex, l_targetIndex
        else
            return nil
        end
    end
    ---有等级选项的情况
    local l_targetIndex = GetTargetIndexByItemId(l_mainIndex, l_secIndex, itemId)
    if l_targetIndex == nil then
        return nil
    end
    return l_mainIndex, l_secIndex, l_targetIndex
end

--===================================sell info==============================================================================

function GetPriceRange(itemId, basePrice)
    local l_curPrice = tonumber(basePrice)
    local l_tableInfo = g_tableItemInfo[itemId]
    --Common.Functions.DumpTable(l_tableInfo.info, "<var>", 6)
    local l_min = l_tableInfo.info.PriceLimit:get_Item(0)
    local l_max = l_tableInfo.info.PriceLimit:get_Item(1)
    local l_originMinPrice = l_min
    local l_originMaxPrice = l_max
    l_curPrice = math.max(l_curPrice, l_min)
    l_curPrice = math.min(l_curPrice, l_max)
    local l_priceRangeMin = l_tableInfo.info.PriceFloatRange:get_Item(0)
    local l_priceRangeMax = l_tableInfo.info.PriceFloatRange:get_Item(1)
    l_min = math.max(l_min, l_curPrice * (1 + l_priceRangeMin / 100))
    l_max = math.min(l_max, l_curPrice * (1 + l_priceRangeMax / 100))
    local l_interval = l_tableInfo.info.SingleFloatRange
    local l_priceInterval = l_curPrice * (l_interval / 100)
    return math.modf(l_curPrice), math.modf(l_min), math.modf(l_max), l_priceInterval, l_min == l_max, l_originMinPrice, l_originMaxPrice
end

--获取推荐价格的提示信息
function GetRecommendedPriceTextAndColor(curPrice,basePrice)
    if basePrice == 0 then
        curPrice = 1
        basePrice = 1
    end
    local l_color1 = RoColor.Hex2Color(RoColor.WordColor.Blue[1])
    local l_color2 = RoColor.Hex2Color(RoColor.WordColor.Red[1])
    local l_color3 = RoColor.Hex2Color(RoColor.WordColor.Yellow[1])
    local l_rateData = ((curPrice-basePrice)/basePrice)*100
    local l_color = l_color1
    local l_str =""
    if l_rateData == 0 then
        l_color = l_color1
        l_str = "    "
    elseif l_rateData>0 then
        l_rateData = math.modf(l_rateData+0.5)
        l_str = "+"..tostring(l_rateData).."%"
        l_color = l_color3
    elseif l_rateData<0 then
        l_rateData = math.modf(l_rateData-0.5)
        l_str = tostring(l_rateData).."%"
        l_color = l_color2
    end
    l_str = StringEx.Format(Common.Utils.Lang("STALL_RECOMMAND_PRICE"),l_str)
    return l_str, l_color
end

return ModuleMgr.StallMgr