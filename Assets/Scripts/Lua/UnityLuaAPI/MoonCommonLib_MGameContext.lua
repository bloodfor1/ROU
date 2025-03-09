---@class MoonCommonLib.MGameContext : MoonCommonLib.MSingleton_MoonCommonLib.MGameContext
---@field public MainChannel number
---@field public MainLanguage number
---@field public IsEmulator boolean
---@field public IsAndroid boolean
---@field public IsIOS boolean
---@field public IsPC boolean
---@field public IsUnityEditor boolean
---@field public IsUnityEditorOrPC boolean
---@field public IsGameRunningInUnityEditor boolean
---@field public IsGameRunningMode boolean
---@field public IsGameEditorMode boolean
---@field public IsPlayerInGameEditorIsRole boolean
---@field public IsSoloMode boolean
---@field public IsNetworkRun boolean
---@field public RoleCount number
---@field public Channel string
---@field public Version MoonCommonLib.MVersion
---@field public IsPublish boolean
---@field public IsDebug boolean
---@field public IsOpenGM boolean
---@field public IsTest boolean
---@field public IsObb boolean
---@field public IsClientPreRelease boolean
---@field public ObbPath string
---@field public ABPackMode number
---@field public ZipMode number
---@field public ProgramUpdateType number
---@field public HotUpdateType number
---@field public IsMainChannel boolean
---@field public CurrentChannel number
---@field public IsMainLanguage boolean
---@field public CurrentLanguage number
---@field public EnableTranslateDebug boolean

---@type MoonCommonLib.MGameContext
MoonCommonLib.MGameContext = { }
---@return MoonCommonLib.MGameContext
function MoonCommonLib.MGameContext.New() end
return MoonCommonLib.MGameContext
