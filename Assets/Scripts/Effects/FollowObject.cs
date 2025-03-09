using System.Collections;
using System.Collections.Generic;
using MoonCommonLib;
using UnityEngine;

public class FollowObject : MonoBehaviour {

    public enum FollowMode
    {
        MainCamera,
        Player,
        Target
    }
    public FollowMode followMode;
    public bool includeRotation;
    public bool ignoreHeight;
    public Transform target;
    private Transform _mTrans;
    private Transform _mTargetTr;

    public static Transform EditorPlayer;

	void Awake ()
    {
        _mTrans = transform;
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

    private void FollowTarget(Transform t)
    {
        if (t == null)
        {
            return;
        }
        var pos = t.position;
        if (ignoreHeight)
            pos.y = 0;
        _mTrans.position = pos;
        if (includeRotation)
        {
            _mTrans.rotation = t.rotation;
        }
    }

    private void FollowAction()
    {
        if (!_mTargetTr)
        {
            GetTarget();
        }

        FollowTarget(_mTargetTr);
    }

    private void GetTarget()
    {
        switch (followMode)
        {
            case FollowMode.MainCamera:
                {
                    if (MGameContext.singleton.IsGameEditorMode)
                    {
                        var cam = Camera.main;
                        if (cam)
                        {
                            _mTargetTr = cam.transform;
                        }
                    }
                    else
                    {
                        if (MoonClientBridge.Bridge.GameCamera)
                        {
                            _mTargetTr = MoonClientBridge.Bridge.GameCamera.transform;
                        }
                    }
                }
                break;
            case FollowMode.Player:
                {
                    if (EditorPlayer)
                    {
                        _mTargetTr = EditorPlayer;
                    }
                    else if (MoonClientBridge.Bridge.HasPlayer) 
                    {
                        _mTargetTr = MoonClientBridge.Bridge.PlayerTransform;
                    }
                }
                break;
            case FollowMode.Target:
                {
                    _mTargetTr = target;
                }
                break;
        }
    }
}
