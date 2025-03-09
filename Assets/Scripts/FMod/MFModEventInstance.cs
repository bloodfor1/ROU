using FMODUnity;
using FMOD.Studio;
using UnityEngine;
using MoonCommonLib;
using ATTRIBUTES_3D = MoonCommonLib.ATTRIBUTES_3D;


public class MFModEventInstance : IMFModEventInstance
{
    public EventInstance instance { get; private set; }

    public bool Deprecated { get; set; }

    public MFModEventInstance(EventInstance instance)
    {
        this.instance = instance;
    }

    public string getPath()
    {
        EventDescription description;
        instance.getDescription(out description);
        string path;
        description.getPath(out path);
        return path;
    }

    public IMFmodEventDescription getDescription()
    {
        EventDescription description;
        instance.getDescription(out description);
        return new MFmodEventDescription(description);
    }

    public void getVolume(out float volume, out float finalvolume)
    {
        if (instance.isValid())
        {
            instance.getVolume(out volume, out finalvolume);
        }
        else
        {
            volume = 0;
            finalvolume = 0;
        }
    }

    public void setVolume(float volume)
    {
        if (instance.isValid())
        {
            instance.setVolume(volume);
        }   
    }

    public void getPitch(out float pitch, out float finalpitch)
    {
        if (instance.isValid())
        {
            instance.getPitch(out pitch, out finalpitch);
        }
        else
        {
            pitch = 0;
            finalpitch = 0;
        }
    }

    public void setPitch(float pitch)
    {
        if (instance.isValid())
        {
            instance.setPitch(pitch);
        }   
    }

    public ATTRIBUTES_3D get3DAttributes()
    {
        if (instance.isValid())
        {
            FMOD.ATTRIBUTES_3D fmodAttr;
            instance.get3DAttributes(out fmodAttr);
            var attr = new MoonCommonLib.ATTRIBUTES_3D()
            {
                up = new Vector3(fmodAttr.up.x, fmodAttr.up.y, fmodAttr.up.z),
                forward = new Vector3(fmodAttr.forward.x, fmodAttr.forward.y, fmodAttr.forward.z),
                position = new Vector3(fmodAttr.position.x, fmodAttr.position.y, fmodAttr.position.z),
                velocity = new Vector3(fmodAttr.velocity.x, fmodAttr.velocity.y, fmodAttr.velocity.z),
            };
            return attr;
        }

        return new MoonCommonLib.ATTRIBUTES_3D();
    }

    public void set3DAttributes(MoonCommonLib.ATTRIBUTES_3D attributes)
    {
        if (instance.isValid())
        {
            FMOD.ATTRIBUTES_3D fmodAttr = new FMOD.ATTRIBUTES_3D()
            {
                up = attributes.up.ToFMODVector(),
                forward = attributes.forward.ToFMODVector(),
                position = attributes.position.ToFMODVector(),
                velocity = attributes.velocity.ToFMODVector(),
            };
            instance.set3DAttributes(fmodAttr);
        }
    }

    public void getListenerMask(out uint mask)
    {
        if (instance.isValid())
        {
            instance.getListenerMask(out mask);
        }
        else
        {
            mask = 0;
        }
        
    }

    public void setListenerMask(uint mask)
    {
        if (instance.isValid())
        {
            instance.setListenerMask(mask);
        }
    }

    public void getReverbLevel(int index, out float level)
    {
        if (instance.isValid())
        {
            instance.getReverbLevel(index, out level);
        }   
        else
        {
            level = 0;
        }
    }

    public void setReverbLevel(int index, float level)
    {
        if (instance.isValid())
        {
            instance.setReverbLevel(index, level);
        }
    }

    public void getPaused(out bool paused)
    {
        if (instance.isValid())
        {
            instance.getPaused(out paused);
        }
        else
        {
            paused = false;
        }
            
    }

    public void setPaused(bool paused)
    {
        if (instance.isValid())
        {
            instance.setPaused(paused);
        }
    }

    public void start()
    {
        if (instance.isValid())
        {
            instance.start();
        }   
    }

    public void stop(bool immediate)
    {
        if (instance.isValid())
        {
            instance.stop(immediate ? FMOD.Studio.STOP_MODE.IMMEDIATE : FMOD.Studio.STOP_MODE.ALLOWFADEOUT);
        }
    }

    public void getTimelinePosition(out int position)
    {
        if (instance.isValid())
        {
            instance.getTimelinePosition(out position);
        }
        else
        {
            position = 0;
        }            
    }

    public void setTimelinePosition(int position)
    {
        if (instance.isValid())
        {
            instance.setTimelinePosition(position);
        }   
    }

    public void release()
    {
        if (instance.isValid())
        {
            instance.release();
            instance.clearHandle();
        }   
    }

    public void isVirtual(out bool virtualState)
    {
        if (instance.isValid())
        {
            instance.isVirtual(out virtualState);
        }
        else
        {
            virtualState = false;
        }            
    }

    public void getParameterValue(string name, out float value, out float finalvalue)
    {
        if (instance.isValid())
        {
            instance.getParameterValue(name, out value, out finalvalue);
        }
        else
        {
            value = 0;
            finalvalue = 0;
        }
    }

    public void setParameterValue(string name, float value)
    {
        if (instance.isValid())
        {
            instance.setParameterValue(name, value);
        }   
    }

    public void triggerCue()
    {
        if (instance.isValid())
        {
            instance.triggerCue();
        }   
    }

}