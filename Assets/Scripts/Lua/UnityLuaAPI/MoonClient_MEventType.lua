---@class MoonClient.MEventType : System.Enum
---@field public value__ number
---@field public MEvent_Invalid number
---@field public Mevent_Born number
---@field public MEvent_Move number
---@field public MEvent_Jump number
---@field public MEvent_BeHit number
---@field public MEvent_Displacement number
---@field public MEvent_Displacement_Fly number
---@field public MEvent_DisplacementStop number
---@field public MEvent_Stun number
---@field public MEvent_Dead number
---@field public MEvent_Special number
---@field public MEvent_Dance number
---@field public MEvent_StopSpecial number
---@field public MEvent_ClientActiveStopSpecial number
---@field public MEvent_doubleActionClip number
---@field public MEvent_StopDoubleActionClip number
---@field public MEvent_DoubleActionClipControlStart number
---@field public MEvent_DoubleActionClipControlStop number
---@field public MEvent_DoubleActionClipControlNavFailed number
---@field public MEvent_DoubleActionClipControlNavSuccess number
---@field public MEvent_DoubleActionNPCInterrupt number
---@field public MEvent_Teleport number
---@field public MEvent_FollowTeleport number
---@field public MEvent_ToFish number
---@field public MEvent_Fishing number
---@field public MEvent_AutoFishing number
---@field public MEvent_FishingItemChange number
---@field public MEvent_FishingTouch number
---@field public MEvent_StartFishing number
---@field public MEvent_FishingUppingRod number
---@field public MEvent_FishingUpRod number
---@field public MEvent_FishingFishResult number
---@field public MEvent_StopFish number
---@field public MEvent_TempAnim number
---@field public MEvent_Collect number
---@field public MEvent_Npc number
---@field public MEvent_ClickNpc number
---@field public MEvent_ClickRole number
---@field public MEvent_StopNpc number
---@field public MEvent_Singing number
---@field public MEvent_Singing_Target number
---@field public MEvent_Skill number
---@field public MEvent_Skill_No_Anim number
---@field public MEvent_Skill_Core_Sync number
---@field public MEvent_Skill_Self_Use number
---@field public MEvent_InBattle number
---@field public MEvent_RideVehicle number
---@field public MEvent_UnRideVehicle number
---@field public MEvent_Fall_State_Change number
---@field public MGlobalEvent_Player_FlyState_Change number
---@field public MEvent_CloseEyes number
---@field public MEvent_Entity_Buff_Color_Change number
---@field public MEvent_Entity_Skill_Color_Change number
---@field public MEvent_Entity_Skill_Rim_Change number
---@field public MEvent_Entity_Skill_Color_Stop number
---@field public MEvent_CloseEyeEmotion number
---@field public MEvent_ChangeEmotion number
---@field public MEvent_StopEmotion number
---@field public MEvent_StopMove number
---@field public MEvent_InnerDirectionStopMove number
---@field public MEvent_PrepareDead number
---@field public MEvent_Hiding number
---@field public MEvent_FearRun number
---@field public MEvent_Freeze number
---@field public MEvent_SkillAdd number
---@field public MEvent_EnterWall number
---@field public MEvent_CarryItem number
---@field public MEvent_InSelfy number
---@field public MEvent_InSelfyAngle_Change number
---@field public MEvent_RefreshDefaultState number
---@field public MEvent_OnSpecial_Change number
---@field public MEvent_StartNavigation number
---@field public MEvent_OnNpcNavigation number
---@field public MEvent_OnNpcStopNavigation number
---@field public MEvent_TakeOnBarrow number
---@field public MEvent_TakeOffBarrow number
---@field public MEvent_UseReviveItem number
---@field public MEvent_Role_Revive number
---@field public MEvent_UseRevive_NeedConfirm number
---@field public MEvent_StartClimb number
---@field public MEvent_StopClimb number
---@field public MEvent_ClimbMove number
---@field public MEvent_OnlineClimb number
---@field public MEvent_CamTarget number
---@field public MEvent_CamTargetOffset number
---@field public MEvent_CamTargetDis number
---@field public MEvent_CamTargetRot number
---@field public MEvent_CamTargetRotX number
---@field public MEvent_CamRotYRangeLimit number
---@field public MEvent_RecoverDefaultCamRotYRange number
---@field public MEvent_CameraShake number
---@field public MEvent_CameraEffect number
---@field public MEvent_CameraFade number
---@field public MEvent_CameraFadeStop number
---@field public MEvent_CameraFadeInOut number
---@field public MEvent_CamChangeState number
---@field public MEvent_CamFixedAction number
---@field public MEvent_CancelPhotoCamera number
---@field public MEvent_CamFixedAngle number
---@field public MEvent_CamFixedApproach number
---@field public MEvent_CamSelectChar number
---@field public MEvent_RecoverDefaultView number
---@field public MEvent_CamBackTrack number
---@field public MEvent_BreaCamkBackTrack number
---@field public MEvent_TriggerCamToNormal number
---@field public MEvent_CameraRoamStart number
---@field public MEvent_CameraRoamArrived number
---@field public MEvent_CameraRoamInit number
---@field public MEvent_CameraStateExit number
---@field public MEvent_CameraStateEnter number
---@field public MEvent_CameraSetFovImmediately number
---@field public MEvent_CameraSetFov number
---@field public MEvent_CameraFovChangeMode number
---@field public MEvent_CameraAddDeltaFov number
---@field public MEvent_CameraAddDeltaFovImmediately number
---@field public MEvent_CameraFovDeleteToken number
---@field public MEvent_SetCountDownCameraObj number
---@field public MEvent_Camera_Clear_Occluder number
---@field public MEvent_Camera_Culling_Mask_Add number
---@field public MEvent_Camera_Culling_Mask_Remove number
---@field public MEvent_Camera_Refresh_Sky_Photo number
---@field public MEvent_Camera_Layer_Cull number
---@field public MEvent_Light_Distorted_Rpc number
---@field public MGlobalEvent_Collider_Check number
---@field public MEvent_ThemeDungeon number
---@field public MEvent_CamNpc number
---@field public MEvent_AfterOverrideAnim number
---@field public MEvent_Camera_Refine number
---@field public MEvent_CamPhotoDis number
---@field public MEvent_CamPhotoRot number
---@field public MEvent_CamPhotoTarget number
---@field public MEvent_CamCusomOffset number
---@field public MEvent_OffSet number
---@field public MEvent_OffSetType number
---@field public MEvent_CamTrgTarget number
---@field public MEvent_CamTrgSlowSpeed number
---@field public MEvent_CamTrgRot number
---@field public MEvent_CamAdaptive number
---@field public MEvent_CamAdaptive_direct number
---@field public MEvent_ShowSkillRange number
---@field public MEvent_HideSkillRange number
---@field public MEvent_SkillRangePos number
---@field public MEvent_UseSkill number
---@field public MEvent_ReplaceSkill number
---@field public MEvent_ChangeSkillOperation number
---@field public MGlobalEvent_RefreshSkill number
---@field public MGlobalEvent_ReSetSkill number
---@field public MGlobalEvent_SetSlotShowInfo number
---@field public MEvent_LocalSyncState number
---@field public MEvent_LocalSceneTriggerSync number
---@field public MEvent_Entity_Created number
---@field public MEvent_Entity_Disappear number
---@field public MEvent_Entity_Global_InView number
---@field public MGlobalEvent_MobMonster_Appear number
---@field public MGlobalEvent_Monster_Appear number
---@field public MGlobalEvent_Monster_Init number
---@field public MGlobalEvent_Monster_Uninit number
---@field public MEvent_HP_Change number
---@field public MEvent_MP_Change number
---@field public MEvent_NameColor_Change number
---@field public MEvent_GuildMsg_Change number
---@field public MEvent_Guild_Hunt_Portal_Change number
---@field public MEvent_RoleName_Change number
---@field public MEvent_RoleTitle_Change number
---@field public MEvent_RoleTag_Change number
---@field public MEvent_DungeonLife_Change number
---@field public MEvent_TempChangeName number
---@field public MEvent_ChangeNameToAttrName number
---@field public MEvent_JumpWord number
---@field public MEvent_ComboWord number
---@field public MEvent_ComboWordEnd number
---@field public MEvent_Skill_PlayName_StopBar number
---@field public MEvent_Skill_PlayName_PlayBar number
---@field public MEvent_Skill_PlayBar number
---@field public MEvent_Skill_PlayName number
---@field public MEvent_Skill_InterruptName_StopBar number
---@field public MEvent_SkillAutoEnd number
---@field public MEvent_DropItem number
---@field public MEvent_SkillEnd number
---@field public MEvent_RefreshShadow number
---@field public MEvent_Display_Attach_Model number
---@field public MEvent_Display_Detach_Model number
---@field public MEvent_Display_Sync number
---@field public MEvent_Ator_Speed_Change number
---@field public MEvent_MountChange number
---@field public MEvent_HairColor_Change number
---@field public MEvent_EyeColor_Change number
---@field public MEvent_CAMP_Change number
---@field public MEvent_FIGHT_GROUP_Change number
---@field public MEvent_OnTransfigure number
---@field public MEvent_OnUnTransfigure number
---@field public MGlobalEvent_OnTransfigureButtonChange number
---@field public MEvent_OnFashionChange number
---@field public MEvent_CastSkillPtc number
---@field public MEvent_SyncSinging number
---@field public MEvent_SyncDead number
---@field public MEvent_Navigation number
---@field public MEvent_ActiveNavigation number
---@field public MEvent_NavgationStop number
---@field public MEvent_NavgationEnd number
---@field public MEvent_NavgationArrive number
---@field public MEvent_LoadNavigation number
---@field public MEvent_NavigationClearSave number
---@field public MEvent_NavgationStart number
---@field public MEvent_LifeTime number
---@field public MEvent_JoystickMoveStart number
---@field public MEvent_JoystickMoveEnd number
---@field public MEvent_ClickGroundMoveStart number
---@field public MEvent_ClickGroundMoveEnd number
---@field public MEvent_FlyWingsMoveEnd number
---@field public MEvent_AutoCollect number
---@field public MEvent_EndAutoCollect number
---@field public MEvent_StopFollow number
---@field public MEvent_MercenaryChange number
---@field public MEvent_PlayerInRange number
---@field public MEvent_PlayerOutRange number
---@field public MEvent_ExclusionStateSet number
---@field public MEvent_ExclusionStateChange number
---@field public MEvent_GlobalTouch number
---@field public MEvent_BUFF number
---@field public MEvent_BUFF_UPDATE number
---@field public MEvent_BUFF_STOP number
---@field public MEvent_Entity_Hiding number
---@field public MEvent_Buff_ReplaceSkill number
---@field public MEvent_Buff_VisibleHiding number
---@field public MEvent_Buff_ClearAll number
---@field public MEvent_Buff_StateType number
---@field public MEvent_ShowHUD number
---@field public MGlobalEvent_Update_Weather_Data number
---@field public MGlobalEvent_Update_To_Next_Hour number
---@field public MGlobalEvent_EnviromentSetting_Update number
---@field public MGlobalEvent_EnviromentSetting_Batched number
---@field public MGlobalEvent_Enter_Soul_PostEffect number
---@field public MGlobalEvent_Exit_Soul_PostEffect number
---@field public MGlobalEvent_Enter_OldPhoto_PostEffect number
---@field public MGlobalEvent_Exit_OldPhoto_PostEffect number
---@field public MEvent_BeatBack number
---@field public MEvent_BeatBackEnd number
---@field public MEvent_BeHitFx number
---@field public MEvent_BeHitFxNoHurt number
---@field public MEvent_BeHitFxCri number
---@field public MEvent_EasyPath number
---@field public MEvent_EasyPathBegin number
---@field public MEvent_EasyPathArrive number
---@field public MEvent_EasyPathCancel number
---@field public MEvent_EasyPathServerInfo number
---@field public MEvent_Task number
---@field public MEvent_Task_Pos number
---@field public MGlobalEvent_OnTaskNpcStateChanged number
---@field public MEvent_EnableAutoBattle number
---@field public MEvent_StopAutoBattle number
---@field public MEvent_AutoBattle_CastSkill number
---@field public MEvent_AutoBattle_FindTarget number
---@field public MEvent_EnableFollow number
---@field public MEvent_AutoBattle_RangeFx number
---@field public MEvent_AutoBattle_FlashFx number
---@field public MEvent_AutoBattle_FollowFx number
---@field public MEvent_AITick number
---@field public MEvent_EnterStage number
---@field public MGlobalEvent_Quality_Level_Change number
---@field public MGlobalEvent_Quality_Post_Type_Change number
---@field public MGlobalEvent_Screen_Resolution_Change number
---@field public MGlobalEvent_Quality_FxParam_Change number
---@field public MGlobalEvent_Scene_Change number
---@field public MGlobalEvent_Scene_Period_Change number
---@field public MGlobalEvent_Scene_Weather_Change number
---@field public MGlobalEvent_Scene_Envoriment_Init_Compelete number
---@field public MGlobalEvent_Scene_Line_Change number
---@field public MGlobalEvent_Show_Scene_Lines number
---@field public MGlobalEvent_Get_Static_Scene_Lines_Data number
---@field public MGlobalEvent_Update_Scene_Lines number
---@field public MGlobalEvent_Clear_Scene_Line_Scroll number
---@field public MGlobalEvent_CutScene_Start number
---@field public MGlobalEvent_CutScene_Stop number
---@field public MGlobalEvent_CutScene_Pasue number
---@field public MGlobalEvent_CutScene_Resume number
---@field public MGlobalEvent_CutScene_NotifyVideoCanStop number
---@field public MEvent_PlayerChat number
---@field public MEvent_ClearChatBubble number
---@field public MEvent_PlayerDie number
---@field public MEvent_WeaponTypeChanged number
---@field public MEvent_CameraShowTypeChange number
---@field public MEvent_RefreshHideState number
---@field public MEvent_FearRunMove number
---@field public MEvent_ShowHeadExpression number
---@field public MEvent_ClearHeadExpression number
---@field public MEvent_ShowPlayerState number
---@field public MEvent_ClearPlayerState number
---@field public MEvent_BeforeTakePhoto number
---@field public MEvent_TakePhotoFinish number
---@field public MGlobalEvent_OnEnterDungeons number
---@field public MGlobalEvent_OnExitDungeons number
---@field public MGlobalEvent_OnDungeonsMonsterNumberUpdate number
---@field public MGlobalEvent_OnDungeonsKillAllMonster number
---@field public MGlobalEvent_OnOpenSystemChange number
---@field public MGlobalEvent_OnOpenSystemUpdate number
---@field public MGlobalEvent_OnSelectTarget number
---@field public MEvent_HideTargetFx number
---@field public MEvent_ShowTargetFx number
---@field public MGlobalEvent_OnDungeonsItemDrop number
---@field public MGlobalEvent_OnTaskInfoUpdate number
---@field public MGlobalEvent_OnDelegateInfoUpdate number
---@field public MGlobalEvent_OnDailyActivityUpdate number
---@field public MGlobalEvent_ShowTextAndSpriteHUD number
---@field public MGlobalEvent_OnConnectSuccess number
---@field public MGlobalEvent_OnReconnectedSuccess number
---@field public MGlobalEvent_OnDisConnected number
---@field public MGlobalEvent_Player_Setting_Load_Competele number
---@field public MEvent_Guide number
---@field public MEvent_StopGuide number
---@field public MEvent_PhotoStartGuide number
---@field public MEvent_PhotoStopGuide number
---@field public MEvent_HPLow number
---@field public MEvent_HPVeryLow number
---@field public MEvent_ChangeScale number
---@field public MEvent_ToCollect number
---@field public MEvent_EndCollect number
---@field public MEvent_CancelCollect number
---@field public MEvent_ColletSelect number
---@field public MEvent_CancelCollectSelect number
---@field public MEvent_SelectEntityChanged number
---@field public MGlobalEvent_CollectCheckPlayerMove number
---@field public MEvent_DestroyCollection number
---@field public MEvent_BattleVehicleChange number
---@field public MEvent_BattleVehicleTemporaryHiding number
---@field public MEvent_ReloadBattleRideAnimation number
---@field public MEvent_BattleVehicleChanged number
---@field public MEvent_BattleVehicleSpecialAction number
---@field public MGlobalEvent_Show_Reporter_GUI number
---@field public MGlobalEvent_Any_Click number
---@field public MGlobalEvent_ClearWait_Skill number
---@field public MGlobalEvent_World_Event number
---@field public MGlobalEvent_EnterSelectCharStage number
---@field public MGlobalEvent_LeaveSelectCharStage number
---@field public MEvent_Num number
---@field public MEvent_GuildCook_Info number
---@field public MEvent_GuildEat_Info number
---@field public MEvent_GuildEat number
---@field public MEvent_GuildEat_Success number
---@field public MEvent_GuildDinner_ShowMenu number
---@field public MEvent_GoToNpc_Local number
---@field public MEvent_GoToPosition_Local number
---@field public MEvent_Gather_ItemChange number
---@field public MEvent_CookingPot_Change number
---@field public MEvent_EntityWeaponTypeChanged number
---@field public MEvent_EditorEntityCreate number
---@field public MEvent_EditorCollectShowButton number
---@field public MEvent_EditorCollectHideButton number
---@field public MEvent_EditorSceneTriggerObjectShowButton number
---@field public MEvent_EditorSceneTriggerObjectHideButton number
---@field public MEvent_CollectionStateChange number
---@field public MEvent_CollectionStateToDestory number
---@field public MEvent_EntityEnterSeat number
---@field public MEvent_EntityLeaveSeat number
---@field public MEvent_TriggerSceneReset number
---@field public MEvent_ClickSceneObject number
---@field public MEvent_SceneTriggerObjectSyncData number
---@field public MEvent_PlayerDoAction number
---@field public MEvent_EnterCollider number
---@field public MEvent_StayCollider number
---@field public MEvent_ExitCollider number
---@field public MEvent_Fishpond number
---@field public MEvent_ClickClientPlayerButton number
---@field public MGlobalEvent_Revive_ItemChange number
---@field public MGlobalEvent_Player_Revive number
---@field public MEvent_Revive_Confirm number
---@field public MEvent_PhotoWallHighLight number
---@field public MEvent_InShoot number
---@field public MEvent_InShootAngleChange number
---@field public MEvent_SpecialFalling number
---@field public MEvent_SceneObjAnimation number
---@field public MEvent_StopLocalNpcAppearEffect number
---@field public MEvent_DisappearLocalNPC number
---@field public MGlobalEvent_DamagedByPlayer number
---@field public MGlobalEvent_KilledByPlayer number
---@field public MGlobalEvent_PlayerStartCollect number
---@field public MGlobalEvent_PlayerCollectSucc number
---@field public MGlobalEvent_NpcCreate number
---@field public MGlobalEvent_NpcDestroy number
---@field public MGlobalEvent_UpdateMapDebugInfoVisible number
---@field public MGlobalEvent_ForceUpdateMiniMapIcon number
---@field public MGlobalEvent_UpdateMapBg number
---@field public MGlobalEvent_UpdateStoneFx number
---@field public MEvent_ShowBeizerArrow number
---@field public MEvent_SetCameraOnlySlowFollow number
---@field public MEvent_NotifyCutsceneImageShot number
---@field public MGlobalEvent_OpenSkyBox number
---@field public MGlobalEvent_DelayCloseSkyBoxTime number
---@field public MEvent_UnitFadeIn number
---@field public MEvent_UnitFadeOut number
---@field public MEvent_SpecialSkyColorChange number
---@field public MEvent_UpdateCollectTimes number
---@field public MGlobalEvent_MediaPlayerEvent number
---@field public MEvent_TriggerGroupEventStart number
---@field public MEvent_TriggerGroupEventInit number
---@field public MEvent_TriggerGroupEventFromServer number
---@field public MEvent_TriggerGroupEventEnd number

---@type MoonClient.MEventType
MoonClient.MEventType = { }
