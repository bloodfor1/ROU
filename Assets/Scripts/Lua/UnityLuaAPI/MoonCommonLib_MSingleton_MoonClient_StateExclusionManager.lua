---@class MoonCommonLib.MSingleton_MoonClient.StateExclusionManager : MoonCommonLib.MBaseSingleton
---@field public singleton MoonClient.StateExclusionManager
---@field public IsInited boolean

---@type MoonCommonLib.MSingleton_MoonClient.StateExclusionManager
MoonCommonLib.MSingleton_MoonClient.StateExclusionManager = { }
---@return boolean
function MoonCommonLib.MSingleton_MoonClient.StateExclusionManager:Init() end
function MoonCommonLib.MSingleton_MoonClient.StateExclusionManager:Uninit() end
---@param clearAccountData boolean
function MoonCommonLib.MSingleton_MoonClient.StateExclusionManager:OnLogout(clearAccountData) end
return MoonCommonLib.MSingleton_MoonClient.StateExclusionManager
