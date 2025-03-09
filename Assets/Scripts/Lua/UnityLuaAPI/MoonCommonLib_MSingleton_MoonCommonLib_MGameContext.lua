---@class MoonCommonLib.MSingleton_MoonCommonLib.MGameContext : MoonCommonLib.MBaseSingleton
---@field public singleton MoonCommonLib.MGameContext
---@field public IsInited boolean

---@type MoonCommonLib.MSingleton_MoonCommonLib.MGameContext
MoonCommonLib.MSingleton_MoonCommonLib.MGameContext = { }
---@return boolean
function MoonCommonLib.MSingleton_MoonCommonLib.MGameContext:Init() end
function MoonCommonLib.MSingleton_MoonCommonLib.MGameContext:Uninit() end
---@param clearAccountData boolean
function MoonCommonLib.MSingleton_MoonCommonLib.MGameContext:OnLogout(clearAccountData) end
return MoonCommonLib.MSingleton_MoonCommonLib.MGameContext
