using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using FMODUnity;

public class SimpleAnimationSoundController: MonoBehaviour
{
    [EventRef]
    public string EventPath;
    public StudioEventEmitter Emitter;
    public Animator Anima;
    public void Start()
    {
        var evt = new AnimationEvent();
        Emitter = GetComponent<StudioEventEmitter>();

        evt.objectReferenceParameter = this;
        evt.time = 0.0f;
        evt.functionName = "PlayEmitterSound";

        // get the animation clip and add the AnimationEvent
        if (Anima == null)
        {
            Anima = GetComponent<Animator>();
        }
        else if(Anima.gameObject != gameObject)
        {
            Anima.gameObject?.AddComponent<SimpleEmitterSoundListener>();
        }

        if (Anima != null)
        {
            var clip = Anima?.runtimeAnimatorController?.animationClips[0];
            clip?.AddEvent(evt);
        }
        else
        {
            var clip = this.gameObject?.GetComponent<Animation>().clip;
            clip?.AddEvent(evt);
        }

    }

    // the function to be called as an event
    public void PlayEmitterSound(Object obj)
    {
        var controller = (SimpleAnimationSoundController)obj;
        if (Emitter == null)
        {
            Emitter = gameObject.AddComponent<StudioEventEmitter>();
            Emitter.TriggerOnce = false;
            Emitter.Event = controller.EventPath;
        }
        Emitter?.Play();


    }
}
