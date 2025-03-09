---@class MoonClient.Utility.MCreateCharGryo : UnityEngine.MonoBehaviour
---@field public target UnityEngine.GameObject
---@field public shakeCallback (fun(arg1:boolean, arg2:number):void)
---@field public AccelerationTrigger number

---@type MoonClient.Utility.MCreateCharGryo
MoonClient.Utility.MCreateCharGryo = { }
---@return MoonClient.Utility.MCreateCharGryo
function MoonClient.Utility.MCreateCharGryo.New() end
---@param maxRotX number
---@param maxRotY number
---@param shakeAction (fun(arg1:boolean, arg2:number):void)
function MoonClient.Utility.MCreateCharGryo:InitCameraInfo(maxRotX, maxRotY, shakeAction) end
---@param interval number
function MoonClient.Utility.MCreateCharGryo:SetCheckInterval(interval) end
return MoonClient.Utility.MCreateCharGryo
