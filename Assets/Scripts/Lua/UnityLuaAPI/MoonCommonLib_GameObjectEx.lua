---@class MoonCommonLib.GameObjectEx

---@type MoonCommonLib.GameObjectEx
MoonCommonLib.GameObjectEx = { }
---@return MoonCommonLib.GameObjectCallBack
function MoonCommonLib.GameObjectEx:GetCallback() end
---@overload fun(): void
function MoonCommonLib.GameObjectEx:ResetTransform() end
---@return UnityEngine.Vector3
---@param pos UnityEngine.Vector3
---@param euler UnityEngine.Vector3
function MoonCommonLib.GameObjectEx:NewRotateAround(pos, euler) end
---@return UnityEngine.GameObject
---@param name string
---@param recursion boolean
function MoonCommonLib.GameObjectEx:FindObjectInChild(name, recursion) end
return MoonCommonLib.GameObjectEx
