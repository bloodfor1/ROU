using Cinemachine;
using DG.Tweening;
using FMODUnity;
using MoonCommonLib;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;
using UnityEngine.UI;

#if UNITY_EDITOR

public class MCutSceneShotHelper : MonoBehaviour, ICutSceneShotHelper
{
    public bool Deprecated { get; set; }

    private static MCutSceneShotHelper _Instance = null;

    public void Init()
    {
        if (_Instance == null)
        {
            _Instance = this;
            MInterfaceMgr.singleton.DetachInterface(MCommonFunctions.GetHash("MCutSceneShotHelper"));
            MInterfaceMgr.singleton.AttachInterface<ICutSceneShotHelper>(MCommonFunctions.GetHash("MCutSceneShotHelper"), _Instance);
        }
    }

    void Awake()
    {
        Init();
    }

    void OnDestroy()
    {
        _Instance = null;
    }


    //加载特效
    private GameObject loadFx(string path)
    {
        if (string.IsNullOrEmpty(path))
            return null;
        GameObject fx = null;
        fx = MResMgr.singleton.AdbLoad<GameObject>(path, MResMgr.SUFFIX_PREFAB);
        if (fx != null)
        {
            fx = GameObject.Instantiate<GameObject>(fx);
        }

        if (fx != null)
        {
            foreach (var anim in fx.GetComponentsInChildren<Animator>())
            {
                anim.cullingMode = AnimatorCullingMode.AlwaysAnimate;
            }
        }
        return fx;
    }

    /// <summary>
    /// 播放动画机
    /// </summary>
    /// <param name="go"></param>
    private void playAnimator(GameObject go)
    {
        Animator[] amts = go.transform.GetComponentsInChildren<Animator>();
        foreach (var am in amts)
        {
            am.enabled = true;
            am.cullingMode = AnimatorCullingMode.AlwaysAnimate;
        }
    }

    public void UpdateRotation(GameObject go, Quaternion rotation)
    {
        go.transform.localRotation = rotation;
    }

    public void UpdateScale(GameObject go, Vector3 scale)
    {
        go.transform.localScale = scale;
    }
    public void UpdatePosition(GameObject go, Vector3 postion)
    {
        go.transform.localPosition = postion;
    }

    private Texture2D getFaceTex(Animator ator, int fid)
    {
        Texture2D faceTex = null;
        if (ator.avatar != null)
        {
            if (ator.avatar.name.Contains("_M_"))
            {
                faceTex = MResMgr.singleton.AdbLoad<Texture2D>($"Equipments/Common_M_Default_Head_{fid}", MResMgr.SUFFIX_TGA);
            }
            else if (ator.avatar.name.Contains("_F_"))
            {
                faceTex = MResMgr.singleton.AdbLoad<Texture2D>($"Equipments/Common_F_Default_Head_{fid}", MResMgr.SUFFIX_TGA);
            }
        }
        return faceTex;
    }

    public void SetEmotion(int modelIndex, int faceId, int eyeEmoId, int mouthEmoId)
    {
#if UNITY_EDITOR && UNITY_STANDALONE_WIN
        Transform model = MoonClient.MCutSceneHelper.GetParent(GameObject.Find("CutSceneRoot"), MoonClient.CSobjType.Model, modelIndex);
        if (model)
        {
            var _mesh = model.gameObject.GetComponent<SkinnedMeshRenderer>();
            var _ator = model.gameObject.GetComponent<Animator>();
            if (_mesh && _mesh.sharedMaterial && _ator)
            {
                //改纹理
                Texture2D faceTex = getFaceTex(_ator, faceId);
                _mesh.sharedMaterial.SetTexture("_Tex0", faceTex);
                if (eyeEmoId >= 0)
                {
                    //换眼睛
                    _mesh.sharedMaterial.SetInt("_EmotionID", eyeEmoId);
                }
                if (mouthEmoId >= 0)
                {
                    //换嘴巴
                    _mesh.sharedMaterial.SetInt("_EmotionID2", mouthEmoId);
                }
            }
        }
#endif
    }

    private Transform _getParentTrans()
    {
        return GameObject.Find("CutSceneImageController").transform;
    }

    private Transform _getImageTrans(int id)
    {
        return _getParentTrans().Find($"Image/Image{id}");
    }

    public void ActiveImageById(int id, object o)
    {
        var obj = _getImageTrans(id);
        if (obj == null) return;

        var proxy = MInterfaceMgr.singleton.GetInterface<IMCinemachine>(MCommonFunctions.GetHash("MCinemachine"));
        if (proxy == null) return;

        foreach (var com in obj.GetComponents<DOTweenAnimation>())
        {
            com.DOKill();
        }

        obj.gameObject.SetActiveEx(true);
    }

    public void UpdateImageById(int id, float time)
    {
        var obj = _getImageTrans(id);
        if (obj == null) return;
        foreach (var com in obj.GetComponents<DOTweenAnimation>())
        {
            if (com.tween == null)
                com.CreateTween();
            if (com.tween == null)
                continue;
            var cur = time - com.delay;
            com.tween.fullPosition = cur;
        }
    }

    public void HideImageById(int id)
    {
        var obj = _getImageTrans(id);
        if (obj == null) return;
        foreach (var com in obj.GetComponents<DOTweenAnimation>())
        {
            com.DORewind();
        }

        obj.gameObject.SetActiveEx(false);
    }

    private GameObject _findBlackCurtainObj()
    {
        return GameObject.Find("BlackCurtainObj");
    }

    public void ShowBlackCurtain(int blackCurtainId, float fadeInTime, float showTime, float fadeOutTime)
    {

        var old = _findBlackCurtainObj();
        if (old != null) return;

        var parent = GameObject.Find("UIRoot/TopLayer");

        var go = new GameObject("BlackCurtainObj");
        go.transform.SetParent(parent.transform);
        go.transform.SetLocalScaleOne();
        go.transform.SetPositionAndRotation(Vector3.zero, Quaternion.identity);
        var image = go.AddComponent<RawImage>();
        image.color = Color.black;

        var rect = go.GetComponent<RectTransform>();
        if (rect == null)
        {
            rect = go.AddComponent<RectTransform>();
        }

        rect.sizeDelta = new Vector2(5000, 5000);
        go.SetActive(true);

        var childGo = new GameObject();
        childGo.transform.parent = go.transform;
        childGo.transform.SetLocalScaleOne();
        childGo.transform.SetPositionAndRotation(Vector3.zero, Quaternion.identity);
        var font = MResMgr.singleton.AdbLoad<Font>("UI/Font/Common", MResMgr.SUFFIX_FONT);
        var text = childGo.AddComponent<Text>();
        text.font = font;
        text.text = "黑幕...";
    }

    public void HideBlackCurtain()
    {
        var go = _findBlackCurtainObj();
        if (go != null)
        {
            DestroyImmediate(go);
        }
    }

    public void UpdateCinemachineDollyCart(Transform trans, float time)
    {
        if (trans == null) return;

        var camera = trans.GetComponent<CinemachineVirtualCamera>();
        if (camera == null) return;

        if (camera.Follow == null) return;

        var transpose = camera.GetCinemachineComponent<CinemachineTransposerDollyCart>();
        if (transpose == null) return;

        var dollyCart = camera.Follow.GetComponent<CinemachineDollyCart>();
        if (dollyCart == null) return;

        dollyCart.SetCartPositionByDeltaTime(time);
    }

    public void ResetCinemachineDollyCart(Transform trans, float startTime)
    {
        if (trans == null) return;

        var camera = trans.GetComponent<CinemachineVirtualCamera>();
        if (camera == null) return;

        if (camera.Follow == null) return;

        var transpose = camera.GetCinemachineComponent<CinemachineTransposerDollyCart>();
        if (transpose == null) return;

        var dollyCart = camera.Follow.GetComponent<CinemachineDollyCart>();
        if (dollyCart == null) return;

        if (dollyCart.ActiveCurveCtrl && dollyCart.CurveCtrl != null)
        {
            dollyCart.CurveCtrl.Time = startTime;
        }
    }

    public void PlaySound(string eventPath)
    {
        RuntimeManager.PlayOneShot(eventPath);
    }

    public void EndSound(string eventPath)
    {

    }

    public void DestroyFx(GameObject go)
    {
        if (go)
        {
            GameObject.DestroyImmediate(go);
            go = null;
        }
    }


    public GameObject LoadFx(string fxPath, Transform parent, Vector3 position, Quaternion rotation, Vector3 scale)
    {
        var fx = loadFx(fxPath);
        if (fx)
        {
            fx.transform.SetParent(parent?.transform);
            fx.transform.localPosition = position;
            fx.transform.localRotation = rotation;
            fx.transform.localScale = scale;
            playAnimator(fx);
        }
        return fx;
    }

}
#endif