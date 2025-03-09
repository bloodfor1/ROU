---@class MoonCommonLib.MSingleton_MoonClient.MCutSceneMgr : MoonCommonLib.MBaseSingleton
---@field public singleton MoonClient.MCutSceneMgr
---@field public IsInited boolean

---@type MoonCommonLib.MSingleton_MoonClient.MCutSceneMgr
MoonCommonLib.MSingleton_MoonClient.MCutSceneMgr = { }
---@return boolean
function MoonCommonLib.MSingleton_MoonClient.MCutSceneMgr:Init() end
function MoonCommonLib.MSingleton_MoonClient.MCutSceneMgr:Uninit() end
---@param clearAccountData boolean
function MoonCommonLib.MSingleton_MoonClient.MCutSceneMgr:OnLogout(clearAccountData) end
return MoonCommonLib.MSingleton_MoonClient.MCutSceneMgr
