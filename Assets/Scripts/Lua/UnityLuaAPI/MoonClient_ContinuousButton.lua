---@class MoonClient.ContinuousButton : UnityEngine.MonoBehaviour
---@field public OnButtonDown (fun(obj:UnityEngine.EventSystems.PointerEventData):void)
---@field public OnContinuousButton (fun():void)
---@field public OnButtonUp (fun(obj:UnityEngine.EventSystems.PointerEventData):void)
---@field public BeginInterval number
---@field public EndInterval number
---@field public TimeBeginToEnd number

---@type MoonClient.ContinuousButton
MoonClient.ContinuousButton = { }
---@return MoonClient.ContinuousButton
function MoonClient.ContinuousButton.New() end
function MoonClient.ContinuousButton:Reset() end
---@param eventData UnityEngine.EventSystems.PointerEventData
function MoonClient.ContinuousButton:OnPointerDown(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function MoonClient.ContinuousButton:OnPointerUp(eventData) end
return MoonClient.ContinuousButton
