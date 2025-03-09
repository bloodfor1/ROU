using System;
using FMOD.Studio;
using MoonCommonLib;

public class MFmodVCA : IMFmodVCA
{
    public VCA vca { get; private set; }

    public bool Deprecated { get; set; }

    public MFmodVCA(VCA vca)
    {
        this.vca = vca;
    }

    public Guid getID()
    {
        Guid id;
        vca.getID(out id);
        return id;
    }

    public string getPath()
    {
        string path;
        vca.getPath(out path);
        return path;
    }

    public void getVolume(out float volume, out float finalvolume)
    {
        vca.getVolume(out volume, out finalvolume);
    }

    public void setVolume(float volume)
    {
        vca.setVolume(volume);
    }
}