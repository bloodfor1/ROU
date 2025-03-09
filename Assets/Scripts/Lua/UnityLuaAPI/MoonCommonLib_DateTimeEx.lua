---@class MoonCommonLib.DateTimeEx

---@type MoonCommonLib.DateTimeEx
MoonCommonLib.DateTimeEx = { }
---@return MoonCommonLib.DateTimeEx
function MoonCommonLib.DateTimeEx.New() end
---@return System.DateTime
---@param cppTime int64
function MoonCommonLib.DateTimeEx.FromCppSecond2CsDateTime(cppTime) end
---@return int64
function MoonCommonLib.DateTimeEx.GetCurrentMsTime() end
return MoonCommonLib.DateTimeEx
