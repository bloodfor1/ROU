---@class MoonCommonLib.MPlatformConfigManager
---@field public configName string
---@field public cacheConfigName string
---@field public configLocalPath string
---@field public configCachePath string

---@type MoonCommonLib.MPlatformConfigManager
MoonCommonLib.MPlatformConfigManager = { }
---@return MoonCommonLib.MPlatformConfig
---@param reload boolean
function MoonCommonLib.MPlatformConfigManager.GetCacheOrLocal(reload) end
---@return MoonCommonLib.MPlatformConfig
---@param reload boolean
function MoonCommonLib.MPlatformConfigManager.GetCache(reload) end
---@return MoonCommonLib.MPlatformConfig
---@param reload boolean
function MoonCommonLib.MPlatformConfigManager.GetLocal(reload) end
---@return boolean
function MoonCommonLib.MPlatformConfigManager:SaveCache() end
---@return boolean
function MoonCommonLib.MPlatformConfigManager:SaveLocal() end
---@param config MoonCommonLib.MPlatformConfig
function MoonCommonLib.MPlatformConfigManager.SignCache(config) end
---@return boolean
function MoonCommonLib.MPlatformConfigManager:ValidationCache() end
---@param config MoonCommonLib.MPlatformConfig
function MoonCommonLib.MPlatformConfigManager.SignLocal(config) end
---@overload fun(sdkName:string): LitJson.JsonData
---@return LitJson.JsonData
---@param sdkName string
---@param varName string
function MoonCommonLib.MPlatformConfigManager.GetSDKConfig(sdkName, varName) end
---@param sdkName string
---@param varName string
---@param value string
function MoonCommonLib.MPlatformConfigManager.SetSDKConfig(sdkName, varName, value) end
return MoonCommonLib.MPlatformConfigManager
