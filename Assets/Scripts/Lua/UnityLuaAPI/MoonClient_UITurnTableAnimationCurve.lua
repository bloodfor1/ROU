---@class MoonClient.UITurnTableAnimationCurve : UnityEngine.MonoBehaviour
---@field public zRotationCurve UnityEngine.AnimationCurve
---@field public finishHandler (fun():void)
---@field public dumpCurve boolean

---@type MoonClient.UITurnTableAnimationCurve
MoonClient.UITurnTableAnimationCurve = { }
---@return MoonClient.UITurnTableAnimationCurve
function MoonClient.UITurnTableAnimationCurve.New() end
---@param tbl table
function MoonClient.UITurnTableAnimationCurve:CreateAnimationCurve(tbl) end
function MoonClient.UITurnTableAnimationCurve:PlayForward() end
return MoonClient.UITurnTableAnimationCurve
