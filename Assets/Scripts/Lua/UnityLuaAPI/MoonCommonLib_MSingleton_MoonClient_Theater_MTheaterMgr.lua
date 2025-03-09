---@class MoonCommonLib.MSingleton_MoonClient.Theater.MTheaterMgr : MoonCommonLib.MBaseSingleton
---@field public singleton MoonClient.Theater.MTheaterMgr
---@field public IsInited boolean

---@type MoonCommonLib.MSingleton_MoonClient.Theater.MTheaterMgr
MoonCommonLib.MSingleton_MoonClient.Theater.MTheaterMgr = { }
---@return boolean
function MoonCommonLib.MSingleton_MoonClient.Theater.MTheaterMgr:Init() end
function MoonCommonLib.MSingleton_MoonClient.Theater.MTheaterMgr:Uninit() end
---@param clearAccountData boolean
function MoonCommonLib.MSingleton_MoonClient.Theater.MTheaterMgr:OnLogout(clearAccountData) end
return MoonCommonLib.MSingleton_MoonClient.Theater.MTheaterMgr
