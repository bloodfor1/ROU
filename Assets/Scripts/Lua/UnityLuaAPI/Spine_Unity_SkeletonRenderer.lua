---@class Spine.Unity.SkeletonRenderer : UnityEngine.MonoBehaviour
---@field public skeletonDataAsset Spine.Unity.SkeletonDataAsset
---@field public initialSkinName string
---@field public initialFlipX boolean
---@field public initialFlipY boolean
---@field public separatorSlots System.Collections.Generic.List_Spine.Slot
---@field public zSpacing number
---@field public useClipping boolean
---@field public immutableTriangles boolean
---@field public pmaVertexColors boolean
---@field public clearStateOnDisable boolean
---@field public tintBlack boolean
---@field public singleSubmesh boolean
---@field public addNormals boolean
---@field public calculateTangents boolean
---@field public maskInteraction number
---@field public maskMaterials Spine.Unity.SkeletonRenderer.SpriteMaskInteractionMaterials
---@field public STENCIL_COMP_PARAM_ID number
---@field public STENCIL_COMP_MASKINTERACTION_NONE number
---@field public STENCIL_COMP_MASKINTERACTION_VISIBLE_INSIDE number
---@field public STENCIL_COMP_MASKINTERACTION_VISIBLE_OUTSIDE number
---@field public disableRenderingOnOverride boolean
---@field public valid boolean
---@field public skeleton Spine.Skeleton
---@field public CustomMaterialOverride System.Collections.Generic.Dictionary_UnityEngine.Material_UnityEngine.Material
---@field public CustomSlotMaterials System.Collections.Generic.Dictionary_Spine.Slot_UnityEngine.Material
---@field public Skeleton Spine.Skeleton
---@field public SkeletonDataAsset Spine.Unity.SkeletonDataAsset

---@type Spine.Unity.SkeletonRenderer
Spine.Unity.SkeletonRenderer = { }
---@return Spine.Unity.SkeletonRenderer
function Spine.Unity.SkeletonRenderer.New() end
---@param value (fun(instruction:Spine.Unity.SkeletonRendererInstruction):void)
function Spine.Unity.SkeletonRenderer:add_GenerateMeshOverride(value) end
---@param value (fun(instruction:Spine.Unity.SkeletonRendererInstruction):void)
function Spine.Unity.SkeletonRenderer:remove_GenerateMeshOverride(value) end
---@param value (fun(buffers:Spine.Unity.MeshGeneratorBuffers):void)
function Spine.Unity.SkeletonRenderer:add_OnPostProcessVertices(value) end
---@param value (fun(buffers:Spine.Unity.MeshGeneratorBuffers):void)
function Spine.Unity.SkeletonRenderer:remove_OnPostProcessVertices(value) end
---@param value (fun(skeletonRenderer:Spine.Unity.SkeletonRenderer):void)
function Spine.Unity.SkeletonRenderer:add_OnRebuild(value) end
---@param value (fun(skeletonRenderer:Spine.Unity.SkeletonRenderer):void)
function Spine.Unity.SkeletonRenderer:remove_OnRebuild(value) end
---@param settings Spine.Unity.MeshGenerator.Settings
function Spine.Unity.SkeletonRenderer:SetMeshSettings(settings) end
function Spine.Unity.SkeletonRenderer:Awake() end
function Spine.Unity.SkeletonRenderer:ClearState() end
---@param minimumVertexCount number
function Spine.Unity.SkeletonRenderer:EnsureMeshGeneratorCapacity(minimumVertexCount) end
---@param overwrite boolean
function Spine.Unity.SkeletonRenderer:Initialize(overwrite) end
function Spine.Unity.SkeletonRenderer:LateUpdate() end
---@overload fun(startsWith:string, clearExistingSeparators:boolean, updateStringArray:boolean): void
---@param slotNamePredicate (fun(arg:string):boolean)
---@param clearExistingSeparators boolean
---@param updateStringArray boolean
function Spine.Unity.SkeletonRenderer:FindAndApplySeparatorSlots(slotNamePredicate, clearExistingSeparators, updateStringArray) end
function Spine.Unity.SkeletonRenderer:ReapplySeparatorSlotNames() end
return Spine.Unity.SkeletonRenderer
