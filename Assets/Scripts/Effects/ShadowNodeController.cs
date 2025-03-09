using System.Collections;
using System.Collections.Generic;
using MoonCommonLib;
using UnityEngine;

public class ShadowNodeController : MonoBehaviour {

    public enum ShadowMode
    {
        Other = 0,
        Plane = 1,
        Projector = 2,
    }

    public static ShadowMode shadowMode = ShadowMode.Projector;

    private Projector projector;
    private Renderer meshRenderer;

    private void Awake()
    {
        projector = this.gameObject.GetComponentInChildren<Projector>();
        meshRenderer = this.gameObject.GetComponentInChildren<Renderer>();
    }

    private void OnEnable()
    {
        ChangeMode(shadowMode);
        
        if (MoonClientBridge.Bridge.MEnvorimentSettingAvaliable)
            SetShadowColor(MoonClientBridge.Bridge.GetEnvorimentSetting().shadowColor);
    }

    public void ChangeMode(ShadowMode mode)
    {
        if (meshRenderer)
        {
            meshRenderer.enabled = (mode == ShadowMode.Plane);
        }

        if (projector)
        {
            projector.enabled = (mode == ShadowMode.Projector);
        }     
    }

    public void SetShadowColor(Color color)
    {
        if (meshRenderer && meshRenderer.enabled)
        {
            meshRenderer.sharedMaterial.SetColor("_TintColor", color * 0.25f);
        }

        if (projector)
        {
            projector.material.SetColor("_TintColor", color * 0.25f);
        }
    }

    public void SetSize(float size)
    {
        if (meshRenderer)
        {
            meshRenderer.transform.localScale = Vector3.one * size;
        }

        if (projector)
        {
            projector.orthographicSize = size * 0.5f;
        }
    }
}
