using System;
using UnityEngine;
using LitJson;
using MoonCommonLib;
using SDKLib;
using SDKLib.SDKInterface;

public class MPlatform : MonoBehaviour, IMPlatform
{
    #region fields

    /// <summary>
    /// 特殊包处理器
    /// </summary>
    public ISpecialUser UserHandler { get; private set; }

    [SerializeField]
    [Header("是否全部使用正式流程")]
    private bool _isPublish = false;
    public bool IsPublish
    {
#if UNITY_EDITOR || UNITY_STANDALONE_WIN
        get { return _isPublish; }
#else
        get { return true; }
#endif
    }

    [SerializeField]
    private GameObject reporter;

    #endregion

    private void init()
    {
        MPlatformConfig config = MPlatformConfigManager.GetLocal();
        MDebug.singleton.AddGreenLog(JsonMapper.ToJson(config));

        if (!Application.isEditor)
        {
            reporter.SetActive(MGameContext.singleton.IsDebug);
        }
        else
        {
            reporter.SetActive(false);
        }

        SDKBridge.InitSDKBridgeList(config);
        SDKBridge.Awake();
    }

    void Awake()
    {
        // 初始化
        init();
        
        // 打点
        JsonData data = new JsonData
        {
            ["tag"] = (int)TagPoint.StartGame,
            ["status"] = true,
            ["msg"] = "",
            ["authorize"] = false,
            ["finish"] = false
        };
        SDKBridge.OnEvent(ESDKBridge.Statistics, ESDKName.GemStatistics, "DoStatistics", data.ToJson());
    }

    void Update()
    {
        try
        {
            SDKBridge.Update();
        }
        catch (Exception e)
        {
            MDebug.singleton.AddErrorLog(e.ToString());
        }
    }

    void OnDestroy()
    {
        SDKBridge.OnDestroy();
    }

    void OnApplicationPause(bool pause)
    {
        try
        {
            if (pause)
            {
                SDKBridge.OnPause();
            }
            else
            {
                SDKBridge.OnResume();
            }
        }
        catch (Exception e)
        {
            MDebug.singleton.AddErrorLog(e.ToString());
        }
    }


    public bool Deprecated { get; set; }
}