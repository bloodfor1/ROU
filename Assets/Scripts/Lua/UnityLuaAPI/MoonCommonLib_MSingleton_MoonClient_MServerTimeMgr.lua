---@class MoonCommonLib.MSingleton_MoonClient.MServerTimeMgr : MoonCommonLib.MBaseSingleton
---@field public singleton MoonClient.MServerTimeMgr
---@field public IsInited boolean

---@type MoonCommonLib.MSingleton_MoonClient.MServerTimeMgr
MoonCommonLib.MSingleton_MoonClient.MServerTimeMgr = { }
---@return boolean
function MoonCommonLib.MSingleton_MoonClient.MServerTimeMgr:Init() end
function MoonCommonLib.MSingleton_MoonClient.MServerTimeMgr:Uninit() end
---@param clearAccountData boolean
function MoonCommonLib.MSingleton_MoonClient.MServerTimeMgr:OnLogout(clearAccountData) end
return MoonCommonLib.MSingleton_MoonClient.MServerTimeMgr
