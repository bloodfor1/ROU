---@class MoonClient.MAnimator.MAnimInfo
---@field public StateKey string
---@field public Clip UnityEngine.AnimationClip
---@field public ClipPath string
---@field public Length number
---@field public IsLooping boolean
---@field public IsClipReady boolean
---@field public NormalizedTime number

---@type MoonClient.MAnimator.MAnimInfo
MoonClient.MAnimator.MAnimInfo = { }
---@return MoonClient.MAnimator.MAnimInfo
function MoonClient.MAnimator.MAnimInfo.New() end
function MoonClient.MAnimator.MAnimInfo:Destory() end
function MoonClient.MAnimator.MAnimInfo:Get() end
function MoonClient.MAnimator.MAnimInfo:Release() end
return MoonClient.MAnimator.MAnimInfo
