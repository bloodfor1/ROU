---@class MoonClient.MPlayer : MoonClient.MRole
---@field public NavComp MoonClient.MNavigationComponent
---@field public AIComp MoonClient.MAIComponent
---@field public FxComp MoonClient.MTargetFxComponent
---@field public Target MoonClient.MEntity
---@field public AttrComp MoonClient.MAttrComponent
---@field public OriginalAttrComp MoonClient.MAttrComponent
---@field public AttrRole MoonClient.MAttrRole
---@field public IsStuck boolean
---@field public IsAutoBattle boolean
---@field public StuckCount number
---@field public Position UnityEngine.Vector3
---@field public ServerPos UnityEngine.Vector3
---@field public Rotation UnityEngine.Quaternion
---@field public AutoFishLeftTime number
---@field public NextSkillUUID number
---@field public IsWaitingForServer boolean
---@field public InBattle boolean
---@field public IsMovable boolean
---@field public ReviveNumber number
---@field public DungeonsBegainTime int64

---@type MoonClient.MPlayer
MoonClient.MPlayer = { }
---@return MoonClient.MPlayer
function MoonClient.MPlayer.New() end
function MoonClient.MPlayer:WaitServer() end
function MoonClient.MPlayer:ServerCallBack() end
---@return UnityEngine.Vector3
---@param firer MoonClient.MEntity
function MoonClient.MPlayer:GetCastPoint(firer) end
function MoonClient.MPlayer:Uninit() end
---@param obj UnityEngine.GameObject
function MoonClient.MPlayer:OnUObjLoaded(obj) end
---@param _killerUID uint64
---@param coolDownTime number
---@param hatorId number
function MoonClient.MPlayer:Dead(_killerUID, coolDownTime, hatorId) end
function MoonClient.MPlayer:Revive() end
---@param fDeltaT number
function MoonClient.MPlayer:Update(fDeltaT) end
function MoonClient.MPlayer:StopState() end
function MoonClient.MPlayer:UpdateMove() end
---@param sysnOldPos UnityEngine.Vector3
---@param accuracy number
function MoonClient.MPlayer.CorrectSyncPos(sysnOldPos, accuracy) end
---@return int64
---@param itemId number
function MoonClient.MPlayer:GetItemNum(itemId) end
---@return boolean
function MoonClient.MPlayer:LearnReviveSkill() end
---@param isNew boolean
function MoonClient.MPlayer:EditorSetAIType(isNew) end
function MoonClient.MPlayer:Recycle() end
return MoonClient.MPlayer
