---@class DelegateFactoryOfMoonClient
---@field public dict System.Collections.Generic.Dictionary_System.Type_DelegateFactoryOfMoonClient.DelegateCreate

---@type DelegateFactoryOfMoonClient
DelegateFactoryOfMoonClient = { }
---@return DelegateFactoryOfMoonClient
function DelegateFactoryOfMoonClient.New() end
function DelegateFactoryOfMoonClient.Init() end
function DelegateFactoryOfMoonClient.Register() end
---@overload fun(t:string, func:(fun():void)): System.Delegate
---@return System.Delegate
---@param t string
---@param func (fun():void)
---@param self table
function DelegateFactoryOfMoonClient.CreateDelegate(t, func, self) end
---@overload fun(obj:System.Delegate, func:(fun():void)): System.Delegate
---@return System.Delegate
---@param obj System.Delegate
---@param dg System.Delegate
function DelegateFactoryOfMoonClient.RemoveDelegate(obj, dg) end
---@return (fun():void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:System_Action(func, self, flag) end
---@return (fun():void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:UnityEngine_Events_UnityAction(func, self, flag) end
---@return (fun(obj:number):boolean)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:System_Predicate_int(func, self, flag) end
---@return (fun(obj:number):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:System_Action_int(func, self, flag) end
---@return (fun(x:number, y:number):number)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:System_Comparison_int(func, self, flag) end
---@return (fun(arg:number):number)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:System_Func_int_int(func, self, flag) end
---@return (fun(obj:UnityEngine.Object, cbObj:System.Object, taskId:number):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:MoonCommonLib_LoadCallBack(func, self, flag) end
---@return (fun(sprite:UnityEngine.Sprite, cbObj:System.Object):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:MoonCommonLib_LoadSpriteCallback(func, self, flag) end
---@return (fun():void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:DG_Tweening_TweenCallback(func, self, flag) end
---@return (fun(item:MoonClient.UIDragDropItem, customData:string, oldCustomData:string, dropSucc:boolean, data:UnityEngine.EventSystems.PointerEventData):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:MoonClient_UIDragDropContainer_DropDelegate(func, self, flag) end
---@return (fun(go:UnityEngine.GameObject, eventData:UnityEngine.EventSystems.PointerEventData):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:MoonClient_MUIListenerBase_UIEventDelegate(func, self, flag) end
---@return (fun(obj:(fun():void)):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:System_Action_System_Action(func, self, flag) end
---@return (fun(go:UnityEngine.GameObject, fxId:number, userData:System.Object):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:MoonCommonLib_FxLoadedHandler(func, self, flag) end
---@return (fun(isFxEnd:boolean, fxId:number, userData:System.Object):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:MoonCommonLib_FxDestroyHandler(func, self, flag) end
---@return (fun(obj:UnityEngine.Texture2D):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:System_Action_UnityEngine_Texture2D(func, self, flag) end
---@return (fun(info:MoonClient.ABInfo):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:MoonClient_LoadABCompleteHandler(func, self, flag) end
---@return (fun(arg1:TMPro.TextMeshProUGUI, arg2:TMPro.TMP_FontAsset):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:System_Action_TMPro_TextMeshProUGUI_TMPro_TMP_FontAsset(func, self, flag) end
---@return (fun(arg1:TMPro.TextMeshProUGUI, arg2:UnityEngine.Material):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:System_Action_TMPro_TextMeshProUGUI_UnityEngine_Material(func, self, flag) end
---@return (fun(arg1:table, arg2:UnityEngine.GameObject, arg3:UnityEngine.EventSystems.PointerEventData):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:System_Action_LuaInterface_LuaTable_UnityEngine_GameObject_UnityEngine_EventSystems_PointerEventData(func, self, flag) end
---@return (fun(obj:UnityEngine.EventSystems.BaseEventData):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:System_Action_UnityEngine_EventSystems_BaseEventData(func, self, flag) end
---@return (fun(text:string, charIndex:number, addedChar:number):number)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:UnityEngine_UI_InputField_OnValidateInput(func, self, flag) end
---@return (fun(arg1:MoonClient.SpriteFrameAnimationImage, arg2:System.Object):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:System_Action_MoonClient_SpriteFrameAnimationImage_object(func, self, flag) end
---@return (fun(gameObject:UnityEngine.GameObject, customData:string, state:number, data:UnityEngine.EventSystems.PointerEventData):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:MoonClient_UIDragDropContainer_LeaveDelegate(func, self, flag) end
---@return (fun(item:UnityEngine.GameObject, index:number):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:MoonClient_UIWrapContent_UpdateOneItem(func, self, flag) end
---@return (fun(item:UnityEngine.GameObject, index:number):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:MoonClient_MRingScrollRect_OnInitItem(func, self, flag) end
---@return (fun(match:System.Text.RegularExpressions.Match):string)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:System_Text_RegularExpressions_MatchEvaluator(func, self, flag) end
---@return (fun(arg0:string, arg1:UnityEngine.EventSystems.PointerEventData):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:UnityEngine_Events_UnityAction_string_UnityEngine_EventSystems_PointerEventData(func, self, flag) end
---@return (fun(arg0:boolean):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:UnityEngine_Events_UnityAction_bool(func, self, flag) end
---@return (fun(item:UnityEngine.GameObject, index:number):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:MoonClient_PageView_UpdateOneItem(func, self, flag) end
---@return (fun(obj:UnityEngine.EventSystems.PointerEventData):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:System_Action_UnityEngine_EventSystems_PointerEventData(func, self, flag) end
---@return (fun(arg1:string, arg2:string):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:System_Action_string_string(func, self, flag) end
---@return (fun(obj:number):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:System_Action_float(func, self, flag) end
---@return (fun(center:UnityEngine.Vector3, radius:number):boolean)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:MoonClient_MEntity_AttackCollisionHandler(func, self, flag) end
---@return (fun(obj:UnityEngine.GameObject):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:System_Action_UnityEngine_GameObject(func, self, flag) end
---@return (fun(obj:MoonClient.MModel):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:System_Action_MoonClient_MModel(func, self, flag) end
---@return (fun(entity:MoonClient.MEntity, entityId:number, uid:uint64):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:MoonClient_MEntityMgr_onEntityCreateDelegate(func, self, flag) end
---@return (fun(arg:MoonClient.MObject):boolean)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:System_Func_MoonClient_MObject_bool(func, self, flag) end
---@return (fun():void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:MoonClient_MEventMgr_EventPoolClear(func, self, flag) end
---@return (fun(obj:int64):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:System_Action_long(func, self, flag) end
---@return (fun():void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:MoonClient_MCommonSliderEndFun(func, self, flag) end
---@return (fun(extractedFrame:UnityEngine.Texture2D):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:MoonCommonLib_ProcessExtractedFrame(func, self, flag) end
---@return (fun(token:number, args:System.Object[]):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:MoonClient_MTimerMgr_TimerEventHandler(func, self, flag) end
---@return (fun(obj:MoonClient.MSceneMgr.AssetEntity):boolean)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:System_Predicate_MoonClient_MSceneMgr_AssetEntity(func, self, flag) end
---@return (fun(obj:MoonClient.MSceneMgr.AssetEntity):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:System_Action_MoonClient_MSceneMgr_AssetEntity(func, self, flag) end
---@return (fun(x:MoonClient.MSceneMgr.AssetEntity, y:MoonClient.MSceneMgr.AssetEntity):number)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:System_Comparison_MoonClient_MSceneMgr_AssetEntity(func, self, flag) end
---@return (fun(obj:MoonClient.MSkillInfo):boolean)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:System_Predicate_MoonClient_MSkillInfo(func, self, flag) end
---@return (fun(obj:MoonClient.MSkillInfo):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:System_Action_MoonClient_MSkillInfo(func, self, flag) end
---@return (fun(x:MoonClient.MSkillInfo, y:MoonClient.MSkillInfo):number)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:System_Comparison_MoonClient_MSkillInfo(func, self, flag) end
---@return (fun(obj:MoonClient.TeamMemberInfo):boolean)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:System_Predicate_MoonClient_TeamMemberInfo(func, self, flag) end
---@return (fun(obj:MoonClient.TeamMemberInfo):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:System_Action_MoonClient_TeamMemberInfo(func, self, flag) end
---@return (fun(x:MoonClient.TeamMemberInfo, y:MoonClient.TeamMemberInfo):number)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:System_Comparison_MoonClient_TeamMemberInfo(func, self, flag) end
---@return (fun(obj:UnityEngine.RectTransform):boolean)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:System_Predicate_UnityEngine_RectTransform(func, self, flag) end
---@return (fun(obj:UnityEngine.RectTransform):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:System_Action_UnityEngine_RectTransform(func, self, flag) end
---@return (fun(x:UnityEngine.RectTransform, y:UnityEngine.RectTransform):number)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:System_Comparison_UnityEngine_RectTransform(func, self, flag) end
---@return (fun(obj:number):boolean)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:System_Predicate_MoonClient_MSceneEnvoriment_MWeatherType(func, self, flag) end
---@return (fun(obj:number):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:System_Action_MoonClient_MSceneEnvoriment_MWeatherType(func, self, flag) end
---@return (fun(x:number, y:number):number)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:System_Comparison_MoonClient_MSceneEnvoriment_MWeatherType(func, self, flag) end
---@return (fun(obj:MoonClient.MSceneNpcData):boolean)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:System_Predicate_MoonClient_MSceneNpcData(func, self, flag) end
---@return (fun(obj:MoonClient.MSceneNpcData):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:System_Action_MoonClient_MSceneNpcData(func, self, flag) end
---@return (fun(x:MoonClient.MSceneNpcData, y:MoonClient.MSceneNpcData):number)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:System_Comparison_MoonClient_MSceneNpcData(func, self, flag) end
---@return (fun(obj:KKSG.WorldEventDB):boolean)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:System_Predicate_KKSG_WorldEventDB(func, self, flag) end
---@return (fun(obj:KKSG.WorldEventDB):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:System_Action_KKSG_WorldEventDB(func, self, flag) end
---@return (fun(x:KKSG.WorldEventDB, y:KKSG.WorldEventDB):number)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:System_Comparison_KKSG_WorldEventDB(func, self, flag) end
---@return (fun(obj:string):boolean)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:System_Predicate_string(func, self, flag) end
---@return (fun(go:UnityEngine.GameObject, data:UnityEngine.EventSystems.BaseEventData):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:MoonClient_MUIEventListener_listenerDelegate(func, self, flag) end
---@return (fun(go:UnityEngine.GameObject, data:UnityEngine.EventSystems.BaseEventData):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:MoonClient_ButtonLongPress_listenerDelegate(func, self, flag) end
---@return (fun(obj:MoonClient.CommandSystem.CommandBlock):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:System_Action_MoonClient_CommandSystem_CommandBlock(func, self, flag) end
---@return (fun():string)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:System_Func_string(func, self, flag) end
---@return (fun(arg1:MoonClient.LoopScrollRect, arg2:UnityEngine.EventSystems.PointerEventData):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:System_Action_MoonClient_LoopScrollRect_UnityEngine_EventSystems_PointerEventData(func, self, flag) end
---@return (fun(obj:MoonClient.LoopScrollRect):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:System_Action_MoonClient_LoopScrollRect(func, self, flag) end
---@return (fun(arg:number):UnityEngine.GameObject)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:System_Func_int_UnityEngine_GameObject(func, self, flag) end
---@return (fun(arg1:UnityEngine.Transform, arg2:number):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:System_Action_UnityEngine_Transform_int(func, self, flag) end
---@return (fun(obj:MoonClient.ScrollRectWithCallback):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:System_Action_MoonClient_ScrollRectWithCallback(func, self, flag) end
---@return (fun():void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:MoonClient_UITurnTableAnimationCurve_OnFinished(func, self, flag) end
---@return (fun(arg1:boolean, arg2:number):void)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:System_Action_bool_float(func, self, flag) end
---@return (fun(arg:MoonClient.MEntity):boolean)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:System_Func_MoonClient_MEntity_bool(func, self, flag) end
---@return (fun():boolean)
---@param func (fun():void)
---@param self table
---@param flag boolean
function DelegateFactoryOfMoonClient:System_Func_bool(func, self, flag) end
return DelegateFactoryOfMoonClient
