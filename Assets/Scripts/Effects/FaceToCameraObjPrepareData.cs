using System;
using UnityEngine;
using System.Collections.Generic;

public class FaceToCameraObjPrepareData : MonoBehaviour
{
    [SerializeField]
    private FaceToCameraObj[] _faceToCameraObjs;
    private object _skinnedMeshRenderers;

    public FaceToCameraObj[] FaceToCameraObjs
    {
        get
        {
            return _faceToCameraObjs;
        }
        set
        {
            _faceToCameraObjs = value;
        }
    }

    public void CustomActive(bool active)
    {
        if (_faceToCameraObjs != null)
        {
            foreach(var com in _faceToCameraObjs)
            {
                com.enabled = active;
            }
        }
    }
}
