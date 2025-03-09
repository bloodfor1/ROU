---@class MoonCommonLib.MSingleton_MoonClient.StringPoolManager : MoonCommonLib.MBaseSingleton
---@field public singleton MoonClient.StringPoolManager
---@field public IsInited boolean

---@type MoonCommonLib.MSingleton_MoonClient.StringPoolManager
MoonCommonLib.MSingleton_MoonClient.StringPoolManager = { }
---@return boolean
function MoonCommonLib.MSingleton_MoonClient.StringPoolManager:Init() end
function MoonCommonLib.MSingleton_MoonClient.StringPoolManager:Uninit() end
---@param clearAccountData boolean
function MoonCommonLib.MSingleton_MoonClient.StringPoolManager:OnLogout(clearAccountData) end
return MoonCommonLib.MSingleton_MoonClient.StringPoolManager
