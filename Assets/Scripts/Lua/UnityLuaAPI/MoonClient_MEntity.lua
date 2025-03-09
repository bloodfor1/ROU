---@class MoonClient.MEntity : MoonClient.MSceneObject
---@field public sysnOldPos UnityEngine.Vector3
---@field public NavComp MoonClient.MNavigationComponent
---@field public cppEntity ROGameLibs.ROEntityComponent
---@field public cppSceneObj ROGameLibs.ROSceneObjectComponent
---@field public cppObject ROGameLibs.ROObject
---@field public IsInChatRoom boolean
---@field public IsHouyao boolean
---@field public BattleIdle boolean
---@field public Radius number
---@field public Height number
---@field public OverheadPosition UnityEngine.Vector3
---@field public HideBattleVehicle boolean
---@field public UseMonsterDispear boolean
---@field public Owner MoonClient.MEntity
---@field public MirrorOwnerUID uint64
---@field public AttrRole MoonClient.MAttrRole
---@field public AttrMonster MoonClient.MAttrMonster
---@field public AttrNPC MoonClient.MAttrNPC
---@field public AttrMirrorRole MoonClient.MAttrMirrorRole
---@field public IsMonsterCount boolean
---@field public IsDeathMimicry boolean
---@field public IsTransfigured boolean
---@field public IsRideVehicle boolean
---@field public IsRideHideVehicle boolean
---@field public BattleVehicleID number
---@field public IsFly boolean
---@field public IsOnSky boolean
---@field public IsClimb boolean
---@field public IsFishing boolean
---@field public IsPassenger boolean
---@field public IsFalling boolean
---@field public IsSpecialFalling boolean
---@field public IsRaycastHit boolean
---@field public IsFake boolean
---@field public PubVehicle MoonClient.MPubVehicle
---@field public IsRidePubVehicle boolean
---@field public IsRideAnyVehicle boolean
---@field public InCarrying boolean
---@field public CarryingID number
---@field public IsNpcDoubleAction boolean
---@field public InBattle boolean
---@field public InSelfy boolean
---@field public InShoot boolean
---@field public IsRideBattleVehicle boolean
---@field public PredictedPos UnityEngine.Vector3
---@field public IsOnSeat boolean
---@field public IsEmotionAction boolean
---@field public IsBuffStateMutex boolean
---@field public IsMovable boolean
---@field public IsTransfigureSaveFashion boolean
---@field public TeleportFx number
---@field public CanManualMove boolean
---@field public Name string
---@field public IsDead boolean
---@field public IsDancing boolean
---@field public IsWildDancing boolean
---@field public IsMoving boolean
---@field public IsMixToDefaultAction boolean
---@field public AtorSpeed number
---@field public Machine MoonClient.MStateMachine
---@field public CurrentState number
---@field public AttrComp MoonClient.MAttrComponent
---@field public BeHitComp MoonClient.MBeHitComponent
---@field public Skill MoonClient.MSkillComponent
---@field public Buff MoonClient.MBuffComponent
---@field public CarryItemComp MoonClient.MCarryItemComponent
---@field public Vehicle MoonClient.MModel
---@field public VehicleMaterialType number
---@field public VehicleOrModel MoonClient.MModel
---@field public ModelOrg MoonClient.MModel
---@field public Model MoonClient.MModel
---@field public Sound MoonClient.SoundComponent
---@field public SingingComp MoonClient.MSingingComponent
---@field public MoveComp MoonClient.MMoveComponent
---@field public DeadComp MoonClient.MDeadComponent
---@field public ChangeModelComp MoonClient.MChangeModelComponent
---@field public VehicleComp MoonClient.MVehicleComponent
---@field public DanceComp MoonClient.MDanceComponent
---@field public VehicleCtrlComp MoonClient.MVehicleControl
---@field public BattleVehicleComp MoonClient.MBattleVehicleComponent
---@field public TransfigureComp MoonClient.MTransfigureComponent
---@field public SpecialComp MoonClient.MSpecialComponent
---@field public DoubleActionComp MoonClient.MDoubleActionClipComponent
---@field public ClimbComp MoonClient.MClimbComponent
---@field public SelfyComponent MoonClient.MSelfyComponent
---@field public Target MoonClient.MEntity
---@field public ServerPos UnityEngine.Vector3
---@field public BoundageMaxY number
---@field public VehicleBoundageMaxY number
---@field public IsVisible boolean
---@field public Position UnityEngine.Vector3
---@field public Rotation UnityEngine.Quaternion
---@field public RunSpeed number
---@field public Scale UnityEngine.Vector3
---@field public MObjScale UnityEngine.Vector3
---@field public EagleUID uint64

---@type MoonClient.MEntity
MoonClient.MEntity = { }
---@overload fun(): MoonClient.MEntity
---@return MoonClient.MEntity
---@param defaultComponentSize number
function MoonClient.MEntity.New(defaultComponentSize) end
---@return boolean
---@param buff_id number
function MoonClient.MEntity:HasBuff(buff_id) end
---@return MoonClient.MBuff
---@param buff_id number
function MoonClient.MEntity:GetBuff(buff_id) end
---@return number
---@param buff_id number
function MoonClient.MEntity:GetBuffLevel(buff_id) end
---@return boolean
function MoonClient.MEntity:InPvPScene() end
---@overload fun(t:number): number
---@return number
---@param t number
function MoonClient.MEntity:GetAttr(t) end
---@return boolean
function MoonClient.MEntity:HasEagle() end
---@return number
---@param radio number
function MoonClient.MEntity:GetHeight(radio) end
---@return number
---@param radio number
function MoonClient.MEntity:GetVehicleHeight(radio) end
function MoonClient.MEntity:Revive() end
function MoonClient.MEntity:OnDestrory() end
function MoonClient.MEntity:Uninit() end
function MoonClient.MEntity:SkillEditorSetPlayer() end
---@param x number
---@param z number
---@param y number
---@param reason number
function MoonClient.MEntity:SetPosition(x, z, y, reason) end
---@return number
function MoonClient.MEntity:GetUnitTypeLevel() end
---@return number
---@param t number
---@param skill_id number
function MoonClient.MEntity:GetSkillInfo(t, skill_id) end
---@param attr MoonClient.MAttrComponent
function MoonClient.MEntity:ResetAttr(attr) end
---@param attr MoonClient.MAttrComponent
---@param pos UnityEngine.Vector3
---@param rot UnityEngine.Quaternion
---@param isCutScene boolean
function MoonClient.MEntity:Initialize(attr, pos, rot, isCutScene) end
---@overload fun(movement:UnityEngine.Vector3): void
---@param x number
---@param y number
---@param z number
function MoonClient.MEntity:AppendMove(x, y, z) end
---@param t number
function MoonClient.MEntity:ChangeBehitFx(t) end
---@param t number
function MoonClient.MEntity:ChangeBehitAudio(t) end
---@param fDeltaT number
function MoonClient.MEntity:Update(fDeltaT) end
---@return boolean
---@param model MoonClient.MModel
---@param movement UnityEngine.Vector3
---@param t number
function MoonClient.MEntity.MoveModel(model, movement, t) end
---@return boolean
---@param e MoonClient.MEntity
function MoonClient.MEntity.ValideEntity(e) end
---@return boolean
---@param e MoonClient.MEntity
function MoonClient.MEntity.ValideEntityIncludeDead(e) end
---@param obj UnityEngine.GameObject
function MoonClient.MEntity:OnUObjLoaded(obj) end
---@param alpha number
function MoonClient.MEntity:ChangeAlpha(alpha) end
---@param callback (fun(center:UnityEngine.Vector3, radius:number):boolean)
function MoonClient.MEntity:ForeachHugeMonsterColliderCenter(callback) end
---@return UnityEngine.Vector3
---@param firer MoonClient.MEntity
function MoonClient.MEntity:GetCastPoint(firer) end
---@return number
function MoonClient.MEntity:GetBuffVehicle() end
---@return number
function MoonClient.MEntity:GetCurSceneID() end
---@return number
function MoonClient.MEntity:GetCurSceneType() end
function MoonClient.MEntity:Recycle() end
---@return boolean
---@param actionId number
function MoonClient.MEntity:IsDoRightSpecialAction(actionId) end
---@return MoonClient.MAnimator.MAnimInfo
---@param key string
---@param clipName string
---@param blendTreeKey string
function MoonClient.MEntity:OverrideAnim(key, clipName, blendTreeKey) end
---@param eventType number
---@param delay number
---@param args MoonClient.IEventArg
function MoonClient.MEntity:DelayFireEvent(eventType, delay, args) end
return MoonClient.MEntity
