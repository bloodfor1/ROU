--
-- @Description: 
-- @Author: haiyaojing
-- @Date: 2019-10-10 11:21:45
--

module("ModuleData.TimeLimitPayData", package.seeall)

-- 无操作触发Idle的时间
TriggerIdleTime = 0
-- 当前状态
CurIdleState = nil
-- 当前活动状态
ActivityState = nil
-- 结束时间
FinishTime = 0
-- 充值活动服务器配置
RechargeTable = nil

Ratio = 0

AwardIds = nil
AwardId2Index = nil
AwardInfo = nil

MallAwardCount = 6

function Init()
    
    TriggerIdleTime = tonumber(TableUtil.GetChargePreferenceTable().GetRowByName("ReadyTimer").Value)
    CurIdleState = RoleActivityStatusType.ROLE_ACTIVITY_STATUS_NONE
    ActivityState = LimitedOfferStatusType.LIMITED_OFFER_NONE

    Ratio = MGlobalConfig:GetInt("ReBateValue")


    AwardIds = {}
    local l_mallType = MgrMgr:GetMgr("MallMgr").MallTable.Pay
    local l_rows = TableUtil.GetRechargeTable().GetTable()
    for i = 1, #l_rows do
        local l_row = l_rows[i]
        if l_row.Type == l_mallType and l_row.OpenSystemID <= 0 then
            if game:GetPayMgr():IsPaymentIDMatched(l_row.PaymentID) then
                local l_payRow = TableUtil.GetPaymentTable().GetRowByProductId(l_row.PaymentID)
                table.insert(AwardIds, l_payRow.AwardId[1])
            end
        end
    end

    AwardId2Index = {}
    for i, v in ipairs(AwardIds) do
        AwardId2Index[v] = i
    end

    reset()
end


function Logout()
    
    reset()
end


function reset()

    CurIdleState = RoleActivityStatusType.ROLE_ACTIVITY_STATUS_NONE
    ActivityState = LimitedOfferStatusType.LIMITED_OFFER_NONE
    FinishTime = 0
    RechargeTable = nil
    AwardInfo = nil
end

-- 获取充值赠送比例
function GetRatio()

    return Ratio
end

return ModuleData.TimeLimitPayData