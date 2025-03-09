---@class MoonClient.MGameObject
---@field public LoadGoCallback (fun(obj:UnityEngine.GameObject):void)
---@field public ResetGoCallback (fun(obj:UnityEngine.GameObject):void)
---@field public IsValid boolean
---@field public IsLoaded boolean
---@field public UObj UnityEngine.GameObject
---@field public Trans UnityEngine.Transform
---@field public Location string
---@field public Forward UnityEngine.Vector3
---@field public IsActive boolean
---@field public Name string
---@field public Tag string
---@field public Layer number
---@field public Position UnityEngine.Vector3
---@field public LocalPosition UnityEngine.Vector3
---@field public Rotation UnityEngine.Quaternion
---@field public LocalRotation UnityEngine.Quaternion
---@field public Scale UnityEngine.Vector3
---@field public ParentUObj UnityEngine.GameObject

---@type MoonClient.MGameObject
MoonClient.MGameObject = { }
---@return MoonClient.MGameObject
function MoonClient.MGameObject.New() end
---@param isActive boolean
function MoonClient.MGameObject:SetActive(isActive) end
---@param obj UnityEngine.GameObject
function MoonClient.MGameObject:SetGameObject(obj) end
---@param layers System.Int32[]
function MoonClient.MGameObject:SetIgnoreLayers(layers) end
---@param location string
---@param usePool boolean
function MoonClient.MGameObject:Load(location, usePool) end
function MoonClient.MGameObject:Reset() end
function MoonClient.MGameObject:MarkPreUnloadAB() end
---@overload fun(parentObj:UnityEngine.GameObject): void
---@overload fun(parentObj:UnityEngine.GameObject, localPosition:UnityEngine.Vector3): void
---@overload fun(parentObj:UnityEngine.GameObject, localPosition:UnityEngine.Vector3, localRotation:UnityEngine.Quaternion): void
---@param parentObj UnityEngine.GameObject
---@param localPosition UnityEngine.Vector3
---@param localRotation UnityEngine.Quaternion
---@param localScale UnityEngine.Vector3
function MoonClient.MGameObject:SetParent(parentObj, localPosition, localRotation, localScale) end
function MoonClient.MGameObject:Get() end
function MoonClient.MGameObject:Release() end
function MoonClient.MGameObject:Destory() end
function MoonClient.MGameObject:Recycle() end
return MoonClient.MGameObject
