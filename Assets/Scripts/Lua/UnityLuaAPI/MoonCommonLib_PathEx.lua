---@class MoonCommonLib.PathEx
---@field public CopyProjResourcesPaths System.Collections.Generic.List_System.String
---@field public CopyProjStreamingAssetsPath System.Collections.Generic.List_System.String
---@field public LuaPath string
---@field public LocalizationPath string
---@field public OverseaProjRootName string
---@field public OverseaConfigRootName string
---@field public OverseaArtRootName string
---@field public projectPath string
---@field public PersistentDataPath string

---@type MoonCommonLib.PathEx
MoonCommonLib.PathEx = { }
---@return MoonCommonLib.PathEx
function MoonCommonLib.PathEx.New() end
---@return string
function MoonCommonLib.PathEx.GetCachePath() end
---@return string
function MoonCommonLib.PathEx.GetUnzippedPath() end
---@return string
---@param bankName string
function MoonCommonLib.PathEx.GetBankPath(bankName) end
---@return string
function MoonCommonLib.PathEx.GetHotUpdatePath() end
---@return string
function MoonCommonLib.PathEx.GetResourcesAssetsPath() end
---@return string
---@param path string
---@param forWWW boolean
---@param platform System.Nullable_UnityEngine.RuntimePlatform
function MoonCommonLib.PathEx.GetStreamingAssetsFile(path, forWWW, platform) end
---@return string
---@param filePath string
---@param isAndroidNative boolean
---@param platform System.Nullable_UnityEngine.RuntimePlatform
function MoonCommonLib.PathEx.GetBundleStreamAssetsPath(filePath, isAndroidNative, platform) end
---@return string
---@param forWWW boolean
---@param isAndroidNative boolean
---@param platform System.Nullable_UnityEngine.RuntimePlatform
function MoonCommonLib.PathEx.GetStreamingAssetsPath(forWWW, isAndroidNative, platform) end
---@return string
---@param platform System.Nullable_UnityEngine.RuntimePlatform
function MoonCommonLib.PathEx.GetBundleSavePath(platform) end
---@return string
---@param channel number
---@param location string
function MoonCommonLib.PathEx.GetChannelProjPathEx(channel, location) end
---@return string
---@param channel number
---@param location string
function MoonCommonLib.PathEx.GetChannelConfigPathEx(channel, location) end
---@return string
---@param channel number
---@param location string
function MoonCommonLib.PathEx.GetChannelArtPathEx(channel, location) end
---@return string
---@param channel number
---@param language number
function MoonCommonLib.PathEx.GetChannelLocalizationPath(channel, language) end
---@return string
---@param absolutePath string
---@param rootPath string
function MoonCommonLib.PathEx.ConvertAPToRP(absolutePath, rootPath) end
---@return string
---@param absolutePath string
function MoonCommonLib.PathEx.ConvertAPToAssetPath(absolutePath) end
---@return string
---@param path string
function MoonCommonLib.PathEx.ConvertAPToAssetPathWithoutExtention(path) end
---@return string
---@param path string
function MoonCommonLib.PathEx.ConvertAssetPathToAbstractPath(path) end
---@return string
---@param path string
function MoonCommonLib.PathEx.ConvertAssetPathToAbstractPathWithoutExtention(path) end
---@return string
---@param path string
function MoonCommonLib.PathEx.Normalize(path) end
---@return string
---@param path string
function MoonCommonLib.PathEx.GetShortName(path) end
---@return string
---@param path string
function MoonCommonLib.PathEx.GetFileNamePathWithoutExtension(path) end
---@return string
---@param path string
function MoonCommonLib.PathEx.MakePathStandard(path) end
return MoonCommonLib.PathEx
