---@class MoonCommonLib.MSingleton_MoonClient.MAudioMgr : MoonCommonLib.MBaseSingleton
---@field public singleton MoonClient.MAudioMgr
---@field public IsInited boolean

---@type MoonCommonLib.MSingleton_MoonClient.MAudioMgr
MoonCommonLib.MSingleton_MoonClient.MAudioMgr = { }
---@return boolean
function MoonCommonLib.MSingleton_MoonClient.MAudioMgr:Init() end
function MoonCommonLib.MSingleton_MoonClient.MAudioMgr:Uninit() end
---@param clearAccountData boolean
function MoonCommonLib.MSingleton_MoonClient.MAudioMgr:OnLogout(clearAccountData) end
return MoonCommonLib.MSingleton_MoonClient.MAudioMgr
