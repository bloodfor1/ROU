using System.Collections;
using System.Collections.Generic;
using UnityEngine;

#if UNITY_EDITOR

using UnityEditor;
[CustomEditor(typeof(ClimbMesh))]
public class ClimbMeshEditor : Editor
{
    ClimbMesh _target;

    private static string path = "Assets/artres/_GameRes/Scenes/Common/Climb/";

    public override void OnInspectorGUI()
    {
        _target = target as ClimbMesh;

        base.OnInspectorGUI();

        using(var c = new EditorGUI.ChangeCheckScope())
        {
            var scale = EditorGUILayout.Vector3Field("宽，高，深", _target.Scale);
            if (c.changed)
            {
                Undo.RecordObject(target, "修改宽高");
                _target.Scale = scale;
                EditorUtility.SetDirty(target);
            }
        }

        if (_target.Mesh && string.IsNullOrEmpty(AssetDatabase.GetAssetPath(_target.Mesh)) && GUILayout.Button("导出"))
        {
            if (!System.IO.Directory.Exists(path))
            {
                System.IO.Directory.CreateDirectory(path);
            }
            AssetDatabase.CreateAsset(_target.Mesh, path + _target.Mesh.name + "_" + (uint)_target.Mesh.GetHashCode() + ".asset");
            AssetDatabase.Refresh();
        }
    }
}

#endif

[RequireComponent(typeof(MeshFilter))]
public class ClimbMesh : MonoBehaviour
{
#if UNITY_EDITOR
    [MenuItem("GameObject/Climbing Zone", false, 10)]
    static void CreateObject()
    {
        var go = new GameObject("Climbing Zone");
        go.AddComponent<ClimbMesh>();
        go.transform.position = SceneView.lastActiveSceneView.pivot;
    }
#endif
    private static float _moveDis = 0.7f;
    private static float _manH = 2;

    private Vector3 _scale = new Vector3(4, 4, 0.5f);
    public Vector3 Scale {

        get
        {
            return _scale;            
        }

        set
        {
            _scale = value;

            UpdateMesh();
        }
    }

    [SerializeField]
    private Mesh _mesh;
    public Mesh Mesh
    {
        get
        {
            return _mesh;
        }
    }

    private void UpdateMesh()
    {
        List<Vector3> vts = new List<Vector3>();

        if (_mesh == null || !_mesh.isReadable || _mesh.vertexCount != 10)
        {
            _mesh = new Mesh()
            {
                name = this.name
            };

            _mesh.MarkDynamic();
            AddVert(vts);
            List<int> trgs = new List<int>();
            for (int i = 0; i + 2 < vts.Count; i++)
            {
                if (i % 2 == 1)
                {
                    trgs.Add(i);
                    trgs.Add(i + 1);
                    trgs.Add(i + 2);
                }
                else
                {
                    trgs.Add(i + 2);
                    trgs.Add(i + 1);
                    trgs.Add(i);
                }
            }
            _mesh.SetVertices(vts);
            _mesh.SetTriangles(trgs.ToArray(), 0);
            _mesh.tangents = null;
            _mesh.uv = null;
            _mesh.colors = null;
            _mesh.uv2 = null;
            _mesh.uv3 = null;
            _mesh.uv4 = null;
            _mesh.boneWeights = null;
            _mesh.bindposes = null;

            if (!GetComponent<MeshRenderer>())
                gameObject.AddComponent<MeshRenderer>();
        }
        else
        {
            AddVert(vts);
            _mesh.SetVertices(vts);
        }

        GetComponent<MeshFilter>().sharedMesh = _mesh;

#if UNITY_EDITOR
        if (AssetDatabase.GetAssetPath(_mesh) != null)
        {
            EditorUtility.SetDirty(_mesh);
        }
#endif
    }

    private void AddVert(List<Vector3> vts)
    {
        vts.Add(new Vector3(-Scale.x * 0.5f, 0, -_moveDis));
        vts.Add(new Vector3( Scale.x * 0.5f, 0, -_moveDis));
        vts.Add(new Vector3(-Scale.x * 0.5f, 0, 0));
        vts.Add(new Vector3( Scale.x * 0.5f, 0, 0));

        float angle = Mathf.Atan2(Scale.y, Scale.z);
        float cosV = Mathf.Cos(angle);
        float sinV = Mathf.Sin(angle);
        float slopProj = cosV * _manH;
        float sz = Scale.z - slopProj;
        float sy = Scale.y - sinV * _manH;

        vts.Add(new Vector3(-Scale.x * 0.5f, sy, sz));
        vts.Add(new Vector3( Scale.x * 0.5f, sy, sz));
        vts.Add(new Vector3(-Scale.x * 0.5f, Scale.y, Scale.z));
        vts.Add(new Vector3( Scale.x * 0.5f, Scale.y, Scale.z));
        vts.Add(new Vector3(-Scale.x * 0.5f, Scale.y, Scale.z + _moveDis));
        vts.Add(new Vector3( Scale.x * 0.5f, Scale.y, Scale.z + _moveDis));
    }
}
