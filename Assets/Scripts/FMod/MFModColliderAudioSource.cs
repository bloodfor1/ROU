using FMODUnity;
#if UNITY_EDITOR && UNITY_STANDALONE_WIN
using MoonClient;
#endif
using MoonCommonLib;
using UnityEngine;
using System;

public partial class MFModColliderAudioSource : MonoBehaviour
{
    /// <summary>
    /// 要跟随的Listener Index
    /// </summary>
    public int ListenerIndex;
    /// <summary>
    /// 要用到的Collider列表
    /// </summary>
    public Collider[] ColliderList;

    /// <summary>
    /// Event路径
    /// </summary>
    public bool firstTime;
    float startTime;
    public float speed = 0.005F;

    [EventRef]
    public string AudioEvent;

    private const int UPDATE_FRAME_COUNT = 5;
    private int _currentFrameCount = 0;

    void OnEnable()
    {
        firstTime = true;
        startTime = Time.time;

        if (!MGameContext.singleton.IsGameEditorMode)
        {
            OnRuntimeEnable();
        }
        else
        {
            OnEditorEnable();
        }

    }

    void Update()
    {
        if (_currentFrameCount < UPDATE_FRAME_COUNT)
        {
            _currentFrameCount++;
            return;
        }
        if (ColliderList == null || ColliderList.Length == 0)
        {
            return;
        }

        if (!MGameContext.singleton.IsGameEditorMode)
        {
            OnRuntimeUpdate();
        }
        else
        {
            OnEditorUpdate();
        }

    }

    void OnDisable()
    {
        if (!MGameContext.singleton.IsGameEditorMode)
        {
            OnRuntimeDisable();
        }
        else
        {
            OnEditorDisable();
        }
    }

    void OnDrawGizmos()
    {
        if (Application.isEditor)
        {
            ResEditorGizmo();

            if (_eventInstance == null)
            {
                return;
            }

            Gizmos.DrawWireSphere(_eventInstance.get3DAttributes().position, _eventInstance.getDescription().getSoundSize());

        }
    }
}


/// <summary>
/// 运行时运行
/// </summary>
public partial class MFModColliderAudioSource
{
    private IMFModEventInstance _eventInstance;
    public IMFModRunTimeManager RunTimeManager => MoonClientBridge.Bridge?.GetMFModRunTimeManager();


    bool OnRuntimeEnable()
    {
        var eventPath = AudioEvent;
        if (!string.IsNullOrEmpty(eventPath) && RunTimeManager != null)
        {
            _eventInstance = RunTimeManager.CreateInstance(eventPath);
            if (_eventInstance != null)
            {
                _eventInstance.set3DAttributes(new ATTRIBUTES_3D()
                {
                    position = Vector3.one * 10000,
                    up = Vector3.up,
                    forward = Vector3.forward,
                    velocity = Vector3.zero
                });
                _eventInstance.start();
                return true;
            }
        }
        return false;
    }

    bool OnRuntimeUpdate()
    {
        if (_eventInstance == null)
        {
            return false;
        }

        var listeners = RuntimeManager.HasListener;
        if (!listeners[ListenerIndex])
        {
            return false;
        }
        var listenerPos = RuntimeManager.GetListenerLocation(ListenerIndex); ;
        var cloestPoint = Vector3.zero;
        for (var i = 0; i < ColliderList.Length; i++)
        {
            var currentPoint = ColliderList[i].ClosestPoint(listenerPos);
            if (Vector3.Distance(cloestPoint, listenerPos) > Vector3.Distance(currentPoint, listenerPos))
            {
                cloestPoint = currentPoint;
            }
        }
        float distCovered = (Time.time - startTime) * speed;
        var factpos = Vector3.Lerp(_eventInstance.get3DAttributes().position, cloestPoint, distCovered);
        if (firstTime)
        {
            _eventInstance.set3DAttributes(new ATTRIBUTES_3D()
            {
                position = cloestPoint,
                up = Vector3.up,
                forward = Vector3.forward,
                velocity = Vector3.zero
            });
            firstTime = false;
        }
        else
        {
            _eventInstance.set3DAttributes(new ATTRIBUTES_3D()
            {
                position = factpos,
                up = Vector3.up,
                forward = Vector3.forward,
                velocity = Vector3.zero
            });
        }
        return true;
    }

    bool OnRuntimeDisable()
    {
        if (_eventInstance == null)
        {
            return false;
        }
        _eventInstance.stop();
        _eventInstance.release();
        _eventInstance = null;
        return true;
    }
}

/// <summary>
/// 编辑器下运行
/// </summary>
public partial class MFModColliderAudioSource
{
    private FMOD.Studio.EventInstance _fmodEventInstance;

    FMODUnity.StudioListener _fmodEditorListener;
    private FMODUnity.StudioListener FmodEditorListener
    {
        get
        {
            if (!MGameContext.singleton.IsGameEditorMode)
            {
                MDebug.singleton.AddErrorLog("只能在编辑器下使用EditorListener");
                return null;
            }
#if UNITY_EDITOR && UNITY_STANDALONE_WIN
            if (_fmodEditorListener == null)
            {
                var fmodListner = MEntityMgr.singleton.SkillEditorPlayer?.Model.Trans;

                if (fmodListner == null)
                {
                    return null;
                }
                _fmodEditorListener = fmodListner.GetComponent<StudioListener>();
            }
            return _fmodEditorListener;
#else
            return null;
#endif
        }

    }

    bool OnEditorEnable()
    {
        var eventPath = AudioEvent;
        if (!string.IsNullOrEmpty(eventPath) && RunTimeManager != null)
        {
            try
            {
                _fmodEventInstance = RuntimeManager.CreateInstance(eventPath);
                _fmodEventInstance.set3DAttributes(new FMOD.ATTRIBUTES_3D()
                {
                    forward = Vector3.forward.ToFMODVector(),
                    position = (Vector3.one * 10000).ToFMODVector(),
                    up = Vector3.up.ToFMODVector(),
                    velocity = Vector3.zero.ToFMODVector()
                });
                _fmodEventInstance.start();
                return true;
            }
            catch(Exception)
            {
                MDebug.singleton.AddErrorLogF("Cannot find event, path={0}", eventPath);
                return false;
            }
        }   
        return false;
    }

    bool OnEditorUpdate()
    {
        if (!_fmodEventInstance.isValid())
        {
            return false;
        }
        if (FmodEditorListener == null)
        {
            return false;
        }

        var pos = new FMOD.ATTRIBUTES_3D();
        _fmodEventInstance.get3DAttributes(out pos);
        var listenerPos = FmodEditorListener.transform.position;
        var cloestPoint = Vector3.zero;
        for (var i = 0; i < ColliderList.Length; i++)
        {
            var currentPoint = ColliderList[i].ClosestPoint(listenerPos);
            if (Vector3.Distance(cloestPoint, listenerPos) > Vector3.Distance(currentPoint, listenerPos))
            {
                cloestPoint = currentPoint;
            }
        }
        float distCovered = (Time.time - startTime) * speed;
        var factpos = Vector3.Lerp(new Vector3(pos.position.x, pos.position.y, pos.position.z), cloestPoint, distCovered);
        if (firstTime)
        {
            _fmodEventInstance.set3DAttributes(cloestPoint.To3DAttributes());
            firstTime = false;
        }
        else
        {
            _fmodEventInstance.set3DAttributes(factpos.To3DAttributes());
        }

        return true;
    }

    bool OnEditorDisable()
    {
        if (!_fmodEventInstance.isValid())
        {
            return false;
        }   
        _fmodEventInstance.stop(FMOD.Studio.STOP_MODE.ALLOWFADEOUT);
        _fmodEventInstance.release();
        _fmodEventInstance.clearHandle();
        return true;
    }

    private void ResEditorGizmo()
    {
        if (_fmodEventInstance.isValid())
        {
            var pos = new FMOD.ATTRIBUTES_3D();
            var desc = new FMOD.Studio.EventDescription();
            var radius = float.MinValue;
            _fmodEventInstance.get3DAttributes(out pos);
            _fmodEventInstance.getDescription(out desc);
            desc.getMaximumDistance(out radius);

            Gizmos.DrawWireSphere(new Vector3(pos.position.x, pos.position.y, pos.position.z), radius);
        }
    }
}