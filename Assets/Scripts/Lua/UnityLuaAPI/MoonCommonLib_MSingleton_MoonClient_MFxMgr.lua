---@class MoonCommonLib.MSingleton_MoonClient.MFxMgr : MoonCommonLib.MBaseSingleton
---@field public singleton MoonClient.MFxMgr
---@field public IsInited boolean

---@type MoonCommonLib.MSingleton_MoonClient.MFxMgr
MoonCommonLib.MSingleton_MoonClient.MFxMgr = { }
---@return boolean
function MoonCommonLib.MSingleton_MoonClient.MFxMgr:Init() end
function MoonCommonLib.MSingleton_MoonClient.MFxMgr:Uninit() end
---@param clearAccountData boolean
function MoonCommonLib.MSingleton_MoonClient.MFxMgr:OnLogout(clearAccountData) end
return MoonCommonLib.MSingleton_MoonClient.MFxMgr
