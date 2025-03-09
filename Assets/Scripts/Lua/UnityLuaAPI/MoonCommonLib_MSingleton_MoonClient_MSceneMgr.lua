---@class MoonCommonLib.MSingleton_MoonClient.MSceneMgr : MoonCommonLib.MBaseSingleton
---@field public singleton MoonClient.MSceneMgr
---@field public IsInited boolean

---@type MoonCommonLib.MSingleton_MoonClient.MSceneMgr
MoonCommonLib.MSingleton_MoonClient.MSceneMgr = { }
---@return boolean
function MoonCommonLib.MSingleton_MoonClient.MSceneMgr:Init() end
function MoonCommonLib.MSingleton_MoonClient.MSceneMgr:Uninit() end
---@param clearAccountData boolean
function MoonCommonLib.MSingleton_MoonClient.MSceneMgr:OnLogout(clearAccountData) end
return MoonCommonLib.MSingleton_MoonClient.MSceneMgr
