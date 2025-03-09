---@class MoonCommonLib.MSingleton_MoonClient.MSceneWallTriggerMgr : MoonCommonLib.MBaseSingleton
---@field public singleton MoonClient.MSceneWallTriggerMgr
---@field public IsInited boolean

---@type MoonCommonLib.MSingleton_MoonClient.MSceneWallTriggerMgr
MoonCommonLib.MSingleton_MoonClient.MSceneWallTriggerMgr = { }
---@return boolean
function MoonCommonLib.MSingleton_MoonClient.MSceneWallTriggerMgr:Init() end
function MoonCommonLib.MSingleton_MoonClient.MSceneWallTriggerMgr:Uninit() end
---@param clearAccountData boolean
function MoonCommonLib.MSingleton_MoonClient.MSceneWallTriggerMgr:OnLogout(clearAccountData) end
return MoonCommonLib.MSingleton_MoonClient.MSceneWallTriggerMgr
