---@class MoonClient.MPostGrabRTForBg : UnityEngine.MonoBehaviour
---@field public CaptureScreenRT UnityEngine.RenderTexture

---@type MoonClient.MPostGrabRTForBg
MoonClient.MPostGrabRTForBg = { }
---@return MoonClient.MPostGrabRTForBg
function MoonClient.MPostGrabRTForBg.New() end
---@param rawImg UnityEngine.UI.RawImage
function MoonClient.MPostGrabRTForBg:SetCapatureScreenForBg(rawImg) end
function MoonClient.MPostGrabRTForBg:StopCapatureScreenForBg() end
return MoonClient.MPostGrabRTForBg
