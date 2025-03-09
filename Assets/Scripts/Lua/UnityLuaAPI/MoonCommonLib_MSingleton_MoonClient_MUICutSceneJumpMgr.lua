---@class MoonCommonLib.MSingleton_MoonClient.MUICutSceneJumpMgr : MoonCommonLib.MBaseSingleton
---@field public singleton MoonClient.MUICutSceneJumpMgr
---@field public IsInited boolean

---@type MoonCommonLib.MSingleton_MoonClient.MUICutSceneJumpMgr
MoonCommonLib.MSingleton_MoonClient.MUICutSceneJumpMgr = { }
---@return boolean
function MoonCommonLib.MSingleton_MoonClient.MUICutSceneJumpMgr:Init() end
function MoonCommonLib.MSingleton_MoonClient.MUICutSceneJumpMgr:Uninit() end
---@param clearAccountData boolean
function MoonCommonLib.MSingleton_MoonClient.MUICutSceneJumpMgr:OnLogout(clearAccountData) end
return MoonCommonLib.MSingleton_MoonClient.MUICutSceneJumpMgr
