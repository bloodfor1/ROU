---@class MoonCommonLib.MSingleton_MoonClient.MPlayerInfo : MoonCommonLib.MBaseSingleton
---@field public singleton MoonClient.MPlayerInfo
---@field public IsInited boolean

---@type MoonCommonLib.MSingleton_MoonClient.MPlayerInfo
MoonCommonLib.MSingleton_MoonClient.MPlayerInfo = { }
---@return boolean
function MoonCommonLib.MSingleton_MoonClient.MPlayerInfo:Init() end
function MoonCommonLib.MSingleton_MoonClient.MPlayerInfo:Uninit() end
---@param clearAccountData boolean
function MoonCommonLib.MSingleton_MoonClient.MPlayerInfo:OnLogout(clearAccountData) end
return MoonCommonLib.MSingleton_MoonClient.MPlayerInfo
