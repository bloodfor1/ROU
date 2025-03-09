---@class MoonClient.StringPoolManager : MoonCommonLib.MSingleton_MoonClient.StringPoolManager
---@field public LocalizationPath string
---@field public TranslateStringPoolName string
---@field public StringCachePoolName string
---@field public StringCacheConflicPoolName string
---@field public StringPoolKeyFileName string
---@field public FullStringPoolKeyFileName string
---@field public ConflictKeyFileName string
---@field public RuntimeStringPoolName string
---@field public RuntimeStringPoolExtendsName string
---@field public RuntimeConflictStringPoolName string
---@field public StringPool MoonClient.IStringPool

---@type MoonClient.StringPoolManager
MoonClient.StringPoolManager = { }
---@return MoonClient.StringPoolManager
function MoonClient.StringPoolManager.New() end
---@return boolean
function MoonClient.StringPoolManager:Init() end
function MoonClient.StringPoolManager:Uninit() end
---@overload fun(key:number): string
---@return string
---@param key string
function MoonClient.StringPoolManager:GetString(key) end
---@return number
---@param key string
function MoonClient.StringPoolManager:GetKey(key) end
---@return string
---@param source string
function MoonClient.StringPoolManager:GetOneLineString(source) end
---@return string
---@param oneline string
function MoonClient.StringPoolManager:ParseFromOneLineString(oneline) end
---@return string
---@param key string
---@param count number
function MoonClient.StringPoolManager:AddConflictFlag(key, count) end
---@return string
---@param keyDict System.Collections.Generic.Dictionary_System.UInt32_System.String
---@param key string
function MoonClient.StringPoolManager:ConvertConflictKey(keyDict, key) end
---@return string
---@param originKey string
function MoonClient.StringPoolManager:GetConflictOriginKey(originKey) end
---@return boolean
---@param key string
function MoonClient.StringPoolManager:HasConflictFlag(key) end
return MoonClient.StringPoolManager
