---@class MoonCommonLib.MSingleton_MoonClient.CommandSystem.CommandBlockManager : MoonCommonLib.MBaseSingleton
---@field public singleton MoonClient.CommandSystem.CommandBlockManager
---@field public IsInited boolean

---@type MoonCommonLib.MSingleton_MoonClient.CommandSystem.CommandBlockManager
MoonCommonLib.MSingleton_MoonClient.CommandSystem.CommandBlockManager = { }
---@return boolean
function MoonCommonLib.MSingleton_MoonClient.CommandSystem.CommandBlockManager:Init() end
function MoonCommonLib.MSingleton_MoonClient.CommandSystem.CommandBlockManager:Uninit() end
---@param clearAccountData boolean
function MoonCommonLib.MSingleton_MoonClient.CommandSystem.CommandBlockManager:OnLogout(clearAccountData) end
return MoonCommonLib.MSingleton_MoonClient.CommandSystem.CommandBlockManager
