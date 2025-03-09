---@class MoonCommonLib.MSingleton_MoonClient.MResGoPool : MoonCommonLib.MBaseSingleton
---@field public singleton MoonClient.MResGoPool
---@field public IsInited boolean

---@type MoonCommonLib.MSingleton_MoonClient.MResGoPool
MoonCommonLib.MSingleton_MoonClient.MResGoPool = { }
---@return boolean
function MoonCommonLib.MSingleton_MoonClient.MResGoPool:Init() end
function MoonCommonLib.MSingleton_MoonClient.MResGoPool:Uninit() end
---@param clearAccountData boolean
function MoonCommonLib.MSingleton_MoonClient.MResGoPool:OnLogout(clearAccountData) end
return MoonCommonLib.MSingleton_MoonClient.MResGoPool
