---@class MoonClient.MapEffectObj
---@field public effectId number
---@field public mnEffectId number
---@field public rawImg UnityEngine.UI.RawImage
---@field public mnRawImg UnityEngine.UI.RawImage
---@field public playTime number

---@type MoonClient.MapEffectObj
MoonClient.MapEffectObj = { }
---@return MoonClient.MapEffectObj
function MoonClient.MapEffectObj.New() end
function MoonClient.MapEffectObj:Init() end
return MoonClient.MapEffectObj
