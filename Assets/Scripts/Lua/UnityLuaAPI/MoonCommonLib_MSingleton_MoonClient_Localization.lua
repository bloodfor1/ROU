---@class MoonCommonLib.MSingleton_MoonClient.Localization : MoonCommonLib.MBaseSingleton
---@field public singleton MoonClient.Localization
---@field public IsInited boolean

---@type MoonCommonLib.MSingleton_MoonClient.Localization
MoonCommonLib.MSingleton_MoonClient.Localization = { }
---@return boolean
function MoonCommonLib.MSingleton_MoonClient.Localization:Init() end
function MoonCommonLib.MSingleton_MoonClient.Localization:Uninit() end
---@param clearAccountData boolean
function MoonCommonLib.MSingleton_MoonClient.Localization:OnLogout(clearAccountData) end
return MoonCommonLib.MSingleton_MoonClient.Localization
