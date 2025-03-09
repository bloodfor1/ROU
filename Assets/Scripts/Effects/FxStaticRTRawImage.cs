
using UnityEngine;
using UnityEngine.UI;
using MoonCommonLib;

public class FxStaticRTRawImage : MonoBehaviour
{
    public RawImage _rawImage;
    public string effectPath;

    private int _fxId = 0;
    private IMFxMgr _imfxMgr = null;
    private FxLoadedHandler _onFxLoaded;
    private FxDestroyHandler _onFxDestroyed;

    private IMFxMgr IMFxMgr
    {
        get
        {
            if (_imfxMgr == null)
            {
                _imfxMgr = MInterfaceMgr.singleton.GetInterface<IMFxMgr>(
                    MCommonFunctions.GetHash("MFxMgr"));
            }
            return _imfxMgr;
        }
    }

    private FxLoadedHandler OnFxLoaded
    {
        get
        {
            if (_onFxLoaded == null)
            {
                _onFxLoaded = loadedCallBack;
            }
            return _onFxLoaded;
        }
    }

    private FxDestroyHandler OnFxDestroyed
    {
        get
        {
            if (_onFxDestroyed == null)
            {
                _onFxDestroyed = destroyHandler;
            }
            return _onFxDestroyed;
        }
    }

    public void Awake()
    {
        RawImage rawImage = gameObject.GetComponent<RawImage>();
        if (rawImage != null)
        {
            _rawImage = rawImage;
        }
    }

    public void OnEnable()
    {
        if (_fxId > 0)
        {
            IMFxMgr.Replay(_fxId);
        }
        else
        {
            _fxId = IMFxMgr.CreateFxForRT(_rawImage, effectPath,
                OnFxLoaded, OnFxDestroyed);
        }
    }

    public void OnDestroy()
    {
        if (_fxId != 0)
        {
            IMFxMgr.DestroyFx(_fxId);
            _fxId = 0;
        }
    }

    private void destroyHandler(bool isFxEnd, int fxId, object userData)
    {
        if (_fxId > 0)
        {
            _fxId = 0;
            _rawImage.gameObject.SetActive(false);
        }
    }

    public void loadedCallBack(GameObject go, int fxId, object userData)
    {
    }
}