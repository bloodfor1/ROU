---@class MoonClient.MCamera : MoonClient.MObject
---@field public MIN_DIS_TO_TERRIAN number
---@field public TargetOffset UnityEngine.Vector3
---@field public ShakeOffset UnityEngine.Vector3
---@field public LastLookPointY number
---@field public OriginOffset UnityEngine.Vector3
---@field public Dis number
---@field public RotX number
---@field public RotY number
---@field public RotZ number
---@field public DesRotX number
---@field public DesRotY number
---@field public DesRotZ number
---@field public DesDis number
---@field public MinCameraDis number
---@field public CanRotate boolean
---@field public Fov number
---@field public FollowPoint UnityEngine.Vector3
---@field public ShadowPoint UnityEngine.Vector3
---@field public CanUse3DView boolean
---@field public StableRotY number
---@field public UCam UnityEngine.Camera
---@field public TransCam UnityEngine.Transform
---@field public IsLoaded boolean
---@field public LayerCullComp MoonClient.MCameraLayerCullComponent
---@field public CameraCollider UnityEngine.Collider
---@field public CameraFadeComp MoonClient.MCameraFadeComponent
---@field public IsInited boolean
---@field public CameraConfig MoonClient.MCameraConfig
---@field public CameraState number
---@field public IsOpenSky boolean
---@field public CurrentModeComponent MoonClient.MCameraModeBaseComponent
---@field public CameraEnabled boolean
---@field public CameraForceEnabled boolean
---@field public EnablePhysicsRaycaster boolean
---@field public CullingMask number
---@field public Target MoonClient.MSceneObject
---@field public CustomOffset UnityEngine.Vector3
---@field public ActionComp MoonClient.MCameraActionComponent
---@field public PhotoComp MoonClient.MCameraPhotoComponent
---@field public VR360Comp MoonClient.MCamera360PhotoComponent
---@field public CountDownComp MoonClient.MCameraCountDownPhotoComponent
---@field public SelfPhotoComp MoonClient.MCameraSelfPhotoComponent
---@field public OffSetComp MoonClient.MCameraOffSetComponent
---@field public ChangeStateComp MoonClient.MCameraChangeState
---@field public AdaptiveComp MoonClient.MCameraAdaptiveComponent
---@field public RainDropComp MoonClient.MCameraRainDropComponent
---@field public CameraFovCtrolComp MoonClient.MCameraFovCtrlComponent
---@field public CameraCheckColliderComp MoonClient.MCameraCheckColliderComponent
---@field public CheckInViewportComp MoonClient.MCameraCheckInViewPortComponent

---@type MoonClient.MCamera
MoonClient.MCamera = { }
---@return MoonClient.MCamera
function MoonClient.MCamera.New() end
---@return boolean
---@param cam UnityEngine.Camera
---@param config MoonClient.MCameraConfig
function MoonClient.MCamera:InitCamera(cam, config) end
---@return number
---@param ctrlmode boolean
---@param recycleTime number
function MoonClient.MCamera:ApplyFovToken(ctrlmode, recycleTime) end
function MoonClient.MCamera:Uninit() end
function MoonClient.MCamera:Recycle() end
---@return number
function MoonClient.MCamera:GetMaxCameraRot() end
---@return number
function MoonClient.MCamera:GetMinCameraRot() end
return MoonClient.MCamera
