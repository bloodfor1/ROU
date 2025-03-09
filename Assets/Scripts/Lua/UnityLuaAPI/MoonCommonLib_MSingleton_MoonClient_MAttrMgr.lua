---@class MoonCommonLib.MSingleton_MoonClient.MAttrMgr : MoonCommonLib.MBaseSingleton
---@field public singleton MoonClient.MAttrMgr
---@field public IsInited boolean

---@type MoonCommonLib.MSingleton_MoonClient.MAttrMgr
MoonCommonLib.MSingleton_MoonClient.MAttrMgr = { }
---@return boolean
function MoonCommonLib.MSingleton_MoonClient.MAttrMgr:Init() end
function MoonCommonLib.MSingleton_MoonClient.MAttrMgr:Uninit() end
---@param clearAccountData boolean
function MoonCommonLib.MSingleton_MoonClient.MAttrMgr:OnLogout(clearAccountData) end
return MoonCommonLib.MSingleton_MoonClient.MAttrMgr
