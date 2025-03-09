---@class LuaClient : UnityEngine.MonoBehaviour
---@field public Instance LuaClient

---@type LuaClient
LuaClient = { }
---@return LuaClient
function LuaClient.New() end
---@param ip string
function LuaClient:OpenZbsDebugger(ip) end
function LuaClient:Destroy() end
---@return LuaInterface.LuaState
function LuaClient.GetMainState() end
---@return LuaLooper
function LuaClient:GetLooper() end
return LuaClient
