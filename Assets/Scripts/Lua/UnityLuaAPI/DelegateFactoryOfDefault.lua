---@class DelegateFactoryOfDefault
---@field public dict System.Collections.Generic.Dictionary_System.Type_DelegateFactoryOfDefault.DelegateCreate

---@type DelegateFactoryOfDefault
DelegateFactoryOfDefault = { }
---@return DelegateFactoryOfDefault
function DelegateFactoryOfDefault.New() end
function DelegateFactoryOfDefault.Init() end
function DelegateFactoryOfDefault.Register() end
---@overload fun(t:string, func:(fun():void)): System.Delegate
---@return System.Delegate
---@param t string
---@param func (fun():void)
---@param self table
function DelegateFactoryOfDefault.CreateDelegate(t, func, self) end
---@overload fun(obj:System.Delegate, func:(fun():void)): System.Delegate
---@return System.Delegate
---@param obj System.Delegate
---@param dg System.Delegate
function DelegateFactoryOfDefault.RemoveDelegate(obj, dg) end
---@return (fun():void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfDefault:System_Action(func, self, flag) end
---@return (fun():void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfDefault:UnityEngine_Events_UnityAction(func, self, flag) end
---@return (fun(obj:number):boolean)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfDefault:System_Predicate_int(func, self, flag) end
---@return (fun(obj:number):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfDefault:System_Action_int(func, self, flag) end
---@return (fun(x:number, y:number):number)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfDefault:System_Comparison_int(func, self, flag) end
---@return (fun(arg:number):number)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfDefault:System_Func_int_int(func, self, flag) end
---@return (fun(obj:UnityEngine.Object, cbObj:System.Object, taskId:number):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfDefault:MoonCommonLib_LoadCallBack(func, self, flag) end
---@return (fun(mat:UnityEngine.Material, sprites:UnityEngine.Sprite[], cbObj:System.Object):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfDefault:MoonCommonLib_LoadSpritesCallBack(func, self, flag) end
---@return (fun(obj:(fun():void)):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfDefault:System_Action_System_Action(func, self, flag) end
---@return (fun(text:string, charIndex:number, addedChar:number):number)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfDefault:TMPro_TMP_InputField_OnValidateInput(func, self, flag) end
---@return (fun():void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfDefault:DG_Tweening_TweenCallback(func, self, flag) end
---@return (fun(animated:Spine.Unity.ISkeletonAnimation):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfDefault:Spine_Unity_UpdateBonesDelegate(func, self, flag) end
---@return (fun(instruction:Spine.Unity.SkeletonRendererInstruction):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfDefault:Spine_Unity_SkeletonRenderer_InstructionDelegate(func, self, flag) end
---@return (fun(buffers:Spine.Unity.MeshGeneratorBuffers):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfDefault:Spine_Unity_MeshGeneratorDelegate(func, self, flag) end
---@return (fun(skeletonRenderer:Spine.Unity.SkeletonRenderer):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfDefault:Spine_Unity_SkeletonRenderer_SkeletonRendererDelegate(func, self, flag) end
---@return (fun(arg:string):boolean)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfDefault:System_Func_string_bool(func, self, flag) end
---@return (fun(extractedFrame:UnityEngine.Texture2D):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfDefault:MoonCommonLib_ProcessExtractedFrame(func, self, flag) end
return DelegateFactoryOfDefault
