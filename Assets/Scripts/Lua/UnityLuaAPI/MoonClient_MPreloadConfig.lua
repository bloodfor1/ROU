---@class MoonClient.MPreloadConfig : MoonCommonLib.MSingleton_MoonClient.MPreloadConfig

---@type MoonClient.MPreloadConfig
MoonClient.MPreloadConfig = { }
---@return MoonClient.MPreloadConfig
function MoonClient.MPreloadConfig.New() end
---@return boolean
function MoonClient.MPreloadConfig:Init() end
---@param tableNames System.String[]
function MoonClient.MPreloadConfig:PreloadTables(tableNames) end
function MoonClient.MPreloadConfig:Uninit() end
return MoonClient.MPreloadConfig
