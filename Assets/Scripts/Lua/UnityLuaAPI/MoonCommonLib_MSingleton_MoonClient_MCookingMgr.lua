---@class MoonCommonLib.MSingleton_MoonClient.MCookingMgr : MoonCommonLib.MBaseSingleton
---@field public singleton MoonClient.MCookingMgr
---@field public IsInited boolean

---@type MoonCommonLib.MSingleton_MoonClient.MCookingMgr
MoonCommonLib.MSingleton_MoonClient.MCookingMgr = { }
---@return boolean
function MoonCommonLib.MSingleton_MoonClient.MCookingMgr:Init() end
function MoonCommonLib.MSingleton_MoonClient.MCookingMgr:Uninit() end
---@param clearAccountData boolean
function MoonCommonLib.MSingleton_MoonClient.MCookingMgr:OnLogout(clearAccountData) end
return MoonCommonLib.MSingleton_MoonClient.MCookingMgr
