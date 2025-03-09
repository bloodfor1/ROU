---@class MoonCommonLib.MPlatformConfig
---@field public bundleId string
---@field public channel string
---@field public area number
---@field public language number
---@field public apiDomain string
---@field public mode MoonCommonLib.MModeSettings
---@field public version MoonCommonLib.MVersion
---@field public programUpdate MoonCommonLib.MUpdateSettings
---@field public hotUpdate MoonCommonLib.MUpdateSettings
---@field public sdkList string
---@field public androidNativeSdkList string
---@field public fileServer string
---@field public sign string

---@type MoonCommonLib.MPlatformConfig
MoonCommonLib.MPlatformConfig = { }
---@return MoonCommonLib.MPlatformConfig
function MoonCommonLib.MPlatformConfig.New() end
---@return boolean
function MoonCommonLib.MPlatformConfig:SaveCache() end
---@return boolean
function MoonCommonLib.MPlatformConfig:SaveLocal() end
---@return boolean
function MoonCommonLib.MPlatformConfig:ValidationCache() end
return MoonCommonLib.MPlatformConfig
