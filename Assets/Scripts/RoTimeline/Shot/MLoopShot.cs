using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Playables;

[System.Serializable]
public class MLoopShot : PlayableAsset
{
    internal sealed class MLoopShotPlayable : PlayableBehaviour
    {
        public GameObject owner;
        public override void OnBehaviourPause(Playable playable, FrameData info)
        {
            if (owner == null)
                return;
            PlayableDirector pdComp = owner.GetComponent<PlayableDirector>();
            double duration = playable.GetDuration<Playable>();
            double nowTime = pdComp.time;
            double preTime = nowTime - duration;
            if (preTime >= 0)
            {
                pdComp.time = preTime;
            }
            pdComp.Play();
        }
    }

    // Factory method that generates a playable based on this asset
    public override Playable CreatePlayable(PlayableGraph graph, GameObject go)
    {
        var playable = ScriptPlayable<MLoopShotPlayable>.Create(graph);
        var behav = playable.GetBehaviour();
        behav.owner = go;
        return playable;
    }
}
