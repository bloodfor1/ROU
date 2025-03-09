---@class MoonCommonLib.MSingleton_MoonClient.MNpcMgr : MoonCommonLib.MBaseSingleton
---@field public singleton MoonClient.MNpcMgr
---@field public IsInited boolean

---@type MoonCommonLib.MSingleton_MoonClient.MNpcMgr
MoonCommonLib.MSingleton_MoonClient.MNpcMgr = { }
---@return boolean
function MoonCommonLib.MSingleton_MoonClient.MNpcMgr:Init() end
function MoonCommonLib.MSingleton_MoonClient.MNpcMgr:Uninit() end
---@param clearAccountData boolean
function MoonCommonLib.MSingleton_MoonClient.MNpcMgr:OnLogout(clearAccountData) end
return MoonCommonLib.MSingleton_MoonClient.MNpcMgr
