---@class MoonCommonLib.MSingleton_MoonClient.MSceneFirstInMgr : MoonCommonLib.MBaseSingleton
---@field public singleton MoonClient.MSceneFirstInMgr
---@field public IsInited boolean

---@type MoonCommonLib.MSingleton_MoonClient.MSceneFirstInMgr
MoonCommonLib.MSingleton_MoonClient.MSceneFirstInMgr = { }
---@return boolean
function MoonCommonLib.MSingleton_MoonClient.MSceneFirstInMgr:Init() end
function MoonCommonLib.MSingleton_MoonClient.MSceneFirstInMgr:Uninit() end
---@param clearAccountData boolean
function MoonCommonLib.MSingleton_MoonClient.MSceneFirstInMgr:OnLogout(clearAccountData) end
return MoonCommonLib.MSingleton_MoonClient.MSceneFirstInMgr
