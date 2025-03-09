---@class MoonClient.MCutSceneMgr : MoonCommonLib.MSingleton_MoonClient.MCutSceneMgr
---@field public DataFileRootName string
---@field public Version number
---@field public ShadowPoint UnityEngine.Vector3
---@field public IsShadowShotRuning boolean
---@field public AllowPlay boolean
---@field public AllowStop boolean
---@field public DesignatedFadeTime System.Nullable_System.Single
---@field public DesignatedExitTime System.Nullable_System.Single
---@field public Is2D boolean
---@field public FilePath string
---@field public PlayType number
---@field public NeedLoadImageRoot boolean
---@field public CanShare boolean
---@field public VideoLocation string
---@field public InBlackCurtain boolean
---@field public IsPlaying boolean
---@field public IsPreparing boolean
---@field public PlayTime number
---@field public IsReady boolean

---@type MoonClient.MCutSceneMgr
MoonClient.MCutSceneMgr = { }
---@return MoonClient.MCutSceneMgr
function MoonClient.MCutSceneMgr.New() end
---@return boolean
function MoonClient.MCutSceneMgr:Init() end
---@param fDeltaT number
function MoonClient.MCutSceneMgr:Update(fDeltaT) end
---@param fDeltaT number
function MoonClient.MCutSceneMgr:LateUpdate(fDeltaT) end
function MoonClient.MCutSceneMgr:AfterVideoPlayerFinish() end
function MoonClient.MCutSceneMgr:AfterBlackCurtainFinish() end
function MoonClient.MCutSceneMgr:MarkPlay() end
---@param path string
---@param mode number
---@param endCallback (fun():void)
---@param startCallback (fun():void)
function MoonClient.MCutSceneMgr:Play(path, mode, endCallback, startCallback) end
---@param id number
---@param mode number
---@param endCallback (fun():void)
---@param startCallback (fun():void)
function MoonClient.MCutSceneMgr:PlayWithTrans(id, mode, endCallback, startCallback) end
---@param id number
---@param mode number
---@param endCallback (fun():void)
---@param startCallback (fun():void)
function MoonClient.MCutSceneMgr:PlayImmById(id, mode, endCallback, startCallback) end
---@param path string
---@param mode number
---@param endCallback (fun():void)
---@param startCallback (fun():void)
function MoonClient.MCutSceneMgr:PlayImm(path, mode, endCallback, startCallback) end
---@param path string
---@param endCallback (fun():void)
---@param startCallback (fun():void)
function MoonClient.MCutSceneMgr:PlayImmJump(path, endCallback, startCallback) end
---@return MoonClient.MEntity
---@param index number
function MoonClient.MCutSceneMgr:GetEntity(index) end
function MoonClient.MCutSceneMgr:Jump() end
---@param isNext boolean
function MoonClient.MCutSceneMgr:Clear(isNext) end
function MoonClient.MCutSceneMgr:Pause() end
function MoonClient.MCutSceneMgr:Resume() end
function MoonClient.MCutSceneMgr:updateBindModelParent() end
function MoonClient.MCutSceneMgr:OnVideoPrepareComplete() end
---@param sceneId number
function MoonClient.MCutSceneMgr:UnLimitCutScene(sceneId) end
function MoonClient.MCutSceneMgr:UnLimitClearState() end
---@return number
---@param fxPath string
function MoonClient.MCutSceneMgr:GetFxIfPreload(fxPath) end
---@return boolean
---@param targetSceneId number
---@param fadeTime number
function MoonClient.MCutSceneMgr:PreloadCutSceneIfNecessary(targetSceneId, fadeTime) end
---@param d Ro.Timeline.MTimelinePostUberEffectData
function MoonClient.MCutSceneMgr.RevertUberShotRef(d) end
---@param d Ro.Timeline.MTimelinePostUberEffectData
function MoonClient.MCutSceneMgr.AddPostUberShotRef(d) end
---@param d Ro.Timeline.MTimelinePostUberEffectData
function MoonClient.MCutSceneMgr.RemovePostUberShotRef(d) end
function MoonClient.MCutSceneMgr:clearPostUberShotRef() end
return MoonClient.MCutSceneMgr
