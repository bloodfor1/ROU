---@class MoonCommonLib.MSingleton_MoonClient.MScene : MoonCommonLib.MBaseSingleton
---@field public singleton MoonClient.MScene
---@field public IsInited boolean

---@type MoonCommonLib.MSingleton_MoonClient.MScene
MoonCommonLib.MSingleton_MoonClient.MScene = { }
---@return boolean
function MoonCommonLib.MSingleton_MoonClient.MScene:Init() end
function MoonCommonLib.MSingleton_MoonClient.MScene:Uninit() end
---@param clearAccountData boolean
function MoonCommonLib.MSingleton_MoonClient.MScene:OnLogout(clearAccountData) end
return MoonCommonLib.MSingleton_MoonClient.MScene
