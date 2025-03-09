using System;
using System.Collections.Generic;
using UnityEngine;

public class MEffectUpdater : MonoBehaviour
{
    public static Action updater;
    private static MEffectUpdater _instance;

    public static MEffectUpdater Active()
    {
        if (_instance)
        {
            return _instance;
        }

        _instance = new GameObject("GlobalFxUpdater").AddComponent<MEffectUpdater>();
        DontDestroyOnLoad(_instance);
        return _instance;
    }

    private void Update()
    {
        updater?.Invoke();
    }

    private void OnDestroy()
    {
        updater = null;
        _instance = null;
    }
}
