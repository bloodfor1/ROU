using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraLayerCulling : MonoBehaviour
{
    public CullingGroup[] layerCullings;

    private void OnEnable()
    {
        SetCameraLayerCull(Camera.main);
    }

    public void SetCameraLayerCull(Camera cam)
    {
        if (null == cam || null == layerCullings)
            return;

        var cullings = new float[32];
        for (int i = layerCullings.Length - 1; i >= 0; i--)
        {
            var layerID = Mathf.Clamp(layerCullings[i].idx, 0, 31);
            if (layerCullings[i].distance > 0)
            {
                cullings[layerID] = layerCullings[i].distance;
            }
        }
        cam.layerCullDistances = cullings;
        cam.layerCullSpherical = true;
    }
}

[System.Serializable]
public struct CullingGroup
{
    public int idx;
    public float distance;
}



