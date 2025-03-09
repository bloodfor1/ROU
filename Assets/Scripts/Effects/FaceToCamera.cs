using System.Collections;
using System.Collections.Generic;
using MoonCommonLib;
using UnityEngine;

public class FaceToCamera : MonoBehaviour {

    public enum Mode : byte
    {
        Align = 0,
        FaceTo = 1
    }

    public Mode mode = Mode.Align;
    public bool lockYUp = false;

    private Transform _mTr;
    private Camera _refCamera;
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

        _forward = mode == Mode.Align ? _mCameraTr.forward : _mCameraTr.position - _mTr.position;

        if (lockYUp)
        {
            _forward.y = 0;
            _forward.Normalize();
        }
        _mTr.forward = _forward;
    }
}
