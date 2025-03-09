---@class MoonCommonLib.MSingleton_MoonClient.MCppTableLoader : MoonCommonLib.MBaseSingleton
---@field public singleton MoonClient.MCppTableLoader
---@field public IsInited boolean

---@type MoonCommonLib.MSingleton_MoonClient.MCppTableLoader
MoonCommonLib.MSingleton_MoonClient.MCppTableLoader = { }
---@return boolean
function MoonCommonLib.MSingleton_MoonClient.MCppTableLoader:Init() end
function MoonCommonLib.MSingleton_MoonClient.MCppTableLoader:Uninit() end
---@param clearAccountData boolean
function MoonCommonLib.MSingleton_MoonClient.MCppTableLoader:OnLogout(clearAccountData) end
return MoonCommonLib.MSingleton_MoonClient.MCppTableLoader
