---@class MoonCommonLib.MSingleton_MoonClient.MResLoader : MoonCommonLib.MBaseSingleton
---@field public singleton MoonClient.MResLoader
---@field public IsInited boolean

---@type MoonCommonLib.MSingleton_MoonClient.MResLoader
MoonCommonLib.MSingleton_MoonClient.MResLoader = { }
---@return boolean
function MoonCommonLib.MSingleton_MoonClient.MResLoader:Init() end
function MoonCommonLib.MSingleton_MoonClient.MResLoader:Uninit() end
---@param clearAccountData boolean
function MoonCommonLib.MSingleton_MoonClient.MResLoader:OnLogout(clearAccountData) end
return MoonCommonLib.MSingleton_MoonClient.MResLoader
