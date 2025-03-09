using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using MoonCommonLib;

public class PushToCommandBuffer : MonoBehaviour
{

    private Camera mainCamera;
    private Renderer render;

    private void Awake()
    {
        render = GetComponent<Renderer>();
    }

    private void OnWillRenderObject()
    {
        if (gameObject.layer == MLayer.ID_CUTSCENE)
            return;
        if (null == mainCamera)
        {
            mainCamera = Camera.main;
        }

        if (Camera.current == mainCamera)
        {
            MoonClientBridge.Bridge.GetOutline()
                .AddRendererToOutlineBuffer(render);
        }
    }
}
