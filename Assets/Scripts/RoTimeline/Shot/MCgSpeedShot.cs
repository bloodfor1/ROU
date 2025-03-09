using System.Collections;
using System.Collections.Generic;
using MoonCommonLib;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

public class MCgSpeedShotPlayable : PlayableBehaviour
{
    public float desSpeed;
    public bool isGradually;
    private float _orgSpeed = 1f;
    private IMEntrance _proxy;

    public override void PrepareFrame(Playable playable, FrameData info)
    {
        if(isGradually)
        {
            var ret = Mathf.Lerp(_orgSpeed, desSpeed, (float)(playable.GetTime() / playable.GetDuration()));
            if (_proxy != null)
            {
                _proxy.SetTimeScale(ret);
            }
            else
            {
                Time.timeScale = ret;
            }
        }
    }
    public override void OnBehaviourPlay(Playable playable, FrameData info)
    {
        _proxy = MInterfaceMgr.singleton.GetInterface<IMEntrance>(0);

        _orgSpeed = _proxy?.TimeScale ?? Time.timeScale;

        if (!isGradually)
        {
            if (_proxy != null)
            {
                _proxy.SetTimeScale(desSpeed);
            }
            else
            {
                Time.timeScale = desSpeed;
            }
        }
        
    }
    public override void OnBehaviourPause(Playable playable, FrameData info)
    {
        if (_proxy != null)
        {
            _proxy.SetTimeScale(_orgSpeed);
        }
        else
        {
            Time.timeScale = _orgSpeed;
        }

        _proxy = null;
    }
}

public class MCgSpeedShot : PlayableAsset
{
    public float desSpeed;
    public bool isGradually;
    public override Playable CreatePlayable(PlayableGraph graph, GameObject go)
    {
        var playable = ScriptPlayable<MCgSpeedShotPlayable>.Create(graph);
        var behav = playable.GetBehaviour();
        behav.desSpeed = desSpeed;
        behav.isGradually = isGradually;
        return playable;
    }
}