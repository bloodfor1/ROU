---@class MoonClient.MPlayerInfo : MoonCommonLib.MSingleton_MoonClient.MPlayerInfo
---@field public IsInGuild boolean
---@field public followStartTimer number
---@field public OnOfflineStateTimer number
---@field public IsAreadyRegistGlobalTouch boolean
---@field public AfkCdTime number
---@field public IsPreviewAutoBattleRange boolean
---@field public AutoFightType number
---@field public AutoFightRangeType number
---@field public AutoFightRange number
---@field public AutoBattleList System.Collections.Generic.HashSet_System.Int32
---@field public IsAutoBattle boolean
---@field public IsAutoFollow boolean
---@field public AutoBattleAttackAll boolean
---@field public EnableAutoHpDrag boolean
---@field public AutoDragHpPercent number
---@field public AutoHpDragItemList System.Int32[]
---@field public EnableAutoMpDrag boolean
---@field public AutoDragMpPercent number
---@field public AutoMpDragItemList System.Int32[]
---@field public EnableAutoPickUp boolean
---@field public AutoPickUpPercent number
---@field public albumInfo MoonClient.PlayerAlbumInfo
---@field public IsPhotoMode boolean
---@field public CurrentPhotoCameraMode number
---@field public CurrentCameraMode number
---@field public CameraShowTypes number
---@field public HideFx boolean
---@field public CameraDistance number
---@field public HairStyle number
---@field public Fashion number
---@field public OrnamentHead number
---@field public OrnamentFace number
---@field public OrnamentMouth number
---@field public OrnamentBack number
---@field public OrnamentTail number
---@field public WeaponFromBag number
---@field public WeaponExFromBag number
---@field public OrnamentHeadFromBag number
---@field public OrnamentFaceFromBag number
---@field public OrnamentMouthFromBag number
---@field public OrnamentBackFromBag number
---@field public OrnamentTailFromBag number
---@field public FashionFromBag number
---@field public EyeColorID number
---@field public EyeID number
---@field public HeadID number
---@field public FrameID number
---@field public BeiluzEffectID number
---@field public PlayerDungeonsInfo MoonClient.MPlayerDungeonsInfo
---@field public AttackRoleInfo MoonClient.MPlayerAttackRoleInfo
---@field public AbnormalState boolean
---@field public Name string
---@field public ShownTitleId number
---@field public ShownTagId number
---@field public CamRotX number
---@field public SessionId uint64
---@field public UID uint64
---@field public ProID number
---@field public IsMale boolean
---@field public VehicleItemID number
---@field public VehicleOrnamentID number
---@field public VehicleDyeID number
---@field public ClimbUid uint64
---@field public PosEnterScene UnityEngine.Vector3
---@field public EnterFace number
---@field public ServerName string
---@field public ZeroProfitTime System.DateTime
---@field public ZeroProfitReason string
---@field public ChangeNameCount number
---@field public ServerLevel number
---@field public CertificatesCount int64
---@field public Debris int64
---@field public CurrentAccount string
---@field public CurrentPassword string
---@field public LastTouchTime number
---@field public IsWatchWar boolean
---@field public WatchFocusPlayerId uint64
---@field public IsHideOutlookWhenBeWatched boolean
---@field public CustomLockTouch boolean
---@field public Lv number
---@field public JobLv number
---@field public Exp int64
---@field public JobExp int64
---@field public BlessExp int64
---@field public BlessJobExp int64
---@field public Coin104 int64
---@field public Coin103 int64
---@field public Coin101 int64
---@field public Coin102 int64
---@field public Yuanqi int64
---@field public BoliPoint int64
---@field public GuildContribution int64
---@field public ArenaCoin int64
---@field public Prestige int64
---@field public AssistCoin int64
---@field public MonsterCoin int64
---@field public MerchantCoin int64
---@field public ExtraFightTime number
---@field public IsTalking boolean
---@field public ExpRate number
---@field public BlessExpRate number
---@field public JobExpRate number
---@field public BlessJobExpRate number
---@field public ProfessionId number
---@field public OpenSecondSlot boolean
---@field public SkillList System.Collections.Generic.List_MoonClient.MSkillInfo
---@field public SkillSlots MoonClient.MSkillInfo[]
---@field public QueueSkillSlot MoonClient.MSkillInfo[]
---@field public AutoSkillSlots MoonClient.MSkillInfo[]
---@field public IsAutoSkillSlotsChange boolean
---@field public MainUISkillSlots MoonClient.MSkillInfo[]
---@field public SkillDict System.Collections.Generic.Dictionary_System.Int32_MoonClient.MSkillInfo
---@field public BuffSkillDict System.Collections.Generic.Dictionary_System.Int32_MoonClient.MSkillInfo
---@field public MaxSkillPoint number
---@field public MaxQueueSlotCount number
---@field public QueueSkillIndex number
---@field public BaseProId number
---@field public ProOneId number
---@field public ProTwoId number
---@field public ProThreeId number
---@field public ProFourId number
---@field public QueueSkillId number
---@field public ProfessionIdList System.Collections.Generic.List_System.Int32
---@field public FixedSkillIdList System.Collections.Generic.List_System.Int32
---@field public FixedUnlockSkillIdList System.Collections.Generic.List_System.Int32
---@field public ReleaseState number
---@field public TeamInfo MoonClient.TeamInfo
---@field public IsFollowing boolean
---@field public IsInTeam boolean
---@field public IsCaptain boolean
---@field public TeamMemberNumber number
---@field public TeamMemberBasicInfoDic System.Collections.Generic.Dictionary_System.UInt64_MoonClient.TeamMemberBasicInfo
---@field public FollowerUid uint64
---@field public WorldEvents System.Collections.Generic.List_KKSG.WorldEventDB

---@type MoonClient.MPlayerInfo
MoonClient.MPlayerInfo = { }
---@return MoonClient.MPlayerInfo
function MoonClient.MPlayerInfo.New() end
---@param id number
function MoonClient.MPlayerInfo:AddMonsterTarget(id) end
---@param id number
function MoonClient.MPlayerInfo:RemoveMonsterTarget(id) end
---@return boolean
---@param id number
function MoonClient.MPlayerInfo:HasMonsterTarget(id) end
---@param is_follow boolean
function MoonClient.MPlayerInfo:AutoBattleFollowFx(is_follow) end
---@param fx_num number
---@param fx_range number
---@param show_range boolean
function MoonClient.MPlayerInfo:PlayerAutoBattleRangeFx(fx_num, fx_range, show_range) end
---@param pos UnityEngine.Vector3
---@param fx_num number
---@param fx_range number
---@param show_range boolean
function MoonClient.MPlayerInfo:AutoBattleRangeFx(pos, fx_num, fx_range, show_range) end
---@return boolean
---@param entity MoonClient.MEntity
function MoonClient.MPlayerInfo:CameraModeNeedHide(entity) end
---@return boolean
---@param showType number
function MoonClient.MPlayerInfo:IsMatchCameraShowMode(showType) end
---@param showType number
---@param open boolean
function MoonClient.MPlayerInfo:SetShowMode(showType, open) end
---@return boolean
function MoonClient.MPlayerInfo:Init() end
function MoonClient.MPlayerInfo:Uninit() end
---@param clearAccountData boolean
function MoonClient.MPlayerInfo:OnLogout(clearAccountData) end
---@param x number
---@param y number
---@param z number
---@param face number
function MoonClient.MPlayerInfo:SetPosEnterScene(x, y, z, face) end
---@param npcId number
---@param offsetY number
---@param dis number
---@param RotX number
---@param RotY number
function MoonClient.MPlayerInfo:FocusToNpc(npcId, offsetY, dis, RotX, RotY) end
---@param npcId number
---@param offsetX number
---@param offsetY number
---@param offsetZ number
---@param dis number
---@param RotX number
---@param RotY number
function MoonClient.MPlayerInfo:FocusToOrnamentBarter(npcId, offsetX, offsetY, offsetZ, dis, RotX, RotY) end
---@param npcId number
---@param offsetX number
---@param offsetY number
---@param offsetZ number
---@param dis number
---@param RotX number
---@param RotY number
function MoonClient.MPlayerInfo:FocusToRefine(npcId, offsetX, offsetY, offsetZ, dis, RotX, RotY) end
function MoonClient.MPlayerInfo:FocusToMyPlayer() end
---@param pos UnityEngine.Vector3
function MoonClient.MPlayerInfo:FocusToPosition(pos) end
---@param layer number
function MoonClient.MPlayerInfo:CloseCameraMask(layer) end
---@param layer number
function MoonClient.MPlayerInfo:OpenCameraMask(layer) end
---@return boolean
function MoonClient.MPlayerInfo:FocusOpenBookView() end
---@param value number
---@param entity MoonClient.MEntity
function MoonClient.MPlayerInfo:FocusOffSetView(value, entity) end
---@param value number
function MoonClient.MPlayerInfo:FocusOffSetValueUpdate(value) end
---@param id number
function MoonClient.MPlayerInfo:Focus2Player(id) end
---@param id number
---@param go UnityEngine.GameObject
---@param isHidePlayer boolean
function MoonClient.MPlayerInfo:Focus2Go(id, go, isHidePlayer) end
---@param id number
---@param npcId number
---@param isHidePlayer boolean
function MoonClient.MPlayerInfo:Focus2Npc(id, npcId, isHidePlayer) end
---@param id number
---@param targetPos UnityEngine.Vector3
---@param face number
---@param isHidePlayer boolean
function MoonClient.MPlayerInfo:Focus2Pos(id, targetPos, face, isHidePlayer) end
---@param id number
---@param roleId uint64
---@param isHidePlayer boolean
---@param go UnityEngine.GameObject
---@param targetPos System.Nullable_UnityEngine.Vector3
---@param targetY System.Nullable_System.Single
function MoonClient.MPlayerInfo:Focus2AdaptiveState(id, roleId, isHidePlayer, go, targetPos, targetY) end
---@return boolean
---@param fromPos UnityEngine.Vector3
---@param toPos UnityEngine.Vector3
---@param fromRot UnityEngine.Vector3
---@param toRot UnityEngine.Vector3
---@param ease number
---@param time number
function MoonClient.MPlayerInfo:ApproachFocus2Entity(fromPos, toPos, fromRot, toRot, ease, time) end
function MoonClient.MPlayerInfo:ExitAdaptiveState() end
---@return MoonClient.MRole
---@param uid uint64
---@param notWeapon boolean
---@param professionId number
function MoonClient.MPlayerInfo:CreateCutScenePlayer(uid, notWeapon, professionId) end
---@return MoonClient.MPlayer
function MoonClient.MPlayerInfo:CreateMPlayer() end
function MoonClient.MPlayerInfo:InitPlayerEntity() end
---@param orgRotY3D number
---@param minRotY3D number
---@param maxRotY3D number
function MoonClient.MPlayerInfo:SetCameraRotRangeLimit(orgRotY3D, minRotY3D, maxRotY3D) end
function MoonClient.MPlayerInfo:RecoveCameraRotRange() end
---@return MoonClient.LifeSKillInfo
---@param t number
function MoonClient.MPlayerInfo:GetLifeSkillInfo(t) end
---@param data KKSG.LifeSkillInfo
function MoonClient.MPlayerInfo:RefreshLifeSkillInfo(data) end
---@return number
---@param skillId number
function MoonClient.MPlayerInfo:GetRootSkillId(skillId) end
---@return boolean
---@param skillId number
function MoonClient.MPlayerInfo:IsFixedSkill(skillId) end
---@return boolean
---@param skillId number
function MoonClient.MPlayerInfo:IsFixedUnlockSkill(skillId) end
---@return boolean
---@param skillId number
function MoonClient.MPlayerInfo:NeedTaskFinish(skillId) end
---@return boolean
---@param skillId number
function MoonClient.MPlayerInfo:NeedSkillPointToLearn(skillId) end
---@return boolean
---@param skillid number
---@param skilllv number
function MoonClient.MPlayerInfo:IsSkillReplaced(skillid, skilllv) end
---@param player MoonClient.MEntity
---@param skillInfo MoonClient.MSkillInfo
function MoonClient.MPlayerInfo:TryReplaceSkillInfo(player, skillInfo) end
---@return boolean
---@param player MoonClient.MEntity
---@param skillInfo MoonClient.MSkillInfo
function MoonClient.MPlayerInfo:CheckReplaceSkillInfo(player, skillInfo) end
---@param slotIdxs System.Int32[]
---@param skillIDs System.Int32[]
---@param skillLvs System.Int32[]
---@param forceInit boolean
function MoonClient.MPlayerInfo:SetSkillSlots(slotIdxs, skillIDs, skillLvs, forceInit) end
---@param slotIdxs System.Int32[]
---@param skillIDs System.Int32[]
---@param skillLvs System.Int32[]
function MoonClient.MPlayerInfo:SetMainUISkillSlots(slotIdxs, skillIDs, skillLvs) end
function MoonClient.MPlayerInfo:UnSetMainUISkillSlots() end
---@overload fun(skillId:number, skillLv:number, tutorialId:number, showSkill:boolean): void
---@param skillId number
---@param skillLv number
---@param tutorialId number
---@param showSkill boolean
---@param slotIdx number
function MoonClient.MPlayerInfo:AddMainUISkillSlot(skillId, skillLv, tutorialId, showSkill, slotIdx) end
---@return boolean
---@param skillId number
function MoonClient.MPlayerInfo:HasSkillOnMainUISkillSlot(skillId) end
---@param slotIdxs System.Int32[]
---@param skillIDs System.Int32[]
---@param skillLvs System.Int32[]
---@param forceInit boolean
function MoonClient.MPlayerInfo:SetQueueSkillSlots(slotIdxs, skillIDs, skillLvs, forceInit) end
---@param slotIdxs System.Int32[]
---@param skillIDs System.Int32[]
---@param skillLvs System.Int32[]
---@param forceInit boolean
function MoonClient.MPlayerInfo:SetAutoSkillSlots(slotIdxs, skillIDs, skillLvs, forceInit) end
---@param skillIDs System.Int32[]
---@param skillLvs System.Int32[]
---@param forceInit boolean
function MoonClient.MPlayerInfo:SetSkills(skillIDs, skillLvs, forceInit) end
---@param skillIDs System.Int32[]
---@param skillLvs System.Int32[]
function MoonClient.MPlayerInfo:SetBuffSkills(skillIDs, skillLvs) end
function MoonClient.MPlayerInfo:ResetSkills() end
---@param skillId number
---@param addPoint number
function MoonClient.MPlayerInfo:AddSkillPoint(skillId, addPoint) end
---@return MoonClient.MSkillInfo
---@param skillID number
---@param isBuff boolean
function MoonClient.MPlayerInfo:GetCurrentSkillInfo(skillID, isBuff) end
---@param skillId number
function MoonClient.MPlayerInfo:RemoveSkillSlot(skillId) end
---@param skillId number
function MoonClient.MPlayerInfo:RemoveMainUISkillSlot(skillId) end
---@return MoonClient.MSkillInfo
---@param skillID number
function MoonClient.MPlayerInfo:GetSkillInfoFromAutoSlot(skillID) end
---@return MoonClient.MSkillInfo
---@param skillID number
function MoonClient.MPlayerInfo:GetSkillInfoFromSkillSlot(skillID) end
---@return number
---@param rawTime number
function MoonClient.MPlayerInfo:GetSkillRealTime(rawTime) end
function MoonClient.MPlayerInfo:RefreshAllSkillToSkillMap() end
---@return number
---@param skillId number
function MoonClient.MPlayerInfo:GetSlotIndexBySkillId(skillId) end
---@return MoonClient.MSkillInfo
---@param skillId number
function MoonClient.MPlayerInfo:GetCombineSkillInfo(skillId) end
---@return boolean
function MoonClient.MPlayerInfo:CheckQueneHasSkill() end
function MoonClient.MPlayerInfo:InitQueueIndex() end
---@return MoonClient.MSkillInfo
function MoonClient.MPlayerInfo:GetNextQueneSkill() end
---@return boolean
---@param skillId number
function MoonClient.MPlayerInfo:IsQueueSkillNotNeedRefresh(skillId) end
---@return MoonClient.MSkillInfo
function MoonClient.MPlayerInfo:GetNowQueneSkill() end
---@return boolean
---@param id number
function MoonClient.MPlayerInfo:JudNowQSkillInSelfCD(id) end
---@return UnityEngine.Vector3
---@param npcId number
---@param sceneId number
function MoonClient.MPlayerInfo:GetTaskNpcPosition(npcId, sceneId) end
---@param npcId number
---@param sceneId number
---@param position UnityEngine.Vector3
function MoonClient.MPlayerInfo:CacheTaskNpcPosition(npcId, sceneId, position) end
---@param npcId number
---@param sceneId number
function MoonClient.MPlayerInfo:RemoveTaskNpcPosition(npcId, sceneId) end
function MoonClient.MPlayerInfo:ClearTaskNpcPosition() end
---@return boolean
---@param taskId number
---@param collectionId number
function MoonClient.MPlayerInfo:CheckCollection(taskId, collectionId) end
---@param taskId number
---@param collectionId number
function MoonClient.MPlayerInfo:AddCollectionWithTask(taskId, collectionId) end
---@param taskId number
---@param collectionId number
function MoonClient.MPlayerInfo:RemoveCollectionWithTask(taskId, collectionId) end
---@return boolean
---@param targetId number
---@param collectionId number
function MoonClient.MPlayerInfo:CheckCollectionByTarget(targetId, collectionId) end
---@param targetId number
---@param collectionId number
function MoonClient.MPlayerInfo:AddCollectionWithTaskTarget(targetId, collectionId) end
---@param targetId number
---@param collectionId number
function MoonClient.MPlayerInfo:RemoveCollectionWithTaskTarget(targetId, collectionId) end
function MoonClient.MPlayerInfo:ClearCollection() end
function MoonClient.MPlayerInfo:ClearTaskSceneObjActionID() end
---@param sceneTriggerUID number
---@param actionID number
function MoonClient.MPlayerInfo:AddTaskSceneObjActionID(sceneTriggerUID, actionID) end
---@param sceneTriggerUID number
function MoonClient.MPlayerInfo:RemoveTaskSceneObjActionID(sceneTriggerUID) end
---@return number
---@param sceneTriggerUID number
function MoonClient.MPlayerInfo:GetActionIdByTriggerUID(sceneTriggerUID) end
---@param npcId number
---@param actionId number
---@param script string
---@param tag string
function MoonClient.MPlayerInfo:AddTaskNpcAction(npcId, actionId, script, tag) end
---@param npcId number
function MoonClient.MPlayerInfo:RemoveTaskNpcAction(npcId) end
function MoonClient.MPlayerInfo:ClearTaskNpcAction() end
---@return MoonClient.TaskNpcAction
---@param npcId number
function MoonClient.MPlayerInfo:GetTaskNpcAction(npcId) end
---@return number
---@param npcId number
function MoonClient.MPlayerInfo:GetTaskNpcActionId(npcId) end
---@return boolean
function MoonClient.MPlayerInfo:CheckFishTaskFinished() end
---@return boolean
---@param taskId number
function MoonClient.MPlayerInfo:CheckTaskFinished(taskId) end
---@return System.Collections.Generic.Dictionary_System.UInt64_System.Single
function MoonClient.MPlayerInfo:GetCaptainTargets() end
---@return System.Collections.Generic.List_System.UInt64
function MoonClient.MPlayerInfo:GetAttackMeTargets() end
---@return System.Collections.Generic.List_System.UInt64
function MoonClient.MPlayerInfo:GetAttackTeamMateTargets() end
---@return uint64
---@param roleId uint64
function MoonClient.MPlayerInfo.GetOwnerUID(roleId) end
---@overload fun(roleIdA:uint64): boolean
---@return boolean
---@param roleIdA uint64
---@param roleIdB uint64
function MoonClient.MPlayerInfo:IsInSameTeam(roleIdA, roleIdB) end
function MoonClient.MPlayerInfo:ClearTeamTarget() end
---@return boolean
---@param uid uint64
function MoonClient.MPlayerInfo:AutoBattleTraceBack(uid) end
---@param captainId uint64
function MoonClient.MPlayerInfo:SetCaptainId(captainId) end
---@param uuid uint64
function MoonClient.MPlayerInfo:AddCaptainTarget(uuid) end
---@param uuid uint64
function MoonClient.MPlayerInfo:AddAttackMeTarget(uuid) end
---@param uuid uint64
function MoonClient.MPlayerInfo:AddAttackTeamMateTarget(uuid) end
---@param uuid uint64
function MoonClient.MPlayerInfo:RemoveCaptainTarget(uuid) end
---@param uuid uint64
function MoonClient.MPlayerInfo:RemoveAttackMeTarget(uuid) end
---@param uuid uint64
function MoonClient.MPlayerInfo:RemoveAttackTeamMateTarget(uuid) end
---@return uint64
---@param uid uint64
function MoonClient.MPlayerInfo:GetTeamIdByRoleId(uid) end
---@return boolean
---@param uid uint64
function MoonClient.MPlayerInfo:GetIsInTeamByUid(uid) end
---@return boolean
---@param uid uint64
function MoonClient.MPlayerInfo:GetIsShowHudByUid(uid) end
---@param teamInfo KKSG.TeamInfo
---@param isCreate boolean
function MoonClient.MPlayerInfo:UpdateTeamInfo(teamInfo, isCreate) end
---@param teamid uint64
---@param memberInfos Google.Protobuf.Collections.RepeatedField_KKSG.MemberStatusInfo
function MoonClient.MPlayerInfo:UpdateTeamMembersPos(teamid, memberInfos) end
---@param allMemberStatusInfo KKSG.AllMemberStatusInfo
function MoonClient.MPlayerInfo:UpdateTeamMembersStatusInfo(allMemberStatusInfo) end
function MoonClient.MPlayerInfo:UpdateTeamMapInfo() end
function MoonClient.MPlayerInfo:ClearTeamInfo() end
---@param uid uint64
function MoonClient.MPlayerInfo:UpdateLeaveTeam(uid) end
function MoonClient.MPlayerInfo:GetTeamInfo() end
function MoonClient.MPlayerInfo:LeaveTeam() end
---@param cId uint64
---@param cColor number
function MoonClient.MPlayerInfo:UpdateTeamTxtInfo(cId, cColor) end
function MoonClient.MPlayerInfo:RegistFollowEvent() end
function MoonClient.MPlayerInfo:RemoveFollowEvent() end
function MoonClient.MPlayerInfo:StopFollowTimer() end
function MoonClient.MPlayerInfo:RegistGlobalTouchEvent() end
function MoonClient.MPlayerInfo:RemoveGlobalTouchEvent() end
function MoonClient.MPlayerInfo:StopOfflineTimer() end
---@param eventId number
function MoonClient.MPlayerInfo:RemoveWorldEvent(eventId) end
---@return UnityEngine.Vector3
---@param npcId number
---@param sceneId number
function MoonClient.MPlayerInfo:GetWorldEventNpcPosition(npcId, sceneId) end
---@param roPtc MoonClient.PtcG2C_RoleWorldEventNotify
function MoonClient.MPlayerInfo:OnRoleWorldEventNtf(roPtc) end
return MoonClient.MPlayerInfo
