using System.Collections;
using System.Collections.Generic;
using MoonCommonLib;
using UnityEngine;

public class FollowCamera : MonoBehaviour {

    private Transform _mTr;
    private Camera _refCamera;
    private Transform _mCameraTr;

    public bool AlsoRotation;

    private void Awake()
    {
        _mTr = transform;
    }

    private void Start()
    {
        if (MGameContext.singleton.IsGameEditorMode)
        {
            _refCamera = Camera.main;
            if (_refCamera)
            {
                _mCameraTr = _refCamera.transform;
            }
        }
    }

    private void OnWillRenderObject()
    {
        if (!_mCameraTr)
        {
            _refCamera = MoonClientBridge.Bridge.GameCamera;
            if (_refCamera)
            {
                _mCameraTr = MoonClientBridge.Bridge.GameCamera.transform;
            }
        }

        if (Camera.current != _refCamera || !_mCameraTr)
        {
            return;
        }

        _mTr.position = _mCameraTr.position;
        if (AlsoRotation)
        {
            _mTr.rotation = _mCameraTr.rotation;
        }
    }
}
