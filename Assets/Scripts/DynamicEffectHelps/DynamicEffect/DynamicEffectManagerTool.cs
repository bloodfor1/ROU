using System;
using UnityEngine;
using System.Collections.Generic;
using MoonCommonLib;

[DisallowMultipleComponent]
public class DynamicEffectManagerTool : MonoBehaviour, IDynamicEffectTool
{
    [SerializeField] private List<IDynamicEffectComponent> dynamicEffectList = new List<IDynamicEffectComponent>();
    [SerializeField] private int maxCanUseID = 1;
    private bool isInit = false;

    private Dictionary<int, IDynamicEffectComponent> dynamicEffectDic =
        new Dictionary<int, IDynamicEffectComponent>();

    #region api

    public void PlayAll(Dictionary<string, object> paramDic)
    {
        foreach (var helper in dynamicEffectList)
        {
            playInner(helper, paramDic);
        }
    }

    public void PauseAll()
    {
        foreach (var helper in dynamicEffectList)
        {
            helper.Pause();
        }
    }

    public void StopAll()
    {
        bool hasCallStopCallback = false;
        foreach (var helper in dynamicEffectList)
        {
            helper.PrePareStop(!hasCallStopCallback);
            hasCallStopCallback = true;
        }
    }

    public void Play(int id, Dictionary<string, object> paramDic)
    {
        IDynamicEffectComponent dynamicEffectHelper = null;
        if (dynamicEffectDic.TryGetValue(id, out dynamicEffectHelper))
        {
            playInner(dynamicEffectHelper, paramDic);
        }
        else
        {
            Debug.LogError("尝试操作不存在的动效，动效ID:" + id + " GameObject Name:" + gameObject.name);
        }
    }

    public void Pause(int id)
    {
        IDynamicEffectComponent dynamicEffectHelper = null;
        if (dynamicEffectDic.TryGetValue(id, out dynamicEffectHelper))
        {
            dynamicEffectHelper.Pause();
        }
        else
        {
            Debug.LogError("尝试操作不存在的动效，动效ID:" + id + " GameObject Name:" + gameObject.name);
        }
    }

    public void Stop(int id)
    {
        IDynamicEffectComponent dynamicEffectHelper = null;
        if (dynamicEffectDic.TryGetValue(id, out dynamicEffectHelper))
        {
            dynamicEffectHelper.PrePareStop();
        }
        else
        {
            Debug.LogError("尝试操作不存在的动效，动效ID:" + id + " GameObject Name:" + gameObject.name);
        }
    }

    #endregion

    #region inner function

    private void Start()
    {
        InitTool();
        //播放所有勾选自动播放的动效
        foreach (var dynamicEffectHelper in dynamicEffectList)
        {
            if (dynamicEffectHelper == null) continue;

            if (dynamicEffectHelper.IsAutoPlay())
            {
                playInner(dynamicEffectHelper, null);
            }
        }
    }

    private void OnEnable()
    {
        InitTool();
    }

    public void InitTool(bool forceReInit = false)
    {
        if (isInit && !forceReInit) return;
        isInit = true;
        dynamicEffectDic.Clear();
        dynamicEffectList.Clear();
        IDynamicEffectComponent[] dynamicEffects = gameObject.GetComponents<IDynamicEffectComponent>();
        maxCanUseID = 1;
        foreach (var singleDynamicEffect in dynamicEffects)
        {
            if (singleDynamicEffect == null) continue;
            int dynamicEffectID = singleDynamicEffect.GetID();
            maxCanUseID = Mathf.Max(maxCanUseID, dynamicEffectID + 1);
            dynamicEffectList.Add(singleDynamicEffect);
            dynamicEffectDic.Add(dynamicEffectID, singleDynamicEffect);
        }
    }

    public void AddDynamicEffectHelper(Type helperBaseType)
    {
        DynamicEffectHelperBase effecthelper = gameObject.AddComponent(helperBaseType) as DynamicEffectHelperBase;
        if (effecthelper == null) return;
        effecthelper.SetID(maxCanUseID++);
        dynamicEffectList.Add(effecthelper);
        dynamicEffectDic[effecthelper.GetID()] = effecthelper;
        effecthelper.OnAddHelper();
    }

    public void RemoveDynamicEffectHelper(int ID)
    {
        if (!dynamicEffectDic.ContainsKey(ID))
        {
            return;
        }

        var dynamicEffectHelper = dynamicEffectDic[ID];
        dynamicEffectHelper.OnRemoveHelper();
        dynamicEffectList.Remove(dynamicEffectHelper);
        dynamicEffectDic.Remove(ID);
        if (dynamicEffectHelper != null)
        {
            var helperObj = dynamicEffectHelper as UnityEngine.Object;
            DestroyImmediate(helperObj, true);
        }
    }

    /// <summary>
    ///编辑器模式下获取助手全部信息
    /// </summary>
    /// <returns></returns>
    public List<IDynamicEffectComponent> GetDynamicEffectHelpers()
    {
        return dynamicEffectList;
    }

    /// <summary>
    /// 清楚空的助手信息，助手作为组件，可以通过组件菜单移除，导致引
    /// 用变空，此处用来清楚此类情况产生的空数据
    /// </summary>
    public void ClearEmptyHelper()
    {
        for (int i = dynamicEffectList.Count - 1; i >= 0; i--)
        {
            if (dynamicEffectList[i] == null)
            {
                dynamicEffectList.RemoveAt(i);
            }
        }
    }

    private void playInner(IDynamicEffectComponent dynamicEffectHelper, Dictionary<string, object> paramDic)
    {
        if (dynamicEffectHelper == null) return;
        dynamicEffectHelper.PreparePlay(paramDic);
    }


    #endregion
}
