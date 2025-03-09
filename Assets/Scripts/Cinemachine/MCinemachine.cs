using System.Collections.Generic;
using MoonCommonLib;
using UnityEngine;
using UnityEngine.Playables;
using Cinemachine;
using UnityEngine.Timeline;
using Cinemachine.Timeline;
using DG.Tweening.Core;
using Spine.Unity;
using Spine.Unity.Playables;

//using UnityEngine.Rendering.PostProcessing;

public class MCinemachine : MonoBehaviour, IMCinemachine
{
    public enum TrackType
    {
        Animation,
        Cinemachine,
        MAnimation,
        SpineAnimation,
        SpineFlip,
    }

    private static MCinemachine _Instance = null;


    public bool Deprecated
    {
        get { return _Instance == null; }
        set { }
    }

    public void Init()
    {
        if (_Instance == null)
        {
            _Instance = this;
            MInterfaceMgr.singleton.AttachInterface<IMCinemachine>(MCommonFunctions.GetHash("MCinemachine"), _Instance);
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

    #region InnerFunc 
    //private PostProcessEffectSettings getEffectRd<T>(List<PostProcessEffectSettings> rds)
    //{
    //    for (int i = 0; i < rds.Count; i++)
    //    {
    //        if (rds[i] is T)
    //            return rds[i];
    //    }
    //    return null;
    //}

    #endregion



    public void AddCinemachineBrain(GameObject go)
    {
        if (!go.GetComponent<CinemachineBrain>())
        {
            go.AddComponent<CinemachineBrain>();
        }
    }

    public void DeleteCinemachineBrain(GameObject go)
    {
        CinemachineBrain comp = go.GetComponent<CinemachineBrain>();
        if (comp)
        {
            GameObject.DestroyImmediate(comp);
        }
    }

    public void AddCinemachineVirtualCamera(GameObject go)
    {
        if (!go.GetComponent<CinemachineVirtualCamera>())
        {
            go.AddComponent<CinemachineVirtualCamera>();
        }
    }

    public void AddPostProcessLayer(GameObject go)
    {
        //if (!go.GetComponent<PostProcessLayer>())
        //{
        //    PostProcessLayer pplayer = go.AddComponent<PostProcessLayer>();
        //    pplayer.volumeTrigger = go.transform;
        //    pplayer.volumeLayer = LayerMask.NameToLayer("PostProcess");
        //}
    }

    public void DeletePostProcessLayer(GameObject go)
    {
        //PostProcessLayer comp = go.GetComponent<PostProcessLayer>();
        //if (comp)
        //{
        //    GameObject.DestroyImmediate(comp);
        //}
    }

    public void AddPostProcessVolume(GameObject go)
    {
        //if (!go.GetComponent<PostProcessVolume>())
        //{
        //    PostProcessVolume pvcomp = go.AddComponent<PostProcessVolume>();
        //    pvcomp.priority = 1;
        //    pvcomp.isGlobal = true;
        //    pvcomp.profile = null;
        //}
    }

    public void DeletePostProcessVolume(GameObject go)
    {
        //if (HasPostProfile(go))
        //{
        //    PostProcessVolume comp = go.GetComponent<PostProcessVolume>();
        //    if (!MoonClientBridge.Bridge.IsCutSceneRes)
        //    {
        //        MResLoader.singleton.ReleaseSharedAsset(comp.profile);
        //    }
        //    comp.profile = null;
        //    GameObject.DestroyImmediate(comp);
        //}
    }

    public void DeletePostProfile(GameObject go)
    {
        //if (HasPostProfile(go))
        //{
        //    PostProcessVolume comp = go.GetComponent<PostProcessVolume>();
        //    MResLoader.singleton.ReleaseSharedAsset(comp.profile);
        //    comp.profile = null;
        //}
    }

    public void SetPostProcessVolume(GameObject go, string path)
    {
        //PostProcessVolume comp = go.GetComponent<PostProcessVolume>();
        //if (!comp)
        //{
        //    return;
        //}
        //if (string.IsNullOrEmpty(path))
        //{
        //    comp.profile = null;
        //    return;
        //}
        //if (MoonClientBridge.Bridge.IsCutSceneRes)
        //{
        //    comp.profile = Resources.Load<PostProcessProfile>(path);
        //}
        //else
        //{
        //    if (comp.profile.name != "")
        //    {
        //        MResLoader.singleton.ReleaseSharedAsset(comp.profile);
        //        comp.profile = null;
        //    }
        //    comp.profile = MResLoader.singleton.GetSharedAsset<PostProcessProfile>(path, MResMgr.SUFFIX_ASSET);
        //}
    }

    public void DeleteCinemachineVirtualCamera(GameObject go)
    {
        CinemachineVirtualCamera comp = go.GetComponent<CinemachineVirtualCamera>();
        if (comp)
        {
            GameObject.DestroyImmediate(comp);
        }
    }

    public bool IsCinemachineTrack(TrackAsset ta)
    {
        return (ta is CinemachineTrack);
    }

    public bool IsSpineAnimationTrack(TrackAsset ta)
    {
        return (ta is SpineAnimationStateTrack);
    }

    public bool IsSpineFlipTrack(TrackAsset ta)
    {
        return (ta is SpineSkeletonFlipTrack);
    }

    public void SetCamPos(GameObject go, Vector3 pos)
    {
        CinemachineBrain cbrain = go.GetComponent<CinemachineBrain>();
        if (cbrain == null)
            return;
        ICinemachineCamera virCam = cbrain.ActiveVirtualCamera;
        if (virCam == null)
        {
            go.transform.position = pos;
            return;
        }
        GameObject virGo = virCam.VirtualCameraGameObject;
        if (virGo == null)
            return;
        virGo.transform.position = pos;
    }

    public bool IsLoopShot(TimelineClip tlc)
    {
        return (tlc.asset is MLoopShot);
    }

    public void SetGenericBinding(PlayableDirector pd, TrackAsset track, GameObject mainCam)
    {
        pd.SetGenericBinding(track, mainCam.GetComponent<CinemachineBrain>());
    }

    public void SetGenericBinding(PlayableDirector pd, TrackAsset track, GameObject go, int trackType)
    {
        TrackType type = (TrackType) trackType;
        if (type == TrackType.SpineAnimation)
        {
            pd.SetGenericBinding(track, go.GetComponent<SkeletonAnimation>());
        }
        else if (type == TrackType.SpineFlip)
        {
            pd.SetGenericBinding(track, go.GetComponent<SkeletonAnimationPlayableHandle>());
        }
    }

    public void SetReferenceValue(PlayableDirector pd, TimelineClip tlc, GameObject go)
    {
        CinemachineShot cms = tlc.asset as CinemachineShot;
        pd.SetReferenceValue(cms.VirtualCamera.exposedName, go.GetComponent<CinemachineVirtualCamera>());
    }

    public void SetFocusDis(GameObject go, float dis)
    {
        //if (!HasPostProfile(go))
        //{
        //    return;
        //}
        //PostProcessVolume comp = go.GetComponent<PostProcessVolume>();
        //var effect = getEffectRd<DepthOfField>(comp.profile.settings);
        //if (effect == null)
        //    return;
        //DepthOfField df = (DepthOfField)effect;
        //df.focusDistance.value = dis;
    }

    public void SetFstop(GameObject go, float stopVal)
    {
        //if (!HasPostProfile(go))
        //{
        //    return;
        //}
        //PostProcessVolume comp = go.GetComponent<PostProcessVolume>();
        //var effect = getEffectRd<DepthOfField>(comp.profile.settings);
        //if (effect == null)
        //    return;
        //DepthOfField df = (DepthOfField)effect;
        //df.aperture.value = stopVal;
    }

    public void SetFocalLen(GameObject go, float len)
    {
        //if (!HasPostProfile(go))
        //{
        //    return;
        //}
        //PostProcessVolume comp = go.GetComponent<PostProcessVolume>();
        //var effect = getEffectRd<DepthOfField>(comp.profile.settings);
        //if (effect == null)
        //    return;
        //DepthOfField df = (DepthOfField)effect;
        //df.focalLength.value = len;
    }

    public void SetBloomIntensity(GameObject go, float val)
    {
        //if (!HasPostProfile(go))
        //{
        //    return;
        //}
        //PostProcessVolume comp = go.GetComponent<PostProcessVolume>();
        //var effect = getEffectRd<Bloom>(comp.profile.settings);
        //if (effect == null)
        //    return;
        //Bloom df = (Bloom)effect;
        //df.intensity.value = val;
    }

    public void SetBloomThreshold(GameObject go, float val)
    {
        //if (!HasPostProfile(go))
        //{
        //    return;
        //}
        //PostProcessVolume comp = go.GetComponent<PostProcessVolume>();
        //var effect = getEffectRd<Bloom>(comp.profile.settings);
        //if (effect == null)
        //    return;
        //Bloom df = (Bloom)effect;
        //df.threshold.value = val;
    }

    public void SetBloomSoftKnee(GameObject go, float val)
    {
        //if (!HasPostProfile(go))
        //{
        //    return;
        //}
        //PostProcessVolume comp = go.GetComponent<PostProcessVolume>();
        //var effect = getEffectRd<Bloom>(comp.profile.settings);
        //if (effect == null)
        //    return;
        //Bloom df = (Bloom)effect;
        //df.softKnee.value = val;
    }

    public void SetPostExposure(GameObject go, float val)
    {
        //if (!HasPostProfile(go))
        //{
        //    return;
        //}
        //PostProcessVolume comp = go.GetComponent<PostProcessVolume>();
        //var effect = getEffectRd<ColorGrading>(comp.profile.settings);
        //if (effect == null)
        //    return;
        //ColorGrading df = (ColorGrading)effect;
        //df.postExposure.value = val;
    }

    public void SetBloomRadius(GameObject go, float val)
    {
        //if (!HasPostProfile(go))
        //{
        //    return;
        //}
        //PostProcessVolume comp = go.GetComponent<PostProcessVolume>();
        //var effect = getEffectRd<Bloom>(comp.profile.settings);
        //if (effect == null)
        //    return;
        //Bloom df = (Bloom)effect;
        //df.diffusion.value = val;
    }

    public void SetRoGrayScaleExposure(GameObject go, float val)
    {
        var ppp = go.GetComponent<PostProcessingProxy>();

        if (!ppp)
        {
            ppp = go.AddComponent<PostProcessingProxy>();
        }

        ppp.Exposure(val);

        //if (!HasPostProfile(go))
        //{
        //    return;
        //}
        //PostProcessVolume comp = go.GetComponent<PostProcessVolume>();
        //var effect = getEffectRd<ROGrayScale>(comp.profile.settings);
        //if (effect == null)
        //    return;
        //ROGrayScale df = (ROGrayScale)effect;
        //df.exposure.value = val;
    }

    public void SetRoGrayScaleStrength(GameObject go, float val)
    {
        var ppp = go.GetComponent<PostProcessingProxy>();

        if (!ppp)
        {
            ppp = go.AddComponent<PostProcessingProxy>();
        }

        ppp.Desaturate(val);

        //if (!HasPostProfile(go))
        //{
        //    return;
        //}
        //PostProcessVolume comp = go.GetComponent<PostProcessVolume>();
        //var effect = getEffectRd<ROGrayScale>(comp.profile.settings);
        //if (effect == null)
        //    return;
        //ROGrayScale df = (ROGrayScale)effect;
        //df.strength.value = val;
    }

    public void SetRoWaveDistortStrength(GameObject go, float val)
    {
        var ppp = go.GetComponent<PostProcessingProxy>();

        if (!ppp)
        {
            ppp = go.AddComponent<PostProcessingProxy>();
        }

        ppp.WaveDistort(val);

        //if (!HasPostProfile(go))
        //{
        //    return;
        //}
        //PostProcessVolume comp = go.GetComponent<PostProcessVolume>();
        //var effect = getEffectRd<ROWaveDistort>(comp.profile.settings);
        //if (effect == null)
        //    return;
        //ROWaveDistort df = (ROWaveDistort)effect;
        //df.strength.value = val;
    }

    public void SetRoWaveDistortDensity(GameObject go, float val)
    {
        var ppp = go.GetComponent<PostProcessingProxy>();

        if (!ppp)
        {
            ppp = go.AddComponent<PostProcessingProxy>();
        }

        ppp._wvDensity = val;
        ppp.WaveDistort();
        //if (!HasPostProfile(go))
        //{
        //    return;
        //}
        //PostProcessVolume comp = go.GetComponent<PostProcessVolume>();
        //var effect = getEffectRd<ROWaveDistort>(comp.profile.settings);
        //if (effect == null)
        //    return;
        //ROWaveDistort df = (ROWaveDistort)effect;
        //df.density.value = val;
    }

    public void SetRoWaveDistortFrequency(GameObject go, float val)
    {
        var ppp = go.GetComponent<PostProcessingProxy>();

        if (!ppp)
        {
            ppp = go.AddComponent<PostProcessingProxy>();
        }

        ppp._wvFrequency = val;
        ppp.WaveDistort();
        //if (!HasPostProfile(go))
        //{
        //    return;
        //}
        //PostProcessVolume comp = go.GetComponent<PostProcessVolume>();
        //var effect = getEffectRd<ROWaveDistort>(comp.profile.settings);
        //if (effect == null)
        //    return;
        //ROWaveDistort df = (ROWaveDistort)effect;
        //df.frequency.value = val;
    }

    public void SetRoWaveDistortFade(GameObject go, float val)
    {
        var ppp = go.GetComponent<PostProcessingProxy>();

        if (!ppp)
        {
            ppp = go.AddComponent<PostProcessingProxy>();
        }

        ppp._wvFade = val;
        ppp.WaveDistort();
        //if (!HasPostProfile(go))
        //{
        //    return;
        //}
        //PostProcessVolume comp = go.GetComponent<PostProcessVolume>();
        //var effect = getEffectRd<ROWaveDistort>(comp.profile.settings);
        //if (effect == null)
        //    return;
        //ROWaveDistort df = (ROWaveDistort)effect;
        //df.fade.value = val;
    }

    public void SetRoWaveDistortRoundness(GameObject go, float val)
    {
        var ppp = go.GetComponent<PostProcessingProxy>();

        if (!ppp)
        {
            ppp = go.AddComponent<PostProcessingProxy>();
        }

        ppp._wvRoundness = val;
        ppp.WaveDistort();
        //if (!HasPostProfile(go))
        //{
        //    return;
        //}
        //PostProcessVolume comp = go.GetComponent<PostProcessVolume>();
        //var effect = getEffectRd<ROWaveDistort>(comp.profile.settings);
        //if (effect == null)
        //    return;
        //ROWaveDistort df = (ROWaveDistort)effect;
        //df.roundness.value = val;
    }

    public void SetRoRadialBlurStrength(GameObject go, float val)
    {
        var ppp = go.GetComponent<PostProcessingProxy>();

        if (!ppp)
        {
            ppp = go.AddComponent<PostProcessingProxy>();
        }

        ppp._rbStrength = val;
        ppp.RadialBlur();

        //if (!HasPostProfile(go))
        //{
        //    return;
        //}
        //PostProcessVolume comp = go.GetComponent<PostProcessVolume>();
        //var effect = getEffectRd<RORadialBlur>(comp.profile.settings);
        //if (effect == null)
        //    return;
        //RORadialBlur df = (RORadialBlur)effect;
        //df.strength.value = val;
    }

    public void SetRoRadialBlurSpread(GameObject go, float val)
    {
        var ppp = go.GetComponent<PostProcessingProxy>();

        if (!ppp)
        {
            ppp = go.AddComponent<PostProcessingProxy>();
        }

        ppp._rbDistance = val;
        ppp.RadialBlur();
        //if (!HasPostProfile(go))
        //{
        //    return;
        //}
        //PostProcessVolume comp = go.GetComponent<PostProcessVolume>();
        //var effect = getEffectRd<RORadialBlur>(comp.profile.settings);
        //if (effect == null)
        //    return;
        //RORadialBlur df = (RORadialBlur)effect;
        //df.spread.value = val;
    }

    public bool HasPostProfile(GameObject go)
    {
        return false;
        //PostProcessVolume comp = go.GetComponent<PostProcessVolume>();
        //return comp != null && comp.profile.name != "";
    }

    public T LoadAssetAtPath<T>(string path) where T : UnityEngine.Object
    {
#if UNITY_EDITOR
        return UnityEditor.AssetDatabase.LoadAssetAtPath<T>(path);
#else
        return null;
#endif
    }

    public void AddCinemachineDollyCart(GameObject go, int updateMethod, int positionUnits, float speed, AnimationCurve curve,
        float totalTime)
    {
        var com = go.AddComponent<CinemachineDollyCart>();
        com.m_PositionUnits = (CinemachinePathBase.PositionUnits)positionUnits;
        com.m_UpdateMethod = (CinemachineDollyCart.UpdateMethod)updateMethod;
        com.m_Speed = speed;
        com.ActiveCurveCtrl = curve != null;

        com.Signal = true;
        if (!com.ActiveCurveCtrl) return;

        com.CurveCtrl = new CinemachineDollyCartCtrlCurve()
        {
            Curve = curve,
            TotalTime = totalTime
        };
        com.Signal = false;
    }

    public void AttachCinemachineDollyCartPath(GameObject modelGo, GameObject pathGo)
    {
        var dollyCart = modelGo.GetComponent<CinemachineDollyCart>();
        if (dollyCart == null) return;

        var path = pathGo.GetComponent<CinemachinePath>();
        if (path == null) return;

        dollyCart.m_Path = path;
    }

    public void OnCinemachineShotStart(GameObject go)
    {
        if (!go) return;

        var camera = go.GetComponent<CinemachineVirtualCamera>();
        if (!camera || camera.Follow == null) return;

        var dollyCart = camera.Follow.GetComponent<CinemachineDollyCart>();
        if (!dollyCart) return;

        dollyCart.Signal = true;
    }

    public Component CreateCinemachinePathByConfig(GameObject go, Vector3[] positions, Vector3[] tangents, float[] rolls, int resolution)
    {
        var path = go.AddComponent<CinemachinePath>();

        var length = positions.Length;
        path.m_Waypoints = new CinemachinePath.Waypoint[length];
        for (int i = 0; i < length; i++)
        {
            path.m_Waypoints[i].position = positions[i];
            path.m_Waypoints[i].tangent = tangents[i];
            path.m_Waypoints[i].roll = rolls[i];
        }
        path.m_Looped = false;
        path.m_Resolution = Mathf.Max(resolution, 1);

        return path;
    }

    public bool GetCinemachinePathValue(Component c, float t, out Vector3 position, out Quaternion rotation)
    {
        position = Vector3.zero;
        rotation = Quaternion.identity;
        var path = c as CinemachinePath;
        if (path == null) return false;

        var distance = path.PathLength * t;
        var unit = path.NormalizeUnit(distance, CinemachinePathBase.PositionUnits.Distance);
        position = path.EvaluatePositionAtUnit(unit, CinemachinePathBase.PositionUnits.Distance);
        rotation = path.EvaluateOrientationAtUnit(unit, CinemachinePathBase.PositionUnits.Distance);

        return true;
    }

    public void InitImageTrackInitParams(GameObject go, int[] intValues, float[] floatValues, Vector3[] vecValues)
    {
        if (go == null || intValues == null || floatValues == null || vecValues == null) return;

        if (intValues.Length != floatValues.Length || intValues.Length != vecValues.Length) return;

        for (int i = 0; i < intValues.Length; i++)
        {
            var type = (DOTweenAnimationType)intValues[i];
            switch (type)
            {
                case DOTweenAnimationType.LocalMove:
                    go.transform.localPosition = vecValues[i];
                    break;
                case DOTweenAnimationType.LocalRotate:
                    go.transform.localEulerAngles = vecValues[i];
                    break;
                case DOTweenAnimationType.Fade:
                    var canvasGroup = go.GetComponent<CanvasGroup>();
                    if (canvasGroup != null)
                    {
                        canvasGroup.alpha = floatValues[i];
                    }

                    break;
                case DOTweenAnimationType.Scale:
                    go.transform.localScale = vecValues[i];
                    break;
            }
        }


    }

    public void AddCinemachinePath(GameObject camGo, GameObject pathGo)
    {
        if (camGo == null || pathGo == null)
            return;
        CinemachineVirtualCamera virCam = camGo.GetComponent<CinemachineVirtualCamera>();
        if (virCam == null)
            return;
        CinemachineTrackedDolly dolly = virCam.GetCinemachineComponent<CinemachineTrackedDolly>();
        if(dolly)
        {
            CinemachinePath cPath = pathGo.GetComponent<CinemachinePath>();
            if(cPath)
            {
                dolly.m_Path = cPath;
            }
        }
    }

    public void AddCinemachineFollow(GameObject camGo, GameObject followGo)
    {
        if (camGo == null || followGo == null)
            return;
        var virCam = camGo.GetComponent<CinemachineVirtualCamera>();
        if (virCam == null)
            return;
        virCam.Follow = followGo.transform;
    }

    public void AddCinemachineLook(GameObject camGo, GameObject lookGo)
    {
        if (camGo == null || lookGo == null)
            return;
        var virCam = camGo.GetComponent<CinemachineVirtualCamera>();
        if (virCam == null)
            return;
        virCam.LookAt = lookGo.transform;
    }

    public void SetCinemachinePriority(GameObject camGo, int priority)
    {
        if (camGo == null)
            return;
        var virCam = camGo.GetComponent<CinemachineVirtualCamera>();
        if (virCam == null)
            return;
        virCam.Priority = priority;
    }
}