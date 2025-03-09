using UnityEngine;
using UnityEngine.UI;
using System.Collections;
using System.Collections.Generic;
using UnityEngine.Serialization;

#if UNITY_EDITOR

using UnityEditor;

[CustomEditor(typeof(UIMesh))]
public class UIMeshEditor : Editor
{
    UIMesh mTarget;

    private void OnEnable()
    {
        mTarget = target as UIMesh;
    }

    public override void OnInspectorGUI()
    {
        SetField(t => mTarget.texture = (Texture)t, () => EditorGUILayout.ObjectField("Texture", mTarget.texture, typeof(Texture), true));
        SetField(mTarget.SetColor, () => EditorGUILayout.ColorField("Color", mTarget.color));
        SetField(t => mTarget.material = t, () => (Material)EditorGUILayout.ObjectField("Material", mTarget.material, typeof(Material), true));
        SetField(t => mTarget.mesh = t, () => (Mesh)EditorGUILayout.ObjectField("Mesh", mTarget.mesh, typeof(Mesh), true));
        SetField(t => mTarget.raycastTarget = t, () => EditorGUILayout.Toggle("Raycast Target", mTarget.raycastTarget));
        SetField(t => mTarget.uvRect = t, () => (Rect)EditorGUILayout.RectField("UV Rect", mTarget.uvRect));
    }

    void SetField<T>(System.Action<T> value, System.Func<T> func, string undoTip = null)
    {
        EditorGUI.BeginChangeCheck();
        T result = func();
        if (EditorGUI.EndChangeCheck())
        {
            Undo.RecordObject(mTarget, undoTip == null ? "Field Change" : undoTip);
            value(result);
            EditorUtility.SetDirty(mTarget);
        }
    }

    [MenuItem("GameObject/UI/Mesh Image", false, 0)]
    public static void CreateUIMesh()
    {
        GameObject meshImage = new GameObject("MeshImage", typeof(RectTransform), typeof(CanvasRenderer), typeof(UIMesh));
        if (Selection.activeGameObject)
        {
            meshImage.transform.SetParent(Selection.activeGameObject.transform, false);
        }
    }
}

#endif

[RequireComponent(typeof(CanvasRenderer))]
[AddComponentMenu("UI/UI Mesh", 12)]
public class UIMesh : MaskableGraphic
{
    [SerializeField]
    Mesh m_Mesh;
    [FormerlySerializedAs("m_Tex")]
    [SerializeField]
    Texture m_Texture;
    [SerializeField]
    Rect m_UVRect = new Rect(0f, 0f, 1f, 1f);

    protected UIMesh()
    {
        useLegacyMeshGeneration = false;
    }

    public Mesh mesh
    {
        get
        {
            return m_Mesh;
        }

        set
        {
            if (m_Mesh == value)
                return;

            m_Mesh = value;
            SetVerticesDirty();
        }
    }

    public override Texture mainTexture
    {
        get
        {
            if (m_Texture == null)
            {
                if (material != null && material.mainTexture != null)
                {
                    return material.mainTexture;
                }
                return s_WhiteTexture;
            }

            return m_Texture;
        }
    }

    public Texture texture
    {
        get
        {
            return m_Texture;
        }
        set
        {
            if (m_Texture == value)
                return;

            m_Texture = value;
            SetVerticesDirty();
            SetMaterialDirty();
        }
    }

    public Rect uvRect
    {
        get
        {
            return m_UVRect;
        }
        set
        {
            if (m_UVRect == value)
                return;
            m_UVRect = value;
            SetVerticesDirty();
        }
    }

    public override void SetNativeSize()
    {
        Texture tex = mainTexture;
        if (tex != null)
        {
            int w = Mathf.RoundToInt(tex.width * uvRect.width);
            int h = Mathf.RoundToInt(tex.height * uvRect.height);
            rectTransform.anchorMax = rectTransform.anchorMin;
            rectTransform.sizeDelta = new Vector2(w, h);
        }
    }

    protected override void OnPopulateMesh(VertexHelper vh)
    {
        Texture tex = mainTexture;
        vh.Clear();
        if (tex != null)
        {
            var color32 = color;
            if (canvas && mesh && mesh.isReadable)
            {
                Vector3[] verts = mesh.vertices;
                Vector2[] uvs = mesh.uv;
                int[] triangles = mesh.triangles;
                Vector3 vert;
                Vector2 uv;
                for (int i = 0, n = mesh.vertexCount; i < n; i++)
                {
                    vert = verts[i];
                    uv = uvs[i];
                    vh.AddVert(new Vector3(vert.x, vert.y), color32, new Vector2(uv.x, uv.y));
                }

                for (int i = 0, n = triangles.Length; i < n; i = i + 3)
                {
                    vh.AddTriangle(triangles[i], triangles[i + 1], triangles[i + 2]);
                }
            }
            else
            {
                var r = GetPixelAdjustedRect();
                var v = new Vector4(r.x, r.y, r.x + r.width, r.y + r.height);
                vh.AddVert(new Vector3(v.x, v.y), color32, new Vector2(m_UVRect.xMin, m_UVRect.yMin));
                vh.AddVert(new Vector3(v.x, v.w), color32, new Vector2(m_UVRect.xMin, m_UVRect.yMax));
                vh.AddVert(new Vector3(v.z, v.w), color32, new Vector2(m_UVRect.xMax, m_UVRect.yMax));
                vh.AddVert(new Vector3(v.z, v.y), color32, new Vector2(m_UVRect.xMax, m_UVRect.yMin));

                vh.AddTriangle(0, 1, 2);
                vh.AddTriangle(2, 3, 0);
            }
        }
    }

    public void SetColor(Color color)
    {
        this.color = color;
    }

    public void SetUV(string propertyName, Vector4 uv)
    {
        if (material)
        {
            material.SetVector(propertyName, uv);
        }
    }

    public void SetValue(string propertyName, float v)
    {
        if (material)
        {
            material.SetFloat(propertyName, v);
        }
    }
}
