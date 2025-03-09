---@class MoonClient.MEntityMgr : MoonCommonLib.MSingleton_MoonClient.MEntityMgr
---@field public onEntityCreate (fun(entity:MoonClient.MEntity, entityId:number, uid:uint64):void)
---@field public PlayerEntity MoonClient.MPlayer
---@field public SkillEditorPlayer MoonClient.MEntity
---@field public HideNpcAndRole boolean

---@type MoonClient.MEntityMgr
MoonClient.MEntityMgr = { }
---@return MoonClient.MEntityMgr
function MoonClient.MEntityMgr.New() end
---@return boolean
function MoonClient.MEntityMgr:Init() end
function MoonClient.MEntityMgr:Uninit() end
---@param clearAccountData boolean
function MoonClient.MEntityMgr:OnLogout(clearAccountData) end
---@return MoonClient.MObject
---@param uid uint64
function MoonClient.MEntityMgr:GetObject(uid) end
---@overload fun(uid:uint64): void
---@param obj MoonClient.MObject
function MoonClient.MEntityMgr:DeleteObject(obj) end
---@param obj MoonClient.MObject
function MoonClient.MEntityMgr:AsyncDeleteObject(obj) end
---@param obj MoonClient.MObject
function MoonClient.MEntityMgr:AddObject(obj) end
function MoonClient.MEntityMgr:SkillEditorPosFix() end
---@param fDeltaT number
---@param updatePlayerOnly boolean
function MoonClient.MEntityMgr:Update(fDeltaT, updatePlayerOnly) end
---@param fDeltaT number
function MoonClient.MEntityMgr:LateUpdate(fDeltaT) end
---@return number
---@param entity MoonClient.MEntity
function MoonClient.MEntityMgr.GetRelationWithPlayer(entity) end
---@overload fun(attrType:number): number
---@return number
---@param attrType number
function MoonClient.MEntityMgr:GetMyPlayerAttr(attrType) end
---@overload fun(attrType:number): number
---@return number
---@param attrType number
function MoonClient.MEntityMgr:GetCalulatedAttr(attrType) end
function MoonClient.MEntityMgr:BeginCaluelateAttr() end
function MoonClient.MEntityMgr:EndCaluelateAttr() end
---@param attrType number
---@param value number
---@param t number
function MoonClient.MEntityMgr:SetAttrToCalulateByType(attrType, value, t) end
function MoonClient.MEntityMgr:SoloModeStop() end
---@return uint64
function MoonClient.MEntityMgr:GenerateUUID() end
---@return boolean
---@param uuid uint64
function MoonClient.MEntityMgr:IsClientObject(uuid) end
---@return MoonClient.MPlayer
---@param playerAttr MoonClient.MAttrPlayer
---@param pos UnityEngine.Vector3
---@param rot UnityEngine.Quaternion
---@param autoAdd boolean
function MoonClient.MEntityMgr:CreatePlayer(playerAttr, pos, rot, autoAdd) end
---@return MoonClient.MSceneTriggerObject
---@param uuid uint64
---@param dataId number
---@param position UnityEngine.Vector3
---@param faceDegree number
function MoonClient.MEntityMgr:CreateSceneTriggerObject(uuid, dataId, position, faceDegree) end
---@param uuid uint64
---@param collectionData KKSG.CollectionData
---@param position UnityEngine.Vector3
---@param faceDegree number
---@param fightGroup number
---@param localName string
function MoonClient.MEntityMgr:CreateCollection(uuid, collectionData, position, faceDegree, fightGroup, localName) end
---@return MoonClient.MSoul
---@param uid uint64
function MoonClient.MEntityMgr:CreateSoul(uid) end
---@return MoonClient.MPubVehicle
---@param uid uint64
---@param vehicleId number
---@param pos UnityEngine.Vector3
---@param rot UnityEngine.Quaternion
function MoonClient.MEntityMgr:CreatePubVehicle(uid, vehicleId, pos, rot) end
---@param role MoonClient.MSoul
function MoonClient.MEntityMgr:ReleaseSoul(role) end
---@return MoonClient.MEntity
---@param attr MoonClient.MAttrComponent
---@param pos UnityEngine.Vector3
---@param rot UnityEngine.Quaternion
---@param autoAdd boolean
---@param forCutScene boolean
function MoonClient.MEntityMgr:CreateEntity(attr, pos, rot, autoAdd, forCutScene) end
---@param uuid uint64
---@param itemInfo KKSG.DropItemInfo
---@param position UnityEngine.Vector3
---@param fake boolean
function MoonClient.MEntityMgr:OnItemDrop(uuid, itemInfo, position, fake) end
---@param uuid uint64
---@param buffInfo KKSG.DropBuffInfo
---@param position UnityEngine.Vector3
---@param fake boolean
function MoonClient.MEntityMgr:OnBuffDrop(uuid, buffInfo, position, fake) end
---@param itemUid uint64
---@param entityUid uint64
function MoonClient.MEntityMgr:OnPickDrop(itemUid, entityUid) end
---@return MoonClient.MEntity
---@param uid uint64
---@param name string
---@param proId number
---@param sex number
---@param x number
---@param y number
---@param z number
function MoonClient.MEntityMgr:CreateRoleByLua(uid, name, proId, sex, x, y, z) end
---@return MoonClient.MEntity
---@param index uint64
---@param parents UnityEngine.GameObject
---@param name string
---@param entityId number
---@param pos UnityEngine.Vector3
function MoonClient.MEntityMgr:CreateMonsterByLua(index, parents, name, entityId, pos) end
---@overload fun(suffererUid:uint64, attackerUid:uint64): boolean
---@return boolean
---@param suffererFightGroup number
---@param attackerFightGroup number
function MoonClient.MEntityMgr:IsEnemy(suffererFightGroup, attackerFightGroup) end
---@return boolean
---@param entityA MoonClient.MEntity
---@param entityB MoonClient.MEntity
function MoonClient.MEntityMgr.IsACanSeeB(entityA, entityB) end
---@return boolean
---@param entity MoonClient.MEntity
function MoonClient.MEntityMgr.CheckAttackTarget(entity) end
---@param list System.Collections.Generic.List_MoonClient.MEntity
---@param mEntity MoonClient.MEntity
---@param findEnemy boolean
---@param range number
---@param includeBorn boolean
function MoonClient.MEntityMgr:GetOpponent(list, mEntity, findEnemy, range, includeBorn) end
---@return System.Collections.Generic.List_MoonClient.MEntity
---@param mEntity MoonClient.MEntity
---@param findEnemy boolean
---@param range number
function MoonClient.MEntityMgr:GetOpponentByLua(mEntity, findEnemy, range) end
---@return uint64
---@param entityId number
function MoonClient.MEntityMgr:GetUUIDByEntityId(entityId) end
---@return MoonClient.MEntity
---@param uid uint64
---@param includeDead boolean
function MoonClient.MEntityMgr:GetEntity(uid, includeDead) end
---@overload fun(): System.Collections.Generic.List_MoonClient.MEntity
---@return System.Collections.Generic.List_MoonClient.MEntity
---@param mEntities System.Collections.Generic.List_MoonClient.MEntity
function MoonClient.MEntityMgr:GetMEntities(mEntities) end
---@overload fun(): System.Collections.Generic.List_MoonClient.MEntity
---@return System.Collections.Generic.List_MoonClient.MEntity
---@param mEntities System.Collections.Generic.List_MoonClient.MEntity
function MoonClient.MEntityMgr:GetEnemyMEntities(mEntities) end
---@return System.Collections.Generic.List_MoonClient.MEntity
function MoonClient.MEntityMgr:GetRoleEntities() end
---@return MoonClient.MSceneObject
---@param uid uint64
function MoonClient.MEntityMgr:GetSceneObject(uid) end
---@return MoonClient.MRole
---@param uid uint64
---@param includeDead boolean
function MoonClient.MEntityMgr:GetRole(uid, includeDead) end
---@return MoonClient.MMonster
---@param uid uint64
---@param includeDead boolean
function MoonClient.MEntityMgr:GetMonster(uid, includeDead) end
---@param excludePlayer boolean
function MoonClient.MEntityMgr:ClearAll(excludePlayer) end
function MoonClient.MEntityMgr:ClearServerObjects() end
---@param foreachCallback (fun(arg:MoonClient.MObject):boolean)
function MoonClient.MEntityMgr:ForeachObject(foreachCallback) end
return MoonClient.MEntityMgr
