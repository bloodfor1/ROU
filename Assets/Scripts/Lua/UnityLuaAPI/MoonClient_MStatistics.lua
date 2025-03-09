---@class MoonClient.MStatistics

---@type MoonClient.MStatistics
MoonClient.MStatistics = { }
---@param jsondata string
function MoonClient.MStatistics.DoStatistics(jsondata) end
---@param jsondata string
function MoonClient.MStatistics.GemSetUser(jsondata) end
---@param jsondata string
function MoonClient.MStatistics.GemAnalyseStart(jsondata) end
function MoonClient.MStatistics.GemAnalyseEnd() end
---@param jsondata string
function MoonClient.MStatistics.GemDisconnectEvent(jsondata) end
---@param jsondata string
function MoonClient.MStatistics.GemLoadingEvent(jsondata) end
---@param jsondata string
function MoonClient.MStatistics.GemPayEvent(jsondata) end
function MoonClient.MStatistics.GemDetectInTimeout() end
---@param jsondata string
function MoonClient.MStatistics.AnalyticsSetUserProperty(jsondata) end
return MoonClient.MStatistics
