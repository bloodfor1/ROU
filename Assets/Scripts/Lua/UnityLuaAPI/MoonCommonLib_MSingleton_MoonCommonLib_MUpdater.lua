---@class MoonCommonLib.MSingleton_MoonCommonLib.MUpdater : MoonCommonLib.MBaseSingleton
---@field public singleton MoonCommonLib.MUpdater
---@field public IsInited boolean

---@type MoonCommonLib.MSingleton_MoonCommonLib.MUpdater
MoonCommonLib.MSingleton_MoonCommonLib.MUpdater = { }
---@return boolean
function MoonCommonLib.MSingleton_MoonCommonLib.MUpdater:Init() end
function MoonCommonLib.MSingleton_MoonCommonLib.MUpdater:Uninit() end
---@param clearAccountData boolean
function MoonCommonLib.MSingleton_MoonCommonLib.MUpdater:OnLogout(clearAccountData) end
return MoonCommonLib.MSingleton_MoonCommonLib.MUpdater
