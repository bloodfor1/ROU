---@class MoonCommonLib.MSingleton_MoonClient.MPreloadConfig : MoonCommonLib.MBaseSingleton
---@field public singleton MoonClient.MPreloadConfig
---@field public IsInited boolean

---@type MoonCommonLib.MSingleton_MoonClient.MPreloadConfig
MoonCommonLib.MSingleton_MoonClient.MPreloadConfig = { }
---@return boolean
function MoonCommonLib.MSingleton_MoonClient.MPreloadConfig:Init() end
function MoonCommonLib.MSingleton_MoonClient.MPreloadConfig:Uninit() end
---@param clearAccountData boolean
function MoonCommonLib.MSingleton_MoonClient.MPreloadConfig:OnLogout(clearAccountData) end
return MoonCommonLib.MSingleton_MoonClient.MPreloadConfig
