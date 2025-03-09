using System.Collections.Generic;
using DG.Tweening;
using LuaInterface;
using MoonCommonLib;
using UnityEngine;

[ExtendField("特别描述", typeof(string), "以上属性默认为助手支持的第一个DotweenAnimation,如果多个动画传参则是则为[参数名animationID]," +
                                     "如给ID为2的动画的isFrom传参，key为isFrom_2")]
[ExtendField("isFrom_", typeof(bool), "对应于DotweenAnimation的From/To")]
[ExtendField("endValueFloat_", typeof(float), "动画参数为float的最终值，比如Fade动画")]
[ExtendField("endValueV3_", typeof(Vector3), "动画参数为Vector3的最终值，比如Move动画")]
[ExtendField("endValueV2_", typeof(Vector2), "动画参数为Vector2的最终值")]
[ExtendField("endValueColor_", typeof(Color), "动画参数为Color的最终值，比如颜色动画")]
[ExtendField("endValueString_", typeof(string), "动画参数为string的最终值，比如Text动画")]
[ExtendField("endValueRect_", typeof(Rect), "动画参数为Rect的最终值，比如Camera/Rect动画")]
[ExtendField("endValueTransform_", typeof(Transform), "动画参数为Transform的最终值，比如Move动画中目标改为Transform对象的动画")]
[ExtendField("optionalBool0_", typeof(bool), "对应与DotweenAnimation的optionalBool0")]
[ExtendField("optionalFloat0_", typeof(float), "对应与DotweenAnimation的optionalFloat0")]
[ExtendField("optionalInt0_", typeof(int), "对应与DotweenAnimation的optionalInt0")]
[ExtendField("optionalString_", typeof(string), "对应与DotweenAnimation的optionalString")]
[ExtendField("playDotweenIds_", typeof(string), "播放的dotweenId列表，及DotweenAnimation上的ID,以,分隔,如 1,2代表播放1和2")]
[ExtendField("completeCallback_", typeof(LuaFunction), "动画完成回调")]
[ExtendField("autoRewind_", typeof(bool), "每次变动是否自动恢复至动画初始位置")]
[Describe("DotweenAnimation 助手")]
public class DotweenAnimAssistant : DynamicEffectHelperBase
{
    [HideInInspector]
    public List<DOTweenAnimation> DotweenList = new List<DOTweenAnimation>();
    [HideInInspector]
    public List<string> PlayIdsList = new List<string>();

    protected override bool _CheckValid()
    {
        if (DotweenList.Count < 1)
        {
            MDebug.singleton.AddErrorLog("[DotweenHelper]播放失败，不存在DOTweenAnimation！");
            return false;
        }

        return true;
    }

    private void initDotweenAnimationParam(DOTweenAnimation dotweenAnim, List<string> tweenIdsList,
        Dictionary<string, object> paramDic)
    {
        if (dotweenAnim == null) return;

        string dotweenId = dotweenAnim.id;

        if (!IsPlayAllDotweenAnim() && !tweenIdsList.Contains(dotweenId)) return;

        //以下变量的解释在类的开头的特性中介绍过了
        bool isTweenDataChange = false;
        bool isFrom = false;
        double endValueFloat = 0;
        Vector3 endValueV3 = Vector3.zero;
        Vector2 endValueV2 = Vector2.zero;
        Color endValueColor;
        string endValueString = string.Empty;
        Rect endValueRect;
        Transform endValueTransform;
        bool optionalBool0 = false;
        double optionalFloat0 = 0;
        double optionalInt0 = 0;
        string optionalString = string.Empty;
        bool needAutoRewind = true;
        bool autoRewind = false;
        TweenCallback completeCb = null;
        bool changeCompleteCb = false;

        //清空旧的onComplete函数
        dotweenAnim.tween.onComplete = null;
        
        if (_TryGetValueFromParamDic("isFrom_" + dotweenId, out isFrom, paramDic))
        {
            dotweenAnim.isFrom = isFrom;
            isTweenDataChange = true;
        }

        if (_TryGetValueFromParamDic("endValueFloat_" + dotweenId, out endValueFloat, paramDic))
        {
            dotweenAnim.endValueFloat = (float)endValueFloat;
            isTweenDataChange = true;
        }

        if (_TryGetValueFromParamDic("endValueV3_" + dotweenId, out endValueV3, paramDic))
        {
            dotweenAnim.endValueV3 = endValueV3;
            isTweenDataChange = true;
        }

        if (_TryGetValueFromParamDic("endValueV2_" + dotweenId, out endValueV2, paramDic))
        {
            dotweenAnim.endValueV2 = endValueV2;
            isTweenDataChange = true;
        }

        if (_TryGetValueFromParamDic("endValueColor_" + dotweenId, out endValueColor, paramDic))
        {
            dotweenAnim.endValueColor = endValueColor;
            isTweenDataChange = true;
        }

        if (_TryGetValueFromParamDic("endValueString_" + dotweenId, out endValueString, paramDic))
        {
            dotweenAnim.endValueString = endValueString;
            isTweenDataChange = true;
        }

        if (_TryGetValueFromParamDic("endValueRect_" + dotweenId, out endValueRect, paramDic))
        {
            dotweenAnim.endValueRect = endValueRect;
            isTweenDataChange = true;
        }

        if (_TryGetValueFromParamDic("endValueTransform_" + dotweenId, out endValueTransform, paramDic))
        {
            dotweenAnim.endValueTransform = endValueTransform;
            isTweenDataChange = true;
        }

        if (_TryGetValueFromParamDic("optionalBool0_" + dotweenId, out optionalBool0, paramDic))
        {
            dotweenAnim.optionalBool0 = optionalBool0;
            isTweenDataChange = true;
        }

        if (_TryGetValueFromParamDic("optionalFloat0_" + dotweenId, out optionalFloat0, paramDic))
        {
            dotweenAnim.optionalFloat0 = (float)optionalFloat0;
            isTweenDataChange = true;
        }

        if (_TryGetValueFromParamDic("optionalInt0_" + dotweenId,out optionalInt0, paramDic))
        {
            dotweenAnim.optionalInt0 = (int)optionalInt0;
            isTweenDataChange = true;
        }

        if (_TryGetValueFromParamDic("optionalString_" + dotweenId, out optionalString, paramDic))
        {
            dotweenAnim.optionalString = optionalString;
            isTweenDataChange = true;
        }

        if (_TryGetValueFromParamDic("autoRewind_" + dotweenId, out autoRewind, paramDic))
        {
            needAutoRewind = autoRewind;
        }

        if (_TryGetDelegateFromParamDic("completeCallback_" + dotweenId, out completeCb, paramDic))
        {
            dotweenAnim.tween.onComplete = completeCb;
            changeCompleteCb = true;
        }
        //如果tween数据变化，重新生成tween
        if (isTweenDataChange)
        {
            if (needAutoRewind)
            {
                dotweenAnim.tween.Rewind();
            }
            dotweenAnim.tween.Kill();
            dotweenAnim.CreateTween();

            if (changeCompleteCb)
            {
                dotweenAnim.tween.onComplete = completeCb;
            }
        }
    }

    protected override void _InitParam(Dictionary<string, object> paramDic)
    {
        string playDotweenIds;

        PlayIdsList.Clear();
        if (_TryGetValueFromParamDic("playDotweenIds", out playDotweenIds, paramDic))
        {
            if (!string.IsNullOrEmpty(playDotweenIds))
            {
                string[] playTweenIdsArray = playDotweenIds.Split(',');
                foreach (var tweenId in playTweenIdsArray)
                {
                    PlayIdsList.Add(tweenId);
                }
            }
        }

        foreach (var dotweenAnim in DotweenList)
        {
            initDotweenAnimationParam(dotweenAnim, PlayIdsList, paramDic);
        }
    }

    public override void OnAddHelper()
    {
        DotweenList.Clear();
        DOTweenAnimation defaultTweenAnimation = gameObject.AddComponent<DOTweenAnimation>();
        DotweenList.Add(defaultTweenAnimation);
    }

    public override void OnRemoveHelper()
    {
        if (DotweenList.Count > 0)
        {
            DestroyImmediate(DotweenList[0]);
        }
    }

    protected override void _Play()
    {
        bool isPlayAll = IsPlayAllDotweenAnim();
        foreach (var dotweenAnim in DotweenList)
        {
            if (dotweenAnim == null) continue;

            if (isPlayAll || PlayIdsList.Contains(dotweenAnim.id))
            {
                dotweenAnim.tween.Restart();
            }
        }
    }

    public bool IsPlayAllDotweenAnim()
    {
        if (PlayIdsList == null) return true;
        if (PlayIdsList.Count < 1) return true;
        return false;
    }

    protected override void _Pause()
    {
        bool isPauseAll = IsPlayAllDotweenAnim();
        foreach (var dotweenAnim in DotweenList)
        {
            if (dotweenAnim == null) continue;

            if (isPauseAll || PlayIdsList.Contains(dotweenAnim.id))
            {
                dotweenAnim.tween.Pause();
            }
        }
    }

    protected override void _Stop()
    {
        bool isStopAll = IsPlayAllDotweenAnim();
        foreach (var dotweenAnim in DotweenList)
        {
            if (dotweenAnim == null) continue;

            if (isStopAll || PlayIdsList.Contains(dotweenAnim.id))
            {
                dotweenAnim.tween.Complete(true);
            }
        }
    }
}
