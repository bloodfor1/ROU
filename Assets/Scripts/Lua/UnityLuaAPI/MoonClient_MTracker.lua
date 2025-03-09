---@class MoonClient.MTracker

---@type MoonClient.MTracker
MoonClient.MTracker = { }
---@param jsondata string
function MoonClient.MTracker.TrackEvent(jsondata) end
---@param jsondata string
function MoonClient.MTracker.TrackPurchaseCpmplete(jsondata) end
---@param jsondata string
function MoonClient.MTracker.TrackAddCallbackParameter(jsondata) end
---@param jsondata string
function MoonClient.MTracker.TrackAddPartnerParameter(jsondata) end
---@param jsondata string
function MoonClient.MTracker.SetPushToken(jsondata) end
---@param jsondata string
function MoonClient.MTracker.OperaterSessionPartnerParameter(jsondata) end
---@param jsondata string
function MoonClient.MTracker.OperaterSessionCallbackParameter(jsondata) end
---@param jsondata string
function MoonClient.MTracker.TrackAdRevenue(jsondata) end
---@return string
function MoonClient.MTracker.GetAdid() end
---@return string
function MoonClient.MTracker.GetAttribution() end
---@return string
function MoonClient.MTracker.GetIdfa() end
return MoonClient.MTracker
