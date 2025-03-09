---@class MoonClient.MLuaUIListener : MoonClient.MUIListenerBase

---@type MoonClient.MLuaUIListener
MoonClient.MLuaUIListener = { }
---@return MoonClient.MLuaUIListener
function MoonClient.MLuaUIListener.New() end
---@return MoonClient.MLuaUIListener
---@param go UnityEngine.GameObject
function MoonClient.MLuaUIListener.Get(go) end
---@param go UnityEngine.GameObject
function MoonClient.MLuaUIListener.Destroy(go) end
return MoonClient.MLuaUIListener
