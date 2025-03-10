﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using MoonCommonLib;
using LuaInterface;

public class LuaTools_LuaProfilerWrap
{
	public static void Register(LuaState L)
	{
		L.BeginStaticLibs("LuaProfiler");
		L.RegFunction("BeginSample", BeginSample);
		L.RegFunction("EndSample", EndSample);
		L.EndStaticLibs();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int BeginSample(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 1)
			{
				int arg0 = (int)LuaDLL.luaL_checknumber(L, 1);
				LuaTools.LuaProfiler.BeginSample(arg0);
				return 0;
			}
			else if (count == 2)
			{
				int arg0 = (int)LuaDLL.luaL_checknumber(L, 1);
				string arg1 = ToLua.CheckString(L, 2);
				LuaTools.LuaProfiler.BeginSample(arg0, arg1);
				return 0;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to method: LuaTools.LuaProfiler.BeginSample");
			}
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int EndSample(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 0);
			LuaTools.LuaProfiler.EndSample();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}
}

