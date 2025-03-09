---@class MoonClient.MObject
---@field public UID uint64
---@field public EventDispatcher MoonClient.MEventDispatcher
---@field public ToSceneObject MoonClient.MSceneObject
---@field public ToEntity MoonClient.MEntity
---@field public ToNpc MoonClient.MNpc
---@field public ToRole MoonClient.MRole
---@field public ToMonster MoonClient.MMonster
---@field public ToMercenary MoonClient.MMercenary
---@field public ToPubVehicle MoonClient.MPubVehicle
---@field public ToSceneTriggerObject MoonClient.MSceneTriggerObject
---@field public ToDrop MoonClient.MDrop
---@field public IsLoaded boolean
---@field public Deprecated boolean
---@field public Destroying boolean
---@field public entityType number
---@field public IsTrap boolean
---@field public IsPlayer boolean
---@field public IsRole boolean
---@field public IsEagle boolean
---@field public IsMonster boolean
---@field public IsMobMonster boolean
---@field public IsElite boolean
---@field public IsBoss boolean
---@field public IsBullet boolean
---@field public IsNpc boolean
---@field public IsCollection boolean
---@field public IsDummy boolean
---@field public IsPet boolean
---@field public IsPubVehicle boolean
---@field public IsTriggerObject boolean
---@field public IsDrop boolean
---@field public IsMirrorRole boolean
---@field public IsMercenary boolean

---@type MoonClient.MObject
MoonClient.MObject = { }
---@overload fun(): MoonClient.MObject
---@return MoonClient.MObject
---@param defaultComponentSize number
function MoonClient.MObject.New(defaultComponentSize) end
---@return boolean
function MoonClient.MObject:Init() end
function MoonClient.MObject:Uninit() end
function MoonClient.MObject:OnCreated() end
function MoonClient.MObject:OnDestrory() end
---@return MoonClient.MComponent
---@param uuid number
function MoonClient.MObject:GetMComponentByUUID(uuid) end
---@param componentObject MoonClient.MComponent
function MoonClient.MObject:AttachComponent(componentObject) end
---@param id number
function MoonClient.MObject:DetachComponent(id) end
---@param args System.Object[]
function MoonClient.MObject:DetachAllComponent(args) end
---@param fDeltaT number
function MoonClient.MObject:Update(fDeltaT) end
---@param fDeltaT number
function MoonClient.MObject:LateUpdate(fDeltaT) end
---@param eventType number
---@param eventHandle MoonClient.MEventHandler
function MoonClient.MObject:AddEventListener(eventType, eventHandle) end
---@param eventType number
---@param eventHandle MoonClient.MEventHandler
function MoonClient.MObject:RemoveEventListener(eventType, eventHandle) end
---@param eventType number
---@param args MoonClient.IEventArg
function MoonClient.MObject:FireEvent(eventType, args) end
function MoonClient.MObject:Get() end
function MoonClient.MObject:Release() end
function MoonClient.MObject:Destory() end
function MoonClient.MObject:Recycle() end
return MoonClient.MObject
