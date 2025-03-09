---@class MoonCommonLib.MSingleton_MoonClient.MStageMgr : MoonCommonLib.MBaseSingleton
---@field public singleton MoonClient.MStageMgr
---@field public IsInited boolean

---@type MoonCommonLib.MSingleton_MoonClient.MStageMgr
MoonCommonLib.MSingleton_MoonClient.MStageMgr = { }
---@return boolean
function MoonCommonLib.MSingleton_MoonClient.MStageMgr:Init() end
function MoonCommonLib.MSingleton_MoonClient.MStageMgr:Uninit() end
---@param clearAccountData boolean
function MoonCommonLib.MSingleton_MoonClient.MStageMgr:OnLogout(clearAccountData) end
return MoonCommonLib.MSingleton_MoonClient.MStageMgr
