---@class MoonClient.MRingScrollRect : UnityEngine.MonoBehaviour
---@field public onInitItem (fun(item:UnityEngine.GameObject, index:number):void)
---@field public OnStartDrag (fun():void)
---@field public OnEndDrag (fun():void)
---@field public OnItemIndexChanged (fun():void)
---@field public CurIndex number
---@field public CurItemIndex number

---@type MoonClient.MRingScrollRect
MoonClient.MRingScrollRect = { }
---@return MoonClient.MRingScrollRect
function MoonClient.MRingScrollRect.New() end
---@param count number
function MoonClient.MRingScrollRect:SetCount(count) end
---@param times number
function MoonClient.MRingScrollRect:SetSensitive(times) end
---@param index number
---@param showTween boolean
---@param action (fun():void)
function MoonClient.MRingScrollRect:SelectIndex(index, showTween, action) end
function MoonClient.MRingScrollRect:TestComponent() end
return MoonClient.MRingScrollRect
