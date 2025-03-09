---@class MoonCommonLib.MSingleton_MoonClient.MEntityMgr : MoonCommonLib.MBaseSingleton
---@field public singleton MoonClient.MEntityMgr
---@field public IsInited boolean

---@type MoonCommonLib.MSingleton_MoonClient.MEntityMgr
MoonCommonLib.MSingleton_MoonClient.MEntityMgr = { }
---@return boolean
function MoonCommonLib.MSingleton_MoonClient.MEntityMgr:Init() end
function MoonCommonLib.MSingleton_MoonClient.MEntityMgr:Uninit() end
---@param clearAccountData boolean
function MoonCommonLib.MSingleton_MoonClient.MEntityMgr:OnLogout(clearAccountData) end
return MoonCommonLib.MSingleton_MoonClient.MEntityMgr
