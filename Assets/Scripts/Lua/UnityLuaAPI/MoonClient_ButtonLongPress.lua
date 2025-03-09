---@class MoonClient.ButtonLongPress : UnityEngine.EventSystems.UIBehaviour
---@field public duration number
---@field public repeatStep number
---@field public onClick (fun(go:UnityEngine.GameObject, data:UnityEngine.EventSystems.BaseEventData):void)
---@field public onLongClick (fun(go:UnityEngine.GameObject, data:UnityEngine.EventSystems.BaseEventData):void)

---@type MoonClient.ButtonLongPress
MoonClient.ButtonLongPress = { }
---@return MoonClient.ButtonLongPress
function MoonClient.ButtonLongPress.New() end
---@param eventData UnityEngine.EventSystems.PointerEventData
function MoonClient.ButtonLongPress:OnPointerDown(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function MoonClient.ButtonLongPress:OnPointerUp(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function MoonClient.ButtonLongPress:OnPointerExit(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function MoonClient.ButtonLongPress:OnPointerClick(eventData) end
function MoonClient.ButtonLongPress:Release() end
return MoonClient.ButtonLongPress
