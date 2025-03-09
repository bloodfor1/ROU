---@class MoonCommonLib.MSingleton_MoonClient.MAnimationMgr : MoonCommonLib.MBaseSingleton
---@field public singleton MoonClient.MAnimationMgr
---@field public IsInited boolean

---@type MoonCommonLib.MSingleton_MoonClient.MAnimationMgr
MoonCommonLib.MSingleton_MoonClient.MAnimationMgr = { }
---@return boolean
function MoonCommonLib.MSingleton_MoonClient.MAnimationMgr:Init() end
function MoonCommonLib.MSingleton_MoonClient.MAnimationMgr:Uninit() end
---@param clearAccountData boolean
function MoonCommonLib.MSingleton_MoonClient.MAnimationMgr:OnLogout(clearAccountData) end
return MoonCommonLib.MSingleton_MoonClient.MAnimationMgr
