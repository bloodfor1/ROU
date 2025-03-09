//#if !PACKAGE_MODE
////using MoonClient;
//#if UNITY_EDITOR
//using UnityEditor;
//#endif
//#endif

////using KKSG;
//using MoonCommonLib;
////using ROGameLibs;
//using Random = UnityEngine.Random;
//using Vector3 = UnityEngine.Vector3;
//using System;
//using System.Reflection;
//using System.Collections;
//using System.Collections.Generic;
//using UnityEngine;


//public class TestAssembly : MonoBehaviour
//{
//#if !PACKAGE_MODE && UNITY_EDITOR || UNITY_STANDALONE_WIN
//    //   private delegate void MTestInputHandler(KeyCode keyCode);
//    private Dictionary<KeyCode, MethodInfo> _dictKeyCodeToHandler;
//    //是否将Scene同步到Game
//    private static bool syncSceneCameraToGame = false;
//#endif

//    // Use this for initialization
//    void Start()
//    {
//        //#if DEBUG
//        StartCoroutine(LoadFpsPanel());
//        //#endif
//#if !PACKAGE_MODE && UNITY_EDITOR
//        AddKeyCodeHandlerToHandler();
//        _testNum = testNum - 1;
//#endif
//    }

//#if !PACKAGE_MODE && (UNITY_EDITOR || UNITY_STANDALONE_WIN)

//    public float testNum;
//    private float _testNum;
//    // Update is called once per frame
//    void Update()
//    {
//        UpdateKeyCodeToHandler();
//#if !PACKAGE_MODE && UNITY_EDITOR
//        if (Mathf.Abs(testNum - _testNum) > Mathf.Epsilon)
//        {
//            _testNum = testNum;
//            //MEventMgr.singleton.FireGlobalEvent(MEventType.MGlobalEvent_Test_Assembly_Num_Change, _testNum);
//        }
//        //if (syncSceneCameraToGame && MScene.singleton.GameCamera != null)
//        //{
//        //    SceneView.lastActiveSceneView.AlignViewToObject(MScene.singleton.GameCamera.TransCam);
//        //    SceneView.lastActiveSceneView.camera.fieldOfView = MScene.singleton.GameCamera.Fov;
//        //    SceneView.lastActiveSceneView.Repaint();
//        //}
//#endif
//    }

//    #region KeyCodeHandler
//    private Dictionary<string, KeyCode> _dictStringToKeyCode;
//    void AddKeyCodeHandlerToHandler()
//    {
//        _dictStringToKeyCode = new Dictionary<string, KeyCode>();
//        foreach (KeyCode key in Enum.GetValues(typeof(KeyCode)))
//        {
//            string strKeyCode = key.ConverToString().ToLower();
//            if (!_dictStringToKeyCode.ContainsKey(strKeyCode))
//            {
//                _dictStringToKeyCode.Add(strKeyCode, key);
//            }
//            else
//            {
//                //   MDebug.singleton.AddErrorLog(strKeyCode);
//            }
//        }

//        BindingFlags bindingAttr = (
//                BindingFlags.Default
//                | BindingFlags.NonPublic
//                | BindingFlags.Public
//                | BindingFlags.Static
//                | BindingFlags.IgnoreReturn
//                //       | BindingFlags.Instance
//                | BindingFlags.DeclaredOnly
//            );
//        Type type = typeof(TestAssembly);
//        MethodInfo[] methods = type.GetMethods(bindingAttr);

//        KeyCode keyCode;
//        char[] splits = new char[] { '_' };
//        string strKeyCodeHandler = "KeyCodeHandler".ToLower();
//        _dictKeyCodeToHandler = new Dictionary<KeyCode, MethodInfo>();
//        foreach (var val in methods)
//        {
//            string[] splitArray = val.Name.SplitAndTrim(splits);
//            if (2 <= splitArray.Length && splitArray[0].ToLower() == strKeyCodeHandler)
//            {
//                for (int i = splitArray.Length - 1; i > 0; i--)
//                {
//                    string strKeycode = splitArray[i].ToLower();
//                    if (_dictStringToKeyCode.TryGetValue(strKeycode, out keyCode))
//                    {
//                        _dictKeyCodeToHandler.Add(keyCode, val);
//                    }
//                }
//            }
//        }
//    }

//    void UpdateKeyCodeToHandler()
//    {
//        if (null == _dictStringToKeyCode)
//        {
//            AddKeyCodeHandlerToHandler();
//        }
//        if (Input.GetKey(KeyCode.RightShift) || Input.GetKey(KeyCode.RightAlt))
//        {
//            foreach (var val in _dictKeyCodeToHandler)
//            {
//                if (Input.GetKeyDown(val.Key))
//                {
//                    val.Value.Invoke(this, new object[] { val.Key });
//                }
//            }
//        }
//    }

//    private static MObject.ObjectType[] types = new MObject.ObjectType[]
//    {
//        //MEntity.EntityType.Entity_Role,
//        //MEntity.EntityType.Entity_Npc,
//        //MEntity.EntityType.Entity_Monster,
//        MObject.ObjectType.Entity_Player
//    };

//    //static void KeyCodeHandler_L(KeyCode keyCode)
//    //{
//    //    var target = MEntityMgr.singleton.PlayerEntity;

//    //    int pos = UnityEngine.Random.Range(0, MEntityHeadColorInfo.singleton.dictTagToHairColorData.Count - 1);
//    //    int cnt = 0;
//    //    foreach(var val in MEntityHeadColorInfo.singleton.dictTagToHairColorData)
//    //    {
//    //        if(cnt == pos)
//    //        {
//    //            MEventMgr.singleton.FireEvent(MEventType.MEvent_HairColor_Change, target, val.Key);
//    //            break;
//    //        }
//    //        else
//    //        {
//    //            cnt++;
//    //        }
//    //    }


//    //    pos = UnityEngine.Random.Range(0, MEntityHeadColorInfo.singleton.dictTagToEyeColorData.Count - 1);
//    //    cnt = 0;
//    //    foreach (var val in MEntityHeadColorInfo.singleton.dictTagToEyeColorData)
//    //    {
//    //        if (cnt == pos)
//    //        {
//    //            MEventMgr.singleton.FireEvent(MEventType.MEvent_EyeColor_Change, target, val.Key);
//    //            break;
//    //        }
//    //        else
//    //        {
//    //            cnt++;
//    //        }
//    //    }

//    //}

//    static void KeyCodeHandler_Q(KeyCode k)
//    {
//        var player = MEntityMgr.singleton.PlayerEntity;
//        ulong uid = 10086;
//        var obj = MEntityMgr.singleton.GetObject(uid);
//        if (obj == null)
//        {
//            MPubVehicleMoveComponent.TestMode = true;
//            var vehicle = MEntityMgr.singleton.CreatePubVehicle(10086, 1, player.Position, player.Rotation);
//            vehicle.AddPassenger(player);
//            vehicle.MoveComp.SetStartTime(0);
//        }
//        else
//        {
//            obj.ToPubVehicle.RemovePassenger(player);
//            MEntityMgr.singleton.DeleteObject(obj);
//        }
//    }

//    static void KeyCodeHandler_T_Y(KeyCode keyCode)
//    {
//        if (null == MScene.singleton.GameCamera) return;

//        float sub = 100;
//        if (Input.GetKeyDown(KeyCode.T))
//        {
//            sub *= 1;
//        }
//        else if (Input.GetKeyDown(KeyCode.Y))
//        {
//            sub *= -1;
//        }
//        var camDisArgs = MEventPool<MCameraTargetDisEventArgs>.GetEvent();
//        camDisArgs.dis = MScene.singleton.GameCamera.Dis - sub * 0.01f;
//        camDisArgs.isImmediately = true;
//        camDisArgs.isPlayerModify = true;
//        MEventMgr.singleton.FireEvent(MEventType.MEvent_CamTargetDis, MScene.singleton.GameCamera, camDisArgs);
//    }

//    //static void KeyCodeHandler_U_I_O(KeyCode keyCode)
//    //{
//    //    var args = MEventPool<MHidingEventArgs>.GetEvent();
//    //    if (KeyCode.U == keyCode)
//    //    {
//    //        MPlatform platform = MInterfaceMgr.singleton.GetInterface<MPlatform>(nameof(MPlatform));
//    //        GVoiceSDK gvoice = platform.SDKList["GVoice"] as GVoiceSDK;
//    //        gvoice.StartRecording();
//    //    }
//    //    else if(KeyCode.I == keyCode)
//    //    {
//    //        MPlatform platform = MInterfaceMgr.singleton.GetInterface<MPlatform>(nameof(MPlatform));
//    //        GVoiceSDK gvoice = platform.SDKList["GVoice"] as GVoiceSDK;
//    //        gvoice.StopRecording();
//    //    }
//    //    else
//    //    {
//    //        type = MHidingEventArgs.MHidingEventType.Translucent;
//    //    }  
//    //}

//    static void KeyCodeHandler_A(KeyCode keyCode)
//    {
//#if UNITY_EDITOR
//        syncSceneCameraToGame = !syncSceneCameraToGame;
//#endif
//    }

//    #endregion

//#endif
//    #region FpsPanel
//    private IEnumerator LoadFpsPanel()
//    {
//        yield return new WaitForSeconds(10f);
//        if (MGameContext.singleton.IsDebug)
//        {
//            int maxLoopCnt = 10;
//            while(maxLoopCnt > 0)
//            {
//                maxLoopCnt--;
//                var resLoader = MInterfaceMgr.singleton.GetInterface<IResLoader>("MResLoader");
//                if (resLoader != null)
//                {
//                    resLoader.CreateObjAsync("UI/Prefabs/CSharp/FPS_Panel", ShowFpsCallBack, this, false);
//                    break;
//                }
//                else
//                {
//                    yield return new WaitForSeconds(5f);
//                }
//            }
//        }
//    }

//    private void ShowFpsCallBack(UnityEngine.Object obj, object cbOjb, uint taskId)
//    {
//        GameObject go = obj as GameObject;
//        if (!go)
//        {
//            var resLoader = MInterfaceMgr.singleton.GetInterface<IResLoader>("MResLoader");
//            resLoader.DestroyObj(go, false);
//        }
//        else
//        {
//            Transform testLayer = GetTestLayer();
//            go.transform.SetParent(testLayer, false);
//        }
//    }
//    #endregion

//    #region TestLayer
//    private readonly string Test_Layer_Name = "TestLayer";
//    private Transform _testLayerTransform;
//    private Transform GetTestLayer()
//    {
//        if (!_testLayerTransform)
//        {
//            _testLayerTransform = CreateTestLayer();
//        }
//        return _testLayerTransform;
//    }

//    private Transform CreateTestLayer()
//    {
//        GameObject testLayerGO = new GameObject(Test_Layer_Name);
//        Canvas curCanvas = testLayerGO.AddComponent<Canvas>();
//        curCanvas.overrideSorting = true;
//        curCanvas.sortingOrder = -100;

//        CanvasGroup curCanvasGroup = curCanvas.gameObject.AddComponent<CanvasGroup>();
//        curCanvasGroup.blocksRaycasts = true;
//        curCanvasGroup.interactable = false;

//        testLayerGO.layer = MLayer.ID_UI;
//        var uiRoot = GameObject.Find("UIRoot");
//        if (uiRoot)
//        {
//            testLayerGO.transform.SetParent(uiRoot.transform, false);
//        }
//        else
//        {
//            testLayerGO.transform.SetParent(null, false);
//            MDebug.singleton.AddWarningLogF("test assembly parent is null");
//        }

//        RectTransform rectTransform = testLayerGO.GetComponent<RectTransform>();
//        rectTransform.anchorMax = rectTransform.anchorMin = new Vector2(0, 1);
//        rectTransform.anchoredPosition = Vector2.zero;
//        //    rectTransform.position = Vector2.zero;
//        rectTransform.sizeDelta = Vector2.zero;
//        return testLayerGO.transform;
//    }
//    #endregion
//}

