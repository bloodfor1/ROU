---@class Spine.Unity.SkeletonGraphic : UnityEngine.UI.MaskableGraphic
---@field public skeletonDataAsset Spine.Unity.SkeletonDataAsset
---@field public initialSkinName string
---@field public initialFlipX boolean
---@field public initialFlipY boolean
---@field public startingAnimation string
---@field public startingLoop boolean
---@field public timeScale number
---@field public freeze boolean
---@field public unscaledTime boolean
---@field public SkeletonDataAsset Spine.Unity.SkeletonDataAsset
---@field public OverrideTexture UnityEngine.Texture
---@field public mainTexture UnityEngine.Texture
---@field public Skeleton Spine.Skeleton
---@field public SkeletonData Spine.SkeletonData
---@field public IsValid boolean
---@field public AnimationState Spine.AnimationState
---@field public MeshGenerator Spine.Unity.MeshGenerator
---@field public AnimationName string
---@field public Loop boolean
---@field public TimeScale number

---@type Spine.Unity.SkeletonGraphic
Spine.Unity.SkeletonGraphic = { }
---@return Spine.Unity.SkeletonGraphic
function Spine.Unity.SkeletonGraphic.New() end
---@return Spine.Unity.SkeletonGraphic
---@param skeletonDataAsset Spine.Unity.SkeletonDataAsset
---@param parent UnityEngine.Transform
---@param material UnityEngine.Material
function Spine.Unity.SkeletonGraphic.NewSkeletonGraphicGameObject(skeletonDataAsset, parent, material) end
---@return Spine.Unity.SkeletonGraphic
---@param gameObject UnityEngine.GameObject
---@param skeletonDataAsset Spine.Unity.SkeletonDataAsset
---@param material UnityEngine.Material
function Spine.Unity.SkeletonGraphic.AddSkeletonGraphicComponent(gameObject, skeletonDataAsset, material) end
---@param update number
function Spine.Unity.SkeletonGraphic:Rebuild(update) end
---@overload fun(): void
---@param deltaTime number
function Spine.Unity.SkeletonGraphic:Update(deltaTime) end
function Spine.Unity.SkeletonGraphic:LateUpdate() end
---@return UnityEngine.Mesh
function Spine.Unity.SkeletonGraphic:GetLastMesh() end
---@param value (fun(animated:Spine.Unity.ISkeletonAnimation):void)
function Spine.Unity.SkeletonGraphic:add_UpdateLocal(value) end
---@param value (fun(animated:Spine.Unity.ISkeletonAnimation):void)
function Spine.Unity.SkeletonGraphic:remove_UpdateLocal(value) end
---@param value (fun(animated:Spine.Unity.ISkeletonAnimation):void)
function Spine.Unity.SkeletonGraphic:add_UpdateWorld(value) end
---@param value (fun(animated:Spine.Unity.ISkeletonAnimation):void)
function Spine.Unity.SkeletonGraphic:remove_UpdateWorld(value) end
---@param value (fun(animated:Spine.Unity.ISkeletonAnimation):void)
function Spine.Unity.SkeletonGraphic:add_UpdateComplete(value) end
---@param value (fun(animated:Spine.Unity.ISkeletonAnimation):void)
function Spine.Unity.SkeletonGraphic:remove_UpdateComplete(value) end
---@param value (fun(buffers:Spine.Unity.MeshGeneratorBuffers):void)
function Spine.Unity.SkeletonGraphic:add_OnPostProcessVertices(value) end
---@param value (fun(buffers:Spine.Unity.MeshGeneratorBuffers):void)
function Spine.Unity.SkeletonGraphic:remove_OnPostProcessVertices(value) end
function Spine.Unity.SkeletonGraphic:Clear() end
---@param overwrite boolean
function Spine.Unity.SkeletonGraphic:Initialize(overwrite) end
function Spine.Unity.SkeletonGraphic:UpdateMesh() end
return Spine.Unity.SkeletonGraphic
