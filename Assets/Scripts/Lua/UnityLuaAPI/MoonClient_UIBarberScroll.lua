---@class MoonClient.UIBarberScroll : UnityEngine.MonoBehaviour
---@field public OnValueChanged (fun(obj:number):void)
---@field public _desX number
---@field public _curIdx number
---@field public CurrentIndex number

---@type MoonClient.UIBarberScroll
MoonClient.UIBarberScroll = { }
---@return MoonClient.UIBarberScroll
function MoonClient.UIBarberScroll.New() end
---@param idx number
function MoonClient.UIBarberScroll:TweenToIndex(idx) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function MoonClient.UIBarberScroll:OnBeginDrag(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function MoonClient.UIBarberScroll:OnEndDrag(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function MoonClient.UIBarberScroll:OnDrag(eventData) end
return MoonClient.UIBarberScroll
