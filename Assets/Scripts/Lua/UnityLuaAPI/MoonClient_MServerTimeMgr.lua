---@class MoonClient.MServerTimeMgr : MoonCommonLib.MSingleton_MoonClient.MServerTimeMgr
---@field public NET_GREEN number
---@field public NET_YELLOW number
---@field public NET_RED number
---@field public DelayMilles int64
---@field public DelaySeconds number
---@field public ServerTime System.DateTime
---@field public UtcMillis int64
---@field public UtcSeconds int64
---@field public UtcSeconds_u number
---@field public LastSyncServerTime uint64
---@field public TimeZoneOffsetTicks int64
---@field public LocalTimeSeconds int64
---@field public TimeZoneOffsetValue number
---@field public NetworkState number

---@type MoonClient.MServerTimeMgr
MoonClient.MServerTimeMgr = { }
---@return MoonClient.MServerTimeMgr
function MoonClient.MServerTimeMgr.New() end
---@return boolean
function MoonClient.MServerTimeMgr:Init() end
function MoonClient.MServerTimeMgr:Uninit() end
---@param deltaTime number
function MoonClient.MServerTimeMgr:Update(deltaTime) end
---@return int64
---@param utcSeonds int64
function MoonClient.MServerTimeMgr:GetLocalTimeTickByUtcTime(utcSeonds) end
---@return boolean
function MoonClient.MServerTimeMgr:IsSameTimeZone() end
---@return string
function MoonClient.MServerTimeMgr:GetCurrentDeviceTimeStr() end
---@param serverTime int64
---@param timeZone number
---@param sendAt int64
---@param replayAt int64
function MoonClient.MServerTimeMgr:OnSyncTime(serverTime, timeZone, sendAt, replayAt) end
function MoonClient.MServerTimeMgr:OnSyncTimeout() end
return MoonClient.MServerTimeMgr
