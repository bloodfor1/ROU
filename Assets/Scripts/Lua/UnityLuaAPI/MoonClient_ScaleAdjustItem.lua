---@class MoonClient.ScaleAdjustItem : UnityEngine.MonoBehaviour
---@field public Parent UnityEngine.GameObject
---@field public maxScale number
---@field public minScale number
---@field public onChange (fun():void)
---@field public IsDraging boolean

---@type MoonClient.ScaleAdjustItem
MoonClient.ScaleAdjustItem = { }
---@return MoonClient.ScaleAdjustItem
function MoonClient.ScaleAdjustItem.New() end
---@param eventData UnityEngine.EventSystems.PointerEventData
function MoonClient.ScaleAdjustItem:OnBeginDrag(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function MoonClient.ScaleAdjustItem:OnDrag(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function MoonClient.ScaleAdjustItem:OnEndDrag(eventData) end
return MoonClient.ScaleAdjustItem
