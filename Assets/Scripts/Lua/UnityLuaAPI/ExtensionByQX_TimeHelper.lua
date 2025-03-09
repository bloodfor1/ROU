---@class ExtensionByQX.TimeHelper
---@field public Time1970 System.DateTime
---@field public ServerTime System.DateTime

---@type ExtensionByQX.TimeHelper
ExtensionByQX.TimeHelper = { }
---@return string
---@param second int64
---@param format string
function ExtensionByQX.TimeHelper.SecondConvertTime(second, format) end
---@return string
---@param dateTime System.DateTime
---@param format string
function ExtensionByQX.TimeHelper.GetTimeStringByDataTime(dateTime, format) end
---@return System.DateTime
---@param data System.DateTime
function ExtensionByQX.TimeHelper.GetTodayStart(data) end
---@return number
---@param data System.DateTime
function ExtensionByQX.TimeHelper.GetTodayTotalSecond(data) end
---@return number
---@param todayTime System.DateTime
---@param lastSecond number
function ExtensionByQX.TimeHelper.GetDeltaSecondsByDayTime(todayTime, lastSecond) end
---@return number
---@param beforeSecond int64
---@param lastTime System.DateTime
function ExtensionByQX.TimeHelper.GetDeltaSeconds(beforeSecond, lastTime) end
---@return number
---@param beforeSecond int64
function ExtensionByQX.TimeHelper.DeltaSecondsWithServerTime(beforeSecond) end
function ExtensionByQX.TimeHelper.CheckIsHaveOneDay() end
---@return int64
---@param data System.DateTime
function ExtensionByQX.TimeHelper.DateTimeToTimestamp(data) end
---@overload fun(timestamp:int64): System.DateTime
---@overload fun(timestamp:number): System.DateTime
---@return System.DateTime
---@param timestamp string
function ExtensionByQX.TimeHelper.TimestampToDateTime(timestamp) end
---@overload fun(ticks:string): int64
---@return int64
---@param ticks int64
function ExtensionByQX.TimeHelper.TicksToSeconds(ticks) end
---@return int64
---@param seconds int64
function ExtensionByQX.TimeHelper.SecondsToTicks(seconds) end
return ExtensionByQX.TimeHelper
