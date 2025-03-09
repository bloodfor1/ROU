---
--- Created by husheng.
--- DateTime: 2018/1/27 10:46
---
---@module ModuleMgr.NoticeMgr
module("ModuleMgr.NoticeMgr", package.seeall)

--底部公告来源
NoticeType = {
    GM = 0, --GM
    Award = 1, --奖励
}

--底部公告是否存在
IsSecondaryNotice = false
--公告显示的时长
SecondaryNoticeTimes = 0
--GM公告存在时间
NoticeSpeed = 10

AwardExpReason = GameEnum.AwardExpReason
local virProp = GameEnum.l_virProp
--播放公告的时间间隔
local duration = 0
--上次底部公告类型
local lastSecondaryNotice = NoticeType.GM
--GM公告队列
local gmNoticeList = {}
--底部公告队列
local secondaryNoticeList = {}
--奖励公告的存在最短时间
local showIntervalTime = tonumber(TableUtil.GetSocialGlobalTable().GetRowByName("SystemMessageMinTime").Value)
local specialTipQueue = {}
--是否再loading中
local isLoading = false
--缓存消息数据
local cacheMessageInfo = nil
local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")

--- 如果是表中的这些类型就直接忽略，不进行提示处理
local L_CONST_IGNORE_HASH_TABLE = {
    [ItemChangeReason.ITEM_REASON_NONE] = 1,
    [ItemChangeReason.ITEM_REASON_MOVE_ITEM] = 1,
    [ItemChangeReason.ITEM_REASON_USE] = 1,
    [ItemChangeReason.ITEM_REASON_CLEAR_TEMP_BAG] = 1,
    [ItemChangeReason.ITEM_REASON_JUNK] = 1,
    [ItemChangeReason.ITEM_REASON_TASK_REMOVE] = 1,
    [ItemChangeReason.ITEM_REASON_APPRAISE_EQUIP] = 1,
    [ItemChangeReason.ITEM_REASON_TASK_TAKE] = 1,
    [ItemChangeReason.ITEM_REASON_TASK_REWARD] = 1,
    [ItemChangeReason.ITEM_REASON_TURNTABLE_TICKTY] = 1,
    [ItemChangeReason.ITEM_REASON_TURNTABLE_WABAO] = 1,
    [ItemChangeReason.ITEM_REASON_COLLECT_FISHING] = 1,
    [ItemChangeReason.ITEM_REASON_HYMN_TRIAL] = 1,
    [ItemChangeReason.ITEM_REASON_CAT_TRADE_REWARD] = 1,
    [ItemChangeReason.ITEM_REASON_COOK_DUNGEONS] = 1,
    [ItemChangeReason.ITEM_REASON_THIRTY_SIGN_IN] = 1,
    [ItemChangeReason.ITEM_REASON_COBBLESTONE] = 1,
    [ItemChangeReason.ITEM_REASON_MAKE_STONE] = 1,
    [ItemChangeReason.ITEM_REASON_TOWER_DEFENSE_DUNGEON] = 1,
    [ItemChangeReason.ITEM_REASON_DUNGEON_WEEK] = 1,
    [ItemChangeReason.ITEM_REASON_TAKE_OFF_MULTI_EQUIP] = 1,
    [ItemChangeReason.ITEM_REASON_WEAR_MULTI_EQUIP] = 1,
}

local C_CONST_STALL_PURCHASE = {
    [ItemChangeReason.ITEM_REASON_TRADE_BUY] = 1,
    [ItemChangeReason.ITEM_REASON_TRADE_SELL] = 1,
    [ItemChangeReason.ITEM_REASON_ROLL_POINT] = 1,
    [ItemChangeReason.ITEM_REASON_FLOP] = 1,
    [ItemChangeReason.ITEM_REASON_ORNAMENT_DRAW] = 1,
    [ItemChangeReason.ITEM_REASON_DELEGATE_DARW_AWARD] = 1,
    [ItemChangeReason.ITEM_REASON_CARD_DRAW] = 1,
    [ItemChangeReason.ITEM_REASON_EQUIP_DRAW] = 1,
    [ItemChangeReason.ITEM_REASON_SELL_ITEM] = 1,
    [ItemChangeReason.ITEM_REASON_WEAR_EQUIP] = 1,
    [ItemChangeReason.ITEM_REASON_BATTLE_RESULT] = 1,
    [ItemChangeReason.ITEM_REASON_BATTLE_ASSIST_RESULT] = 1,
}

local C_GUILD_DINNER_NOTICE_MAP = {
    [ItemChangeReason.ITEM_REASON_CREAM_MELEE_WINNER] = Lang("GUILD_DINNER_FIGHT_WINNER_AWARD"),
    [ItemChangeReason.ITEM_REASON_CREAM_MELEE_WATCH] = Lang("GUILD_DINNER_FIGHT_WATCH_AWARD"),
}

-- 拍卖竞拍失败
local C_AUCTION_BID_FAIL = {
    [ItemChangeReason.ITEM_REASON_AUCTION_BIB_BE_EXCEED] = 1,
}

-- 拍卖竞拍成功
local C_AUCTION_SUCCESS_FAIL = {
    [ItemChangeReason.ITEM_REASON_AUCTION_SUCCESS] = 1,
}

local C_EXP_REASON_HASH = {
    [ItemChangeReason.ITEM_REASON_EXP_BLESS] = 1,
    [ItemChangeReason.ITEM_REASON_EXP_HEALTH] = 1,
    [ItemChangeReason.ITEM_REASON_PICK_UP_EXP] = 1,
    [ItemChangeReason.ITEM_REASON_HEALTH_QUICKLY] = 1,
}

local C_PICKUP_REASON_HASH = {
    [ItemChangeReason.ITEM_REASON_PICK_UP] = 1,
    [ItemChangeReason.ITEM_REASON_HEALTH_QUICKLY] = 1,
    [ItemChangeReason.ITEM_REASON_DABAO_CANDY] = 1,
}

function OnInit()
    GlobalEventBus:Add(EventConst.Names.ShowNextSpecialTip, OnShowNextSpecialTip)
    gameEventMgr.Register(gameEventMgr.OnBagUpdate, _onItemUpdate)
end

function OnUninit()
    GlobalEventBus:RemoveObjectAllFunc(EventConst.Names.ShowNextSpecialTip)
end

---@param itemUpdateDataList ItemUpdateData[]
function _onItemUpdate(itemUpdateDataList)
    if nil == itemUpdateDataList then
        logError("[NoticeMgr] invalid param")
        return
    end

    for i = 1, #itemUpdateDataList do
        local singleUpdateInfo = itemUpdateDataList[i]
        local compareData = singleUpdateInfo:GetItemCompareData()
        local itemData = singleUpdateInfo:GetNewOrOldItem()
        --- 在这里处理是因为不确定时间更新的reason是来自于哪里
        _showItemTimeUpdateTips(singleUpdateInfo)
        if nil == L_CONST_IGNORE_HASH_TABLE[singleUpdateInfo.Reason] then
            if GameEnum.EItemType.HeadIcon == itemData.ItemConfig.TypeTab and singleUpdateInfo:IsItemNewAcquire() then
                _addSpecialTips(compareData.id)
            elseif GameEnum.EItemType.ChatBubbleBg == itemData.ItemConfig.TypeTab and singleUpdateInfo:IsItemNewAcquire() then
                _addSpecialTips(compareData.id, GameEnum.SpecialItemTipShowType.ChatBubble)
            elseif GameEnum.EItemType.IconFrame == itemData.ItemConfig.TypeTab and singleUpdateInfo:IsItemNewAcquire() then
                _addSpecialTips(compareData.id, GameEnum.SpecialItemTipShowType.IconFrame)
            elseif C_PICKUP_REASON_HASH[singleUpdateInfo.Reason] then
                MgrMgr:GetMgr("TipsMgr").ShowItemDropNotice(compareData.id, compareData.count)
                if itemData:CanShowSpecialTips() then
                    MgrMgr:GetMgr("TipsMgr").ShowSpecialItemTips(compareData.id, compareData.count, nil, nil)
                end
            elseif ItemChangeReason.ITEM_REASON_CAT_TRADE_SELL_EXTRA == singleUpdateInfo.Reason then
                local str = Lang("NEW_USER_GET_ITEM",MgrMgr:GetMgr("TipsMgr").GetNormalItemTips(tostring(compareData.id), tostring(compareData.count)))
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(str)
            elseif ItemChangeReason.ITEM_REASON_HUIYUAN_CARD == singleUpdateInfo.Reason then
                MgrMgr:GetMgr("CapraCardMgr").CacheCapraExtraRewardTips(compareData.id, compareData.count)
            elseif nil ~= C_CONST_STALL_PURCHASE[singleUpdateInfo.Reason] then
                SpecialNoticeTips(singleUpdateInfo.Reason, compareData.id, compareData.count)
            elseif nil ~= C_GUILD_DINNER_NOTICE_MAP[singleUpdateInfo.Reason] then
                --- 这边映射表里面填的是字符串
                local tipsStr = C_GUILD_DINNER_NOTICE_MAP[singleUpdateInfo.Reason]
                if 0 ~= compareData.count then
                    local l_opt = {
                        itemId = compareData.id,
                        itemOpts = { num = compareData.count },
                        title = tipsStr,
                        adapter = true,
                    }

                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_opt)
                end
            elseif nil ~= C_AUCTION_BID_FAIL[singleUpdateInfo.Reason] then
                if compareData.count > 0 then
                    local l_itemId = compareData.id
                    local l_icon = GetItemIconText(l_itemId, 18, 1.4)
                    local l_name = Data.BagModel:GetItemNameText(l_itemId)
                    local l_count = compareData.count
                    l_count=tonumber(l_count)
                    local l_countText=MNumberFormat.GetNumberFormat(l_count)
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("AUCTION_BID_FAIL_RETURN", l_icon, l_name, l_countText))
                end
            elseif nil ~= C_AUCTION_SUCCESS_FAIL[singleUpdateInfo.Reason] then
                if compareData.count > 0 then
                    local l_itemId = compareData.id
                    local l_icon = GetItemIconText(l_itemId, 18, 1.4)
                    local l_name = Data.BagModel:GetItemNameText(l_itemId)
                    local l_count = compareData.count
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("AUCTION_BID_SUCCESS_RETURN", l_icon, l_name, l_count))
                end
            elseif 0 < compareData.count and nil == C_EXP_REASON_HASH[singleUpdateInfo.Reason] then
                if singleUpdateInfo.Reason == ItemChangeReason.ITEM_REASON_BIG_WORLD_FRUIT then
                    NoticeNormalTipsByEntity(compareData.id, compareData.count, singleUpdateInfo.ExtraData)
                else
                    NoticeNormalTips(compareData.id, compareData.count, false, false)
                end
                if itemData:CanShowSpecialTips() then
                    local l_additionData = nil
                    -- 卡片解封成功
                    if singleUpdateInfo.Reason == ItemChangeReason.ITEM_REASON_UNSEAL_CARD then
                        l_additionData = { titleName = Lang("UNSEAL_SUCCEED", "") }
                    end
                    MgrMgr:GetMgr("TipsMgr").ShowSpecialItemTips(compareData.id, compareData.count, nil, l_additionData)
                end

            end
        end
    end
end

---@param itemUpdateData ItemUpdateData
function _showItemTimeUpdateTips(itemUpdateData)
    if nil == itemUpdateData then
        logError("[NoticeMgr] invalid param")
        return
    end

    if itemUpdateData:GetNewOrOldItem().ItemConfig.TypeTab == GameEnum.EItemType.BelluzGear then        -- 贝鲁兹使用自己Tips，不走统一接口
        return
    end

    local name = itemUpdateData:GetNewOrOldItem():GetName()
    if itemUpdateData:ItemRemoved() and ItemChangeReason.ITEM_REASON_LIMITED_TIME_OFFER == itemUpdateData.Reason then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("C_ITEM_TIME_EXPIRED", name))
        return
    end

    if not itemUpdateData:ItemTimeUpdated() then
        return
    end

    local l_timeTable = Common.TimeMgr.GetTimeTable(Common.TimeMgr.GetLocalTimestamp(itemUpdateData.NewItem:GetExpireTime()))
    local str = Lang("DATE_YY_MM_DD_H_M_S", l_timeTable.year, l_timeTable.month, l_timeTable.day, l_timeTable.hour, l_timeTable.min, l_timeTable.sec)
    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("C_ITEM_TIME_UPDATED", name, str))
end

function NoticeNormalTipsByEntity(itemId, itemCount, entityID)

    local l_str = ""
    local l_data = MGlobalConfig:GetVectorSequence("ColorDantips")
    for i = 0, l_data.Length - 1 do
        local l_id = tonumber(l_data[i][0])
        if l_id == entityID then
            l_str = Lang(l_data[i][1])
            break
        end
    end
    l_str = l_str .. MgrMgr:GetMgr("TipsMgr").GetNormalItemTips(tostring(itemId), tostring(itemCount))
    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_str)

end

function NoticeNormalTips(itemId, itemCount, isAssist, isAssistSpecial)
    if not isAssist and not isAssistSpecial then
        local l_opt = {
            itemId = itemId,
            itemOpts = { num = itemCount, icon = { size = 18, width = 1.4 } },
        }
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_opt)
    else
        local forString = ""
        if isAssist then
            forString = Common.Utils.Lang("GETITEM_BY_ASSIST")
        end
        if isAssistSpecial then
            forString = Common.Utils.Lang("GETITEM_BY_ASSIST_SPECIAL")
        end
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(forString .. MgrMgr:GetMgr("TipsMgr").GetNormalItemTips(tostring(itemId), tostring(itemCount)))
    end
end

function GetExtraItemName(id)
    local name = TableUtil.GetItemTable().GetRowByItemID(tonumber(id)).ItemName
    if id == virProp.exp then
        name = Lang("TO_GET_EXTRA_ITEMNAME")
    elseif id == virProp.jobExp then
        name = Lang("TO_GET_EXTRA_ITEMNAME")
    end
    return name
end

function SpecialNoticeTips(reason, id, num)
    if reason == ItemChangeReason.ITEM_REASON_ROLL_POINT then
        MgrMgr:GetMgr("RollMgr").DumpReward(id, num)
        return
    end
    if reason == ItemChangeReason.ITEM_REASON_FLOP then
        MgrMgr:GetMgr("LuckyDrawMgr").DumpReward(id, num)
        return
    end
    -- 已移至OnItemAwardNtf()
    --if reason == ItemChangeReason.ITEM_REASON_DELEGATE_DARW_AWARD then
    --    MgrMgr:GetMgr("DelegateModuleMgr").DumpDelegateReward(id, num)
    --    return
    --end
    if reason == ItemChangeReason.ITEM_REASON_BATTLE_RESULT then
        MgrMgr:GetMgr("PvpMgr").DumpReward(id, num)
        return
    end
    if reason == ItemChangeReason.ITEM_REASON_BATTLE_ASSIST_RESULT then
        MgrMgr:GetMgr("PvpMgr").DumpAssistReward(id, num)
        return
    end
end

--- 处理接收到的奖励信息
function OnItemAwardNtf(msg)
    ---@type ItemAwardNtfData
    local l_info = ParseProtoBufToTable("ItemAwardNtfData", msg)
    if l_info.total_reason == ItemChangeReason.ITEM_REASON_COLLECT_FISHING then
        MgrMgr:GetMgr("FishMgr").ShowFishAward(l_info)
    elseif l_info.total_reason == ItemChangeReason.ITEM_REASON_HYMN_TRIAL then
        MgrMgr:GetMgr("HymnTrialMgr").ShowEventAward(l_info)
    elseif l_info.total_reason == ItemChangeReason.ITEM_REASON_DELEGATE_DARW_AWARD then
        MgrMgr:GetMgr("DelegateModuleMgr").DumpDelegateReward(l_info)
    end
end

function OnShowLoading()
    cacheMessageInfo = nil
    isLoading = true
end

function OnHideLoading()
    isLoading = false
    if cacheMessageInfo then
        ShowAnnounce(cacheMessageInfo)
        cacheMessageInfo = nil
    end
end

---通知信息(主要公告+次要公告);
function OnPushAnnouceNtf(msg)
    ---@type AnnounceData
    local l_info = ParseProtoBufToTable("AnnounceData", msg)

    if not isLoading then
        ShowAnnounce(l_info)
    else
        if not (MPlayerInfo.PlayerDungeonsInfo and MPlayerInfo.PlayerDungeonsInfo.dungeonData) then
            cacheMessageInfo = l_info
        end
    end
end

function ShowAnnounce(info)
    if not info or isLoading then
        return
    end
    --id为-1表示这是个GM自定义的公告 不用读配置表
    if info.id == -1 then
        local l_content = ""
        if info.announce_msg and #info.announce_msg > 0 then
            for _, v in ipairs(info.announce_msg) do
                if v.localization_name and v.localization_name.type then
                    l_content = l_content .. Lang(v.localization_name)
                end
            end
        end
        AddSecondaryNotice(NoticeType.GM, info, nil, l_content)
    else
        MgrMgr:GetMgr("MessageRouterMgr").OnMessage(info.id, nil, info)
    end
end

-- 增加底部公告
-- @param type，类型
-- @param info，PbcMgr.get_pbc_chat_pb().AnnounceData()
-- @param msgData，MessageTable数据
-- @param content, 文本内容
function AddSecondaryNotice(type, info, msgData, content)
    local l_message = {}
    l_message.type = type
    l_message.info = info
    l_message.repeatTimer = nil
    l_message.msgData = msgData
    l_message.content = content
    --是GM公告
    if l_message.type == NoticeType.GM then
        table.insert(gmNoticeList, l_message)
        table.insert(secondaryNoticeList, l_message)
        --公告循环播放时间间隔计时
        if l_message.repeatTimer == nil then
            --重复显示公告
            l_message.repeatTimer = Timer.New(function()
                --加入队列等待播放公告
                table.insert(secondaryNoticeList, 1, l_message)
            end, tonumber(info.show_interval), -1, true)
            l_message.repeatTimer:Start()
        end
        --是奖励公告
    elseif l_message.type == NoticeType.Award then
        --这个提示需要延迟播放
        if msgData.DelayTime > 0 then
            local l_timer = Timer.New(function()
                table.insert(secondaryNoticeList, l_message)
                if l_timer then
                    l_timer:Stop()
                end
                l_timer = nil
            end, msgData.DelayTime, 0, true)
            l_timer:Start()
            return
        end
        --加入队列等待播放公告
        table.insert(secondaryNoticeList, l_message)
    end
end

--播放底部公告
function ShowSecondaryMessage()
    if #secondaryNoticeList < 1 then
        return
    end

    local l_message = secondaryNoticeList[1]
    local l_info = l_message.info
    --如果没有对应服务器数据 则清理
    if not l_info then
        table.remove(secondaryNoticeList, 1)
        return
    end

    if l_message then
        if l_message.type == NoticeType.GM then
            --到时间清除公告
            local l_info = l_message.info
            if MLuaCommonHelper.Long(MServerTimeMgr.UtcSeconds) >= MLuaCommonHelper.Long(l_info.end_time) then
                table.remove(secondaryNoticeList, 1)
                DeleteGMMessageByUUID(l_info.uuid)
                return
            end
        end

        NoticeSpeed = l_message.msgData and l_message.msgData.Duration or 10
        --有公告 判断符不符合直接显示的逻辑
        if IsSecondaryNotice then
            --之前播放的是GM
            if lastSecondaryNotice == NoticeType.GM then
                --等GM结束
                if SecondaryNoticeTimes <= NoticeSpeed then
                    return
                end
                --之前播放的是奖励
            elseif lastSecondaryNotice == NoticeType.Award then
                --之前奖励播放时间是最短时间
                if SecondaryNoticeTimes <= showIntervalTime then
                    return
                end
            end
        end

        lastSecondaryNotice = l_message.type
        table.remove(secondaryNoticeList, 1)
        MgrMgr:GetMgr("TipsMgr").ShowSecondaryNotice(l_message.content)
    end
end

---喇叭信息(超级喇叭+普通喇叭);
function OnPushHornNtf(msg)
    ---@type ChatInfo
    local l_info = ParseProtoBufToTable("ChatInfo", msg)
    if l_info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end
    if l_info.channel == ChatChannel.CHAT_CHANNEL_SMALL_HORN then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTrumpet(l_info.content)
    end
    if l_info.channel == ChatChannel.CHAT_CHANNEL_BIG_HORN then
        MgrMgr:GetMgr("TipsMgr").ShowImportantNotice(l_info.content)
    end
end

---发送普通喇叭;
function SendHornReq(str)
    local l_msgId = Network.Define.Rpc.SendHorn
    ---@type SendHornArg
    local l_sendInfo = GetProtoBufSendTable("SendHornArg")
    l_sendInfo.channel = ChatChannel.CHAT_CHANNEL_SMALL_HORN
    l_sendInfo.content = str
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

---发送超级喇叭;
function SendImportantHornReq(str)
    local l_msgId = Network.Define.Rpc.SendHorn
    ---@type SendHornArg
    local l_sendInfo = GetProtoBufSendTable("SendHornArg")
    l_sendInfo.channel = ChatChannel.CHAT_CHANNEL_BIG_HORN
    l_sendInfo.content = str
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--删除GM公告
function DeleteGMMessage(msg)
    ---@type AnnounceClearInfo
    local l_info = ParseProtoBufToTable("AnnounceClearInfo", msg)
    for i = 1, #l_info.announce_list do
        DeleteGMMessageByUUID(l_info.announce_list[i].value)
    end
end

--根据uuid删除GM公告
function DeleteGMMessageByUUID(uuid)
    for i = #gmNoticeList, 1, -1 do
        if uuid == gmNoticeList[i].info.uuid then
            if gmNoticeList[i].repeatTimer ~= nil then
                gmNoticeList[i].repeatTimer:Stop()
                gmNoticeList[i].repeatTimer = nil
            end
            table.remove(gmNoticeList, i)
            break
        end
    end
end

--退出删除公告
function DeleteAllSecondaryNotice()
    for i = #secondaryNoticeList, 1, -1 do
        if secondaryNoticeList[i].repeatTimer ~= nil then
            secondaryNoticeList[i].repeatTimer:Stop()
            secondaryNoticeList[i].repeatTimer = nil
        end
        table.remove(secondaryNoticeList, i)
    end
    secondaryNoticeList = {}
end

--断线重连删除所有公告
function OnReconnected(reconnectData)
    for i = #gmNoticeList, 1, -1 do
        if gmNoticeList[i].repeatTimer ~= nil then
            gmNoticeList[i].repeatTimer:Stop()
            gmNoticeList[i].repeatTimer = nil
        end
    end
    secondaryNoticeList = {}
    gmNoticeList = {}
end

--退出登录
function OnLogout()
    OnReconnected(nil)
    DeleteAllSecondaryNotice()
    specialTipQueue = {}
end

function OnUpdate()
    SecondaryNoticeTimes = SecondaryNoticeTimes + Time.deltaTime
    duration = duration + Time.deltaTime
    if duration >= 1 then
        duration = 0
        ShowSecondaryMessage()
    end
end

--region Special Tip
function OnCheckSpecialTip()
    if #specialTipQueue == 0 then
        return
    end
    local tipData = table.remove(specialTipQueue, 1)
    ShowSpecialItemTip(tipData)
end

function ShowSpecialItemTip(tipData)
    if tipData then
        local l_openUIData = {
            type = DataMgr:GetData("LifeProfessionData").EUIOpenType.LifeProfessionReward_Tip,
            itemList = { { id = tipData.id, count = 1, isSticker = tipData.isSticker or false } },
            closeFunc = function()
                GlobalEventBus:Dispatch(EventConst.Names.ShowNextSpecialTip)
            end,
            tipsInfo = {
                title = tipData.title,
                tipsInfo = tipData.tipsInfo,
                atlas = tipData.tipsatlas,
                icon = tipData.tipsIcon,
            }
        }
        UIMgr:ActiveUI(UI.CtrlNames.LifeProfessionReward, l_openUIData)
    end
end

function AddSpecialItemTip(id, type)
    _addSpecialTips(id, type)
end

function _addSpecialTips(id, type)
    type = type or GameEnum.SpecialItemTipShowType.Item
    if type == GameEnum.SpecialItemTipShowType.Item then
        local itemConfig = TableUtil.GetItemTable().GetRowByItemID(id)
        if itemConfig then
            local strSplit = string.ro_split(Lang("LifeProfession_Head_AwardTips"), "&")
            table.insert(specialTipQueue, {
                id = id,
                atlas = itemConfig.ItemAtlas,
                icon = itemConfig.ItemIcon,
                name = itemConfig.ItemName,
                tipsatlas = "CommonIcon",
                tipsIcon = "UI_CommonIcon_Leixing_Touxiang.png",
                prefix = Lang("NEW_HEAD_UNLOCK"),
                title = strSplit[1],
                tipsInfo = strSplit[2] }
            )
        end
    elseif type == GameEnum.SpecialItemTipShowType.IconFrame then
        local itemConfig = TableUtil.GetItemTable().GetRowByItemID(id)
        if nil == itemConfig then
            return
        end

        table.insert(specialTipQueue, {
            id = id,
            atlas = itemConfig.ItemAtlas,
            icon = itemConfig.ItemIcon,
            name = itemConfig.ItemName,
            tipsatlas = "CommonIcon",
            tipsIcon = "UI_CommonIcon_Leixing_Touxiang.png",
            prefix = Common.Utils.Lang("NEW_ICON_FRAME_UNLOCK"),
            title = Common.Utils.Lang("NEW_ICON_FRAME_UNLOCK"),
            tipsInfo = Common.Utils.Lang("C_VIEW_IN_PERSONAL_BOOK") }
        )
    elseif type == GameEnum.SpecialItemTipShowType.ChatBubble then
        local itemConfig = TableUtil.GetItemTable().GetRowByItemID(id)
        if nil == itemConfig then
            return
        end

        table.insert(specialTipQueue, {
            id = id,
            atlas = itemConfig.ItemAtlas,
            icon = itemConfig.ItemIcon,
            name = itemConfig.ItemName,
            tipsatlas = "CommonIcon",
            tipsIcon = "UI_CommonIcon_Leixing_Touxiang.png",
            prefix = Common.Utils.Lang("NEW_CHAT_BUBBLE_UNLOCK"),
            title = Common.Utils.Lang("NEW_CHAT_BUBBLE_UNLOCK"),
            tipsInfo = Common.Utils.Lang("C_VIEW_IN_PERSONAL_BOOK") }
        )
    elseif type == GameEnum.SpecialItemTipShowType.Sticker then
        local stickerSdata = TableUtil.GetStickersTable().GetRowByStickersID(id)
        if stickerSdata then
            local strSplit = string.ro_split(Lang("LifeProfession_Sticker_AwardTips"), "&")
            table.insert(specialTipQueue, {
                id = id,
                atlas = stickerSdata.StickersAtlas,
                icon = stickerSdata.StickersIcon,
                name = stickerSdata.StickersName,
                tipsatlas = "CommonIcon",
                tipsIcon = "UI_CommonIcon_Leixing_Tiezhi.png",
                prefix = Lang("NEW_STICKER_UNLOCK"),
                isSticker = true,
                title = strSplit[1],
                tipsInfo = strSplit[2] }
            )
        end
    elseif type == GameEnum.SpecialItemTipShowType.Achievement then
        local achievementSdata = TableUtil.GetAchievementDetailTable().GetRowByID(id)
        if achievementSdata then
            table.insert(specialTipQueue, {
                id = id,
                atlas = achievementSdata.Atlas,
                icon = achievementSdata.Icon,
                name = achievementSdata.Name,
                prefix = Lang("NEW_HEAD_UNLOCK") }
            )
        end
    end

    local ui = UIMgr:GetUI(UI.CtrlNames.LifeProfessionReward)
    if not ui or not ui:IsActive() then
        OnCheckSpecialTip()
    end
end

function OnShowNextSpecialTip()
    OnCheckSpecialTip()
end
--endregion

--公告列表是否为空
function IsSecondaryNoticeListEmpty()
    return #secondaryNoticeList == 0
end

return ModuleMgr.NoticeMgr