---@class MoonClient.MRaycastTouchUtils

---@type MoonClient.MRaycastTouchUtils
MoonClient.MRaycastTouchUtils = { }
---@return MoonClient.MRaycastTouchUtils
function MoonClient.MRaycastTouchUtils.New() end
---@return boolean
---@param gameObject UnityEngine.GameObject
---@param isTouchPhase boolean
---@param touchPhase number
function MoonClient.MRaycastTouchUtils.IsNoTouched(gameObject, isTouchPhase, touchPhase) end
---@return boolean
---@param gameObject UnityEngine.GameObject
---@param isTouchPhase boolean
---@param touchPhase number
function MoonClient.MRaycastTouchUtils.IsNoTouchedForLua(gameObject, isTouchPhase, touchPhase) end
return MoonClient.MRaycastTouchUtils
