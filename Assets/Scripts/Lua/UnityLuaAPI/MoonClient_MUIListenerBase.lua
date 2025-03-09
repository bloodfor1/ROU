---@class MoonClient.MUIListenerBase : UnityEngine.EventSystems.EventTrigger
---@field public longClickTime number
---@field public _dragThresholdExceeded boolean
---@field public _oldActionMap System.Collections.Generic.Dictionary_MoonClient.E_MOUSE_ACTION_TYPE_MoonClient.MUIListenerBase.UIEventDelegate
---@field public _actionMap System.Collections.Generic.Dictionary_MoonClient.E_MOUSE_ACTION_TYPE_MoonClient.MouseActionPack
---@field public onClick (fun(go:UnityEngine.GameObject, eventData:UnityEngine.EventSystems.PointerEventData):void)
---@field public onDoubleClick (fun(go:UnityEngine.GameObject, eventData:UnityEngine.EventSystems.PointerEventData):void)
---@field public onDown (fun(go:UnityEngine.GameObject, eventData:UnityEngine.EventSystems.PointerEventData):void)
---@field public onEnter (fun(go:UnityEngine.GameObject, eventData:UnityEngine.EventSystems.PointerEventData):void)
---@field public onExit (fun(go:UnityEngine.GameObject, eventData:UnityEngine.EventSystems.PointerEventData):void)
---@field public onUp (fun(go:UnityEngine.GameObject, eventData:UnityEngine.EventSystems.PointerEventData):void)
---@field public initDrag (fun(go:UnityEngine.GameObject, eventData:UnityEngine.EventSystems.PointerEventData):void)
---@field public beginDrag (fun(go:UnityEngine.GameObject, eventData:UnityEngine.EventSystems.PointerEventData):void)
---@field public onDrag (fun(go:UnityEngine.GameObject, eventData:UnityEngine.EventSystems.PointerEventData):void)
---@field public endDrag (fun(go:UnityEngine.GameObject, eventData:UnityEngine.EventSystems.PointerEventData):void)
---@field public onDrop (fun(go:UnityEngine.GameObject, eventData:UnityEngine.EventSystems.PointerEventData):void)
---@field public onScroll (fun(go:UnityEngine.GameObject, eventData:UnityEngine.EventSystems.PointerEventData):void)
---@field public onLongClick (fun(go:UnityEngine.GameObject, eventData:UnityEngine.EventSystems.PointerEventData):void)
---@field public onFocusOut (fun(go:UnityEngine.GameObject, eventData:UnityEngine.EventSystems.PointerEventData):void)
---@field public onFocusIn (fun(go:UnityEngine.GameObject, eventData:UnityEngine.EventSystems.PointerEventData):void)
---@field public onShortPress (fun(go:UnityEngine.GameObject, eventData:UnityEngine.EventSystems.PointerEventData):void)
---@field public onLongPress (fun(go:UnityEngine.GameObject, eventData:UnityEngine.EventSystems.PointerEventData):void)

---@type MoonClient.MUIListenerBase
MoonClient.MUIListenerBase = { }
---@return MoonClient.MUIListenerBase
function MoonClient.MUIListenerBase.New() end
---@param eventCallback (fun(arg1:table, arg2:UnityEngine.GameObject, arg3:UnityEngine.EventSystems.PointerEventData):void)
---@param luaSelf table
function MoonClient.MUIListenerBase:SetActionClick(eventCallback, luaSelf) end
---@param eventCallback (fun(arg1:table, arg2:UnityEngine.GameObject, arg3:UnityEngine.EventSystems.PointerEventData):void)
---@param luaSelf table
function MoonClient.MUIListenerBase:SetActionDoubleClick(eventCallback, luaSelf) end
---@param eventCallback (fun(arg1:table, arg2:UnityEngine.GameObject, arg3:UnityEngine.EventSystems.PointerEventData):void)
---@param luaSelf table
function MoonClient.MUIListenerBase:SetActionButtonDown(eventCallback, luaSelf) end
---@param eventCallback (fun(arg1:table, arg2:UnityEngine.GameObject, arg3:UnityEngine.EventSystems.PointerEventData):void)
---@param luaSelf table
function MoonClient.MUIListenerBase:SetActionMouseEnter(eventCallback, luaSelf) end
---@param eventCallback (fun(arg1:table, arg2:UnityEngine.GameObject, arg3:UnityEngine.EventSystems.PointerEventData):void)
---@param luaSelf table
function MoonClient.MUIListenerBase:SetActionButtonExit(eventCallback, luaSelf) end
---@param eventCallback (fun(arg1:table, arg2:UnityEngine.GameObject, arg3:UnityEngine.EventSystems.PointerEventData):void)
---@param luaSelf table
function MoonClient.MUIListenerBase:SetActionButtonUp(eventCallback, luaSelf) end
---@param eventCallback (fun(arg1:table, arg2:UnityEngine.GameObject, arg3:UnityEngine.EventSystems.PointerEventData):void)
---@param luaSelf table
function MoonClient.MUIListenerBase:SetActionInitDrag(eventCallback, luaSelf) end
---@param eventCallback (fun(arg1:table, arg2:UnityEngine.GameObject, arg3:UnityEngine.EventSystems.PointerEventData):void)
---@param luaSelf table
function MoonClient.MUIListenerBase:SetActionBeginDrag(eventCallback, luaSelf) end
---@param eventCallback (fun(arg1:table, arg2:UnityEngine.GameObject, arg3:UnityEngine.EventSystems.PointerEventData):void)
---@param luaSelf table
function MoonClient.MUIListenerBase:SetActionOnDrag(eventCallback, luaSelf) end
---@param eventCallback (fun(arg1:table, arg2:UnityEngine.GameObject, arg3:UnityEngine.EventSystems.PointerEventData):void)
---@param luaSelf table
function MoonClient.MUIListenerBase:SetActionEndDrag(eventCallback, luaSelf) end
---@param eventCallback (fun(arg1:table, arg2:UnityEngine.GameObject, arg3:UnityEngine.EventSystems.PointerEventData):void)
---@param luaSelf table
function MoonClient.MUIListenerBase:SetActionOnDrop(eventCallback, luaSelf) end
---@param eventCallback (fun(arg1:table, arg2:UnityEngine.GameObject, arg3:UnityEngine.EventSystems.PointerEventData):void)
---@param luaSelf table
function MoonClient.MUIListenerBase:SetActionOnScroll(eventCallback, luaSelf) end
---@param eventCallback (fun(arg1:table, arg2:UnityEngine.GameObject, arg3:UnityEngine.EventSystems.PointerEventData):void)
---@param luaSelf table
function MoonClient.MUIListenerBase:SetActionLongClick(eventCallback, luaSelf) end
---@param eventCallback (fun(arg1:table, arg2:UnityEngine.GameObject, arg3:UnityEngine.EventSystems.PointerEventData):void)
---@param luaSelf table
function MoonClient.MUIListenerBase:SetActionFocusOut(eventCallback, luaSelf) end
---@param eventCallback (fun(arg1:table, arg2:UnityEngine.GameObject, arg3:UnityEngine.EventSystems.PointerEventData):void)
---@param luaSelf table
function MoonClient.MUIListenerBase:SetActionFocusIn(eventCallback, luaSelf) end
---@param eventCallback (fun(arg1:table, arg2:UnityEngine.GameObject, arg3:UnityEngine.EventSystems.PointerEventData):void)
---@param luaSelf table
function MoonClient.MUIListenerBase:SetActionShortPress(eventCallback, luaSelf) end
---@param eventCallback (fun(arg1:table, arg2:UnityEngine.GameObject, arg3:UnityEngine.EventSystems.PointerEventData):void)
---@param luaSelf table
function MoonClient.MUIListenerBase:SetActionLongPress(eventCallback, luaSelf) end
---@param go UnityEngine.GameObject
function MoonClient.MUIListenerBase:SetPassThroughGo(go) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function MoonClient.MUIListenerBase:OnPointerClick(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function MoonClient.MUIListenerBase:OnPointerDown(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function MoonClient.MUIListenerBase:OnPointerUp(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function MoonClient.MUIListenerBase:OnPointerEnter(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function MoonClient.MUIListenerBase:OnPointerExit(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function MoonClient.MUIListenerBase:OnInitializePotentialDrag(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function MoonClient.MUIListenerBase:OnBeginDrag(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function MoonClient.MUIListenerBase:OnDrag(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function MoonClient.MUIListenerBase:OnEndDrag(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function MoonClient.MUIListenerBase:OnDrop(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function MoonClient.MUIListenerBase:OnScroll(eventData) end
---@param focus boolean
function MoonClient.MUIListenerBase:OnApplicationFocus(focus) end
---@param actionType number
---@param callBack (fun(go:UnityEngine.GameObject, eventData:UnityEngine.EventSystems.PointerEventData):void)
function MoonClient.MUIListenerBase:_setOldCb(actionType, callBack) end
---@return (fun(go:UnityEngine.GameObject, eventData:UnityEngine.EventSystems.PointerEventData):void)
---@param actionType number
function MoonClient.MUIListenerBase:_getOldCb(actionType) end
function MoonClient.MUIListenerBase:_clearMap() end
---@param t number
---@param eventCallback (fun(arg1:table, arg2:UnityEngine.GameObject, arg3:UnityEngine.EventSystems.PointerEventData):void)
---@param luaSelf table
function MoonClient.MUIListenerBase:_setDataByType(t, eventCallback, luaSelf) end
---@param actionType number
---@param go UnityEngine.GameObject
---@param eventData UnityEngine.EventSystems.PointerEventData
function MoonClient.MUIListenerBase:_invokeActionByType(actionType, go, eventData) end
---@return boolean
---@param actionType number
function MoonClient.MUIListenerBase:_hasActionByType(actionType) end
---@param actionType number
---@param go UnityEngine.GameObject
---@param eventData UnityEngine.EventSystems.PointerEventData
function MoonClient.MUIListenerBase:_invokeCbInMap(actionType, go, eventData) end
---@param actionType number
---@param go UnityEngine.GameObject
---@param eventData UnityEngine.EventSystems.PointerEventData
function MoonClient.MUIListenerBase:_invokeOriginalCb(actionType, go, eventData) end
function MoonClient.MUIListenerBase:Release() end
return MoonClient.MUIListenerBase
