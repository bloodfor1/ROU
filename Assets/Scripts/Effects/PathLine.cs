/*
 *      Archor: Starking. 
 * 
 */

using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using MoonCommonLib;

#if UNITY_EDITOR

using UnityEditor;
using DG.Tweening;

[CustomEditor(typeof(PathLine))]
public class PathLineEditor : Editor
{

    public override void OnInspectorGUI()
    {
        base.OnInspectorGUI();

        if (Application.isPlaying && GUILayout.Button("Create"))
        {
            (target as PathLine).DrawLine();
        }

        if (Application.isPlaying && GUILayout.Button("Test Dynamic Drawing"))
        {
            var t = target as PathLine;
            var linePointsFrom = new List<Vector3>()
            {
                new Vector3(0,30,0),
                new Vector3(100,30,0),
                new Vector3(100,30,100)
            };

            var linePointsTo = new List<Vector3>()
            {
                new Vector3(80,30,0),
                new Vector3(100,30,0),
                new Vector3(100,30,100)
            };

            t.linePoints.Clear();
            t.linePoints.AddRange(linePointsFrom);

            DOTween.To(v =>
            {
                if (t)
                {
                    t.linePoints[0] = Vector3.Lerp(linePointsFrom[0], linePointsTo[0], v);
                }
            }, 0f, 1f, 5).SetEase(Ease.Linear);

            t.DynamicDrawing(5);
        }
    }
}

#endif

[RequireComponent(typeof(MeshFilter), typeof(MeshRenderer))]
public class PathLine : MonoBehaviour
{

    public enum LineType
    {
        HardLine = 0,
        CornerSmoothLine,
        SmoothLime
    }

    public LineType lineType;
    public List<Vector3> linePoints = new List<Vector3>();
    public int subDivision = 3;
    public float smoothCornerRadius = 1;
    public float width = 1;
    public AnimationCurve widthSample = new AnimationCurve(new Keyframe[] { new Keyframe(0, 1), new Keyframe(1, 1) });
    [Range(0, 1)]
    public float centerShift = 0.5f;
    public float arrawLength = 3f;
    public float arrawWidth = 3f;
    public bool facingScreen;
    public Material material;
    public bool uvRampV;
    public float updateInterval = 1f;//每秒更新一次

    private Mesh mesh;
    private MeshFilter meshFilter;
    private MeshFilter Filter
    {
        get
        {
            if (!meshFilter)
                meshFilter = GetComponent<MeshFilter>();

            return meshFilter;
        }
    }

    private MeshRenderer meshRenderer;
    private MeshRenderer Renderer
    {
        get
        {
            if (!meshRenderer)
                meshRenderer = GetComponent<MeshRenderer>();

            return meshRenderer;
        }
    }

    private List<Vector3> drawLinePoints;
    private Vector3 up;
    private List<Vector3> verts;
    private List<Vector2> uvs;
    private List<int> tris;
    private List<Vector3> dbaseLine;
    private List<float> dbaseLerp;
    private float dbaseLength;
    private Vector3 arrawForward;
    private float updateIntervalTime;
    private Coroutine coroutine;

    //private void Start()
    //{
    //    meshFilter = GetComponent<MeshFilter>();
    //    meshRenderer = GetComponent<MeshRenderer>();
    //    meshRenderer.material = material;
    //}

    private void Start()
    {

    }

    private bool Init()
    {
        if (Filter && Renderer)
        {
            Renderer.material = material;
            return true;
        }
        return false;
    }

    /// <summary>
    /// 使用transfrom获得点坐标
    /// </summary>
    public void SetPoint(Transform[] points)
    {
        linePoints.Clear();
        for (int i = 0, n = points.Length; i < n; i++)
        {
            if (points[i])
                linePoints.Add(points[i].position);
        }
    }
    /// <summary>
    /// 绘制线路，这个是对外公开的方法
    /// </summary>
    public void DrawLine()
    {
        if (!Init())
            return;

        CreateMesh();
    }

    /// <summary>
    /// 实时更新
    /// </summary>
    public void DynamicDrawing(float duration = -1)
    {
        if (!Init())
            return;

        updateIntervalTime = Mathf.Max(Time.deltaTime, updateInterval);

        StopCurrentDrawing();

        coroutine = StartCoroutine(CoroutineDrawLine(duration, MCommonFunctions.IsEqual(duration, -1)));
    }

    /// <summary>
    /// 协程绘制
    /// </summary>
    /// <returns></returns>
    IEnumerator CoroutineDrawLine(float duration = -1, bool always = false)
    {
        while (duration > 0 || always)
        {
            CreateMesh();
            Debug.Log("Now Drawing! " + Time.realtimeSinceStartup);
            yield return new WaitForSeconds(updateIntervalTime);
            if (!always)
                duration -= updateIntervalTime;
        }

        StopCurrentDrawing();
    }

    /// <summary>
    /// 如果不给予变化时间，则需要手动终止
    /// </summary>
    public void StopCurrentDrawing()
    {
        CancelInvoke();
        if (coroutine != null) StopCoroutine(coroutine);
    }

    /// <summary>
    /// 创建网格
    /// </summary>
    private void CreateMesh()
    {
        if (drawLinePoints == null) drawLinePoints = new List<Vector3>();
        else drawLinePoints.Clear();

        for (int i = 0, n = linePoints.Count - 2; i <= n; i++)
            drawLinePoints.Add(linePoints[i]);

        //为末尾箭头预留空间
        arrawForward = linePoints[linePoints.Count - 1] - drawLinePoints[drawLinePoints.Count - 1];
        arrawForward = arrawForward.normalized * arrawLength;
        drawLinePoints.Add(linePoints[linePoints.Count - 1] - arrawForward);

        if (mesh)
            mesh.Clear();
        else
        {
            mesh = new Mesh
            {
                name = "LineMesh"
            };
            mesh.MarkDynamic();
        }

        up = facingScreen && Camera.main ? Camera.main.transform.forward : Vector3.up;

        if (verts == null) verts = new List<Vector3>();
        else verts.Clear();
        if (uvs == null) uvs = new List<Vector2>();
        else uvs.Clear();
        if (tris == null) tris = new List<int>();
        else tris.Clear();

        //获得插值点成功，生成模型，否则跳过
        if (GetMeshVert(drawLinePoints, verts.Add))
        {
            Vert2UV(verts, uvs.Add);
            CreateTris(verts.Count, tris.Add);

            mesh.SetVertices(verts);
            mesh.SetUVs(0, uvs);
            mesh.SetTriangles(tris, 0);
            Filter.mesh = mesh;
        }
    }

    /// <summary>
    /// 获得网格所有的点
    /// </summary>
    /// <param name="verts">给定的关键点</param>
    /// <param name="addVertTo">加入网格所需的顶点</param>
    private bool GetMeshVert(List<Vector3> verts, System.Action<Vector3> addVertTo)
    {
        if (verts.Count > 1)
        {
            //获得主轴线
            GetBaseLinePoint(verts);

            float dWidth;
            Vector3 dLeft, dRight, forward = Vector3.right, tempFor = Vector3.zero, side = Vector3.zero;

            for (int i = 0, n = dbaseLine.Count - 1; i <= n; i++)
            {
                if (i > 0 && i <= n - 1)//中间的折点，方向取决于切线方向
                {
                    tempFor = dbaseLine[i + 1] - dbaseLine[i - 1];
                }
                else if (i == 0)//起始点，方向取决于次点
                {
                    tempFor = dbaseLine[i + 1] - dbaseLine[i];
                }
                else //结束点，方向取决于前点
                {
                    tempFor = dbaseLine[i] - dbaseLine[i - 1];
                }

                if (tempFor != Vector3.zero)
                    forward = tempFor;

                dWidth = widthSample.Evaluate(Mathf.InverseLerp(0, n, i)) * width;
                side = Vector3.Cross(forward, up).normalized;
                dLeft = dbaseLine[i] + side * dWidth * centerShift;
                dRight = dbaseLine[i] - side * dWidth * (1 - centerShift);
                dLeft = transform.InverseTransformPoint(dLeft);
                dRight = transform.InverseTransformPoint(dRight);
                addVertTo(dRight);
                addVertTo(dLeft);
            }

            GetArrawVert(forward, side, addVertTo);

            return true;
        }
        return false;
    }

    /// <summary>
    /// 获得主轴点
    /// </summary>
    private void GetBaseLinePoint(List<Vector3> verts)
    {
        if (dbaseLine == null) dbaseLine = new List<Vector3>();
        else dbaseLine.Clear();

        if (dbaseLerp == null) dbaseLerp = new List<float>();
        else dbaseLerp.Clear();

        dbaseLength = 0;

        switch (lineType)
        {
            case LineType.HardLine:
                GetHardLineBasePoint(verts);
                break;
            case LineType.CornerSmoothLine:
                GetCornerSmoothLineBasePoint(verts);
                break;
            case LineType.SmoothLime:
                GetSmoothLineBasePoint(verts);
                break;
        }
    }

    /// <summary>
    /// 折角线
    /// </summary>
    private void GetHardLineBasePoint(List<Vector3> verts)
    {
        float angle, offset;
        Vector3 prevVert = verts[0], tangentIn, tangentOut, cornerIn, cornerOut;
        dbaseLine.Add(prevVert);

        for (int i = 1, n = verts.Count - 2; i <= n; i++)
        {
            tangentIn = verts[i] - verts[i - 1];
            tangentOut = verts[i + 1] - verts[i];
            angle = 90 - (180 - Vector3.Angle(tangentIn, tangentOut)) * 0.5f;
            angle *= Mathf.Deg2Rad;
            offset = width * widthSample.Evaluate(Mathf.InverseLerp(0, n + 1, i));
            offset *= Mathf.Tan(angle) * 0.5f;

            tangentIn = tangentIn.normalized * offset;
            tangentOut = tangentOut.normalized * offset;
            cornerIn = verts[i] - tangentIn;
            cornerOut = verts[i] + tangentOut;

            dbaseLine.Add(cornerIn);
            dbaseLength += (cornerIn - prevVert).magnitude;
            dbaseLerp.Add(dbaseLength);

            dbaseLine.Add(cornerOut);
            dbaseLength += (cornerOut - cornerIn).magnitude;
            dbaseLerp.Add(dbaseLength);

            prevVert = cornerOut;
        }

        dbaseLine.Add(verts[verts.Count - 1]);
        dbaseLength += (verts[verts.Count - 1] - prevVert).magnitude;
        dbaseLerp.Add(dbaseLength);
    }

    /// <summary>
    /// 圆角线
    /// </summary>
    private void GetCornerSmoothLineBasePoint(List<Vector3> verts)
    {
        float angle, sign, minCornerRadius;
        Vector3 prevVert = verts[0], tangentIn, tangentOut, cornerIn, cornerOut,
            cornerIn2Center, cornerCenter, cornerSub, crossTangent;
        dbaseLine.Add(prevVert);

        for (int i = 1, n = verts.Count - 2; i <= n; i++)
        {
            tangentIn = verts[i] - verts[i - 1];
            tangentOut = verts[i + 1] - verts[i];
            minCornerRadius = Mathf.Min(tangentIn.magnitude, tangentOut.magnitude, smoothCornerRadius);
            tangentIn = tangentIn.normalized * minCornerRadius;
            tangentOut = tangentOut.normalized * minCornerRadius;
            cornerIn = verts[i] - tangentIn;
            cornerOut = verts[i] + tangentOut;

            angle = Vector3.Angle(tangentIn, tangentOut);

            if (MCommonFunctions.IsEqual(angle, 180) || MCommonFunctions.IsEqual(angle, 0))//180 = 回头 0 = 无偏转
            {
                dbaseLine.Add(cornerIn);
                dbaseLength += (cornerIn - prevVert).magnitude;
                dbaseLerp.Add(dbaseLength);
            }
            else
            {
                crossTangent = Vector3.Cross(tangentIn, tangentOut);
                sign = Vector3.Dot(up, crossTangent) > 0 ? 1 : -1;
                cornerIn2Center = Quaternion.AngleAxis(90 * sign, crossTangent) * tangentIn;
                cornerIn2Center *= Mathf.Tan((180 - angle * sign) * 0.5f * Mathf.Deg2Rad);
                cornerCenter = cornerIn + cornerIn2Center;
                for (int step = 0; step < subDivision; step++)
                {
                    cornerSub = Vector3.Slerp(cornerIn - cornerCenter,
                        cornerOut - cornerCenter,
                        Mathf.InverseLerp(0, subDivision, step)) + cornerCenter;
                    dbaseLine.Add(cornerSub);
                    dbaseLength += (cornerSub - prevVert).magnitude;
                    dbaseLerp.Add(dbaseLength);
                    prevVert = cornerSub;
                }
            }

            dbaseLine.Add(cornerOut);
            dbaseLength += (cornerOut - prevVert).magnitude;
            dbaseLerp.Add(dbaseLength);

            prevVert = cornerOut;
        }

        dbaseLine.Add(verts[verts.Count - 1]);
        dbaseLength += (verts[verts.Count - 1] - prevVert).magnitude;
        dbaseLerp.Add(dbaseLength);
    }

    /// <summary>
    /// 过点曲线
    /// </summary>
    private void GetSmoothLineBasePoint(List<Vector3> verts)
    {
        Vector3 dBase;

        for (int i = 0, n = verts.Count - 1; i < n; i++)
        {
            for (int step = 0; step < subDivision; step++)
            {
                //细分点进度
                dBase = GetInterpolateVert(Mathf.InverseLerp(0, subDivision, step), i, verts);
                dbaseLine.Add(dBase);
            }
        }

        dbaseLine.Add(verts[verts.Count - 1]);
    }

    /// <summary>
    /// 写入箭头顶点
    /// </summary>
    /// <param name="forward">方向</param>
    /// <param name="side">侧展</param>
    private void GetArrawVert(Vector3 forward, Vector3 side, System.Action<Vector3> addVertTo)
    {
        var lastVert = dbaseLine[dbaseLine.Count - 1];
        var dLeft = transform.InverseTransformPoint(lastVert - side * arrawWidth * 0.5f);
        var dRight = transform.InverseTransformPoint(lastVert + side * arrawWidth * 0.5f);
        var dFor = transform.InverseTransformPoint(lastVert + arrawForward);
        addVertTo(dLeft);
        addVertTo(dRight);
        addVertTo(dFor);
    }

    /// <summary>
    /// 通过顶点计算UV点坐标
    /// </summary>
    private void Vert2UV(List<Vector3> verts, System.Action<Vector2> addUVTo)
    {
        float pt;

        for (int i = 0, n = dbaseLine.Count; i < n; i++)
        {
            if (lineType == LineType.SmoothLime)
                pt = Mathf.InverseLerp(0, n - 1, i);
            else if (i > 0)
                pt = dbaseLerp[i - 1] / dbaseLength;
            else
                pt = 0;

            addUVTo(uvRampV ? new Vector2(0.5f, pt) : new Vector2(pt, 0.5f));
            addUVTo(uvRampV ? new Vector2(0, pt) : new Vector2(pt, 1));
        }

        //箭头UV
        ArrawVert2UV(addUVTo);
    }

    /// <summary>
    /// 箭头顶点对应UV
    /// </summary>
    private void ArrawVert2UV(System.Action<Vector2> addUVTo)
    {
        addUVTo(uvRampV ? new Vector2(1, 0) : new Vector2(0, 0));
        addUVTo(uvRampV ? new Vector2(0.5f, 0) : new Vector2(0, 0.5f));
        addUVTo(uvRampV ? new Vector2(0.75f, 1) : new Vector2(1, 0.25f));
    }

    /// <summary>
    /// 计算描绘顺序
    /// </summary>
    private void CreateTris(int vertCount, System.Action<int> addTriIDTo)
    {
        //一次循环写3个三角点, 最后两个线段点不用绘制，箭头点另外绘制
        for (int i = 0; i < vertCount - 5; i++)
        {
            if (i % 2 == 0)
            {
                addTriIDTo(i);//r0 or t1          
                addTriIDTo(i + 1);//t0 or t1
                addTriIDTo(i + 2);//r1 or t2
            }
            else
            {
                addTriIDTo(i + 2);//r0 or t1          
                addTriIDTo(i + 1);//t0 or t1
                addTriIDTo(i);//r1 or t2
            }
        }

        //绘制箭头
        CreateArrawTris(vertCount, addTriIDTo);
    }

    /// <summary>
    /// 箭头的描绘顺序
    /// </summary>
    private void CreateArrawTris(int vertCount, System.Action<int> addTriIDTo)
    {
        addTriIDTo(vertCount - 3);
        addTriIDTo(vertCount - 2);
        addTriIDTo(vertCount - 1);
    }

    private static Vector3 GetInterpolateVert(float t, int idx, List<Vector3> verts)
    {
        int n = verts.Count - 1;
        idx = Mathf.Clamp(idx, 0, n);
        return CatmullRom(verts[Mathf.Max(0, idx - 1)], verts[idx], verts[Mathf.Min(n, idx + 1)], verts[Mathf.Min(n, idx + 2)], t);
    }

    //t == 0 => start  t == 1 => end 
    private static Vector3 CatmullRom(Vector3 prev, Vector3 start, Vector3 end, Vector3 next, float t)
    {
        t = Mathf.Clamp01(t);
        float tSqr = t * t;
        float tCub = tSqr * t;

        return prev * (-0.5f * tCub + tSqr - 0.5f * t) +
            start * (1.5f * tCub - 2.5f * tSqr + 1.0f) +
            end * (-1.5f * tCub + 2.0f * tSqr + 0.5f * t) +
            next * (0.5f * tCub - 0.5f * tSqr);
    }
}
