---@class MoonCommonLib.MSingleton_MoonClient.MEventMgr : MoonCommonLib.MBaseSingleton
---@field public singleton MoonClient.MEventMgr
---@field public IsInited boolean

---@type MoonCommonLib.MSingleton_MoonClient.MEventMgr
MoonCommonLib.MSingleton_MoonClient.MEventMgr = { }
---@return boolean
function MoonCommonLib.MSingleton_MoonClient.MEventMgr:Init() end
function MoonCommonLib.MSingleton_MoonClient.MEventMgr:Uninit() end
---@param clearAccountData boolean
function MoonCommonLib.MSingleton_MoonClient.MEventMgr:OnLogout(clearAccountData) end
return MoonCommonLib.MSingleton_MoonClient.MEventMgr
