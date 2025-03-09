---@class MoonCommonLib.MSingleton_MoonClient.MCheckInCameraManager : MoonCommonLib.MBaseSingleton
---@field public singleton MoonClient.MCheckInCameraManager
---@field public IsInited boolean

---@type MoonCommonLib.MSingleton_MoonClient.MCheckInCameraManager
MoonCommonLib.MSingleton_MoonClient.MCheckInCameraManager = { }
---@return boolean
function MoonCommonLib.MSingleton_MoonClient.MCheckInCameraManager:Init() end
function MoonCommonLib.MSingleton_MoonClient.MCheckInCameraManager:Uninit() end
---@param clearAccountData boolean
function MoonCommonLib.MSingleton_MoonClient.MCheckInCameraManager:OnLogout(clearAccountData) end
return MoonCommonLib.MSingleton_MoonClient.MCheckInCameraManager
