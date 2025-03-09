// ****************************************************************************
//
// 文件名(File Name):              MScript.cs
//
// 功能描述(Description):          游戏入口文件（挂载在MGameRoot结点上）
//
// 数据表(Tables):                 nothing                         
//
// 作者(Author):                   tmgg
// 
// 日期(Create Date):              2017.08.07
//
// 修改记录(Revision History):     none
//                                         
// *****************************************************************************

using System;
using UnityEngine;
using MoonCommonLib;
using UnityEngine.Profiling;
using SDKLib;

public class MScript : MonoBehaviour, ICoroutine
{
    void Awake()
    {
        MProfiler.ResetProfile();
        Application.lowMemory += OnLowMemory;
        GameObject.DontDestroyOnLoad(gameObject);

        // bind platform
        MInterfaceMgr.singleton.AttachInterface<IMPlatform>(nameof(MPlatform),
            gameObject.GetComponent<MPlatform>());

        //ObbDownloader初始化
        MInterfaceMgr.singleton.AttachInterface<IMObbDownloader>(nameof(MObbDownloader), new MObbDownloader());
        // 热更初始化
        MInterfaceMgr.singleton.AttachInterface<IMHotUpdater>(nameof(MHotUpdater), new MHotUpdater());
        // 设备层初始化
        MInterfaceMgr.singleton.AttachInterface<IDevice>(nameof(MCommonLib2SDKLibBridge), new MCommonLib2SDKLibBridge());

        MShell.singleton.Awake(gameObject);
    }

    private float minNextClearTime = 0;
    private void OnLowMemory()
    {
        if (Time.time > minNextClearTime)
        {
#if DEBUG
            System.Text.StringBuilder sb = new System.Text.StringBuilder();

            sb.Append("Time.time:"); sb.AppendLine(Time.time.ToString());
            sb.Append("systemMemorySize:"); sb.AppendLine(SystemInfo.systemMemorySize.ToString());
            sb.Append("msystemMemorySize:"); sb.AppendLine(MSystemInfoUtil.GetSystemMemorySize().ToString());
            sb.Append("deviceModel:"); sb.AppendLine(SystemInfo.deviceModel);
            sb.Append("deviceName:"); sb.AppendLine(SystemInfo.deviceName);
            sb.Append("IsEmulator:"); sb.AppendLine(MGameContext.singleton.IsEmulator.ToString());
            sb.Append("graphicsDeviceType:"); sb.AppendLine(SystemInfo.graphicsDeviceType.ToString());
            sb.Append("GetTotalReservedMemoryLong:"); sb.Append(BitTranslateToMB(Profiler.GetTotalReservedMemoryLong()).ToString()); sb.AppendLine("MB");
            sb.Append("GetTotalUnusedReservedMemoryLong:"); sb.Append(BitTranslateToMB(Profiler.GetTotalUnusedReservedMemoryLong()).ToString()); sb.AppendLine("MB");
            sb.Append("GetTotalAllocatedMemoryLong:"); sb.Append(BitTranslateToMB(Profiler.GetTotalAllocatedMemoryLong()).ToString()); sb.AppendLine("MB");
            sb.Append("GetMonoUsedSizeLong:"); sb.Append(BitTranslateToMB(Profiler.GetMonoUsedSizeLong()).ToString()); sb.AppendLine("MB");
            sb.Append("GetMonoHeapSizeLong:"); sb.Append(BitTranslateToMB(Profiler.GetMonoHeapSizeLong()).ToString()); sb.AppendLine("MB");

            MDebug.singleton.AddErrorLog(sb.ToString());
#endif
            System.GC.Collect();

            minNextClearTime = Time.time + 600;
        }
    }
    private static long BitTranslateToMB(long size)
    {
        return (size >> 20);
    }

    // Use this for initialization
    void Start()
    {
        try
        {
            MShell.singleton.Start();
        }
        catch (Exception e)
        {
            MDebug.singleton.AddErrorLog(e.ToString());
        }

    }

    // Update is called once per frame
    void Update()
    {
        try
        {
            MShell.singleton.Update();
        }
        catch (Exception e)
        {
            MDebug.singleton.AddErrorLog(e.ToString());
        }
    }

    void LateUpdate()
    {
        try
        {
            MShell.singleton.LateUpdate();
        }
        catch (Exception e)
        {
            MDebug.singleton.AddErrorLog(e.ToString());
        }
    }

    void OnApplicationQuit()
    {
        try
        {
            if (Application.isMobilePlatform)
            {
                MDebug.singleton.AddWarningLogF("OnApplicationQuit");
            }
            else
            {
                MShell.singleton.Quit();
            }
        }
        catch (Exception e)
        {
            MDebug.singleton.AddErrorLog(e.ToString());
        }
    }

    void OnApplicationPause(bool pause)
    {
        try
        {
            if (pause)
            {
                MShell.singleton.PauseGame();
            }
            else
            {
                MShell.singleton.ResumeGame();
            }
        }
        catch (Exception e)
        {
            MDebug.singleton.AddErrorLog(e.ToString());
        }
    }

    private void OnDestroy()
    {
        try
        {
            if (!Application.isMobilePlatform)
            {
                Application.lowMemory -= OnLowMemory;
                MShell.singleton.Uninit();
            }
        }
        catch (Exception e)
        {
            MDebug.singleton.AddErrorLog(e.ToString());
        }
    }
}