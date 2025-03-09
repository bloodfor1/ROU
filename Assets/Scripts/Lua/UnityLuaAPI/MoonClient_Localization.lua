---@class MoonClient.Localization : MoonCommonLib.MSingleton_MoonClient.Localization
---@field public LocalizationFileName string
---@field public EditorLocalizationFileName string
---@field public LocalizationFilePath string
---@field public EditorLocalizationFilePath string
---@field public StringDict System.Collections.Generic.Dictionary_System.String_System.UInt32

---@type MoonClient.Localization
MoonClient.Localization = { }
---@return MoonClient.Localization
function MoonClient.Localization.New() end
---@return boolean
function MoonClient.Localization:Init() end
---@return string
---@param key string
function MoonClient.Localization:Get(key) end
---@return string
---@param value string
function MoonClient.Localization:FindKey(value) end
return MoonClient.Localization
