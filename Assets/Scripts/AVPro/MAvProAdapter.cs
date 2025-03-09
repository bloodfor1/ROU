using MoonCommonLib;
using RenderHeads.Media.AVProVideo;
using UnityEngine;

class MAvProAdapter : MonoBehaviour
{
    public MediaPlayer Media;
    public GameObject BG;

    private void Awake()
    {
        Media.Events.AddListener(onMediaPlayerEvent);
    }

    private void onMediaPlayerEvent(MediaPlayer mp, EEventType et, EErrorCode errorCode)
    {
        MDebug.singleton.AddLogF("[onMediaPlayerEvent]{0}", et.ToString());
        switch(et)
        {
            case EEventType.ReadyToPlay:
            case EEventType.FirstFrameReady:
                BG.SetActiveEx(true);
                break;
            case EEventType.Error:
            case EEventType.Closing:
                BG.SetActive(false);
                break;
        }
    }
}