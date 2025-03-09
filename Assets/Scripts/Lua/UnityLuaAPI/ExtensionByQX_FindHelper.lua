---@class ExtensionByQX.FindHelper

---@type ExtensionByQX.FindHelper
ExtensionByQX.FindHelper = { }
---@return UnityEngine.GameObject
---@param path string
function ExtensionByQX.FindHelper.FindGameObject(path) end
---@return UnityEngine.Transform
---@param root UnityEngine.Transform
---@param targetName string
function ExtensionByQX.FindHelper.FindChildrenTransformRecursion(root, targetName) end
---@return System.Collections.Generic.List_UnityEngine.Transform
---@param root UnityEngine.Transform
---@param targetName string
function ExtensionByQX.FindHelper.FindChildrenTransformsRecursion(root, targetName) end
---@return System.Collections.Generic.Stack_UnityEngine.Transform
---@param go UnityEngine.Transform
---@param endTransform UnityEngine.Transform
---@param isContainEnd boolean
function ExtensionByQX.FindHelper.GetAllParentNode(go, endTransform, isContainEnd) end
---@return string
---@param transform UnityEngine.Transform
---@param endTransform UnityEngine.Transform
---@param isContainEnd boolean
function ExtensionByQX.FindHelper.GetGameObjectPath(transform, endTransform, isContainEnd) end
---@return number
---@param transform UnityEngine.Transform
function ExtensionByQX.FindHelper.GetAllChildrenCount(transform) end
return ExtensionByQX.FindHelper
