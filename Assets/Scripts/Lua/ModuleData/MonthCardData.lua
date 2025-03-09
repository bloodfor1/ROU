--this file is gen by script
--you can edit this file in custom part


--lua model
module("ModuleData.MonthCardData", package.seeall)
--lua model end

--最终显示的月卡奖励字符串
l_finalShowMonCardStr = ""
--月卡的奖励字符串
l_monthCardRewardStr = ""

--是否是首充
l_IsFirstCharge = false
--领取小礼包的时间
l_PickSmallGiftTime = 0
--月卡过期确认
l_MonthCardExpireConfirm = false
--月卡有没有购买过
l_isBuyMonthCard = false
--月卡的激活时间
l_MonthCardActiveTime = 0
--月卡的持续时间
l_MonthCardExistTime = 0

l_MonthCardItemData = {}

local l_expiredTime = 0

EMouthCardShowType = 
{
    LimitedPrivilege = 1,   --限定特权
    AwardPreview = 2,       --奖励预览
    IosSubscribe = 3,       --Ios订阅
}

MonthCardType ={
    Vip = 1,
    NormalRebate = 2,
    SuperRebate = 3
}

--lua functions
function Init()
	
	
end --func end
--next--
function Logout()
    l_finalShowMonCardStr = ""
    l_monthCardRewardStr = ""
    l_IsFirstCharge = false
    l_PickSmallGiftTime = 0
    l_MonthCardExpireConfirm = false
    l_isBuyMonthCard = false
    l_MonthCardActiveTime = 0
    l_MonthCardExistTime = 0
end --func end

--next--
--lua functions end

--lua custom scripts

function SetExpiredTime(time)
    local flag = false
    local endtime = l_expiredTime
    if time == 0 and l_expiredTime ~= 0 then
        flag = true
    end
    l_expiredTime = time
    return flag, endtime
end

--lua custom scripts end
return ModuleData.MonthCardData