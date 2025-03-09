module("ModuleData.LandingAwardData", package.seeall)


--领取按钮背景颜色
BG_TYPE = {
    WHITE = 0,  --白色
    GOLDEN = 1,  --金色
}

SevenDayInfo = nil


-- 获取上次登录时间
function GetLastEnterTime()
    -- 本地数据
    return PlayerPrefs.GetInt(Common.Functions.GetPlayerPrefsKey("SEVEN_DAY_AWARD_PREFS_KEY"), 0)
end

-- 保存登录时间(用于下次登录自动弹出判断逻辑)
function SaveLastEnterTime()
    -- 本地数据
    PlayerPrefs.SetInt(Common.Functions.GetPlayerPrefsKey("SEVEN_DAY_AWARD_PREFS_KEY"), Common.TimeMgr.GetNowTimestamp())
end

function CheckMessageIsSame(info)

    if not SevenDayInfo then
        return false
    end

    if info.cur_reward ~= SevenDayInfo.cur_reward then
        return false
    end

    for i, v in ipairs(info.reward_get_list) do
        if SevenDayInfo[i] ~= v.value then
            return false
        end
    end

    return true
end

function OnGetLandingInfo(info)

    if CheckMessageIsSame(info) then
        return false
    end

    -- 拷贝pb信息
    SevenDayInfo = {}
    SevenDayInfo.cur_reward = info.cur_reward
    for i, v in ipairs(info.reward_get_list) do
        SevenDayInfo[i] = v.value
    end

    return true
end

function ClearAwardData()

    SevenDayInfo = nil
end

return ModuleData.LandingAwardData