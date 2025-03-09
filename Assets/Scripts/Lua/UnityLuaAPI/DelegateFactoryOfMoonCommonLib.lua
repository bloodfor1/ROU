---@class DelegateFactoryOfMoonCommonLib
---@field public dict System.Collections.Generic.Dictionary_System.Type_DelegateFactoryOfMoonCommonLib.DelegateCreate

---@type DelegateFactoryOfMoonCommonLib
DelegateFactoryOfMoonCommonLib = { }
---@return DelegateFactoryOfMoonCommonLib
function DelegateFactoryOfMoonCommonLib.New() end
function DelegateFactoryOfMoonCommonLib.Init() end
function DelegateFactoryOfMoonCommonLib.Register() end
---@overload fun(t:string, func:(fun():void)): System.Delegate
---@return System.Delegate
---@param t string
---@param func (fun():void)
---@param self table
function DelegateFactoryOfMoonCommonLib.CreateDelegate(t, func, self) end
---@overload fun(obj:System.Delegate, func:(fun():void)): System.Delegate
---@return System.Delegate
---@param obj System.Delegate
---@param dg System.Delegate
function DelegateFactoryOfMoonCommonLib.RemoveDelegate(obj, dg) end
---@return (fun():void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonCommonLib:System_Action(func, self, flag) end
---@return (fun():void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonCommonLib:UnityEngine_Events_UnityAction(func, self, flag) end
---@return (fun(obj:number):boolean)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonCommonLib:System_Predicate_int(func, self, flag) end
---@return (fun(obj:number):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonCommonLib:System_Action_int(func, self, flag) end
---@return (fun(x:number, y:number):number)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonCommonLib:System_Comparison_int(func, self, flag) end
---@return (fun(arg:number):number)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonCommonLib:System_Func_int_int(func, self, flag) end
---@return (fun(obj:(fun():void)):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonCommonLib:System_Action_System_Action(func, self, flag) end
---@return (fun():string)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonCommonLib:System_Func_string(func, self, flag) end
---@return (fun():number)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonCommonLib:DG_Tweening_Core_DOGetter_float(func, self, flag) end
---@return (fun(pNewValue:number):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonCommonLib:DG_Tweening_Core_DOSetter_float(func, self, flag) end
---@return (fun():number)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonCommonLib:DG_Tweening_Core_DOGetter_double(func, self, flag) end
---@return (fun(pNewValue:number):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonCommonLib:DG_Tweening_Core_DOSetter_double(func, self, flag) end
---@return (fun():number)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonCommonLib:DG_Tweening_Core_DOGetter_int(func, self, flag) end
---@return (fun(pNewValue:number):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonCommonLib:DG_Tweening_Core_DOSetter_int(func, self, flag) end
---@return (fun():number)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonCommonLib:DG_Tweening_Core_DOGetter_uint(func, self, flag) end
---@return (fun(pNewValue:number):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonCommonLib:DG_Tweening_Core_DOSetter_uint(func, self, flag) end
---@return (fun():int64)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonCommonLib:DG_Tweening_Core_DOGetter_long(func, self, flag) end
---@return (fun(pNewValue:int64):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonCommonLib:DG_Tweening_Core_DOSetter_long(func, self, flag) end
---@return (fun():uint64)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonCommonLib:DG_Tweening_Core_DOGetter_ulong(func, self, flag) end
---@return (fun(pNewValue:uint64):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonCommonLib:DG_Tweening_Core_DOSetter_ulong(func, self, flag) end
---@return (fun():string)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonCommonLib:DG_Tweening_Core_DOGetter_string(func, self, flag) end
---@return (fun(pNewValue:string):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonCommonLib:DG_Tweening_Core_DOSetter_string(func, self, flag) end
---@return (fun():UnityEngine.Vector2)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonCommonLib:DG_Tweening_Core_DOGetter_UnityEngine_Vector2(func, self, flag) end
---@return (fun(pNewValue:UnityEngine.Vector2):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonCommonLib:DG_Tweening_Core_DOSetter_UnityEngine_Vector2(func, self, flag) end
---@return (fun():UnityEngine.Vector3)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonCommonLib:DG_Tweening_Core_DOGetter_UnityEngine_Vector3(func, self, flag) end
---@return (fun(pNewValue:UnityEngine.Vector3):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonCommonLib:DG_Tweening_Core_DOSetter_UnityEngine_Vector3(func, self, flag) end
---@return (fun():UnityEngine.Vector4)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonCommonLib:DG_Tweening_Core_DOGetter_UnityEngine_Vector4(func, self, flag) end
---@return (fun(pNewValue:UnityEngine.Vector4):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonCommonLib:DG_Tweening_Core_DOSetter_UnityEngine_Vector4(func, self, flag) end
---@return (fun():UnityEngine.Quaternion)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonCommonLib:DG_Tweening_Core_DOGetter_UnityEngine_Quaternion(func, self, flag) end
---@return (fun(pNewValue:UnityEngine.Quaternion):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonCommonLib:DG_Tweening_Core_DOSetter_UnityEngine_Quaternion(func, self, flag) end
---@return (fun():UnityEngine.Color)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonCommonLib:DG_Tweening_Core_DOGetter_UnityEngine_Color(func, self, flag) end
---@return (fun(pNewValue:UnityEngine.Color):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonCommonLib:DG_Tweening_Core_DOSetter_UnityEngine_Color(func, self, flag) end
---@return (fun():UnityEngine.Rect)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonCommonLib:DG_Tweening_Core_DOGetter_UnityEngine_Rect(func, self, flag) end
---@return (fun(pNewValue:UnityEngine.Rect):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonCommonLib:DG_Tweening_Core_DOSetter_UnityEngine_Rect(func, self, flag) end
---@return (fun():UnityEngine.RectOffset)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonCommonLib:DG_Tweening_Core_DOGetter_UnityEngine_RectOffset(func, self, flag) end
---@return (fun(pNewValue:UnityEngine.RectOffset):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonCommonLib:DG_Tweening_Core_DOSetter_UnityEngine_RectOffset(func, self, flag) end
---@return (fun():void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonCommonLib:DG_Tweening_TweenCallback(func, self, flag) end
---@return (fun(value:number):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonCommonLib:DG_Tweening_TweenCallback_int(func, self, flag) end
---@return (fun(driven:UnityEngine.RectTransform):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonCommonLib:UnityEngine_RectTransform_ReapplyDrivenProperties(func, self, flag) end
---@return (fun(cam:UnityEngine.Camera):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonCommonLib:UnityEngine_Camera_CameraCallback(func, self, flag) end
---@return (fun(advertisingId:string, trackingEnabled:boolean, errorMsg:string):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonCommonLib:UnityEngine_Application_AdvertisingIdentifierCallback(func, self, flag) end
---@return (fun():void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonCommonLib:UnityEngine_Application_LowMemoryCallback(func, self, flag) end
---@return (fun(condition:string, stackTrace:string, type:number):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonCommonLib:UnityEngine_Application_LogCallback(func, self, flag) end
---@return (fun(obj:boolean):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonCommonLib:System_Action_bool(func, self, flag) end
---@return (fun():boolean)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonCommonLib:System_Func_bool(func, self, flag) end
---@return (fun(data:System.Single[]):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonCommonLib:UnityEngine_AudioClip_PCMReaderCallback(func, self, flag) end
---@return (fun(position:number):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonCommonLib:UnityEngine_AudioClip_PCMSetPositionCallback(func, self, flag) end
---@return (fun(obj:UnityEngine.AsyncOperation):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonCommonLib:System_Action_UnityEngine_AsyncOperation(func, self, flag) end
---@return (fun():void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonCommonLib:UnityEngine_Canvas_WillRenderCanvases(func, self, flag) end
---@return (fun(text:string, charIndex:number, addedChar:number):number)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonCommonLib:UnityEngine_UI_InputField_OnValidateInput(func, self, flag) end
---@return (fun(arg0:string):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonCommonLib:UnityEngine_Events_UnityAction_string(func, self, flag) end
---@return (fun(arg0:number):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonCommonLib:UnityEngine_Events_UnityAction_int(func, self, flag) end
---@return (fun(obj:string):boolean)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonCommonLib:System_Predicate_string(func, self, flag) end
---@return (fun(obj:string):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonCommonLib:System_Action_string(func, self, flag) end
---@return (fun(x:string, y:string):number)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonCommonLib:System_Comparison_string(func, self, flag) end
---@return (fun(obj:UnityEngine.GameObject):boolean)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonCommonLib:System_Predicate_UnityEngine_GameObject(func, self, flag) end
---@return (fun(obj:UnityEngine.GameObject):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonCommonLib:System_Action_UnityEngine_GameObject(func, self, flag) end
---@return (fun(x:UnityEngine.GameObject, y:UnityEngine.GameObject):number)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonCommonLib:System_Comparison_UnityEngine_GameObject(func, self, flag) end
---@return (fun(obj:UnityEngine.EventSystems.RaycastResult):boolean)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonCommonLib:System_Predicate_UnityEngine_EventSystems_RaycastResult(func, self, flag) end
---@return (fun(obj:UnityEngine.EventSystems.RaycastResult):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonCommonLib:System_Action_UnityEngine_EventSystems_RaycastResult(func, self, flag) end
---@return (fun(x:UnityEngine.EventSystems.RaycastResult, y:UnityEngine.EventSystems.RaycastResult):number)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonCommonLib:System_Comparison_UnityEngine_EventSystems_RaycastResult(func, self, flag) end
---@return (fun(arg1:number, arg2:string):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonCommonLib:System_Action_MoonCommonLib_HttpTask_HttpResult_string(func, self, flag) end
---@return (fun(source:UnityEngine.Video.VideoPlayer):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonCommonLib:UnityEngine_Video_VideoPlayer_EventHandler(func, self, flag) end
---@return (fun(source:UnityEngine.Video.VideoPlayer, message:string):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonCommonLib:UnityEngine_Video_VideoPlayer_ErrorEventHandler(func, self, flag) end
---@return (fun(source:UnityEngine.Video.VideoPlayer, seconds:number):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonCommonLib:UnityEngine_Video_VideoPlayer_TimeEventHandler(func, self, flag) end
---@return (fun(source:UnityEngine.Video.VideoPlayer, frameIdx:int64):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonCommonLib:UnityEngine_Video_VideoPlayer_FrameReadyEventHandler(func, self, flag) end
return DelegateFactoryOfMoonCommonLib
