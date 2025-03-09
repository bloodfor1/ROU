---@class MoonCommonLib.MSingleton_MoonClient.MapDataModel : MoonCommonLib.MBaseSingleton
---@field public singleton MoonClient.MapDataModel
---@field public IsInited boolean

---@type MoonCommonLib.MSingleton_MoonClient.MapDataModel
MoonCommonLib.MSingleton_MoonClient.MapDataModel = { }
---@return boolean
function MoonCommonLib.MSingleton_MoonClient.MapDataModel:Init() end
function MoonCommonLib.MSingleton_MoonClient.MapDataModel:Uninit() end
---@param clearAccountData boolean
function MoonCommonLib.MSingleton_MoonClient.MapDataModel:OnLogout(clearAccountData) end
return MoonCommonLib.MSingleton_MoonClient.MapDataModel
