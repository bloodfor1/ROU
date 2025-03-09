---@class MoonCommonLib.MSingleton_MoonClient.MPlayerSetting : MoonCommonLib.MBaseSingleton
---@field public singleton MoonClient.MPlayerSetting
---@field public IsInited boolean

---@type MoonCommonLib.MSingleton_MoonClient.MPlayerSetting
MoonCommonLib.MSingleton_MoonClient.MPlayerSetting = { }
---@return boolean
function MoonCommonLib.MSingleton_MoonClient.MPlayerSetting:Init() end
function MoonCommonLib.MSingleton_MoonClient.MPlayerSetting:Uninit() end
---@param clearAccountData boolean
function MoonCommonLib.MSingleton_MoonClient.MPlayerSetting:OnLogout(clearAccountData) end
return MoonCommonLib.MSingleton_MoonClient.MPlayerSetting
