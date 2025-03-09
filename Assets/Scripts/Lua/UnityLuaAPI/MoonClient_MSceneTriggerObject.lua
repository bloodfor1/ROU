---@class MoonClient.MSceneTriggerObject : MoonClient.MSceneObject
---@field public Data PbLocal.MSceneTriggerObjectData
---@field public ModelGo UnityEngine.GameObject
---@field public Id number
---@field public NeedModel boolean

---@type MoonClient.MSceneTriggerObject
MoonClient.MSceneTriggerObject = { }
---@return MoonClient.MSceneTriggerObject
function MoonClient.MSceneTriggerObject.New() end
---@return boolean
function MoonClient.MSceneTriggerObject:CanReset() end
function MoonClient.MSceneTriggerObject:OnDestrory() end
function MoonClient.MSceneTriggerObject:Uninit() end
---@return boolean
---@param uuid uint64
---@param data PbLocal.MSceneTriggerObjectData
---@param position UnityEngine.Vector3
---@param faceDegree number
function MoonClient.MSceneTriggerObject:Initialize(uuid, data, position, faceDegree) end
---@param state boolean
function MoonClient.MSceneTriggerObject:IsShowEffect(state) end
---@param obj UnityEngine.GameObject
function MoonClient.MSceneTriggerObject:OnUObjLoaded(obj) end
function MoonClient.MSceneTriggerObject:Recycle() end
---@param info KKSG.SceneTriggerObjectInfo
function MoonClient.MSceneTriggerObject:SyncData(info) end
---@overload fun(t:number): number
---@return number
---@param t number
function MoonClient.MSceneTriggerObject:GetParam(t) end
function MoonClient.MSceneTriggerObject:Reset() end
return MoonClient.MSceneTriggerObject
