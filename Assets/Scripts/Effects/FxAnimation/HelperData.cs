using DG.Tweening;
using MoonCommonLib;
using UnityEngine;
using UnityEngine.UI;

namespace FxAnimation
{
    [System.Serializable]
    public class HelperData
#if MOON_PROJ
        : IFxHelperData
#endif
    {
        #region 序列化

        [SerializeField]
        private string m_Name;
        [SerializeField]
        private ControlType m_ControlType;
        [SerializeField]
        private Object m_Body;
        [SerializeField]
        private string m_Property;
        [SerializeField]
        private float m_Delay;
        [SerializeField]
        private float m_Duration;
        [SerializeField]
        private LoopType m_LoopType;
        [SerializeField]
        private int m_Loops;
        [SerializeField]
        private LerpType m_LerpType;
        [SerializeField]
        private Ease m_Ease;
        [SerializeField]
        private bool m_LoopRandom;
        [SerializeField]
        private bool m_RangeFrom;
        [SerializeField]
        private bool m_RangeTo;
        [SerializeField]
        private float[] m_From;
        [SerializeField]
        private float[] m_From2;
        [SerializeField]
        private float[] m_To;
        [SerializeField]
        private float[] m_To2;
        [SerializeField]
        private Gradient[] m_ColorGrad;
        [SerializeField]
        private AnimationCurve[] m_Curves;
        [SerializeField]
        private bool m_ImageColor;
		[SerializeField]
        private Object m_StartPos;
        [SerializeField]
        private Object m_EndPos;
        #endregion

        #region 运行时参数

        public bool IsInited { get; set; }
        public Tween Tween { get; set; }
        public GameObject Gameobject { get; set; }
        public Transform Transform { get; set; }
        public Renderer Renderer { get; set; }
        public MaterialPropertyBlock Block { get; set; }
        public Graphic Graphic { get; set; }
        public Projector Projector { get; set; }
        public CanvasGroup CanvasGroup { get; set; }
#if MOON_PROJ
        public IMeleeTrail MeleeTrail { get; set; }
#else
        public MeleeTrail MeleeTrail { get; set; }
#endif
        public Material Material { get; set; }
        public Material SharedMaterial { get; set; }
        public int PropertyID { get; set; }
        public float FromF { get; set; }
        public float ToF { get; set; }
        public Vector3 FromV3 { get; set; }
        public Vector3 ToV3 { get; set; }
        public Vector4 FromV4 { get; set; }
        public Vector4 ToV4 { get; set; }
        public Vector4[] Sprites { get; set; }
        public int SpriteCount { get; set; }
        public int SpriteCur { get; set; }

        #endregion
        
        #region 属性

        public int SortedID { get; set; }

        public string Name
        {
            get { return m_Name; }
            set { m_Name = value; }
        }

        public byte FxControlType
        {
            get { return (byte)m_ControlType; }
            set
            {
                m_ControlType = (ControlType)value;
                switch (m_ControlType)
                {
                    case ControlType.Visible:
                    case ControlType.RadialBlurEffect:
                    case ControlType.MeleeTrail:
                    case ControlType.Mat_Float:
                        {
                            From = new float[1];
                            To = new float[1];
                        }
                        break;
                    case ControlType.CanvasAlpha:
                    case ControlType.Mat_AniSprite:
                    case ControlType.ProjectorSize:
                        {
                            From = new float[1] { 1 };
                            To = new float[1] { 1 };
                        }
                        break;
                    case ControlType.Position:
                    case ControlType.Rotation:
                    case ControlType.Scale:
                        {
                            From = new float[3];
                            To = new float[3];
                        }
                        break;
                    case ControlType.Mat_UV:
                        {
                            From = new float[4] { 1, 1, 0, 0 };
                            To = new float[4] { 1, 1, 0, 0 };
                        }
                        break;
                    case ControlType.Mat_Vector:
                        {
                            From = new float[4];
                            To = new float[4];
                        }
                        break;
                    case ControlType.Color:
                        {
                            ColorGrad = new Gradient()
                            {
                                colorKeys = new GradientColorKey[] { new GradientColorKey(Color.white, 0), new GradientColorKey(Color.white, 1) },
                                alphaKeys = new GradientAlphaKey[] { new GradientAlphaKey(1, 0), new GradientAlphaKey(1, 1) }
                            };
                        }
                        break;
                }
            }
        }

        public Object Body
        {
            get { return m_Body; }
            set
            {
                if (value != m_Body)
                {
                    m_Body = value;
                    IsInited = false;
                }
            }
        }

        public Object StartPos
        {
            get { return m_StartPos; }
            set
            {
                if (value != m_StartPos)
                {
                    m_StartPos = value;
                    IsInited = false;
                }
            }
        }

        public Object EndPos
        {
            get { return m_EndPos; }
            set
            {
                if (value != m_EndPos)
                {
                    m_EndPos = value;
                    IsInited = false;
                }
            }
        }

        public string Property
        {
            get { return m_Property; }
            set
            {
                m_Property = value;
                Name = string.Format("{0}:[{1}{2}]@[{3}]", Body.name, ((ControlType)FxControlType).ToString(), value, Delay.ToString("f2"));
            }
        }

        public float[] From
        {
            get { return m_From; }
            set
            {
                m_From = value;
                IsInited = false;
            }
        }

        public float[] From2
        {
            get { return m_From2; }
            set
            {
                m_From2 = value;
                IsInited = false;
            }
        }

        public bool LoopRandom
        {
            get { return m_LoopRandom; }
            set { m_LoopRandom = value; }
        }

        public bool RangeFrom
        {
            get { return m_RangeFrom; }
            set { m_RangeFrom = value; }
        }

        public float[] To
        {
            get { return m_To; }
            set
            {
                m_To = value;
                IsInited = false;
            }
        }

        public float[] To2
        {
            get { return m_To2; }
            set
            {
                m_To2 = value;
                IsInited = false;
            }
        }

        public bool RangeTo
        {
            get { return m_RangeTo; }
            set { m_RangeTo = value; }
        }

        public Gradient ColorGrad
        {
            get { return m_ColorGrad[0]; }
            set
            {
                if (m_ColorGrad == null || m_ColorGrad.Length < 1)
                    m_ColorGrad = new Gradient[1];
                m_ColorGrad[0] = value;
            }
        }

        public float Delay
        {
            get { return m_Delay; }
            set
            {
                m_Delay = value > 0 ? value : 0;
                Name = string.Format("{0}:[{1}{2}]@[{3}]", Body.name, ((ControlType)FxControlType).ToString(), Property, m_Delay.ToString("f2"));
            }
        }

        public float Duration
        {
            get { return m_Duration; }
            set
            {
                m_Duration = value > 0 ? value : 0.01f;
                IsInited = true;
            }
        }

        public LoopType LoopType
        {
            get { return m_LoopType; }
            set { m_LoopType = value; }
        }

        public int Loops
        {
            get { return m_Loops; }
            set { m_Loops = value > 0 ? value : -1; }
        }

        public byte FxLerpType
        {
            get { return (byte)m_LerpType; }
            set
            {
                m_LerpType = (LerpType)value;
                switch (m_LerpType)
                {
                    case LerpType.Ease:
                        Curves = new AnimationCurve[0];
                        break;
                    case LerpType.SingleCurve:
                        {
                            var curves = Curves;
                            System.Array.Resize(ref curves, 1);
                            if (curves[0] == null)
                                curves[0] = AnimationCurve.Linear(0, 0, 1, 1);
                            Curves = curves;
                        }
                        break;
                    case LerpType.AxisCurve:
                        {
                            var curves = Curves;
                            int length = From.Length;
                            System.Array.Resize(ref curves, length);
                            for (int i = 0; i < length; i++)
                                if (curves[i] == null)
                                    curves[i] = AnimationCurve.Linear(0, 0, 1, 1);
                            Curves = curves;
                        }
                        break;
                }
            }
        }

        public Ease Ease
        {
            get { return m_Ease; }
            set { m_Ease = value; }
        }

        public AnimationCurve[] Curves
        {
            get
            {
                if (m_Curves == null)
                    m_Curves = new AnimationCurve[0];
                return m_Curves;
            }
            set { m_Curves = value; }
        }

        public bool ImageColor
        {
            get
            {
                return m_ImageColor;
            }
            set
            {
                m_ImageColor = value;
            }
        }

        #endregion
        
        #region 构造器

        public HelperData(Object body, ControlType type)
        {
            Body = body;
            FxControlType = (byte)type;
            Name = string.Format(string.Format("{1}:[{0}]@[{2}]", ((ControlType)FxControlType).ToString(), Body.name, 0.ToString("f2")));
            Duration = 1;
            LoopType = LoopType.Restart;
            Loops = 1;
            Ease = Ease.Linear;
            FxLerpType = (byte)LerpType.Ease;
        }

        #endregion

        #region API

        public float GetAnimTotalTime()
        {
            return Delay + Duration;
        }
        
        public void SetTweenCompleteCallback(TweenCallback callback)
        {
            if (Tween == null) return;
            Tween.onComplete = callback;
        }

        public void ClearTweenCompleteCallback()
        {
            if (Tween == null) return;
            Tween.onComplete = null;
        }

        public void UpdateBodyStateByTime(float time)
        {
            float animProgress = getAnimProgress(time);
            switch (m_ControlType)
            {
                case ControlType.Position:
                    this.GetVector3Range();
                    this.SetPosition(animProgress);
                    break;
                case ControlType.Rotation:
                    this.GetVector3Range();
                    this.SetRotation(animProgress);
                    break;
                case ControlType.Scale:
                    this.GetVector3Range();
                    this.SetScale(animProgress);
                    break;
                case ControlType.Visible:
                    this.SetVisible();
                    break;
                case ControlType.Color:
                    this.SetColorByTime(animProgress);
                    break;
                case ControlType.Mat_UV:
                case ControlType.Mat_AniSprite:    
                    this.SetUVByTime(animProgress);
                    break;
                case ControlType.Mat_Float:
                    this.GetFloatRange();
                    this.SetFloatByTime(animProgress);
                    break;
                case ControlType.Mat_Vector:
                    this.SetVector4ByTime(animProgress);
                    break;
                case ControlType.CanvasAlpha:
                    this.SetFloatByTime(animProgress);
                    break;
                case ControlType.MeleeTrail:
                    this.SetEmitState();
                    break;
                case ControlType.ProjectorSize:
                    this.SetFloatByTime(animProgress);
                    break;
                case ControlType.PositionByGameObject:
                    this.GetVector3Range();
                    this.SetPosition(animProgress);
                    break; 
                case ControlType.RadialBlurEffect:
                    this.SetRadialBlurEffect();
                    break;  
                default:
                    break;
            }

        }
        #endregion

        #region inner function

        public int GetMapVectorAnimType()
        {
            int type = -1;
            if (Renderer && null != Block)
            {
                type = 0;
            }
            else if (Material)
            {
                type = 1;
            }

            return type;
        }
        public int GetMapFloatAnimType()
        {
            int type = -1;
            if (Renderer && null != Block)
            {
                type = 0;
            }
            else if (Material)
            {
                type = 1;
            }
            else if (Projector)
            {
                type = 2;
            }
            else if (CanvasGroup)
            {
                type = 3;
            }

            return type;
        }
        
        public int GetMatUvType()
        {
            int type = -1;
            if (Renderer && null != Block)
            {
                type = 0;
            }
            else if (Material)
            {
                type = 1;
            }

            return type;
        } 
        
        private float getAnimProgress(float time)
        {
            float startTime = Delay;
            float endTime = startTime + Duration;
            float currentTime = Mathf.Clamp(time, startTime, endTime);
            return (currentTime-startTime)/Duration;
        }
        

        #endregion
#if UNITY_EDITOR

        #region 参数使用数组序列化

        public static void FloatToArray(ref float[] fArray, float v)
        {
            if (fArray == null || fArray.Length < 1) fArray = new float[1] { v };
            else fArray[0] = v;
        }

        public static void Vector3ToArray(ref float[] vArray, Vector3 v)
        {
            if (vArray == null || vArray.Length < 3) vArray = new float[3] { v.x, v.y, v.z };
            else { for (int i = 0; i < 3; i++) vArray[i] = v[i]; }
        }

        public static void Vector4ToArray(ref float[] vArray, Vector4 v)
        {
            if (vArray == null || vArray.Length < 4) vArray = new float[4] { v.x, v.y, v.z, v.w };
            else { for (int i = 0; i < 4; i++) vArray[i] = v[i]; }
        }

        #endregion

        #region 复制类方法

        public static HelperData clipBoardData = null;

        public HelperData Clone()
        {
            HelperData clone = new HelperData(Body, (ControlType)FxControlType)
            {
                Property = this.Property
            };
            ClonePropertiesOnly(this, clone);
            return clone;
        }

        public static void ClonePropertiesOnly(HelperData source, HelperData dest)
        {
            dest.Delay = source.Delay;
            dest.Duration = source.Duration;
            dest.LoopType = source.LoopType;
            dest.Loops = source.Loops;
            dest.FxLerpType = source.FxLerpType;
            dest.Ease = source.Ease;
            if (dest.FxControlType == source.FxControlType)
            {
                if (dest.FxControlType == (byte)ControlType.Color)
                {
                    dest.ColorGrad = new Gradient();
                    var colorKeys = new GradientColorKey[source.ColorGrad.colorKeys.Length];
                    var alphaKeys = new GradientAlphaKey[source.ColorGrad.alphaKeys.Length];
                    for (int i = 0; i < dest.ColorGrad.colorKeys.Length; i++)
                        colorKeys[i] = source.ColorGrad.colorKeys[i];
                    for (int i = 0; i < dest.ColorGrad.alphaKeys.Length; i++)
                        alphaKeys[i] = source.ColorGrad.alphaKeys[i];
                    dest.ColorGrad.SetKeys(colorKeys, alphaKeys);
                }
                else
                {
                    dest.RangeFrom = source.RangeFrom;
                    dest.RangeTo = source.RangeTo;

                    dest.From = new float[source.From.Length];
                    for (int i = 0; i < dest.From.Length; i++)
                        dest.From[i] = source.From[i];

                    if (dest.RangeFrom)
                    {
                        dest.From2 = new float[source.From2.Length];
                        for (int i = 0; i < dest.From2.Length; i++)
                            dest.From2[i] = source.From2[i];
                    }

                    dest.To = new float[source.To.Length];
                    for (int i = 0; i < dest.From.Length; i++)
                        dest.To[i] = source.To[i];

                    if (dest.RangeTo)
                    {
                        dest.To2 = new float[source.To2.Length];
                        for (int i = 0; i < dest.To2.Length; i++)
                            dest.To2[i] = source.To2[i];
                    }

                    dest.Curves = new AnimationCurve[source.Curves.Length];
                    for (int i = 0; i < dest.Curves.Length; i++)
                        dest.Curves[i] = new AnimationCurve(source.Curves[i].keys);
                }
            }
        }

        #endregion

#endif
    }
    
    #region 类型和结构
#if !MOON_PROJ
    public struct StateShot
    {
        public bool posCached { get; set; }
        public bool rotCached { get; set; }
        public bool sclCached { get; set; }
        public bool valCached { get; set; }
        public bool tglCached { get; set; }

        public Vector3 position { get; set; }//该tranform的初始位置
        public Vector3 rotation { get; set; }//该tranform的初始角度
        public Vector3 scale { get; set; }//该tranform的初始缩放
        public float value { get; set; }//该projector的初始投影尺寸
        public bool toggle { get; set; }//该gameobject的初始可见

        public int lastColorHelperID { get; set; }//是否是最后一个控制颜色
    }
#endif

    public enum ControlType : byte
    {
        Position = 0,
        Rotation,
        Scale,
        Visible,
        Color,
        Mat_UV,
        Mat_AniSprite,
        Mat_Float,
        Mat_Vector,
        CanvasAlpha,
        MeleeTrail,
        ProjectorSize,
        PositionByGameObject,
        RadialBlurEffect,
    }

    public enum LerpType : byte
    {
        Ease = 0,
        SingleCurve,
        AxisCurve
    }

    #endregion
}