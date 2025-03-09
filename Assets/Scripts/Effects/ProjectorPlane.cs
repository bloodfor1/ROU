using System.Collections;
using System.Collections.Generic;
using UnityEngine;

#if UNITY_EDITOR

using UnityEditor;

[CustomEditor(typeof(ProjectorPlane))]
public class ProjectorPlaneEditor : Editor
{
    public override void OnInspectorGUI()
    {
        serializedObject.Update();
        EditorGUI.BeginChangeCheck();
        {
            EditorGUILayout.PropertyField(serializedObject.FindProperty("m_Radius"));
            EditorGUILayout.PropertyField(serializedObject.FindProperty("m_DotPitch"));
            EditorGUILayout.PropertyField(serializedObject.FindProperty("m_Suspend"));
            EditorGUILayout.PropertyField(serializedObject.FindProperty("m_CreateOnStart"));
            EditorGUI.BeginChangeCheck();
            {
                var coli = EditorGUILayout.ObjectField("Ground", (target as ProjectorPlane).GroundCollider, typeof(Collider), true);
                if (EditorGUI.EndChangeCheck())
                {
                    (target as ProjectorPlane).GroundCollider = coli as Collider;
                }
            }
            if (EditorGUI.EndChangeCheck())
            {
                serializedObject.ApplyModifiedProperties();

            }
        }
        if (Application.isPlaying && GUILayout.Button("投影到地面"))
            (target as ProjectorPlane).Projector();
    }
}

#endif

[RequireComponent(typeof(MeshFilter), typeof(MeshRenderer))]
public class ProjectorPlane : MonoBehaviour
{
    [SerializeField]
    private float m_Radius = 5;//半径
    [SerializeField]
    private float m_DotPitch = 2.5f;//点间距
    [SerializeField]
    private float m_Suspend = 0.01f;
    [SerializeField]
    private bool m_CreateOnStart;

    private Mesh m_Mesh;

    public float Radius
    {
        get
        {
            return m_Radius;
        }

        set
        {
            m_Radius = Mathf.Max(0.1f, value);
        }
    }

    public float DotPitch
    {
        get
        {
            return m_DotPitch;
        }

        set
        {
            m_DotPitch = Mathf.Max(0.1f, value);
        }
    }

    public float Suspend
    {
        get
        {
            return m_Suspend;
        }

        set
        {
            m_Suspend = value;
        }
    }

    public bool CreateOnStart
    {
        get
        {
            return m_CreateOnStart;
        }

        set
        {
            m_CreateOnStart = value;
        }
    }

    public Mesh Mesh
    {
        get
        {
            return m_Mesh;
        }

        set
        {
            m_Mesh = value;
        }
    }

    private List<int> tris;
    private List<Vector3> verties;
    private List<Vector2> uvs;
    private int vertCount;
    private Collider m_GroundCollider;
    public Collider GroundCollider
    {
        get { return m_GroundCollider; }
        set { m_GroundCollider = value; }
    }

    private Ray ray = new Ray();
    private RaycastHit hit;
    private Vector3 vertWorldPos;
    private bool needUpdate = false;

    private void Start()
    {
        Radius = Radius;
        DotPitch = DotPitch;
        if (CreateOnStart)
            CreateMesh();
    }

    private void OnDestroy()
    {
        if (Mesh)
            Destroy(Mesh);
    }

    /// <summary>
    /// 生成一个投影面。
    /// </summary>
    public void Projector()
    {
        if (Mesh)
            UpdateMesh();
        else
            CreateMesh();
    }

    /// <summary>
    /// 新建一个网格。
    /// </summary>
    private void CreateMesh()
    {
        if (Mesh)
            Destroy(Mesh);

        Mesh = new Mesh();
        Mesh.MarkDynamic();
        Mesh.name = "ProjectorPlane";
        GetComponent<MeshFilter>().mesh = Mesh;

        int[] vertCountInColumn;
        SetVerties(out vertCountInColumn);
        SetUVs();
        SetTriangles(vertCountInColumn);
        UpdateMesh();
    }

    /// <summary>
    /// 更新当前网格。
    /// </summary>
    private void UpdateMesh()
    {
        if (UpdateMeshVerties())
        {
            Mesh.SetVertices(verties);
            Mesh.SetUVs(0, uvs);
            Mesh.SetTriangles(tris, 0);
        }
    }

    /// <summary>
    /// 计算顶点位置。
    /// </summary>
    /// <param name="vertCountInColumn">每列顶点数。</param>
    private void SetVerties(out int[] vertCountInColumn)
    {
        verties = new List<Vector3>();
        float hUnit = Mathf.Cos(Mathf.PI / 6) * DotPitch;
        int vertVerticalMax = Mathf.FloorToInt(2 * Radius / DotPitch) + 1;
        int vertColOneSide = Mathf.FloorToInt(Radius / hUnit);
        vertCountInColumn = new int[vertColOneSide * 2 + 1];
        float hOffset;
        for (int col = 0, cp = -vertColOneSide; cp <= vertColOneSide; col++, cp++)//从左至右
        {
            vertCountInColumn[col] = vertVerticalMax - Mathf.Abs(cp);//每一竖列的点数目
            hOffset = cp * hUnit;
            if (vertCountInColumn[col] % 2 == 0)//双数
            {
                for (int i = 1, n = vertCountInColumn[col] / 2; i <= n; i++)
                {
                    verties.Add(new Vector3(hOffset, 0, DotPitch * (i - 0.5f)));
                    verties.Add(new Vector3(hOffset, 0, -DotPitch * (i - 0.5f)));
                }
            }
            else//单数
            {
                verties.Add(new Vector3(hOffset, 0, 0));
                for (int i = 1, n = (vertCountInColumn[col] - 1) / 2; i <= n; i++)
                {
                    verties.Add(new Vector3(hOffset, 0, DotPitch * i));
                    verties.Add(new Vector3(hOffset, 0, -DotPitch * i));
                }
            }
        }

        verties.Sort(CompareVert);
        vertCount = verties.Count;
    }

    /// <summary>
    /// 网格UV对齐。
    /// </summary>
    private void SetUVs()
    {
        uvs = new List<Vector2>();
        verties.ForEach(Vert2UV);
    }

    /// <summary>
    /// 多边形绘制顺序。
    /// </summary>
    /// <param name="vertCountInColumn">每列顶点数。</param>
    private void SetTriangles(int[] vertCountInColumn)
    {
        tris = new List<int>();

        for (int col = 0, vid = 0, n = vertCountInColumn.Length; col < n - 1; col++)
        {
            if (col < n / 2)//在左半区时
            {
                for (int i = 0; i < vertCountInColumn[col]; i++, vid++)
                {
                    //有右侧上方点
                    tris.Add(vid);//当前点
                    tris.Add(vid + vertCountInColumn[col] + 1);//右列上方点
                    tris.Add(vid + vertCountInColumn[col]);//右列同位点

                    if (i < vertCountInColumn[col] - 1)//非每列最高点时
                    {
                        tris.Add(vid);//当前点
                        tris.Add(vid + 1);//上方点
                        tris.Add(vid + vertCountInColumn[col] + 1);//右列上方点
                    }
                }
            }
            else
            {
                for (int i = 0; i < vertCountInColumn[col]; i++, vid++)
                {
                    if (i < vertCountInColumn[col] - 1)
                    {
                        if (i > 0)//右半区的最低点和最高点都不做右侧绘制
                        {
                            tris.Add(vid);//当前点
                            tris.Add(vid + vertCountInColumn[col]);//右列同位点
                            tris.Add(vid + vertCountInColumn[col] - 1);//右列下方点
                        }

                        tris.Add(vid);//当前点
                        tris.Add(vid + 1);//上方点
                        tris.Add(vid + vertCountInColumn[col]);//右列同位点
                    }
                }
            }
        }
    }
   
    /// <summary>
    /// 更新网格点的高度。
    /// </summary>
    /// <returns>网格需要重绘。</returns>
    private bool UpdateMeshVerties()
    {
        needUpdate = false;

        if (!GroundCollider)
        {
            GroundCollider = GameObject.FindObjectOfType<MeshCollider>();
            if (!GroundCollider)
                return false; 
        }

        for (int i = 0; i < vertCount; i++)
        {
            vertWorldPos = transform.TransformPoint(verties[i]);
            vertWorldPos.y = GroundCollider.bounds.max.y;
            ray.origin = vertWorldPos;
            ray.direction = Vector3.down;

            if (GroundCollider.Raycast(ray, out hit, GroundCollider.bounds.size.y))
            {
                vertWorldPos.y = hit.point.y + Suspend;
                verties[i] = transform.InverseTransformPoint(vertWorldPos);
                needUpdate = true;
            }
        }

        return needUpdate;
    }

    private static int CompareVert(Vector3 a, Vector3 b)
    {
        int comp = a.x.CompareTo(b.x);
        if (comp == 0)
            comp = a.z.CompareTo(b.z);
        return comp;
    }

    private void Vert2UV(Vector3 v)
    {
        uvs.Add((new Vector2((v.x + Radius), v.z + Radius)) / (2 * Radius));
    }
}

