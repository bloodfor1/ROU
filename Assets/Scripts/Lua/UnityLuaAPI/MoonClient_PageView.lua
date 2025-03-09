---@class MoonClient.PageView : UnityEngine.MonoBehaviour
---@field public updateOneItem (fun(item:UnityEngine.GameObject, index:number):void)
---@field public OnPageChanged (fun(obj:number):void)
---@field public smooting number
---@field public sensitivity number
---@field public pageItem UnityEngine.GameObject
---@field public Init boolean

---@type MoonClient.PageView
MoonClient.PageView = { }
---@return MoonClient.PageView
function MoonClient.PageView.New() end
---@param num number
---@param _updateItem (fun(item:UnityEngine.GameObject, index:number):void)
function MoonClient.PageView:InitContent(num, _updateItem) end
---@param objs System.Collections.Generic.List_UnityEngine.GameObject
---@param _updateItem (fun(item:UnityEngine.GameObject, index:number):void)
function MoonClient.PageView:InitWithTemplates(objs, _updateItem) end
---@param index number
function MoonClient.PageView:pageTo(index) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function MoonClient.PageView:OnBeginDrag(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function MoonClient.PageView:OnEndDrag(eventData) end
function MoonClient.PageView:Clear() end
function MoonClient.PageView:OnDestroy() end
return MoonClient.PageView
