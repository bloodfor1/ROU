---@module ModuleMgr.SignInMgr
module("ModuleMgr.SignInMgr", package.seeall)
EventDispatcher = EventDispatcher.new()
Event = {
    ResetIndex = "ResetIndex",
    Award = "Award",
    Cashing = "Cashing",
}

CurIndex = -1
MaxIndex = -1
MaxDayCount = -1
IsEnd = false

local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")

------------------------------------------------生命周期
function OnInit()
    gameEventMgr.Register(gameEventMgr.OnBagUpdate, _onItemUpdate)
end

function OnLogout()
    if WaitTimer then
        WaitTimer:Stop()
        WaitTimer = nil
    end
end

function OnReconnected(reconnectData)
    --断线重连
    local l_roleAllInfo = reconnectData.role_data
    if l_roleAllInfo.thirty_sign_info then
        SetThirtySignInfo(l_roleAllInfo.thirty_sign_info)
    end
end

function OnSelectRoleNtf(roleInfo)
    --角色登陆成功
    SetThirtySignInfo(roleInfo.thirty_sign_info)
    SendThirtySignActivityGetInfo()
end

--- 获得道具显示
---@param itemUpdateInfoList ItemUpdateData[]
function _onItemUpdate(itemUpdateInfoList)
    if nil == itemUpdateInfoList then
        logError("[SignInMgr] invalid param")
        return
    end

    local rollItemTID = nil

    ---@type ItemIdCountPair[]
    local itemPairList = {}
    for i = 1, #itemUpdateInfoList do
        local singleItemUpdateData = itemUpdateInfoList[i]
        local compareData = singleItemUpdateData:GetItemCompareData()
        if ItemChangeReason.ITEM_REASON_THIRTY_SIGN_IN == singleItemUpdateData.Reason
                and nil ~= singleItemUpdateData.NewItem
        then
            ---@type ItemIdCountPair
            local singlePair = {
                id = compareData.id,
                count = compareData.count,
            }

            table.insert(itemPairList, singlePair)
            local oldItemCount = 0
            if nil ~= singleItemUpdateData.OldItem then
                oldItemCount = singleItemUpdateData.OldItem.ItemCount
            end

            if 0 < singleItemUpdateData.NewItem.ItemCount - oldItemCount and nil == rollItemTID then
                rollItemTID = singleItemUpdateData.NewItem.TID
            end
        end
    end

    --- 提示上有两个注意事项：1是要取差值，2是有可能出现堆叠满的情况，要进行合并
    local mergedList = _mergeData(itemPairList)
    _showRandomDice(rollItemTID, mergedList)
end

--- 合并数据，原因是可能有道具达到了堆叠上限，这个时候会分成两个道具发过来，显示上回分开
---@param pairDataList ItemIdCountPair[]
---@return ItemIdCountPair[]
function _mergeData(pairDataList)
    if nil == pairDataList then
        logError("[LvReward] invalid param")
        return {}
    end

    local hashMap = {}
    for i = 1, #pairDataList do
        local singlePair = pairDataList[i]
        if nil == hashMap[singlePair.id] then
            hashMap[singlePair.id] = singlePair.count
        else
            hashMap[singlePair.id] = hashMap[singlePair.id] + singlePair.count
        end
    end

    local ret = {}
    for id, value in pairs(hashMap) do
        ---@type ItemIdCountPair
        local singleData = {
            id = id,
            count = value
        }

        table.insert(ret, singleData)
    end

    return ret
end

---@param tid number
---@param itemPairList ItemIdCountPair[]
function _showRandomDice(tid, itemPairList)
    local l_title = Common.Utils.Lang("Achievement_GetBadgeGetAwardText")
    local l_tipsInfo = Common.Utils.Lang("Landing_GetAwardText")
    if not WaitRandomItems then
        MgrMgr:GetMgr("TipsMgr").ShowAwardItemTips(itemPairList, l_title, l_tipsInfo)
        return
    end

    if WaitRandomItems then
        --显示随机道具骰子
        local l_randomItems = WaitRandomItems
        local l_pos = { x = (WaitRandomDay >= 11 and WaitRandomDay <= 24) and 256 or -256, y = -236 }
        WaitRandomItems = nil
        WaitRandomDay = nil
        UIMgr:ActiveUI(UI.CtrlNames.DiceRandom, function(ctrl)
            ctrl:InitItems(tid, l_randomItems, l_pos)
        end)
        WaitTimer = Timer.New(function(b)
            UIMgr:DeActiveUI(UI.CtrlNames.DiceRandom)
            MgrMgr:GetMgr("TipsMgr").ShowAwardItemTips(itemPairList, l_title, l_tipsInfo)
        end, 2)
        WaitTimer:Start()
    end
end

------------------------------------------------func
function IsSystemOpenExtraCheck()
    return not IsEnd
end

function CheckWelfareRedSignMethod()
    return CanSignIn() and 1 or 0
end

function CanSignIn()
    if CurIndex < MaxIndex then
        if MaxIndex ~= 0 then
            if not IsEnd then
                return true
            end
        end
    end
    return false
end

function SetThirtySignInfo(info)
    --ThirtySignInfo
    if CurIndex == info.cur_reward and
            MaxIndex == info.max_reward_index and
            IsEnd == info.is_end then
        return
    end
    CurIndex = info.cur_reward
    MaxIndex = info.max_reward_index
    IsEnd = info.is_end
    EventDispatcher:Dispatch(Event.ResetIndex, CurIndex, MaxIndex)

    MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(eRedSignKey.SignIn)
end

function TryGetSign(day, itemInfos)
    if day < MaxIndex then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("SignIn_Award_Hint"))--奖励已经领取啦！
        return
    end
    
    if itemInfos == nil then
        return
    end

    if day > MaxIndex then
        local row = TableUtil.GetMouthAttendanceTable().GetRowByDay(day, false)
        if row then
            if row.AwardType == 3 and row.VirtualItemTips and row.VirtualItemTips ~= 0 then
                MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(row.VirtualItemTips)
                return
            end
            for i = 1, #itemInfos do
                MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(itemInfos[i].id)
                return
            end
            return
        end
    end

    WaitRandomItems = nil
    if MaxIndex > 0 then
        local row = TableUtil.GetMouthAttendanceTable().GetRowByDay(MaxIndex)
        if row.AwardType == 3 then
            WaitRandomItems = {}
            for k, v in pairs(itemInfos) do
                table.insert(WaitRandomItems, v.id)
            end
            WaitRandomDay = day
        end
    end
    SendThirtySignActivityGetReward()
end

------------------------------------------------协议
--请求签到所有数据
function SendThirtySignActivityGetInfo()
    local l_msgId = Network.Define.Rpc.ThirtySignActivityGetInfo
    ---@type ThirtySignActivityGetInfoArg
    local l_sendInfo = GetProtoBufSendTable("ThirtySignActivityGetInfoArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--拿到签到所有数据
function OnThirtySignActivityGetInfo(msg)
    ---@type ThirtySignActivityGetInfoRes
    local l_resInfo = ParseProtoBufToTable("ThirtySignActivityGetInfoRes", msg)
    if l_resInfo.error_code ~= 0 and l_resInfo.error_code ~= 1150 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_resInfo.error_code))
        return
    end
    SetThirtySignInfo(l_resInfo)
end

--请求签到
function SendThirtySignActivityGetReward()
    local l_msgId = Network.Define.Rpc.ThirtySignActivityGetReward
    ---@type ThirtySignActivityGetRewardArg
    local l_sendInfo = GetProtoBufSendTable("ThirtySignActivityGetRewardArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--签到返回
function OnThirtySignActivityGetReward(msg)
    ---@type ThirtySignActivityGetRewardRes
    local l_resInfo = ParseProtoBufToTable("ThirtySignActivityGetRewardRes", msg)
    if ErrorCode.ERR_SUCCESS == l_resInfo.err_code then
        return
    end

    local content = Common.Functions.GetErrorCodeStr(l_resInfo.err_code)
    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(content)
end

--签到数据同步
function OnThirtySignActivityUpdateNotify(msg)
    ---@type ThirtySignActivityUpdateNotifyInfo
    local l_resInfo = ParseProtoBufToTable("ThirtySignActivityUpdateNotifyInfo", msg)
    SetThirtySignInfo(l_resInfo)
end

return ModuleMgr.SignInMgr