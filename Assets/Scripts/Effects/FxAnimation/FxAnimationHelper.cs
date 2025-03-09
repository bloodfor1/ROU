//*********************************************************************************

//文件名称(File Name)： FxAnimationHelper.cs 

//功能描述(Description)： 特效动画管理器

//数据表(Tables)： nothing

//作者(Author)： Starking

//Create Date: 2017.10.30

//修改记录(Revision History)： 2018.9.12

//*********************************************************************************

using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using DG.Tweening;
using Object = UnityEngine.Object;
using Random = UnityEngine.Random;
#if MOON_PROJ
using MoonCommonLib;
#endif

namespace FxAnimation
{
    public class FxAnimationHelper : MonoBehaviour
#if MOON_PROJ
        , IFxHelper
#endif
    {
        #region 序列化
        [SerializeField]
        private HelperData[] m_Helpers;
        [SerializeField]
        private int m_Repeat = 1;
        [SerializeField]
        private float m_RepeatCheck = -1;
        [SerializeField]
        private bool m_PlayOnEnable = true;
        [SerializeField]
        private bool m_IsStatic = false;
        [SerializeField]
        private bool m_StartEffect = false;
        #endregion
       
        #region 属性
        public HelperData[] Helpers
        {
            get { return m_Helpers; }
        }

        public int Repeat
        {
            get { return m_Repeat; }
            set { m_Repeat = value; }
        }

        public float RepeatCheck
        {
            get { return m_RepeatCheck; }
            set { m_RepeatCheck = value; }
        }

        public bool PlayOnEnable
        {
            get { return m_PlayOnEnable; }
            set { m_PlayOnEnable = value; }
        }

        public bool IsStatic
        {
            get { return m_IsStatic; }
            set { m_IsStatic = value; }
        }
        #endregion

#if UNITY_EDITOR

        #region 编辑器专用序列化
        [SerializeField]
        private int m_HelperID;
        #endregion

        #region 编辑器属性
        [LuaInterface.NoToLua]
        public int HelperID
        {
            get { return m_HelperID = (Helpers == null) ? -1 : Mathf.Clamp(m_HelperID, 0, Helpers.Length - 1); }
            set { m_HelperID = value; }
        }

        [LuaInterface.NoToLua]
        public Dictionary<Object, StateShot> StateShotDict
        {
            get
            {
                return _stateShotDict;
            }
        }
        #endregion

#endif

        #region 运行时变量
        private bool _isReadable;
        private Dictionary<Object, StateShot> _stateShotDict;//部分控制需要记录复位信息
        private Dictionary<Renderer, MaterialPropertyBlock> _rendererBlockDict;
        private Tween _loopTween; //整组循环播放专用tween
        private bool _isStateReset = false;
        #endregion

        #region Mono 方法

        private void Awake()
        {
            if (null == Helpers)
            {
                Debug.LogErrorFormat("{0} 序列化读取失败!", this.name);
                return;
            }

            _isReadable = true;

            System.Array.Sort(Helpers, Comparer);//按照时间线排序

#if MOON_PROJ

            if (null != MoonClientBridge.Bridge)
            {
                MoonClientBridge.Bridge.FxAnimationInit(Helpers, ref _stateShotDict, ref _rendererBlockDict);
            }
            else
            {
                InitData();
            }

#else

            InitData();

#endif

        }

        private void OnEnable()
        {

#if MOON_PROJ

            if (MGameContext.singleton.IsGameEditorMode || IsStatic)
            {
                if (PlayOnEnable)
                    PlayAll();
            }

#else

            if (PlayOnEnable)
                PlayAll();

#endif
        }

        private void OnDisable()
        {
            StopAll();
        }

        private void OnDestroy()
        {
            ReleasePool();
        }

        #endregion

        #region 公开方法

        /// <summary>
        /// 整组开始播放动画
        /// </summary>
        public void PlayAll()
        {
            if (!_isReadable)
                return;

            PlayAllOnce();

            //启用整组循环，注意循环时间为手动控制，超过该时间的循环会被强制中断
            PlayAllRepeat(RepeatCheck, Repeat);
        }

        /// <summary>
        /// 整组播放一次
        /// </summary>
        public void PlayAllOnce()
        {

#if MOON_PROJ

            if (null != MoonClientBridge.Bridge)
            {
                MoonClientBridge.Bridge.FxAnimationPlayAll(Helpers, _stateShotDict, ref _isStateReset);
            }
            else
            {
                StopAndReset(false);
                PlayAllInternal();
            }

#else

            StopAndReset(false);
            PlayAllInternal();

#endif

        }

        /// <summary>
        /// 添加结束回调
        /// </summary>
        public void addFinishCallbackByIndex(TweenCallback func,int index = -1)
        {
            if (index == -1)
            {
                index = Helpers.Length - 1;
            }
            if (Helpers[index].Tween != null)
            {
                Helpers[index].Tween.onComplete += func;
            }
            else
            {

            }
           
        }

        /// <summary>
        /// 停止所有动画
        /// </summary>
        public void StopAll()
        {
            //如果启用了整组循环，这里会在停止时结束tween的循环
            KillGroupLooping();

#if MOON_PROJ

            if (null != MoonClientBridge.Bridge)
            {
                MoonClientBridge.Bridge.FxAnimationStopAll(Helpers, _stateShotDict, ref _isStateReset);
            }
            else
            {
                StopAndReset(true);
            }

#else

            StopAndReset(true);

#endif
        }

        public void Stop(HelperData helper)
        {
            if (helper == null) return;

            if (helper.Tween != null)
            {
                helper.Tween.Kill();
                helper.Tween = null;
            } 
        }
        
        /// <summary>
        /// 变速
        /// </summary>
        public void SetSpeed(float v)
        {

#if MOON_PROJ

            if (null != MoonClientBridge.Bridge)
            {
                MoonClientBridge.Bridge.FxAnimationSetSpeed(Helpers, v);
            }
            else
            {
                SetSpeedInternal(v);
            }

#else
            SetSpeedInternal(v);

#endif

        }

        /// <summary>
        /// 单条播放接口，如果不启用自动播放，则可以按照给定条目单条播放
        /// </summary>
        public void Play(HelperData h)
        {
            switch ((ControlType)h.FxControlType)
            {
                case ControlType.PositionByGameObject:
                    {
                        if(h.StartPos != null && h.EndPos != null)
                        {
                            GameObject startGO = h.StartPos as GameObject;
                            GameObject endGO = h.EndPos as GameObject;

                            h.From = new float[3] { startGO.transform.localPosition.x, startGO.transform.localPosition.y, startGO.transform.localPosition.z};
                            h.To = new float[3] { endGO.transform.localPosition.x, endGO.transform.localPosition.y, endGO.transform.localPosition.z };
                            h.SetVector3();
                        }
                    }
                    break;
                case ControlType.Position://本地位移动画
                case ControlType.Rotation://本地旋转动画
                case ControlType.Scale://本地缩放动画
                    {
                        h.SetVector3();
                    }
                    break;
                case ControlType.ProjectorSize://投影尺寸动画
                    {
                        h.SetFloat(2);
                    }
                    break;
                case ControlType.CanvasAlpha://UI图组渐隐
                    {
                        h.SetFloat(3);
                    }
                    break;
                case ControlType.RadialBlurEffect:
                    {
                        h.SetRadialBlurEffect();
                    }
                    break;
                case ControlType.Visible://物体显示隐藏控制
                    {
                        h.SetVisible();
                    }
                    break;
                case ControlType.MeleeTrail://启用特效拖尾
                    {
                        h.SetEmitState();
                    }
                    break;
                case ControlType.Color://颜色动画
                    {
                        h.SetColor(CanColorReset(h));
                    }
                    break;
                case ControlType.Mat_Float://材质单通道属性动画，需帧确认载体可访问性
                    {
                        int type = h.GetMapFloatAnimType();
                        h.SetFloat(type);
                    }
                    break;
                case ControlType.Mat_Vector://材质多通道属性动画，需帧确认载体可访问性
                    {
                        int type = h.GetMapVectorAnimType();
                        h.SetVector4(type);
                    }
                    break;
                case ControlType.Mat_UV://材质UV属性动画，需帧确认载体可访问性
                case ControlType.Mat_AniSprite://材质序列图动画，需帧确认载体可访问性
                    {
                        h.SetUV();
                    }
                    break;
            }
        }

        public void SetPlayTime(float time)
        {
            for (int i = 0, c = Helpers.Length; i < c; i++)
            {
                Helpers[i].UpdateBodyStateByTime(time);
            }
        }

        public float GetFxAnimTotalPlayTime()
        {
            int helpersNum = Helpers.Length;
            float currentMaxTime = 0;
            for (int i = 0; i < helpersNum; i++)
            {
                var helperData = Helpers[i];
                currentMaxTime = Mathf.Max(currentMaxTime, helperData.GetAnimTotalTime());
            }

            return currentMaxTime;
        }
        
        #region 新增与初始化
        /// <summary>
        /// 初始化控制项
        /// </summary>
        public void InitHelper()
        {
            m_Helpers = new HelperData[0];
        }

        /// <summary>
        /// 添加一条控制项
        /// </summary>
        public int AddHelper(HelperData helper)
        {
            int pos = Helpers.Length;
            System.Array.Resize(ref m_Helpers, pos + 1);
            Helpers[pos] = helper;
            return pos;
        }

        #endregion

        #endregion

        #region 状态复位控制

        /// <summary>
        /// 初始化数据，并记录快照以便复位
        /// </summary>
        public void InitData()
        {
            for (int i = 0, c = Helpers.Length; i < c; i++)
            {
                Helpers[i].SortedID = i;

                if (Helpers[i].Body is Renderer && null == _rendererBlockDict)
                {
#if MOON_PROJ
                    _rendererBlockDict = MDictionaryPool<Renderer, MaterialPropertyBlock>.Get();
#else
                    _rendererBlockDict = new Dictionary<Renderer, MaterialPropertyBlock>();
#endif
                }

                Helpers[i].InitData(_rendererBlockDict);
                RecordState(Helpers[i]);//记忆初始状态
            }
        }

        /// <summary>
        /// 复位状态，可在停止时操作，也可以在启动前操作
        /// </summary>
        /// <param name="atStopPhase">是否在停止阶段作此操作</param>
        private void StopAndReset(bool atStopPhase = false)
        {
            //将原本的重播复位移到结束复位，结束后复位会设置已复位标记，如果这个操作没有执行，则会在重播开始执行复位操作
            if (!_isStateReset)
            {
                KillLiveTween();
                ResetState();

                if (atStopPhase)
                {
                    _isStateReset = true;
                }
            }
        }

        /// <summary>
        /// 强行停止正在播放的tween
        /// </summary>
        private void KillLiveTween()
        {
            for (int i = 0, c = Helpers.Length; i < c; i++)
            {
                Helpers[i].Tween?.Kill(false);
                Helpers[i].Tween = null;
            }
        }

        /// <summary>
        /// 停止循环组的tween
        /// </summary>
        private void KillGroupLooping()
        {
            _loopTween?.Kill();
            _loopTween = null;
        }

        /// <summary>
        /// 记忆初始化状态
        /// </summary>
        /// <param name="h"></param>
        private void RecordState(HelperData h)
        {
            //保存变换的首帧信息，以便复位
            if (h.Transform)
            {
                GetStateShotDict();

                switch ((ControlType)h.FxControlType)
                {
                    case ControlType.Position:
                        {
                            StateShot stateShot;

                            if (_stateShotDict.TryGetValue(h.Body, out stateShot))
                            {
                                if (!stateShot.posCached)
                                {
                                    stateShot.posCached = true;
                                    stateShot.position = h.Transform.localPosition;
                                }
                                _stateShotDict[h.Body] = stateShot;
                            }
                            else
                            {
                                stateShot.posCached = true;
                                stateShot.position = h.Transform.localPosition;
                                _stateShotDict.Add(h.Body, stateShot);
                            }
                        }
                        break;
                    case ControlType.Rotation:
                        {
                            StateShot stateShot;

                            if (_stateShotDict.TryGetValue(h.Body, out stateShot))
                            {
                                if (!stateShot.rotCached)
                                {
                                    stateShot.rotCached = true;
                                    stateShot.rotation = h.Transform.localEulerAngles;
                                }
                                _stateShotDict[h.Body] = stateShot;
                            }
                            else
                            {
                                stateShot.rotCached = true;
                                stateShot.rotation = h.Transform.localEulerAngles;
                                _stateShotDict.Add(h.Body, stateShot);
                            }
                        }
                        break;
                    case ControlType.Scale:
                        {
                            StateShot stateShot;

                            if (_stateShotDict.TryGetValue(h.Body, out stateShot))
                            {
                                if (!stateShot.sclCached)
                                {
                                    stateShot.sclCached = true;
                                    stateShot.scale = h.Transform.localScale;
                                }
                                _stateShotDict[h.Body] = stateShot;
                            }
                            else
                            {
                                stateShot.sclCached = true;
                                stateShot.scale = h.Transform.localScale;
                                _stateShotDict.Add(h.Body, stateShot);
                            }
                        }
                        break;
                }
            }
            else if (h.Gameobject)
            {
                if (h.FxControlType == (byte)ControlType.Visible)
                {
                    GetStateShotDict();
                    StateShot stateShot;

                    if (_stateShotDict.TryGetValue(h.Body, out stateShot))
                    {
                        if (!stateShot.tglCached)
                        {
                            stateShot.tglCached = true;
                            stateShot.toggle = h.Gameobject.activeSelf;
                            _stateShotDict[h.Body] = stateShot;
                        }
                    }
                    else
                    {
                        stateShot.tglCached = true;
                        stateShot.toggle = h.Gameobject.activeSelf;
                        _stateShotDict.Add(h.Body, stateShot);
                    }
                }
            }
            else if (h.Projector)
            {
                GetStateShotDict();

                switch ((ControlType)h.FxControlType)
                {
                    case ControlType.ProjectorSize:
                        {
                            StateShot stateShot;

                            if (_stateShotDict.TryGetValue(h.Body, out stateShot))
                            {
                                if (!stateShot.valCached)
                                {
                                    stateShot.valCached = true;
                                    stateShot.value = h.Projector.orthographicSize;
                                    _stateShotDict[h.Body] = stateShot;
                                }
                            }
                            else
                            {
                                stateShot.valCached = true;
                                stateShot.value = h.Projector.orthographicSize;
                                stateShot.lastColorHelperID = -1;
                                _stateShotDict.Add(h.Body, stateShot);
                            }
                        }
                        break;
                    case ControlType.Color:
                        {
                            StateShot stateShot;

                            if (_stateShotDict.TryGetValue(h.Body, out stateShot))
                            {
                                stateShot.lastColorHelperID = h.SortedID;
                                _stateShotDict[h.Body] = stateShot;
                            }
                            else
                            {
                                stateShot.lastColorHelperID = h.SortedID;
                                _stateShotDict.Add(h.Body, stateShot);
                            }
                        }
                        break;
                }
            }
            else if (null != h.MeleeTrail)
            {
                GetStateShotDict();

                switch ((ControlType)h.FxControlType)
                {
                    case ControlType.MeleeTrail:
                        {
                            StateShot stateShot;

                            if (_stateShotDict.TryGetValue(h.Body, out stateShot))
                            {
                                if (!stateShot.tglCached)
                                {
                                    stateShot.tglCached = true;
                                    stateShot.toggle = h.MeleeTrail.Emit;
                                    _stateShotDict[h.Body] = stateShot;
                                }
                            }
                            else
                            {
                                stateShot.tglCached = true;
                                stateShot.toggle = h.MeleeTrail.Emit;
                                stateShot.lastColorHelperID = -1;
                                _stateShotDict.Add(h.Body, stateShot);
                            }
                        }
                        break;
                    case ControlType.Color:
                        {
                            StateShot stateShot;

                            if (_stateShotDict.TryGetValue(h.Body, out stateShot))
                            {
                                stateShot.lastColorHelperID = h.SortedID;
                                _stateShotDict[h.Body] = stateShot;
                            }
                            else
                            {
                                stateShot.lastColorHelperID = h.SortedID;
                                _stateShotDict.Add(h.Body, stateShot);
                            }
                        }
                        break;
                }
            }
            else if (h.Renderer || h.Graphic)
            {
                if (h.FxControlType == (byte)ControlType.Color)
                {
                    GetStateShotDict();
                    StateShot stateShot;

                    if (_stateShotDict.TryGetValue(h.Body, out stateShot))
                    {
                        stateShot.lastColorHelperID = h.SortedID;
                        _stateShotDict[h.Body] = stateShot;
                    }
                    else
                    {
                        stateShot.lastColorHelperID = h.SortedID;
                        _stateShotDict.Add(h.Body, stateShot);
                    }
                }
            }
        }

        /// <summary>
        /// 生成一个初始化状态字典
        /// </summary>
        private void GetStateShotDict()
        {
            if (null == _stateShotDict)
            {
#if MOON_PROJ
                _stateShotDict = MDictionaryPool<Object, StateShot>.Get();
#else
                _stateShotDict = new Dictionary<Object, StateShot>();
#endif
            }
        }

        /// <summary>
        /// 还原初始化状态
        /// </summary>
        private void ResetState()
        {
            if (null != _stateShotDict)
            {
                foreach (var s in _stateShotDict)
                {
                    if (!s.Key)
                    {
                        continue;
                    }

                    if (s.Key is Transform)
                    {
                        if (s.Value.posCached)
                        {
                            (s.Key as Transform).localPosition = s.Value.position;
                        }
                        if (s.Value.rotCached)
                        {
                            (s.Key as Transform).localEulerAngles = s.Value.rotation;
                        }
                        if (s.Value.sclCached)
                        {
                            (s.Key as Transform).localScale = s.Value.scale;
                        }
                    }
                    else if (s.Key is GameObject)
                    {
                        var go = s.Key as GameObject;
                        if (s.Value.tglCached && go && go.activeSelf != s.Value.toggle)
                        {
                            go.SetActive(s.Value.toggle);
                        }
                    }
                    else if (s.Key is Projector)
                    {
                        if (s.Value.valCached)
                        {
                            (s.Key as Projector).orthographicSize = s.Value.value;
                        }
                    }
                    else if (s.Key is MeleeTrail)
                    {
                        if (s.Value.tglCached)
                        {
                            (s.Key as MeleeTrail).emit = s.Value.toggle;
                        }
                    }
                }
            }
        }

        /// <summary>
        /// 清空缓存信息
        /// </summary>
        private void ReleasePool()
        {
#if MOON_PROJ

            if (null != MoonClientBridge.Bridge)
            {
                MoonClientBridge.Bridge.FxAnimationRelease(Helpers, ref _stateShotDict, ref _rendererBlockDict);
            }
            else
            {
                ReleasePoolInternal();
            }

#else

            ReleasePoolInternal();

#endif
        }

        /// <summary>
        /// 清空缓存信息
        /// </summary>
        private void ReleasePoolInternal()
        {
            for (int i = Helpers.Length - 1; i >= 0; i--)
            {
                if (Helpers[i].SharedMaterial && Helpers[i].Material)
                {
                    if (Helpers[i].Projector)
                    {
                        Helpers[i].Projector.material = Helpers[i].SharedMaterial;
                    }
                    else if (Helpers[i].Graphic)
                    {
                        Helpers[i].Graphic.material = Helpers[i].SharedMaterial;
                    }
                    else if (null != Helpers[i].MeleeTrail)
                    {
                        Helpers[i].MeleeTrail.Material = Helpers[i].SharedMaterial;
                    }

                    Destroy(Helpers[i].Material);

                    Helpers[i].Material = null;
                }

                if (null != Helpers[i].Block)
                {
                    Helpers[i].Block = null;
                }
            }

            if (null != _stateShotDict)
            {
#if MOON_PROJ
                MDictionaryPool<Object, StateShot>.Release(_stateShotDict);
#else
                _stateShotDict.Clear();
#endif
                _stateShotDict = null;
            }

            if (null != _rendererBlockDict)
            {
                foreach (var k in _rendererBlockDict)
                {
                    if (null != k.Value)
                    {
                        k.Value.Clear();
                    }
                }

#if MOON_PROJ
                MDictionaryPool<Renderer, MaterialPropertyBlock>.Release(_rendererBlockDict);
#else
                _rendererBlockDict.Clear();
#endif
                _rendererBlockDict = null;
            }
        }

        /// <summary>
        /// 判断颜色复位阶段
        /// </summary>
        /// <param name="h"></param>
        /// <returns></returns>
        private bool CanColorReset(HelperData h)
        {
            StateShot stateShot;

            return _stateShotDict != null
                && _stateShotDict.TryGetValue(h.Body, out stateShot)
                && stateShot.lastColorHelperID == h.SortedID;
        }

        #endregion

        #region 其他私有方法

        /// <summary>
        /// 使用自带方法初始化
        /// </summary>
        private void InitInternal()
        {
            for (int i = 0, c = Helpers.Length; i < c; i++)
            {
                Helpers[i].SortedID = i;

                if (Helpers[i].Body is Renderer && null == _rendererBlockDict)
                {
#if MOON_PROJ
                    _rendererBlockDict = MDictionaryPool<Renderer, MaterialPropertyBlock>.Get();
#else
                    _rendererBlockDict = new Dictionary<Renderer, MaterialPropertyBlock>();
#endif
                }

                Helpers[i].InitData(_rendererBlockDict);
                RecordState(Helpers[i]);//记忆初始状态
            }
        }

        /// <summary>
        /// 使用自带方法依次播放
        /// </summary>
        private void PlayAllInternal()
        {
            _isStateReset = false;
            for (int i = 0, c = Helpers.Length; i < c; i++)
            {
                Play(Helpers[i]);
            }
        }

        /// <summary>
        /// 整组循环重复，这个操作默认跳过第一次播放，因此计数减一
        /// </summary>
        /// <param name="repeatCheck"></param>
        /// <param name="repeat"></param>
        private void PlayAllRepeat(float repeatCheck, int repeat)
        {
            //重复播放时，如果之前的grouptween没有停掉，则需要强行停止
            KillGroupLooping();

            if ((repeat == -1 || repeat > 1) && repeatCheck > 0)
            {
                _loopTween = DOTween.To(UpdateInDelay, 0, 1, repeatCheck);
                _loopTween.SetLoops((repeat == -1) ? -1 : (repeat - 1));
                _loopTween.OnStepComplete(PlayAllOnce);
            }
        }

        /// <summary>
        /// Tween变速
        /// </summary>
        /// <param name="v"></param>
        private void SetSpeedInternal(float v)
        {
            for (int i = 0, c = Helpers.Length; i < c; i++)
            {
                if (null != Helpers[i].Tween)
                {
                    Helpers[i].Tween.timeScale = v;
                }
            }
        }

        /// <summary>
        /// 比较排序
        /// </summary>
        /// <param name="a"></param>
        /// <param name="b"></param>
        /// <returns></returns>
        private static int Comparer(HelperData a, HelperData b)
        {
            return a.Delay.CompareTo(b.Delay);
        }

        /// <summary>
        ///占位循环
        /// </summary>
        /// <param name="t"></param>
        private static void UpdateInDelay(float t) { }

        #endregion
    }

    #region 运行时控制扩展

    public static class MHelperDataExtension
    {
        private static readonly string DEFAULT_MAT_TAG = "Default";

        //获得属性对应nameID
        private static void GetPropertyID(this HelperData h)
        {
            if (h.FxControlType == (byte)ControlType.Mat_UV || h.FxControlType == (byte)ControlType.Mat_AniSprite)
            {
                h.PropertyID = Shader.PropertyToID(string.Format("{0}_ST", h.Property));
            }
            else
            {
                h.PropertyID = Shader.PropertyToID(h.Property);
            }
        }

        private static bool IsForceNewRange(this HelperData h)
        {
            return h.RangeFrom || h.RangeTo;
        }

        public static void InitData(this HelperData h, Dictionary<Renderer, MaterialPropertyBlock> blockDict)
        {
            if (h.Body is GameObject)
            {
                h.Gameobject = h.Body as GameObject;
            }
            else if (h.Body is Transform)
            {
                h.Transform = h.Body as Transform;
            }
            else if (h.Body is Renderer)
            {
                //所有的renderer都可以使用mpb优化
                h.Renderer = h.Body as Renderer;

                MaterialPropertyBlock block;

                if (!blockDict.TryGetValue(h.Renderer, out block))
                {
#if MOON_PROJ
                    block = MCommonObjectPool<MaterialPropertyBlock>.Get();
#else
                    block = new MaterialPropertyBlock();
#endif
                    blockDict.Add(h.Renderer, block);
                    h.Renderer.GetPropertyBlock(block);
                }

                h.Block = block;
                h.GetPropertyID();
            }
            else if (h.Body is Graphic)
            {
                h.Graphic = h.Body as Graphic;
                //如果是更改UI材质上的颜色，要排除掉默认材质
                if (!h.ImageColor)
                {
                    if (!h.Graphic.material.name.StartsWith(DEFAULT_MAT_TAG))
                    {
                        h.SharedMaterial = h.Graphic.material;
                        h.Material = new Material(h.SharedMaterial);
                        h.Graphic.material = h.Material;
                        h.GetPropertyID();
                    }
                }
            }
            else if (h.Body is Projector)
            {
                h.Projector = h.Body as Projector;
                h.SharedMaterial = h.Projector.material;
                h.Material = new Material(h.SharedMaterial);
                h.Projector.material = h.Material;
                h.GetPropertyID();
            }
#if MOON_PROJ
            else if (h.Body is IMeleeTrail)
            {
                h.MeleeTrail = h.Body as IMeleeTrail;
                h.SharedMaterial = h.MeleeTrail.Material;
                h.Material = new Material(h.SharedMaterial);
                h.MeleeTrail.Material = h.Material;
                h.GetPropertyID();
            }
#else
            else if (h.Body is MeleeTrail)
            {
                h.MeleeTrail = h.Body as MeleeTrail;
                h.SharedMaterial = h.MeleeTrail.Material;
                h.Material = new Material(h.SharedMaterial);
                h.MeleeTrail.Material = h.Material;
                h.GetPropertyID();
            }
#endif
            else if (h.Body is CanvasGroup)
            {
                h.CanvasGroup = h.Body as CanvasGroup;
            }
        }

        #region 取得范围

        //从结构序列化到float值，并获得随机区间中的值
        public static void GetFloatRange(this HelperData h)
        {
            //初始化一次即可，如果有随机需要会取消
            if (h.IsForceNewRange())
            {
                h.IsInited = false;
            }

            if (h.IsInited)
            {
                return;
            }

            var from = GetFloatValue(h.From);
            var to = GetFloatValue(h.To);
            if (h.RangeFrom)
            {
                var from2 = GetFloatValue(h.From2);
                from = Random.Range(from, from2);
            }
            if (h.RangeTo)
            {
                var to2 = GetFloatValue(h.To2);
                to = Random.Range(to, to2);
            }

            h.FromF = from;
            h.ToF = to;

            h.IsInited = true;
        }

        //从结构序列化到vector值，并获得随机区间中的值
        public static void GetVector3Range(this HelperData h)
        {
            //初始化一次即可，如果有随机需要会取消
            if (h.IsForceNewRange())
            {
                h.IsInited = false;
            }

            if (h.IsInited)
            {
                return;
            }

            var from = GetVector3Value(h.From);
            var to = GetVector3Value(h.To);
            if (h.RangeFrom)
            {
                var from2 = GetVector3Value(h.From2);
                from.Set(Random.Range(from.x, from2.x), Random.Range(from.y, from2.y), Random.Range(from.z, from2.z));
            }
            if (h.RangeTo)
            {
                var to2 = GetVector3Value(h.To2);
                to.Set(Random.Range(to.x, to2.x), Random.Range(to.y, to2.y), Random.Range(to.z, to2.z));
            }

            h.FromV3 = from;
            h.ToV3 = to;

            h.IsInited = true;
        }

        //从结构序列化到float值，并获得随机区间中的值
        public static void GetVector4Range(this HelperData h)
        {
            //初始化一次即可，如果有随机需要会取消
            if (h.IsForceNewRange())
            {
                h.IsInited = false;
            }

            if (h.IsInited)
            {
                return;
            }

            var from = GetVector4Value(h.From);
            var to = GetVector4Value(h.To);
            if (h.RangeFrom)
            {
                var from2 = GetVector4Value(h.From2);
                from.Set(Random.Range(from.x, from2.x), Random.Range(from.y, from2.y), Random.Range(from.z, from2.z), Random.Range(from.w, from2.w));
            }
            if (h.RangeTo)
            {
                var to2 = GetVector4Value(h.To2);
                to.Set(Random.Range(to.x, to2.x), Random.Range(to.y, to2.y), Random.Range(to.z, to2.z), Random.Range(to.w, to2.w));
            }

            h.FromV4 = from;
            h.ToV4 = to;

            h.IsInited = true;
        }

        //获得序列图坐标组
        public static void GetSprites(this HelperData h)
        {
            //初始化一次即可，如果有随机需要会取消
            if (h.IsInited)
            {
                return;
            }

            int xCount = (int)h.From[0];
            int yCount = (int)h.To[0];
            var pu = 1f / Mathf.Max(1, xCount);
            var pv = 1f / Mathf.Max(1, yCount);
            var tiling = new Vector2(pu, pv);
            var count = xCount * yCount;
            var arr = new Vector4[count];
            for (int y = 0, l = 0; y < yCount; y++)
            {
                for (int x = 0; x < xCount; x++, l++)
                {
                    arr[l] = new Vector4(pu, pv, pu * x, 1 - (pv * y + pv));//xy = scale, zw = offset
                }
            }

            h.Sprites = arr;
            h.SpriteCount = count;
            h.SpriteCur = 0;

            h.IsInited = true;
        }

        public static float GetFloatValue(float[] vArray)
        {
            if (vArray != null && vArray.Length >= 1)
                return vArray[0];
            return 0;
        }

        public static Vector3 GetVector3Value(float[] vArray)
        {
            if (vArray != null && vArray.Length >= 3)
                return new Vector3(vArray[0], vArray[1], vArray[2]);
            return Vector3.zero;
        }

        public static Vector4 GetVector4Value(float[] vArray)
        {
            if (vArray != null && vArray.Length >= 4)
                return new Vector4(vArray[0], vArray[1], vArray[2], vArray[3]);
            return Vector4.zero;
        }

        #endregion

        #region 取得当前值 
        
        //取得区间中对应时间的float值
        public static float EvaluateFloat(this HelperData h, float time)
        {
            return h.FxLerpType == (byte)LerpType.Ease ? Mathf.LerpUnclamped(h.FromF, h.ToF, time) : h.Curves[0].Evaluate(time) * h.FromF;
        }

        //取得区间中对应时间的vector3值
        public static Vector3 EvaluateVector3(this HelperData h, float time)
        {
            switch ((LerpType)h.FxLerpType)
            {
                case LerpType.SingleCurve:
                        return h.Curves[0].Evaluate(time) * h.FromV3;
                case LerpType.AxisCurve:
                        return new Vector3()
                        {
                            x = h.Curves[0].Evaluate(time) * h.FromV3.x,
                            y = h.Curves[1].Evaluate(time) * h.FromV3.y,
                            z = h.Curves[2].Evaluate(time) * h.FromV3.z
                        };
                default:
                        return Vector3.LerpUnclamped(h.FromV3, h.ToV3, time);
            }
        }

        //取得区间中对应时间的vector4值
        public static Vector4 EvaluateVector4(this HelperData h, float time)
        {
            switch ((LerpType)h.FxLerpType)
            {
                case LerpType.SingleCurve:
                    return h.Curves[0].Evaluate(time) * h.FromV4;
                case LerpType.AxisCurve:
                    return new Vector4()
                    {
                        x = h.Curves[0].Evaluate(time) * h.FromV4.x,
                        y = h.Curves[1].Evaluate(time) * h.FromV4.y,
                        z = h.Curves[2].Evaluate(time) * h.FromV4.z,
                        w = h.Curves[3].Evaluate(time) * h.FromV4.w
                    };
                default:
                    return Vector4.LerpUnclamped(h.FromV4, h.ToV4, time);
            }
        }

        #endregion

        #region 重复循环

        public static void RestartFloatLerp(this HelperData h)
        {
            h.IsInited = false;
            h.GetFloatRange();
            h.Tween?.Restart(false);
        }

        public static void RestartVector3Lerp(this HelperData h)
        {
            h.IsInited = false;
            h.GetVector3Range();
            h.Tween?.Restart(false);
        }

        public static void RestartVector4Lerp(this HelperData h)
        {
            h.IsInited = false;
            h.GetVector4Range();
            h.Tween?.Restart(false);
        }

        #endregion

        #region 改变值
        
        public static void SetPosition(this HelperData h, float t)
        {
            if (h.Transform)
            {
                h.Transform.localPosition = h.EvaluateVector3(t);
            }
        }

        public static void SetRotation(this HelperData h, float t)
        {
            if (h.Transform)
            {
                h.Transform.localEulerAngles = h.EvaluateVector3(t);
            }
        }

        public static void SetScale(this HelperData h, float t)
        {
            if (h.Transform)
            {
                h.Transform.localScale = h.EvaluateVector3(t);
            }
        }

        public static void SetImageColor(this HelperData h, float t)
        {
            if (h.Graphic)
            {
                h.Graphic.color = h.ColorGrad.Evaluate(t);
            }
        }

        public static void SetMaterialColor(this HelperData h, float t)
        {
            if (h.Material)
            {
                h.Material.SetColor(h.PropertyID, h.ColorGrad.Evaluate(t));
            }
        }

        public static void SetBlockColor(this HelperData h, float t)
        {
            if (null != h.Block && h.Renderer)
            {
                h.Block.SetColor(h.PropertyID, h.ColorGrad.Evaluate(t));
                h.Renderer.SetPropertyBlock(h.Block);
            }
        }

        public static void SetMaterialValue(this HelperData h, float t)
        {
            if (h.Material)
            {
                h.Material.SetFloat(h.PropertyID, h.EvaluateFloat(t));
            }
        }

        public static void SetBlockValue(this HelperData h, float t)
        {
            if (null != h.Block && h.Renderer)
            {
                h.Block.SetFloat(h.PropertyID, h.EvaluateFloat(t));
                h.Renderer.SetPropertyBlock(h.Block);
            }
        }

        public static void SetMaterialVector(this HelperData h, float t)
        {
            if (h.Material)
            {
                h.Material.SetVector(h.PropertyID, h.EvaluateVector4(t));
            }
        }

        public static void SetBlockVector(this HelperData h, float t)
        {
            if (null != h.Block && h.Renderer)
            {
                h.Block.SetVector(h.PropertyID, h.EvaluateVector4(t));
                h.Renderer.SetPropertyBlock(h.Block);
            }
        }

        public static void SetProjSize(this HelperData h, float t)
        {
            if (h.Projector)
            {
                h.Projector.orthographicSize = h.EvaluateFloat(t);
            }
        }

        public static void SetCanvasAlpha(this HelperData h, float t)
        {
            if (h.CanvasGroup)
            {
                h.CanvasGroup.alpha = h.EvaluateFloat(t);
            }
        }

        public static void SetMaterialSprite(this HelperData h, float t)
        {
            var cur = Mathf.Min(h.SpriteCount - 1, (int)Mathf.Lerp(0, h.SpriteCount, t));
            if (cur != h.SpriteCur)
            {
                h.SpriteCur = cur;

                if (h.Material)
                {
                    h.Material.SetVector(h.PropertyID, h.Sprites[cur]);
                }
            }
        }

        public static void SetBlockSprite(this HelperData h, float t)
        {
            var cur = Mathf.Min(h.SpriteCount - 1, (int)Mathf.Lerp(0, h.SpriteCount, t));
            if (cur != h.SpriteCur)
            {
                h.SpriteCur = cur;

                if (null != h.Block && h.Renderer)
                {
                    h.Block.SetVector(h.PropertyID, h.Sprites[cur]);
                    h.Renderer.SetPropertyBlock(h.Block);
                }
            }
        }

        public static void SetActive(this HelperData h)
        {
            if (h.Gameobject && !h.Gameobject.activeSelf)
            {
                h.Gameobject.SetActive(true);
            }
        }

        public static void SetDeactive(this HelperData h)
        {
            if (h.Gameobject && h.Gameobject.activeSelf)
            {
                h.Gameobject.SetActive(false);
            }
        }

        public static void StartEmit(this HelperData h)
        {
            if (h.MeleeTrail != null && !h.MeleeTrail.Emit)
            {
                h.MeleeTrail.Emit = true;
            }
        }

        public static void StopEmit(this HelperData h)
        {
            if (h.MeleeTrail != null && h.MeleeTrail.Emit)
            {
                h.MeleeTrail.Emit = false;
            }
        }

        public static void ResetImageColor(this HelperData h)
        {
            if (h.Graphic)
            {
                h.Graphic.color = Color.white;
            }
        }

        public static void ResetMaterialColor(this HelperData h)
        {
            if (h.Material)
            {
                h.Material.SetColor(h.PropertyID, Color.clear);
            }
        }

        public static void ResetBlockColor(this HelperData h)
        {
            if (null != h.Block && h.Renderer)
            {
                h.Block.SetColor(h.PropertyID, Color.clear);
                h.Renderer.SetPropertyBlock(h.Block);
            }
        }

        /// <summary>
        /// 设置三维矢量
        /// </summary>
        /// <param name="h"></param>
        public static void SetVector3(this HelperData h)
        {
            h.GetVector3Range();

            if (h.LoopRandom)
            {
                switch ((ControlType)h.FxControlType)
                {
                    case ControlType.PositionByGameObject:
                    case ControlType.Position:
                        h.SetValue(h.SetPosition, null, h.RestartVector3Lerp, null);
                        break;
                    case ControlType.Rotation:
                        h.SetValue(h.SetRotation, null, h.RestartVector3Lerp, null);
                        break;
                    case ControlType.Scale:
                        h.SetValue(h.SetScale, null, h.RestartVector3Lerp, null);
                        break;
                }
            }
            else
            {
                switch ((ControlType)h.FxControlType)
                {
                    case ControlType.PositionByGameObject:
                    case ControlType.Position:
                        h.SetValue(h.SetPosition, null, null, null);
                        break;
                    case ControlType.Rotation:
                        h.SetValue(h.SetRotation, null, null, null);
                        break;
                    case ControlType.Scale:
                        h.SetValue(h.SetScale, null, null, null);
                        break;
                }
            }
        }

        /// <summary>
        /// 设置四维矢量
        /// </summary>
        /// <param name="h"></param>
        /// <param name="typeID">0 = mpb, 1 = mat</param>
        public static void SetVector4(this HelperData h, int typeID)
        {
            h.GetVector4Range();

            if (h.LoopRandom)
            {
                switch (typeID)
                {
                    case 0:
                        h.SetValue(h.SetBlockVector, null, h.RestartVector4Lerp, null);
                        break;
                    case 1:
                        h.SetValue(h.SetMaterialVector, null, h.RestartVector4Lerp, null);
                        break;
                }
            }
            else
            {
                switch (typeID)
                {
                    case 0:
                        h.SetValue(h.SetBlockVector, null, null, null);
                        break;
                    case 1:
                        h.SetValue(h.SetMaterialVector, null, null, null);
                        break;
                }
            }
        }

        public static void SetVector4ByTime(this HelperData h, float time)
        {
            h.GetVector4Range();
            int typeID = h.GetMapVectorAnimType();
            if (h.LoopRandom)
            {
                switch (typeID)
                {
                    case 0:
                        h.SetBlockVector(time);
                        break;
                    case 1:
                        h.SetMaterialVector(time);
                        break;
                }
            }
            else
            {
                switch (typeID)
                {
                    case 0:
                        h.SetBlockVector(time);
                        break;
                    case 1:
                        h.SetMaterialVector(time);
                        break;
                }
            }
        }
        /// <summary>
        /// 设置值
        /// </summary>
        /// <param name="h"></param>
        /// <param name="typeID">0 = mpb, 1 = mat 2 = size 3 = alpha</param>
        public static void SetFloat(this HelperData h, int typeID)
        {
            h.GetFloatRange();

            if (h.LoopRandom)
            {
                switch (typeID)
                {
                    case 0:
                        h.SetValue(h.SetBlockValue, null, h.RestartFloatLerp, null);
                        break;
                    case 1:
                        h.SetValue(h.SetMaterialValue, null, h.RestartFloatLerp, null);
                        break;
                    case 2:
                        h.SetValue(h.SetProjSize, null, h.RestartFloatLerp, null);
                        break;
                    case 3:
                        h.SetValue(h.SetCanvasAlpha, null, h.RestartFloatLerp, null);
                        break;
                }
            }
            else
            {
                switch (typeID)
                {
                    case 0:
                        h.SetValue(h.SetBlockValue, null, null, null);
                        break;
                    case 1:
                        h.SetValue(h.SetMaterialValue, null, null, null);
                        break;
                    case 2:
                        h.SetValue(h.SetProjSize, null, null, null);
                        break;
                    case 3:
                        h.SetValue(h.SetCanvasAlpha, null, null, null);
                        break;
                }
            }
        }

        public static void SetFloatByTime(this HelperData h, float time)
        {
            int typeID = h.GetMapFloatAnimType();
            h.GetFloatRange();

            if (h.LoopRandom)
            {
                switch (typeID)
                {
                    case 0:
                        h.SetBlockValue(time);
                        break;
                    case 1:
                        h.SetMaterialValue(time);
                        break;
                    case 2:
                        h.SetProjSize(time);
                        break;
                    case 3:
                        h.SetCanvasAlpha(time);
                        break;
                }
            }
            else
            {
                switch (typeID)
                {
                    case 0:
                        h.SetBlockValue(time);
                        break;
                    case 1:
                        h.SetMaterialValue(time);
                        break;
                    case 2:
                        h.SetProjSize(time);
                        break;
                    case 3:
                        h.SetCanvasAlpha(time);
                        break;
                }
            }
        }
        
        /// <summary>
        /// 设置序列图
        /// </summary>
        /// <param name="h"></param>
        /// <param name="typeID">0 = mpb, 1 = mat</param>
        public static void SetUV(this HelperData h)//, int typeID)// 0 = mpb, 1 = mat
        {
            int typeID = h.GetMatUvType();
            if (h.FxControlType == (byte)ControlType.Mat_AniSprite)
            {
                h.GetSprites();//获得图集的UV坐标

                switch (typeID)
                {
                    case 0:
                        h.SetValue(h.SetBlockSprite, null, null, null);
                        break;
                    case 1:
                        h.SetValue(h.SetMaterialSprite, null, null, null);
                        break;
                }
            }
            else
            {
                h.GetVector4Range();

                switch (typeID)
                {
                    case 0:
                        h.SetValue(h.SetBlockVector, null, null, null);
                        break;
                    case 1:
                        h.SetValue(h.SetMaterialVector, null, null, null);
                        break;
                }
            }
        }

        public static void SetUVByTime(this HelperData h,float time)
        {
            int typeID = h.GetMatUvType();
            if (h.FxControlType == (byte)ControlType.Mat_AniSprite)
            {
                h.GetSprites();//获得图集的UV坐标

                switch (typeID)
                {
                    case 0:
                        h.SetBlockSprite(time);
                        break;
                    case 1:
                        h.SetMaterialSprite(time);
                        break;
                }
            }
            else
            {
                h.GetVector4Range();

                switch (typeID)
                {
                    case 0:
                        h.SetBlockVector(time);
                        break;
                    case 1:
                        h.SetMaterialVector(time);
                        break;
                }
            }
        }

        
        /// <summary>
        /// 设置颜色
        /// </summary>
        /// <param name="h"></param>
        public static void SetColor(this HelperData h, bool canColorReset)
        {
            if (h.Graphic)
            {
                if (h.ImageColor)
                {
                    if (canColorReset)
                    {
                        h.SetValue(h.SetImageColor, h.ResetImageColor, null, h.ResetImageColor);
                    }
                    else
                    {
                        h.SetValue(h.SetImageColor, null, null, null);
                    }
                }
                else
                {
                    if (canColorReset)
                    {
                        h.SetValue(h.SetMaterialColor, h.ResetMaterialColor, null, h.ResetMaterialColor);
                    }
                    else
                    {
                        h.SetValue(h.SetMaterialColor, null, null, null);
                    }
                }
            }
            else if (h.Renderer && null != h.Block)
            {
                if (canColorReset)
                {
                    h.SetValue(h.SetBlockColor, h.ResetBlockColor, null, h.ResetBlockColor);
                }
                else
                {
                    h.SetValue(h.SetBlockColor, null, null, null);
                }
            }
            else if (h.Material)
            {
                if (canColorReset)
                {
                    h.SetValue(h.SetMaterialColor, h.ResetMaterialColor, null, h.ResetMaterialColor);
                }
                else
                {
                    h.SetValue(h.SetMaterialColor, null, null, null);
                }
            }
        }

        public static void SetColorByTime(this HelperData h,float time)
        {
            if (h.Graphic)
            {
                if (h.ImageColor)
                {
                    h.SetImageColor(time);
                }
                else
                {
                    h.SetMaterialColor(time);
                }
            }
            else if (h.Renderer && null != h.Block)
            {
                h.SetBlockColor(time);
            }
            else if (h.Material)
            {
                h.SetMaterialColor(time);
            }
        }
        
        public static void SetRadialBlurEffect(this HelperData h)
        {
            //目前必须要通过bridge才能使用
            //Sequence s = DOTween.Sequence();
            //for(int i = 0,c = h.From.Length; i < c; i++)
            //{
            //    float vd = h.From[i];
            //    if(h.To[i] > 0.5)
            //    {
            //        if (null != MoonClientBridge.Bridge)
            //        {
            //            //MoonClientBridge.Bridge.FxAnimationSetRadiaBlurEffect(h);
            //        }
            //    }
            //    else
            //    {
            //        if (null != MoonClientBridge.Bridge)
            //        {
            //            //MoonClientBridge.Bridge.FxAnimationSetRadiaBlurEffect(h);
            //        }
            //    }
            //    h.Tween = s;
            //    s.Play();
            //}
        }

        /// <summary>
        /// 显示组
        /// </summary>
        /// <param name="h"></param>
        public static void SetVisible(this HelperData h)
        {
            //定义一组序列
            Sequence s = DOTween.Sequence();
            for (int i = 0, c = h.From.Length; i < c; i++)
            {
                float vd = h.From[i];
                if (h.To[i] > 0.5f)
                {
                    s.InsertCallback(vd, h.SetActive);
                }
                else
                {
                    s.InsertCallback(vd, h.SetDeactive);
                }
            }

            h.Tween = s;
            s.Play();
        }

        /// <summary>
        /// 发射组
        /// </summary>
        /// <param name="h"></param>
        public static void SetEmitState(this HelperData h)
        {
            //定义一组序列
            Sequence s = DOTween.Sequence();
            for (int i = 0, c = h.From.Length; i < c; i++)
            {
                float vd = h.From[i];
                if (h.To[i] > 0.5f)
                {
                    s.InsertCallback(vd, h.StartEmit);
                }
                else
                {
                    s.InsertCallback(vd, h.StopEmit);
                }
            }

            h.Tween = s;
            s.Play();
        }

        //帧更新器，提供结束回调
        public static void SetValue(this HelperData h,
            DG.Tweening.Core.DOSetter<float> onUpdate,
            TweenCallback onComplete,
            TweenCallback onStepComplete,
            TweenCallback onKill)
        {
            Tweener t = DOTween.To(onUpdate, 0, 1, h.Duration);//返回值范围量化的0~1

            t.SetEase(h.FxLerpType == (byte)LerpType.Ease ? h.Ease : Ease.Linear);//如果没有自定义缓动则使用线性
            t.SetDelay(h.Delay);//设置延迟
            t.SetLoops(h.Loops, h.LoopType);//设置循环方式和次数

            if (null != onStepComplete)
            {
                t.OnStepComplete(onStepComplete);
            }

            if (null != onComplete)
            {
                t.OnComplete(onComplete);
            }

            if (null != onKill)
            {
                t.OnKill(onKill);
            }

         

            h.Tween = t;
        }

        #endregion
    }

    #endregion
}