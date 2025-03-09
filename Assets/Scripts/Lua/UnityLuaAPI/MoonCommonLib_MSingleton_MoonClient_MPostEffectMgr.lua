---@class MoonCommonLib.MSingleton_MoonClient.MPostEffectMgr : MoonCommonLib.MBaseSingleton
---@field public singleton MoonClient.MPostEffectMgr
---@field public IsInited boolean

---@type MoonCommonLib.MSingleton_MoonClient.MPostEffectMgr
MoonCommonLib.MSingleton_MoonClient.MPostEffectMgr = { }
---@return boolean
function MoonCommonLib.MSingleton_MoonClient.MPostEffectMgr:Init() end
function MoonCommonLib.MSingleton_MoonClient.MPostEffectMgr:Uninit() end
---@param clearAccountData boolean
function MoonCommonLib.MSingleton_MoonClient.MPostEffectMgr:OnLogout(clearAccountData) end
return MoonCommonLib.MSingleton_MoonClient.MPostEffectMgr
