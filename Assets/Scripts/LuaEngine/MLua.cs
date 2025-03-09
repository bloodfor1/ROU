//***************************

//文件名称(File Name)： MLua.cs 

//功能描述(Description)： Lua中间件

//数据表(Tables)： nothing

//作者(Author)： zzr

//Create Date: 2017.08.10

//修改记录(Revision History)： nothing

//***************************
using System;
using System.Collections.Generic;
using UnityEngine;
using MoonCommonLib;
using LuaInterface;

public class MLua : MonoBehaviour, IMLua
{
    private LuaState _lua;
    private IMLuaLoader _loader;
    private LuaLooper _looper = null;
    private IMLuaNetworkHelper _helper;

    public IMLuaNetworkHelper LuaNetworkHelper
    {
        get { return _helper; }
    }

    public bool Deprecated { get; set; }

    public bool Inited { get; private set; } = false;

    // Use this for initialization
    void Awake()
    {
#if UNITY_EDITOR
        LuaDLL.toluas_closeint64(IntPtr.Zero);
        LuaDLL.toluas_closeuint64(IntPtr.Zero);
#endif
        MInterfaceMgr.singleton.AttachInterface<IMLua>(MCommonFunctions.GetHash("MLua"), this);
    }
    public void Init()
    {
        _loader = MInterfaceMgr.singleton.GetInterface<IMLuaLoader>("MLuaLoader");
        _helper = MInterfaceMgr.singleton.GetInterface<IMLuaNetworkHelper>("MLuaNetworkHelper");

        _lua = new LuaState();

        LuaBinderOfMoonCommonLib.Bind(_lua);
        DelegateFactoryOfMoonCommonLib.Init();
        LuaBinderOfDefault.Bind(_lua);
        DelegateFactoryOfDefault.Init();
        MoonClientBridge.Bridge.BindLua(_lua);
        MoonClientBridge.Bridge.DelegateFactoryInit();

        this.OpenLibs();
        _lua.LuaSetTop(0);
        LuaCoroutine.Register(_lua, this);
        _loader.Init(_lua);

        _lua.Start();

        StartLooper();
        DoFile("Main.lua");
        Inited = true;
    }

    /// <summary>
    /// 初始化加载第三方库
    /// </summary>
    void OpenLibs()
    {
        _lua.OpenLibs(LuaDLL.luaopen_pb);
        _lua.OpenLibs(LuaDLL.luaopen_lpeg);
        _lua.OpenLibs(LuaDLL.luaopen_bit);
        _lua.OpenLibs(LuaDLL.luaopen_pb_io);
        _lua.OpenLibs(LuaDLL.luaopen_pb_conv);
        _lua.OpenLibs(LuaDLL.luaopen_pb_buffer);
        _lua.OpenLibs(LuaDLL.luaopen_pb_slice);
        _lua.OpenLibs(LuaDLL.luaopen_pb_new);

        OpenCJson();
#if (UNITY_EDITOR && UNITY_STANDALONE) || UNITY_ANDROID
        OpenLuaSocket();
#endif
    }

    //cjson 比较特殊，只new了一个table，没有注册库，这里注册一下
    protected void OpenCJson()
    {
        _lua.LuaGetField(LuaIndexes.LUA_REGISTRYINDEX, "_LOADED");
        _lua.OpenLibs(LuaDLL.luaopen_cjson);
        _lua.LuaSetField(-2, "cjson");

        _lua.OpenLibs(LuaDLL.luaopen_cjson_safe);
        _lua.LuaSetField(-2, "cjson.safe");

#if (UNITY_EDITOR && UNITY_STANDALONE)
        _lua.OpenLibs(LuaDLL.luaopen_snapshot);
        _lua.LuaSetField(-2, "snapshot");
#endif
    }

    protected void OpenLuaSocket()
    {
        _lua.BeginPreLoad();
        _lua.RegFunction("socket.core", LuaDLL.luaopen_socket_core);
        _lua.RegFunction("mime.core", LuaDLL.luaopen_mime_core);
        _lua.EndPreLoad();
    }

    void StartLooper()
    {
        _looper = gameObject.AddComponent<LuaLooper>();
        _looper.luaState = _lua;
    }

    public void DoFile(string filename)
    {
        if (_lua != null)
        {
            _lua.DoFile(filename);
        }
    }

    public T DoString<T>(string luascript, string chunkName = "LuaState.cs")
    {
        return _lua.DoString<T>(luascript, chunkName);
    }

    public void DoString(string luascript, string chunkName = "LuaState.cs")
    {
        _lua.DoString(luascript, chunkName);
    }

    public void Require(string filename)
    {
        _lua.Require(filename);
    }

    public int GetMemorySize()
    {
        return _lua.GetMemorySize();
    }

    public LuaTable GetTable(string fullPath, bool beLogMiss = true)
    {
        return _lua.GetTable(fullPath, beLogMiss);
    }
    
    public void SendMessageToLua(string eventName)
    {
        CallTableFunc<string>(null, "MUIEvent.ReceiveCSharpMessage", eventName);
    }
    public void SendMessageToLua<T1>(string eventName, T1 arg1)
    {
        CallTableFunc<string, T1>(null, "MUIEvent.ReceiveCSharpMessage", eventName, arg1);
    }
    public void SendMessageToLua<T1, T2>(string eventName, T1 arg1, T2 arg2)
    {
        CallTableFunc<string, T1, T2>(null, "MUIEvent.ReceiveCSharpMessage", eventName, arg1, arg2);
    }
    public void SendMessageToLua<T1, T2, T3>(string eventName, T1 arg1, T2 arg2, T3 arg3)
    {
        CallTableFunc<string, T1, T2, T3>(null, "MUIEvent.ReceiveCSharpMessage", eventName, arg1, arg2, arg3);
    }
    public void SendMessageToLua<T1, T2, T3, T4>(string eventName, T1 arg1, T2 arg2, T3 arg3, T4 arg4)
    {
        CallTableFunc<string, T1, T2, T3, T4>(null, "MUIEvent.ReceiveCSharpMessage", eventName, arg1, arg2, arg3, arg4);
    }
    public void SendMessageToLua<T1, T2, T3, T4, T5>(string eventName, T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5)
    {
        CallTableFunc<string, T1, T2, T3, T4, T5>(null, "MUIEvent.ReceiveCSharpMessage", eventName, arg1, arg2, arg3, arg4, arg5);
    }
    public void SendMessageToLua<T1, T2, T3, T4, T5, T6>(string eventName, T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6)
    {
        CallTableFunc<string, T1, T2, T3, T4, T5, T6>(null, "MUIEvent.ReceiveCSharpMessage", eventName, arg1, arg2, arg3, arg4, arg5, arg6);
    }
    public void SendMessageToLua<T1, T2, T3, T4, T5, T6, T7>(string eventName, T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6, T7 arg7)
    {
        CallTableFunc<string, T1, T2, T3, T4, T5, T6, T7>(null, "MUIEvent.ReceiveCSharpMessage", eventName, arg1, arg2, arg3, arg4, arg5, arg6, arg7);
    }
    

    public RT SendMessageToLua<RT>(string eventName)
    {
        return InvokeTableFunc<RT, string>(null, "MUIEvent.ReceiveCSharpMessage", eventName);
    }
    public RT SendMessageToLua<RT, T1>(string eventName, T1 arg1)
    {
        return InvokeTableFunc<RT, string, T1>(null, "MUIEvent.ReceiveCSharpMessage", eventName, arg1);
    }
    public RT SendMessageToLua<RT, T1, T2>(string eventName, T1 arg1, T2 arg2)
    {
        return InvokeTableFunc<RT, string, T1, T2>(null, "MUIEvent.ReceiveCSharpMessage", eventName, arg1, arg2);
    }
    public RT SendMessageToLua<RT, T1, T2, T3>(string eventName, T1 arg1, T2 arg2, T3 arg3)
    {
        return InvokeTableFunc<RT, string, T1, T2, T3>(null, "MUIEvent.ReceiveCSharpMessage", eventName, arg1, arg2, arg3);
    }
    public RT SendMessageToLua<RT, T1, T2, T3, T4>(string eventName, T1 arg1, T2 arg2, T3 arg3, T4 arg4)
    {
        return InvokeTableFunc<RT, string, T1, T2, T3, T4>(null, "MUIEvent.ReceiveCSharpMessage", eventName, arg1, arg2, arg3, arg4);
    }
    public RT SendMessageToLua<RT, T1, T2, T3, T4, T5>(string eventName, T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5)
    {
        return InvokeTableFunc<RT, string, T1, T2, T3, T4, T5>(null, "MUIEvent.ReceiveCSharpMessage", eventName, arg1, arg2, arg3, arg4, arg5);
    }
    public RT SendMessageToLua<RT, T1, T2, T3, T4, T5, T6>(string eventName, T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6)
    {
        return InvokeTableFunc<RT, string, T1, T2, T3, T4, T5, T6>(null, "MUIEvent.ReceiveCSharpMessage", eventName, arg1, arg2, arg3, arg4, arg5, arg6);
    }
    public RT SendMessageToLua<RT, T1, T2, T3, T4, T5, T6, T7>(string eventName, T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6, T7 arg7)
    {
        return InvokeTableFunc<RT, string, T1, T2, T3, T4, T5, T6, T7>(null, "MUIEvent.ReceiveCSharpMessage", eventName, arg1, arg2, arg3, arg4, arg5, arg6, arg7);
    }


    public void SendEventToLua(string eventName)
    {
        CallTableFunc(null, "MUIEvent.SendLuaEvent", eventName);
    }
    public void SendEventToLua<T1>(string eventName, T1 arg1)
    {
        CallTableFunc(null, "MUIEvent.SendLuaEvent", eventName, arg1);
    }
    public void SendEventToLua<T1, T2>(string eventName, T1 arg1, T2 arg2)
    {
        CallTableFunc(null, "MUIEvent.SendLuaEvent", eventName, arg1, arg2);
    }
    public void SendEventToLua<T1, T2, T3>(string eventName, T1 arg1, T2 arg2, T3 arg3)
    {
        CallTableFunc(null, "MUIEvent.SendLuaEvent", eventName, arg1, arg2, arg3);
    }
    public void SendEventToLua<T1, T2, T3, T4>(string eventName, T1 arg1, T2 arg2, T3 arg3, T4 arg4)
    {
        CallTableFunc(null, "MUIEvent.SendLuaEvent", eventName, arg1, arg2, arg3, arg4);
    }
    public void SendEventToLua<T1, T2, T3, T4, T5>(string eventName, T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5)
    {
        CallTableFunc(null, "MUIEvent.SendLuaEvent", eventName, arg1, arg2, arg3, arg4, arg5);
    }
    public void SendEventToLua<T1, T2, T3, T4, T5, T6>(string eventName, T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6)
    {
        CallTableFunc(null, "MUIEvent.SendLuaEvent", eventName, arg1, arg2, arg3, arg4, arg5, arg6);
    }
    public void SendEventToLua<T1, T2, T3, T4, T5, T6, T7>(string eventName, T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6, T7 arg7)
    {
        CallTableFunc(null, "MUIEvent.SendLuaEvent", eventName, arg1, arg2, arg3, arg4, arg5, arg6, arg7);
    }


    public TR InvokeTableFunc<TR>(string tableName, string funcName)
    {
        if (_lua == null)
        {
            return default(TR);
        }

        TR ret = default(TR);
        LuaTable table = null;
        LuaFunction func = null;
        if (!string.IsNullOrEmpty(tableName))
        {
            table = _lua.GetTable(tableName);
            if (table != null)
            {
                func = table.GetLuaFunction(funcName);
            }
        }
        if (func == null)
        {
            func = _lua.GetFunction(funcName);
        }

        if (func != null)
        {
            if (table == null)
            {
                ret = func.Invoke<TR>();
            }
            else
            {
                ret = func.Invoke<LuaTable, TR>(table);
            }
            
            func.Dispose();
            func = null;
            return ret;
        }
        if (table != null)
        {
            table.Dispose();
            table = null;
        }
        return ret;
    }
    public TR InvokeTableFunc<TR, T1>(string tableName, string funcName, T1 arg1)
    {
        if (_lua == null)
        {
            return default(TR);
        }

        TR ret = default(TR);
        LuaTable table = null;
        LuaFunction func = null;
        if (!string.IsNullOrEmpty(tableName))
        {
            table = _lua.GetTable(tableName);
            if (table != null)
            {
                func = table.GetLuaFunction(funcName);
            }
        }
        if (func == null)
        {
            func = _lua.GetFunction(funcName);
        }

        if (func != null)
        {
            if (table == null)
            {
                ret = func.Invoke<T1, TR>(arg1);
            }
            else
            {
                ret = func.Invoke<LuaTable, T1, TR>(table, arg1);
            }
            func.Dispose();
            func = null;
            return ret;
        }
        if (table != null)
        {
            table.Dispose();
            table = null;
        }
        return ret;
    }
    public TR InvokeTableFunc<TR, T1, T2>(string tableName, string funcName, T1 arg1, T2 arg2)
    {
        if (_lua == null)
        {
            return default(TR);
        }

        TR ret = default(TR);
        LuaTable table = null;
        LuaFunction func = null;
        if (!string.IsNullOrEmpty(tableName))
        {
            table = _lua.GetTable(tableName);
            if (table != null)
            {
                func = table.GetLuaFunction(funcName);
            }   
        }
        if (func == null)
        {
            func = _lua.GetFunction(funcName);
        }   

        if (func != null)
        {
            if (table == null)
            {
                ret = func.Invoke<T1, T2, TR>(arg1, arg2);
            }
            else
            {
                ret = func.Invoke<LuaTable, T1, T2, TR>(table, arg1, arg2);
            }
            func.Dispose();
            func = null;
            return ret;
        }
        if (table != null)
        {
            table.Dispose();
            table = null;
        }
        return ret;
    }
    public TR InvokeTableFunc<TR, T1, T2, T3>(string tableName, string funcName, T1 arg1, T2 arg2, T3 arg3)
    {
        if (_lua == null)
        {
            return default(TR);
        }

        TR ret = default(TR);
        LuaTable table = null;
        LuaFunction func = null;
        if (!string.IsNullOrEmpty(tableName))
        {
            table = _lua.GetTable(tableName);
            if (table != null)
            {
                func = table.GetLuaFunction(funcName);
            }
        }
        if (func == null)
        {
            func = _lua.GetFunction(funcName);
        }   

        if (func != null)
        {
            if (table == null)
            {
                ret = func.Invoke<T1, T2, T3, TR>(arg1, arg2, arg3);
            }
            else
            {
                ret = func.Invoke<LuaTable, T1, T2, T3, TR>(table, arg1, arg2, arg3);
            }
            func.Dispose();
            func = null;
            return ret;
        }
        if (table != null)
        {
            table.Dispose();
            table = null;
        }
        return ret;
    }
    public TR InvokeTableFunc<TR, T1, T2, T3, T4>(string tableName, string funcName, T1 arg1, T2 arg2, T3 arg3, T4 arg4)
    {
        if (_lua == null)
        {
            return default(TR);
        }

        TR ret = default(TR);
        LuaTable table = null;
        LuaFunction func = null;
        if (!string.IsNullOrEmpty(tableName))
        {
            table = _lua.GetTable(tableName);
            if (table != null)
            {
                func = table.GetLuaFunction(funcName);
            }
        }
        if (func == null)
        {
            func = _lua.GetFunction(funcName);
        }   

        if (func != null)
        {
            if (table == null)
            {
                ret = func.Invoke<T1, T2, T3, T4, TR>(arg1, arg2, arg3, arg4);
            }
            else
            {
                ret = func.Invoke<LuaTable, T1, T2, T3, T4, TR>(table, arg1, arg2, arg3, arg4);
            }
            func.Dispose();
            func = null;
            return ret;
        }
        if (table != null)
        {
            table.Dispose();
            table = null;
        }
        return ret;
    }
    public TR InvokeTableFunc<TR, T1, T2, T3, T4, T5>(string tableName, string funcName, T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5)
    {
        if (_lua == null)
        {
            return default(TR);
        }

        TR ret = default(TR);
        LuaTable table = null;
        LuaFunction func = null;
        if (!string.IsNullOrEmpty(tableName))
        {
            table = _lua.GetTable(tableName);
            if (table != null)
            {
                func = table.GetLuaFunction(funcName);
            }   
        }
        if (func == null)
        {
            func = _lua.GetFunction(funcName);
        }   

        if (func != null)
        {
            if (table == null)
            {
                ret = func.Invoke<T1, T2, T3, T4, T5, TR>(arg1, arg2, arg3, arg4, arg5);
            }
            else
            {
                ret = func.Invoke<LuaTable, T1, T2, T3, T4, T5, TR>(table, arg1, arg2, arg3, arg4, arg5);
            }
            func.Dispose();
            func = null;
            return ret;
        }
        if (table != null)
        {
            table.Dispose();
            table = null;
        }
        return ret;
    }
    public TR InvokeTableFunc<TR, T1, T2, T3, T4, T5, T6>(string tableName, string funcName, T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6)
    {
        if (_lua == null)
        {
            return default(TR);
        }

        TR ret = default(TR);
        LuaTable table = null;
        LuaFunction func = null;
        if (!string.IsNullOrEmpty(tableName))
        {
            table = _lua.GetTable(tableName);
            if (table != null)
            {
                func = table.GetLuaFunction(funcName);
            }   
        }
        if (func == null)
        {
            func = _lua.GetFunction(funcName);
        }

        if (func != null)
        {
            if (table == null)
            {
                ret = func.Invoke<T1, T2, T3, T4, T5, T6, TR>(arg1, arg2, arg3, arg4, arg5, arg6);
            }
            else
            {
                ret = func.Invoke<LuaTable, T1, T2, T3, T4, T5, T6, TR>(table, arg1, arg2, arg3, arg4, arg5, arg6);
            }
            func.Dispose();
            func = null;
            return ret;
        }
        if (table != null)
        {
            table.Dispose();
            table = null;
        }
        return ret;
    }
    public TR InvokeTableFunc<TR, T1, T2, T3, T4, T5, T6, T7>(string tableName, string funcName, T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6, T7 arg7)
    {
        if (_lua == null)
        {
            return default(TR);
        }

        TR ret = default(TR);
        LuaTable table = null;
        LuaFunction func = null;
        if (!string.IsNullOrEmpty(tableName))
        {
            table = _lua.GetTable(tableName);
            if (table != null)
            {
                func = table.GetLuaFunction(funcName);
            }   
        }
        if (func == null)
        {
            func = _lua.GetFunction(funcName);
        }   

        if (func != null)
        {
            if (table == null)
            {
                ret = func.Invoke<T1, T2, T3, T4, T5, T6, T7, TR>(arg1, arg2, arg3, arg4, arg5, arg6, arg7);
            }
            else
            {
                ret = func.Invoke<LuaTable, T1, T2, T3, T4, T5, T6, T7, TR>(table, arg1, arg2, arg3, arg4, arg5, arg6, arg7);
            }
            func.Dispose();
            func = null;
            return ret;
        }
        if (table != null)
        {
            table.Dispose();
            table = null;
        }
        return ret;
    }
    public TR InvokeTableFunc<TR, T1, T2, T3, T4, T5, T6, T7, T8>(string tableName, string funcName, T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6, T7 arg7, T8 arg8)
    {
        if (_lua == null)
        {
            return default(TR);
        }

        TR ret = default(TR);
        LuaTable table = null;
        LuaFunction func = null;
        if (!string.IsNullOrEmpty(tableName))
        {
            table = _lua.GetTable(tableName);
            if (table != null)
            {
                func = table.GetLuaFunction(funcName);
            }
        }
        if (func == null)
        {
            func = _lua.GetFunction(funcName);
        }   

        if (func != null)
        {
            if (table == null)
            {
                ret = func.Invoke<T1, T2, T3, T4, T5, T6, T7, T8, TR>(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8);
            }
            else
            {
                ret = func.Invoke<LuaTable, T1, T2, T3, T4, T5, T6, T7, T8, TR>(table, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8);
            }
            func.Dispose();
            func = null;
            return ret;
        }
        if (table != null)
        {
            table.Dispose();
            table = null;
        }
        return ret;
    }

    public void CallTableFunc(string tableName, string funcName)
    {
        if (_lua == null)
        {
            return;
        }

        LuaTable table = null;
        LuaFunction func = null;
        if (!string.IsNullOrEmpty(tableName))
        {
            table = _lua.GetTable(tableName);
            if (table != null)
            {
                func = table.GetLuaFunction(funcName);
            }   
        }
        if (func == null)
        {
            func = _lua.GetFunction(funcName);
        }

        if (func != null)
        {
            func.Call(table);
            func.Dispose();
            func = null;
            return;
        }
        if (table != null)
        {
            table.Dispose();
            table = null;
        }
    }
    public void CallTableFunc<T1>(string tableName, string funcName, T1 arg1)
    {
        if (_lua == null)
        {
            return;
        }

        LuaTable table = null;
        LuaFunction func = null;
        if (!string.IsNullOrEmpty(tableName))
        {
            table = _lua.GetTable(tableName);
            if (table != null)
            {
                func = table.GetLuaFunction(funcName);
            }
        }
        if (func == null)
        {
            func = _lua.GetFunction(funcName);
        }

        if (func != null)
        {
            if (table == null)
            {
                func.Call(arg1);
            }
            else
            {
                func.Call(table, arg1);
            }
            
            func.Dispose();
            func = null;
            return;
        }
        if (table != null)
        {
            table.Dispose();
            table = null;
        }
    }
    public void CallTableFunc<T1, T2>(string tableName, string funcName, T1 arg1, T2 arg2)
    {
        if (_lua == null)
        {
            return;
        }

        LuaTable table = null;
        LuaFunction func = null;
        if (!string.IsNullOrEmpty(tableName))
        {
            table = _lua.GetTable(tableName);
            if (table != null)
            {
                func = table.GetLuaFunction(funcName);
            }   
        }
        if (func == null)
        {
            func = _lua.GetFunction(funcName);
        }

        if (func != null)
        {
            if (table == null)
            {
                func.Call(arg1, arg2);
            }
            else
            {
                func.Call(table, arg1, arg2);
            }
            func.Dispose();
            func = null;
            return;
        }
        if (table != null)
        {
            table.Dispose();
            table = null;
        }
    }
    public void CallTableFunc<T1, T2, T3>(string tableName, string funcName, T1 arg1, T2 arg2, T3 arg3)
    {
        if (_lua == null)
        {
            return;
        }

        LuaTable table = null;
        LuaFunction func = null;
        if (!string.IsNullOrEmpty(tableName))
        {
            table = _lua.GetTable(tableName);
            if (table != null)
            {
                func = table.GetLuaFunction(funcName);
            }
        }
        if (func == null)
        {
            func = _lua.GetFunction(funcName);
        }

        if (func != null)
        {
            if (table == null)
            {
                func.Call(arg1, arg2, arg3);
            }
            else
            {
                func.Call(table, arg1, arg2, arg3);
            }
            func.Dispose();
            func = null;
            return;
        }
        if (table != null)
        {
            table.Dispose();
            table = null;
        }
    }
    public void CallTableFunc<T1, T2, T3, T4>(string tableName, string funcName, T1 arg1, T2 arg2, T3 arg3, T4 arg4)
    {
        if (_lua == null)
        {
            return;
        }

        LuaTable table = null;
        LuaFunction func = null;
        if (!string.IsNullOrEmpty(tableName))
        {
            table = _lua.GetTable(tableName);
            if (table != null)
            {
                func = table.GetLuaFunction(funcName);
            }
        }
        if (func == null)
        {
            func = _lua.GetFunction(funcName);
        }

        if (func != null)
        {
            if (table == null)
            {
                func.Call(arg1, arg2, arg3, arg4);
            }
            else
            {
                func.Call(table, arg1, arg2, arg3, arg4);
            }
            func.Dispose();
            func = null;
            return;
        }
        if (table != null)
        {
            table.Dispose();
            table = null;
        }
    }
    public void CallTableFunc<T1, T2, T3, T4, T5>(string tableName, string funcName, T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5)
    {
        if (_lua == null)
        {
            return;
        }

        LuaTable table = null;
        LuaFunction func = null;
        if (!string.IsNullOrEmpty(tableName))
        {
            table = _lua.GetTable(tableName);
            if (table != null)
            {
                func = table.GetLuaFunction(funcName);
            }
        }
        if (func == null)
        {
            func = _lua.GetFunction(funcName);
        }

        if (func != null)
        {
            if (table == null)
            {
                func.Call(arg1, arg2, arg3, arg4, arg5);
            }
            else
            {
                func.Call(table, arg1, arg2, arg3, arg4, arg5);
            }
            func.Dispose();
            func = null;
            return;
        }
        if (table != null)
        {
            table.Dispose();
            table = null;
        }
    }
    public void CallTableFunc<T1, T2, T3, T4, T5, T6>(string tableName, string funcName, T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6)
    {
        if (_lua == null)
        {
            return;
        }

        LuaTable table = null;
        LuaFunction func = null;
        if (!string.IsNullOrEmpty(tableName))
        {
            table = _lua.GetTable(tableName);
            if (table != null)
            {
                func = table.GetLuaFunction(funcName);
            }
        }
        if (func == null)
        {
            func = _lua.GetFunction(funcName);
        }

        if (func != null)
        {
            if (table == null)
            {
                func.Call(arg1, arg2, arg3, arg4, arg5, arg6);
            }
            else
            {
                func.Call(table, arg1, arg2, arg3, arg4, arg5, arg6);
            }
            func.Dispose();
            func = null;
            return;
        }
        if (table != null)
        {
            table.Dispose();
            table = null;
        }
    }
    public void CallTableFunc<T1, T2, T3, T4, T5, T6, T7>(string tableName, string funcName, T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6, T7 arg7)
    {
        if (_lua == null)
        {
            return;
        }

        LuaTable table = null;
        LuaFunction func = null;
        if (!string.IsNullOrEmpty(tableName))
        {
            table = _lua.GetTable(tableName);
            if (table != null)
            {
                func = table.GetLuaFunction(funcName);
            }   
        }
        if (func == null)
        {
            func = _lua.GetFunction(funcName);
        }

        if (func != null)
        {
            if (table == null)
            {
                func.Call(arg1, arg2, arg3, arg4, arg5, arg6, arg7);
            }
            else
            {
                func.Call(table, arg1, arg2, arg3, arg4, arg5, arg6, arg7);
            }
            func.Dispose();
            func = null;
            return;
        }
        if (table != null)
        {
            table.Dispose();
            table = null;
        }
    }
    public void CallTableFunc<T1, T2, T3, T4, T5, T6, T7, T8>(string tableName, string funcName, T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6, T7 arg7, T8 arg8)
    {
        if (_lua == null)
        {
            return;
        }

        LuaTable table = null;
        LuaFunction func = null;
        if (!string.IsNullOrEmpty(tableName))
        {
            table = _lua.GetTable(tableName);
            if (table != null)
            {
                func = table.GetLuaFunction(funcName);
            }   
        }
        if (func == null)
        {
            func = _lua.GetFunction(funcName);
        }

        if (func != null)
        {
            if (table == null)
            {
                func.Call(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8);
            }
            else
            {
                func.Call(table, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8);
            }
            func.Dispose();
            func = null;
            return;
        }
        if (table != null)
        {
            table.Dispose();
            table = null;
        }
    }

    public void CallFunc(string funcName)
    {
        CallTableFunc(null, funcName);
    }
    public void CallFunc<T1>(string funcName, T1 arg1)
    {
        CallTableFunc(null, funcName, arg1);
    }
    public void CallFunc<T1, T2>(string funcName, T1 arg1, T2 arg2)
    {
        CallTableFunc(null, funcName, arg1, arg2);
    }
    public void CallFunc<T1, T2, T3>(string funcName, T1 arg1, T2 arg2, T3 arg3)
    {
        CallTableFunc(null, funcName, arg1, arg2, arg3);
    }
    public void CallFunc<T1, T2, T3, T4>(string funcName, T1 arg1, T2 arg2, T3 arg3, T4 arg4)
    {
        CallTableFunc(null, funcName, arg1, arg2, arg3, arg4);
    }
    public void CallFunc<T1, T2, T3, T4, T5>(string funcName, T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5)
    {
        CallTableFunc(null, funcName, arg1, arg2, arg3, arg4, arg5);
    }
    public void CallFunc<T1, T2, T3, T4, T5, T6>(string funcName, T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6)
    {
        CallTableFunc(null, funcName, arg1, arg2, arg3, arg4, arg5, arg6);
    }
    public void CallFunc<T1, T2, T3, T4, T5, T6, T7>(string funcName, T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6, T7 arg7)
    {
        CallTableFunc(null, funcName, arg1, arg2, arg3, arg4, arg5, arg6, arg7);
    }
    public void CallFunc<T1, T2, T3, T4, T5, T6, T7, T8>(string funcName, T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6, T7 arg7, T8 arg8)
    {
        CallTableFunc(null, funcName, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8);
    }

    public TR InvokeFunc<TR>(string funcName)
    {
        return InvokeTableFunc<TR>(null, funcName);
    }
    public TR InvokeFunc<TR, T1>(string funcName, T1 arg1)
    {
        return InvokeTableFunc<TR, T1>(null, funcName, arg1);
    }
    public TR InvokeFunc<TR, T1, T2>(string funcName, T1 arg1, T2 arg2)
    {
        return InvokeTableFunc<TR, T1, T2>(null, funcName, arg1, arg2);
    }
    public TR InvokeFunc<TR, T1, T2, T3>(string funcName, T1 arg1, T2 arg2, T3 arg3)
    {
        return InvokeTableFunc<TR, T1, T2, T3>(null, funcName, arg1, arg2, arg3);
    }
    public TR InvokeFunc<TR, T1, T2, T3, T4>(string funcName, T1 arg1, T2 arg2, T3 arg3, T4 arg4)
    {
        return InvokeTableFunc<TR, T1, T2, T3, T4>(null, funcName, arg1, arg2, arg3, arg4);
    }
    public TR InvokeFunc<TR, T1, T2, T3, T4, T5>(string funcName, T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5)
    {
        return InvokeTableFunc<TR, T1, T2, T3, T4, T5>(null, funcName, arg1, arg2, arg3, arg4, arg5);
    }
    public TR InvokeFunc<TR, T1, T2, T3, T4, T5, T6>(string funcName, T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6)
    {
        return InvokeTableFunc<TR, T1, T2, T3, T4, T5, T6>(null, funcName, arg1, arg2, arg3, arg4, arg5, arg6);
    }
    public TR InvokeFunc<TR, T1, T2, T3, T4, T5, T6, T7>(string funcName, T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6, T7 arg7)
    {
        return InvokeTableFunc<TR, T1, T2, T3, T4, T5, T6, T7>(null, funcName, arg1, arg2, arg3, arg4, arg5, arg6, arg7);
    }
    public TR InvokeFunc<TR, T1, T2, T3, T4, T5, T6, T7, T8>(string funcName, T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6, T7 arg7, T8 arg8)
    {
        return InvokeTableFunc<TR, T1, T2, T3, T4, T5, T6, T7, T8>(null, funcName, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8);
    }

    public LuaFunction GetFunction(string tableName)
    {
        return _lua.GetFunction(tableName);
    }

    public void LuaGC()
    {
        if (_lua != null)
        {
            _lua.LuaGC(LuaGCOptions.LUA_GCCOLLECT);
        }
    }

    public void Uninit()
    {
        if (!Inited)
        {
            return;
        }

        //修复c#报错闪退问题
        try
        {
            CallFunc("Close");
        }
        catch (Exception e)
        {
            MDebug.singleton.AddErrorLogF("{0}", e.ConverToString());
        }

        //修复lua报错闪退问题
        if (_looper != null)
        {
            _looper.Destroy();
            _looper = null;
        }

        if (_loader != null)
        {
            _loader.Uninit();
            _loader = null;
        }

        if (_lua != null)
        {
            _lua.CloseLibs(LuaDLL.toluas_closeuint64);
            _lua.CloseLibs(LuaDLL.toluas_closeint64);
            _lua.Dispose();
            _lua = null;
        }

        Inited = false;
    }
}

