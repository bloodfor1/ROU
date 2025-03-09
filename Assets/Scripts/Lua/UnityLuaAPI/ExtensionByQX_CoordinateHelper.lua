---@class ExtensionByQX.CoordinateHelper

---@type ExtensionByQX.CoordinateHelper
ExtensionByQX.CoordinateHelper = { }
---@return UnityEngine.Vector3
---@param viewportPosition UnityEngine.Vector3
---@param targetCamera UnityEngine.Camera
---@param targetTransform UnityEngine.Transform
function ExtensionByQX.CoordinateHelper.ViewportToLocalPosition(viewportPosition, targetCamera, targetTransform) end
---@overload fun(worldPosition:UnityEngine.Vector3, targetTransform:UnityEngine.Transform): UnityEngine.Vector3
---@return UnityEngine.Vector3
---@param originCamera UnityEngine.Camera
---@param targetCamera UnityEngine.Camera
---@param originWorldPosition UnityEngine.Vector3
---@param targetTransform UnityEngine.Transform
function ExtensionByQX.CoordinateHelper.WorldPositionToLocalPosition(originCamera, targetCamera, originWorldPosition, targetTransform) end
---@return UnityEngine.Vector3
---@param screenPoint UnityEngine.Vector3
---@param targetCamera UnityEngine.Camera
---@param targetTransform UnityEngine.Transform
function ExtensionByQX.CoordinateHelper.ScreenPointToLocalPosition(screenPoint, targetCamera, targetTransform) end
return ExtensionByQX.CoordinateHelper
