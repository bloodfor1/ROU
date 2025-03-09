---@class MoonClient.MCheckInCameraTrigger : UnityEngine.MonoBehaviour
---@field public PrefabLocation string
---@field public triggerId number
---@field public image MoonClient.MCsUICom

---@type MoonClient.MCheckInCameraTrigger
MoonClient.MCheckInCameraTrigger = { }
---@return MoonClient.MCheckInCameraTrigger
function MoonClient.MCheckInCameraTrigger.New() end
---@param distance number
---@param angleRange number
function MoonClient.MCheckInCameraTrigger:InitLimit(distance, angleRange) end
---@return boolean
function MoonClient.MCheckInCameraTrigger:FitLimit() end
return MoonClient.MCheckInCameraTrigger
