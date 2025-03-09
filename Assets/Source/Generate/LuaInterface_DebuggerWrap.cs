﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using MoonCommonLib;
using LuaInterface;

public class LuaInterface_DebuggerWrap
{
	public static void Register(LuaState L)
	{
		L.BeginStaticLibs("Debugger");
		L.RegFunction("Log", Log);
		L.RegFunction("LogWarning", LogWarning);
		L.RegFunction("LogError", LogError);
		L.RegFunction("LogException", LogException);
		L.RegVar("useLog", get_useLog, set_useLog);
		L.RegVar("threadStack", get_threadStack, set_threadStack);
		L.RegVar("logger", get_logger, set_logger);
		L.EndStaticLibs();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Log(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 1 && TypeChecker.CheckTypes<string>(L, 1))
			{
				string arg0 = ToLua.ToString(L, 1);
				LuaInterface.Debugger.Log(arg0);
				return 0;
			}
			else if (count == 1 && TypeChecker.CheckTypes<object>(L, 1))
			{
				object arg0 = ToLua.ToVarObject(L, 1);
				LuaInterface.Debugger.Log(arg0);
				return 0;
			}
			else if (count == 2 && TypeChecker.CheckTypes<string, object>(L, 1))
			{
				string arg0 = ToLua.ToString(L, 1);
				object arg1 = ToLua.ToVarObject(L, 2);
				LuaInterface.Debugger.Log(arg0, arg1);
				return 0;
			}
			else if (count == 3 && TypeChecker.CheckTypes<string, object, object>(L, 1))
			{
				string arg0 = ToLua.ToString(L, 1);
				object arg1 = ToLua.ToVarObject(L, 2);
				object arg2 = ToLua.ToVarObject(L, 3);
				LuaInterface.Debugger.Log(arg0, arg1, arg2);
				return 0;
			}
			else if (count == 4 && TypeChecker.CheckTypes<string, object, object, object>(L, 1))
			{
				string arg0 = ToLua.ToString(L, 1);
				object arg1 = ToLua.ToVarObject(L, 2);
				object arg2 = ToLua.ToVarObject(L, 3);
				object arg3 = ToLua.ToVarObject(L, 4);
				LuaInterface.Debugger.Log(arg0, arg1, arg2, arg3);
				return 0;
			}
			else if (TypeChecker.CheckTypes<string>(L, 1) && TypeChecker.CheckParamsType<object>(L, 2, count - 1))
			{
				string arg0 = ToLua.ToString(L, 1);
				object[] arg1 = ToLua.ToParamsObject(L, 2, count - 1);
				LuaInterface.Debugger.Log(arg0, arg1);
				return 0;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to method: LuaInterface.Debugger.Log");
			}
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int LogWarning(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 1 && TypeChecker.CheckTypes<string>(L, 1))
			{
				string arg0 = ToLua.ToString(L, 1);
				LuaInterface.Debugger.LogWarning(arg0);
				return 0;
			}
			else if (count == 1 && TypeChecker.CheckTypes<object>(L, 1))
			{
				object arg0 = ToLua.ToVarObject(L, 1);
				LuaInterface.Debugger.LogWarning(arg0);
				return 0;
			}
			else if (count == 2 && TypeChecker.CheckTypes<string, object>(L, 1))
			{
				string arg0 = ToLua.ToString(L, 1);
				object arg1 = ToLua.ToVarObject(L, 2);
				LuaInterface.Debugger.LogWarning(arg0, arg1);
				return 0;
			}
			else if (count == 3 && TypeChecker.CheckTypes<string, object, object>(L, 1))
			{
				string arg0 = ToLua.ToString(L, 1);
				object arg1 = ToLua.ToVarObject(L, 2);
				object arg2 = ToLua.ToVarObject(L, 3);
				LuaInterface.Debugger.LogWarning(arg0, arg1, arg2);
				return 0;
			}
			else if (count == 4 && TypeChecker.CheckTypes<string, object, object, object>(L, 1))
			{
				string arg0 = ToLua.ToString(L, 1);
				object arg1 = ToLua.ToVarObject(L, 2);
				object arg2 = ToLua.ToVarObject(L, 3);
				object arg3 = ToLua.ToVarObject(L, 4);
				LuaInterface.Debugger.LogWarning(arg0, arg1, arg2, arg3);
				return 0;
			}
			else if (TypeChecker.CheckTypes<string>(L, 1) && TypeChecker.CheckParamsType<object>(L, 2, count - 1))
			{
				string arg0 = ToLua.ToString(L, 1);
				object[] arg1 = ToLua.ToParamsObject(L, 2, count - 1);
				LuaInterface.Debugger.LogWarning(arg0, arg1);
				return 0;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to method: LuaInterface.Debugger.LogWarning");
			}
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int LogError(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 1 && TypeChecker.CheckTypes<string>(L, 1))
			{
				string arg0 = ToLua.ToString(L, 1);
				LuaInterface.Debugger.LogError(arg0);
				return 0;
			}
			else if (count == 1 && TypeChecker.CheckTypes<object>(L, 1))
			{
				object arg0 = ToLua.ToVarObject(L, 1);
				LuaInterface.Debugger.LogError(arg0);
				return 0;
			}
			else if (count == 2 && TypeChecker.CheckTypes<string, object>(L, 1))
			{
				string arg0 = ToLua.ToString(L, 1);
				object arg1 = ToLua.ToVarObject(L, 2);
				LuaInterface.Debugger.LogError(arg0, arg1);
				return 0;
			}
			else if (count == 3 && TypeChecker.CheckTypes<string, object, object>(L, 1))
			{
				string arg0 = ToLua.ToString(L, 1);
				object arg1 = ToLua.ToVarObject(L, 2);
				object arg2 = ToLua.ToVarObject(L, 3);
				LuaInterface.Debugger.LogError(arg0, arg1, arg2);
				return 0;
			}
			else if (count == 4 && TypeChecker.CheckTypes<string, object, object, object>(L, 1))
			{
				string arg0 = ToLua.ToString(L, 1);
				object arg1 = ToLua.ToVarObject(L, 2);
				object arg2 = ToLua.ToVarObject(L, 3);
				object arg3 = ToLua.ToVarObject(L, 4);
				LuaInterface.Debugger.LogError(arg0, arg1, arg2, arg3);
				return 0;
			}
			else if (TypeChecker.CheckTypes<string>(L, 1) && TypeChecker.CheckParamsType<object>(L, 2, count - 1))
			{
				string arg0 = ToLua.ToString(L, 1);
				object[] arg1 = ToLua.ToParamsObject(L, 2, count - 1);
				LuaInterface.Debugger.LogError(arg0, arg1);
				return 0;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to method: LuaInterface.Debugger.LogError");
			}
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int LogException(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 1)
			{
				System.Exception arg0 = (System.Exception)ToLua.CheckObject<System.Exception>(L, 1);
				LuaInterface.Debugger.LogException(arg0);
				return 0;
			}
			else if (count == 2)
			{
				string arg0 = ToLua.CheckString(L, 1);
				System.Exception arg1 = (System.Exception)ToLua.CheckObject<System.Exception>(L, 2);
				LuaInterface.Debugger.LogException(arg0, arg1);
				return 0;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to method: LuaInterface.Debugger.LogException");
			}
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_useLog(IntPtr L)
	{
		try
		{
			LuaDLL.lua_pushboolean(L, LuaInterface.Debugger.useLog);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_threadStack(IntPtr L)
	{
		try
		{
			LuaDLL.lua_pushstring(L, LuaInterface.Debugger.threadStack);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_logger(IntPtr L)
	{
		try
		{
			ToLua.PushObject(L, LuaInterface.Debugger.logger);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_useLog(IntPtr L)
	{
		try
		{
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			LuaInterface.Debugger.useLog = arg0;
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_threadStack(IntPtr L)
	{
		try
		{
			string arg0 = ToLua.CheckString(L, 2);
			LuaInterface.Debugger.threadStack = arg0;
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_logger(IntPtr L)
	{
		try
		{
			LuaInterface.ILogger arg0 = (LuaInterface.ILogger)ToLua.CheckObject<LuaInterface.ILogger>(L, 2);
			LuaInterface.Debugger.logger = arg0;
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}
}

