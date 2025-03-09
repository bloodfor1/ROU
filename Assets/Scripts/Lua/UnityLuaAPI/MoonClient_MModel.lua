---@class MoonClient.MModel
---@field public TAG_OUTLINE_RENDERS string
---@field public Name string
---@field public Tag string
---@field public Layer number
---@field public Position UnityEngine.Vector3
---@field public LocalPosition UnityEngine.Vector3
---@field public Rotation UnityEngine.Quaternion
---@field public LocalRotation UnityEngine.Quaternion
---@field public Forward UnityEngine.Vector3
---@field public Scale UnityEngine.Vector3
---@field public UObj UnityEngine.GameObject
---@field public IsMObjActive boolean
---@field public IsLoadCalled boolean
---@field public Trans UnityEngine.Transform
---@field public ParentUObj UnityEngine.GameObject
---@field public EnableCC boolean
---@field public Collider UnityEngine.Collider
---@field public ColCenter UnityEngine.Vector3
---@field public ColHeight number
---@field public ColRadius number
---@field public Visible boolean
---@field public UpdateWhenOffScreen boolean
---@field public IsHiding boolean
---@field public IsOffScreen boolean
---@field public TransWeaponR UnityEngine.Transform
---@field public TransWeaponL UnityEngine.Transform
---@field public TransWeaponFxL UnityEngine.Transform
---@field public TransWeaponFxR UnityEngine.Transform
---@field public TransHelmetPoint UnityEngine.Transform
---@field public TransBackPoint UnityEngine.Transform
---@field public TransTailPoint UnityEngine.Transform
---@field public TransMountPoint UnityEngine.Transform
---@field public TransCartPoint UnityEngine.Transform
---@field public TransFingerR UnityEngine.Transform
---@field public Ator MoonClient.MAnimator
---@field public IsUObjLoaded boolean
---@field public IsModelLoaded boolean
---@field public MainSkin UnityEngine.SkinnedMeshRenderer
---@field public ModelPrepareData MoonClient.MModelPrepareData
---@field public IsLockEquip boolean
---@field public EquipData MoonClient.MEquipData
---@field public CustomLightDir UnityEngine.Vector3
---@field public RenderType number
---@field public RenderMatType number
---@field public RendererDict System.Collections.Generic.Dictionary_System.Int32_MoonClient.ModelRenderMaterial
---@field public RenderAlpha number
---@field public OutlineType number
---@field public EnableShadowPlane boolean
---@field public FollowShadowPoint boolean
---@field public ShadowType number
---@field public DisplayType number
---@field public IsCombineMesh boolean
---@field public EmotionEyeId number
---@field public EmotionMouthId number

---@type MoonClient.MModel
MoonClient.MModel = { }
---@return MoonClient.MModel
function MoonClient.MModel.New() end
---@overload fun(parentObj:UnityEngine.GameObject): void
---@overload fun(parentObj:UnityEngine.GameObject, localPosition:UnityEngine.Vector3): void
---@overload fun(parentObj:UnityEngine.GameObject, localPosition:UnityEngine.Vector3, localRotation:UnityEngine.Quaternion): void
---@param parentObj UnityEngine.GameObject
---@param localPosition UnityEngine.Vector3
---@param localRotation UnityEngine.Quaternion
---@param localScale UnityEngine.Vector3
function MoonClient.MModel:SetParent(parentObj, localPosition, localRotation, localScale) end
---@param prefabLocation string
function MoonClient.MModel:Load(prefabLocation) end
---@param go UnityEngine.GameObject
function MoonClient.MModel:SetGameObject(go) end
---@param layer number
function MoonClient.MModel:SetModelFxLayer(layer) end
---@param eventType number
---@param handler MoonClient.MEventHandler
function MoonClient.MModel:AddEventListener(eventType, handler) end
---@param eventType number
---@param handler MoonClient.MEventHandler
function MoonClient.MModel:RemoveEventListener(eventType, handler) end
---@param eventType number
---@param args MoonClient.IEventArg
function MoonClient.MModel:FireEvent(eventType, args) end
---@param from MoonClient.MModel
function MoonClient.MModel:CopyModelInfo(from) end
---@overload fun(fxTableId:number, parentBone:number, fxData:MoonClient.MFxMgr.OriginData): number
---@overload fun(prefabPath:string, parentBone:number, fxData:MoonClient.MFxMgr.OriginData): number
---@overload fun(fxTableId:number, parentBoneName:string, fxData:MoonClient.MFxMgr.OriginData): number
---@overload fun(prefabPath:string, parentBoneName:string, fxData:MoonClient.MFxMgr.OriginData): number
---@overload fun(fxTableId:number, parentBone:number, fxData:MoonClient.MFxMgr.OriginData, fx:MoonClient.MFx): number
---@return number
---@param fxTableId number
---@param parentBoneName string
---@param fxData MoonClient.MFxMgr.OriginData
---@param fx MoonClient.MFx
function MoonClient.MModel:CreateFx(fxTableId, parentBoneName, fxData, fx) end
---@param target MoonClient.MModel
function MoonClient.MModel:ChangeFxRoot(target) end
---@return boolean
---@param fxId number
---@param parent UnityEngine.Transform
function MoonClient.MModel:TryGetFxParent(fxId, parent) end
---@param fxId number
function MoonClient.MModel:OnFxDestroyed(fxId) end
---@param data MoonSerializable.RimData
function MoonClient.MModel:SetRim(data) end
---@param color UnityEngine.Color
function MoonClient.MModel:SetSkillColor(color) end
---@param renderGO UnityEngine.GameObject
function MoonClient.MModel:AddNoCombineRender(renderGO) end
---@return MoonClient.ModelRenderMaterial
---@param render UnityEngine.Renderer
---@param rType number
---@param mType number
function MoonClient.MModel:AddRenderExt(render, rType, mType) end
---@param renderGO UnityEngine.GameObject
function MoonClient.MModel:RemoveRender(renderGO) end
---@param enable boolean
function MoonClient.MModel:SetHighLighting(enable) end
function MoonClient.MModel:ClearRenderList() end
---@param eyeId number
---@param mouthId number
---@param delayTime number
function MoonClient.MModel:ChangeEmotion(eyeId, mouthId, delayTime) end
function MoonClient.MModel:StopEmotion() end
---@param texturePath string
function MoonClient.MModel:ChangeTexture(texturePath) end
---@return number
---@param callback (fun(obj:UnityEngine.GameObject):void)
function MoonClient.MModel:AddLoadGoCallback(callback) end
---@return boolean
---@param token number
function MoonClient.MModel:RemoveLoadGoCallback(token) end
---@param callback (fun(obj:UnityEngine.GameObject):void)
function MoonClient.MModel:AddResetGoCallback(callback) end
---@param callback (fun(obj:MoonClient.MModel):void)
function MoonClient.MModel:AddLoadModelCallback(callback) end
---@overload fun(path:string): void
---@param id number
function MoonClient.MModel:PlayAudio(id) end
---@overload fun(path:string): MoonCommonLib.IMFModEventInstance
---@return MoonCommonLib.IMFModEventInstance
---@param id number
function MoonClient.MModel:PlayAudioInstance(id) end
---@param audioEvent MoonCommonLib.IMFModEventInstance
function MoonClient.MModel:StopAudioInstance(audioEvent) end
---@param data MoonClient.MModel.OriginData
function MoonClient.MModel:InitData(data) end
---@param equipData MoonClient.MEquipData
function MoonClient.MModel:RefreshEquipData(equipData) end
function MoonClient.MModel:Update() end
function MoonClient.MModel:Reset() end
function MoonClient.MModel:Release() end
function MoonClient.MModel:Get() end
function MoonClient.MModel:Destory() end
return MoonClient.MModel
