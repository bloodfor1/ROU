---@class MoonClient.UIDragDropItem : UnityEngine.MonoBehaviour
---@field public onBeginDrag (fun(go:UnityEngine.GameObject, eventData:UnityEngine.EventSystems.PointerEventData):void)
---@field public onDraging (fun(go:UnityEngine.GameObject, eventData:UnityEngine.EventSystems.PointerEventData):void)
---@field public onEndDrag (fun(go:UnityEngine.GameObject, eventData:UnityEngine.EventSystems.PointerEventData):void)
---@field public ignoreDrop boolean
---@field public restriction number
---@field public _cloneOnDrag boolean
---@field public pressAndHoldDelay number
---@field public interactable boolean
---@field public dragDropRoot UnityEngine.Transform
---@field public _customData string
---@field public customData string
---@field public selfContainer MoonClient.UIDragDropContainer
---@field public isClone boolean

---@type MoonClient.UIDragDropItem
MoonClient.UIDragDropItem = { }
---@return MoonClient.UIDragDropItem
function MoonClient.UIDragDropItem.New() end
---@param eventData UnityEngine.EventSystems.PointerEventData
function MoonClient.UIDragDropItem:OnBeginDrag(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function MoonClient.UIDragDropItem:OnDrag(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function MoonClient.UIDragDropItem:OnEndDrag(eventData) end
---@param container MoonClient.UIDragDropContainer
---@param isMoveItem boolean
function MoonClient.UIDragDropItem:OnItemDrop(container, isMoveItem) end
---@return UnityEngine.GameObject
function MoonClient.UIDragDropItem:GetMoveObject() end
---@param isClone boolean
---@param cloneOnDrag boolean
---@param customData string
function MoonClient.UIDragDropItem:InitItem(isClone, cloneOnDrag, customData) end
function MoonClient.UIDragDropItem:Release() end
return MoonClient.UIDragDropItem
