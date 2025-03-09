---@class MoonCommonLib.MSingleton_MoonClient.MTransferMgr : MoonCommonLib.MBaseSingleton
---@field public singleton MoonClient.MTransferMgr
---@field public IsInited boolean

---@type MoonCommonLib.MSingleton_MoonClient.MTransferMgr
MoonCommonLib.MSingleton_MoonClient.MTransferMgr = { }
---@return boolean
function MoonCommonLib.MSingleton_MoonClient.MTransferMgr:Init() end
function MoonCommonLib.MSingleton_MoonClient.MTransferMgr:Uninit() end
---@param clearAccountData boolean
function MoonCommonLib.MSingleton_MoonClient.MTransferMgr:OnLogout(clearAccountData) end
return MoonCommonLib.MSingleton_MoonClient.MTransferMgr
