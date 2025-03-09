---@class MoonCommonLib.MSingleton_MoonClient.MUIBlackWordMgr : MoonCommonLib.MBaseSingleton
---@field public singleton MoonClient.MUIBlackWordMgr
---@field public IsInited boolean

---@type MoonCommonLib.MSingleton_MoonClient.MUIBlackWordMgr
MoonCommonLib.MSingleton_MoonClient.MUIBlackWordMgr = { }
---@return boolean
function MoonCommonLib.MSingleton_MoonClient.MUIBlackWordMgr:Init() end
function MoonCommonLib.MSingleton_MoonClient.MUIBlackWordMgr:Uninit() end
---@param clearAccountData boolean
function MoonCommonLib.MSingleton_MoonClient.MUIBlackWordMgr:OnLogout(clearAccountData) end
return MoonCommonLib.MSingleton_MoonClient.MUIBlackWordMgr
