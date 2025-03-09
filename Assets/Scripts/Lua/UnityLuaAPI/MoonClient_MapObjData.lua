---@class MoonClient.MapObjData
---@field public rotation UnityEngine.Quaternion
---@field public txtPos UnityEngine.Vector2
---@field public spPos UnityEngine.Vector2
---@field public txt MoonClient.MDoublyList_MoonClient.HUDMesh.MTextData.ListNode
---@field public spName string
---@field public size UnityEngine.Vector2
---@field public scale UnityEngine.Vector3
---@field public clickEvent (fun(go:UnityEngine.GameObject, eventData:UnityEngine.EventSystems.PointerEventData):void)
---@field public active boolean
---@field public activeSmall boolean
---@field public activeBig boolean
---@field public removeOnCloseBigMap boolean
---@field public effectObj MoonClient.MapEffectObj
---@field public dynamicObj MoonClient.MapDynamicEffectObj

---@type MoonClient.MapObjData
MoonClient.MapObjData = { }
---@return MoonClient.MapObjData
function MoonClient.MapObjData.New() end
function MoonClient.MapObjData:Init() end
return MoonClient.MapObjData
