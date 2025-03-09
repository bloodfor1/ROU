---@class MoonCommonLib.MSingleton_MoonClient.MUIManager : MoonCommonLib.MBaseSingleton
---@field public singleton MoonClient.MUIManager
---@field public IsInited boolean

---@type MoonCommonLib.MSingleton_MoonClient.MUIManager
MoonCommonLib.MSingleton_MoonClient.MUIManager = { }
---@return boolean
function MoonCommonLib.MSingleton_MoonClient.MUIManager:Init() end
function MoonCommonLib.MSingleton_MoonClient.MUIManager:Uninit() end
---@param clearAccountData boolean
function MoonCommonLib.MSingleton_MoonClient.MUIManager:OnLogout(clearAccountData) end
return MoonCommonLib.MSingleton_MoonClient.MUIManager
