--this file is gen by script
--you can edit this file in custom part


--lua model
---@module ModuleData.RebateMonthCardData
module("ModuleData.RebateMonthCardData", package.seeall)

--lua model end

--lua functions
function init()
    ClearNormalCardInfo()
    ClearSuperCardInfo()
    GetRebateMonthCardTableInfo()
end --func end
--next--
function logout()
    ClearNormalCardInfo()
    ClearSuperCardInfo()
end --func end
--next--
--lua functions end

--lua custom scripts
REBATE_CARD_TYPE = {
    Normal = 1,
    Super = 2
}
BUY_TYPE = {
    BuyMonthCard = 1,
    BuyAll = 2
}

REFRESH_REBATE_PANEL = "REFRESH_REBATE_PANEL"

---@class RebateMonthCardInfo
---@field endTimeStamp number 结束时间戳
---@field lastEarnRewardTimeStamp number 上次领奖时间
---@field leftTimes number 剩余领奖次数
---@field buyCount number 总共购买次数 
---@field tableInfo RebateMonthlyCard 表信息
local SuperCardInfo = {}
---@type RebateMonthCardInfo
local NormalCardInfo = {}
--GlobalKey = {
--    TermOfValidity = {
--        [1] = "CommonTermOfValidity",
--        [2] = "SuperTermOfValidity"
--    },
--    TimeAgain = {
--        [1] = "CommonTimeAgain",
--        [2] = "SuperTimeAgain"
--    },
--    FirstAwardId = {
--        [1] = "CommonFirstAwardId",
--        [2] = "SuperFirstAwardId"
--    },
--    DayAwardId = {
--        [1] = "CommonDayAwardId",
--        [2] = "SuperDayAwardId"
--    },
--    OnceBuy = {
--        [1] = "RebateMonthCardOnceBuy",
--        [2] = "RebateSuperardOnceBuy"
--    }
--}

SystemID = {
    card = {
        [1] = MgrMgr:GetMgr("OpenSystemMgr").eSystemId.RebateMonthCardNormal,
        [2] = MgrMgr:GetMgr("OpenSystemMgr").eSystemId.RebateMonthCardSuper
    },
    buyNow = {
        [1] = 0,
        [2] = 0
    }
}
---设置普通返利月卡结束时间戳
---@param time number 结束时间戳
---@return boolean flag 用于标记是否是从有到无，标记是否刚刚过期
---@return number endtime 返回上次记录的结束时间戳，用于到期Tips的标记
function SetNormalEndTime(time)
    local flag = false
    local endtime = NormalCardInfo.endTimeStamp
    if time == 0 and NormalCardInfo.endTimeStamp ~= 0 then
        flag = true
    end
    NormalCardInfo.endTimeStamp = time
    --NormalCardInfo.showTipsStamp = 0
    return flag, endtime
end

---设置超级返利月卡结束时间戳
---@param time number 结束时间戳
---@return boolean flag 用于标记是否是从有到无，标记是否刚刚过期
---@return number endtime 返回上次记录的结束时间戳，用于到期Tips的标记
function SetSuperEndTime(time)
    local flag = false
    local endtime = SuperCardInfo.endTimeStamp
    if time == 0 and SuperCardInfo.endTimeStamp ~= 0 then
        flag = true
    end
    SuperCardInfo.endTimeStamp = time
    --SuperCardInfo.showTipsStamp = 0
    return flag, endtime
end
---设置普通返利已月卡购买次数
---@param count number 次数
function SetNormalBuyCount(count)
    NormalCardInfo.buyCount = count
    updateRewardInfoLeftTimes(NormalCardInfo)
end

---设置超级返利已月卡购买次数
---@param count number 次数
function SetSuperBuyCount(count)
    SuperCardInfo.buyCount = count
    updateRewardInfoLeftTimes(SuperCardInfo)
end

---设置普通返利月卡领奖信息
---@param leftTimes number 剩余次数
---@param lastEarnRewardTimeStamp number 上次领奖时间戳
function SetNormalRewardInfo(leftTimes, lastEarnRewardTimeStamp)
    NormalCardInfo.hasReceiveTimes = leftTimes
    NormalCardInfo.lastEarnRewardTimeStamp = lastEarnRewardTimeStamp
    updateRewardInfoLeftTimes(NormalCardInfo)
end
---设置超级返利月卡领奖信息
---@param leftTimes number 剩余次数
---@param lastEarnRewardTimeStamp number 上次领奖时间戳
function SetSuperRewardInfo(leftTimes, lastEarnRewardTimeStamp)
    SuperCardInfo.hasReceiveTimes = leftTimes
    SuperCardInfo.lastEarnRewardTimeStamp = lastEarnRewardTimeStamp
    updateRewardInfoLeftTimes(SuperCardInfo)
end
--- 更新奖励信息剩余次数
function updateRewardInfoLeftTimes(cardInfo)
    if not cardInfo.tableInfo then
        GetRebateMonthCardTableInfo()
    end
    cardInfo.leftTimes = cardInfo.tableInfo.TermOfValidity * cardInfo.buyCount - cardInfo.hasReceiveTimes
end
---返回普通月卡信息
---@return RebateMonthCardInfo
function GetNormalInfo()
    if not NormalCardInfo.tableInfo then
        GetRebateMonthCardTableInfo()
    end
    return NormalCardInfo
end
---返回超级月卡信息
---@return RebateMonthCardInfo
function GetSuperInfo()
    if not SuperCardInfo.tableInfo then
        GetRebateMonthCardTableInfo()
    end
    return SuperCardInfo
end

function ClearNormalCardInfo()
    NormalCardInfo = {}
    NormalCardInfo.endTimeStamp = 0
    NormalCardInfo.lastEarnRewardTimeStamp = 0
    NormalCardInfo.leftTimes = -1
    NormalCardInfo.hasReceiveTimes = 0
    NormalCardInfo.buyCount = 0
end

function ClearSuperCardInfo()
    SuperCardInfo = {}
    SuperCardInfo.endTimeStamp = 0
    SuperCardInfo.lastEarnRewardTimeStamp = 0
    SuperCardInfo.leftTimes = -1
    SuperCardInfo.hasReceiveTimes = 0
    SuperCardInfo.buyCount = 0
end
---获取表信息
function GetRebateMonthCardTableInfo()
    local l_curArea = MLuaCommonHelper.Enum2Int(MGameContext.CurrentChannel)

    local l_datas = {}
    local l_rows = TableUtil.GetRebateMonthlyCard().GetTable()
    for i = 1, #l_rows do
        local l_row = l_rows[i]
        if l_row.ProductId == game:GetPayMgr():GetRealProductId("CommonCardPay") then
            NormalCardInfo.tableInfo = l_row
        elseif l_row.ProductId == game:GetPayMgr():GetRealProductId("SuperCardPay") then
            SuperCardInfo.tableInfo = l_row
        end
    end
    return l_datas
end

--lua custom scripts end
return ModuleData.RebateMonthCardData