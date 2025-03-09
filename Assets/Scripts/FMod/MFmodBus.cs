using System;
using FMOD.Studio;
using MoonCommonLib;

public class MFmodBus : IMFmodBus
{
    public Bus bus { get; private set; }

    public bool Deprecated
    {
        get;
        set;
    }

    public MFmodBus(Bus bus)
    {
        this.bus = bus;
    }

    public Guid getID()
    {
        Guid id;
        bus.getID(out id);
        return id;
    }

    public string getPath()
    {
        string path;
        bus.getPath(out path);
        return path;
    }

    public void getVolume(out float volume, out float finalvolume)
    {
        bus.getVolume(out volume, out finalvolume);
    }

    public void setVolume(float volume)
    {
        bus.setVolume(volume);
    }

    public void getPaused(out bool paused)
    {
        bus.getPaused(out paused);
    }

    public void setPaused(bool paused)
    {
        bus.setPaused(paused);
    }

    public void getMute(out bool mute)
    {
        bus.getMute(out mute);
    }
    public void setMute(bool mute)
    {
        bus.setMute(mute);
    }
    public void stopAllEvents(bool immediate)
    {
        bus.stopAllEvents(immediate ? FMOD.Studio.STOP_MODE.IMMEDIATE : FMOD.Studio.STOP_MODE.ALLOWFADEOUT);
    }
    public void lockChannelGroup()
    {
        bus.lockChannelGroup();
    }
    public void unlockChannelGroup()
    {
        bus.unlockChannelGroup();
    }

}