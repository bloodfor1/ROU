---@class MoonCommonLib.MSingleton_MoonClient.MUIModelManagerEx : MoonCommonLib.MBaseSingleton
---@field public singleton MoonClient.MUIModelManagerEx
---@field public IsInited boolean

---@type MoonCommonLib.MSingleton_MoonClient.MUIModelManagerEx
MoonCommonLib.MSingleton_MoonClient.MUIModelManagerEx = { }
---@return boolean
function MoonCommonLib.MSingleton_MoonClient.MUIModelManagerEx:Init() end
function MoonCommonLib.MSingleton_MoonClient.MUIModelManagerEx:Uninit() end
---@param clearAccountData boolean
function MoonCommonLib.MSingleton_MoonClient.MUIModelManagerEx:OnLogout(clearAccountData) end
return MoonCommonLib.MSingleton_MoonClient.MUIModelManagerEx
