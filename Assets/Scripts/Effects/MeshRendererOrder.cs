using UnityEngine;
#if UNITY_EDITOR
using UnityEditor;

[ExecuteInEditMode]
#endif
[RequireComponent(typeof(MeshRenderer))]
public class MeshRendererOrder : MonoBehaviour {

    private Renderer _renderer;
    public int sortOrder = 0;

    private void Awake()
    {
        _renderer = gameObject.GetComponent<MeshRenderer>();
    }

    private void OnEnable()
    {
        _renderer.sortingOrder = sortOrder;
    }
}
