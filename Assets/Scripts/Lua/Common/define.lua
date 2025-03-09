--==============================--
--@Description: 全局声明
--@Date: 2018/8/22
--@Param: [args]
--@Return:
--==============================--
-- Unity Classes --
Object = UnityEngine.Object
GameObject = UnityEngine.GameObject
Application = UnityEngine.Application
RuntimePlatform = UnityEngine.RuntimePlatform
EventSystem = UnityEngine.EventSystems.EventSystem
Input = UnityEngine.Input
Touch = UnityEngine.Touch
Time = UnityEngine.Time
Screen = UnityEngine.Screen
PlayerPrefs = UnityEngine.PlayerPrefs
PointerEventData = UnityEngine.EventSystems.PointerEventData
RaycastResultList = System.Collections.Generic.List_UnityEngine_EventSystems_RaycastResult
GameObjectList = System.Collections.Generic.List_UnityEngine_GameObject
WWW = UnityEngine.WWW
TextureFormat = UnityEngine.TextureFormat
Physics = UnityEngine.Physics

-- System Classes --
Directory = System.IO.Directory
File = System.IO.File
DirectoryInfo = System.IO.DirectoryInfo
FileInfo = System.IO.FileInfo
Path = System.IO.Path
TimeSpan = System.TimeSpan

-- Moon Enums --
ENetErrCode = MoonClient.ENetErrCode
MStageEnum = MoonClient.EMStage
ENetLoginStep = MoonClient.ENetLoginStep
MEventType = MoonClient.MEventType
DirectorWrapMode = UnityEngine.Playables.DirectorWrapMode
ETargetTabType = MoonClient.MPlayerSetting.ETargetTabType
EHitNumType = MoonClient.MPlayerSetting.EHitNumType
EMercenaryShowType = MoonClient.MPlayerSetting.EMercenaryShowType
EVolumeSettingType = MoonClient.MPlayerSetting.EVolumeSettingType
ESkillControllerType = MoonClient.MPlayerSetting.ESkillControllerType
MSliderType = MoonClient.MCommonSliderType
ECombineMeshPart = MoonClient.ECombineMeshPart
ECombineMountPart = MoonClient.ECombineMountPart
HttpResult = MoonCommonLib.HttpTask.HttpResult
FitMode = UnityEngine.UI.ContentSizeFitter.FitMode
LeaveStateEnum = MoonClient.LeaveStateEnum
TagPoint = MoonCommonLib.TagPoint
DiceDirection = MoonClient.DiceDirection
EModelBone = MoonClient.EModelBone
ModelBoneName = MoonClient.ModelBoneName

BuffDisPlayTextType = MoonClient.BuffDisPlayTextType
SceneTriggerTimingType = PbLocal.SceneTriggerTimingType

-- Moon Classes --
MPreloadConfig = MoonClient.MPreloadConfig.singleton
MInput  = MoonClient.MInput.singleton
MLayer = MoonCommonLib.MLayer
MEntity = MoonClient.MEntity
MEntityMgr = MoonClient.MEntityMgr.singleton
MNpcMgr = MoonClient.MNpcMgr.singleton
MCutSceneMgr=MoonClient.MCutSceneMgr.singleton
MUIModelManagerEx = MoonClient.MUIModelManagerEx.singleton
MUICameraRTManager = MoonClient.MUICameraRTManager.singleton
MUICameraRTFuture = MoonClient.MUICameraRTFuture
MUICameraNpcRTFuture = MoonClient.MUICameraNpcRTFuture
MUIManager = MoonClient.MUIManager.singleton
MAttrMgr = MoonClient.MAttrMgr.singleton
MPlayerInfo = MoonClient.MPlayerInfo.singleton
MPlayerDungeonsInfo = MPlayerInfo.PlayerDungeonsInfo
MResLoader = MoonClient.MResLoader.singleton
MNetClient = MoonClient.MNetClient.singleton
MGame = MoonClient.MGame.singleton
MGameContext = MoonCommonLib.MGameContext.singleton
MStageMgr = MoonClient.MStageMgr.singleton
MSceneObjControllerCSharpMgr=MoonClient.MSceneObjController.singleton
MAudioMgr = MoonClient.MAudioMgr.singleton
MScene = MoonClient.MScene.singleton
MHeadPortrait = MoonClient.MHeadPortrait.singleton
MSkillTargetMgr = MoonClient.MSkillTargetMgr
MUITweenHelper = MoonClient.MUITweenHelper
MEventMgr = MoonClient.MEventMgr.singleton
MServerTimeMgr = MoonClient.MServerTimeMgr.singleton
NetWorkState = MoonClient.NetWorkState
StringEx = MoonCommonLib.StringEx
MPlayerSetting = MoonClient.MPlayerSetting.singleton
Localization = MoonClient.Localization.singleton
MScreenCapture = MoonClient.MScreenCapture
MUIEventListener = MoonClient.MUIEventListener
MCommonFunctions = MoonCommonLib.MCommonFunctions
PathEx = MoonCommonLib.PathEx
MoreDropdown = MoonClient.MoreDropdown
MoreDropdownItem = MoonClient.MoreDropdownItem
MapObjMgr = MoonClient.MapObjMgr.singleton
MapDataModel = MoonClient.MapDataModel.singleton
MMazeDungeonMgr = MoonClient.MMazeDungeonMgr.singleton
MPlatformConfigManager = MoonCommonLib.MPlatformConfigManager
MTheaterMgr = MoonClient.Theater.MTheaterMgr.singleton
--FxHelperUtil=MoonClient.FxHelperUtil
MFxMgr=MoonClient.MFxMgr.singleton
MSceneMgr = MoonClient.MSceneMgr.singleton
MTransferMgr = MoonClient.MTransferMgr.singleton
MUIBlackWordMgr= MoonClient.MUIBlackWordMgr.singleton
MUICutSceneJumpMgr= MoonClient.MUICutSceneJumpMgr.singleton
MSceneWallTriggerMgr = MoonClient.MSceneWallTriggerMgr.singleton
TriggerHudEnableEnum = MoonClient.MSceneWallTriggerMgr.TriggerHudEnableEnum
MapObjType = MoonClient.MapObjType
TakeVehicleType = MoonClient.TakeVehicleType
MGlobalConfig = MoonClient.MGlobalConfig.singleton
StateExclusionManager = MoonClient.StateExclusionManager.singleton
MExlusionStates = MoonClient.MExlusionStates
MVirtualTab = MoonClient.MVirtualTab.singleton
MProfiler = MoonCommonLib.MProfiler
NetworkReachability = UnityEngine.NetworkReachability
MSceneFirstInMgr = MoonClient.MSceneFirstInMgr.singleton
MAnimationMgr = MoonClient.MAnimationMgr.singleton
MNavigationMgr = MoonClient.MNavigationMgr.singleton
StringPoolManager = MoonClient.StringPoolManager.singleton
MResGoPool=MoonClient.MResGoPool.singleton
--DoTween
DOTween = DG.Tweening.DOTween
--CommandSystem
CommandBlockManager = MoonClient.CommandSystem.CommandBlockManager
CommandBlock = MoonClient.CommandSystem.CommandBlock
CommandBlockTriggerManager = MoonClient.CommandSystem.CommandBlockTriggerManager

MEnvironWeatherGM = MoonClient.MEnvironWeatherGM
UserDataManager = MoonClient.UserDataManager
HttpTask = MoonCommonLib.HttpTask
--ExtensionByQX
CoordinateHelper=ExtensionByQX.CoordinateHelper
--UGUI
LayoutRebuilder = UnityEngine.UI.LayoutRebuilder
RectTransformUtility = UnityEngine.RectTransformUtility
SystemInfo = UnityEngine.SystemInfo
CJson = require "cjson"

MLuaCommonHelper = MoonCommonLib.MLuaCommonHelper
MLuaClientHelper = MoonClient.MLuaClientHelper
MLuaUICom = MoonClient.MLuaUICom
MLuaUIPanel = MoonClient.MLuaUIPanel
MLuaUIGroup = MoonClient.MLuaUIGroup
MLuaUIListener = MoonClient.MLuaUIListener
UICDImgHelper = MoonClient.UICDImgHelper
UIAutoTest = MoonClient.UIAutoTest
MCookingMgr = MoonClient.MCookingMgr.singleton
MQualityGradeSetting = MoonClient.MQualityGradeSetting
MCameraHelper = MoonClient.MCameraHelper
MAnimator = MoonClient.MAnimator
MFixedEventArg = MoonClient.MCamFixAngleEventArgs
MListRectTransform = System.Collections.Generic.List_UnityEngine_RectTransform
MListPoolRectTransformList = MoonCommonLib.MListPool_UnityEngine_RectTransform
SlotShowInfo = MoonClient.SlotShowInfo
MEnvironMgr = MoonClient.MSceneEnvoriment.MEnvironMgr
MSpecialUserManager = MoonCommonLib.SpecialUserManager
MUserType = MoonCommonLib.UserType
MNumberFormat = MoonClient.MNumberFormat

-- SDKBridge
MAnnounce = MoonClient.MAnnounce
MCrashReport = MoonClient.MCrashReport
MLogin = MoonClient.MLogin
MMaple = MoonClient.MMaple
MPay = MoonClient.MPay
MStatistics = MoonClient.MStatistics
MTss = MoonClient.MTss
MVoice = MoonClient.MVoice
MDevice = MoonClient.MDevice
MPushNotification = MoonClient.MPushNotification
MShare = MoonClient.MShare
MTracker = MoonClient.MTracker
EDevicePermissionType = SDKLib.SDKInterface.EDevicePermissionType
EDevicePermissionResult = SDKLib.SDKInterface.EDevicePermissionResult

g_Globals = {
	IOS_REVIEW = 0, --苹果审核标识（0：非提审，1：提审）
	DEBUG_NETWORK = false,
	NETWORK_DELAYTIME = 2,
	HTTP_KEY = "de2d7b2864d3a6b88cb9318677c12f41",
	GETLOGIN_API = "{0}/login-server/ip?channel_code={1}&system={2}&sdk={3}&review={4}",
	IsKorea = (MGameContext.CurrentChannel == MoonCommonLib.MGameArea.Korea),
	IsChina = (MGameContext.CurrentChannel == MoonCommonLib.MGameArea.China),
	IsGooglePlay = (MPlatformConfigManager.GetLocal().bundleId == "com.gravity.ragnarokorigin.aos") or MGameContext.IsUnityEditor,
	IsAppStore = (MPlatformConfigManager.GetLocal().bundleId == "com.gravity.ragnarokorigin.ios"),
	IsOneStore = (MPlatformConfigManager.GetLocal().bundleId == "com.gravity.ragnarokorigin.one"),
	GMLoginSerCfg = {
		{ desc = "normal_player_login", ip = "", port = ""},
		{ desc = "formal", ip = "52.78.17.109", port = "25001"},
		{ desc = "relase", ip = "15.164.71.88", port = "25001"},
		{ desc = "pre", ip = "15.164.130.195", port = "25001"},
	},
}

LongZero = MLuaCommonHelper.Long(0)