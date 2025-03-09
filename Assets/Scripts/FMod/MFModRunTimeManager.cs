using System;
using FMODUnity;
using MoonCommonLib;
using UnityEngine;

public class MFModRunTimeManager : MonoBehaviour, IMFModRunTimeManager
{
    private static MFModRunTimeManager _Instance;

    public bool Deprecated
    {
        get { return _Instance == null; }
        set { }
    }

    public void PlayOneShot(string path, Vector3 position = new Vector3())
    {
        if (!EventExist(path))
        {
            MDebug.singleton.AddErrorLog($"Fmod event: {path} not exist!");
            return;
        }
        try
        {
            RuntimeManager.PlayOneShot(path, position);
        }
        catch (Exception)
        {
            MDebug.singleton.AddErrorLog($"Fmod event: {path} not exist!");
        }
    }

    public void PlayOneShotAttached(string path, GameObject gameObject)
    {
        if (!EventExist(path))
        {
            MDebug.singleton.AddErrorLog($"Fmod event: {path} not exist!");
            return;
        }
        try
        {
            RuntimeManager.PlayOneShotAttached(path, gameObject);
        }
        catch (Exception)
        {
            MDebug.singleton.AddErrorLog($"Fmod event: {path} not exist!");
        }

    }

    public IMFModEventInstance CreateInstance(string path)
    {
        if (!EventExist(path))
        {
            MDebug.singleton.AddErrorLog($"Fmod event: {path} not exist!");
            return null;
        }
        try
        {
            var instance = RuntimeManager.CreateInstance(path);
            return new MFModEventInstance(instance);
        }
        catch (Exception)
        {
            MDebug.singleton.AddErrorLog($"Fmod event: {path} not exist!");
            return null;
        }
    }

    public IMFmodEventDescription GetEventDescription(string path)
    {
        try
        {
            if (!EventExist(path))
            {
                MDebug.singleton.AddErrorLog($"Fmod event: {path} not exist!");
                return null;
            }
            return new MFmodEventDescription(RuntimeManager.GetEventDescription(path));
        }
        catch
        {
            MDebug.singleton.AddErrorLog($"Fmod event: {path} not exist!");
            return null;
        }
    }

    public void LoadBank(string bankName, bool loadSamples = false)
    {
        RuntimeManager.LoadBank(bankName, loadSamples);
    }

    public void LoadBank(TextAsset bankName, bool loadSamples = false)
    {
        RuntimeManager.LoadBank(bankName, loadSamples);
    }

    public void UnloadBank(string bankName)
    {
        RuntimeManager.UnloadBank(bankName);
    }

    public IMFmodBus GetBus(string path)
    {
        try
        {
            return new MFmodBus(RuntimeManager.GetBus(path));
        }
        catch (Exception)
        {
            MDebug.singleton.AddErrorLogF("GetBus failed, path={0}", path);
            return null;
        }
    }

    public IMFmodVCA GetVCA(string path)
    {
        try
        {
            return new MFmodVCA(RuntimeManager.GetVCA(path));
        }
        catch (Exception)
        {
            MDebug.singleton.AddErrorLogF("GetVCA failed, path={0}", path);
            return null;
        }
    }

    public void AttachInstanceToGameObject(IMFModEventInstance instance, Transform transform, Rigidbody rigidBody)
    {
        RuntimeManager.AttachInstanceToGameObject(((MFModEventInstance)instance).instance, transform, rigidBody);
    }

    public void DetachInstanceFromGameObject(IMFModEventInstance instance)
    {
        RuntimeManager.DetachInstanceFromGameObject(((MFModEventInstance)instance).instance);
    }

    public void AnyBankLoading()
    {
        RuntimeManager.AnyBankLoading();
    }

    public void WaitForAllLoads()
    {
        RuntimeManager.WaitForAllLoads();
    }

    public void PauseAllEvents(bool paused)
    {
        RuntimeManager.PauseAllEvents(paused);
    }

    public void MuteAllEvents(bool muted)
    {
        RuntimeManager.MuteAllEvents(muted);
    }

    public void AddListener(GameObject gameObject)
    {
        gameObject.GetOrCreateComponent<StudioListener>();
    }

    public Guid PathToGUID(string path)
    {
        return RuntimeManager.PathToGUID(path);
    }

    public bool EventExist(string path)
    {
        return RuntimeManager.PathToGUID(path) != Guid.Empty;
    }

    public void Init()
    {
        if (_Instance == null)
        {
            _Instance = this;
            MInterfaceMgr.singleton.AttachInterface<IMFModRunTimeManager>(
                MCommonFunctions.GetHash("MFModRunTimeManager"), _Instance);
        }
    }

    private void Awake()
    {
        Init();
    }

    private void OnDestroy()
    {
        _Instance = null;
    }
}