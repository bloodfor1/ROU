---@class MoonCommonLib.MSingleton_MoonClient.MNetClient : MoonCommonLib.MBaseSingleton
---@field public singleton MoonClient.MNetClient
---@field public IsInited boolean

---@type MoonCommonLib.MSingleton_MoonClient.MNetClient
MoonCommonLib.MSingleton_MoonClient.MNetClient = { }
---@return boolean
function MoonCommonLib.MSingleton_MoonClient.MNetClient:Init() end
function MoonCommonLib.MSingleton_MoonClient.MNetClient:Uninit() end
---@param clearAccountData boolean
function MoonCommonLib.MSingleton_MoonClient.MNetClient:OnLogout(clearAccountData) end
return MoonCommonLib.MSingleton_MoonClient.MNetClient
