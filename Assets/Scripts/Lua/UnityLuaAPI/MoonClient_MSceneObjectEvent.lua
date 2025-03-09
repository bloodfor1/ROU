---@class MoonClient.MSceneObjectEvent : UnityEngine.MonoBehaviour
---@field public eventType number
---@field public clipName string
---@field public visibleObject UnityEngine.GameObject
---@field public visible boolean
---@field public UID number

---@type MoonClient.MSceneObjectEvent
MoonClient.MSceneObjectEvent = { }
---@return MoonClient.MSceneObjectEvent
function MoonClient.MSceneObjectEvent.New() end
---@param uid number
function MoonClient.MSceneObjectEvent.SendEvent(uid) end
---@param uid number
function MoonClient.MSceneObjectEvent.SendStopEvent(uid) end
return MoonClient.MSceneObjectEvent
