using System.Collections;
using System.IO;
using System.Runtime.InteropServices;
using MoonCommonLib;
using MoonSerializable;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class GameLaunch : MonoBehaviour {
#if HDG_TEST
    private const string GAME_ENTRY_SCENE_NAME = "GameEntryHdg";
#else
    private const string GAME_ENTRY_SCENE_NAME = "GameEntry";
#endif

#if ENABLE_AUTOTEST
    private void AddPocoManager()
    {
        GameObject goPocoManager = new GameObject("PocoManager");
        DontDestroyOnLoad(goPocoManager);
        goPocoManager.AddComponent<PocoManager>();
    }
#endif

    public static bool NotShowLaunchMovieAtStart
    {
        get
        {
            var bundleId = MPlatformConfigManager.GetLocal().bundleId;
            if (bundleId.Equals("com.tencent.ro") || bundleId.Equals("com.joyyou.ro"))
                return true;
            return false;
        }
    }

    public RawImage logo;
    public GameObject gameRoot;
    private Camera gameCamera;
    private MPerformanceScoreTest _performanceScoreTest;

#if UNITY_IOS && !UNITY_EDITOR
    [DllImport("__Internal")]
    private static extern void iosPlayMovie();
#endif
    
    private void Awake()
    {
#if !(TRACE_LOG || UNITY_EDITOR)
        if (null != Debug.unityLogger)
        {
            Debug.unityLogger.filterLogType = LogType.Warning;
        }
#endif
#if (UWA_TEST)
        UWAEngine.SetOverrideLuaLib(LuaInterface.LuaDLL.LUADLL);
#endif

        gameCamera = Camera.main;
        logo.gameObject.SetActive(false);
    }

    public void StartLogo(){
        StartCoroutine(Play());
    }

    private void Start()
    {
#if !UNITY_EDITOR
        if (!MQualityGradeConditionChecker.Begin())
        {
            _performanceScoreTest = gameCamera.gameObject.AddComponent<MPerformanceScoreTest>();
            _performanceScoreTest.Reset();
        }
#endif

        if (NotShowLaunchMovieAtStart)
        {
            StartLogo();
        }
        else
        {
#if UNITY_IOS && !UNITY_EDITOR
            iosPlayMovie();
#else
            StartLogo();
#endif
        }
#if ENABLE_AUTOTEST
        AddPocoManager();
#endif
    }

    void Update () {
        if(_performanceScoreTest && _performanceScoreTest.CalculateCompelete)
        {
            ProcessPerformanceScoreTestFinish();
        }
    }

    private void ReleasePerformanceScoreTest()
    {
        if (_performanceScoreTest)
        {
            UnityEngine.Object.Destroy(_performanceScoreTest);
            _performanceScoreTest = null;
        }
    }

    private void ProcessPerformanceScoreTestFinish()
    {
        if (!_performanceScoreTest) return;

        MQualityGradeConditionChecker.ProcessScore(_performanceScoreTest.ScoreValue);
        ReleasePerformanceScoreTest();
    }

    private void ProcessFinish()
    {
        if(_performanceScoreTest && !_performanceScoreTest.CalculateCompelete)// 结束的时候性能跑分未完成，提前结束
        {
            ProcessPerformanceScoreTestFinish();
        }
        MQualityGradeConditionChecker.Stop();

        if (Application.isMobilePlatform && !MGameContext.singleton.IsEmulator)
        {
            MQualityResolution.singleton.InitResolution((int)MQualityGradeConditionChecker.GetGrade());
        }
        else
        {
            MQualityResolution.singleton.InitResolution(-1);
        }

    }


    IEnumerator Play()
    {
        logo.gameObject.SetActive(true);

        yield return new WaitForSecondsRealtime(2f);
        
        ProcessFinish();

#if UNITY_IOS || UNITY_ANDROID
        if (NotShowLaunchMovieAtStart)
        {
            Handheld.PlayFullScreenMovie("Movie/launch.mp4", Color.white, FullScreenMovieControlMode.Hidden, FullScreenMovieScalingMode.AspectFill);
            yield return new WaitForSecondsRealtime(0.5f);
        }
#endif

        logo.gameObject.SetActive(false);
        gameRoot.SetActive(true);

        GameObject.Destroy(gameObject);
    }
}
