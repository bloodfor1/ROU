using System;
using FMOD;
using FMOD.Studio;
using MoonCommonLib;

public class MFmodEventDescription : IMFmodEventDescription
{
    public EventDescription description { get; private set; }

    public bool Deprecated { get; set; }

    public MFmodEventDescription(EventDescription description)
    {
        this.description = description;
    }


    public Guid getID()
    {
        Guid id;
        description.getID(out id);
        return id;
    }

    public string getPath()
    {
        string path;
        description.getPath(out path);
        return path;
    }

    public int getUserPropertyCount()
    {
        int propCount;
        description.getUserPropertyCount(out propCount);
        return propCount;
    }

    public int getLength()
    {
        int length;
        description.getLength(out length);
        return length;
    }

    public float getMinimumDistance()
    {
        float minimumDistance;
        description.getMinimumDistance(out minimumDistance);
        return minimumDistance;
    }

    public float getMaximumDistance()
    {
        float maximumDistance;
        description.getMaximumDistance(out maximumDistance);
        return maximumDistance;
    }

    public float getSoundSize()
    {
        float soundSize;
        description.getSoundSize(out soundSize);
        return soundSize;
    }

    public bool isSnapshot()
    {
        bool snapshot;
        description.isSnapshot(out snapshot);
        return snapshot;
    }

    public bool isOneshot()
    {
        bool oneshot;
        description.isOneshot(out oneshot);
        return oneshot;
    }

    public bool isStream()
    {
        bool isStream;
        description.isStream(out isStream);
        return isStream;
    }

    public bool is3D()
    {
        bool is3D;
        description.is3D(out is3D);
        return is3D;
    }

    public bool isValid()
    {
        return description.isValid();
    }

    public bool hasCue()
    {
        bool hasCue;
        description.hasCue(out hasCue);
        return hasCue;
    }

    public IMFModEventInstance createInstance()
    {
        EventInstance instance;
        if (description.createInstance(out instance) == RESULT.OK)
        {
            return new MFModEventInstance(instance);
        }
        return null;
    }

    public int getInstanceCount()
    {
        int instanceCount;
        description.getInstanceCount(out instanceCount);
        return instanceCount;
    }

    public IMFModEventInstance[] getInstanceList()
    {
        EventInstance[] list;
        if (description.getInstanceList(out list) == RESULT.OK)
        {
            IMFModEventInstance[] instanceList = new IMFModEventInstance[list.Length];
            for (int i = 0; i < list.Length; i++)
            {
                instanceList[i] = new MFModEventInstance(list[i]);
            }
            return instanceList;
        }
        return null;
    }

    public void loadSampleData()
    {
        description.loadSampleData();
    }

    public void unloadSampleData()
    {
        description.unloadSampleData();
    }

    public void releaseAllInstances()
    {
        description.releaseAllInstances();
    }

    public IntPtr getUserData()
    {
        IntPtr userData;
        description.getUserData(out userData);
        return userData;
    }

    public void setUserData(IntPtr userdata)
    {
        description.setUserData(userdata);
    }
}