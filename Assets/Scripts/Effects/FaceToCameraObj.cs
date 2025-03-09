using System.Collections;
using System.Collections.Generic;
using MoonCommonLib;
using UnityEngine;

public class FaceToCameraObj : MonoBehaviour {

    public enum Mode : byte
    {
        Align = 0,
        FaceTo = 1
    }

    public Mode mode = Mode.Align;
    public bool lockYUp = false;

    private Transform _mTr;
    private Transform _mCameraTr;
    private Vector3 _forward;

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
        MEffectUpdater.updater += FaceToAction;
    }

    private void OnDisable()
    {
        MEffectUpdater.updater -= FaceToAction;
    }

    private void FaceToAction()
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

        _forward = mode == Mode.Align ? _mCameraTr.forward : _mCameraTr.position - _mTr.position;

        if (lockYUp)
        {
            _forward.y = 0;
            _forward.Normalize();
        }

        if (_forward != Vector3.zero)
        {
            _mTr.forward = _forward;   
        }
    }
}
