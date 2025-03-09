--this file is gen by script
--you can edit this file in custom part


--lua model
module("ModuleMgr.ActivityNewKingMgr", package.seeall)

SIG_ACTIVITY_NEW_KING_ON_GET_INFO = "SIG_ACTIVITY_NEW_KING_ON_GET_INFO"
SIG_ACTIVITY_NEW_KING_AWARD_CHANGE = "SIG_ACTIVITY_NEW_KING_AWARD_CHANGE"

G_TOTAL_REWARD = 4

l_eventDispatcher = EventDispatcher.new()

E_REWARD_STATE = {
    Locked = 0,
    Received = 1
}

local l_awardInfo = 0
local g_totalCount = 0

--lua model end

--lua custom scripts

function OnLogout()
    ResetData()
end

---@param reconnectData ReconectSync
function OnReconnected(reconnectData)
end

function ResetData()
    l_awardInfo = 0
    g_totalCount = 0
end

function OnInit()

    ---@type CommonMsgProcessor
    local l_commonDataAward = Common.CommonMsgProcessor.new()
    local l_awardDatas = {}

    local l_data = {}
    l_data.ModuleEnum = CommondataType.kCDT_COMMON_JIFEN_AWARD
    l_data.Callback = OnAwardDataChange
    table.insert(l_awardDatas, l_data)

    l_commonDataAward:Init(l_awardDatas)

    local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
    gameEventMgr.Register(gameEventMgr.FestivalDataUpdate,OnFestivalDataUpdate)
end

function OnAwardDataChange(id, value)
    local l_isGetAward = tonumber(value)
    if l_isGetAward == nil then
        l_isGetAward = 0
    end
    l_awardInfo = tonumber(l_isGetAward)
    l_eventDispatcher:Dispatch(SIG_ACTIVITY_NEW_KING_AWARD_CHANGE)
    MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(eRedSignKey.NewKingPoint2)
end

-- 是否领取过
function GetAwardStatue(index)
    return CheckBit(l_awardInfo,index)
end

--
function CheckBit(value,n)
    local tmp1 = 2^n
    local tmp2 = 2^(n - 1)
    local ret = 0
    ret = value % tmp1
    ret = ret / tmp2
    if ret >= 1 then
        return 1
    else
        return 0
    end
end

function GetCurrentCount()
    return g_totalCount
end

function SetTotalCount(count)
    g_totalCount = count
    MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(eRedSignKey.NewKingPoint2)
    l_eventDispatcher:Dispatch(SIG_ACTIVITY_NEW_KING_ON_GET_INFO)
end

function CheckRedSign()
    if g_totalCount == 0 then
        return 0
    end

    local totalCount = GetCurrentCount()
    for i = 1,G_TOTAL_REWARD do
        local awardStatue = GetAwardStatue(i)
        local needCount = TableUtil.GetNewKingActivity().GetRowByID(i).TotalScore
        if awardStatue == E_REWARD_STATE.Locked and totalCount >= needCount then
            return 1
        end
    end

    return 0

end

function OnFestivalDataUpdate()
    local festivalMgr = MgrMgr:GetMgr("FestivalMgr")
    if festivalMgr.IsActivityShowByType(GameEnum.EActType.NewKing) then
        if g_totalCount == 0 then
            MgrMgr:GetMgr("FestivalMgr").ReqActData(GameEnum.EActType.NewKing)
        end
    else
        ResetData()
    end
end

--- message begin

function ReqGetReward(index)
    local msgId = Network.Define.Rpc.ActivityNewKingGetReward
    ---@type GetActivityAwardArg
    local sendInfo = GetProtoBufSendTable("GetActivityAwardArg")
    sendInfo.act_type = GameEnum.EActType.NewKing
    sendInfo.index = index
    Network.Handler.SendRpc(msgId, sendInfo)
end

function OnGetReward(msg, sendArg)
    -- 数据同步会延帧，收到错误码属于正常现象
    ---@type GetActivityAwardRes
    local l_info = ParseProtoBufToTable("GetActivityAwardRes", msg)
    local l_errorCode = l_info.result
    if 0 ~= l_errorCode then
        local l_str = Common.Functions.GetErrorCodeStr(l_errorCode)
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_str)
        return
    end
end
--- message end

--lua custom scripts end
return ModuleMgr.ActivityNewKingMgr