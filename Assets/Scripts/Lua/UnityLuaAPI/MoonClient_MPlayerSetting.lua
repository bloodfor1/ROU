---@class MoonClient.MPlayerSetting : MoonCommonLib.MSingleton_MoonClient.MPlayerSetting
---@field public FIRST_IN_SCENE string
---@field public TARGET_TAB_TYPE string
---@field public QUALITY_DISPLAY_LEVEL string
---@field public QUALITY_GRADE string
---@field public HARDWARE_GRADE_TYPE string
---@field public LOW_FRAMERATE_TIPS_NUM string
---@field public QUICK_TALK_INFO string
---@field public QUICK_TALK_NUM string
---@field public OPEN_SCREEN_CAPTURE_SHARE string
---@field public AUTO_COLLECT_SCOPE string
---@field public AUTO_COLLECT_ALL_MAP string
---@field public CHAT_SYSTEM_INDEX string
---@field public CHAT_QUICK_INDEX string
---@field public CHAT_QUICK_FRIENDS string
---@field public CAMERA_MODE_HIDE_TYPE string
---@field public PHOTO_MESSAGE_INFO string
---@field public ATTACK_WHEN_SELECT string
---@field public LAST_SERVERTIME string
---@field public FIRST_LEARNING_MAGICSKILL string
---@field public CURRECT_PLAYER_TAG string
---@field public SKILL_CONTROL_TYPE string
---@field public IDENTIFICATION_TIMES string
---@field public CHAT_ROOM_NAME_SHOW string
---@field public MVP_WARNING_HINT string
---@field public CAMERA_SHAKE_ENABLE string
---@field public HIT_NUM_TYPE string
---@field public MERCENARY_SHOW_TYPE string
---@field public IS_SHOW_OUTLINE string
---@field public IS_3D_VIEW string
---@field public RECOVER_DEFAULT_VIEW_WHEN_PATHFIND string
---@field public LAST_ACCOUNT string
---@field public DEFAULT_CAM_DIS string
---@field public GLOBAL_SETING_GROUP string
---@field public SPECTATOR_SETTING string
---@field public FRAME_RATE string
---@field public soundVolumeData MoonClient.MPlayerSetting.SoundVolumeData
---@field public soundChatData MoonClient.MPlayerSetting.SoundChatData
---@field public _currentPlayerType number
---@field public _chatRoomNameShow boolean
---@field public _AssistMvpShow boolean
---@field public USE_DRAG_HP_PERCENT string
---@field public USE_DRAG_MP_PERCENT string
---@field public AUTO_BATTLE_HP_DRAGS string
---@field public AUTO_BATTLE_MP_DRAGS string
---@field public PLAYER_SETTING_GROUP string
---@field public TargetFrameRate number
---@field public PLAYER_ACCOUNT_GROUP string
---@field public LastAccount string
---@field public AutoCollectScope number
---@field public AllMapAutoCollect boolean
---@field public OpenScreenCaptureShare boolean
---@field public QuickInfoNum number
---@field public TargetTabType number
---@field public HitNumType number
---@field public IsCameraShakeEnable boolean
---@field public MercenaryShowType number
---@field public IsShowOutline boolean
---@field public Is3DViewMode boolean
---@field public RecoverViewWhenPathFinding boolean
---@field public ChatSystemIndex number
---@field public ChatQuickIndex number
---@field public ChatQuickLis System.Collections.Generic.List_System.UInt64
---@field public IfAttckWhenSelect boolean
---@field public LastDataTimeDay number
---@field public IdentificationTimes number
---@field public CurrentPlayerTag number
---@field public ChatRoomNameShow boolean
---@field public AssistMvpShow boolean
---@field public SkillCtrlType number
---@field public IsClassic boolean
---@field public UseDragHpPercent number
---@field public UseDragMpPercent number
---@field public AutoBattleHpDrags System.Collections.Generic.List_System.Int32
---@field public AutoBattleMpDrags System.Collections.Generic.List_System.Int32
---@field public LoginFailedTimes number
---@field public LastLoginFailedTime System.DateTime
---@field public AllowAgreement boolean

---@type MoonClient.MPlayerSetting
MoonClient.MPlayerSetting = { }
---@return MoonClient.MPlayerSetting
function MoonClient.MPlayerSetting.New() end
---@param targetFrameRate number
function MoonClient.MPlayerSetting:SetTargetFrameRateWithoutSaving(targetFrameRate) end
---@return number
---@param defaultValue number
function MoonClient.MPlayerSetting:GetLowFrameRateTipsNum(defaultValue) end
---@param value number
function MoonClient.MPlayerSetting:SetLowFrameRateTipsNum(value) end
function MoonClient.MPlayerSetting:DeleteLowFrameRateTipsNum() end
---@return number
---@param defaultValue number
function MoonClient.MPlayerSetting:GetQualityGrade(defaultValue) end
---@return boolean
function MoonClient.MPlayerSetting:HasQualityGrade() end
---@param value number
function MoonClient.MPlayerSetting:SetQualityGrade(value) end
function MoonClient.MPlayerSetting:DeleteQualityGrade() end
---@return number
---@param defaultValue number
function MoonClient.MPlayerSetting:GetHardwareGradeType(defaultValue) end
---@param value number
function MoonClient.MPlayerSetting:SetHardwareGradeType(value) end
function MoonClient.MPlayerSetting:DeleteHardwareGradeType() end
---@return number
---@param defaultValue number
function MoonClient.MPlayerSetting:GetQualityDisplayLevel(defaultValue) end
---@param value number
function MoonClient.MPlayerSetting:SetQualityDisplayLevel(value) end
---@return boolean
function MoonClient.MPlayerSetting:HasQualityDisplayLevel() end
function MoonClient.MPlayerSetting:DeleteQualityDisplayLevel() end
function MoonClient.MPlayerSetting:DeleteQuickTalkInfos() end
---@param index number
---@param infoStr string
function MoonClient.MPlayerSetting:StoreQuickTalkInfos(index, infoStr) end
---@return string
---@param index number
function MoonClient.MPlayerSetting:GetQuickTalkInfos(index) end
---@param dragId number
function MoonClient.MPlayerSetting:AddAutoBattleHpDrag(dragId) end
---@param dragId number
function MoonClient.MPlayerSetting:RemoveAutoBattleHpDrag(dragId) end
---@param dragId number
function MoonClient.MPlayerSetting:AddAutoBattleMpDrag(dragId) end
---@param dragId number
function MoonClient.MPlayerSetting:RemoveAutoBattleMpDrag(dragId) end
function MoonClient.MPlayerSetting:UpdateCamDefaultDisKey() end
---@return number
function MoonClient.MPlayerSetting:GetCamDefaultCachedDis() end
---@param dis number
function MoonClient.MPlayerSetting:SetCamDefaultCachedDis(dis) end
---@return boolean
function MoonClient.MPlayerSetting:Init() end
function MoonClient.MPlayerSetting:Uninit() end
---@param clearAccountData boolean
function MoonClient.MPlayerSetting:OnLogout(clearAccountData) end
function MoonClient.MPlayerSetting:LoadGloableSetting() end
---@param playerUID uint64
function MoonClient.MPlayerSetting:LoadPlayerSetting(playerUID) end
function MoonClient.MPlayerSetting:SetDefaultCommonAttack() end
return MoonClient.MPlayerSetting
