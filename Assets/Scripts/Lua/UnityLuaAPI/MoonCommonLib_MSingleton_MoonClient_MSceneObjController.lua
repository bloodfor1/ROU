---@class MoonCommonLib.MSingleton_MoonClient.MSceneObjController : MoonCommonLib.MBaseSingleton
---@field public singleton MoonClient.MSceneObjController
---@field public IsInited boolean

---@type MoonCommonLib.MSingleton_MoonClient.MSceneObjController
MoonCommonLib.MSingleton_MoonClient.MSceneObjController = { }
---@return boolean
function MoonCommonLib.MSingleton_MoonClient.MSceneObjController:Init() end
function MoonCommonLib.MSingleton_MoonClient.MSceneObjController:Uninit() end
---@param clearAccountData boolean
function MoonCommonLib.MSingleton_MoonClient.MSceneObjController:OnLogout(clearAccountData) end
return MoonCommonLib.MSingleton_MoonClient.MSceneObjController
