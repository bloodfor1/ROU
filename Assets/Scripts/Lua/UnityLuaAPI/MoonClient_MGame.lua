---@class MoonClient.MGame : MoonCommonLib.MSingleton_MoonClient.MGame
---@field public MainThreadId number
---@field public MainThread System.Threading.SynchronizationContext
---@field public LuaEngine MoonCommonLib.IMLua
---@field public LuaStateProxy MoonCommonLib.ILuaStateProxy
---@field public IsPaused boolean
---@field public TimeScale number
---@field public GameLibPaused boolean
---@field public CameraRoot UnityEngine.GameObject

---@type MoonClient.MGame
MoonClient.MGame = { }
---@return MoonClient.MGame
function MoonClient.MGame.New() end
---@return boolean
function MoonClient.MGame:Init() end
function MoonClient.MGame:Uninit() end
---@return System.Collections.IEnumerator
function MoonClient.MGame:AwakeEnum() end
function MoonClient.MGame:NetUpdate() end
---@param fDeltaT number
function MoonClient.MGame:PreUpdate(fDeltaT) end
---@param fDeltaT number
function MoonClient.MGame:Update(fDeltaT) end
---@param fDeltaT number
function MoonClient.MGame:LateUpdate(fDeltaT) end
---@param clearAccountData boolean
function MoonClient.MGame:OnLogout(clearAccountData) end
function MoonClient.MGame:PauseGame() end
function MoonClient.MGame:ResumeGame() end
---@param pause boolean
function MoonClient.MGame:SetFakePaused(pause) end
---@param val number
function MoonClient.MGame:SetTimeScale(val) end
return MoonClient.MGame
