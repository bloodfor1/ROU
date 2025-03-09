---@class MoonCommonLib.MSingleton_MoonClient.MMazeDungeonMgr : MoonCommonLib.MBaseSingleton
---@field public singleton MoonClient.MMazeDungeonMgr
---@field public IsInited boolean

---@type MoonCommonLib.MSingleton_MoonClient.MMazeDungeonMgr
MoonCommonLib.MSingleton_MoonClient.MMazeDungeonMgr = { }
---@return boolean
function MoonCommonLib.MSingleton_MoonClient.MMazeDungeonMgr:Init() end
function MoonCommonLib.MSingleton_MoonClient.MMazeDungeonMgr:Uninit() end
---@param clearAccountData boolean
function MoonCommonLib.MSingleton_MoonClient.MMazeDungeonMgr:OnLogout(clearAccountData) end
return MoonCommonLib.MSingleton_MoonClient.MMazeDungeonMgr
