---@module ModuleMgr.GiftMgr
module("ModuleMgr.GiftMgr", package.seeall)

EventDispatcher = EventDispatcher.new()

SelectGiftItem = "SelectGiftItem"
GiveGiftsSuccess = "GiveGiftsSuccess"
--ScrollRect 索引
g_currentSelectFriendIndex = 1
--选择赠送的玩家
g_currentSelectFriend = nil
--次数
g_giftTimesInfo = nil
--礼物类型
g_giftType = 0
--选择赠送的玩家UID
g_currentSelectFriendUID = nil
--当前赠送的礼物
g_giftItems = {}

--当前赠送的数量
g_giftCount = 0
g_friendsList = {}

--- 这个函数目前只处理增加道具有关的事情，如果开界面的过程中道具数量有减少，是不处理的
---@param itemUpdateData ItemUpdateData
---@param giftDataList GiftItemData[]
function UpdateAllGiftInfo(itemUpdateData, giftDataList)
    if nil == itemUpdateData then
        logError("[GiftMgr] invalid item update data")
        return
    end

    local itemCompareData = itemUpdateData:GetItemCompareData()
    if 0 >= itemCompareData.count then
        return
    end

    local giftConfig = TableUtil.GetGiftTable().GetRowByItemID(itemCompareData.id, true)
    if nil == giftConfig or 0 > giftConfig.FriendDegree or g_giftType ~= giftConfig.GiftType then
        return
    end

    for i = 1, #giftDataList do
        local singleGiftInfo = giftDataList[i]
        if uint64.equals(singleGiftInfo.Item.UID, itemCompareData.uid) then
            singleGiftInfo.Item = itemUpdateData.NewItem
            return
        end
    end

    local newData = {
        Item = itemUpdateData.NewItem,
        count = 0
    }

    table.insert(giftDataList, newData)
    return giftDataList
end

--得到背包里所有可以赠送的物品
---@return GiftItemData[]
function GetGiftItem()
    local l_giftItems = {}

    --得到背包中所有道具数据
    local l_bagItems = _getItemsInBag()

    --摆摊表数据
    for _, propInfo in pairs(l_bagItems) do
        local l_giftRow = TableUtil.GetGiftTable().GetRowByItemID(propInfo.TID, true)
        --判断这个道具是否可以赠送
        if l_giftRow and l_giftRow.FriendDegree >= 0 and l_giftRow.GiftType == g_giftType then
            table.insert(l_giftItems, {
                Item = propInfo,
                count = 0
            })
        end
    end

    return l_giftItems
end

--- 获取背包中的道具
---@return ItemData[]
function _getItemsInBag()
    local types = { GameEnum.EBagContainerType.Bag }
    local items = Data.BagApi:GetItemsByTypesAndConds(types, nil)
    return items
end

--点击玩家头像 赠送礼物
function TouchPlayer(uid)
    g_currentSelectFriendUID = uid
    local l_msgId = Network.Define.Rpc.GetGiftLimitInfo
    ---@type GetGiftLimitInfoArg
    local l_sendInfo = GetProtoBufSendTable("GetGiftLimitInfoArg")
    l_sendInfo.role_uid = g_currentSelectFriendUID
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--赠送礼物
function SendGifts()
    if #g_giftItems < 1 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("NO_SELECT_GIFTS"))
        return
    end
    local l_msgId = Network.Define.Rpc.GiveGifts
    ---@type GiveGiftsArg
    local l_sendInfo = GetProtoBufSendTable("GiveGiftsArg")
    l_sendInfo.role_uid = g_currentSelectFriend.friend_list.uid
    for i = 1, #g_giftItems do
        local l_itemInfo = l_sendInfo.uid_items:add()
        if g_giftType == 1 or g_giftType == 0 or g_giftType == 3 then
            l_itemInfo.item_uid = g_giftItems[i].uid
            l_itemInfo.item_count = g_giftItems[i].count
        end
        if g_giftType == 2 then
            l_itemInfo.virtual_item_id = g_giftItems[i].itemID
            l_itemInfo.item_count = g_giftItems[i].count
        end
    end
    l_sendInfo.gift_type = g_giftType
    --g_giftItems背包数据到了会重新分配table，所以此处需传其引用传
    Network.Handler.SendRpc(l_msgId, l_sendInfo,g_giftItems)
end

--获取好友列表
function GetGiftLimitInfo(msg)
    ---@type GetGiftLimitInfoRes
    local l_info = ParseProtoBufToTable("GetGiftLimitInfoRes", msg)
    if l_info.result ~= 0 then
        ErrorTips(l_info.result)
        return
    end

    g_friendsList = l_info.limit_list

    --打开赠送礼物UI
    UIMgr:ActiveUI(UI.CtrlNames.Gift)
end

--赠送礼物成功
function GiveGiftsSucess(msg, arg, customData)
    ---@type GiveGiftsRes
    local l_info = ParseProtoBufToTable("GiveGiftsRes", msg)
    if l_info.result ~= 0 then
        ErrorTips(l_info.result)
        return
    end
    --logError(tostring(l_info))
    --道具提示用
    local l_items = {}
    local l_ishave = false

    if customData ~=nil then
        for i = 1, #customData do
            local l_sendGiftData = customData[i]
            l_ishave = false
            for j = 1, #l_items do
                if l_items[j].itemID == l_sendGiftData.itemID then
                    l_items[j].count = l_items[j].count + l_sendGiftData.count
                    l_ishave = true
                    break
                end
            end

            if not l_ishave then
                table.insert(l_items, l_sendGiftData)
            end
        end
    end
    --弹出赠送道具提示框
    local l_name = StringEx.Format(Common.Utils.Lang("GIVE_GIFTS_SUCESS"), g_currentSelectFriend.friend_list.base_info.name)
    for i = 1, #l_items do
        local l_opt = {
            itemId = l_items[i].itemID,
            itemOpts = { num = l_items[i].count, icon = { size = 18, width = 1.4 } },
            title = l_name, --标题
        }
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_opt)
    end

    local l_giftTimes = l_info.gift_times
    --重置与该玩家的次数
    g_giftTimesInfo.gift_recipient_times = l_giftTimes.gift_recipient_times
    g_giftTimesInfo.present_times[1] = l_giftTimes.present_times[1]
    EventDispatcher:Dispatch(GiveGiftsSuccess)
end

--错误提示
function ErrorTips(result)
    local tips = ""
    if result == ErrorCode.ERR_GIFT_TAKE_PRESENT_TIMES_FAILED then
        tips = Common.Utils.Lang("ERR_GIFT_TAKE_PRESENT_TIMES_FAILED")
    elseif result == ErrorCode.ERR_GIFT_TAKE_RECIPIENT_TIMES_FAILED then
        tips = Common.Utils.Lang("ERR_GIFT_TAKE_RECIPIENT_TIMES_FAILED")
    elseif result == ErrorCode.ERR_GIFT_CHECK_FRIEND_INTIMACY_FAILED then
        tips = Common.Utils.Lang("ERR_GIFT_CHECK_FRIEND_INTIMACY_FAILED")
    elseif result == ErrorCode.ERR_GIFT_CHECK_ITEM_LIST_FAILED then
        tips = Common.Utils.Lang("ERR_GIFT_CHECK_ITEM_LIST_FAILED")
    elseif result == ErrorCode.ERR_GIFT_CHECK_ITEM_COUNT_FAILED then
        tips = Common.Utils.Lang("ERR_GIFT_CHECK_ITEM_COUNT_FAILED")
    elseif result == ErrorCode.ERR_MS_NOT_HAVE_GIFT_LIMIT_DATA then
        tips = Common.Utils.Lang("ERR_MS_NOT_HAVE_GIFT_LIMIT_DATA")
    end
    local l_ui = UIMgr:GetUI(UI.CtrlNames.Gift)
    if l_ui ~= nil then
        l_ui:ResetGifts()
    end
    if string.ro_isEmpty(tips) then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(result))
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(tips)
    end
end

return ModuleMgr.GiftMgr