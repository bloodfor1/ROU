using System;
using System.Collections.Generic;
using LuaInterface;
using MoonCommonLib;
using UnityEngine;


[ExtendField("delayTime", typeof(double), "单位s，延迟播放动效的时间")]
[ExtendField("stopTime", typeof(double), "单位s，延迟关闭播放动效的时间，-1为不关闭")]
[ExtendField("stopCallback", typeof(LuaFunction), "void stopcallback(int id) 通过助手，关闭动效回调")]
public abstract class DynamicEffectHelperBase : MonoBehaviour,IDynamicEffectComponent
{
    public int ID; //助手在每个助手管理组件中的唯一标识
    [HideInInspector] public bool ShowDescInfo = false; //编辑器中使用，控制是否显示属性描述

    public bool AutoPlay = false;

    /// <summary>
    /// 面板上配置的延迟时间
    /// </summary>
    public float DelayTime = 0;

    public float StopPlayTime = -1;

    /// <summary>
    /// 程序传递的延迟播放时间
    /// </summary>
    protected float _DelayPlayTime = 0;

    protected float _StopPlayTime = 0;

    //动效被停止回调
    private Action<int> _stopDynamicEffectCb = null;

    #region 子类生命周期

    /// <summary>
    /// 检查数据合法性，Play前调用
    /// </summary>
    /// <returns></returns>
    protected abstract bool _CheckValid();

    /// <summary>
    /// 初始化数据
    /// </summary>
    protected virtual void _Init()
    {
    }

    /// <summary>
    /// 初始化程序传递的参数，CheckValid前调用
    /// </summary>
    /// <param name="paramDic"></param>
    protected abstract void _InitParam(Dictionary<string, object> paramDic);

    /// <summary>
    /// 当助手被添加到gameobject上时调用，可用来init助手所需组件
    /// </summary>
    /// <returns></returns>
    public abstract void OnAddHelper();

    public bool IsAutoPlay()
    {
        return AutoPlay;
    }

    /// <summary>
    /// 当助手从gameobject上移除时调用，可用来uninit助手所需组件
    /// </summary>
    /// <returns></returns>
    public abstract void OnRemoveHelper();

    protected abstract void _Play();

    public void Pause()
    {
        if (!_CheckValid()) return;

        _Pause();
    }

    protected abstract void _Pause();

    protected abstract void _Stop();

    protected virtual void OnDestroy()
    {
        CancelInvoke("_Play");
        PrePareStop(false);
    }

    #endregion

    #region 内部生命周期

    /// <summary>
    /// 准备播放，做好播放前准备工作，然后开始播放
    /// </summary>
    /// <param name="paramDic"></param>
    public void PreparePlay(Dictionary<string, object> paramDic)
    {
        initBaseInfo();
        _Init();

        if (paramDic != null)
        {
            initCommonParam(paramDic);
            _InitParam(paramDic);
        }

        if (_CheckValid())
        {
            playDynamicEffect();
            delayStopDynamicEffect();
        }
    }

    private void delayStop()
    {
        PrePareStop();
    }

    /// <summary>
    /// 准备停止，处理停止前的通用操作
    /// </summary>
    public void PrePareStop(bool callStopCallback = true)
    {
        CancelInvoke("delayStop");
        CancelInvoke("_Play");
        if (_CheckValid())
        {
            _Stop();
        }

        if (callStopCallback && _stopDynamicEffectCb != null)
        {
            _stopDynamicEffectCb(ID);
            _stopDynamicEffectCb = null;
        }
    }

    public int GetID()
    {
        return ID;
    }

    public void SetID(int ID)
    {
        this.ID = ID;
    }

    public bool IsShowDescInfo()
    {
        return ShowDescInfo;
    }
    
    public void SetShowDescInfo(bool isShow)
    {
        ShowDescInfo = isShow;
    }

    private void initBaseInfo()
    {
        _DelayPlayTime = DelayTime;
        _StopPlayTime = StopPlayTime;
        _stopDynamicEffectCb = null;
    }

    /// <summary>
    /// 初始化助手通用参数，比如延迟时间等
    /// </summary>
    /// <param name="paramDic"></param>
    private void initCommonParam(Dictionary<string, object> paramDic)
    {
        //初始化延迟播放时间
        double delayTime = 0;
        if (_TryGetValueFromParamDic("delayTime", out delayTime, paramDic))
        {
            if (delayTime <= 0)
            {
                _DelayPlayTime = 0;
            }
            else
            {
                _DelayPlayTime = (float) delayTime;
            }
        }

        //初始化停止播放时间
        double stopTime = 0;
        if (_TryGetValueFromParamDic("stopTime", out stopTime, paramDic))
        {
            if (stopTime <= 0)
            {
                _StopPlayTime = -1;
            }
            else
            {
                _StopPlayTime = (float) stopTime;
            }
        }

        //初始化停止播放时间
        Action<int> stopCallback;
        if (_TryGetDelegateFromParamDic("stopCallback", out stopCallback, paramDic))
        {
            _stopDynamicEffectCb = stopCallback;
        }
    }

    /// <summary>
    /// 播放动效
    /// </summary>
    private void playDynamicEffect()
    {
        if (Mathf.Approximately(_DelayPlayTime, 0))
        {
            _Play();
            return;
        }

        CancelInvoke("_Play");
        Invoke("_Play", _DelayPlayTime);
    }

    /// <summary>
    /// 助手延迟终止动效
    /// </summary>
    private void delayStopDynamicEffect()
    {
        if (_StopPlayTime <= 0)
        {
            return;
        }

        CancelInvoke("delayStop");
        Invoke("delayStop", _StopPlayTime);
    }

    #endregion

    #region 提供给子类的通用方法

    /// <summary>
    /// 将object类型转化为T类型
    /// </summary>
    /// <param name="obj"></param>
    /// <typeparam name="T"></typeparam>
    /// <returns></returns>
    protected T _ConvertToType<T>(object obj)
    {
        if (obj == null)
        {
            return default(T);
        }

        try
        {
            return (T) obj;
        }
        catch (Exception e)
        {
            Debug.LogError("[DynamicEffect]数据强转失败，已返回默认值，强转数据类型：" + typeof(T).FullName);
            return default(T);
        }
    }

    /// <summary>
    /// 将字典中指定key的值转换T类型，T不能为委托
    /// </summary>
    /// <param name="key"></param>
    /// <param name="value"></param>
    /// <param name="paramDic"></param>
    /// <typeparam name="T"></typeparam>
    /// <returns></returns>
    protected bool _TryGetValueFromParamDic<T>(string key, out T value, Dictionary<string, object> paramDic)
    {
        value = default(T);
        if (paramDic == null) return false;
        object valueObj;
        if (!paramDic.TryGetValue(key, out valueObj))
        {
            return false;
        }

        value = _ConvertToType<T>(valueObj);
        return true;
    }

    /// <summary>
    /// 将字典中指定key的值转换为指定委托类型，object必须为luafunction
    /// </summary>
    /// <param name="key"></param>
    /// <param name="value"></param>
    /// <param name="paramDic"></param>
    /// <typeparam name="T"></typeparam>
    /// <returns></returns>
    protected bool _TryGetDelegateFromParamDic<T>(string key, out T value, Dictionary<string, object> paramDic)
        where T : class
    {
        value = null;
        if (paramDic == null) return false;
        object valueObj;
        if (!paramDic.TryGetValue(key, out valueObj))
        {
            return false;
        }

        if (valueObj is LuaFunction)
        {
            LuaFunction luaFunc = valueObj as LuaFunction;
            value = luaFunc.ToDelegate<T>();
        }
        else
        {
            Debug.LogError("[DynamicEffect]尝试将LuaFunction转换为委托！");
        }

        return true;
    }

    /// <summary>
    /// 将字典中指定key的值转换为指定数组类型，object必须为string
    /// </summary>
    /// <param name="key"></param>
    /// <param name="value">value必须为数组，且不能为float</param>
    /// <param name="paramDic"></param>
    /// <param name="splitChar">分隔符</param>
    /// <typeparam name="T"></typeparam>
    /// <returns></returns>
    protected bool _TryGetArrayFromParamDic<T>(string key, out T[] value, Dictionary<string, object> paramDic,
        char splitChar = ',')
    {
        value = null;
        if (paramDic == null) return false;
        object valueObj;
        if (!paramDic.TryGetValue(key, out valueObj))
        {
            return false;
        }

        string[] splitStrArray = valueObj.ToString().Split(splitChar);
        int splitStrArrayLen = splitStrArray.Length;

        value = new T[splitStrArrayLen];
        for (int i = 0; i < splitStrArrayLen; i++)
        {
            value[i] = _ConvertToType<T>(splitStrArray[i]);
        }

        return true;
    }

    /// <summary>
    /// 将字典中指定key的值转换为float数组类型，object必须为string
    /// </summary>
    /// <param name="key"></param>
    /// <param name="value">必须为float[]类型</param>
    /// <param name="paramDic"></param>
    /// <param name="splitChar">分隔符</param>
    /// <typeparam name="T"></typeparam>
    /// <returns></returns>
    protected bool _TryGetFloatArrayFromParamDic(string key, out float[] value, Dictionary<string, object> paramDic,
        char splitChar = ',')
    {
        value = null;
        if (paramDic == null) return false;
        object valueObj;
        if (!paramDic.TryGetValue(key, out valueObj))
        {
            return false;
        }

        string[] splitStrArray = valueObj.ToString().Split(splitChar);
        int splitStrArrayLen = splitStrArray.Length;

        value = new float[splitStrArrayLen];
        for (int i = 0; i < splitStrArrayLen; i++)
        {
            float tempFloatValue = 0;
            if (float.TryParse(splitStrArray[i], out tempFloatValue))
            {
                value[i] = tempFloatValue;
            }
        }

        return true;
    }

    protected T _GetUniqueComponent<T>() where T : Component
    {
        T com = transform.GetComponent<T>();
        if (com == null)
        {
            com = gameObject.AddComponent<T>();
        }

        return com;
    }

    #endregion
}
    

