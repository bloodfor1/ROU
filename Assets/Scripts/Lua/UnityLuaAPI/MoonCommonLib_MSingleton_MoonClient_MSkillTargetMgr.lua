---@class MoonCommonLib.MSingleton_MoonClient.MSkillTargetMgr : MoonCommonLib.MBaseSingleton
---@field public singleton MoonClient.MSkillTargetMgr
---@field public IsInited boolean

---@type MoonCommonLib.MSingleton_MoonClient.MSkillTargetMgr
MoonCommonLib.MSingleton_MoonClient.MSkillTargetMgr = { }
---@return boolean
function MoonCommonLib.MSingleton_MoonClient.MSkillTargetMgr:Init() end
function MoonCommonLib.MSingleton_MoonClient.MSkillTargetMgr:Uninit() end
---@param clearAccountData boolean
function MoonCommonLib.MSingleton_MoonClient.MSkillTargetMgr:OnLogout(clearAccountData) end
return MoonCommonLib.MSingleton_MoonClient.MSkillTargetMgr
