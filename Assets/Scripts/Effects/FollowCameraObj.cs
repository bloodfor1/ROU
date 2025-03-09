using System.Collections;
using System.Collections.Generic;
using MoonCommonLib;
using UnityEngine;

public class FollowCameraObj : MonoBehaviour {

    private Transform _mTr;
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
            var cam = Camera.main;
            if (cam)
            {
                _mCameraTr = cam.transform;
            }
        }
    }

    private void OnEnable()
    {
        MEffectUpdater.Active();
        MEffectUpdater.updater += FollowAction;
    }

    private void OnDisable()
    {
        MEffectUpdater.updater -= FollowAction;
    }

    private void FollowAction()
    {
        if (!_mCameraTr)
        {
            if (MoonClientBridge.Bridge.GameCamera)
            {
                _mCameraTr = MoonClientBridge.Bridge.GameCamera.transform;
            }
        }

        if (!_mCameraTr)
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
