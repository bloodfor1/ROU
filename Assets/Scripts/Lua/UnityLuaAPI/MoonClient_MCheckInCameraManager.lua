---@class MoonClient.MCheckInCameraManager : MoonCommonLib.MSingleton_MoonClient.MCheckInCameraManager
---@field public PositionCheckInCameraTriggers System.Collections.Generic.Dictionary_System.Int32_MoonClient.MCheckInCameraTrigger
---@field public VisibleComponents System.Collections.Generic.HashSet_MoonClient.MCheckInCameraComponent
---@field public VisibleViewPortTriggers System.Collections.Generic.Dictionary_System.Int32_MoonClient.MCheckInViewPortTrigger
---@field public NpcCheckInCameraData System.Collections.Generic.Dictionary_System.Int32_MoonClient.MCheckInCameraData
---@field public MonsterCheckInCameraData System.Collections.Generic.Dictionary_System.Int32_MoonClient.MCheckInCameraData
---@field public EntityCheckInCameraData System.Collections.Generic.Dictionary_System.UInt64_MoonClient.MCheckInCameraData

---@type MoonClient.MCheckInCameraManager
MoonClient.MCheckInCameraManager = { }
---@return MoonClient.MCheckInCameraManager
function MoonClient.MCheckInCameraManager.New() end
---@return System.Collections.Generic.List_System.Int32
function MoonClient.MCheckInCameraManager.GetTriggerIds() end
---@return boolean
---@param worldPos UnityEngine.Vector3
function MoonClient.MCheckInCameraManager.IsInCamera(worldPos) end
function MoonClient.MCheckInCameraManager.OnSceneLoaded() end
function MoonClient.MCheckInCameraManager.OnLeaveScene() end
---@return MoonClient.MCheckInCameraData
---@param row MoonClient.CheckInCameraTable.RowData
function MoonClient.MCheckInCameraManager.ToCameraData(row) end
---@param npc MoonClient.MNpc
function MoonClient.MCheckInCameraManager.AddNpcComponent(npc) end
---@param entity MoonClient.MEntity
---@param distanceLimit number
---@param angleLimit number
function MoonClient.MCheckInCameraManager.AddMonsterComponent(entity, distanceLimit, angleLimit) end
---@param entity MoonClient.MEntity
---@param distanceLimit number
---@param angleLimit number
function MoonClient.MCheckInCameraManager.AddEntityComponent(entity, distanceLimit, angleLimit) end
---@param triggerId number
---@param npcId number
---@param t number
---@param distanceLimit number
---@param angleLimit number
function MoonClient.MCheckInCameraManager.AddNpcCheckInCamera(triggerId, npcId, t, distanceLimit, angleLimit) end
---@param npcId number
function MoonClient.MCheckInCameraManager.RemoveNpcCheckInCamera(npcId) end
---@param triggerId number
---@param entityId number
---@param t number
---@param distanceLimit number
---@param angleLimit number
function MoonClient.MCheckInCameraManager.AddMonsterCheckInCamera(triggerId, entityId, t, distanceLimit, angleLimit) end
---@param entityId number
function MoonClient.MCheckInCameraManager.RemoveMonsterCheckInCamera(entityId) end
---@param triggerId number
---@param uuid uint64
---@param t number
---@param distanceLimit number
---@param angleLimit number
function MoonClient.MCheckInCameraManager.AddEntityCheckInCamera(triggerId, uuid, t, distanceLimit, angleLimit) end
---@param uuid uint64
function MoonClient.MCheckInCameraManager.RemoveEntityCheckInCamera(uuid) end
---@param viewportId number
function MoonClient.MCheckInCameraManager.AddViewPort(viewportId) end
---@param viewportId number
function MoonClient.MCheckInCameraManager.RemoveViewPort(viewportId) end
---@param id number
---@param t number
function MoonClient.MCheckInCameraManager.AddCheckInCameraById(id, t) end
---@param id number
function MoonClient.MCheckInCameraManager.RemoveCheckInCameraById(id) end
---@param clearAccountData boolean
function MoonClient.MCheckInCameraManager:OnLogout(clearAccountData) end
return MoonClient.MCheckInCameraManager
