using MoonCommonLib;
using RenderHeads.Media.AVProVideo;
using UnityEngine;

public class MMediaPlayer : MonoBehaviour, IMMediaPlayer
{
    public static MMediaPlayer Instance { get; private set; }

    private MediaPlayer _mediaPlayer;

    public bool Deprecated {
        get => Instance == null;
        set { }
    }

    private void Init()
    {
        if (Instance == null)
        {
            Instance = this;
            MInterfaceMgr.singleton.AttachInterface("MMediaPlayer", Instance);
        }

        _mediaPlayer = gameObject.GetComponent<MediaPlayer>();
    }

    void Awake()
    {
        Init();
        if (_mediaPlayer != null)
        {
            _mediaPlayer.Events.AddListener(onMediaPlayerEvent);
        }
    }

    void OnDestroy()
    {
        Instance = null;

        if (_mediaPlayer != null)
        {
            _mediaPlayer.Events.RemoveListener(onMediaPlayerEvent);
        }
    }

    public bool Loop
    {
        get => _mediaPlayer != null && _mediaPlayer.m_Loop;
        set
        {
            if (_mediaPlayer != null && _mediaPlayer.Control != null)
            {
                _mediaPlayer.Control.SetLooping(value);
            }
        }
    }

    public bool OpenVideoFromFile(EFileLocation location, string path, bool autoPlay = true)
    {
        if (_mediaPlayer == null) return false;
        return _mediaPlayer.OpenVideoFromFile(location, path, autoPlay);
    }

    public bool OpenVideoFromBuffer(byte[] buffer, bool autoPlay = true)
    {
        if (_mediaPlayer == null) return false;
        return _mediaPlayer.OpenVideoFromBuffer(buffer, autoPlay);
    }

    public bool StartOpenChunkedVideoFromBuffer(ulong length, bool autoPlay = true)
    {
        if (_mediaPlayer == null) return false;
        return _mediaPlayer.StartOpenChunkedVideoFromBuffer(length, autoPlay);
    }

    public bool AddChunkToVideoBuffer(byte[] chunk, ulong offset, ulong chunkSize)
    {
        if (_mediaPlayer == null) return false;
        return _mediaPlayer.AddChunkToVideoBuffer(chunk, offset, chunkSize);
    }

    public bool EndOpenChunkedVideoFromBuffer()
    {
        if (_mediaPlayer == null) return false;
        return _mediaPlayer.EndOpenChunkedVideoFromBuffer();
    }

    public bool EnableSubtitles(EFileLocation fileLocation, string filePath)
    {
        if (_mediaPlayer == null) return false;
        return _mediaPlayer.EnableSubtitles(fileLocation, filePath);
    }

    public void DisableSubtitles()
    {
        _mediaPlayer?.DisableSubtitles();
    }

    public void CloseVideo()
    {
        _mediaPlayer?.CloseVideo();
    }

    public void Play()
    {
        _mediaPlayer?.Play();
    }

    public void Pause()
    {
        _mediaPlayer?.Pause();
    }

    public void Stop()
    {
        _mediaPlayer?.Stop();
    }

    public void Rewind(bool pause)
    {
        _mediaPlayer?.Rewind(pause);
    }

    public bool HasMetaData()
    {
        if (_mediaPlayer == null) return false;
        return _mediaPlayer.Control.HasMetaData();
    }

    public bool CanPlay()
    {
        if (_mediaPlayer == null) return false;
        return _mediaPlayer.Control.CanPlay();
    }

    public bool IsPlaying()
    {
        if (_mediaPlayer == null) return false;
        return _mediaPlayer.Control.IsPlaying();
    }

    public bool IsSeeking()
    {
        if (_mediaPlayer == null) return false;
        return _mediaPlayer.Control.IsSeeking();
    }

    public bool IsPaused()
    {
        if (_mediaPlayer == null) return false;
        return _mediaPlayer.Control.IsPaused();
    }

    public bool IsFinished()
    {
        if (_mediaPlayer == null) return false;
        return _mediaPlayer.Control.IsFinished();
    }

    public bool IsBuffering()
    {
        if (_mediaPlayer == null) return false;
        return _mediaPlayer.Control.IsBuffering();
    }

    public float GetCurrentTimeMs()
    {
        if (_mediaPlayer == null) return 0;
        return _mediaPlayer.Control.GetCurrentTimeMs();
    }

    public double GetCurrentDateTimeSecondsSince1970()
    {
        if (_mediaPlayer == null) return 0;
        return _mediaPlayer.Control.GetCurrentDateTimeSecondsSince1970();
    }

    public void Seek(float timeMs)
    {
        _mediaPlayer?.Control?.Seek(timeMs);
    }

    public void SeekFast(float timeMs)
    {
        _mediaPlayer?.Control?.SeekFast(timeMs);
    }

    public void SeekWithTolerance(float timeMs, float beforeMs, float afterMs)
    {
        _mediaPlayer?.Control?.SeekWithTolerance(timeMs, beforeMs, afterMs);
    }

    public float GetPlaybackRate()
    {
        if (_mediaPlayer == null) return 0;
        return _mediaPlayer.Control.GetPlaybackRate();
    }

    public void SetPlaybackRate(float rate)
    {
        _mediaPlayer?.Control?.SetPlaybackRate(rate);
    }

    public void MuteAudio(bool bMute)
    {
        _mediaPlayer?.Control?.MuteAudio(bMute);
    }

    public bool IsMuted()
    {
        if (_mediaPlayer == null) return false;
        return _mediaPlayer.Control.IsMuted();
    }

    public void SetVolume(float volume)
    {
        _mediaPlayer?.Control?.SetVolume(volume);
    }

    public void SetBalance(float balance)
    {
        _mediaPlayer?.Control?.SetBalance(balance);
    }

    public float GetVolume()
    {
        if (_mediaPlayer == null) return 0;
        return _mediaPlayer.Control.GetVolume();
    }

    public float GetBalance()
    {
        if (_mediaPlayer == null) return 0;
        return _mediaPlayer.Control.GetBalance();
    }

    private void onMediaPlayerEvent(MediaPlayer mp, MoonCommonLib.EEventType et, MoonCommonLib.EErrorCode errorCode)
    {
        var bridge = MInterfaceMgr.singleton.GetInterface<IMoonClientBridge>("MoonClientBridge");
        bridge?.OnMediaPlayerEvent(et, errorCode);
    }

    public bool BindMediaPlayer(GameObject go, bool bind)
    {
        var comDisplayUGUI = go.GetComponent<DisplayUGUI>();
        if (comDisplayUGUI)
        {
            comDisplayUGUI.CurrentMediaPlayer = bind ? _mediaPlayer : null;
            return true;
        }

        var comDisplayIMGUI = go.GetComponent<DisplayIMGUI>();
        if (comDisplayIMGUI)
        {
            comDisplayIMGUI._mediaPlayer = bind ? _mediaPlayer : null;
            return true;
        }

        var comApplyToMesh = go.GetComponent<ApplyToMesh>();
        if (comApplyToMesh)
        {
            comApplyToMesh.Player = bind ? _mediaPlayer : null;
            return true;
        }

        var comApplyToMaterial = go.GetComponent<ApplyToMaterial>();
        if (comApplyToMaterial)
        {
            comApplyToMaterial.Player = bind ? _mediaPlayer : null;
            return true;
        }

        return false;
    }

    public void DebugOverlay(bool open)
    {
        if (_mediaPlayer == null) return;

        var com = gameObject.GetOrCreateComponent<DebugOverlay>();
        if (com == null)
        {
            return;
        }

        com.CurrentMediaPlayer = open ? _mediaPlayer : null;
    }

    public void ExtractFrameAsync(Texture2D target, ProcessExtractedFrame callback, float timeSeconds = -1, bool accurateSeek = true, int timeoutMs = 1000, int timeThresholdMs = 100)
    {
        _mediaPlayer.ExtractFrameAsync(target, callback, timeSeconds, accurateSeek, timeoutMs, timeThresholdMs);
    }

    public Texture2D ExtractFrame(Texture2D target, float timeSeconds = -1, bool accurateSeek = true, int timeoutMs = 1000, int timeThresholdMs = 100)
    {
        return _mediaPlayer.ExtractFrame(target, timeSeconds, accurateSeek, timeoutMs, timeThresholdMs);
    }
}
