---@class MoonCommonLib.MSingleton_MoonClient.ROUtilTool : MoonCommonLib.MBaseSingleton
---@field public singleton MoonClient.ROUtilTool
---@field public IsInited boolean

---@type MoonCommonLib.MSingleton_MoonClient.ROUtilTool
MoonCommonLib.MSingleton_MoonClient.ROUtilTool = { }
---@return boolean
function MoonCommonLib.MSingleton_MoonClient.ROUtilTool:Init() end
function MoonCommonLib.MSingleton_MoonClient.ROUtilTool:Uninit() end
---@param clearAccountData boolean
function MoonCommonLib.MSingleton_MoonClient.ROUtilTool:OnLogout(clearAccountData) end
return MoonCommonLib.MSingleton_MoonClient.ROUtilTool
