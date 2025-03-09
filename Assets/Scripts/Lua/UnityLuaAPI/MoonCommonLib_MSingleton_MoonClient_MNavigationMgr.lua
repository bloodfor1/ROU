---@class MoonCommonLib.MSingleton_MoonClient.MNavigationMgr : MoonCommonLib.MBaseSingleton
---@field public singleton MoonClient.MNavigationMgr
---@field public IsInited boolean

---@type MoonCommonLib.MSingleton_MoonClient.MNavigationMgr
MoonCommonLib.MSingleton_MoonClient.MNavigationMgr = { }
---@return boolean
function MoonCommonLib.MSingleton_MoonClient.MNavigationMgr:Init() end
function MoonCommonLib.MSingleton_MoonClient.MNavigationMgr:Uninit() end
---@param clearAccountData boolean
function MoonCommonLib.MSingleton_MoonClient.MNavigationMgr:OnLogout(clearAccountData) end
return MoonCommonLib.MSingleton_MoonClient.MNavigationMgr
