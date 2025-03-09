---@class MoonClient.MPostEffectMgr : MoonCommonLib.MSingleton_MoonClient.MPostEffectMgr
---@field public PostType number
---@field public UberInstance MoonClient.MPostUber
---@field public ColorGradingInstance MoonClient.MPostColorGrading
---@field public BloomInstance MoonClient.MPostBloom
---@field public GrabRTForBgInstance MoonClient.MPostGrabRTForBg
---@field public OutlineInstance MoonClient.MOutlineController
---@field public GrabInstance MoonClient.MPostGrabRT
---@field public DepthMapShadowInstance MoonClient.MDepthMapShadow

---@type MoonClient.MPostEffectMgr
MoonClient.MPostEffectMgr = { }
---@return MoonClient.MPostEffectMgr
function MoonClient.MPostEffectMgr.New() end
---@param mainCam UnityEngine.Camera
---@param shadowCam UnityEngine.Camera
function MoonClient.MPostEffectMgr:SetCameras(mainCam, shadowCam) end
---@return boolean
---@param shaderLod number
function MoonClient.MPostEffectMgr.IsEditorObserver(shaderLod) end
---@return boolean
function MoonClient.MPostEffectMgr:Init() end
function MoonClient.MPostEffectMgr:Uninit() end
return MoonClient.MPostEffectMgr
