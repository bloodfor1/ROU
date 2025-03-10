﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using MoonCommonLib;
using LuaInterface;

public class FxAnimation_FxAnimationHelperWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(FxAnimation.FxAnimationHelper), typeof(UnityEngine.MonoBehaviour));
		L.RegFunction("PlayAll", PlayAll);
		L.RegFunction("PlayAllOnce", PlayAllOnce);
		L.RegFunction("addFinishCallbackByIndex", addFinishCallbackByIndex);
		L.RegFunction("StopAll", StopAll);
		L.RegFunction("Stop", Stop);
		L.RegFunction("SetSpeed", SetSpeed);
		L.RegFunction("Play", Play);
		L.RegFunction("SetPlayTime", SetPlayTime);
		L.RegFunction("GetFxAnimTotalPlayTime", GetFxAnimTotalPlayTime);
		L.RegFunction("InitHelper", InitHelper);
		L.RegFunction("AddHelper", AddHelper);
		L.RegFunction("InitData", InitData);
		L.RegFunction("__eq", op_Equality);
		L.RegFunction("__tostring", ToLua.op_ToString);
		L.RegVar("Helpers", get_Helpers, null);
		L.RegVar("Repeat", get_Repeat, set_Repeat);
		L.RegVar("RepeatCheck", get_RepeatCheck, set_RepeatCheck);
		L.RegVar("PlayOnEnable", get_PlayOnEnable, set_PlayOnEnable);
		L.RegVar("IsStatic", get_IsStatic, set_IsStatic);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int PlayAll(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			FxAnimation.FxAnimationHelper obj = (FxAnimation.FxAnimationHelper)ToLua.CheckObject<FxAnimation.FxAnimationHelper>(L, 1);
			obj.PlayAll();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int PlayAllOnce(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			FxAnimation.FxAnimationHelper obj = (FxAnimation.FxAnimationHelper)ToLua.CheckObject<FxAnimation.FxAnimationHelper>(L, 1);
			obj.PlayAllOnce();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int addFinishCallbackByIndex(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 2)
			{
				FxAnimation.FxAnimationHelper obj = (FxAnimation.FxAnimationHelper)ToLua.CheckObject<FxAnimation.FxAnimationHelper>(L, 1);
				DG.Tweening.TweenCallback arg0 = (DG.Tweening.TweenCallback)ToLua.CheckDelegate<DG.Tweening.TweenCallback>(L, 2);
				obj.addFinishCallbackByIndex(arg0);
				return 0;
			}
			else if (count == 3)
			{
				FxAnimation.FxAnimationHelper obj = (FxAnimation.FxAnimationHelper)ToLua.CheckObject<FxAnimation.FxAnimationHelper>(L, 1);
				DG.Tweening.TweenCallback arg0 = (DG.Tweening.TweenCallback)ToLua.CheckDelegate<DG.Tweening.TweenCallback>(L, 2);
				int arg1 = (int)LuaDLL.luaL_checknumber(L, 3);
				obj.addFinishCallbackByIndex(arg0, arg1);
				return 0;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to method: FxAnimation.FxAnimationHelper.addFinishCallbackByIndex");
			}
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int StopAll(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			FxAnimation.FxAnimationHelper obj = (FxAnimation.FxAnimationHelper)ToLua.CheckObject<FxAnimation.FxAnimationHelper>(L, 1);
			obj.StopAll();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Stop(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			FxAnimation.FxAnimationHelper obj = (FxAnimation.FxAnimationHelper)ToLua.CheckObject<FxAnimation.FxAnimationHelper>(L, 1);
			FxAnimation.HelperData arg0 = (FxAnimation.HelperData)ToLua.CheckObject<FxAnimation.HelperData>(L, 2);
			obj.Stop(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetSpeed(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			FxAnimation.FxAnimationHelper obj = (FxAnimation.FxAnimationHelper)ToLua.CheckObject<FxAnimation.FxAnimationHelper>(L, 1);
			float arg0 = (float)LuaDLL.luaL_checknumber(L, 2);
			obj.SetSpeed(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Play(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			FxAnimation.FxAnimationHelper obj = (FxAnimation.FxAnimationHelper)ToLua.CheckObject<FxAnimation.FxAnimationHelper>(L, 1);
			FxAnimation.HelperData arg0 = (FxAnimation.HelperData)ToLua.CheckObject<FxAnimation.HelperData>(L, 2);
			obj.Play(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetPlayTime(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			FxAnimation.FxAnimationHelper obj = (FxAnimation.FxAnimationHelper)ToLua.CheckObject<FxAnimation.FxAnimationHelper>(L, 1);
			float arg0 = (float)LuaDLL.luaL_checknumber(L, 2);
			obj.SetPlayTime(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetFxAnimTotalPlayTime(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			FxAnimation.FxAnimationHelper obj = (FxAnimation.FxAnimationHelper)ToLua.CheckObject<FxAnimation.FxAnimationHelper>(L, 1);
			float o = obj.GetFxAnimTotalPlayTime();
			LuaDLL.lua_pushnumber(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int InitHelper(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			FxAnimation.FxAnimationHelper obj = (FxAnimation.FxAnimationHelper)ToLua.CheckObject<FxAnimation.FxAnimationHelper>(L, 1);
			obj.InitHelper();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int AddHelper(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			FxAnimation.FxAnimationHelper obj = (FxAnimation.FxAnimationHelper)ToLua.CheckObject<FxAnimation.FxAnimationHelper>(L, 1);
			FxAnimation.HelperData arg0 = (FxAnimation.HelperData)ToLua.CheckObject<FxAnimation.HelperData>(L, 2);
			int o = obj.AddHelper(arg0);
			LuaDLL.lua_pushinteger(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int InitData(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			FxAnimation.FxAnimationHelper obj = (FxAnimation.FxAnimationHelper)ToLua.CheckObject<FxAnimation.FxAnimationHelper>(L, 1);
			obj.InitData();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int op_Equality(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			UnityEngine.Object arg0 = (UnityEngine.Object)ToLua.ToObject(L, 1);
			UnityEngine.Object arg1 = (UnityEngine.Object)ToLua.ToObject(L, 2);
			bool o = arg0 == arg1;
			LuaDLL.lua_pushboolean(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_Helpers(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			FxAnimation.FxAnimationHelper obj = (FxAnimation.FxAnimationHelper)o;
			FxAnimation.HelperData[] ret = obj.Helpers;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index Helpers on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_Repeat(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			FxAnimation.FxAnimationHelper obj = (FxAnimation.FxAnimationHelper)o;
			int ret = obj.Repeat;
			LuaDLL.lua_pushinteger(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index Repeat on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_RepeatCheck(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			FxAnimation.FxAnimationHelper obj = (FxAnimation.FxAnimationHelper)o;
			float ret = obj.RepeatCheck;
			LuaDLL.lua_pushnumber(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index RepeatCheck on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_PlayOnEnable(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			FxAnimation.FxAnimationHelper obj = (FxAnimation.FxAnimationHelper)o;
			bool ret = obj.PlayOnEnable;
			LuaDLL.lua_pushboolean(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index PlayOnEnable on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_IsStatic(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			FxAnimation.FxAnimationHelper obj = (FxAnimation.FxAnimationHelper)o;
			bool ret = obj.IsStatic;
			LuaDLL.lua_pushboolean(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index IsStatic on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_Repeat(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			FxAnimation.FxAnimationHelper obj = (FxAnimation.FxAnimationHelper)o;
			int arg0 = (int)LuaDLL.luaL_checknumber(L, 2);
			obj.Repeat = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index Repeat on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_RepeatCheck(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			FxAnimation.FxAnimationHelper obj = (FxAnimation.FxAnimationHelper)o;
			float arg0 = (float)LuaDLL.luaL_checknumber(L, 2);
			obj.RepeatCheck = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index RepeatCheck on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_PlayOnEnable(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			FxAnimation.FxAnimationHelper obj = (FxAnimation.FxAnimationHelper)o;
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			obj.PlayOnEnable = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index PlayOnEnable on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_IsStatic(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			FxAnimation.FxAnimationHelper obj = (FxAnimation.FxAnimationHelper)o;
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			obj.IsStatic = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index IsStatic on a nil value");
		}
	}
}

