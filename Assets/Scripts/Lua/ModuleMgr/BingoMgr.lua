module("ModuleMgr.BingoMgr", package.seeall)

EventType = {
    RefreshNum = "RefreshNum",
    RefreshBingoSucceedNum = "RefreshBingoSucceedNum",
    LightNum = "LightNum",
    GuessSucceed = "GuessSucceed",
    RefreshReward = "RefreshReward",
}

EventDispatcher = EventDispatcher.new()

--{
--    itemId = 0,
--    state = EnmBingoGridState.kBingoGridStateGray,
--    lastGuessTimeStamp = 0,
--}
bingoNums = {}

bingoNumToItemId = {}
bingoSucceedNum = -1

awardReceiveState = {

}

openTimeStamps = {

}

-- 行列数
Row_Column = 6

function OnBingoGridCommonData(id, valueInt64)
    local l_state, l_itemId = Common.Functions.SplitNumber(valueInt64, {{1, 32}, {33, 64}})
    --logError(StringEx.Format("OnBingoGridCommonData:{0}-{1}-{2}-{3}", id, valueInt64, l_itemId, l_state))
    bingoNums[id] = bingoNums[id] or {
        itemId = 0,
        state = EnmBingoGridState.kBingoGridStateNone,
        lastGuessTimeStamp = 0,
    }
    bingoNums[id].itemId = l_itemId
    bingoNums[id].state = l_state

    EventDispatcher:Dispatch(EventType.RefreshNum)
end

function OnBingoGuessCommonData(id, valueInt64)
    -- logError("OnBingoGuessCommonData")
    bingoNums[id] = bingoNums[id] or {
        itemId = 0,
        state = EnmBingoGridState.kBingoGridStateNone,
        lastGuessTimeStamp = 0,
    }
    bingoNums[id].lastGuessTimeStamp = tonumber(valueInt64)
end

function OnBingoGridLightLevel(id, valueInt64)
    -- logError("OnBingoGridLightLevel")
    local l_old = bingoSucceedNum
    bingoSucceedNum = tonumber(valueInt64)
    local l_getBingo = l_old < bingoSucceedNum and l_old ~= -1
    EventDispatcher:Dispatch(EventType.RefreshBingoSucceedNum, l_getBingo)

    RefreshRedSign()
end

function OnAwardCommonData(_, valueInt64)
    -- 转化为二进制字符串
    local l_binStr = System.Convert.ToString(valueInt64, 2)
    awardReceiveState = {}
    for i = 1, #l_binStr do
        if l_binStr:sub(#l_binStr - i + 1, #l_binStr - i + 1)== '1' then
            awardReceiveState[i-1] = true
        end
    end

    EventDispatcher:Dispatch(EventType.RefreshReward)

    RefreshRedSign()
end

function OnInit()
    for _, itemRow in pairs(TableUtil.GetItemTable().GetTable()) do
        if itemRow.TypeTab == GameEnum.EItemType.Bingo then
            bingoNumToItemId[itemRow.ItemID % 100] = itemRow.ItemID
        end
    end

    ---@type CommonMsgProcessor
    local l_commonData = Common.CommonMsgProcessor.new()
    local l_data = {}
    table.insert(l_data, {
        ModuleEnum = CommondataType.kCDT_BINGO_GRID,
        Callback = OnBingoGridCommonData,
    })

    table.insert(l_data, {
        ModuleEnum = CommondataType.kCDT_BINGO_GUESS,
        Callback = OnBingoGuessCommonData,
    })

    table.insert(l_data, {
        ModuleEnum = CommondataType.kCDT_NORMAL,
        DetailDataEnum = CommondataId.kCDI_BINGO_LIGHT_LEVEL,
        Callback = OnBingoGridLightLevel,
    })

    table.insert(l_data, {
        ModuleEnum = CommondataType.kCDT_NORMAL,
        DetailDataEnum = CommondataId.kCDI_BINGO_AWARD,
        Callback = OnAwardCommonData,
    })

    l_commonData:Init(l_data)
end

function OnLogout()
    bingoNums = {}
    bingoSucceedNum = -1
    awardReceiveState = {}

    openTimeStamps = {}
end


function RequestBingoZone()
    ---@type QueryBingoZoneArg
    local l_sendInfo = GetProtoBufSendTable("QueryBingoZoneArg")
    Network.Handler.SendRpc(Network.Define.Rpc.QueryBingoZone, l_sendInfo)
end

function GetBingoNums()
    return bingoNums
end

function GetBingoSucceedNum()
    return bingoSucceedNum
end

function IsAwardReceived(bingoNum)
    return not not awardReceiveState[bingoNum]
end

function GetOpenTimeStamp(id)
    return openTimeStamps[id] or 0
end

function LightBingoNum(index)
    ---@type QueryBingoLightArg
    local l_sendInfo = GetProtoBufSendTable("QueryBingoLightArg")
    l_sendInfo.light_pos = index
    Network.Handler.SendRpc(Network.Define.Rpc.QueryBingoLight, l_sendInfo)
end

function GuessNum(index, num)
    local l_itemId = GetItemIdByNum(num)
    --logError(num)
    --logError(l_itemId)
    ---@type QueryBingoGuessArg
    local l_sendInfo = GetProtoBufSendTable("QueryBingoGuessArg")
    l_sendInfo.pos = index
    l_sendInfo.item_id = l_itemId
    Network.Handler.SendRpc(Network.Define.Rpc.QueryBingoGuess, l_sendInfo)
end

function GetAward(awardId)
    ---@type GetBingoAwardArg
    local l_sendInfo = GetProtoBufSendTable("GetBingoAwardArg")
    l_sendInfo.award_id = awardId
    Network.Handler.SendRpc(Network.Define.Rpc.GetBingoAward, l_sendInfo)
end

function GetItemIdByNum(num)
    return bingoNumToItemId[num] or 0
end

function GetValidNum(num)
    if num < 1 then return 1 end
    if num > MGlobalConfig:GetInt("BingoNumberArea") then return MGlobalConfig:GetInt("BingoNumberArea") end
    return num
end

function CheckRedSign()
    local l_hasReward = false
    local l_actId = MgrMgr:GetMgr("FestivalMgr").GetIdByType(EnmBackstageDetailType.EnmBackstageDetailTypeBingo)
    local l_data = MgrMgr:GetMgr("FestivalMgr").GetDataById(l_actId)
    if l_data then
        for _, awardInfo in ipairs(l_data.awardInfos) do
            local l_bingNum = awardInfo.param
            if l_bingNum <= GetBingoSucceedNum() and not IsAwardReceived(l_bingNum) then
                l_hasReward = true
                break
            end
        end
    end
    return l_hasReward and 1 or 0
end

function RefreshRedSign()
    MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(eRedSignKey.BingoPoint1)
    MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(eRedSignKey.BingoPoint2)
end

-- 协议
function OnQueryBingoGuess(msg, sendArg)
    local l_info = ParseProtoBufToTable("QueryBingoGuessRes", msg)
    if l_info.result ~= ErrorCode.ERR_SUCCESS then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end

    EventDispatcher:Dispatch(EventType.GuessSucceed, sendArg.pos)
end

function OnQueryBingoLight(msg, sendArg)
    local l_info = ParseProtoBufToTable("QueryBingoLightRes", msg)
    if l_info.result ~= ErrorCode.ERR_SUCCESS then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end

    EventDispatcher:Dispatch(EventType.RefreshNum, sendArg.light_pos)
end

function OnQueryBingoZone(msg, sendArg)
    local l_info = ParseProtoBufToTable("QueryBingoZoneRes", msg)
    if l_info.result ~= ErrorCode.ERR_SUCCESS then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end

    openTimeStamps = {}
    for i = 1, #l_info.guess_list.repeat_pairs do
        local l_pair = l_info.guess_list.repeat_pairs[i]
        openTimeStamps[l_pair.first] = tonumber(l_pair.second)
    end

    EventDispatcher:Dispatch(EventType.RefreshNum)
end

function OnGetBingoAward(msg, sendArg)
    local l_info = ParseProtoBufToTable("GetBingoAwardRes", msg)
    if l_info.result ~= ErrorCode.ERR_SUCCESS then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end
end

return ModuleMgr.BingoMgr