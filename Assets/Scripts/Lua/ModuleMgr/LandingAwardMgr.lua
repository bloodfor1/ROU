---@module ModuleMgr.LandingAwardMgr
module("ModuleMgr.LandingAwardMgr", package.seeall)

require "Common/TimeMgr"
require "Common/Functions"

EventDispatcher = EventDispatcher.new()
ON_LANDING_AWARD_INFO_UPDATE = "ON_LANDING_AWARD_INFO_UPDATE"

local l_systemId = MgrMgr:GetMgr("OpenSystemMgr").eSystemId.LandingAward
local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")

-- 只有第一次进入常规场景才做自动弹出检查
local l_firstEnter = true
local l_hasRequestInfo = false

-- 数据
local l_data

--MgrMgr调用
function OnInit()
    l_data = DataMgr:GetData("LandingAwardData")
    l_firstEnter = true

    -- 清理数据
    ClearAwardData()
    local l_selfMgr = MgrMgr:GetMgr("LandingAwardMgr")
    MgrMgr:GetMgr("OpenSystemMgr").EventDispatcher:Add(MgrMgr:GetMgr("OpenSystemMgr").OpenSystemUpdate, OnSystemUpdate, l_selfMgr)
    gameEventMgr.Register(gameEventMgr.OnBagUpdate, _onItemUpdate)
end

function OnUnInit()
    local l_selfMgr = MgrMgr:GetMgr("LandingAwardMgr")
    MgrMgr:GetMgr("OpenSystemMgr").EventDispatcher:RemoveObjectAllFunc(MgrMgr:GetMgr("OpenSystemMgr").OpenSystemUpdate, l_selfMgr)
end

function OnReconnected()
    l_hasRequestInfo = false
    --当功能开启后在发送请求七日礼的消息
    if MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.LandingAward) then
        RequestGetLandingAwardInfo()
    end
    EventDispatcher:Dispatch(ON_LANDING_AWARD_INFO_UPDATE)
end

function OnLogout()
    -- 注销时，重置状态信息
    l_firstEnter = true
    l_hasRequestInfo = false
    -- 保存
    DataMgr:GetData("LandingAwardData").SaveLastEnterTime()
    -- 清理数据
    ClearAwardData()
end

function OnLeaveScene()
    -- 若从来没进过，则不存
    if l_firstEnter then
        return
    end

    DataMgr:GetData("LandingAwardData").SaveLastEnterTime()
end

-- 请求领奖
function RequestGetLandingAward(day)
    local l_msgId = Network.Define.Rpc.SevenLoginActivityGetReward
    ---@type SevenLoginActivityGetRewardArg
    local l_sendInfo = GetProtoBufSendTable("SevenLoginActivityGetRewardArg")
    l_sendInfo.id = day
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

-- 领奖结果
function OnGetLandingAward(msg)
    ---@type SevenLoginActivityGetRewardRes
    local l_info = ParseProtoBufToTable("SevenLoginActivityGetRewardRes", msg)
    if l_info.error_code ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
        return
    end

    RequestGetLandingAwardInfo()
end

-- 请求七日奖励信息
function RequestGetLandingAwardInfo()
    local l_msgId = Network.Define.Rpc.SevenLoginActivityGetInfo
    ---@type SevenLoginActivityGetInfoArg
    local l_sendInfo = GetProtoBufSendTable("SevenLoginActivityGetInfoArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnSelectRoleNtf(info)
    OnSystemUpdate()
end

function OnSystemUpdate()
    if IsSystemOpen() then
        if not l_hasRequestInfo then
            l_hasRequestInfo = true
            RequestGetLandingAwardInfo()
        end
    end
end

-- 收到七日奖励信息
function OnGetLandingInfo(msg)
    ---@type SevenLoginActivityGetInfoRes
    local l_info = ParseProtoBufToTable("SevenLoginActivityGetInfoRes", msg)

    if l_info.error_code ~= 0 then
        --logError("OnGetLandingInfo error: " .. tostring(l_info.error_code))
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
        return
    end

    local l_infoUpdate = l_data.OnGetLandingInfo(l_info)
    if not l_infoUpdate then
        return
    end

    NotifyInfoUpdate()

    EventDispatcher:Dispatch(ON_LANDING_AWARD_INFO_UPDATE)
end

-- 收到服务器通知，用于跨天
function OnNotifyLandingInfo(msg)
    ---@type SevenLoginActivityUpdateNotifyInfo
    local l_info = ParseProtoBufToTable("SevenLoginActivityUpdateNotifyInfo", msg)

    if not l_data.SevenDayInfo then
        logError("本地没有七日登陆奖励内容")
        return
    end

    l_data.cur_reward = l_info.cur_reward
    l_data.SevenDayInfo.cur_reward = l_info.cur_reward
    NotifyInfoUpdate()
    log("OnNotifyLandingInfo cur_reward:", l_info.cur_reward)
end

--- 获得道具显示
---@param itemUpdateInfoList ItemUpdateData[]
function _onItemUpdate(itemUpdateInfoList)
    if nil == itemUpdateInfoList then
        logError("[LandingAwardMgr] invalid param")
        return
    end

    local title = Common.Utils.Lang("Achievement_GetBadgeGetAwardText")
    local tipsTitle = Common.Utils.Lang("Landing_GetAwardText")

    ---@type ItemIdCountPair[]
    local itemPairList = {}
    for i = 1, #itemUpdateInfoList do
        local singleUpdateInfo = itemUpdateInfoList[i]
        local compareData = singleUpdateInfo:GetItemCompareData()
        if ItemChangeReason.ITEM_REASON_SEVEN_LOGIN_REWARD == singleUpdateInfo.Reason
                and nil ~= singleUpdateInfo.NewItem
        then
            ---@type ItemIdCountPair
            local singlePair = {
                id = compareData.id,
                count = compareData.count,
            }

            table.insert(itemPairList, singlePair)
        end
    end

    local mergeList = _mergeData(itemPairList)
    MgrMgr:GetMgr("TipsMgr").ShowAwardItemTips(mergeList, title, tipsTitle)
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

-- 统一的通知更新逻辑
function NotifyInfoUpdate()
    -- 通过红点系统
    MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(eRedSignKey.LandingAward)
    -- 抛出事件
    EventDispatcher:Dispatch(ON_LANDING_AWARD_INFO_UPDATE)
end

-- 清理pb数据
function ClearAwardData()

    if l_data then
        l_data.ClearAwardData()
    end
end

function IsLandingAwardAvailable(day)

    -- 系统未开放
    if not IsSystemOpen() then
        log("七日登陆奖励系统还未开放")
        return false
    end

    -- 客户端无pb数据
    if not l_data.SevenDayInfo then
        log("无七日登陆奖励数据")
        return false
    end

    -- 天数大于当前可领取天数
    if day > l_data.SevenDayInfo.cur_reward then
        return false
    end

    -- 判断之前有木有领取过奖励
    for i, v in ipairs(l_data.SevenDayInfo) do
        if v == day then
            return false
        end
    end

    return true
end

-- 判断当前是否有奖励可以领取
function CheckRedSignMethod()

    -- 系统未开放
    if not IsSystemOpen() then
        log("七日登陆奖励系统还未开放")
        return 0
    end

    -- 客户端无pb数据
    if not l_data.SevenDayInfo then
        log("无七日登陆奖励数据")
        return 0
    end

    local l_curReward = l_data.SevenDayInfo.cur_reward
    -- 构建map 方便查询
    local l_getMap = {}
    for i, v in ipairs(l_data.SevenDayInfo) do
        l_getMap[v] = true
    end

    for i = 1, l_curReward do
        if not l_getMap[i] then
            return 1
        end
    end

    return 0
end

function IsSystemOpen()

    return MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(l_systemId)
end

function CheckSystemOpen()

    -- 都领取完了，认为不开放
    if (GetCanTakeAwardDay() >= GetTotalAwardCount()) and (CheckRedSignMethod() <= 0) then
        return false
    end

    return true
end

function IsSystemOpenExtraCheck()

    -- 木有数据，认为不开放
    if not l_data.SevenDayInfo then
        return false
    end

    return CheckSystemOpen()
end

-- 当前可领取的索引
function GetCanTakeAwardDay()

    return l_data.SevenDayInfo and l_data.SevenDayInfo.cur_reward or 1
end

-- 总共天数
function GetTotalAwardCount()
    return 8
end

-- 获取Lua配置内容
function GetLandingAwardConfig()
    require "seven_day_award"
    local l_configs = SevenDayAward.GetAwardConfigs()
    if not l_configs or #l_configs < GetTotalAwardCount() then
        logError("无七日奖励配置或者配置数量有误")
        return
    end

    return l_configs
end

return ModuleMgr.LandingAwardMgr
