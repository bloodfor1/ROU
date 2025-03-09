---@class Spine.Unity.SkeletonAnimation : Spine.Unity.SkeletonRenderer
---@field public state Spine.AnimationState
---@field public loop boolean
---@field public timeScale number
---@field public AnimationState Spine.AnimationState
---@field public AnimationName string

---@type Spine.Unity.SkeletonAnimation
Spine.Unity.SkeletonAnimation = { }
---@return Spine.Unity.SkeletonAnimation
function Spine.Unity.SkeletonAnimation.New() end
---@param value (fun(animated:Spine.Unity.ISkeletonAnimation):void)
function Spine.Unity.SkeletonAnimation:add_UpdateLocal(value) end
---@param value (fun(animated:Spine.Unity.ISkeletonAnimation):void)
function Spine.Unity.SkeletonAnimation:remove_UpdateLocal(value) end
---@param value (fun(animated:Spine.Unity.ISkeletonAnimation):void)
function Spine.Unity.SkeletonAnimation:add_UpdateWorld(value) end
---@param value (fun(animated:Spine.Unity.ISkeletonAnimation):void)
function Spine.Unity.SkeletonAnimation:remove_UpdateWorld(value) end
---@param value (fun(animated:Spine.Unity.ISkeletonAnimation):void)
function Spine.Unity.SkeletonAnimation:add_UpdateComplete(value) end
---@param value (fun(animated:Spine.Unity.ISkeletonAnimation):void)
function Spine.Unity.SkeletonAnimation:remove_UpdateComplete(value) end
---@return Spine.Unity.SkeletonAnimation
---@param gameObject UnityEngine.GameObject
---@param skeletonDataAsset Spine.Unity.SkeletonDataAsset
function Spine.Unity.SkeletonAnimation.AddToGameObject(gameObject, skeletonDataAsset) end
---@return Spine.Unity.SkeletonAnimation
---@param skeletonDataAsset Spine.Unity.SkeletonDataAsset
function Spine.Unity.SkeletonAnimation.NewSkeletonAnimationGameObject(skeletonDataAsset) end
function Spine.Unity.SkeletonAnimation:ClearState() end
---@param overwrite boolean
function Spine.Unity.SkeletonAnimation:Initialize(overwrite) end
---@param deltaTime number
function Spine.Unity.SkeletonAnimation:Update(deltaTime) end
return Spine.Unity.SkeletonAnimation
