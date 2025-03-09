#define USING_DOTWEENING

using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using DG.Tweening;
using LuaInterface;
using MoonCommonLib;
using RenderHeads.Media.AVProVideo;
using UnityEngine;
using SDKLib;
using SDKLib.SDKInterface;

public class DefaultExportSettings : BaseExportSetting
{

    public override string AssemblyName { get; } = "Default";

    public override string SaveDir { get; } = Application.dataPath + "/Source/Generate/";

    public override List<Type> StaticClassTypes { get; } = new List<Type>()
    {
        typeof(UnityEngine.PlayerPrefs),
        typeof(StringEx),
        typeof(FileEx),
        typeof(PathEx),
    };

    public override List<LuaBindType> CustomTypeList { get; } = new List<LuaBindType>()
    {
        _GT(typeof(Debugger)).SetNameSpace(null),
        _GT(typeof(DG.Tweening.DOTweenAnimation)),
        _GT(typeof(TMPro.TextMeshProUGUI)),
        _GT(typeof(TMPro.TMP_InputField)),

        // 以下是sdklib相关的lua wrap
         // msdk_lua_wrap_insert
        _GT(typeof(EDevicePermissionType)),
        _GT(typeof(EDevicePermissionResult)),
        // 以上是sdklib相关的lua wrap

        //enum
        _GT(typeof(UnityEngine.Playables.DirectorWrapMode)),

        //audio
        _GT(typeof(MFModEventInstance)),
        _GT(typeof(MFmodVCA)),
        _GT(typeof(MFModRunTimeManager)),
        _GT(typeof(MFmodBus)),
        _GT(typeof(MFmodEventDescription)),

        _GT(typeof(LuaTools.LuaProfiler)),
        _GT(typeof(FxAnimation.FxAnimationHelper)),
        _GT(typeof(Spine.Unity.SkeletonAnimation)),
        _GT(typeof(Spine.Unity.SkeletonGraphic)),
        _GT(typeof(Reporter)),
        _GT(typeof(FaceToCameraObjPrepareData)),

        _GT(typeof(DisplayUGUI)),
        _GT(typeof(MediaPlayer)),
    };

    public override List<LuaDelegateType> CustomDelegateList { get; } = new List<LuaDelegateType>()
    {
        _DT(typeof(Action)),
        _DT(typeof(UnityEngine.Events.UnityAction)),
        _DT(typeof(System.Predicate<int>)),
        _DT(typeof(System.Action<int>)),
        _DT(typeof(System.Comparison<int>)),
        _DT(typeof(System.Func<int, int>)),

        // Custom
        _DT(typeof(LoadCallBack)),
        _DT(typeof(LoadSpritesCallBack)),

        _DT(typeof(Action<Action>)),
    };

    public override List<string> ExtraUsing { get; } = new List<string>()
    {
        "MoonCommonLib"
    };

    public override Dictionary<Type, Dictionary<string, string>> ReDefineMethodDict { get; } = new Dictionary<Type, Dictionary<string, string>>()
    {
        [typeof(GameObject)] = new Dictionary<string, string>()
        {
            ["GetComponent"] = @"
        try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 2 && TypeChecker.CheckTypes<System.Type>(L, 2))
			{
				UnityEngine.GameObject obj = (UnityEngine.GameObject)ToLua.CheckObject(L, 1, typeof(UnityEngine.GameObject));
				System.Type arg0 = (System.Type)ToLua.ToObject(L, 2);
				UnityEngine.Component o = obj.GetComponent(arg0);
				ToLua.Push(L, o);
				return 1;
			}
			else if (count == 2 && TypeChecker.CheckTypes<string>(L, 2))
			{
				UnityEngine.GameObject obj = (UnityEngine.GameObject)ToLua.CheckObject(L, 1, typeof(UnityEngine.GameObject));
				string arg0 = ToLua.ToString(L, 2);
                UnityEngine.Component o = null;
                var typeMap = MInterfaceMgr.singleton.GetInterface<ITypeMap>(""TypeMapOfMoonClient"");
			    var type = typeMap?.GetTypeWithName(arg0);
			    if (type != null)
			    {
			        o = obj.GetComponent(type);
			    }
			    else
			    {
				    o = obj.GetComponent(arg0);
                }
				ToLua.Push(L, o);
				return 1;
			}
			else
			{
				return LuaDLL.luaL_throw(L, ""invalid arguments to method: UnityEngine.GameObject.GetComponent"");
            }

        }
        catch (Exception e)
        {
            return LuaDLL.toluaL_exception(L, e);
        }"
        },
        [typeof(GameObject)] = new Dictionary<string, string>()
        {
            ["GetComponentsInChildren"] = @"
        try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 2 && TypeChecker.CheckTypes<System.Type>(L, 2))
			{
				UnityEngine.GameObject obj = (UnityEngine.GameObject)ToLua.CheckObject(L, 1, typeof(UnityEngine.GameObject));
				System.Type arg0 = (System.Type)ToLua.ToObject(L, 2);
				UnityEngine.Component[] o = obj.GetComponentsInChildren(arg0);
				ToLua.Push(L, o);
				return 1;
			}
			else if (count == 2 && TypeChecker.CheckTypes<string>(L, 2))
			{
				UnityEngine.GameObject obj = (UnityEngine.GameObject)ToLua.CheckObject(L, 1, typeof(UnityEngine.GameObject));
				string arg0 = ToLua.ToString(L, 2);
				UnityEngine.Component[] o = null;
                var typeMap = MInterfaceMgr.singleton.GetInterface<ITypeMap>(""TypeMapOfMoonClient"");
			    var type = typeMap?.GetTypeWithName(arg0);
			    if (type != null)
			    {
			        o = obj.GetComponentsInChildren(type);
			    }
				ToLua.Push(L, o);
				return 1;
			}
            else if(count == 3 && TypeChecker.CheckTypes<System.Type>(L, 2))
            {
				UnityEngine.GameObject obj = (UnityEngine.GameObject)ToLua.CheckObject(L, 1, typeof(UnityEngine.GameObject));
				System.Type arg0 = (System.Type)ToLua.ToObject(L, 2);
				bool arg1 = LuaDLL.luaL_checkboolean(L, 3);
				UnityEngine.Component[] o = obj.GetComponentsInChildren(arg0, arg1);
				ToLua.Push(L, o);
				return 1;
            }
            else if(count == 3 && TypeChecker.CheckTypes<string>(L, 2))
            {
				UnityEngine.GameObject obj = (UnityEngine.GameObject)ToLua.CheckObject(L, 1, typeof(UnityEngine.GameObject));
				string arg0 = ToLua.ToString(L, 2);
				UnityEngine.Component[] o = null;
                var typeMap = MInterfaceMgr.singleton.GetInterface<ITypeMap>(""TypeMapOfMoonClient"");
				bool arg1 = LuaDLL.luaL_checkboolean(L, 3);
	            var type = typeMap?.GetTypeWithName(arg0);
			    if (type != null)
			    {
			        o = obj.GetComponentsInChildren(type,arg1);
			    }
				ToLua.Push(L, o);
				return 1;
            }
			else
			{
				return LuaDLL.luaL_throw(L, ""invalid arguments to method: UnityEngine.GameObject.GetComponent"");
            }
        }
        catch (Exception e)
        {
            return LuaDLL.toluaL_exception(L, e);
        }"
        },
        [typeof(Component)] = new Dictionary<string, string>()
        {
            ["GetComponent"] = @"
        try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 2 && TypeChecker.CheckTypes<System.Type>(L, 2))
			{
				UnityEngine.Component obj = (UnityEngine.Component)ToLua.CheckObject(L, 1, typeof(UnityEngine.Component));
				System.Type arg0 = (System.Type)ToLua.ToObject(L, 2);
				UnityEngine.Component o = obj.GetComponent(arg0);
				ToLua.Push(L, o);
				return 1;
			}
			else if (count == 2 && TypeChecker.CheckTypes<string>(L, 2))
			{
				UnityEngine.Component obj = (UnityEngine.Component)ToLua.CheckObject(L, 1, typeof(UnityEngine.Component));
				string arg0 = ToLua.ToString(L, 2);
				UnityEngine.Component o = null;
                var typeMap = MInterfaceMgr.singleton.GetInterface<ITypeMap>(""TypeMapOfMoonClient"");
			    var type = typeMap?.GetTypeWithName(arg0);
			    if (type != null)
			    {
			        o = obj.GetComponent(type);
			    }
			    else
			    {
				    o = obj.GetComponent(arg0);
                }
				ToLua.Push(L, o);
				return 1;
			}
			else
			{
				return LuaDLL.luaL_throw(L, ""invalid arguments to method: UnityEngine.GameObject.GetComponent"");
            }
        }
        catch (Exception e)
        {
            return LuaDLL.toluaL_exception(L, e);
        }"
        },
        [typeof(Component)] = new Dictionary<string, string>()
        {
            ["GetComponentsInChildren"] = @"
        try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 2 && TypeChecker.CheckTypes<System.Type>(L, 2))
			{
				UnityEngine.Component obj = (UnityEngine.Component)ToLua.CheckObject(L, 1, typeof(UnityEngine.Component));
				System.Type arg0 = (System.Type)ToLua.ToObject(L, 2);
				UnityEngine.Component[] o = obj.GetComponentsInChildren(arg0);
				ToLua.Push(L, o);
				return 1;
			}
			else if (count == 2 && TypeChecker.CheckTypes<string>(L, 2))
			{
				UnityEngine.Component obj = (UnityEngine.Component)ToLua.CheckObject(L, 1, typeof(UnityEngine.Component));
				string arg0 = ToLua.ToString(L, 2);
				UnityEngine.Component[] o = null;
                var typeMap = MInterfaceMgr.singleton.GetInterface<ITypeMap>(""TypeMapOfMoonClient"");
			    var type = typeMap?.GetTypeWithName(arg0);
			    if (type != null)
			    {
			        o = obj.GetComponentsInChildren(type);
			    }
				ToLua.Push(L, o);
				return 1;
			}
            else if(count == 3 && TypeChecker.CheckTypes<System.Type>(L, 2))
            {
				UnityEngine.Component obj = (UnityEngine.Component)ToLua.CheckObject(L, 1, typeof(UnityEngine.Component));
				System.Type arg0 = (System.Type)ToLua.ToObject(L, 2);
				bool arg1 = LuaDLL.luaL_checkboolean(L, 3);
				UnityEngine.Component[] o = obj.GetComponentsInChildren(arg0, arg1);
				ToLua.Push(L, o);
				return 1;
            }
            else if(count == 3 && TypeChecker.CheckTypes<string>(L, 2))
            {
				UnityEngine.Component obj = (UnityEngine.Component)ToLua.CheckObject(L, 1, typeof(UnityEngine.Component));
				string arg0 = ToLua.ToString(L, 2);
				UnityEngine.Component[] o = null;
                var typeMap = MInterfaceMgr.singleton.GetInterface<ITypeMap>(""TypeMapOfMoonClient"");
				bool arg1 = LuaDLL.luaL_checkboolean(L, 3);
	            var type = typeMap?.GetTypeWithName(arg0);
			    if (type != null)
			    {
			        o = obj.GetComponentsInChildren(type,arg1);
			    }
				ToLua.Push(L, o);
				return 1;
            }
			else
			{
				return LuaDLL.luaL_throw(L, ""invalid arguments to method: UnityEngine.GameObject.GetComponent"");
            }
        }
        catch (Exception e)
        {
            return LuaDLL.toluaL_exception(L, e);
        }"
        },
    };

    public override List<Type> DynamicList { get; } = new List<Type>()
    {

    };

    public override List<Type> OutList { get; } = new List<Type>()
    {

    };

    public override List<Type> SealedList { get; } = new List<Type>()
    {

    };
}
