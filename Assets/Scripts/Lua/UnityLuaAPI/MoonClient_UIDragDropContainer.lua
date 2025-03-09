---@class MoonClient.UIDragDropContainer : UnityEngine.MonoBehaviour
---@field public onDrop (fun(item:MoonClient.UIDragDropItem, customData:string, oldCustomData:string, dropSucc:boolean, data:UnityEngine.EventSystems.PointerEventData):void)
---@field public onLeave (fun(gameObject:UnityEngine.GameObject, customData:string, state:number, data:UnityEngine.EventSystems.PointerEventData):void)
---@field public dropCheckFunc string
---@field public reparentTarget UnityEngine.Transform
---@field public dropedItem UnityEngine.Transform
---@field public DropedItem MoonClient.UIDragDropItem

---@type MoonClient.UIDragDropContainer
MoonClient.UIDragDropContainer = { }
---@return MoonClient.UIDragDropContainer
function MoonClient.UIDragDropContainer.New() end
---@param data UnityEngine.EventSystems.PointerEventData
function MoonClient.UIDragDropContainer:OnDrop(data) end
---@param dragItem MoonClient.UIDragDropItem
---@param data UnityEngine.EventSystems.PointerEventData
function MoonClient.UIDragDropContainer:DropItem(dragItem, data) end
---@param data UnityEngine.EventSystems.PointerEventData
function MoonClient.UIDragDropContainer:OnPointerEnter(data) end
---@param data UnityEngine.EventSystems.PointerEventData
function MoonClient.UIDragDropContainer:OnPointerExit(data) end
---@param go UnityEngine.GameObject
---@param isClone boolean
---@param state number
---@param data UnityEngine.EventSystems.PointerEventData
function MoonClient.UIDragDropContainer:OnItemLeave(go, isClone, state, data) end
function MoonClient.UIDragDropContainer:RemoveDropedItem() end
function MoonClient.UIDragDropContainer:Release() end
return MoonClient.UIDragDropContainer
