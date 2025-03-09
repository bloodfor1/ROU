using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using MoonCommonLib;

public class MeleeTrail : MonoBehaviour, IMeleeTrail {

    #region 公开变量
    [Tooltip("激发")]
    public bool emit;
    [Tooltip("根节点")]
    public Transform root;
    [Tooltip("尖节点")]
    public Transform tips;
    [Tooltip("材质")]
    public Material material;
    [Tooltip("时长")]
    public float duration = 0.3f;
    [Tooltip("采样率")]
    public int fps = 30;
    [Tooltip("细分")]
    public int subDivitions = 4;

    [Tooltip("周期颜色")]
    public Gradient lifeColor = new Gradient()
    {
        colorKeys = new GradientColorKey[2]
        {
            new GradientColorKey(Color.white, 0),
            new GradientColorKey(Color.white, 1)
        },
        alphaKeys = new GradientAlphaKey[2]
        {
            new GradientAlphaKey(1, 0),
            new GradientAlphaKey(1, 1)
        }
    };

    [Tooltip("0=处于根节点位置, 1=处于尖节点位置, 可以超越0-1范围")]
    public AnimationCurve lifeTips = new AnimationCurve(new Keyframe(0, 1), new Keyframe(1, 1));
    [Tooltip("0=处于根节点位置, 1=处于尖节点位置, 可以超越0-1范围")]
    public AnimationCurve lifeRoot = new AnimationCurve(new Keyframe(0, 0), new Keyframe(1, 1));

    [Tooltip("显示绘制段")]
    public bool showMeshTrip;

    public bool remakeOnEnable;
    #endregion

    #region 私有变量
    private bool _isInit;

    private int _subDivitions;
    private int _segmentCount;
    private int _vertCount;
    private int _sinceLastCatch;

    private Mesh _trailMesh;
    private Vector3[] _verts;
    private Vector2[] _uvs;
    private Color[] _colors;
    private int[] _tris;

    private Vector3 _rootCurPos;
    private Vector3 _tipsCurPos;

    private Vector3[] _rootCache = new Vector3[4];
    private Vector3[] _tipsCache = new Vector3[4]; 

    private Vector3[] _rootVerts;
    private Vector3[] _tipsVerts;

    private Transform _transform;
    #endregion

    #region 属性

    public bool Emit
    {
        get { return emit; }
        set { emit = value; }
    }

    public Material Material
    {
        get { return material; }
        set { material = value; }
    }

    #endregion

    #region Mono 函数

    private void Awake()
    {
        _transform = transform;
        if (!remakeOnEnable)
        {
            Init();
        }
    }

    private void OnEnable()
    {
        _transform = _transform ?? transform;
        if (remakeOnEnable)
        {
            Init();
        }
        MEffectUpdater.Active();
        MEffectUpdater.updater += DrawTrail;
    }

    private void OnDisable()
    {
        MEffectUpdater.updater -= DrawTrail;
        if (remakeOnEnable)
        {
            Drop();
        }
    }

    private void OnDestroy()
    {
        if (!remakeOnEnable)
        {
            Drop();
        }
    }

    #endregion

    #region 公开函数
    public void Init()
    {
        //细分段数
        _subDivitions = Mathf.Max(1, subDivitions);
        _segmentCount = Mathf.FloorToInt(Mathf.Max(1, duration * fps) * _subDivitions);
        _segmentCount = Mathf.Max(4, _segmentCount);
        _rootVerts = new Vector3[_segmentCount];
        _tipsVerts = new Vector3[_segmentCount];

        _vertCount = _segmentCount * 2;
        _verts = new Vector3[_vertCount];
        _uvs = new Vector2[_vertCount];
        _colors = new Color[_vertCount];
        _tris = new int[_vertCount * 3 - 6];

        for (int i = 0, tc = _vertCount - 2; i < _vertCount; i++)
        {
            _verts[i] = Vector3.zero;

            bool isRPoint = i % 2 == 0;
            float d = Mathf.InverseLerp(0, _segmentCount - 1, i);
            _uvs[i] = new Vector2(d, isRPoint ? 0 : 1);
            _colors[i] = lifeColor.Evaluate(d);

            if (i < tc)
            {
                _tris[3 * i    ] = isRPoint ? i : i + 2;
                _tris[3 * i + 1] = i + 1;
                _tris[3 * i + 2] = isRPoint ? i + 2 : i;
            }
        }

        _trailMesh = new Mesh()
        {
            name = "TrailMesh"
        };

        _trailMesh.MarkDynamic();
        UpdateMesh();

        _isInit = true;
    }

    public void Drop()
    {
        if (_isInit)
        {
            Destroy(_trailMesh);
            _trailMesh = null;
            _isInit = false;
        }
    }

    public void DrawTrail()
    {
        if (UpdateCachePoint())
        {
            UpdateShape();
            UpdateVerts();
            UpdateMesh();
            DrawMesh();
        }
    }
    #endregion

    #region 私有方法
    /// <summary>
    /// 更新缓存点
    /// </summary>
    /// <returns></returns>
    private bool UpdateCachePoint()
    {
        if (emit)
        {
            for (int i = 3; i >= 0; i--)
            {
                _rootCurPos = root.position - _transform.position;
                _tipsCurPos = tips.position - _transform.position;

                _rootCache[i] = i == 0 ? _rootCurPos : _rootCache[i - 1];
                _tipsCache[i] = i == 0 ? _tipsCurPos : _tipsCache[i - 1];
            }
            _sinceLastCatch = 0;
        }
        else if (_sinceLastCatch < _segmentCount)
        {
            _sinceLastCatch++;
        }

        return _sinceLastCatch < _segmentCount;
    }

    /// <summary>
    /// 更新形态，通过 spline 插值平滑，每帧只会更新最近的两帧，同时丢弃最后一帧
    /// </summary>
    private void UpdateShape()
    {
        for (int i = _segmentCount - 1, c = _subDivitions * 2; i >= c; i--)
        {
            int p = i - _subDivitions;

            _rootVerts[i] = _rootVerts[p];
            _tipsVerts[i] = _tipsVerts[p];
        }

        for (int i = 0; i < _subDivitions; i++)
        {
            float d = Mathf.InverseLerp(0, _subDivitions - 1, i);
            int curVertStart = i + subDivitions;
            int newVertStart = i;

            _rootVerts[curVertStart] = CatmullRom(_rootCache[0], _rootCache[1], _rootCache[2], _rootCache[3], d);
            _tipsVerts[curVertStart] = CatmullRom(_tipsCache[0], _tipsCache[1], _tipsCache[2], _tipsCache[3], d);
            _rootVerts[newVertStart] = CatmullRom(_rootCache[0], _rootCache[0], _rootCache[1], _rootCache[2], d);
            _tipsVerts[newVertStart] = CatmullRom(_tipsCache[0], _tipsCache[0], _tipsCache[1], _tipsCache[2], d);
        }
    }

    /// <summary>
    /// 更新网格的顶点
    /// </summary>
    private void UpdateVerts()
    {
        for (int i = 0; i < _segmentCount; i++)
        {
            int vi = i * 2;
            float lerp = Mathf.InverseLerp(0, _segmentCount - 1, i);

            float tipsSize = lifeTips.Evaluate(lerp);
            float rootSize = lifeRoot.Evaluate(lerp);

            _verts[vi    ] = Vector3.LerpUnclamped(_rootVerts[i], _tipsVerts[i], rootSize);
            _verts[vi + 1] = Vector3.LerpUnclamped(_rootVerts[i], _tipsVerts[i], tipsSize);
        }
    }

    /// <summary>
    /// 更新网格
    /// </summary>
    private void UpdateMesh()
    {
        _trailMesh.vertices = _verts;
        _trailMesh.uv = _uvs;
        _trailMesh.colors = _colors;
        _trailMesh.triangles = _tris;
    }

    /// <summary>
    /// 绘制网格
    /// </summary>
    private void DrawMesh()
    {
        if (_trailMesh && material)
        {
            //_trailMesh.RecalculateBounds();
            Graphics.DrawMesh(_trailMesh, Matrix4x4.Translate(_transform.position), material, 1);
        }
    }

    /// <summary>
    /// 插值线段
    /// </summary>
    /// <param name="t">插值度0-1，点在start和end之间</param>
    /// <returns></returns>
    private static Vector3 CatmullRom(Vector3 prev, Vector3 start, Vector3 end, Vector3 next, float t)
    {
        float tSqr = t * t;
        float tCub = tSqr * t;

        return  prev    * (-0.5f * tCub +        tSqr - 0.5f * t) +
                start   * ( 1.5f * tCub - 2.5f * tSqr + 1.0f    ) +
                end     * (-1.5f * tCub + 2.0f * tSqr + 0.5f * t) +
                next    * ( 0.5f * tCub - 0.5f * tSqr           );
    }
    #endregion

    private void OnDrawGizmos()
    {
        if (showMeshTrip && Application.isPlaying && null != _verts)
        {
            for (int i = 0; i < _verts.Length - 2; i++)
            {
                Gizmos.DrawLine(_verts[_tris[3 * i    ]], _verts[_tris[3 * i + 1]]);
                Gizmos.DrawLine(_verts[_tris[3 * i + 1]], _verts[_tris[3 * i + 2]]);
                Gizmos.DrawLine(_verts[_tris[3 * i + 2]], _verts[_tris[3 * i    ]]);
            }
        }
    }
}
