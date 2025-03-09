---@class MoonClient.ScrollRectWithCallback : UnityEngine.UI.ScrollRect
---@field public OnEndDragCallback (fun(obj:MoonClient.ScrollRectWithCallback):void)
---@field public OnBeginDragCallback (fun(obj:MoonClient.ScrollRectWithCallback):void)
---@field public OnDragCallback (fun(obj:MoonClient.ScrollRectWithCallback):void)

---@type MoonClient.ScrollRectWithCallback
MoonClient.ScrollRectWithCallback = { }
---@return MoonClient.ScrollRectWithCallback
function MoonClient.ScrollRectWithCallback.New() end
---@param eventData UnityEngine.EventSystems.PointerEventData
function MoonClient.ScrollRectWithCallback:OnEndDrag(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function MoonClient.ScrollRectWithCallback:OnBeginDrag(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function MoonClient.ScrollRectWithCallback:OnDrag(eventData) end
return MoonClient.ScrollRectWithCallback
