---@class MoonClient.MapObjMgr : MoonCommonLib.MSingleton_MoonClient.MapObjMgr
---@field public MiniMapIconRoleID number
---@field public MiniMapIconTrsDoorID number
---@field public MiniMapIconJyg number
---@field public MiniMapIconMng number
---@field public MiniMapIconMvpg number
---@field public TrsDoorSp string
---@field public EnemySp string
---@field public TeammateSp string
---@field public WorldPveSp string
---@field public WorldPveBgSp string
---@field public DelegateSp string
---@field public PathSp string
---@field public PathDestSp string
---@field public PathDestFx string
---@field public TaskDestSP string
---@field public BigMapSpriteMesh MoonClient.HUDMesh.MHUDMapMesh
---@field public MiniMapSpriteMesh MoonClient.HUDMesh.MHUDMapMesh
---@field public BigMapTxtMesh MoonClient.HUDMesh.MHUDMapTxtMesh
---@field public ObjDic System.Collections.Generic.Dictionary_MoonClient.MapObj_MoonClient.MapObjData
---@field public PathLs System.Collections.Generic.List_MoonClient.MapObj

---@type MoonClient.MapObjMgr
MoonClient.MapObjMgr = { }
---@return MoonClient.MapObjMgr
function MoonClient.MapObjMgr.New() end
function MoonClient.MapObjMgr:BindCSharpEvent() end
function MoonClient.MapObjMgr:UnBindCSharpEvent() end
---@return boolean
function MoonClient.MapObjMgr:Init() end
function MoonClient.MapObjMgr:Uninit() end
---@param clearAccountData boolean
function MoonClient.MapObjMgr:OnLogout(clearAccountData) end
---@return UnityEngine.Vector2
---@param orgPos UnityEngine.Vector2
function MoonClient.MapObjMgr:getHudPosInBigMap(orgPos) end
---@param fDeltaT number
function MoonClient.MapObjMgr:Update(fDeltaT) end
function MoonClient.MapObjMgr:LateUpdate() end
---@return MoonClient.MapObjData
function MoonClient.MapObjMgr:GetMapObjData() end
---@return string
---@param fightGroup number
---@param iconId number
function MoonClient.MapObjMgr:GetSprite(fightGroup, iconId) end
---@return boolean
---@param go UnityEngine.GameObject
---@param eventData UnityEngine.EventSystems.PointerEventData
---@param worldPos UnityEngine.Vector2
function MoonClient.MapObjMgr:TryClickEvent(go, eventData, worldPos) end
---@return boolean
---@param t number
---@param id uint64
---@param pos UnityEngine.Vector2
function MoonClient.MapObjMgr:AddObj(t, id, pos) end
---@return MoonClient.MapDynamicEffectObj
function MoonClient.MapObjMgr:GetDynamicEffectObj() end
---@return boolean
---@param t number
---@param id uint64
function MoonClient.MapObjMgr:CheckDynamicEffect(t, id) end
---@return boolean
---@param t number
---@param id uint64
---@param dynamicObj MoonClient.MapDynamicEffectObj
function MoonClient.MapObjMgr:AddDynamicEffect(t, id, dynamicObj) end
---@overload fun(t:number, id:uint64, pos:UnityEngine.Vector2): void
---@overload fun(t:number, id:uint64, rotation:UnityEngine.Quaternion): void
---@overload fun(t:number, id:uint64, txtColor:UnityEngine.Color): void
---@overload fun(t:number, id:uint64, sprite:string): void
---@overload fun(t:number, id:uint64, activeBig:boolean, activeSmall:boolean): void
---@overload fun(t:number, id:uint64, position:UnityEngine.Vector2, sprite:string): void
---@overload fun(t:number, id:uint64, size:number, click:(fun():void)): void
---@overload fun(t:number, id:uint64, txt:string, txtPos:UnityEngine.Vector2): void
---@param t number
---@param id uint64
---@param position UnityEngine.Vector2
---@param rotation UnityEngine.Vector2
---@param sprite string
function MoonClient.MapObjMgr:MdObj(t, id, position, rotation, sprite) end
---@param t number
---@param id uint64
---@param rotation UnityEngine.Vector2
function MoonClient.MapObjMgr:MdObjRotation(t, id, rotation) end
---@param t number
---@param id uint64
function MoonClient.MapObjMgr:RmDynamicEffectObj(t, id) end
---@overload fun(): void
---@overload fun(t:number): void
---@param t number
---@param id uint64
function MoonClient.MapObjMgr:RmObj(t, id) end
---@return uint64
function MoonClient.MapObjMgr:GetEffectId() end
---@param id uint64
---@param newMapData MoonClient.MapObjData
function MoonClient.MapObjMgr:AddEffect(id, newMapData) end
---@param id uint64
function MoonClient.MapObjMgr:RmEffect(id) end
---@param mapEffectObj MoonClient.MapEffectObj
---@param mapObjData MoonClient.MapObjData
function MoonClient.MapObjMgr:ReleaseMapRelateObj(mapEffectObj, mapObjData) end
function MoonClient.MapObjMgr:RmAllEffect() end
function MoonClient.MapObjMgr:OnCloseBigMap() end
return MoonClient.MapObjMgr
