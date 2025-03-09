---@class MoonCommonLib.MSingleton_MoonClient.MHeadPortrait : MoonCommonLib.MBaseSingleton
---@field public singleton MoonClient.MHeadPortrait
---@field public IsInited boolean

---@type MoonCommonLib.MSingleton_MoonClient.MHeadPortrait
MoonCommonLib.MSingleton_MoonClient.MHeadPortrait = { }
---@return boolean
function MoonCommonLib.MSingleton_MoonClient.MHeadPortrait:Init() end
function MoonCommonLib.MSingleton_MoonClient.MHeadPortrait:Uninit() end
---@param clearAccountData boolean
function MoonCommonLib.MSingleton_MoonClient.MHeadPortrait:OnLogout(clearAccountData) end
return MoonCommonLib.MSingleton_MoonClient.MHeadPortrait
