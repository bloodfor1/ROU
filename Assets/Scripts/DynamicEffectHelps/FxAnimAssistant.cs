using System.Collections.Generic;
using DG.Tweening;
using FxAnimation;
using LuaInterface;
using MoonCommonLib;
using UnityEngine;

[ExtendField("特别说明", typeof(string), "FxAnimationHelper组件可以同时支持多个动画，给指定index格式为对应名字+index" +
    ",如何给index为2的动画传递Body_参数，则为 Body_2")]
[ExtendField("PlayAnimIndexs", typeof(string), "试图播放的动画的indexs,以‘,’分隔")]
[ExtendField("Body_", typeof(GameObject), "动画操控的GameObject")]
[ExtendField("StartPos_", typeof(GameObject), "起始目标GameObject")]
[ExtendField("EndPos_", typeof(GameObject), "结束目标GameObject")]
[ExtendField("From_", typeof(string), "第一个起始位置，fxAnim组件中是参数类型float[],根据需要传参,用‘,’分隔")]
[ExtendField("From2_", typeof(string), "第二个起始位置，fxAnim组件中是参数类型float[],根据需要传参,用‘,’分隔")]
[ExtendField("LoopRandom_", typeof(bool), "是否开启循环随机")]
[ExtendField("RangeFrom_", typeof(bool), "是否随机起始位置")]
[ExtendField("To_", typeof(string), "第一个结束位置，fxAnim组件中是参数类型float[],根据需要传参,用‘,’分隔")]
[ExtendField("To2_", typeof(string), "第二个结束位置，fxAnim组件中是参数类型float[],根据需要传参,用‘,’分隔")]
[ExtendField("RangeTo_", typeof(bool), "是否随机结束位置")]
[ExtendField("completeCallback_", typeof(LuaFunction), "动画完成回调")]
[DescribeAttribute("Fx Animation 助手")]
public class FxAnimAssistant : DynamicEffectHelperBase
{
    public FxAnimationHelper FxAnimHelper=null;
    [HideInInspector]
    public List<int> PlayAnimIndexs = new List<int>();
    [HideInInspector]
    public bool IsPlayAllAnim = true;

    private Dictionary<int,TweenCallback> completeTweenCbDic=new Dictionary<int, TweenCallback>();
    
    #region 动效管理生命周期
    protected override bool _CheckValid()
    {
        if (FxAnimHelper == null)
        {
            MDebug.singleton.AddErrorLog("[FxAnimAssistant]数据非法，未分配FxAnimationHelper组件！助手ID:"+ID);
            return false;
        }

        return true;
    }
    
    protected override void _InitParam(Dictionary<string, object> paramDic)
    {
        HelperData[] helperDatas = FxAnimHelper.Helpers;
        if(helperDatas==null) return;

        IsPlayAllAnim = true;
        PlayAnimIndexs.Clear();
        completeTweenCbDic.Clear();
        
        string playAnimIndexsStr;
        if (_TryGetValueFromParamDic("PlayAnimIndexs", out playAnimIndexsStr, paramDic))
        {
            if (!string.IsNullOrEmpty(playAnimIndexsStr))
            {
                string[] playAnimIndexArray = playAnimIndexsStr.Split(',');
                foreach (var animIndexStr in playAnimIndexArray)
                {
                    int animIndex = 0;
                    if (int.TryParse(animIndexStr, out animIndex))
                    {
                        PlayAnimIndexs.Add(animIndex);
                    }
                    else
                    {
                        MDebug.singleton.AddErrorLog("[FxAnimAssistant]试图给PlayAnimIndexs传递非法的参数！");
                    }
                }

                IsPlayAllAnim = false;
            }
        }
            
        for (int i = 0; i < helperDatas.Length; i++)
        {
            var tempHelperData = helperDatas[i];
            if (IsPlayAllAnim || PlayAnimIndexs.Contains(i))
            {
                initSingleHelperData(i, tempHelperData, paramDic);
            }
        }
    }

    public override void OnAddHelper()
    {
        FxAnimHelper = gameObject.AddComponent<FxAnimationHelper>();
        FxAnimHelper.PlayOnEnable = false;
    }

    public override void OnRemoveHelper()
    {
        if (FxAnimHelper == null) return;
        
        DestroyImmediate(FxAnimHelper);
    }

    protected override void _Play()
    {
        if (IsPlayAllAnim)
        {
            FxAnimHelper.StopAll();
            FxAnimHelper.PlayAll();
            return;
        }

        for (int i = 0; i < FxAnimHelper.Helpers.Length; i++)
        {
            if (PlayAnimIndexs.Contains(i))
            {
                var tempHelper = FxAnimHelper.Helpers[i];
                FxAnimHelper.Stop(tempHelper);
                FxAnimHelper.Play(tempHelper);
                //fxAnimHelper会中播放的时候创建一个新的Tween，导致之前加的回调数据丢失，所以回调
                //需要在创建后重新添加
                if (completeTweenCbDic.ContainsKey(i))
                {
                    tempHelper.SetTweenCompleteCallback(completeTweenCbDic[i]);
                }
            }
        }
    }

    protected override void _Pause()
    {
        MDebug.singleton.AddWarningLog("[FxAnimAssistant] 组件不支持Pause!");
    }

    protected override void _Stop()
    {
        //当前组件只能停止所有动画
        FxAnimHelper.StopAll();
    }
    #endregion
    
    #region inner Function

    public void OnPlayAnimIndexsChange()
    {
        if (FxAnimHelper == null)
        {
            IsPlayAllAnim = false;
            return;
        }

        int currentChoosePlayAnimCount = PlayAnimIndexs.Count;
        //选择播放全部，或者未选择任意一个，则播放全部
        if (currentChoosePlayAnimCount == FxAnimHelper.Helpers.Length ||
            currentChoosePlayAnimCount==0)
        {
            IsPlayAllAnim = true;
            return;
        }

        IsPlayAllAnim = false;
    }
    
    private void initSingleHelperData(int index,HelperData animHelperData,Dictionary<string, object> paramDic)
    {
        if (animHelperData == null) return;
        
        GameObject bodyObj = null;
        GameObject startPosObj = null;
        GameObject endPosObj = null;
        float[] from;
        float[] from2;
        bool loopRandom;
        bool rangeFrom;
        float[] to;
        float[] to2;
        bool rangeTo;
        TweenCallback completeCb = null;
        
        //animHelperData.ClearTweenCompleteCallback();
        
        if (_TryGetValueFromParamDic("Body_" + index, out bodyObj, paramDic))
        {
            animHelperData.Body = bodyObj;
        }
        
        if (_TryGetValueFromParamDic("StartPos_" + index, out startPosObj, paramDic))
        {
            animHelperData.StartPos = startPosObj;
        }
        
        if (_TryGetValueFromParamDic("EndPos_" + index, out endPosObj, paramDic))
        {
            animHelperData.EndPos = endPosObj;
        }
        
        if(_TryGetFloatArrayFromParamDic("From_" + index,out from, paramDic))
        {
            animHelperData.From = from;
        }
        
        if(_TryGetFloatArrayFromParamDic("From2_" + index,out from2, paramDic))
        {
            animHelperData.From2 = from2;
        }
        
        if (_TryGetValueFromParamDic("LoopRandom_" + index, out loopRandom, paramDic))
        {
            animHelperData.LoopRandom = loopRandom;
        }
        
        if (_TryGetValueFromParamDic("RangeFrom_" + index, out rangeFrom, paramDic))
        {
            animHelperData.RangeFrom = rangeFrom;
        }
        
        if(_TryGetFloatArrayFromParamDic("To_" + index,out to, paramDic))
        {
            animHelperData.To = to;
        }
        
        if(_TryGetFloatArrayFromParamDic("To2_" + index,out to2, paramDic))
        {
            animHelperData.To2 = to2;
        }

        if (_TryGetValueFromParamDic("RangeTo_" + index, out rangeTo, paramDic))
        {
            animHelperData.RangeTo = rangeTo;
        }
         
        if (_TryGetDelegateFromParamDic("completeCallback_" + index, out completeCb, paramDic))
        {
            completeTweenCbDic.Add(index,completeCb);
            
        }

    }

    #endregion
}