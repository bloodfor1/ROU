﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using MoonCommonLib;
using LuaInterface;

public class MFmodVCAWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(MFmodVCA), typeof(System.Object));
		L.RegFunction("getID", getID);
		L.RegFunction("getPath", getPath);
		L.RegFunction("getVolume", getVolume);
		L.RegFunction("setVolume", setVolume);
		L.RegFunction("New", _CreateMFmodVCA);
		L.RegFunction("__tostring", ToLua.op_ToString);
		L.RegVar("vca", get_vca, null);
		L.RegVar("Deprecated", get_Deprecated, set_Deprecated);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateMFmodVCA(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 1)
			{
				FMOD.Studio.VCA arg0 = StackTraits<FMOD.Studio.VCA>.Check(L, 1);
				MFmodVCA obj = new MFmodVCA(arg0);
				ToLua.PushObject(L, obj);
				return 1;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to ctor method: MFmodVCA.New");
			}
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int getID(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			MFmodVCA obj = (MFmodVCA)ToLua.CheckObject<MFmodVCA>(L, 1);
			System.Guid o = obj.getID();
			ToLua.PushValue(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int getPath(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			MFmodVCA obj = (MFmodVCA)ToLua.CheckObject<MFmodVCA>(L, 1);
			string o = obj.getPath();
			LuaDLL.lua_pushstring(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int getVolume(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 3);
			MFmodVCA obj = (MFmodVCA)ToLua.CheckObject<MFmodVCA>(L, 1);
			float arg0;
			float arg1;
			obj.getVolume(out arg0, out arg1);
			LuaDLL.lua_pushnumber(L, arg0);
			LuaDLL.lua_pushnumber(L, arg1);
			return 2;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int setVolume(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			MFmodVCA obj = (MFmodVCA)ToLua.CheckObject<MFmodVCA>(L, 1);
			float arg0 = (float)LuaDLL.luaL_checknumber(L, 2);
			obj.setVolume(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_vca(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			MFmodVCA obj = (MFmodVCA)o;
			FMOD.Studio.VCA ret = obj.vca;
			ToLua.PushValue(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index vca on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_Deprecated(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			MFmodVCA obj = (MFmodVCA)o;
			bool ret = obj.Deprecated;
			LuaDLL.lua_pushboolean(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index Deprecated on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_Deprecated(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			MFmodVCA obj = (MFmodVCA)o;
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			obj.Deprecated = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index Deprecated on a nil value");
		}
	}
}

