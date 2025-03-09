---@class MoonCommonLib.MProfiler

---@type MoonCommonLib.MProfiler
MoonCommonLib.MProfiler = { }
---@return MoonCommonLib.MProfiler
function MoonCommonLib.MProfiler.New() end
function MoonCommonLib.MProfiler.ResetProfile() end
---@param logString string
function MoonCommonLib.MProfiler.WriterProfileLog(logString) end
---@param title string
function MoonCommonLib.MProfiler.BeginSample(title) end
---@param title string
function MoonCommonLib.MProfiler.EndSample(title) end
---@param title string
function MoonCommonLib.MProfiler.BeginProfile(title) end
---@param title string
function MoonCommonLib.MProfiler.EndProfile(title) end
---@param title string
function MoonCommonLib.MProfiler:RegisterGroupProfile(title) end
---@param title string
function MoonCommonLib.MProfiler:BeginGroupProfile(title) end
---@param title string
function MoonCommonLib.MProfiler:EndGroupProfile(title) end
function MoonCommonLib.MProfiler:PrintProfiler() end
return MoonCommonLib.MProfiler
