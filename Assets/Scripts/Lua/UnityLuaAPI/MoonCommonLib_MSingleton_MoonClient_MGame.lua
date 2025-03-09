---@class MoonCommonLib.MSingleton_MoonClient.MGame : MoonCommonLib.MBaseSingleton
---@field public singleton MoonClient.MGame
---@field public IsInited boolean

---@type MoonCommonLib.MSingleton_MoonClient.MGame
MoonCommonLib.MSingleton_MoonClient.MGame = { }
---@return boolean
function MoonCommonLib.MSingleton_MoonClient.MGame:Init() end
function MoonCommonLib.MSingleton_MoonClient.MGame:Uninit() end
---@param clearAccountData boolean
function MoonCommonLib.MSingleton_MoonClient.MGame:OnLogout(clearAccountData) end
return MoonCommonLib.MSingleton_MoonClient.MGame
