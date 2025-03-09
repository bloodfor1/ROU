---@class MoonClient.MUIEventListener : UnityEngine.MonoBehaviour
---@field public onClick (fun(go:UnityEngine.GameObject, data:UnityEngine.EventSystems.BaseEventData):void)
---@field public onDown (fun(go:UnityEngine.GameObject, data:UnityEngine.EventSystems.BaseEventData):void)
---@field public onEnter (fun(go:UnityEngine.GameObject, data:UnityEngine.EventSystems.BaseEventData):void)
---@field public onExit (fun(go:UnityEngine.GameObject, data:UnityEngine.EventSystems.BaseEventData):void)
---@field public onUp (fun(go:UnityEngine.GameObject, data:UnityEngine.EventSystems.BaseEventData):void)
---@field public onSelect (fun(go:UnityEngine.GameObject, data:UnityEngine.EventSystems.BaseEventData):void)
---@field public onUpdateSelect (fun(go:UnityEngine.GameObject, data:UnityEngine.EventSystems.BaseEventData):void)
---@field public onDeSelect (fun(go:UnityEngine.GameObject, data:UnityEngine.EventSystems.BaseEventData):void)
---@field public onDrag (fun(go:UnityEngine.GameObject, data:UnityEngine.EventSystems.BaseEventData):void)
---@field public onDragEnd (fun(go:UnityEngine.GameObject, data:UnityEngine.EventSystems.BaseEventData):void)
---@field public onDrop (fun(go:UnityEngine.GameObject, data:UnityEngine.EventSystems.BaseEventData):void)
---@field public onScroll (fun(go:UnityEngine.GameObject, data:UnityEngine.EventSystems.BaseEventData):void)
---@field public onMove (fun(go:UnityEngine.GameObject, data:UnityEngine.EventSystems.BaseEventData):void)

---@type MoonClient.MUIEventListener
MoonClient.MUIEventListener = { }
---@return MoonClient.MUIEventListener
function MoonClient.MUIEventListener.New() end
---@param eventData UnityEngine.EventSystems.PointerEventData
function MoonClient.MUIEventListener:OnPointerClick(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function MoonClient.MUIEventListener:OnPointerDown(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function MoonClient.MUIEventListener:OnPointerEnter(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function MoonClient.MUIEventListener:OnPointerExit(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function MoonClient.MUIEventListener:OnPointerUp(eventData) end
---@param eventData UnityEngine.EventSystems.BaseEventData
function MoonClient.MUIEventListener:OnSelect(eventData) end
---@param eventData UnityEngine.EventSystems.BaseEventData
function MoonClient.MUIEventListener:OnUpdateSelected(eventData) end
---@param eventData UnityEngine.EventSystems.BaseEventData
function MoonClient.MUIEventListener:OnDeselect(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function MoonClient.MUIEventListener:OnDrag(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function MoonClient.MUIEventListener:OnEndDrag(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function MoonClient.MUIEventListener:OnDrop(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function MoonClient.MUIEventListener:OnScroll(eventData) end
---@param eventData UnityEngine.EventSystems.AxisEventData
function MoonClient.MUIEventListener:OnMove(eventData) end
---@return MoonClient.MUIEventListener
---@param go UnityEngine.GameObject
function MoonClient.MUIEventListener.Get(go) end
return MoonClient.MUIEventListener
