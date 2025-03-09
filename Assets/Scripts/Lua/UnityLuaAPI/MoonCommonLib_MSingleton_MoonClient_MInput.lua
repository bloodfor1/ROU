---@class MoonCommonLib.MSingleton_MoonClient.MInput : MoonCommonLib.MBaseSingleton
---@field public singleton MoonClient.MInput
---@field public IsInited boolean

---@type MoonCommonLib.MSingleton_MoonClient.MInput
MoonCommonLib.MSingleton_MoonClient.MInput = { }
---@return boolean
function MoonCommonLib.MSingleton_MoonClient.MInput:Init() end
function MoonCommonLib.MSingleton_MoonClient.MInput:Uninit() end
---@param clearAccountData boolean
function MoonCommonLib.MSingleton_MoonClient.MInput:OnLogout(clearAccountData) end
return MoonCommonLib.MSingleton_MoonClient.MInput
