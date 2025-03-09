using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using FMODUnity;
public class SimpleEmitterSoundListener : MonoBehaviour {

    public void PlayEmitterSound(Object obj)
    {
        var controller = (SimpleAnimationSoundController)obj;
        if (controller == null)
        {
            return;
        }
        var emitter = controller.Emitter;
        if (emitter == null)
        {
            emitter = controller.gameObject.AddComponent<StudioEventEmitter>();
            emitter.TriggerOnce = false;
            emitter.Event = controller.EventPath;
            controller.Emitter = emitter;
        }
        emitter.Play();
    }
}
