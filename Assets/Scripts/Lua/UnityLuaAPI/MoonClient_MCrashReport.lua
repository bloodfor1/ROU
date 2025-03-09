---@class MoonClient.MCrashReport

---@type MoonClient.MCrashReport
MoonClient.MCrashReport = { }
---@param jsondata string
function MoonClient.MCrashReport.SetUserId(jsondata) end
---@param jsondata string
function MoonClient.MCrashReport.SetScene(jsondata) end
---@param jsondata string
function MoonClient.MCrashReport.SetAppVersion(jsondata) end
---@param jsondata string
function MoonClient.MCrashReport.AddSceneData(jsondata) end
function MoonClient.MCrashReport.TestCrash() end
---@param jsondata string
function MoonClient.MCrashReport.BuglySetCrashFilter(jsondata) end
---@param jsondata string
function MoonClient.MCrashReport.BuglySetCrashRegularFilter(jsondata) end
return MoonClient.MCrashReport
