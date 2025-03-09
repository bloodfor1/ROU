---@class MoonCommonLib.MSingleton_MoonClient.MVirtualTab : MoonCommonLib.MBaseSingleton
---@field public singleton MoonClient.MVirtualTab
---@field public IsInited boolean

---@type MoonCommonLib.MSingleton_MoonClient.MVirtualTab
MoonCommonLib.MSingleton_MoonClient.MVirtualTab = { }
---@return boolean
function MoonCommonLib.MSingleton_MoonClient.MVirtualTab:Init() end
function MoonCommonLib.MSingleton_MoonClient.MVirtualTab:Uninit() end
---@param clearAccountData boolean
function MoonCommonLib.MSingleton_MoonClient.MVirtualTab:OnLogout(clearAccountData) end
return MoonCommonLib.MSingleton_MoonClient.MVirtualTab
