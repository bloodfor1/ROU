---@class MoonClient.MPostUber : UnityEngine.MonoBehaviour
---@field public redEyeIntensity number
---@field public redEyeSmoothness number
---@field public redEyeRoundness number
---@field public focalDistance number
---@field public nearBlurScale number
---@field public farBlurScale number
---@field public downSample number
---@field public samplerScale number
---@field public Focus number
---@field public BackIntensity number
---@field public ForwarIntensity number
---@field public FocusPos UnityEngine.Vector3
---@field public FocusMaxLen number
---@field public IsFocusPos boolean
---@field public IsPointDepth boolean
---@field public NearLen number
---@field public NearIntensity number
---@field public DynamicColor UnityEngine.Color
---@field public DynamicGradientIntense number
---@field public DynamicCircle UnityEngine.Vector3
---@field public Deprecated boolean
---@field public Cam UnityEngine.Camera
---@field public UberRT UnityEngine.RenderTexture
---@field public CurHeatDistort number
---@field public CamPixel UnityEngine.Vector2Int
---@field public UberMat UnityEngine.Material
---@field public fullscreenTriangle UnityEngine.Mesh

---@type MoonClient.MPostUber
MoonClient.MPostUber = { }
---@return MoonClient.MPostUber
function MoonClient.MPostUber.New() end
---@param focus number
---@param backIntensity number
---@param forwarIntensity number
---@param isFocusPos boolean
---@param focusPos UnityEngine.Vector3
---@param focusMaxLen number
---@param nearLen number
---@param nearIntensity number
function MoonClient.MPostUber:SetPointDofParams(focus, backIntensity, forwarIntensity, isFocusPos, focusPos, focusMaxLen, nearLen, nearIntensity) end
---@param enablekeywords System.String[]
function MoonClient.MPostUber:EnableUberFeature(enablekeywords) end
---@param disablekeywords System.String[]
function MoonClient.MPostUber:DisableUberFeature(disablekeywords) end
---@param renderers System.Collections.Generic.List_UnityEngine.Renderer
function MoonClient.MPostUber:DOFIn(renderers) end
function MoonClient.MPostUber:DOFOut() end
---@param renderers System.Collections.Generic.List_UnityEngine.Renderer
function MoonClient.MPostUber:AddFocusRenderer(renderers) end
function MoonClient.MPostUber:ReleaseFocusBuffer() end
---@param strength number
function MoonClient.MPostUber:Desaturate(strength) end
---@param exp number
function MoonClient.MPostUber:SetExposure(exp) end
---@param time number
---@param fromWhite boolean
function MoonClient.MPostUber:FadeIn(time, fromWhite) end
---@param time number
---@param toWhite boolean
function MoonClient.MPostUber:FadeOut(time, toWhite) end
function MoonClient.MPostUber:StartRedEye() end
---@param contrastThreshold number
---@param relativeThreshold number
---@param subpixelBlending number
function MoonClient.MPostUber:SetFXAA(contrastThreshold, relativeThreshold, subpixelBlending) end
function MoonClient.MPostUber:DisableFXAA() end
---@overload fun(intensity:number): void
---@overload fun(opacity:number, mask:UnityEngine.Texture, rounded:number): void
---@param intensity number
---@param color UnityEngine.Color
---@param smoothness number
---@param roundness number
---@param round boolean
---@param center UnityEngine.Vector2
function MoonClient.MPostUber:SetVignette(intensity, color, smoothness, roundness, round, center) end
---@param duration number
---@param strength number
---@param heatTex UnityEngine.Texture
---@param frequency number
---@param force number
---@param tiling number
function MoonClient.MPostUber:HeatDistort(duration, strength, heatTex, frequency, force, tiling) end
---@param strength number
function MoonClient.MPostUber:SetVision(strength) end
---@param strength number
---@param mask UnityEngine.Texture
---@param tiling number
function MoonClient.MPostUber:RainDrop(strength, mask, tiling) end
---@param strength number
---@param density number
---@param frequency number
---@param fade number
---@param roundness number
---@param cx number
---@param cy number
function MoonClient.MPostUber:WaveDistrot(strength, density, frequency, fade, roundness, cx, cy) end
---@param strength number
---@param distance number
---@param cx number
---@param cy number
function MoonClient.MPostUber:RadialBlur(strength, distance, cx, cy) end
---@param focalDistance number
---@param samplerScale number
---@param nearBlurScale number
---@param farBlurScale number
function MoonClient.MPostUber:ApplyDof(focalDistance, samplerScale, nearBlurScale, farBlurScale) end
function MoonClient.MPostUber:ApplyDynamicMask() end
return MoonClient.MPostUber
