---@class MoonCommonLib.MSingleton_MoonClient.MUICameraRTManager : MoonCommonLib.MBaseSingleton
---@field public singleton MoonClient.MUICameraRTManager
---@field public IsInited boolean

---@type MoonCommonLib.MSingleton_MoonClient.MUICameraRTManager
MoonCommonLib.MSingleton_MoonClient.MUICameraRTManager = { }
---@return boolean
function MoonCommonLib.MSingleton_MoonClient.MUICameraRTManager:Init() end
function MoonCommonLib.MSingleton_MoonClient.MUICameraRTManager:Uninit() end
---@param clearAccountData boolean
function MoonCommonLib.MSingleton_MoonClient.MUICameraRTManager:OnLogout(clearAccountData) end
return MoonCommonLib.MSingleton_MoonClient.MUICameraRTManager
