---@class MoonClient.MSceneObject : MoonClient.MObject
---@field public DefaultLayer number
---@field public IsCutScene boolean
---@field public IsLoaded boolean
---@field public ScaleRate number
---@field public IsVisible boolean
---@field public Position UnityEngine.Vector3
---@field public Rotation UnityEngine.Quaternion
---@field public RunSpeed number
---@field public Model MoonClient.MModel
---@field public RenderMatType number

---@type MoonClient.MSceneObject
MoonClient.MSceneObject = { }
---@overload fun(): MoonClient.MSceneObject
---@return MoonClient.MSceneObject
---@param defaultComponentSize number
function MoonClient.MSceneObject.New(defaultComponentSize) end
function MoonClient.MSceneObject:Recycle() end
---@return boolean
---@param e MoonClient.MSceneObject
function MoonClient.MSceneObject.Valide(e) end
function MoonClient.MSceneObject:OnDestrory() end
---@param fDeltaT number
function MoonClient.MSceneObject:Update(fDeltaT) end
---@param tweener DG.Tweening.Tweener
function MoonClient.MSceneObject:AddTweener(tweener) end
---@param tweener DG.Tweening.Tweener
---@param isComplete boolean
function MoonClient.MSceneObject:RemoveTweener(tweener, isComplete) end
---@param go UnityEngine.GameObject
function MoonClient.MSceneObject:OnUObjLoaded(go) end
---@param model MoonClient.MModel
function MoonClient.MSceneObject:OnModelLoaded(model) end
---@param callback (fun(obj:UnityEngine.GameObject):void)
function MoonClient.MSceneObject:AddUObjLoadedCallback(callback) end
---@param callback (fun(obj:MoonClient.MModel):void)
function MoonClient.MSceneObject:AddModelLoadedCallback(callback) end
return MoonClient.MSceneObject
