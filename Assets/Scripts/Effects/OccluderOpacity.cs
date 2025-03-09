using UnityEngine;
using DG.Tweening;
//using MoonCommonLib;
//using MoonClient;
using System.Collections.Generic;

public class OccluderOpacity : MonoBehaviour
{

    [Range(0, 1), Tooltip("透明度")]
    public float finalOpacity = 0.25f;
    [Tooltip("通知半隐的对象")]
    public MeshRenderer[] targets;

#if ____
    private List<Material> sharedMaterials;//共享材质
    private List<MeshRenderer> meshRenderers;
    private List<Material> instMaterials;//实例化材质
    private List<Tweener> fadeAnimations;
    private bool _isOnTriggerEnter;

    private void Awake()
    {
        if (targets == null)
        {
            Destroy(this);
            return;
        }
        if (MGameContext.singleton.IsGameEditorMode)
        {
            sharedMaterials = new List<Material>();
            instMaterials = new List<Material>();
            meshRenderers = new List<MeshRenderer>();
            fadeAnimations = new List<Tweener>();
            isOpacityEnable = true;
        }
        else
        {
            sharedMaterials = MListPool<Material>.Get();
            instMaterials = MListPool<Material>.Get();
            meshRenderers = MListPool<MeshRenderer>.Get();
            fadeAnimations = MListPool<Tweener>.Get();
            EventSubscribe();
            if (SystemInfo.graphicsDeviceType == UnityEngine.Rendering.GraphicsDeviceType.OpenGLES2)
            {
                isOpacityEnable = false;
            }

            //isOpacityEnable = MQualityGradeSetting.IsGreaterOrEqual(QualityGradeType.Middle);
        }
        _isOnTriggerEnter = false;
        sharedMaterials.Clear();
        meshRenderers.Clear();
        for (int i = 0; i < targets.Length; i++)
        {
            MeshRenderer meshRenderer = targets[i];
            if (meshRenderer &&
                meshRenderer.sharedMaterial.shader.name.StartsWith("RO/Scene/AllInOne"))
            {
                Material mat = new Material(meshRenderer.sharedMaterial);//todo 使用资源池管理新的material
                instMaterials.Add(mat);
                SaveAndChangeTargetMaterial(meshRenderer);
            }
        }
    }

#region QualitySwitch
    private bool isOpacityEnable;
    protected void EventSubscribe()
    {
        MEventMgr.singleton.RegisterGlobalEvent(MEventType.MGlobalEvent_Quality_Level_Change, OnQualityChange);
    }
    protected void EventUnsubscribe()
    {
        MEventMgr.singleton.RemoveGlobalEvent(MEventType.MGlobalEvent_Quality_Level_Change, OnQualityChange);
    }

    private void OnQualityChange(IEventArg arg)
    {
        ApplyQualityGrade();
    }
    private void ApplyQualityGrade()
    {
        bool lastIsOpacityEnable = isOpacityEnable;
        isOpacityEnable = MQualityGradeSetting.IsGreaterOrEqual(QualityGradeType.Middle);//middle及以上机型开启半透
        if (isOpacityEnable == lastIsOpacityEnable)
        {
            return;
        }

        if (lastIsOpacityEnable)
        {
            KillFadeAnimations();
            for (int i = 0, iLen = meshRenderers.Count; i < iLen; i++)
            {
                ResumeMeshMaterial(i);
            }
            UpdateMeshEnable(!_isOnTriggerEnter);
        }
        else
        {
            UpdateMeshEnable(true);
            if (_isOnTriggerEnter)
            {
                for (int i = 0, iLen = meshRenderers.Count; i < iLen; i++)
                {
                    if (instMaterials[i])
                    {
                        instMaterials[i].SetFloat(Opacity_Property_ID, finalOpacity);
                        meshRenderers[i].sharedMaterial = instMaterials[i];
                    }
                }
            }
            else
            {
                for (int i = 0, iLen = meshRenderers.Count; i < iLen; i++)
                {
                    ResumeMeshMaterial(i);
                }
            }
        }

    }
#endregion

    private void OnDestroy()
    {
        if (!MGameContext.singleton.IsGameEditorMode)
        {
            for (int i = 0; i < instMaterials.Count; i++)
            {
                UnityEngine.Object.Destroy(instMaterials[i]);
            }
            MListPool<Material>.Release(instMaterials);
            MListPool<Material>.Release(sharedMaterials);
            MListPool<MeshRenderer>.Release(meshRenderers);
            KillFadeAnimations();
            MListPool<Tweener>.Release(fadeAnimations);
            fadeAnimations = null;
            sharedMaterials = null;
            meshRenderers = null;
            instMaterials = null;
            EventUnsubscribe();
        }
    }

    //进入区域启用渐隐
    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag(Main_Camera_Tag))
        {
            _isOnTriggerEnter = true;
            if (isOpacityEnable)
            {
                KillFadeAnimations();
                for (int i = 0, iLen = meshRenderers.Count; i < iLen; i++)
                {
                    meshRenderers[i].sharedMaterial = instMaterials[i];
                    DoFadeIn(instMaterials[i], finalOpacity, i, RecordTweener);
                }
            }
            else
            {
                UpdateMeshEnable(!_isOnTriggerEnter);
            }
        }
    }

    private void KillFadeAnimations()
    {
        for (int i = 0, iLen = fadeAnimations.Count; i < iLen; i++)
        {
            fadeAnimations[i].Kill(true);
        }
        fadeAnimations.Clear();
    }

    private static string Main_Camera_Tag = "MainCamera";
    //离开区域恢复原材质
    private void OnTriggerExit(Collider other)
    {
        if (other.CompareTag(Main_Camera_Tag))
        {
            _isOnTriggerEnter = false;
            if (isOpacityEnable)
            {
                KillFadeAnimations();
                for (int i = 0, iLen = meshRenderers.Count; i < iLen; i++)
                {
                    if (instMaterials[i] && sharedMaterials[i])
                    {
                        DoFadeOut(instMaterials[i], finalOpacity, i, ResumeMeshMaterial, RecordTweener);
                    }
                }
            }
            else
            {
                UpdateMeshEnable(!_isOnTriggerEnter);
            }
        }
    }

    void RecordTweener(int i, Tweener t)
    {
        fadeAnimations.Add(t);
    }

    //首次实例化自身半隐材质
    void SaveAndChangeTargetMaterial(MeshRenderer ms)
    {
        int id = sharedMaterials.Count;
        sharedMaterials.Add(ms.sharedMaterial);
        meshRenderers.Add(ms);
        CreateTransparentMaterial(instMaterials[id]);
    }

    //恢复原材质
    void ResumeMeshMaterial(int id)
    {
        if (meshRenderers[id] && sharedMaterials[id])
            meshRenderers[id].sharedMaterial = sharedMaterials[id];
    }

    void UpdateMeshEnable(bool isEnable)
    {
        for (int i = 0, iLen = meshRenderers.Count; i < iLen; i++)
        {
            meshRenderers[i].enabled = isEnable;
        }
    }

    //初次创建半隐材质
    static void CreateTransparentMaterial(Material material)
    {
        material.DisableKeyword("_ALPHAMODE_CUTOUT");
        material.EnableKeyword("_ALPHAMODE_OFF");
        material.SetOverrideTag("RenderType", "Transparent");
        if (material.renderQueue < 3000)
            material.renderQueue = 3000;

        material.SetFloat("_AlphaMode", 2);
        material.SetFloat("_SrcBlend", (float)UnityEngine.Rendering.BlendMode.SrcAlpha);
        material.SetFloat("_DstBlend", (float)UnityEngine.Rendering.BlendMode.OneMinusSrcAlpha);
        material.SetFloat("_ZWrite", 0);
    }

    //渐隐方法
    static void DoFadeIn(Material material, float finalOpacity, int id, System.Action<int, Tweener> forKilledTweener = null)
    {
        forKilledTweener?.Invoke(id,
            DOTween.To(v =>
            {
                if (material)
                {
                    material.SetFloat(Opacity_Property_ID, v);
                }
            }, 1, finalOpacity, 0.3f)
        );
    }

    private static bool IsImmidiately()
    {
        bool isImmidiately = false;
        if (!MGameContext.singleton.IsGameEditorMode)
        {
            if (MScene.singleton.GameCamera != null && MScene.singleton.GameCamera.CameraState == MCameraState.Npc)
            {
                isImmidiately = true;
            }
            else if (MCutSceneMgr.singleton.IsPlaying)
            {
                isImmidiately = true;
            }
            else
            {
                isImmidiately = true;
            }
        }
        else
        {
            isImmidiately = false;
        }
        return isImmidiately;
    }

    //恢复方法
    static void DoFadeOut(Material material, float finalOpacity, int id, System.Action<int> onComplete, System.Action<int, Tweener> forKilledTweener = null)
    {
        if (IsImmidiately())
        {
            onComplete(id);
        }
        else
        {
            forKilledTweener?.Invoke(id, DOTween.To(v =>
            {
                if (material)
                {
                    material.SetFloat(Opacity_Property_ID, v);
                }
            }, finalOpacity, 1, 0.3f).OnComplete(delegate { onComplete(id); }));
        }
    }
    private static int Opacity_Property_ID = Shader.PropertyToID("_Opacity");

#endif
}