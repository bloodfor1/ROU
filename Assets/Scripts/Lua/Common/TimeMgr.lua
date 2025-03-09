
--Author : tmtan
--Date   : 2017/12/27
--- 文档wiki：https://www.tapd.cn/20332331/markdown_wikis/view/#1120332331001008071
module("Common.TimeMgr", package.seeall)
local MONTH_DAY = {
	{31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}, --非闰年
    {31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}  --闰年
}
--- 本地时间相对于utc时间的秒数
local l_localTimeZoneSecond =nil
DAY_SECONDS = 24 * 3600 --一天的秒数

--region ----获取时间戳------------------------------------
--[Comment]
--from 1970-01-01 utc
function GetNowTimestamp()
    return MLuaCommonHelper.Int(MServerTimeMgr.UtcSeconds)
end

--时区本地时间
function GetLocalNowTimestamp()
    return MLuaCommonHelper.Int(MServerTimeMgr.LocalTimeSeconds)
end

--- 根据utc时间戳换算成服务器本地的时间
function GetLocalTimestamp(utcTimeStamp)
    if utcTimeStamp==nil then
        return nil
    end
    return MLuaCommonHelper.Int(utcTimeStamp + MServerTimeMgr.TimeZoneOffsetValue)
end

--[Comment]
--获取时间戳对应当天的0点时间戳，不传为获取今天的0点时间戳
---@param ts number 需传入服务器本地时区时间戳
-----@return number 返回的为utc的时间戳
function GetDayTimestamp(ts, timeInfo)
    if ts == nil then
        ts = GetLocalNowTimestamp()
    end
    timeInfo = timeInfo or {}
    local l_timeTable = GetTimeTable(ts)
    l_timeTable.hour = timeInfo.hour or 0
    l_timeTable.min = timeInfo.min or 0
    l_timeTable.sec = timeInfo.sec or 0
    return GetUtcTimeByTimeTable(l_timeTable)
end

--- os.time封装，获得不受本地时区影响的utc时间
function GetUtcTimeByTimeTable(timeTable)
    return os.time(timeTable) + GetLocalTimeZoneDiffSecond()
end

--- 获取本地时区相对于服务器时区偏移的时间（单位秒）
function GetLocalTimeZoneDiffSecond()
    if l_localTimeZoneSecond ==nil then
        local l_nowTime = os.time()
        l_localTimeZoneSecond = os.difftime(l_nowTime, os.time(os.date("!*t", l_nowTime)))
    end
    return l_localTimeZoneSecond - MServerTimeMgr.TimeZoneOffsetValue
end

--[Comment]
--2015-01-20 00:00:00 格式的时间转成时间戳
---@return number 返回的为utc时区的时间戳
function ParseDateToTimestamp(dateTimeStr)
    local l_timeStr = string.gsub(dateTimeStr, "%W", "")
    local l_y = string.sub(l_timeStr , 1, 4)
    local l_m = string.sub(l_timeStr , 5, 6)
    local l_d = string.sub(l_timeStr , 7, 8)
    local l_h = string.sub(l_timeStr , 9, 10)
    local l_min = string.sub(l_timeStr , 11, 12)
    local l_sec = string.sub(l_timeStr , 13, 14)
    return GetUtcTimeByTimeTable({year=l_y, month=l_m, day=l_d, hour=l_h, min=l_min, sec=l_sec})
end

-- 20210606格式转换为时间戳
---@return number 返回值为utc的时间戳
function ParseTableTimeToTimestamp(timeStr)
    local l_year = tonumber(string.sub(timeStr, 1, 4)) or 0
    local l_month = tonumber(string.sub(timeStr, 5, 6)) or 0
    local l_day = tonumber(string.sub(timeStr, 7, 8)) or 0
    return GetUtcTimeByTimeTable({year=l_year, month=l_month, day=l_day}) or 0
end

--- 获取自定义时间的时间撮，如果timeInfo为nil则获取0点的时间戳
--- 返回服务器时区的时间
function GetCustomTimestamp(timeInfo)
    if not timeInfo then return 0 end
    local l_hour = timeInfo.hour or 0
    local l_min = timeInfo.min or 0
    local l_sec = timeInfo.sec or 0
    local l_curTimeTable = os.date("!*t",GetLocalNowTimestamp())
    l_curTimeTable.hour = l_hour
    l_curTimeTable.min = l_min
    l_curTimeTable.sec = l_sec
    if timeInfo.dayOffset then
        l_curTimeTable.day = l_curTimeTable.day + timeInfo.dayOffset
    end
    return GetUtcTimeByTimeTable(l_curTimeTable) + MServerTimeMgr.TimeZoneOffsetValue
end
--endregion ----获取时间戳------------------------------------

--region ----转换时间显示格式------------------------------------
--[Comment]
--获取时间戳代表日期的数字形式（Ymd）
---@param timestamp number 传入utc时间戳
function GetDateNumByTimestamp(timestamp)
	timestamp = GetLocalTimestamp(timestamp) or Common.TimeMgr.GetLocalNowTimestamp()
    return tonumber(os.date("!%Y%m%d", timestamp))
end

--[Comment]
--00:00:00格式的时间转为秒
function ParseDayTimeToTimestamp(dayTimeStr)
    local l_timeStr = string.gsub(dayTimeStr, "%W", "")
    local l_h = tonumber(string.sub(l_timeStr, 1, 2)) or 0
    local l_m = tonumber(string.sub(l_timeStr, 3, 4)) or 0
    local l_s = tonumber(string.sub(l_timeStr, 5, 6)) or 0

    return l_h * 3600 + l_m * 60 + l_s
end

-- 根据时间戳显示，xx年xx月xx日
---传utc时间戳
function GetDataShowTime(timeStamp)
    local l_time =  os.date("!*t", GetLocalTimestamp(timeStamp))
    return Lang("DATE_YY_MM_DD", l_time.year, l_time.month, l_time.day)
end

---@Description:获得yyyy-MM-dd HH:mm:ss格式时间
---@param timeStamp number utc时间撮
---@param format string 时间显示格式 默认为 !%Y-%m-%d %H:%M:%S
function GetChatTimeFormatStr(timeStamp,format)
    if format == nil then
        format = "!%Y-%m-%d %H:%M:%S"
    end
    return os.date(format,GetLocalTimestamp(timeStamp))
end
--endregion ----转换时间显示格式------------------------------------

--region ---常用的时间戳操作--------------------------------------------
--[Comment]
--判断两个时间戳是否在同一天
--- ts1和ts2均为utc时间戳
function IsSameDayByTimestamp(ts1, ts2)
    --判断是否是同一天
    --return math.floor(ts1 / DAY_SECONDS) == math.floor(ts2 / DAY_SECONDS)---这个判断是错误的
    return not MLuaClientHelper.CheckAcrossDay(ts1*1000,ts2*1000)
end

--[Comment]
--判断时间戳是否是今天
--@param timestamp: 需要判断的utc时间戳
--@return: true 是今天 false 不是今天
function CheckIsTodayByTimestamp(timestamp)
    local l_nowTimestamp = GetNowTimestamp()
    return IsSameDayByTimestamp(timestamp, l_nowTimestamp)
end

--[Comment]
--获取两个时间戳之间差了几天
function GetDiffDayByTimestamp(t1, t2, offset)
    local l_time1 = GetDayTimeStamp(t1 - offset)
    local l_time2 = GetDayTimeStamp(t2 - offset)
    if l_time2 < l_time1 then
        local tmp = l_time2
        l_time2 = l_time1
        l_time1 = tmp
    end
    return math.floor((l_time2 - l_time1) / 86400)
end
--获得当前时间为周几，0~6 ，0代表周日
function GetNowWeekDay()
    return tonumber(os.date("!%w", Common.TimeMgr.GetLocalNowTimestamp()))
end

--比较两个时间的大小 表包含 {year, month, day, hour, min, sec}
function CompareTimeTable(timeTable1, timeTable2)
    local l_t1 = GetUtcTimeByTimeTable(timeTable1)
    local l_t2 = GetUtcTimeByTimeTable(timeTable2)

    if l_t1 < l_t1 then
        return -1
    elseif l_t1 == l_t2 then
        return 0
    else
        return 1
    end
end
--endregion ---常用的时间戳操作--------------------------------------------

--region ----- 获取TimeTable格式时间数据 ----------------------------------
function GetNowTimeTable()
    return GetTimeTable(GetLocalNowTimestamp())
end

--[Comment]
--根据时间戳返回一个表包含 {year = 2017, month = 12, day = 28, yday = 362, wday = 5, hour = 17, min = 46, sec = 52, isdst = false}
---@param ts string 传入服务器本地时区时间戳
function GetTimeTable(ts)
    ts = tonumber(ts)
    if ts == nil then
        return nil
    end

    return os.date("!*t", ts)
end 
---@param ts string 传入服务器本地时区时间戳
function GetTimeTableByTimeStr(ts)
    if ts == nil then
        return nil
    end
    return os.date("!*t", ts)
end

--将单位为秒的时间戳转换为 {hour, min, sec}
function GetDayTimeTable(ts)
    local v = tonumber(ts)
    if v == nil then
        v = 0
    end

    local l_res = {}
    l_res.sec = v % 60
    v = math.floor(v/60)
    l_res.min = v % 60
    v = math.floor(v/60)
    l_res.hour = v % 24
    return l_res
end

--根据时间戳获得倒计时表 {day,hour, min, sec}
function GetCountDownDayTimeTable(ts)
    ts = tonumber(ts)
    if ts == nil then
        ts = 0
    end

    local ret = {}
    ret.day = math.floor(ts / 86400)
    ret.hour = math.floor(math.fmod(ts, 86400) / 3600)
    ret.min = math.floor(math.fmod(ts, 3600) / 60)
    ret.sec = math.fmod(ts, 60)
    return ret
end
--endregion ----- 获取TimeTable格式时间数据 ----------------------------------

--region --------获取时间字符串----------------------------------------------
--- 将时间撮转化为 {0}天{0}秒{0}分
function GetLeftTimeStrEx(timestamp)
    local leftTime = GetCountDownDayTimeTable(timestamp)
    local l_string = ""
    local flag = false

    if leftTime.day > 0 then
        flag = true
        l_string = l_string .. Common.Utils.Lang("TIME_DAY",leftTime.day)
    end
    
    if flag == true or leftTime.hour > 0 then
        flag = true
        l_string = l_string .. Common.Utils.Lang("TIME_HOUR",leftTime.hour)
    end

    if leftTime.sec > 0 and leftTime.min<59 then
        l_string = l_string .. Common.Utils.Lang("TIME_MINUTE",leftTime.min+1)
    else
        l_string = l_string .. Common.Utils.Lang("TIME_MINUTE",leftTime.min)
    end

    return l_string
end
--- 将时间撮转化为 {0}天{0}秒{0}分{0}秒
function GetLeftTimeStrAccurateToSecond(timestamp)
    local l_tmpTime = timestamp - GetNowTimestamp()
    if l_tmpTime < 0 then
        l_tmpTime = 0
    end
    local leftTime = GetCountDownDayTimeTable(l_tmpTime)
    local l_string = ""
    local flag = false

    if leftTime.day > 0 then
        flag = true
        l_string = l_string .. Common.Utils.Lang("TIME_DAY",leftTime.day)
    end

    if flag == true or leftTime.hour > 0 then
        flag = true
        l_string = l_string .. Common.Utils.Lang("TIME_HOUR",leftTime.hour)
    end

    if flag == true or leftTime.min > 0 then
        flag = true
        l_string = l_string .. Common.Utils.Lang("TIME_MINUTE",leftTime.min)
    end

    if flag == true or leftTime.sec > 0 then
        flag = true
        l_string = l_string .. Common.Utils.Lang("TIMESHOW_S",leftTime.sec)
    end

    if not flag then
        l_string =  Common.Utils.Lang("TIMESHOW_S",0)
    end
    return l_string
end

--- 将时间撮转化为 {0}月{0}天{0}秒{0}分{0}秒
function GetLeftTimeStr(timestamp)
    local l_time = tonumber(timestamp)
    local l_string = ""
    if l_time == nil or l_time == 0 then
        return l_string
    end

    local l_tmpTime = l_time - GetNowTimestamp()
    if l_tmpTime < 0 then
        l_tmpTime = 0
    end

    local l_day = math.floor(l_tmpTime / 86400)

    if l_day >= 30 then
        l_string = Lang("TIME_MONTH", tostring(math.floor(l_day / 30)))
    elseif l_day > 0 then
        l_string = Lang("TIME_DAY", tostring(l_day))
    else
        if l_tmpTime > 3599 then
            l_string = Lang("TIME_HOUR", tostring(math.floor(l_tmpTime / 3600)))
        else
            if l_tmpTime < 60 then l_tmpTime = 60 end
            l_string = Lang("TIME_MINUTE", tostring(math.floor(l_tmpTime / 60)))
        end
    end

    return l_string
end

--[Comment]
--获取该月有多少天
--@param year 哪一年（如：2017）
--@param month 哪个月（如：12）
function GetDayNumOfMonth(year, month)
    local function _leapYear(year)
        if (math.mod(year, 4) == 0 and math.mod(year, 100) ~= 0) or math.mod(year, 400) == 0 then
            return true
        end
        return false
    end

    if _leapYear(year) then
        return MONTH_DAY[2][month]
    else
        return MONTH_DAY[1][month]
    end
end

-- 将秒转化为00:00:00
function GetSecondToHMS(second)
    local l_hour = math.floor(second / 3600)
    local l_minute = math.floor((second % 3600) / 60)
    local l_second = second % 60
    return StringEx.Format("{0:00}:{1:00}:{2:00}", l_hour, l_minute, l_second)
end
--endregion --------获取时间字符串----------------------------------------------
return Common.TimeMgr