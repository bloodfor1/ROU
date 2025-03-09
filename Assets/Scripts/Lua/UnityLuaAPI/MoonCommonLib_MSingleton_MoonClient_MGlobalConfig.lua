---@class MoonCommonLib.MSingleton_MoonClient.MGlobalConfig : MoonCommonLib.MBaseSingleton
---@field public singleton MoonClient.MGlobalConfig
---@field public IsInited boolean

---@type MoonCommonLib.MSingleton_MoonClient.MGlobalConfig
MoonCommonLib.MSingleton_MoonClient.MGlobalConfig = { }
---@return boolean
function MoonCommonLib.MSingleton_MoonClient.MGlobalConfig:Init() end
function MoonCommonLib.MSingleton_MoonClient.MGlobalConfig:Uninit() end
---@param clearAccountData boolean
function MoonCommonLib.MSingleton_MoonClient.MGlobalConfig:OnLogout(clearAccountData) end
return MoonCommonLib.MSingleton_MoonClient.MGlobalConfig
