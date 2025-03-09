---@class MoonCommonLib.MSingleton_MoonClient.MapObjMgr : MoonCommonLib.MBaseSingleton
---@field public singleton MoonClient.MapObjMgr
---@field public IsInited boolean

---@type MoonCommonLib.MSingleton_MoonClient.MapObjMgr
MoonCommonLib.MSingleton_MoonClient.MapObjMgr = { }
---@return boolean
function MoonCommonLib.MSingleton_MoonClient.MapObjMgr:Init() end
function MoonCommonLib.MSingleton_MoonClient.MapObjMgr:Uninit() end
---@param clearAccountData boolean
function MoonCommonLib.MSingleton_MoonClient.MapObjMgr:OnLogout(clearAccountData) end
return MoonCommonLib.MSingleton_MoonClient.MapObjMgr
